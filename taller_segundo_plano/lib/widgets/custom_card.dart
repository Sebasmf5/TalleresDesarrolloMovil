import 'package:flutter/material.dart';

enum CardVariant {
  standard,
  neumorphic,
}

class CustomCard extends StatelessWidget {
  final Widget child;
  final CardVariant variant;
  final EdgeInsetsGeometry padding;
g
    super.key,
    required this.child,
    this.variant = CardVariant.standard,
    this.padding = const EdgeInsets.all(16.0),
  });

  @override
  Widget build(BuildContext context) {
    if (variant == CardVariant.neumorphic) {
      return Container(
        padding: padding,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFF7F9FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(color: const Color(0xFFECEFF5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 18,
              offset: const Offset(8, 8),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.95),
              blurRadius: 18,
              offset: const Offset(-8, -8),
            ),
          ],
        ),
        child: child,
      );
    }

    // Standard Variant
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFFF7F9FC)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
