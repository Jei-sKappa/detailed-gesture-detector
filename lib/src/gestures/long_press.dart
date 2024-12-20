// -----------------------------------------------------------------------------
// Forked from Flutter's original 'src/gestures/long_press.dart' file.
// -----------------------------------------------------------------------------
// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/gestures.dart';

/// Callback signature for [DetailedLongPressGestureRecognizer.onLongPressDown].
///
/// Called when a pointer that might cause a long-press has contacted the
/// screen. The position at which the pointer contacted the screen is available
/// in the `details`.
/// 
/// The `event` is the original [PointerDownEvent] that started the long press.
///
/// See also:
///
///  * [DetailedGestureDetector.onLongPressDown], which matches this signature.
///  * [DetailedGestureLongPressStartCallback], the signature that gets called when the
///    pointer has been in contact with the screen long enough to be considered
///    a long-press.
typedef DetailedGestureLongPressDownCallback = void Function(LongPressDownDetails details, PointerDownEvent event);

/// Callback signature for [DetailedLongPressGestureRecognizer.onLongPressCancel].
///
/// Called when the pointer that previously triggered a
/// [GestureLongPressDownCallback] will not end up causing a long-press.
/// 
/// The `firstEvent` is the original [PointerDownEvent] that started the long press.
/// 
/// The `event` is the [PointerCancelEvent] that caused the long press to be canceled if available.
///
/// See also:
///
///  * [DetailedGestureDetector.onLongPressCancel], which matches this signature.
typedef DetailedGestureLongPressCancelCallback = void Function(PointerDownEvent firstEvent, PointerCancelEvent? event);

/// Callback signature for [DetailedLongPressGestureRecognizer.onLongPress].
///
/// Called when a pointer has remained in contact with the screen at the
/// same location for a long period of time.
///
/// See also:
///
///  * [DetailedGestureDetector.onLongPress], which matches this signature.
///  * [DetailedGestureLongPressStartCallback], which is the same signature but with
///    details of where the long press occurred.
typedef DetailedGestureLongPressCallback = void Function(PointerDownEvent event);

/// Callback signature for [DetailedLongPressGestureRecognizer.onLongPressUp].
///
/// Called when a pointer stops contacting the screen after a long press
/// gesture was detected.
///
/// See also:
///
///  * [DetailedGestureDetector.onLongPressUp], which matches this signature.
typedef DetailedGestureLongPressUpCallback = void Function(PointerDownEvent initialEvent, PointerUpEvent event);

/// Callback signature for [DetailedLongPressGestureRecognizer.onLongPressStart].
///
/// Called when a pointer has remained in contact with the screen at the
/// same location for a long period of time. Also reports the long press down
/// position.
///
/// See also:
///
///  * [DetailedGestureDetector.onLongPressStart], which matches this signature.
///  * [DetailedGestureLongPressCallback], which is the same signature without the
///    details.
typedef DetailedGestureLongPressStartCallback = void Function(LongPressStartDetails details, PointerDownEvent event);

/// Callback signature for [DetailedLongPressGestureRecognizer.onLongPressMoveUpdate].
///
/// Called when a pointer is moving after being held in contact at the same
/// location for a long period of time. Reports the new position and its offset
/// from the original down position.
///
/// See also:
///
///  * [DetailedGestureDetector.onLongPressMoveUpdate], which matches this signature.
typedef DetailedGestureLongPressMoveUpdateCallback = void Function(LongPressMoveUpdateDetails details, PointerDownEvent initialEvent, PointerMoveEvent event);

/// Callback signature for [DetailedLongPressGestureRecognizer.onLongPressEnd].
///
/// Called when a pointer stops contacting the screen after a long press
/// gesture was detected. Also reports the position where the pointer stopped
/// contacting the screen.
///
/// See also:
///
///  * [DetailedGestureDetector.onLongPressEnd], which matches this signature.
typedef DetailedGestureLongPressEndCallback = void Function(LongPressEndDetails details, PointerDownEvent initialEvent, PointerUpEvent event);

