import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tailor_app/core/constants/app_constants.dart';
import 'package:tailor_app/data/models/order_model.dart';
import 'package:tailor_app/data/models/review_model.dart';
import 'package:tailor_app/data/models/user_model.dart';
import 'package:tailor_app/data/models/measurement_profile_model.dart';

/// Central Firestore service for users, orders, reviews, and measurement profiles.
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ---------- Users ----------
  Future<UserModel?> getUser(String uid) async {
    final doc = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data()!, doc.id);
  }

  Stream<List<UserModel>> streamTailors({String? searchName, bool? available}) {
    Query<Map<String, dynamic>> q = _firestore
        .collection(AppConstants.usersCollection)
        .where('role', isEqualTo: AppConstants.roleTailor);
    if (available != null) {
      q = q.where('isAvailable', isEqualTo: available);
    }
    return q.snapshots().map((snap) {
      return snap.docs
          .map((d) => UserModel.fromMap(d.data(), d.id))
          .where((u) =>
              searchName == null ||
              u.name.toLowerCase().contains(searchName.toLowerCase()))
          .toList();
    });
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .update(data);
  }

  // ---------- Orders ----------
  Future<String> createOrder(OrderModel order) async {
    final ref = await _firestore
        .collection(AppConstants.ordersCollection)
        .add(order.toMap());
    return ref.id;
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    await _firestore
        .collection(AppConstants.ordersCollection)
        .doc(orderId)
        .update({'status': status});
  }

  Future<void> acceptOrder(String orderId, double? price) async {
    await _firestore.collection(AppConstants.ordersCollection).doc(orderId).update({
      'status': AppConstants.statusAccepted,
      if (price != null) 'price': price,
    });
  }

  Future<void> rejectOrder(String orderId) async {
    await _firestore
        .collection(AppConstants.ordersCollection)
        .doc(orderId)
        .update({'status': AppConstants.statusRejected});
  }

  Stream<List<OrderModel>> streamOrdersByCustomer(String customerId) {
    return _firestore
        .collection(AppConstants.ordersCollection)
        .where('customerId', isEqualTo: customerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => OrderModel.fromMap(d.data(), d.id)).toList());
  }

  Stream<List<OrderModel>> streamOrdersByTailor(String tailorId) {
    return _firestore
        .collection(AppConstants.ordersCollection)
        .where('tailorId', isEqualTo: tailorId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => OrderModel.fromMap(d.data(), d.id)).toList());
  }

  Future<OrderModel?> getOrder(String orderId) async {
    final doc = await _firestore
        .collection(AppConstants.ordersCollection)
        .doc(orderId)
        .get();
    if (!doc.exists) return null;
    return OrderModel.fromMap(doc.data()!, doc.id);
  }

  // ---------- Reviews ----------
  Future<void> addReview(ReviewModel review) async {
    await _firestore
        .collection(AppConstants.reviewsCollection)
        .doc(review.id)
        .set(review.toMap());
  }

  Stream<List<ReviewModel>> streamReviewsForTailor(String tailorId) {
    return _firestore
        .collection(AppConstants.reviewsCollection)
        .where('tailorId', isEqualTo: tailorId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => ReviewModel.fromMap(d.data(), d.id)).toList());
  }

  // ---------- Measurement profiles (stored under users/{uid}/measurement_profiles) ----------
  Future<void> saveMeasurementProfile(MeasurementProfileModel profile) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(profile.userId)
        .collection('measurement_profiles')
        .doc(profile.id)
        .set(profile.toMap());
  }

  Stream<List<MeasurementProfileModel>> streamMeasurementProfiles(
      String userId) {
    return _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .collection('measurement_profiles')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => MeasurementProfileModel.fromMap(d.data(), d.id))
            .toList());
  }
}
