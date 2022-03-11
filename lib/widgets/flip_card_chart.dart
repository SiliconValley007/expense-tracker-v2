import 'dart:math';

import 'package:flutter/material.dart';

class FlipCardChart extends StatefulWidget {
  const FlipCardChart({
    Key? key,
    required this.front,
    required this.back,
  }) : super(key: key);

  final Widget front;
  final Widget back;

  @override
  State<FlipCardChart> createState() => _FlipCardChartState();
}

class _FlipCardChartState extends State<FlipCardChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > 1) {
          if (_animationController.status == AnimationStatus.completed) {
            _animationController.reverse();
          }
        } else if (details.delta.dx < -1) {
          if (_animationController.status == AnimationStatus.dismissed) {
            _animationController.forward();
          }
        }
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) => Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(_animationController.value * pi),
          alignment: Alignment.center,
          child: _animationController.value <= 0.5
              ? widget.front
              : Transform(
                  transform: Matrix4.identity()..rotateY(pi),
                  alignment: Alignment.center,
                  child: widget.back,
                ),
        ),
      ),
    );
  }
}
