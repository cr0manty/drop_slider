import 'package:flutter/rendering.dart';

/// Clip widget in wave shape shape
class DropClipper extends CustomClipper<Path> {
  final double width;
  final double height;
  final double minHeight;

  const DropClipper({
    required this.height,
    required this.width,
    this.minHeight = 20,
  });

  @override
  Path getClip(Size size) {
    if (height < minHeight) {
      return Path();
    }

    return Path()
      ..moveTo(
        width * .15,
        height,
      )
      ..quadraticBezierTo(
        width * .22,
        height,
        width * .35,
        height * .5,
      )
      ..quadraticBezierTo(
        width * .5,
        height * -.1,
        width * .65,
        height * .55,
      )
      ..quadraticBezierTo(
        width * .78,
        height,
        width * .85,
        height,
      )
      ..lineTo(
        width * .85,
        height,
      )
      ..close();
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
