class Endpoints {
  // TODO: Update baseUrl with actual API base URL
  static const String baseUrl =
      // 'https://focus-fusion-api.applore.in/api/mobile'; // dev
      // 'http://localhost:4000/api/mobile';
      'https://martha-insightful-genevie.ngrok-free.dev/api/mobile'; //gourav dev
  // 'https://3p68r138-4000.inc1.devtunnels.ms/api/mobile'; //sahil dev

  static const String uploadFile = '/uploads';

  // Auth endpoints
  static const String registerEmail = '/auth/register-email';
  static const String loginEmail = '/auth/login-email';
  static const String firebaseLogin = '/auth/firebase-login';
  static const String getUserDetails = '/auth/get-user-details';
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String forgotPassword = '/auth/password/forgot';
  static const String resetPassword = '/auth/password/reset';
  static const String sendTfaOtp = '/auth/tfa/send-otp';
  static const String verifyTfa = '/auth/tfa/verify';
  static const String disableTfa = '/auth/tfa';

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
  static const String initiatePayment = '/bookings/payment/initiate';
  static const String confirmPayment = '/bookings/payment/confirm';
  static String getBookingByPaymentIntent(String paymentIntentId) =>
      '/bookings/payment/intent?paymentIntentId=$paymentIntentId';
  static String checkTrainerBooking(String trainerId) =>
      '/bookings/trainer/$trainerId/check-booking';

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
