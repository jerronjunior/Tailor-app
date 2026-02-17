import 'package:tailor_app/core/constants/app_constants.dart';
import 'package:tailor_app/data/models/order_model.dart';
import 'package:tailor_app/data/models/review_model.dart';
import 'package:tailor_app/data/models/user_model.dart';
import 'package:tailor_app/data/models/measurement_profile_model.dart';

/// Mock Firestore service - Firebase removed. Requires backend integration.
/// TODO: Replace with real backend API calls.
class FirestoreService {
  static final Map<String, UserModel> _mockUsers = {};
  static final Map<String, OrderModel> _mockOrders = {};
  static final Map<String, ReviewModel> _mockReviews = {};
  static final Map<String, List<MeasurementProfileModel>> _mockProfiles = {};

  // ---------- Users ----------
  Future<UserModel?> getUser(String uid) async {
    return _mockUsers[uid];
  }

  Stream<List<UserModel>> streamTailors({String? searchName, bool? available}) {
    return Stream.value(
      _mockUsers.values
          .where((u) => u.role == AppConstants.roleTailor)
          .where((u) => available == null || u.isAvailable == available)
          .where((u) =>
              searchName == null ||
              u.name.toLowerCase().contains(searchName.toLowerCase()))
          .toList(),
    );
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    final user = _mockUsers[uid];
    if (user != null) {
      _mockUsers[uid] = UserModel(
        id: user.id,
        name: data['name'] as String? ?? user.name,
        email: user.email,
        role: user.role,
        phone: data['phone'] as String? ?? user.phone,
        profileImage: data['profileImage'] as String? ?? user.profileImage,
        createdAt: user.createdAt,
        isAvailable: data['isAvailable'] as bool? ?? user.isAvailable,
      );
    }
  }

  // ---------- Orders ----------
  Future<String> createOrder(OrderModel order) async {
    final orderId = DateTime.now().millisecondsSinceEpoch.toString();
    _mockOrders[orderId] = order;
    return orderId;
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    final order = _mockOrders[orderId];
    if (order != null) {
      _mockOrders[orderId] = OrderModel(
        id: order.id,
        customerId: order.customerId,
        tailorId: order.tailorId,
        dressType: order.dressType,
        color: order.color,
        measurements: order.measurements,
        referenceImage: order.referenceImage,
        deliveryDate: order.deliveryDate,
        status: status,
        price: order.price,
        createdAt: order.createdAt,
      );
    }
  }

  Future<void> acceptOrder(String orderId, double? price) async {
    final order = _mockOrders[orderId];
    if (order != null) {
      _mockOrders[orderId] = OrderModel(
        id: order.id,
        customerId: order.customerId,
        tailorId: order.tailorId,
        dressType: order.dressType,
        color: order.color,
        measurements: order.measurements,
        referenceImage: order.referenceImage,
        deliveryDate: order.deliveryDate,
        status: AppConstants.statusAccepted,
        price: price ?? order.price,
        createdAt: order.createdAt,
      );
    }
  }

  Future<void> rejectOrder(String orderId) async {
    await updateOrderStatus(orderId, AppConstants.statusRejected);
  }

  Stream<List<OrderModel>> streamOrdersByCustomer(String customerId) {
    return Stream.value(
      _mockOrders.values
          .where((o) => o.customerId == customerId)
          .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
    );
  }

  Stream<List<OrderModel>> streamOrdersByTailor(String tailorId) {
    return Stream.value(
      _mockOrders.values
          .where((o) => o.tailorId == tailorId)
          .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
    );
  }

  Future<OrderModel?> getOrder(String orderId) async {
    return _mockOrders[orderId];
  }

  // ---------- Reviews ----------
  Future<void> addReview(ReviewModel review) async {
    _mockReviews[review.id] = review;
  }

  Stream<List<ReviewModel>> streamReviewsForTailor(String tailorId) {
    return Stream.value(
      _mockReviews.values
          .where((r) => r.tailorId == tailorId)
          .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
    );
  }

  // ---------- Measurement profiles ----------
  Future<void> saveMeasurementProfile(MeasurementProfileModel profile) async {
    _mockProfiles.putIfAbsent(profile.userId, () => []);
    final idx = _mockProfiles[profile.userId]!
        .indexWhere((p) => p.id == profile.id);
    if (idx >= 0) {
      _mockProfiles[profile.userId]![idx] = profile;
    } else {
      _mockProfiles[profile.userId]!.add(profile);
    }
  }

  Stream<List<MeasurementProfileModel>> streamMeasurementProfiles(
      String userId) {
    return Stream.value(
      (_mockProfiles[userId] ?? [])
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
    );
  }
}
