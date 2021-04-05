import 'dart:async';

import 'package:drop_slider/src/base/base_controller.dart';
import 'package:drop_slider/src/base/constants.dart';
import 'package:flutter/services.dart';

class DropSwipeController extends BaseDropSwipeController {
  final _dropSwipeController = StreamController<double>.broadcast();
  Timer? _timer;

  DropSwipeController({
    HapticFeedbackType feedbackType = HapticFeedbackType.light,
    double position = 0,
    double animateHeight = 50,
    double minimumHeight = 50,
    Duration reverseDuration = const Duration(milliseconds: 30),
  }) : super(
          feedbackType,
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
        createHapticFeedback();
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

  @override
  void createHapticFeedback() {
    switch (feedbackType) {
      case HapticFeedbackType.light:
        HapticFeedback.lightImpact();
        break;
      case HapticFeedbackType.medium:
        HapticFeedback.mediumImpact();
        break;
      case HapticFeedbackType.heavy:
        HapticFeedback.heavyImpact();
        break;
      case HapticFeedbackType.selection:
        HapticFeedback.selectionClick();
        break;
      default:
        break;
    }
  }
}
