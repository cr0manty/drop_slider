import 'dart:async';

import 'package:drop_slider/src/base/constants.dart';
import 'package:flutter/foundation.dart';

abstract class BaseDropSwipeController {
  /// Initial position of drop swipe element
  double position;

  /// Reverse animate step
  final double _animateHeight;

  /// The minimum height after which the swipe widget will appear
  final double _minHeight;

  /// Reverse animation duration
  /// after this time timer will called
  /// to reduce drop swipe widget height
  final Duration _reverseDuration;

  /// Haptic feedback type
  /// use default flutter impact [HapticFeedback]
  final HapticFeedbackType feedbackType;

  /// base constructor to init
  /// reverse animation duration
  /// reverse animation height
  /// initial switch widget position
  @mustCallSuper
  BaseDropSwipeController(
    this.feedbackType,
    this.position,
    this._animateHeight,
    this._reverseDuration,
    this._minHeight,
  );

  /// Public access to stream
  Stream<double> get stream;

  /// Public access to animated height
  double get animateHeight => _animateHeight;

  /// Public access to current position
  double get currentPosition => position;

  /// Public access to minimal height to make action
  double get minHeight => _minHeight;

  /// Public access to reverse duration
  Duration get reverseDuration => _reverseDuration;

  // Swipe to position without animation
  void jumpTo(double position);

  // Swipe to minimal height
  void reverse();

  /// Swipe to position with Animation
  void animateTo(double position, {Duration duration});

  /// Make haptic feedback based on the set type
  void createHapticFeedback();

  /// must be called to close stream
  void dispose();
}
