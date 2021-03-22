import 'package:flutter/rendering.dart';

class CoverShadowPainter extends CustomPainter {
  /// If non-null, determines which clip to use.
  final CustomClipper<Path> clipper;

  /// A list of shadows cast by this box behind the box.
  final List<BoxShadow>? clipShadow;

  CoverShadowPainter({
    required this.clipper,
    this.clipShadow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    clipShadow?.forEach(
      (BoxShadow shadow) {
        final paint = shadow.toPaint();
        final spreadSize = Size(
          size.width + shadow.spreadRadius * 2,
          size.height + shadow.spreadRadius * 2,
        );
        final clipPath = clipper.getClip(spreadSize).shift(
              Offset(
                shadow.offset.dx - shadow.spreadRadius,
                shadow.offset.dy - shadow.spreadRadius,
              ),
            );
        canvas.drawPath(clipPath, paint);
      },
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
