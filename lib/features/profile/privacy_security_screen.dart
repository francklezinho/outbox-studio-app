import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';
// ✅ NOVOS IMPORTS ADICIONADOS - PARA NAVEGAÇÃO
import 'view_privacy_policy_screen.dart';
import 'download_my_data_screen.dart';

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
  bool _dataCollection = true;
  bool _thirdPartySharing = false;
  bool _marketingCommunications = false;
  bool _biometricLock = false;
  bool _twoFactorAuth = false;

  Widget _buildSettingTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
    Color? iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (iconColor ?? AppTheme.accentPrimary).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor ?? AppTheme.accentPrimary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Oswald',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                    fontFamily: 'Lato',
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.accentPrimary,
            activeTrackColor: AppTheme.accentPrimary.withOpacity(0.3),
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
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
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (iconColor ?? AppTheme.accentPrimary).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor ?? AppTheme.accentPrimary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Oswald',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                          fontFamily: 'Lato',
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withOpacity(0.5),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundPrimary,
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
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
                      'PRIVACY & SECURITY',
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
                const SizedBox(height: 40),

                // Title and Description
                Text(
                  'Privacy & Security Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Oswald',
                  ),
                ).animate().fadeIn(delay: 400.ms),
                const SizedBox(height: 8),
                Text(
                  'Control your privacy settings and security preferences',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 16,
                    fontFamily: 'Lato',
                  ),
                ).animate().fadeIn(delay: 500.ms),
                const SizedBox(height: 40),

                // Privacy Section
                Text(
                  'PRIVACY',
                  style: TextStyle(
                    color: AppTheme.accentPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Oswald',
                    letterSpacing: 1.5,
                  ),
                ).animate().fadeIn(delay: 600.ms),
                const SizedBox(height: 16),

                _buildSettingTile(
                  title: 'Data Collection',
                  subtitle: 'Allow app to collect usage data for improvements',
                  value: _dataCollection,
                  onChanged: (value) => setState(() => _dataCollection = value),
                  icon: Icons.data_usage,
                ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.3, end: 0),

                _buildSettingTile(
                  title: 'Third-Party Sharing',
                  subtitle: 'Share data with partner services',
                  value: _thirdPartySharing,
                  onChanged: (value) => setState(() => _thirdPartySharing = value),
                  icon: Icons.share,
                  iconColor: Colors.orange,
                ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.3, end: 0),

                _buildSettingTile(
                  title: 'Marketing Communications',
                  subtitle: 'Receive personalized marketing content',
                  value: _marketingCommunications,
                  onChanged: (value) => setState(() => _marketingCommunications = value),
                  icon: Icons.campaign,
                  iconColor: Colors.blue,
                ).animate().fadeIn(delay: 900.ms).slideY(begin: 0.3, end: 0),

                const SizedBox(height: 30),

                // Security Section
                Text(
                  'SECURITY',
                  style: TextStyle(
                    color: AppTheme.accentPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Oswald',
                    letterSpacing: 1.5,
                  ),
                ).animate().fadeIn(delay: 1000.ms),
                const SizedBox(height: 16),

                _buildSettingTile(
                  title: 'Biometric Lock',
                  subtitle: 'Use fingerprint or face ID to secure app',
                  value: _biometricLock,
                  onChanged: (value) => setState(() => _biometricLock = value),
                  icon: Icons.fingerprint,
                  iconColor: Colors.green,
                ).animate().fadeIn(delay: 1100.ms).slideY(begin: 0.3, end: 0),

                _buildSettingTile(
                  title: 'Two-Factor Authentication',
                  subtitle: 'Add extra security to your account',
                  value: _twoFactorAuth,
                  onChanged: (value) => setState(() => _twoFactorAuth = value),
                  icon: Icons.security,
                  iconColor: Colors.red,
                ).animate().fadeIn(delay: 1200.ms).slideY(begin: 0.3, end: 0),

                const SizedBox(height: 20),

                // Action Items
                _buildActionTile(
                  title: 'View Privacy Policy',
                  subtitle: 'Read our complete privacy policy',
                  icon: Icons.policy,
                  onTap: () {
                    // ✅ NAVEGAÇÃO ADICIONADA - VIEW PRIVACY POLICY
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ViewPrivacyPolicyScreen(),
                      ),
                    );
                  },
                ).animate().fadeIn(delay: 1300.ms).slideY(begin: 0.3, end: 0),

                _buildActionTile(
                  title: 'Download My Data',
                  subtitle: 'Export all your personal data',
                  icon: Icons.download,
                  onTap: () {
                    // ✅ NAVEGAÇÃO ADICIONADA - DOWNLOAD MY DATA
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DownloadMyDataScreen(),
                      ),
                    );
                  },
                ).animate().fadeIn(delay: 1400.ms).slideY(begin: 0.3, end: 0),

                _buildActionTile(
                  title: 'Delete Account',
                  subtitle: 'Permanently delete your account and data',
                  icon: Icons.delete_forever,
                  iconColor: Colors.red,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: AppTheme.backgroundSecondary,
                        title: Text(
                          'Delete Account',
                          style: TextStyle(color: Colors.red, fontFamily: 'Oswald'),
                        ),
                        content: Text(
                          'This action cannot be undone. Are you sure you want to delete your account?',
                          style: TextStyle(color: Colors.white, fontFamily: 'Lato'),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Account deletion - Coming soon!'),
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            child: Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ).animate().fadeIn(delay: 1500.ms).slideY(begin: 0.3, end: 0),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