/// Recognizes when the user has pressed down at the same location for a long
/// period of time.
///
/// The gesture must not deviate in position from its touch down point for 500ms
/// until it's recognized. Once the gesture is accepted, the finger can be
/// moved, triggering [onLongPressMoveUpdate] callbacks, unless the
/// [postAcceptSlopTolerance] constructor argument is specified.
///
/// [DetailedLongPressGestureRecognizer] may compete on pointer events of
/// [kPrimaryButton], [kSecondaryButton], and/or [kTertiaryButton] if at least
/// one corresponding callback is non-null. If it has no callbacks, it is a no-op.
class DetailedLongPressGestureRecognizer extends PrimaryPointerGestureRecognizer {
  /// Creates a long-press gesture recognizer.
  ///
  /// Consider assigning the [onLongPressStart] callback after creating this
  /// object.
  ///
  /// The [postAcceptSlopTolerance] argument can be used to specify a maximum
  /// allowed distance for the gesture to deviate from the starting point once
  /// the long press has triggered. If the gesture deviates past that point,
  /// subsequent callbacks ([onLongPressMoveUpdate], [onLongPressUp],
  /// [onLongPressEnd]) will stop. Defaults to null, which means the gesture
  /// can be moved without limit once the long press is accepted.
  ///
  /// The [duration] argument can be used to overwrite the default duration
  /// after which the long press will be recognized.
  ///
  /// {@macro flutter.gestures.tap.TapGestureRecognizer.allowedButtonsFilter}
  ///
  /// {@macro flutter.gestures.GestureRecognizer.supportedDevices}
  DetailedLongPressGestureRecognizer({
    Duration? duration,
    super.postAcceptSlopTolerance = null,
    super.supportedDevices,
    super.debugOwner,
    AllowedButtonsFilter? allowedButtonsFilter,
  }) : super(
          deadline: duration ?? kLongPressTimeout,
          allowedButtonsFilter: allowedButtonsFilter ?? _defaultButtonAcceptBehavior,
        );

  bool _longPressAccepted = false;
  OffsetPair? _longPressOrigin;
  // The buttons sent by `PointerDownEvent`. If a `PointerMoveEvent` comes with a
  // different set of buttons, the gesture is canceled.
  int? _initialButtons;

  // The first event that started the long press.
  PointerDownEvent? _initialEvent;

  // Accept the input if, and only if, a single button is pressed.
  static bool _defaultButtonAcceptBehavior(int buttons) =>
      buttons == kPrimaryButton ||
      buttons == kSecondaryButton ||
      buttons == kTertiaryButton;

  /// Called when a pointer has contacted the screen at a particular location
  /// with a primary button, which might be the start of a long-press.
  ///
  /// This triggers after the pointer down event.
  ///
  /// If this recognizer doesn't win the arena, [onLongPressCancel] is called
  /// next. Otherwise, [onLongPressStart] is called next.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  ///  * [onSecondaryLongPressDown], a similar callback but for a secondary button.
  ///  * [onTertiaryLongPressDown], a similar callback but for a tertiary button.
  ///  * [LongPressDownDetails], which is passed as an argument to this callback.
  ///  * [GestureDetector.onLongPressDown], which exposes this callback in a widget.
  DetailedGestureLongPressDownCallback? onLongPressDown;

  /// Called when a pointer that previously triggered [onLongPressDown] will
  /// not end up causing a long-press.
  ///
  /// This triggers once the gesture loses the arena if [onLongPressDown] has
  /// previously been triggered.
  ///
  /// If this recognizer wins the arena, [onLongPressStart] and [onLongPress]
  /// are called instead.
  ///
  /// If the gesture is deactivated due to [postAcceptSlopTolerance] having
  /// been exceeded, this callback will not be called, since the gesture will
  /// have already won the arena at that point.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  DetailedGestureLongPressCancelCallback? onLongPressCancel;

  /// Called when a long press gesture by a primary button has been recognized.
  ///
  /// This is equivalent to (and is called immediately after) [onLongPressStart].
  /// The only difference between the two is that this callback does not
  /// contain details of the position at which the pointer initially contacted
  /// the screen.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  DetailedGestureLongPressCallback? onLongPress;

