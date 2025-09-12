// lib/models/payment_intent_model.dart

class PaymentIntentModel {
  final String id;
  final String clientSecret;
  final int amount;
  final String currency;
  final String status;
  final DateTime created;

  PaymentIntentModel({
    required this.id,
    required this.clientSecret,
    required this.amount,
    required this.currency,
    required this.status,
    required this.created,
  });

  factory PaymentIntentModel.fromJson(Map<String, dynamic> json) {
    return PaymentIntentModel(
      id: json['id'] ?? '',
      clientSecret: json['client_secret'] ?? '',
      amount: json['amount'] ?? 0,
      currency: json['currency'] ?? 'usd',
      status: json['status'] ?? '',
      created: DateTime.fromMillisecondsSinceEpoch((json['created'] ?? 0) * 1000),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_secret': clientSecret,
      'amount': amount,
      'currency': currency,
      'status': status,
      'created': created.millisecondsSinceEpoch ~/ 1000,
    };
  }
}
