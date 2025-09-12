import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ViewPrivacyPolicyScreen extends StatelessWidget {
  const ViewPrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundPrimary,
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.backgroundSecondary.withOpacity(0.8),
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
                      'PRIVACY POLICY',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Oswald',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ).animate().fadeIn(duration: 800.ms, delay: 200.ms),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.backgroundSecondary,
                          AppTheme.backgroundTertiary.withOpacity(0.6),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Row(
                          children: [
                            Icon(
                              Icons.policy,
                              color: AppTheme.accentPrimary,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Privacy Policy',
                              style: TextStyle(
                                color: AppTheme.accentPrimary,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Oswald',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Last Updated: September 10, 2025',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                            fontFamily: 'Lato',
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Policy Content
                        _buildPolicySection(
                          '1. Introduction',
                          'We are committed to protecting your privacy and personal data. This privacy policy explains how we collect, use, and safeguard your information when you use the Outbox Studio app.',
                        ),
                        _buildPolicySection(
                          '2. Information We Collect',
                          'We collect personal information you provide directly to us such as name, email address, and contact details. We also collect usage data, device information, and location data to improve our services.',
                        ),
                        _buildPolicySection(
                          '3. How We Use Your Data',
                          'We use collected information to provide, maintain, and improve our services, communicate with you, personalize your experience, and comply with legal obligations.',
                        ),
                        _buildPolicySection(
                          '4. Data Sharing',
                          'We do not sell your personal information. We may share information with trusted third-party service providers who help us operate the app. We may also share anonymous aggregated data for analytics.',
                        ),
                        _buildPolicySection(
                          '5. Your Rights',
                          'You have rights over your personal data including access, correction, deletion, and data portability. You may opt out of marketing communications at any time through your account settings.',
                        ),
                        _buildPolicySection(
                          '6. Data Security',
                          'We implement reasonable technical and organizational safeguards to protect your information from unauthorized access, disclosure, or destruction. However, no method of transmission is 100% secure.',
                        ),
                        _buildPolicySection(
                          '7. Changes to This Policy',
                          'We may update this privacy policy from time to time. When changes occur, we will revise the "last updated" date and notify users through the app or email.',
                        ),
                        _buildPolicySection(
                          '8. Contact Us',
                          'If you have questions or concerns about our privacy practices, please contact us at:\n\nEmail: privacy@outboxlasvegas.com\nPhone: +1 702 981 0618\nAddress: 621 S Tonopah Drive, 100 - 89106 Las Vegas, NV',
                          isLast: true,
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3, end: 0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPolicySection(String title, String content, {bool isLast = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'Oswald',
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14,
            fontFamily: 'Lato',
            height: 1.5,
          ),
        ),
        if (!isLast) const SizedBox(height: 20),
      ],
    );
  }
}