  /// Called when a long press gesture by a primary button has been recognized.
  ///
  /// This is equivalent to (and is called immediately before) [onLongPress].
  /// The only difference between the two is that this callback contains
  /// details of the position at which the pointer initially contacted the
  /// screen, whereas [onLongPress] does not.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  ///  * [LongPressStartDetails], which is passed as an argument to this callback.
  DetailedGestureLongPressStartCallback? onLongPressStart;

  /// Called when moving after the long press by a primary button is recognized.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  ///  * [LongPressMoveUpdateDetails], which is passed as an argument to this
  ///    callback.
  DetailedGestureLongPressMoveUpdateCallback? onLongPressMoveUpdate;

  /// Called when the pointer stops contacting the screen after a long-press
  /// by a primary button.
  ///
  /// This is equivalent to (and is called immediately after) [onLongPressEnd].
  /// The only difference between the two is that this callback does not
  /// contain details of the state of the pointer when it stopped contacting
  /// the screen.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  DetailedGestureLongPressUpCallback? onLongPressUp;

  /// Called when the pointer stops contacting the screen after a long-press
  /// by a primary button.
  ///
  /// This is equivalent to (and is called immediately before) [onLongPressUp].
  /// The only difference between the two is that this callback contains
  /// details of the state of the pointer when it stopped contacting the
  /// screen, whereas [onLongPressUp] does not.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  ///  * [LongPressEndDetails], which is passed as an argument to this
  ///    callback.
  DetailedGestureLongPressEndCallback? onLongPressEnd;

  /// Called when a pointer has contacted the screen at a particular location
  /// with a secondary button, which might be the start of a long-press.
  ///
  /// This triggers after the pointer down event.
  ///
  /// If this recognizer doesn't win the arena, [onSecondaryLongPressCancel] is
  /// called next. Otherwise, [onSecondaryLongPressStart] is called next.
  ///
  /// See also:
  ///
  ///  * [kSecondaryButton], the button this callback responds to.
  ///  * [onLongPressDown], a similar callback but for a primary button.
  ///  * [onTertiaryLongPressDown], a similar callback but for a tertiary button.
  ///  * [LongPressDownDetails], which is passed as an argument to this callback.
  ///  * [GestureDetector.onSecondaryLongPressDown], which exposes this callback
  ///    in a widget.
  DetailedGestureLongPressDownCallback? onSecondaryLongPressDown;

  /// Called when a pointer that previously triggered [onSecondaryLongPressDown]
  /// will not end up causing a long-press.
  ///
  /// This triggers once the gesture loses the arena if
  /// [onSecondaryLongPressDown] has previously been triggered.
  ///
  /// If this recognizer wins the arena, [onSecondaryLongPressStart] and
  /// [onSecondaryLongPress] are called instead.
  ///
  /// If the gesture is deactivated due to [postAcceptSlopTolerance] having
  /// been exceeded, this callback will not be called, since the gesture will
  /// have already won the arena at that point.
  ///
  /// See also:
  ///
  ///  * [kSecondaryButton], the button this callback responds to.
  DetailedGestureLongPressCancelCallback? onSecondaryLongPressCancel;

  /// Called when a long press gesture by a secondary button has been
  /// recognized.
  ///
  /// This is equivalent to (and is called immediately after)
  /// [onSecondaryLongPressStart]. The only difference between the two is that
  /// this callback does not contain details of the position at which the
  /// pointer initially contacted the screen.
  ///
  /// See also:
  ///
  ///  * [kSecondaryButton], the button this callback responds to.
  DetailedGestureLongPressCallback? onSecondaryLongPress;

  /// Called when a long press gesture by a secondary button has been recognized.
  ///
  /// This is equivalent to (and is called immediately before)
  /// [onSecondaryLongPress]. The only difference between the two is that this
  /// callback contains details of the position at which the pointer initially
  /// contacted the screen, whereas [onSecondaryLongPress] does not.
  ///
  /// See also:
  ///
  ///  * [kSecondaryButton], the button this callback responds to.
  ///  * [LongPressStartDetails], which is passed as an argument to this
  ///    callback.
  DetailedGestureLongPressStartCallback? onSecondaryLongPressStart;

