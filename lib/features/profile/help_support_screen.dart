import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundPrimary,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildContactSection(),
                      const SizedBox(height: 40),
                      // ✅ REMOVIDA A SEÇÃO _buildSupportMessage()
                      _buildBusinessHours(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.5, end: 0),
          const Spacer(),
          const Text(
            'HELP & SUPPORT',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Oswald',
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ).animate().fadeIn(duration: 800.ms, delay: 200.ms),
          const Spacer(),
          const SizedBox(width: 48), // Espaço para balancear
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Column(
      children: [
        _buildContactCard(
          icon: Icons.email_outlined,
          label: 'Email Support',
          value: 'contact@outboxlasvegas.com',
          description: 'Get help via email - We respond within 24 hours',
        ).animate().fadeIn(delay: 300.ms, duration: 600.ms).slideX(begin: -0.3, end: 0),

        const SizedBox(height: 20),

        _buildContactCard(
          icon: Icons.phone_outlined,
          label: 'Phone Support',
          value: '+1 702 981 0618',
          description: 'Call us during business hours',
        ).animate().fadeIn(delay: 450.ms, duration: 600.ms).slideX(begin: -0.3, end: 0),

        const SizedBox(height: 20),

        _buildContactCard(
          icon: Icons.location_on_outlined,
          label: 'Studio Address',
          value: '621 S Tonopah Drive, 100 - 89106 Las Vegas, NV',
          description: 'Visit our recording studio',
        ).animate().fadeIn(delay: 600.ms, duration: 600.ms).slideX(begin: -0.3, end: 0),

        const SizedBox(height: 20),

        _buildContactCard(
          icon: Icons.chat_bubble_outline,
          label: 'Live Chat',
          value: 'Available on website',
          description: 'Chat with our support team instantly',
        ).animate().fadeIn(delay: 750.ms, duration: 600.ms).slideX(begin: -0.3, end: 0),
      ],
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String label,
    required String value,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.backgroundSecondary,
            AppTheme.backgroundTertiary.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.accentPrimary,
                  AppTheme.accentSecondary,
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accentPrimary.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.black,
              size: 28,
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
                    color: AppTheme.accentPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Oswald',
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Lato',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                    fontFamily: 'Lato',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessHours() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.access_time,
                color: AppTheme.accentPrimary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Business Hours',
                style: TextStyle(
                  color: AppTheme.accentPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Oswald',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildHourRow('Monday - Friday', '9:00 AM - 9:00 PM'),
          _buildHourRow('Saturday', '9:00 AM - 9:00 PM'),
          _buildHourRow('Sunday', '9:00 AM - 9:00 PM'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.green.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Email support available 24/7',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Lato',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 1200.ms, duration: 600.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildHourRow(String day, String hours) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            day,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
              fontFamily: 'Lato',
            ),
          ),
          Text(
            hours,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'Lato',
            ),
          ),
        ],
      ),
    );
  }
}
