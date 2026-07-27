class Endpoints {
  static const String prodUrl = "https://api.focusfusion.co.uk/api/mobile";
  static const String stageUrl =
      "https://api-stage.focusfusion.co.uk/api/mobile";
  static const String devUrl = "https://focus-fusion-api.applore.in/api/mobile";
  static const String localUrl =
      //  "http://localhost:4000/api/mobile";
      'https://ln90vztc-4000.inc1.devtunnels.ms/api/mobile'; //gourav dev

  // TODO IMPORTANT!!!: always check baseUrl before deployment
  static const String baseUrl = devUrl;
  static const String uploadFile = '/uploads';
  // Auth endpoints
  static const String registerEmail = '/auth/register-email';
  static const String loginEmail = '/auth/login-email';
  static const String firebaseLogin = '/auth/firebase-login';
  static const String getUserDetails = '/auth/get-user-details';
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String forgotPassword = '/auth/password/forgot';
  static const String resetPassword = '/auth/passwRord/reset';
  static const String sendTfaOtp = '/auth/tfa/send-otp';
  static const String verifyTfa = '/auth/tfa/verify';
  static const String disableTfa = '/auth/tfa';
  static const String refreshToken = '/auth/refresh-token';
  static const String checkUser = '/auth/check-user';
  static const String whatsappRedirectNumber = '/auth/whatsapp-redirect-number';

  // Client profile endpoints
  static const String getClientProfile = '/client/profile';
  static const String updateClientProfile = '/client/profile';
  static const String deleteAccount = '/client/profile';

  // Trainer endpoints
  static const String getTrainerByReferralCode = '/trainer/referral';
  static const String searchTrainer = '/auth/search-trainer';
  static const String allTrainers = '/auth/all-trainers';
  static const String linkTrainer = '/trainer/link';
  static const String getLinkedTrainer = '/trainer/linked';
  static const String unlinkTrainer = '/trainer/unlink';
  static const String getTrainerProfile = '/trainer';
  static const String bookSession = '/bookings';
  static const String initiatePayment = '/bookings/payment/initiate';
  static const String confirmPayment = '/bookings/payment/confirm';
  static String getBookingByPaymentIntent(String paymentIntentId) =>
      '/bookings/payment/intent?paymentIntentId=$paymentIntentId';
  static String checkTrainerBooking(String trainerId) =>
      '/bookings/trainer/$trainerId/check-booking';
  static String getNextAvailableSlot(String trainerId) =>
      '/trainer/$trainerId/next-available-slot';

  static String updatePaymentStatus(String bookingId) =>
      '/finance/bookings/$bookingId/payment-status';

  static const String getPendingCompletionBookings =
      '/bookings/pending-completion';
  static String updateBookingStatus(String bookingId) =>
      '/bookings/$bookingId/status';

  static String completeBooking(String bookingId) =>
      '/bookings/$bookingId/complete';

  // Booking endpoints
  static const String getClientBookings = '/bookings';
  static String getSessionSummary(String bookingId) =>
      '/bookings/$bookingId/summary';
  static String rateSession(String bookingId) => '/bookings/$bookingId/rate';
  static String cancelBooking(String bookingId) =>
      '/bookings/$bookingId/cancel';
  static String getBookingPayment(String bookingId) =>
      '/bookings/$bookingId/payment';
  static String rescheduleAvailability(String bookingId) =>
      '/bookings/$bookingId/reschedule-availability';
  static String rescheduleBooking(String bookingId) =>
      '/bookings/$bookingId/reschedule';

  // System Settings endpoints
  static const String systemSettings = '/system-settings';
  static const String feeSettings = '/system-settings/fees';
  static const String appFeatures = '/system-settings/app-features';

  // Notification endpoints
  static const String fcmToken = '/notifications/fcm-token';
  static const String notifications = '/notifications';

  // Support endpoints
  static const String getFaqs = '/support/faqs';
  static const String createTicket = '/support/tickets';
  static const String getTickets = '/support/tickets';

  // Subscription endpoints
  static String getSubscriptionOffers(String trainerId) =>
      '/subscriptions/offers/$trainerId';
  static const String subscriptionCheckout = '/subscriptions/checkout-sheet';
  static String getPrivacy(String type) => '/public/privacy/$type';

  // Workout endpoints
  static const String workoutProgress = '/workouts/progress';
  static const String workoutSaveSet = '/workouts/save-set';
  static const String workoutSaveDay = '/workouts/save-day';
  static const String exercises = '/exercises';
  static const String exerciseCategories = '/exercises/categories';
  static const String workoutManuals = '/workouts/manuals';
  static const String getTodayWorkoutSummary = '/workouts/today-summary';
  static const String getWeeklyProgress = '/workouts/weekly-progress';
}