  /// Called when moving after the long press by a secondary button is
  /// recognized.
  ///
  /// See also:
  ///
  ///  * [kSecondaryButton], the button this callback responds to.
  ///  * [LongPressMoveUpdateDetails], which is passed as an argument to this
  ///    callback.
  DetailedGestureLongPressMoveUpdateCallback? onSecondaryLongPressMoveUpdate;

  /// Called when the pointer stops contacting the screen after a long-press by
  /// a secondary button.
  ///
  /// This is equivalent to (and is called immediately after)
  /// [onSecondaryLongPressEnd]. The only difference between the two is that
  /// this callback does not contain details of the state of the pointer when
  /// it stopped contacting the screen.
  ///
  /// See also:
  ///
  ///  * [kSecondaryButton], the button this callback responds to.
  DetailedGestureLongPressUpCallback? onSecondaryLongPressUp;

  /// Called when the pointer stops contacting the screen after a long-press by
  /// a secondary button.
  ///
  /// This is equivalent to (and is called immediately before)
  /// [onSecondaryLongPressUp]. The only difference between the two is that
  /// this callback contains details of the state of the pointer when it
  /// stopped contacting the screen, whereas [onSecondaryLongPressUp] does not.
  ///
  /// See also:
  ///
  ///  * [kSecondaryButton], the button this callback responds to.
  ///  * [LongPressEndDetails], which is passed as an argument to this callback.
  DetailedGestureLongPressEndCallback? onSecondaryLongPressEnd;

  /// Called when a pointer has contacted the screen at a particular location
  /// with a tertiary button, which might be the start of a long-press.
  ///
  /// This triggers after the pointer down event.
  ///
  /// If this recognizer doesn't win the arena, [onTertiaryLongPressCancel] is
  /// called next. Otherwise, [onTertiaryLongPressStart] is called next.
  ///
  /// See also:
  ///
  ///  * [kTertiaryButton], the button this callback responds to.
  ///  * [onLongPressDown], a similar callback but for a primary button.
  ///  * [onSecondaryLongPressDown], a similar callback but for a secondary button.
  ///  * [LongPressDownDetails], which is passed as an argument to this callback.
  ///  * [GestureDetector.onTertiaryLongPressDown], which exposes this callback
  ///    in a widget.
  DetailedGestureLongPressDownCallback? onTertiaryLongPressDown;

  /// Called when a pointer that previously triggered [onTertiaryLongPressDown]
  /// will not end up causing a long-press.
  ///
  /// This triggers once the gesture loses the arena if
  /// [onTertiaryLongPressDown] has previously been triggered.
  ///
  /// If this recognizer wins the arena, [onTertiaryLongPressStart] and
  /// [onTertiaryLongPress] are called instead.
  ///
  /// If the gesture is deactivated due to [postAcceptSlopTolerance] having
  /// been exceeded, this callback will not be called, since the gesture will
  /// have already won the arena at that point.
  ///
  /// See also:
  ///
  ///  * [kTertiaryButton], the button this callback responds to.
  DetailedGestureLongPressCancelCallback? onTertiaryLongPressCancel;

  /// Called when a long press gesture by a tertiary button has been
  /// recognized.
  ///
  /// This is equivalent to (and is called immediately after)
  /// [onTertiaryLongPressStart]. The only difference between the two is that
  /// this callback does not contain details of the position at which the
  /// pointer initially contacted the screen.
  ///
  /// See also:
  ///
  ///  * [kTertiaryButton], the button this callback responds to.
  DetailedGestureLongPressCallback? onTertiaryLongPress;

