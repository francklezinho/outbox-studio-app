// lib/core/models/booking_model.dart

class BookingModel {
  final String id;
  final String userId;
  final String name;
  final String email;
  final String phone;
  final String message;
  final String packageName;
  final String packagePrice;
  final DateTime bookingDate;
  final DateTime createdAt;
  final String status; // pending, confirmed, completed, cancelled
  final Map<String, dynamic>? additionalData;

  BookingModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.message,
    required this.packageName,
    required this.packagePrice,
    required this.bookingDate,
    required this.createdAt,
    required this.status,
    this.additionalData,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      message: json['message'] ?? '',
      packageName: json['package_name'] ?? '',
      packagePrice: json['package_price'] ?? '',
      bookingDate: DateTime.parse(json['booking_date'] ?? DateTime.now().toIso8601String()),
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      status: json['status'] ?? 'pending',
      additionalData: json['additional_data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'email': email,
      'phone': phone,
      'message': message,
      'package_name': packageName,
      'package_price': packagePrice,
      'booking_date': bookingDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'status': status,
      'additional_data': additionalData,
    };
  }

  BookingModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? email,
    String? phone,
    String? message,
    String? packageName,
    String? packagePrice,
    DateTime? bookingDate,
    DateTime? createdAt,
    String? status,
    Map<String, dynamic>? additionalData,
  }) {
    return BookingModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      message: message ?? this.message,
      packageName: packageName ?? this.packageName,
      packagePrice: packagePrice ?? this.packagePrice,
      bookingDate: bookingDate ?? this.bookingDate,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      additionalData: additionalData ?? this.additionalData,
    );
  }
}
