// @dart=2.12
import 'dart:async';

import 'package:drop_slider/src/base/base_controller.dart';

class DropSwipeController extends BaseDropSwipeController {
  final _dropSwipeController = StreamController<double>.broadcast();
  Timer? _timer;

  DropSwipeController({
    double position = 0,
    double animateHeight = 50,
    double minimumHeight = 50,
    Duration reverseDuration = const Duration(milliseconds: 30),
  }) : super(
          position,
          animateHeight,
          reverseDuration,
          minimumHeight,
        );

  Stream<double> get stream => _dropSwipeController.stream;

  void jumpTo(double position) {
    this.position = position;
    _dropSwipeController.sink.add(position);
  }

  void animateTo(double position, {Duration? duration}) {
    _timer = Timer.periodic(duration ?? reverseDuration, (timer) {
      if (this.position < animateHeight) {
        jumpTo(0);
        timer.cancel();
      } else {
        jumpTo(this.position - animateHeight);
      }
    });
  }

  @override
  void reverse() => animateTo(0);

  void dispose() {
    _dropSwipeController.close();
    _timer?.cancel();
  }
}