  /// Called when a long press gesture by a tertiary button has been recognized.
  ///
  /// This is equivalent to (and is called immediately before)
  /// [onTertiaryLongPress]. The only difference between the two is that this
  /// callback contains details of the position at which the pointer initially
  /// contacted the screen, whereas [onTertiaryLongPress] does not.
  ///
  /// See also:
  ///
  ///  * [kTertiaryButton], the button this callback responds to.
  ///  * [LongPressStartDetails], which is passed as an argument to this
  ///    callback.
  DetailedGestureLongPressStartCallback? onTertiaryLongPressStart;

  /// Called when moving after the long press by a tertiary button is
  /// recognized.
  ///
  /// See also:
  ///
  ///  * [kTertiaryButton], the button this callback responds to.
  ///  * [LongPressMoveUpdateDetails], which is passed as an argument to this
  ///    callback.
  DetailedGestureLongPressMoveUpdateCallback? onTertiaryLongPressMoveUpdate;

  /// Called when the pointer stops contacting the screen after a long-press by
  /// a tertiary button.
  ///
  /// This is equivalent to (and is called immediately after)
  /// [onTertiaryLongPressEnd]. The only difference between the two is that
  /// this callback does not contain details of the state of the pointer when
  /// it stopped contacting the screen.
  ///
  /// See also:
  ///
  ///  * [kTertiaryButton], the button this callback responds to.
  DetailedGestureLongPressUpCallback? onTertiaryLongPressUp;

  /// Called when the pointer stops contacting the screen after a long-press by
  /// a tertiary button.
  ///
  /// This is equivalent to (and is called immediately before)
  /// [onTertiaryLongPressUp]. The only difference between the two is that
  /// this callback contains details of the state of the pointer when it
  /// stopped contacting the screen, whereas [onTertiaryLongPressUp] does not.
  ///
  /// See also:
  ///
  ///  * [kTertiaryButton], the button this callback responds to.
  ///  * [LongPressEndDetails], which is passed as an argument to this callback.
  DetailedGestureLongPressEndCallback? onTertiaryLongPressEnd;

  VelocityTracker? _velocityTracker;

  @override
  bool isPointerAllowed(PointerDownEvent event) {
    switch (event.buttons) {
      case kPrimaryButton:
        if (onLongPressDown == null &&
            onLongPressCancel == null &&
            onLongPressStart == null &&
            onLongPress == null &&
            onLongPressMoveUpdate == null &&
            onLongPressEnd == null &&
            onLongPressUp == null) {
          return false;
        }
      case kSecondaryButton:
        if (onSecondaryLongPressDown == null &&
            onSecondaryLongPressCancel == null &&
            onSecondaryLongPressStart == null &&
            onSecondaryLongPress == null &&
            onSecondaryLongPressMoveUpdate == null &&
            onSecondaryLongPressEnd == null &&
            onSecondaryLongPressUp == null) {
          return false;
        }
      case kTertiaryButton:
        if (onTertiaryLongPressDown == null &&
            onTertiaryLongPressCancel == null &&
            onTertiaryLongPressStart == null &&
            onTertiaryLongPress == null &&
            onTertiaryLongPressMoveUpdate == null &&
            onTertiaryLongPressEnd == null &&
            onTertiaryLongPressUp == null) {
          return false;
        }
      default:
        return false;
    }
    return super.isPointerAllowed(event);
  }

  @override
  void didExceedDeadline() {
    // Exceeding the deadline puts the gesture in the accepted state.
    resolve(GestureDisposition.accepted);
    _longPressAccepted = true;
    super.acceptGesture(primaryPointer!);
    _checkLongPressStart();
  }

