/// App-wide constants.
class AppConstants {
  AppConstants._();

  // Firestore collections
  static const String usersCollection = 'users';
  static const String ordersCollection = 'orders';
  static const String reviewsCollection = 'reviews';
  static const String messagesCollection = 'messages';
  static const String chatsCollection = 'chats';

  // User roles
  static const String roleCustomer = 'customer';
  static const String roleTailor = 'tailor';

  // Order statuses
  static const String statusPending = 'Pending';
  static const String statusAccepted = 'Accepted';
  static const String statusRejected = 'Rejected';
  static const String statusMeasuring = 'Measuring';
  static const String statusCutting = 'Cutting';
  static const String statusStitching = 'Stitching';
  static const String statusFinishing = 'Finishing';
  static const String statusReady = 'Ready';

  static const List<String> orderStatusList = [
    statusPending,
    statusAccepted,
    statusRejected,
    statusMeasuring,
    statusCutting,
    statusStitching,
    statusFinishing,
    statusReady,
  ];

  // Dress types (extend as needed)
  static const List<String> dressTypes = [
    'Shirt',
    'Trousers',
    'Suit',
    'Blouse',
    'Dress',
    'Coat',
    'Skirt',
    'Other',
  ];
}
