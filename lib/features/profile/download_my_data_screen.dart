import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DownloadMyDataScreen extends StatefulWidget {
  const DownloadMyDataScreen({super.key});

  @override
  State<DownloadMyDataScreen> createState() => _DownloadMyDataScreenState();
}

class _DownloadMyDataScreenState extends State<DownloadMyDataScreen> {
  bool _isLoading = false;
  bool _downloadRequested = false;

  Future<void> _requestDataExport() async {
    setState(() => _isLoading = true);

    // Simulate data export process
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isLoading = false;
      _downloadRequested = true;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Data export request submitted! You will receive an email with download link within 24 hours.'),
          backgroundColor: AppTheme.accentPrimary,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

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
                      'DOWNLOAD MY DATA',
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
                  child: Column(
                    children: [
                      // Info Section
                      Container(
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
                            Row(
                              children: [
                                Icon(
                                  Icons.download,
                                  color: AppTheme.accentPrimary,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Export Your Personal Data',
                                  style: TextStyle(
                                    color: AppTheme.accentPrimary,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Oswald',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'You can request a copy of all personal data we have about you. This includes:',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 16,
                                fontFamily: 'Lato',
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildDataItem(Icons.person, 'Profile Information', 'Name, email, contact details'),
                            _buildDataItem(Icons.calendar_today, 'Booking History', 'All your studio bookings and sessions'),
                            _buildDataItem(Icons.message, 'Communications', 'Chat messages and support tickets'),
                            _buildDataItem(Icons.settings, 'Preferences', 'App settings and notification preferences'),
                            _buildDataItem(Icons.analytics, 'Usage Data', 'App usage statistics and analytics'),
                          ],
                        ),
                      ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3, end: 0),

                      const SizedBox(height: 24),

                      // Process Info
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.blue.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.blue,
                              size: 24,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'How It Works',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Oswald',
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'After requesting your data export, we will prepare a secure download link and send it to your registered email address within 24 hours. The link will be valid for 7 days.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
                                fontFamily: 'Lato',
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.3, end: 0),

                      const SizedBox(height: 32),

                      // Download Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _downloadRequested ? null : _requestDataExport,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _downloadRequested ? Colors.green : AppTheme.accentPrimary,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 8,
                            shadowColor: AppTheme.accentPrimary.withOpacity(0.3),
                          ),
                          icon: _isLoading
                              ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 2,
                            ),
                          )
                              : Icon(_downloadRequested ? Icons.check : Icons.download, size: 20),
                          label: Text(
                            _isLoading
                                ? 'Preparing Export...'
                                : _downloadRequested
                                ? 'Request Submitted'
                                : 'Request Data Export',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Oswald',
                            ),
                          ),
                        ),
                      ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.5, end: 0),

                      const SizedBox(height: 40),
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

  Widget _buildDataItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.accentPrimary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppTheme.accentPrimary,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Oswald',
                  ),
                ),
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
}
