import 'dart:async';

import 'package:drop_slider/src/base/base_controller.dart';
import 'package:drop_slider/src/utils/clipper.dart';
import 'package:drop_slider/src/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

/// Builder used to redraw widget with current swipe height
typedef HeightBuilder = Widget Function(BuildContext context, double height);

/// [child] widget is displayed at drop swipe bottom side
/// To set swipe color user [color] parameter
/// [aboveWidget] is responsible for the widget, which is the
/// trigger for the swipe, is displayed while the swipe widget
/// height == 0, as well as above the widget after gestures
/// [maxHeight] - maximum widget draw height
/// [controller] Using the controller, you can control the
/// position of this widget (specify the height or return
/// the swipe state to its original position)
/// [width] - max widget width, default  == screen width
/// [onDragEnd] - when the height of the swipe is greater
/// than the minimum, perform this action
/// [reverseDuration] - the duration of the delay after
/// which the height of the controller will be changed when
/// rolling back to the primary state (the height can
/// be changed through the controller)
/// [opacityDuration] - the duration of the child's
/// opacity change on swipe
/// [isOnTapEnabled] - allows you to activate
/// an action on clicking on an element

@immutable
class DropSlider extends StatefulWidget {
  final HeightBuilder child;
  final Color color;
  final HeightBuilder aboveWidget;
  final double maxHeight;
  final BaseDropSwipeController? controller;
  final double? width;
  final VoidCallback? onDragEnd;
  final Duration reverseDuration;
  final Duration opacityDuration;
  final bool isOnTapEnabled;

  const DropSlider({
    required this.child,
    required this.color,
    required this.aboveWidget,
    this.controller,
    this.onDragEnd,
    this.width,
    this.maxHeight = 200,
    this.isOnTapEnabled = true,
    this.opacityDuration = const Duration(milliseconds: 300),
    this.reverseDuration = const Duration(milliseconds: 200),
    Key? key,
  }) : super(key: key);

  @override
  _DropSliderState createState() => _DropSliderState();

  static _DropSliderState? of(BuildContext context) =>
      context.findAncestorStateOfType<_DropSliderState>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) =>
      super.debugFillProperties(
        properties
          ..add(
            StringProperty(
              'description',
              'ScanSlider StatefulWidget',
            ),
          ),
      );
}

class _DropSliderState extends State<DropSlider> {
  late final BaseDropSwipeController? _controller;
  late double _height;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? DropSwipeController();
    _height = _controller!.position;
  }

  @override
  void dispose() {
    _controller?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onDragEnd,
      onVerticalDragUpdate: (details) {
        _timer?.cancel();

        if (_height - details.delta.dy > 0) {
          _height -= details.delta.dy;
        }

        if (widget.maxHeight > _height) {
          _controller!.jumpTo(_height);
        }
      },
      onVerticalDragEnd: (_) {
        if (_height >= _controller!.minHeight) {
          widget.onDragEnd?.call();
        }
        _height = 0;
        _controller!.reverse();
      },
      child: Column(
        children: [
          StreamBuilder<double>(
            stream: _controller!.stream,
            initialData: _height,
            builder: (context, snapshot) =>
                widget.aboveWidget(context, snapshot.data!),
          ),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              StreamBuilder<double>(
                  stream: _controller!.stream,
                  initialData: _height,
                  builder: (context, snapshot) {
                    return ClipPath(
                      clipper: DropClipper(
                        height: snapshot.data!,
                        width:
                            widget.width ?? MediaQuery.of(context).size.width,
                        minHeight: 0,
                      ),
                      child: Container(
                        alignment: Alignment.topCenter,
                        height: snapshot.data!,
                        width:
                            widget.width ?? MediaQuery.of(context).size.width,
                        color: widget.color,
                      ),
                    );
                  }),
              StreamBuilder<double>(
                stream: _controller!.stream,
                initialData: _height,
                builder: (context, snapshot) => AnimatedOpacity(
                  opacity: snapshot.data! > _controller!.minHeight ? 1 : 0,
                  duration: widget.opacityDuration,
                  child: widget.child(context, snapshot.data!),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) =>
      super.debugFillProperties(
        properties
          ..add(
            StringProperty(
              'description',
              'ScanSlider State<ScanSlider>',
            ),
          ),
      );
}
