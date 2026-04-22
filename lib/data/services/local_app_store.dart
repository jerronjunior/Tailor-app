import 'dart:async';

import 'package:tailor_app/core/constants/app_constants.dart';
import 'package:tailor_app/data/models/measurement_profile_model.dart';
import 'package:tailor_app/data/models/message_model.dart';
import 'package:tailor_app/data/models/order_model.dart';
import 'package:tailor_app/data/models/review_model.dart';
import 'package:tailor_app/data/models/user_model.dart';

class LocalAppStore {
  LocalAppStore._() {
    _seed();
  }

  static final LocalAppStore instance = LocalAppStore._();

  final StreamController<void> _changeController = StreamController<void>.broadcast();
  final StreamController<UserModel?> _authController = StreamController<UserModel?>.broadcast();

  final Map<String, _LocalAccount> _accounts = {};
  final Map<String, UserModel> _users = {};
  final Map<String, OrderModel> _orders = {};
  final Map<String, ReviewModel> _reviews = {};
  final Map<String, MeasurementProfileModel> _measurementProfiles = {};
  final Map<String, List<MessageModel>> _messagesByChat = {};

  String? _currentUserId;

  UserModel? get currentUser => _currentUserId == null ? null : _users[_currentUserId!];

  Stream<UserModel?> get authStateChanges => _authController.stream;

  void _emitChange() {
    if (!_changeController.isClosed) {
      _changeController.add(null);
    }
  }

  void _emitAuth() {
    if (!_authController.isClosed) {
      _authController.add(currentUser);
    }
  }

  void _seed() {
    if (_accounts.isNotEmpty) return;

    _createAccount(
      email: 'customer@example.com',
      password: 'password123',
      user: UserModel(
        id: 'customer-1',
        name: 'Demo Customer',
        email: 'customer@example.com',
        role: AppConstants.roleCustomer,
        phone: '555-0101',
        createdAt: DateTime.now().subtract(const Duration(days: 14)),
      ),
    );

    _createAccount(
      email: 'tailor@example.com',
      password: 'password123',
      user: UserModel(
        id: 'tailor-1',
        name: 'Ravi Kumar',
        email: 'tailor@example.com',
        role: AppConstants.roleTailor,
        phone: '555-0202',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        isAvailable: true,
      ),
    );

    final customer = _users['customer-1']!;
    final tailor = _users['tailor-1']!;

    final order1 = OrderModel(
      id: 'order-1',
      customerId: customer.id,
      tailorId: tailor.id,
      dressType: 'Suit',
      color: 'Navy Blue',
      measurements: {'chest': 38, 'waist': 32},
      deliveryDate: DateTime.now().add(const Duration(days: 9)),
      status: AppConstants.statusAccepted,
      price: 149.0,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    );

    final order2 = OrderModel(
      id: 'order-2',
      customerId: customer.id,
      tailorId: tailor.id,
      dressType: 'Kurta',
      color: 'White',
      measurements: {'length': 42, 'chest': 40},
      deliveryDate: DateTime.now().add(const Duration(days: 5)),
      status: AppConstants.statusPending,
      createdAt: DateTime.now().subtract(const Duration(hours: 20)),
    );

    _orders[order1.id] = order1;
    _orders[order2.id] = order2;

    final review = ReviewModel(
      id: 'review-1',
      customerId: customer.id,
      tailorId: tailor.id,
      rating: 5,
      comment: 'Excellent tailoring and quick delivery.',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    );
    _reviews[review.id] = review;

    final profile = MeasurementProfileModel(
      id: 'measurement-1',
      userId: customer.id,
      name: 'Default Shirt Size',
      measurements: {'chest': 38, 'waist': 32, 'sleeve': 24},
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    );
    _measurementProfiles[profile.id] = profile;
  }

  UserModel _createAccount({
    required String email,
    required String password,
    required UserModel user,
  }) {
    _accounts[email.toLowerCase()] = _LocalAccount(password: password, userId: user.id);
    _users[user.id] = user;
    return user;
  }

  UserModel register({
    required String email,
    required String password,
    required String name,
    required String role,
    String? phone,
  }) {
    final normalizedEmail = email.trim().toLowerCase();
    if (_accounts.containsKey(normalizedEmail)) {
      throw Exception('That email is already registered. Please log in instead.');
    }

    final user = UserModel(
      id: 'user-${DateTime.now().microsecondsSinceEpoch}',
      name: name,
      email: normalizedEmail,
      role: role,
      phone: phone,
      createdAt: DateTime.now(),
      isAvailable: role == AppConstants.roleTailor ? true : null,
    );

    _createAccount(email: normalizedEmail, password: password, user: user);
    _currentUserId = user.id;
    _emitAuth();
    _emitChange();
    return user;
  }

