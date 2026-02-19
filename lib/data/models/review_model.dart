import 'package:cloud_firestore/cloud_firestore.dart';

/// Review model matching Firestore [reviews] collection.
class ReviewModel {
  final String id;
  final String customerId;
  final String tailorId;
  final int rating;
  final String? comment;
  final DateTime createdAt;

  const ReviewModel({
    required this.id,
    required this.customerId,
    required this.tailorId,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> map, String id) {
    DateTime createdAt = DateTime.now();
    final raw = map['createdAt'];
    if (raw != null) {
      if (raw is Timestamp) createdAt = raw.toDate();
      if (raw is DateTime) createdAt = raw;
    }
    return ReviewModel(
      id: id,
      customerId: map['customerId'] as String? ?? '',
      tailorId: map['tailorId'] as String? ?? '',
      rating: (map['rating'] as num?)?.toInt() ?? 0,
      comment: map['comment'] as String?,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'tailorId': tailorId,
      'rating': rating,
      'comment': comment,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
