/// Local, build-time feature flags.
///
/// These flags are intentionally shipped INSIDE the app binary (not fetched
/// from the backend). Toggling a feature here and releasing a new build means
/// the reviewed binary always matches the shipped behavior — avoiding the
/// "hidden/dormant feature" problem that comes with remote-toggled flags.
///
/// To enable or disable a module: flip the `true`/`false` value below and ship
/// a new build. Keys must match the [AppFeatures] model.
const Map<String, dynamic> kAppFeaturesConfig = {
  "auth": {
    "emailAuth": true,
    "socialAuth": true,
    "multiChannelOtp": true,
    "tfa": true,
    "passwordManagement": true,
  },
  "trainer": {
    "trainerLinking": true,
    "trainerDiscovery": true,
    "trainerProfiles": true,
    "trainerUnlinking": true,
  },
  "workouts": {
    "workoutProgress": false,
    "exerciseLibrary": false,
    "activeWorkoutLogging": false,
    "workoutManuals": false,
    "sessionLogs": false,
  },
  "bookings": {
    "sessionScheduling": false,
    "sessionManagement": false,
    "sessionSummaries": false,
    "ratingFeedback": false,
  },
  "finance": {
    "subscriptionOffers": false,
    "payments": false,
    "paymentHistory": false,
  },
  "support": {"supportTickets": true, "faqSystem": true, "notifications": true},
  "profile": {"profileCustomization": true, "accountPrivacy": true},
  "home": {"whatsapp": true},
};
