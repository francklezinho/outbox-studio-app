import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/glass_dark_box.dart';
import '../../core/services/stripe_service.dart'; // ✅ NOVO SERVICE SEGURO
import 'booking_confirmation_screen.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> bookingData;

  const PaymentScreen({
    super.key,
    required this.bookingData,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isProcessing = false;

  Future<void> _processPayment() async {
    if (mounted) setState(() => _isProcessing = true);

    try {
      final price = StripeService.parsePrice(widget.bookingData['packagePrice']);

      // ✅ CRIAR PAYMENT INTENT VIA BACKEND
      final clientSecret = await StripeService.createPaymentIntent(
        amount: price,
        currency: 'USD',
        metadata: {
          'booking_id': widget.bookingData['tempBookingId'] ?? '',
          'package_name': widget.bookingData['packageName'],
          'customer_name': widget.bookingData['customerName'],
          'customer_email': widget.bookingData['customerEmail'],
        },
      );

      if (clientSecret == null) {
        _showErrorMessage('Failed to create payment intent. Please try again.');
        return;
      }

      // ✅ APRESENTAR PAYMENT SHEET
      final paymentSuccess = await StripeService.presentPaymentSheet(
        clientSecret: clientSecret,
        merchantDisplayName: 'Outbox Media Studio',
      );

      if (paymentSuccess) {
        await _saveBookingAfterPayment();
      }

    } catch (e) {
      _showErrorMessage('Payment failed: $e');
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _saveBookingAfterPayment() async {
    try {
      final auth = Provider.of<AppAuthProvider>(context, listen: false);

      // Salvar reserva no Supabase após pagamento confirmado
      final response = await Supabase.instance.client
          .from('bookings')
          .insert({
        'user_id': auth.user!.id,
        'name': widget.bookingData['customerName'],
        'email': widget.bookingData['customerEmail'],
        'phone': widget.bookingData['customerPhone'],
        'message': widget.bookingData['message'],
        'package_name': widget.bookingData['packageName'],
        'package_price': widget.bookingData['packagePrice'],
        'booking_date': widget.bookingData['bookingDate'],
        'created_at': DateTime.now().toIso8601String(),
        'status': 'confirmed',
        'payment_status': 'completed',
      })
          .select()
          .single();

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BookingConfirmationScreen(
              bookingId: response['id'].toString(),
              packageName: widget.bookingData['packageName'],
              packagePrice: widget.bookingData['packagePrice'],
              customerName: widget.bookingData['customerName'],
              customerEmail: widget.bookingData['customerEmail'],
              bookingDate: DateTime.parse(widget.bookingData['bookingDate']),
              status: 'confirmed',
            ),
          ),
        );
      }

    } catch (e) {
      _showErrorMessage('Error saving booking: $e');
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundPrimary,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF141414),
              Color(0xFF242424),
              Color(0xFF191919),
              Color(0xFF1F1F1F),
            ],
            stops: [0.0, 0.4, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                      onPressed: _isProcessing ? null : () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Text(
                        'Complete Payment',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontFamily: 'Oswald',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Column(
                        children: [
                          const SizedBox(height: 40),

                          // Payment Icon
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  AppTheme.accentPrimary.withOpacity(0.9),
                                  AppTheme.accentPrimary.withOpacity(0.7),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.accentPrimary.withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.payment_rounded,
                              color: Colors.white,
                              size: 50,
                            ),
                          ).animate().scale(duration: 800.ms),

                          const SizedBox(height: 30),

                          // Title
                          Text(
                            'Secure Payment',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Oswald',
                              letterSpacing: 1.2,
                            ),
                            textAlign: TextAlign.center,
                          ).animate().fadeIn(duration: 600.ms, delay: 200.ms),

                          const SizedBox(height: 12),

                          // Subtitle
                          Text(
                            'Complete your booking with secure payment processing powered by Stripe',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 16,
                              fontFamily: 'Lato',
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ).animate().fadeIn(duration: 600.ms, delay: 400.ms),

                          const SizedBox(height: 40),

                          // Booking Summary
                          GlassDarkBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppTheme.accentPrimary,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(Icons.receipt_long, color: Colors.black, size: 20),
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      'Booking Summary',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Oswald',
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),

                                // Package Name
                                _buildSummaryRow('Package', widget.bookingData['packageName']),
                                const SizedBox(height: 16),

                                // Customer
                                _buildSummaryRow('Customer', widget.bookingData['customerName']),
                                const SizedBox(height: 16),

                                // Date & Time
                                _buildSummaryRow(
                                  'Session Date',
                                  _formatBookingDate(widget.bookingData['bookingDate']),
                                ),
                                const SizedBox(height: 24),

                                // Price (highlighted)
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppTheme.accentPrimary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppTheme.accentPrimary.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Total Amount',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Oswald',
                                        ),
                                      ),
                                      Text(
                                        widget.bookingData['packagePrice'],
                                        style: TextStyle(
                                          color: AppTheme.accentPrimary,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Oswald',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ).animate().fadeIn(duration: 600.ms, delay: 600.ms).slideY(begin: 0.3, end: 0),

                          const SizedBox(height: 40),

                          // Payment Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _isProcessing ? null : _processPayment,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.accentPrimary,
                                foregroundColor: Colors.black,
                                elevation: 8,
                                shadowColor: AppTheme.accentPrimary.withOpacity(0.3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                disabledBackgroundColor: AppTheme.accentPrimary.withOpacity(0.3),
                              ),
                              child: _isProcessing
                                  ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                  strokeWidth: 2.5,
                                ),
                              )
                                  : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.lock_outline, size: 20),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Pay ${widget.bookingData['packagePrice']}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Oswald',
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ).animate().fadeIn(duration: 600.ms, delay: 800.ms).slideY(begin: 0.3, end: 0),

                          const SizedBox(height: 20),

                          // Security Notice
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.green.shade900.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.green.shade400.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.security,
                                  color: Colors.green.shade300,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Your payment is secured by Stripe. We never store your payment information.',
                                    style: TextStyle(
                                      color: Colors.green.shade200,
                                      fontSize: 13,
                                      fontFamily: 'Lato',
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ).animate().fadeIn(duration: 600.ms, delay: 1000.ms),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
            fontFamily: 'Lato',
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'Lato',
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  String _formatBookingDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }
}
