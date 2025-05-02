import 'package:flutter/material.dart';

class AnimatedLogo extends StatefulWidget {
  final String imagePath;
  final double imageHeight;
  final double floatingDistance;

  const AnimatedLogo({
    super.key,
    required this.imagePath,
    this.imageHeight = 110,
    this.floatingDistance = 8.0,
  });

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    final Tween<double> tween = Tween(
      begin: -widget.floatingDistance,
      end: widget.floatingDistance,
    );
    _floatAnimation = tween.animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatAnimation,
      builder:
          (context, child) => Transform.translate(
            offset: Offset(0, _floatAnimation.value),
            child: child,
          ),
      child: Image.asset(widget.imagePath, height: widget.imageHeight),
    );
  }
}
