// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'colors.dart';

class AnimatedLogo extends StatefulWidget {
  const AnimatedLogo({Key? key}) : super(key: key);

  @override
  _AnimatedLogoState createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );
    _controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Transform.rotate(
          transformHitTests: false,
          angle: _controller.value * 2 * math.pi,
          child: child,
        );
      },
      child: const Icon(
        Icons.graphic_eq_rounded,
        size: 30,
        color: AppColors.mainColor,
      ),
    );
  }
}