  UserModel signIn(String email, String password) {
    final normalizedEmail = email.trim().toLowerCase();
    final account = _accounts[normalizedEmail];
    if (account == null) {
      throw Exception('No account found for that email. Please register first.');
    }
    if (account.password != password) {
      throw Exception('Incorrect password. Please try again.');
    }

    final user = _users[account.userId];
    if (user == null) {
      throw Exception('Account data is missing. Please register again.');
    }

    _currentUserId = user.id;
    _emitAuth();
    return user;
  }

  void signOut() {
    _currentUserId = null;
    _emitAuth();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (!_accounts.containsKey(normalizedEmail)) {
      throw Exception('No account found for that email. Please register first.');
    }
  }

  UserModel? getUser(String uid) => _users[uid];

  UserModel? getCurrentUserProfile() => currentUser;

  Stream<UserModel?> get authChanges => _authController.stream;

  Stream<void> get changes => _changeController.stream;

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    final existing = _users[uid];
    if (existing == null) return;
    _users[uid] = existing.copyWith(
      name: data['name'] as String? ?? existing.name,
      email: data['email'] as String? ?? existing.email,
      role: data['role'] as String? ?? existing.role,
      phone: data['phone'] as String? ?? existing.phone,
      profileImage: data['profileImage'] as String? ?? existing.profileImage,
      isAvailable: data.containsKey('isAvailable') ? data['isAvailable'] as bool? : existing.isAvailable,
    );
    _emitChange();
  }

  List<UserModel> tailors({String? searchName, bool? available}) {
    final result = _users.values.where((user) {
      if (!user.isTailor) return false;
      if (available != null && user.isAvailable != available) return false;
      if (searchName != null && searchName.isNotEmpty) {
        return user.name.toLowerCase().contains(searchName.toLowerCase());
      }
      return true;
    }).toList();
    result.sort((a, b) => a.name.compareTo(b.name));
    return result;
  }

  List<OrderModel> ordersByCustomer(String customerId) {
    final result = _orders.values.where((order) => order.customerId == customerId).toList();
    result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return result;
  }

  List<OrderModel> ordersByTailor(String tailorId) {
    final result = _orders.values.where((order) => order.tailorId == tailorId).toList();
    result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return result;
  }

  OrderModel? getOrder(String orderId) => _orders[orderId];

  String createOrder(OrderModel order) {
    final id = order.id.isEmpty ? 'order-${DateTime.now().microsecondsSinceEpoch}' : order.id;
    _orders[id] = order.copyWith(id: id);
    _emitChange();
    return id;
  }

  void updateOrderStatus(String orderId, String status) {
    final existing = _orders[orderId];
    if (existing == null) return;
    _orders[orderId] = existing.copyWith(status: status);
    _emitChange();
  }

  void acceptOrder(String orderId, double? price) {
    final existing = _orders[orderId];
    if (existing == null) return;
    _orders[orderId] = existing.copyWith(
      status: AppConstants.statusAccepted,
      price: price ?? existing.price,
    );
    _emitChange();
  }

  void rejectOrder(String orderId) {
    final existing = _orders[orderId];
    if (existing == null) return;
    _orders[orderId] = existing.copyWith(status: AppConstants.statusRejected);
    _emitChange();
  }

  List<ReviewModel> reviewsForTailor(String tailorId) {
    final result = _reviews.values.where((review) => review.tailorId == tailorId).toList();
    result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return result;
  }

  void addReview(ReviewModel review) {
    _reviews[review.id] = review;
    _emitChange();
  }

  void saveMeasurementProfile(MeasurementProfileModel profile) {
    _measurementProfiles[profile.id] = profile;
    _emitChange();
  }

  List<MeasurementProfileModel> measurementProfilesForUser(String userId) {
    final result = _measurementProfiles.values.where((profile) => profile.userId == userId).toList();
    result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return result;
  }

  List<MessageModel> messagesForChat(String chatId) {
    final result = List<MessageModel>.from(_messagesByChat[chatId] ?? const <MessageModel>[]);
    result.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return result;
  }

  void sendMessage({
    required String chatId,
    required String senderId,
    required String text,
    String? imageUrl,
  }) {
    final messages = _messagesByChat.putIfAbsent(chatId, () => <MessageModel>[]);
    messages.add(
      MessageModel(
        id: 'message-${DateTime.now().microsecondsSinceEpoch}',
        chatId: chatId,
        senderId: senderId,
        message: text,
        imageUrl: imageUrl,
        timestamp: DateTime.now(),
      ),
    );
    _emitChange();
  }
}

class _LocalAccount {
  final String password;
  final String userId;

  const _LocalAccount({required this.password, required this.userId});
}