  @override
  void handlePrimaryPointer(PointerEvent event) {
    if (!event.synthesized) {
      if (event is PointerDownEvent) {
        _velocityTracker = VelocityTracker.withKind(event.kind);
        _velocityTracker!.addPosition(event.timeStamp, event.localPosition);
      }
      if (event is PointerMoveEvent) {
        assert(_velocityTracker != null);
        _velocityTracker!.addPosition(event.timeStamp, event.localPosition);
      }
    }

    if (event is PointerUpEvent) {
      if (_longPressAccepted) {
        _checkLongPressEnd(event);
      } else {
        // Pointer is lifted before timeout.
        resolve(GestureDisposition.rejected);
      }
      _reset();
    } else if (event is PointerCancelEvent) {
      _checkLongPressCancel(event);
      _reset();
    } else if (event is PointerDownEvent) {
      // The first touch.
      _longPressOrigin = OffsetPair.fromEventPosition(event);
      _initialButtons = event.buttons;
      _initialEvent = event;
      _checkLongPressDown(event);
    } else if (event is PointerMoveEvent) {
      if (event.buttons != _initialButtons && !_longPressAccepted) {
        resolve(GestureDisposition.rejected);
        stopTrackingPointer(primaryPointer!);
      } else if (_longPressAccepted) {
        _checkLongPressMoveUpdate(event);
      }
    }
  }

  void _checkLongPressDown(PointerDownEvent event) {
    assert(_longPressOrigin != null);
    final LongPressDownDetails details = LongPressDownDetails(
      globalPosition: _longPressOrigin!.global,
      localPosition: _longPressOrigin!.local,
      kind: getKindForPointer(event.pointer),
    );
    switch (_initialButtons) {
      case kPrimaryButton:
        if (onLongPressDown != null) {
          invokeCallback<void>('onLongPressDown', () => onLongPressDown!(details, event));
        }
      case kSecondaryButton:
        if (onSecondaryLongPressDown != null) {
          invokeCallback<void>('onSecondaryLongPressDown', () => onSecondaryLongPressDown!(details, event));
        }
      case kTertiaryButton:
        if (onTertiaryLongPressDown != null) {
          invokeCallback<void>('onTertiaryLongPressDown', () => onTertiaryLongPressDown!(details, event));
        }
      default:
        assert(false, 'Unhandled button $_initialButtons');
    }
  }

  void _checkLongPressCancel(PointerCancelEvent? event) {
    if (state == GestureRecognizerState.possible) {
      switch (_initialButtons) {
        case kPrimaryButton:
          if (onLongPressCancel != null) {
            invokeCallback<void>('onLongPressCancel', () => onLongPressCancel!(_initialEvent!, event));
          }
        case kSecondaryButton:
          if (onSecondaryLongPressCancel != null) {
            invokeCallback<void>('onSecondaryLongPressCancel', () => onSecondaryLongPressCancel!(_initialEvent!, event));
          }
        case kTertiaryButton:
          if (onTertiaryLongPressCancel != null) {
            invokeCallback<void>('onTertiaryLongPressCancel', () => onTertiaryLongPressCancel!(_initialEvent!, event));
          }
        default:
          assert(false, 'Unhandled button $_initialButtons');
      }
    }
  }

  void _checkLongPressStart() {
    switch (_initialButtons) {
      case kPrimaryButton:
        if (onLongPressStart != null) {
          final LongPressStartDetails details = LongPressStartDetails(
            globalPosition: _longPressOrigin!.global,
            localPosition: _longPressOrigin!.local,
          );
          invokeCallback<void>('onLongPressStart', () => onLongPressStart!(details, _initialEvent!));
        }
        if (onLongPress != null) {
          invokeCallback<void>('onLongPress', () => onLongPress!(_initialEvent!));
        }
      case kSecondaryButton:
        if (onSecondaryLongPressStart != null) {
          final LongPressStartDetails details = LongPressStartDetails(
            globalPosition: _longPressOrigin!.global,
            localPosition: _longPressOrigin!.local,
          );
          invokeCallback<void>('onSecondaryLongPressStart', () => onSecondaryLongPressStart!(details, _initialEvent!));
        }
        if (onSecondaryLongPress != null) {
          invokeCallback<void>('onSecondaryLongPress', () => onSecondaryLongPress!(_initialEvent!));
        }
      case kTertiaryButton:
        if (onTertiaryLongPressStart != null) {
          final LongPressStartDetails details = LongPressStartDetails(
            globalPosition: _longPressOrigin!.global,
            localPosition: _longPressOrigin!.local,
          );
          invokeCallback<void>('onTertiaryLongPressStart', () => onTertiaryLongPressStart!(details, _initialEvent!));
        }
        if (onTertiaryLongPress != null) {
          invokeCallback<void>('onTertiaryLongPress', () => onTertiaryLongPress!(_initialEvent!));
        }
      default:
        assert(false, 'Unhandled button $_initialButtons');
    }
  }

