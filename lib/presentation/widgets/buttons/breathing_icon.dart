// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:vocab_app/configs/config.dart';

class BreathingIcon extends StatefulWidget {
  final IconData iconData;
  final Color color;
  final bool recording;

  const BreathingIcon({
    super.key,
    required this.iconData,
    required this.color,
    required this.recording,
  });

  @override
  _BreathingIconState createState() => _BreathingIconState();
}

class _BreathingIconState extends State<BreathingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    if (widget.recording) {
      _startAnimation();
    }
  }

  @override
  void didUpdateWidget(covariant BreathingIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.recording != widget.recording) {
      if (widget.recording) {
        _startAnimation();
      } else {
        _stopAnimation();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation() {
    _controller.repeat(reverse: true);
  }

  void _stopAnimation() {
    _controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Icon(
          widget.iconData,
          size: SizeConfig.defaultSize * 2.3,
          color: ColorTween(
            begin: Colors.white,
            end: widget.color,
          ).animate(_controller).value,
        );
      },
    );
  }
}
