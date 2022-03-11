import 'package:flutter/material.dart';

class CircleDecoration extends StatelessWidget {
  const CircleDecoration({
    Key? key,
    this.top,
    this.left,
    this.right,
    this.bottom,
    this.radius = 50,
    this.thickness = 10,
  }) : super(key: key);

  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final double radius;
  final double thickness;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      right: right,
      left: left,
      bottom: bottom,
      child: CircleAvatar(
        radius: radius,
        backgroundColor:
            Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
        child: CircleAvatar(
          radius: radius - thickness,
          backgroundColor: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
