import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tailor_app/core/constants/app_constants.dart';

/// User model matching Firestore [users] collection.
class UserModel {
  final String id;
  final String name;
  final String email;
  final String role; // customer | tailor
  final String? phone;
  final String? profileImage;
  final DateTime createdAt;
  final bool? isAvailable; // for tailors only

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.profileImage,
    required this.createdAt,
    this.isAvailable,
  });

  bool get isCustomer => role == AppConstants.roleCustomer;
  bool get isTailor => role == AppConstants.roleTailor;

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    DateTime createdAt = DateTime.now();
    final raw = map['createdAt'];
    if (raw != null) {
      if (raw is Timestamp) createdAt = raw.toDate();
      if (raw is DateTime) createdAt = raw;
    }
    return UserModel(
      id: id,
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      role: map['role'] as String? ?? AppConstants.roleCustomer,
      phone: map['phone'] as String?,
      profileImage: map['profileImage'] as String?,
      createdAt: createdAt,
      isAvailable: map['isAvailable'] as bool?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'phone': phone,
      'profileImage': profileImage,
      'createdAt': createdAt,
      if (isAvailable != null) 'isAvailable': isAvailable,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? phone,
    String? profileImage,
    DateTime? createdAt,
    bool? isAvailable,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
