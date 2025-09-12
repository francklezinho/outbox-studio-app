import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme/app_theme.dart';

class ParallaxCarouselItem extends StatelessWidget {
  final String imagePath;
  final double pageValue;
  final int index;
  final double currentPage;

  const ParallaxCarouselItem({
    Key? key,
    required this.imagePath,
    required this.pageValue,
    required this.index,
    required this.currentPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isActive = (currentPage - index).abs() < 0.5;
    final parallaxValue = (currentPage - index) * 0.5;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 20, // ✅ MARGEM LATERAL AJUSTADA
        vertical: isActive ? 0 : 10,
      ),
      child: Transform.scale(
        scale: pageValue,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30), // ✅ BORDAS MAIS SUAVES
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: isActive ? 25 : 15,
                spreadRadius: isActive ? 3 : 0,
                offset: Offset(0, isActive ? 12 : 8),
              ),
              if (isActive)
                BoxShadow(
                  color: AppTheme.accentPrimary.withOpacity(0.2),
                  blurRadius: 30,
                  spreadRadius: 5,
                  offset: const Offset(0, 0),
                ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30), // ✅ BORDAS MAIS SUAVES
            child: Stack(
              children: [
                // ✅ PARALLAX IMAGE
                Transform.translate(
                  offset: Offset(parallaxValue * 100, 0),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildErrorPlaceholder();
                      },
                    ),
                  ),
                ),

                // ✅ GRADIENT OVERLAY SUAVIZADO
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.1),
                        Colors.black.withOpacity(0.3),
                      ],
                      stops: const [0.0, 0.7, 1.0],
                    ),
                  ),
                ),

                // ✅ SHINE EFFECT (when active)
                if (isActive)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 800),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.1),
                          Colors.transparent,
                          Colors.white.withOpacity(0.05),
                        ],
                      ),
                    ),
                  ).animate(onPlay: (controller) => controller.repeat())
                      .shimmer(
                    duration: 2000.ms,
                    color: Colors.white.withOpacity(0.1),
                  ),

                // ✅ BORDER HIGHLIGHT SUAVIZADA
                if (isActive)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30), // ✅ BORDAS SUAVES
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                  ),

                // ✅ BLUR OVERLAY SUAVIZADO (for inactive items)
                if (!isActive)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30), // ✅ BORDAS SUAVES
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 2.0,
                        sigmaY: 2.0,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(30), // ✅ BORDAS SUAVES
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30), // ✅ BORDAS SUAVES
        gradient: LinearGradient(
          colors: [
            AppTheme.accentPrimary.withOpacity(0.8),
            AppTheme.accentSecondary.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported,
              color: Colors.white.withOpacity(0.8),
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              'Image not found',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Slide ${imagePath.split('/').last}',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 12,
                fontFamily: 'Lato',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
