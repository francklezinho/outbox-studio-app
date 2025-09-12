// lib/widgets/animated_bottom_nav.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme/app_theme.dart';

class AnimatedBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AnimatedBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: AppTheme.backgroundSecondary,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Wrap( // ✅ CORREÇÃO PRINCIPAL: Wrap previne overflow
        children: [
          BottomNavigationBar(
            backgroundColor: Colors.transparent, // ✅ Transparente para usar cor do BottomAppBar
            elevation: 0, // ✅ Remove elevação duplicada
            currentIndex: currentIndex,
            onTap: onTap,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppTheme.accentPrimary,
            unselectedItemColor: Colors.white.withValues(alpha: 0.6),
            selectedFontSize: 12, // ✅ Fonte otimizada
            unselectedFontSize: 10,
            iconSize: 24, // ✅ Ícone otimizado
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.inventory_2),
                label: 'Packages',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book_online),
                label: 'Booking',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
