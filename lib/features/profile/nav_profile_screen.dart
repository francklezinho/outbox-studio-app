import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/profile_provider.dart';
import '../../core/theme/app_theme.dart';
import 'edit_profile_screen.dart';
import 'settings_screen.dart';

class NavProfileScreen extends StatefulWidget {
  final Function(int)? onTabChanged;
  const NavProfileScreen({super.key, this.onTabChanged});

  @override
  State<NavProfileScreen> createState() => _NavProfileScreenState();
}

class _NavProfileScreenState extends State<NavProfileScreen> {
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.92),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Select Image Source',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accentPrimary,
                  fontFamily: 'Oswald',
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: _sourceButton(
                      icon: Icons.camera_alt,
                      label: 'Camera',
                      onTap: () {
                        Navigator.pop(ctx);
                        _pickImageFromSource(ImageSource.camera);
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _sourceButton(
                      icon: Icons.photo_library,
                      label: 'Gallery',
                      onTap: () {
                        Navigator.pop(ctx);
                        _pickImageFromSource(ImageSource.gallery);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  Widget _sourceButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.grey[900]!.withOpacity(0.6),
              Colors.grey[800]!.withOpacity(0.4),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.15)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: AppTheme.accentPrimary),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Lato',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageFromSource(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      setState(() {
        _pickedImage = File(pickedFile.path);
      });

      final profileProvider = context.read<ProfileProvider>();
      final success = await profileProvider.uploadAvatar(_pickedImage!);

      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(profileProvider.error ?? 'Upload failed'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile picture updated successfully!'),
            backgroundColor: Color(0xFFFBAF2A),
            behavior: SnackBarBehavior.floating,
          ),
        );
        setState(() {
          _pickedImage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting image: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().loadProfile();
    });
  }

  Widget _buildHeaderWithBackButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                print('🔧 DEBUG: Clicou na seta de voltar');
                print('🔧 DEBUG: onTabChanged é null? ${widget.onTabChanged == null}');

                if (widget.onTabChanged != null) {
                  print('🔧 DEBUG: Chamando onTabChanged(0)');
                  widget.onTabChanged!(0);
                } else {
                  print('🔧 DEBUG: onTabChanged é null, tentando DefaultTabController');
                  final tabController = DefaultTabController.of(context);
                  if (tabController != null) {
                    print('🔧 DEBUG: DefaultTabController encontrado, mudando para índice 0');
                    tabController.animateTo(0);
                  } else {
                    print('🔧 DEBUG: DefaultTabController não encontrado, tentando pop');
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    } else {
                      print('🔧 DEBUG: Não pode fazer pop, ficando na tela atual');
                    }
                  }
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundSecondary.withAlpha(204),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withAlpha(25),
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
            'PROFILE',
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Consumer2<AppAuthProvider, ProfileProvider>(
              builder: (context, auth, profile, _) {
                final user = auth.user;
                final profilePicUrl = profile.avatarUrl;

                Widget avatarWidget;
                if (_pickedImage != null) {
                  avatarWidget = ClipOval(
                    child: Image.file(
                      _pickedImage!,
                      width: 160,
                      height: 160,
                      fit: BoxFit.cover,
                    ),
                  );
                } else if (profilePicUrl != null && profilePicUrl.isNotEmpty) {
                  avatarWidget = ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: profilePicUrl,
                      width: 160,
                      height: 160,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppTheme.accentGradient,
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppTheme.accentGradient,
                        ),
                        child: const Icon(Icons.person, size: 80, color: Colors.white),
                      ),
                    ),
                  );
                } else {
                  avatarWidget = Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppTheme.accentGradient,
                    ),
                    child: const Icon(Icons.person, size: 80, color: Colors.white),
                  );
                }

                final displayName = profile.fullName ??
                    user?.userMetadata?['full_name'] ??
                    user?.userMetadata?['name'] ??
                    user?.email?.split('@').first ??
                    'User';

                final email = user?.email ?? 'email@example.com';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildHeaderWithBackButton(),
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: _showImageSourceDialog,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppTheme.accentGradient,
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.accentPrimary.withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                          avatarWidget,
                          Consumer<ProfileProvider>(
                            builder: (context, prof, _) {
                              if (!prof.isUploading) return const SizedBox.shrink();
                              return Container(
                                width: 160,
                                height: 160,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                ),
                              );
                            },
                          ),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppTheme.accentPrimary,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).animate().scale(delay: 200.ms, duration: 600.ms),
                    const SizedBox(height: 30),
                    Text(
                      displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Oswald',
                      ),
                    ).animate().fadeIn(delay: 400.ms),
                    const SizedBox(height: 8),
                    Text(
                      email,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 16,
                        fontFamily: 'Lato',
                      ),
                    ).animate().fadeIn(delay: 500.ms),
                    const SizedBox(height: 10),
                    Text(
                      'Tap photo to change',
                      style: TextStyle(
                        color: AppTheme.accentPrimary,
                        fontSize: 14,
                        fontFamily: 'Lato',
                      ),
                    ).animate().fadeIn(delay: 600.ms),
                    const SizedBox(height: 50),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: profile.isUploading || profile.isLoading
                            ? null
                            : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EditProfileScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentPrimary,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 8,
                          shadowColor: AppTheme.accentPrimary.withOpacity(0.3),
                        ),
                        icon: const Icon(Icons.edit, size: 20),
                        label: const Text(
                          'Edit Profile',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Oswald',
                          ),
                        ),
                      ),
                    ).animate().slideY(begin: 0.5, end: 0, delay: 800.ms).fade(),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SettingsScreen(),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(Icons.settings, size: 20),
                        label: const Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Lato',
                          ),
                        ),
                      ),
                    ).animate().slideY(begin: 0.5, end: 0, delay: 900.ms).fade(),
                    const SizedBox(height: 40),
                    _buildAccountInfoCard(user),
                    const SizedBox(height: 30),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountInfoCard(User? user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Consumer<ProfileProvider>(
        builder: (context, profile, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Account Information',
                style: TextStyle(
                  color: AppTheme.accentPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Oswald',
                ),
              ),
              const SizedBox(height: 20),
              _infoRow('User ID', user?.id?.substring(0, 8) ?? 'N/A'),
              const SizedBox(height: 12),
              _infoRow('Email', user?.email ?? 'N/A'),
              const SizedBox(height: 12),
              _infoRow('Phone', profile.phone ?? 'Not provided'),
              const SizedBox(height: 12),
              _infoRow('Email Confirmed', user?.emailConfirmedAt != null ? 'Yes' : 'No'),
              const SizedBox(height: 12),
              _infoRow('Account Type', 'Standard User'),
            ],
          );
        },
      ),
    ).animate().slideY(begin: 0.3, end: 0, delay: 1000.ms).fade();
  }

  Widget _infoRow(String label, String value) {
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
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Lato',
          ),
        ),
      ],
    );
  }
}
