// lib/widgets/glass_dark_box.dart
import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';

/// Glass dark box baseado no CSS fornecido:
/// background: rgba(0, 0, 0, 0.29);
/// border-radius: 16px;
/// box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1);
/// backdrop-filter: blur(8.3px);
/// border: 1px solid rgba(0, 0, 0, 0.08);
class GlassDarkBox extends StatelessWidget {
  final Widget child;
  final double radius;
  final EdgeInsetsGeometry padding;

  const GlassDarkBox({
    super.key,
    required this.child,
    this.radius = 16, // border-radius: 16px
    this.padding = const EdgeInsets.fromLTRB(20, 20, 20, 22),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        // backdrop-filter: blur(8.3px)
        filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 20.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            // background: rgba(0, 0, 0, 0.29)
            color: Colors.black.withValues(alpha: 0.65),
            // border: 1px solid rgba(0, 0, 0, 0.08)
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.08),
              width: 1.0,
            ),
            // box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1)
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 30,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
