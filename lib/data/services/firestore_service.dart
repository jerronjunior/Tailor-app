import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tailor_app/core/constants/app_constants.dart';
import 'package:tailor_app/data/models/order_model.dart';
import 'package:tailor_app/data/models/review_model.dart';
import 'package:tailor_app/data/models/user_model.dart';
import 'package:tailor_app/data/models/measurement_profile_model.dart';

/// Firestore-backed data service for users, orders, reviews, and measurement profiles.
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  CollectionReference<Map<String, dynamic>> get _orders =>
      _firestore.collection('orders');

  CollectionReference<Map<String, dynamic>> get _reviews =>
      _firestore.collection('reviews');

  // ---------- Users ----------
  Future<UserModel?> getUser(String uid) async {
    final snapshot = await _users.doc(uid).get();
    if (!snapshot.exists || snapshot.data() == null) return null;
    return UserModel.fromMap(snapshot.data()!, snapshot.id);
  }

  Stream<List<UserModel>> streamTailors({String? searchName, bool? available}) {
    Query<Map<String, dynamic>> query = _users.where(
      'role',
      isEqualTo: AppConstants.roleTailor,
    );

    if (available != null) {
      query = query.where('isAvailable', isEqualTo: available);
    }

    return query.snapshots().map((snapshot) {
      var list = snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data(), doc.id))
          .toList();

      final search = searchName?.trim().toLowerCase();
      if (search != null && search.isNotEmpty) {
        list = list
            .where((user) => user.name.toLowerCase().contains(search))
            .toList();
      }

      list.sort((a, b) => a.name.compareTo(b.name));
      return list;
    });
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _users.doc(uid).update(data);
  }

  // ---------- Orders ----------
  Future<String> createOrder(OrderModel order) async {
    if (order.id.isNotEmpty) {
      await _orders.doc(order.id).set(order.toMap());
      return order.id;
    }

    final doc = await _orders.add(order.toMap());
    return doc.id;
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    await _orders.doc(orderId).update({'status': status});
  }

  Future<void> acceptOrder(String orderId, double? price) async {
    await _orders.doc(orderId).update({
      'status': AppConstants.statusAccepted,
      if (price != null) 'price': price,
    });
  }

  Future<void> rejectOrder(String orderId) async {
    await _orders
        .doc(orderId)
        .update({'status': AppConstants.statusRejected});
  }

  Stream<List<OrderModel>> streamOrdersByCustomer(String customerId) {
    return _orders
        .where('customerId', isEqualTo: customerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => OrderModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Stream<List<OrderModel>> streamOrdersByTailor(String tailorId) {
    return _orders
        .where('tailorId', isEqualTo: tailorId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => OrderModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Future<OrderModel?> getOrder(String orderId) async {
    final snapshot = await _orders.doc(orderId).get();
    if (!snapshot.exists || snapshot.data() == null) return null;
    return OrderModel.fromMap(snapshot.data()!, snapshot.id);
  }

  // ---------- Reviews ----------
  Future<void> addReview(ReviewModel review) async {
    if (review.id.isNotEmpty) {
      await _reviews.doc(review.id).set(review.toMap());
      return;
    }
    await _reviews.add(review.toMap());
  }

  Stream<List<ReviewModel>> streamReviewsForTailor(String tailorId) {
    return _reviews
        .where('tailorId', isEqualTo: tailorId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ReviewModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // ---------- Measurement profiles (stored under users/{uid}/measurement_profiles) ----------
  Future<void> saveMeasurementProfile(MeasurementProfileModel profile) async {
    final collection =
        _users.doc(profile.userId).collection('measurement_profiles');
    if (profile.id.isNotEmpty) {
      await collection.doc(profile.id).set(profile.toMap());
      return;
    }
    await collection.add(profile.toMap());
  }

  Stream<List<MeasurementProfileModel>> streamMeasurementProfiles(String userId) {
    return _users
        .doc(userId)
        .collection('measurement_profiles')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MeasurementProfileModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }
}
