/// Saved measurement profile for a customer (optional subcollection or separate collection).
class MeasurementProfileModel {
  final String id;
  final String userId;
  final String name; // e.g. "My Shirt Size"
  final Map<String, double> measurements;
  final DateTime createdAt;

  const MeasurementProfileModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.measurements,
    required this.createdAt,
  });

  factory MeasurementProfileModel.fromMap(Map<String, dynamic> map, String id) {
    DateTime createdAt = DateTime.now();
    final raw = map['createdAt'];
    if (raw != null) {
      if (raw is DateTime) createdAt = raw;
    }
    final m = map['measurements'];
    Map<String, double> measurements = {};
    if (m is Map) {
      for (final e in m.entries) {
        final v = e.value;
        if (v != null) measurements[e.key.toString()] = (v as num).toDouble();
      }
    }
    return MeasurementProfileModel(
      id: id,
      userId: map['userId'] as String? ?? '',
      name: map['name'] as String? ?? 'Profile',
      measurements: measurements,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'measurements': measurements,
      'createdAt': createdAt,
    };
  }
}
