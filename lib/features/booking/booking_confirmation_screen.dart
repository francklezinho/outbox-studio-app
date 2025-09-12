// lib/features/booking/booking_confirmation_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/glass_dark_box.dart';
import '../main/main_screen.dart';
import 'booking_list_screen.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final String bookingId;
  final String packageName;
  final String packagePrice;
  final String customerName;
  final String customerEmail;
  final DateTime bookingDate;
  final String status;

  const BookingConfirmationScreen({
    super.key,
    required this.bookingId,
    required this.packageName,
    required this.packagePrice,
    required this.customerName,
    required this.customerEmail,
    required this.bookingDate,
    this.status = 'pending',
  });

  @override
  State<BookingConfirmationScreen> createState() => _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen>
    with TickerProviderStateMixin {
  late AnimationController _successController;
  late AnimationController _detailsController;

  @override
  void initState() {
    super.initState();
    _successController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _detailsController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Start animations
    _successController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      _detailsController.forward();
    });
  }

  @override
  void dispose() {
    _successController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const MainScreen()),
          (route) => false,
    );
  }

  void _navigateToMyBookings() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const BookingListScreen()),
    );
  }

  Color get _statusColor {
    switch (widget.status.toLowerCase()) {
      case 'confirmed':
        return Colors.green.shade400;
      case 'pending':
        return Colors.orange.shade400;
      case 'cancelled':
        return Colors.red.shade400;
      default:
        return Colors.orange.shade400;
    }
  }

  String get _statusText {
    switch (widget.status.toLowerCase()) {
      case 'confirmed':
        return 'Confirmed';
      case 'pending':
        return 'Pending Confirmation';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Pending Confirmation';
    }
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Success Icon Animation
                AnimatedBuilder(
                  animation: _successController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _successController.value,
                      child: Container(
                        width: 120,
                        height: 120,
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
                              blurRadius: 30,
                              spreadRadius: 0,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.check_circle_outline,
                          color: Colors.white,
                          size: 60,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 30),

                // Success Title
                Text(
                  'Booking Confirmed!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Oswald',
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(duration: 800.ms, delay: 600.ms).slideY(begin: 0.3, end: 0),

                const SizedBox(height: 12),

                // Success Subtitle
                Text(
                  'Your studio session has been successfully booked.\nWe\'ll contact you within 24 hours to confirm details.',
                  style: TextStyle(
                    color: Colors.white.withAlpha(179),
                    fontSize: 16,
                    fontFamily: 'Lato',
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(duration: 800.ms, delay: 800.ms).slideY(begin: 0.3, end: 0),

                const SizedBox(height: 40),

                // Booking Details Card
                AnimatedBuilder(
                  animation: _detailsController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, 50 * (1 - _detailsController.value)),
                      child: Opacity(
                        opacity: _detailsController.value,
                        child: GlassDarkBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Booking Details',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Oswald',
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: _statusColor.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: _statusColor, width: 1),
                                    ),
                                    child: Text(
                                      _statusText,
                                      style: TextStyle(
                                        color: _statusColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Oswald',
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              // Booking ID
                              _buildDetailRow(
                                'Booking ID',
                                '#${widget.bookingId.substring(0, 8).toUpperCase()}',
                                Icons.confirmation_number_outlined,
                              ),

                              const SizedBox(height: 16),

                              // Package
                              _buildDetailRow(
                                'Package',
                                widget.packageName,
                                Icons.video_camera_front_outlined,
                              ),

                              const SizedBox(height: 16),

                              // Price
                              _buildDetailRow(
                                'Price',
                                widget.packagePrice,
                                Icons.attach_money_outlined,
                              ),

                              const SizedBox(height: 16),

                              // Customer
                              _buildDetailRow(
                                'Customer',
                                widget.customerName,
                                Icons.person_outline,
                              ),

                              const SizedBox(height: 16),

                              // Email
                              _buildDetailRow(
                                'Email',
                                widget.customerEmail,
                                Icons.email_outlined,
                              ),

                              const SizedBox(height: 16),

                              // Session Date
                              _buildDetailRow(
                                'Session Date',
                                '${widget.bookingDate.day}/${widget.bookingDate.month}/${widget.bookingDate.year} at ${widget.bookingDate.hour.toString().padLeft(2, '0')}:${widget.bookingDate.minute.toString().padLeft(2, '0')}',
                                Icons.calendar_today_outlined,
                              ),

                              const SizedBox(height: 24),

                              // Important Notice
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade900.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.blue.shade400.withOpacity(0.5),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: Colors.blue.shade300,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Important Information',
                                            style: TextStyle(
                                              color: Colors.blue.shade300,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Oswald',
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Please arrive 15 minutes before your scheduled session time. Our team will reach out to you within 24 hours to confirm all details.',
                                            style: TextStyle(
                                              color: Colors.white.withAlpha(204),
                                              fontSize: 13,
                                              fontFamily: 'Lato',
                                              height: 1.4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // Action Buttons
                Column(
                  children: [
                    // View My Bookings Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _navigateToMyBookings,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentPrimary,
                          foregroundColor: Colors.white,
                          elevation: 8,
                          shadowColor: AppTheme.accentPrimary.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.list_alt_outlined, size: 20),
                            const SizedBox(width: 12),
                            const Text(
                              'View My Bookings',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Oswald',
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(duration: 600.ms, delay: 1200.ms).slideY(begin: 0.3, end: 0),

                    const SizedBox(height: 16),

                    // Back to Home Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton(
                        onPressed: _navigateToHome,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: Colors.white.withOpacity(0.3),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.home_outlined, size: 20),
                            const SizedBox(width: 12),
                            const Text(
                              'Back to Home',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Oswald',
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(duration: 600.ms, delay: 1400.ms).slideY(begin: 0.3, end: 0),
                  ],
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.backgroundSecondary.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppTheme.accentPrimary,
            size: 18,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withAlpha(179),
                  fontSize: 12,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
