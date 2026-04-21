import 'package:tailor_app/core/constants/app_constants.dart';
import 'package:tailor_app/data/models/order_model.dart';
import 'package:tailor_app/data/models/review_model.dart';
import 'package:tailor_app/data/models/user_model.dart';
import 'package:tailor_app/data/models/measurement_profile_model.dart';
import 'package:tailor_app/data/services/local_app_store.dart';

/// Local in-memory data service for users, orders, reviews, and measurement profiles.
class FirestoreService {
  final LocalAppStore _store = LocalAppStore.instance;

  // ---------- Users ----------
  Future<UserModel?> getUser(String uid) async {
    return _store.getUser(uid);
  }

  Stream<List<UserModel>> streamTailors({String? searchName, bool? available}) {
    List<UserModel> current() => _store.tailors(searchName: searchName, available: available);
    return Stream<List<UserModel>>.multi((controller) {
      controller.add(current());
      final sub = _store.changes.listen((_) => controller.add(current()));
      controller.onCancel = sub.cancel;
    });
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _store.updateUser(uid, data);
  }

  // ---------- Orders ----------
  Future<String> createOrder(OrderModel order) async {
    return _store.createOrder(order);
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    _store.updateOrderStatus(orderId, status);
  }

  Future<void> acceptOrder(String orderId, double? price) async {
    _store.acceptOrder(orderId, price);
  }

  Future<void> rejectOrder(String orderId) async {
    _store.rejectOrder(orderId);
  }

  Stream<List<OrderModel>> streamOrdersByCustomer(String customerId) {
    List<OrderModel> current() => _store.ordersByCustomer(customerId);
    return Stream<List<OrderModel>>.multi((controller) {
      controller.add(current());
      final sub = _store.changes.listen((_) => controller.add(current()));
      controller.onCancel = sub.cancel;
    });
  }

  Stream<List<OrderModel>> streamOrdersByTailor(String tailorId) {
    List<OrderModel> current() => _store.ordersByTailor(tailorId);
    return Stream<List<OrderModel>>.multi((controller) {
      controller.add(current());
      final sub = _store.changes.listen((_) => controller.add(current()));
      controller.onCancel = sub.cancel;
    });
  }

  Future<OrderModel?> getOrder(String orderId) async {
    return _store.getOrder(orderId);
  }

  // ---------- Reviews ----------
  Future<void> addReview(ReviewModel review) async {
    _store.addReview(review);
  }

  Stream<List<ReviewModel>> streamReviewsForTailor(String tailorId) {
    List<ReviewModel> current() => _store.reviewsForTailor(tailorId);
    return Stream<List<ReviewModel>>.multi((controller) {
      controller.add(current());
      final sub = _store.changes.listen((_) => controller.add(current()));
      controller.onCancel = sub.cancel;
    });
  }

  // ---------- Measurement profiles (stored under users/{uid}/measurement_profiles) ----------
  Future<void> saveMeasurementProfile(MeasurementProfileModel profile) async {
    _store.saveMeasurementProfile(profile);
  }

  Stream<List<MeasurementProfileModel>> streamMeasurementProfiles(
      String userId) {
    List<MeasurementProfileModel> current() => _store.measurementProfilesForUser(userId);
    return Stream<List<MeasurementProfileModel>>.multi((controller) {
      controller.add(current());
      final sub = _store.changes.listen((_) => controller.add(current()));
      controller.onCancel = sub.cancel;
    });
  }
}
