import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundPrimary,
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAnimatedSectionTitle('HOW IT WORKS'),
                      const SizedBox(height: 20),
                      _buildInfoText('Our streamlined process makes professional video production accessible and efficient. From booking to delivery, we handle everything so you can focus on your message.'),
                      const SizedBox(height: 32),
                      _buildProcessSteps(),
                      const SizedBox(height: 40),
                      _buildAnimatedSectionTitle('THE STUDIO'),
                      const SizedBox(height: 20),
                      _buildInfoText('Our professional-grade studio is equipped with cutting-edge technology and designed to deliver exceptional content across multiple formats and platforms.'),
                      const SizedBox(height: 20),
                      _buildStudioServices(),
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
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.backgroundSecondary.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
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
          const Spacer(),
          const Text(
            'SERVICES',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Oswald',
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildAnimatedSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white, // ✅ MUDANÇA: TÍTULOS AGORA EM BRANCO
        fontSize: 32,
        fontWeight: FontWeight.w700,
        fontFamily: 'Oswald',
        letterSpacing: 2,
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildInfoText(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.8),
        fontSize: 16,
        fontFamily: 'Lato',
        height: 1.5,
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 600.ms).slideX(begin: -0.2, end: 0);
  }

  Widget _buildProcessSteps() {
    final steps = [
      {'number': '1', 'title': 'BOOK', 'description': 'Lock in your desired session on a day and time that works best for you.'},
      {'number': '2', 'title': 'RECORD', 'description': 'Walk in, and start recording. You focus on your message, we\'ll handle all the tech stuff.'},
      {'number': '3', 'title': 'GET YOUR FILES', 'description': 'You\'ll receive your final long form video file with camera switching, within 24 hours.'},
    ];

    return Column(
      children: steps.asMap().entries.map((entry) {
        int index = entry.key;
        Map<String, String> step = entry.value;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.backgroundSecondary,
                AppTheme.backgroundTertiary.withValues(alpha: 0.6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                offset: const Offset(0, 4),
                blurRadius: 12,
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.accentPrimary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.accentPrimary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    step['number']!,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontFamily: 'Oswald',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step['title']!,
                      style: TextStyle(
                        color: AppTheme.accentPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Oswald',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      step['description']!,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                        fontFamily: 'Lato',
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate()
            .fadeIn(delay: Duration(milliseconds: 300 + (index * 200)))
            .slideX(begin: 0.3, end: 0, duration: 600.ms);
      }).toList(),
    );
  }

  Widget _buildStudioServices() {
    final services = [
      {
        'icon': Icons.podcasts,
        'title': 'VIDEO PODCASTING',
        'description': 'Full productions video podcasting available with professional cameras, audio, microphones, lighting, and professional engineers.',
      },
      {
        'icon': Icons.live_tv,
        'title': 'LIVE STREAMING',
        'description': 'Stream LIVE with professional audio and video including graphics, live call ins, in person or video call guests.',
      },
      {
        'icon': Icons.smartphone,
        'title': 'YOUTUBE / SOCIAL MEDIA CONTENT',
        'description': 'Create single person content for Instagram Reels, TikTok, Youtube.',
      },
    ];

    return Column(
      children: services.asMap().entries.map((entry) {
        int index = entry.key;
        Map<String, dynamic> service = entry.value;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.backgroundSecondary,
                AppTheme.backgroundTertiary.withValues(alpha: 0.6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                offset: const Offset(0, 4),
                blurRadius: 12,
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.accentSecondary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.accentSecondary.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  service['icon'] as IconData,
                  color: AppTheme.accentSecondary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service['title']!,
                      style: TextStyle(
                        color: AppTheme.accentSecondary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Oswald',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      service['description']!,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                        fontFamily: 'Lato',
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate()
            .fadeIn(delay: Duration(milliseconds: 400 + (index * 200)))
            .slideX(begin: -0.3, end: 0, duration: 600.ms);
      }).toList(),
    );
  }
}
