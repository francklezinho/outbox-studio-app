// lib/widgets/nav_screen_wrapper.dart

import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import 'smart_back_button.dart';

class NavScreenWrapper extends StatelessWidget {
  final Widget child;
  final String title;
  final Function(int)? onBackToHome;

  const NavScreenWrapper({
    super.key,
    required this.child,
    required this.title,
    this.onBackToHome,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // ✅ INTELIGENTE: Verifica se pode fazer pop
        if (Navigator.canPop(context)) {
          return true; // Permite pop normal
        } else {
          // ✅ NÃO TEM TELA ANTERIOR: Volta para Home
          if (onBackToHome != null) {
            onBackToHome!(0);
          }
          return false; // Evita pop que causaria tela preta
        }
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ✅ HEADER COM SETA INTELIGENTE
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  children: [
                    SmartBackButton(
                      onBackToHome: onBackToHome,
                      title: title,
                    ),
                    const Spacer(),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Oswald',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48), // Balancea o layout
                  ],
                ),
              ),
              // ✅ CONTEÚDO DA TELA ORIGINAL
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
