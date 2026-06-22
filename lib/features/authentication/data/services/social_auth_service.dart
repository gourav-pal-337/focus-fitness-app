import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Result of an Apple sign-in.
///
/// Apple's Authentication Services framework only returns the user's full name
/// and email on the *first* authorization. We capture them here so the rest of
/// the app never has to ask the user to re-enter information Apple already
/// provided (an App Store review requirement for Sign in with Apple).
class AppleSignInResult {
  AppleSignInResult({
    required this.userCredential,
    this.fullName,
    this.forename,
    this.surname,
    this.email,
  });

  final UserCredential userCredential;
  final String? fullName;
  final String? forename;
  final String? surname;
  final String? email;
}

class SocialAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User canceled

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  Future<AppleSignInResult?> signInWithApple() async {
    try {
      if (Platform.isIOS) {
        final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );

        final OAuthCredential credential = OAuthProvider('apple.com')
            .credential(
              idToken: appleCredential.identityToken,
              accessToken: appleCredential.authorizationCode,
            );

        // Raw values returned by Apple. givenName/familyName/email are only
        // non-null on the FIRST authorization for a given Apple ID.
        debugPrint(
          '[AppleSignIn] credential -> '
          'givenName: ${appleCredential.givenName}, '
          'familyName: ${appleCredential.familyName}, '
          'email: ${appleCredential.email}, '
          'userId: ${appleCredential.userIdentifier}',
        );

        final userCredential = await _auth.signInWithCredential(credential);

        // Apple only returns the full name on the *first* authorization, so we
        // build it from the credential here and persist it to the Firebase
        // user. On subsequent logins the name is read back from Firebase.
        final fullName = [
          appleCredential.givenName,
          appleCredential.familyName,
        ].where((part) => part != null && part.isNotEmpty).join(' ').trim();

        final user = userCredential.user;
        if (fullName.isNotEmpty &&
            (user?.displayName == null || user!.displayName!.isEmpty)) {
          await user?.updateDisplayName(fullName);
          await user?.reload();
          debugPrint(
            '[AppleSignIn] persisted displayName to Firebase: $fullName',
          );
        }

        final resolvedFullName = fullName.isNotEmpty
            ? fullName
            : userCredential.user?.displayName;
        final resolvedEmail = appleCredential.email ?? userCredential.user?.email;

        // Prefer the separate name parts Apple gives us. On repeat sign-ins
        // (where givenName/familyName are null) fall back to splitting the
        // stored full name: first word -> forename, the rest -> surname.
        final nameParts = (resolvedFullName ?? '')
            .split(' ')
            .where((p) => p.isNotEmpty)
            .toList();
        final resolvedForename = (appleCredential.givenName?.isNotEmpty ?? false)
            ? appleCredential.givenName
            : (nameParts.isNotEmpty ? nameParts.first : null);
        final resolvedSurname = (appleCredential.familyName?.isNotEmpty ?? false)
            ? appleCredential.familyName
            : (nameParts.length > 1 ? nameParts.skip(1).join(' ') : null);

        debugPrint(
          '[AppleSignIn] resolved -> '
          'fullName: $resolvedFullName, '
          'forename: $resolvedForename, '
          'surname: $resolvedSurname, '
          'email: $resolvedEmail, '
          'firebaseDisplayName: ${userCredential.user?.displayName}, '
          'firebaseEmail: ${userCredential.user?.email}',
        );

        return AppleSignInResult(
          userCredential: userCredential,
          // Prefer the freshly provided values, then fall back to whatever
          // Firebase already has stored from a previous sign-in.
          fullName: resolvedFullName,
          forename: resolvedForename,
          surname: resolvedSurname,
          email: resolvedEmail,
        );
      } else {
        throw Exception(
          'Apple Sign In is only supported on iOS in this implementation',
        );
      }
    } on SignInWithAppleAuthorizationException catch (e) {
      // User cancelled the Apple sign-in sheet — treat as a no-op, not an error.
      if (e.code == AuthorizationErrorCode.canceled) {
        return null;
      }
      throw Exception('Failed to sign in with Apple: ${e.message}');
    } catch (e) {
      throw Exception('Failed to sign in with Apple: $e');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
