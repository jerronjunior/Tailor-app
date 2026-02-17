import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tailor_app/core/constants/app_constants.dart';

/// Order model matching Firestore [orders] collection.
class OrderModel {
  final String id;
  final String customerId;
  final String tailorId;
  final String dressType;
  final String color;
  final Map<String, dynamic> measurements;
  final String? referenceImage;
  final DateTime deliveryDate;
  final String status;
  final double? price;
  final DateTime createdAt;

  const OrderModel({
    required this.id,
    required this.customerId,
    required this.tailorId,
    required this.dressType,
    required this.color,
    required this.measurements,
    this.referenceImage,
    required this.deliveryDate,
    required this.status,
    this.price,
    required this.createdAt,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    DateTime deliveryDate = DateTime.now();
    final rawDelivery = map['deliveryDate'];
    if (rawDelivery != null) {
      if (rawDelivery is Timestamp) deliveryDate = rawDelivery.toDate();
      if (rawDelivery is DateTime) deliveryDate = rawDelivery;
    }
    DateTime createdAt = DateTime.now();
    final rawCreated = map['createdAt'];
    if (rawCreated != null) {
      if (rawCreated is Timestamp) createdAt = rawCreated.toDate();
      if (rawCreated is DateTime) createdAt = rawCreated;
    }
    final measurements = map['measurements'];
    return OrderModel(
      id: id,
      customerId: map['customerId'] as String? ?? '',
      tailorId: map['tailorId'] as String? ?? '',
      dressType: map['dressType'] as String? ?? '',
      color: map['color'] as String? ?? '',
      measurements: measurements is Map<String, dynamic>
          ? Map<String, dynamic>.from(measurements)
          : {},
      referenceImage: map['referenceImage'] as String?,
      deliveryDate: deliveryDate,
      status: map['status'] as String? ?? AppConstants.statusPending,
      price: (map['price'] as num?)?.toDouble(),
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'tailorId': tailorId,
      'dressType': dressType,
      'color': color,
      'measurements': measurements,
      'referenceImage': referenceImage,
      'deliveryDate': Timestamp.fromDate(deliveryDate),
      'status': status,
      'price': price,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  OrderModel copyWith({
    String? id,
    String? customerId,
    String? tailorId,
    String? dressType,
    String? color,
    Map<String, dynamic>? measurements,
    String? referenceImage,
    DateTime? deliveryDate,
    String? status,
    double? price,
    DateTime? createdAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      tailorId: tailorId ?? this.tailorId,
      dressType: dressType ?? this.dressType,
      color: color ?? this.color,
      measurements: measurements ?? this.measurements,
      referenceImage: referenceImage ?? this.referenceImage,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      status: status ?? this.status,
      price: price ?? this.price,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
