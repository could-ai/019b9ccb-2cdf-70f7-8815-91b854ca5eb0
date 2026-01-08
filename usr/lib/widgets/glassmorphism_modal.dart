import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GlassmorphismModal extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;

  const GlassmorphismModal({
    super.key,
    required this.child,
    this.blur = 10,
    this.opacity = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
      child: Container(
        color: Colors.black.withOpacity(opacity),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}