  void _checkLongPressMoveUpdate(PointerMoveEvent event) {
    final LongPressMoveUpdateDetails details = LongPressMoveUpdateDetails(
      globalPosition: event.position,
      localPosition: event.localPosition,
      offsetFromOrigin: event.position - _longPressOrigin!.global,
      localOffsetFromOrigin: event.localPosition - _longPressOrigin!.local,
    );
    switch (_initialButtons) {
      case kPrimaryButton:
        if (onLongPressMoveUpdate != null) {
          invokeCallback<void>('onLongPressMoveUpdate', () => onLongPressMoveUpdate!(details, _initialEvent!, event));
        }
      case kSecondaryButton:
        if (onSecondaryLongPressMoveUpdate != null) {
          invokeCallback<void>('onSecondaryLongPressMoveUpdate', () => onSecondaryLongPressMoveUpdate!(details, _initialEvent!, event));
        }
      case kTertiaryButton:
        if (onTertiaryLongPressMoveUpdate != null) {
          invokeCallback<void>('onTertiaryLongPressMoveUpdate', () => onTertiaryLongPressMoveUpdate!(details, _initialEvent!, event));
        }
      default:
        assert(false, 'Unhandled button $_initialButtons');
    }
  }

  void _checkLongPressEnd(PointerUpEvent event) {
    final VelocityEstimate? estimate = _velocityTracker!.getVelocityEstimate();
    final Velocity velocity = estimate == null
        ? Velocity.zero
        : Velocity(pixelsPerSecond: estimate.pixelsPerSecond);
    final LongPressEndDetails details = LongPressEndDetails(
      globalPosition: event.position,
      localPosition: event.localPosition,
      velocity: velocity,
    );

    _velocityTracker = null;
    switch (_initialButtons) {
      case kPrimaryButton:
        if (onLongPressEnd != null) {
          invokeCallback<void>('onLongPressEnd', () => onLongPressEnd!(details, _initialEvent!, event));
        }
        if (onLongPressUp != null) {
          invokeCallback<void>('onLongPressUp', () => onLongPressUp!(_initialEvent!, event));
        }
      case kSecondaryButton:
        if (onSecondaryLongPressEnd != null) {
          invokeCallback<void>('onSecondaryLongPressEnd', () => onSecondaryLongPressEnd!(details, _initialEvent!, event));
        }
        if (onSecondaryLongPressUp != null) {
          invokeCallback<void>('onSecondaryLongPressUp', () => onSecondaryLongPressUp!(_initialEvent!, event));
        }
      case kTertiaryButton:
        if (onTertiaryLongPressEnd != null) {
          invokeCallback<void>('onTertiaryLongPressEnd', () => onTertiaryLongPressEnd!(details, _initialEvent!, event));
        }
        if (onTertiaryLongPressUp != null) {
          invokeCallback<void>('onTertiaryLongPressUp', () => onTertiaryLongPressUp!(_initialEvent!, event));
        }
      default:
        assert(false, 'Unhandled button $_initialButtons');
    }
  }

  void _reset() {
    _longPressAccepted = false;
    _longPressOrigin = null;
    _initialButtons = null;
    _initialEvent = null;
    _velocityTracker = null;
  }

  @override
  void resolve(GestureDisposition disposition) {
    if (disposition == GestureDisposition.rejected) {
      if (_longPressAccepted) {
        // This can happen if the gesture has been canceled. For example when
        // the buttons have changed.
        _reset();
      } else {
        _checkLongPressCancel(null);
      }
    }
    super.resolve(disposition);
  }

  @override
  void acceptGesture(int pointer) {
    // Winning the arena isn't important here since it may happen from a sweep.
    // Explicitly exceeding the deadline puts the gesture in accepted state.
  }

  @override
  String get debugDescription => 'long press';
}
