// lib/widgets/smart_back_button.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme/app_theme.dart';

class SmartBackButton extends StatelessWidget {
  final Function(int)? onBackToHome;
  final String? title;

  const SmartBackButton({
    super.key,
    this.onBackToHome,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _handleBackPress(context),
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
    ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.5, end: 0);
  }

  void _handleBackPress(BuildContext context) {
    // ✅ INTELIGENTE: Verifica se pode fazer pop
    if (Navigator.canPop(context)) {
      // ✅ TEM TELA ANTERIOR: Faz pop normal
      Navigator.pop(context);
    } else {
      // ✅ NÃO TEM TELA ANTERIOR: Volta para Home via callback
      if (onBackToHome != null) {
        onBackToHome!(0); // Vai para index 0 (Home)
      }
    }
  }
}
