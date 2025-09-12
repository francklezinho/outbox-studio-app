import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripeService {
  // ✅ URL DO SEU BACKEND VERCEL
  static const String _backendUrl = 'https://outbox-stripe-backend.vercel.app';

  static Future<String?> createPaymentIntent({
    required double amount,
    required String currency,
    Map<String, String>? metadata,
  }) async {
    try {
      // ✅ LOGS PARA DEBUG
      if (kDebugMode) {
        print('🚀 Criando Payment Intent...');
        print('💰 Amount: ${(amount * 100).round()} cents');
        print('💱 Currency: ${currency.toLowerCase()}');
        print('🌐 Backend URL: $_backendUrl/api/create-payment-intent');
      }

      final response = await http.post(
        Uri.parse('$_backendUrl/api/create-payment-intent'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'amount': (amount * 100).round(),
          'currency': currency.toLowerCase(),
          'metadata': metadata ?? {},
        }),
      );

      if (kDebugMode) {
        print('📡 Status Code: ${response.statusCode}');
        print('📄 Response Body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final clientSecret = data['client_secret'];

        if (kDebugMode) {
          print('✅ Payment Intent criado com sucesso!');
          print('🔑 Client Secret: ${clientSecret?.substring(0, 20)}...');
        }

        return clientSecret;
      } else {
        if (kDebugMode) {
          print('❌ Erro HTTP ${response.statusCode}: ${response.body}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Exceção criando Payment Intent: $e');
      }
      return null;
    }
  }

  static Future<bool> presentPaymentSheet({
    required String clientSecret,
    required String merchantDisplayName,
  }) async {
    try {
      if (kDebugMode) {
        print('🛒 Inicializando Payment Sheet...');
        print('🏪 Merchant: $merchantDisplayName');
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: merchantDisplayName,
          style: ThemeMode.dark,
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'US',
            testEnv: false,
          ),
          applePay: const PaymentSheetApplePay(
            merchantCountryCode: 'US',
          ),
        ),
      );

      if (kDebugMode) {
        print('✅ Payment Sheet inicializado!');
        print('🎯 Apresentando Payment Sheet...');
      }

      await Stripe.instance.presentPaymentSheet();

      if (kDebugMode) {
        print('🎉 Pagamento realizado com sucesso!');
      }

      return true;
    } on StripeException catch (e) {
      if (kDebugMode) {
        print('❌ Erro Stripe: ${e.error.localizedMessage}');
        print('🔧 Code: ${e.error.code}');
        print('🔧 Type: ${e.error.type}');
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erro apresentando Payment Sheet: $e');
      }
      return false;
    }
  }

  static double parsePrice(String price) {
    final cleanPrice = price.replaceAll(RegExp(r'[^\d.]'), '');
    final parsedPrice = double.tryParse(cleanPrice) ?? 0.0;

    if (kDebugMode) {
      print('💲 Preço original: $price');
      print('💲 Preço limpo: $cleanPrice');
      print('💲 Preço parseado: $parsedPrice');
    }

    return parsedPrice;
  }
}
