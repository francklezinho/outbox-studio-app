// lib/widgets/animated_drawer.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../core/providers/auth_provider.dart';
import '../core/providers/profile_provider.dart';
import '../core/theme/app_theme.dart';
import '../features/profile/help_support_screen.dart'; // ✅ NOVO IMPORT

class AnimatedDrawer extends StatelessWidget {
  const AnimatedDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF121212),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: _buildDrawerHeader(),
                      ),
                      // Menu items
                      Expanded(
                        child: Column(
                          children: _buildMenuItems(context),
                        ),
                      ),
                      // Logout button
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: _buildLogoutButton(context),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ✅ HEADER ALINHADO À ESQUERDA
  Widget _buildDrawerHeader() {
    return Consumer2<AppAuthProvider, ProfileProvider>(
      builder: (context, auth, profile, _) {
        // ✅ USA A MESMA LÓGICA DO PROFILE_SCREEN REAL
        final String? profileImageUrl = profile.avatarUrl;
        final String userName = profile.fullName ??
            auth.user?.userMetadata?['full_name'] ??
            auth.user?.userMetadata?['name'] ??
            auth.user?.email?.split('@').first ??
            'User';
        final String userEmail = auth.user?.email ?? 'user@example.com';

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Avatar à esquerda
            _buildProfileAvatar(profileImageUrl),
            const SizedBox(width: 16),
            // ✅ Nome e email alinhados à esquerda
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8), // Para centralizar verticalmente com avatar
                  // Nome
                  Text(
                    userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Oswald',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Email
                  Text(
                    userEmail,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 12,
                      fontFamily: 'Lato',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // ✅ AVATAR COM CACHED_NETWORK_IMAGE - IGUAL AO PROFILE_SCREEN
  Widget _buildProfileAvatar(String? profileImageUrl) {
    if (profileImageUrl != null && profileImageUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: profileImageUrl,
        imageBuilder: (context, imageProvider) => Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
            border: Border.all(
              color: AppTheme.accentPrimary.withValues(alpha: 0.5),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.accentPrimary.withValues(alpha: 0.3),
                blurRadius: 6,
                spreadRadius: 1,
                offset: const Offset(0, 3),
              ),
            ],
          ),
        ),
        placeholder: (context, url) => Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppTheme.accentGradient,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 2,
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
        errorWidget: (context, url, error) => _buildDefaultAvatar(),
      );
    }

    return _buildDefaultAvatar();
  }

  // ✅ AVATAR PADRÃO IGUAL AO PROFILE_SCREEN
  Widget _buildDefaultAvatar() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppTheme.accentGradient,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 2,
        ),
      ),
      child: const Icon(Icons.person, size: 35, color: Colors.white),
    );
  }

  // ✅ MENU ITEMS - COM HELP & SUPPORT LINKADO PARA HELP SUPPORT SCREEN
  List<Widget> _buildMenuItems(BuildContext context) {
    final List<MenuItem> menuItems = [
      MenuItem(
        icon: Icons.home_outlined,
        title: 'Home',
        onTap: () {
          Navigator.pop(context);
        },
      ),
      MenuItem(
        icon: Icons.video_camera_back_outlined,
        title: 'Services',
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/services');
        },
      ),
      MenuItem(
        icon: Icons.inventory_2_outlined,
        title: 'Packages',
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/packages');
        },
      ),
      MenuItem(
        icon: Icons.book_online_outlined,
        title: 'My Bookings',
        onTap: () {
          Navigator.pop(context);
          // ✅ CORREÇÃO: NAVEGA PARA A BOOKING LIST SCREEN
          Navigator.pushNamed(context, '/booking-list');
        },
      ),
      MenuItem(
        icon: Icons.person_outline,
        title: 'Profile',
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/profile');
        },
      ),
      MenuItem(
        icon: Icons.settings_outlined,
        title: 'Settings',
        onTap: () {
          Navigator.pop(context);
          // ✅ CORREÇÃO: NAVEGA PARA A SETTINGS SCREEN
          Navigator.pushNamed(context, '/settings');
        },
      ),
      MenuItem(
        icon: Icons.help_outline,
        title: 'Help & Support',
        onTap: () {
          Navigator.pop(context);
          // ✅ CORREÇÃO: NAVEGA PARA A HELP SUPPORT SCREEN
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const HelpSupportScreen(),
            ),
          );
        },
      ),
    ];

    return menuItems.map((MenuItem item) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
        child: ListTile(
          leading: Icon(
            item.icon,
            color: AppTheme.accentPrimary,
            size: 20,
          ),
          title: Text(
            item.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Lato',
            ),
          ),
          onTap: item.onTap,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          dense: true,
          visualDensity: VisualDensity.compact,
        ),
      );
    }).toList();
  }

  // ✅ FUNÇÃO COMING SOON (REMOVIDA DA HELP & SUPPORT)
  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - Coming Soon!'),
        backgroundColor: AppTheme.accentPrimary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ✅ LOGOUT BUTTON
  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: AppTheme.backgroundSecondary,
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Oswald',
                  fontWeight: FontWeight.w700,
                ),
              ),
              content: Text(
                'Are you sure you want to logout?',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontFamily: 'Lato',
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.read<AppAuthProvider>().signOut();
                  },
                  child: Text(
                    'Logout',
                    style: TextStyle(color: Colors.red.shade400),
                  ),
                ),
              ],
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.withValues(alpha: 0.1),
          foregroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: Colors.red.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
        ),
        icon: const Icon(Icons.logout, size: 16),
        label: const Text(
          'Logout',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Oswald',
          ),
        ),
      ),
    );
  }
}

// ✅ CLASSE MENU ITEM
class MenuItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}
