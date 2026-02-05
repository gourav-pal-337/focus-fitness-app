/// API endpoints configuration
class Endpoints {
  // TODO: Update baseUrl with actual API base URL
  static const String baseUrl =
      'https://focus-fusion-api.applore.in/api/mobile'; //sahil de
  //    'http://localhost:4000/api/mobile';
  //    'https://gmrwk6wb-4000.inc1.devtunnels.ms/api/mobile';
  // 'https://sl5n9v1k-4000.inc1.devtunnels.ms/api/mobile'; //sahil dev

  static const String uploadFile = '/upload';

  // Auth endpoints
  static const String registerEmail = '/auth/register-email';
  static const String loginEmail = '/auth/login-email';
  static const String firebaseLogin = '/auth/firebase-login';
  static const String getUserDetails = '/auth/get-user-details';
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String forgotPassword = '/auth/password/forgot';
  static const String resetPassword = '/auth/password/reset';

  // Client profile endpoints
  static const String getClientProfile = '/client/profile';
  static const String updateClientProfile = '/client/profile';
  static const String deleteAccount = '/client/profile';

  // Trainer endpoints
  static const String getTrainerByReferralCode = '/trainer/referral';
  static const String searchTrainer = '/auth/search-trainer';
  static const String linkTrainer = '/trainer/link';
  static const String getLinkedTrainer = '/trainer/linked';
  static const String unlinkTrainer = '/trainer/unlink';
  static const String getTrainerProfile = '/trainer';
  static const String bookSession = '/bookings';

  // Booking endpoints
  static const String getClientBookings = '/bookings';
  static String getSessionSummary(String bookingId) =>
      '/bookings/$bookingId/summary';
  static String rateSession(String bookingId) => '/bookings/$bookingId/rate';
  static String cancelBooking(String bookingId) =>
      '/bookings/$bookingId/cancel';

  // Notification endpoints
  static const String fcmToken = '/notifications/fcm-token';
  static const String notifications = '/notifications';
}
