// -----------------------------------------------------------------------------
// Forked from Flutter's original 'src/gestures/tap.dart' file.
// -----------------------------------------------------------------------------
// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

/// {@template gestures.tap.DetailedGestureTapDownCallback}
/// Signature for when a pointer that might cause a tap has contacted the
/// screen.
///
/// The position at which the pointer contacted the screen is available in the
/// `details`.
/// The raw pointer event is available in the `pointerDownEvent`.
/// {@endtemplate}
///
/// See also:
///
///  * [DetailedGestureDetector.onTapDown], which matches this signature.
///  * [DetailedTapGestureRecognizer], which uses this signature in one of its callbacks.
typedef DetailedGestureTapDownCallback = void Function(TapDownDetails details, PointerDownEvent pointerDownEvent);

/// {@template gestures.tap.DetailedGestureTapUpCallback}
/// Signature for when a pointer that will trigger a tap has stopped contacting
/// the screen.
///
/// The position at which the pointer stopped contacting the screen is available
/// in the `details`.
/// The raw pointer events are available in the `pointerDownEvent` and
/// `pointerUpEvent`.
/// {@endtemplate}
///
/// See also:
///
///  * [DetailedGestureDetector.onTapUp], which matches this signature.
///  * [DetailedTapGestureRecognizer], which uses this signature in one of its callbacks.
typedef DetailedGestureTapUpCallback = void Function(TapUpDetails details, PointerDownEvent pointerDownEvent, PointerUpEvent pointerUpEvent);

/// Signature for when a tap has occurred.
///
/// The raw pointer events are available in the `pointerDownEvent` and
/// `pointerUpEvent`.
///
/// See also:
///
///  * [DetailedGestureDetector.onTap], which matches this signature.
///  * [DetailedTapGestureRecognizer], which uses this signature in one of its callbacks.
typedef DetailedGestureTapCallback = void Function(PointerDownEvent pointerDownEvent, PointerUpEvent pointerUpEvent);

/// Signature for when the pointer that previously triggered a
/// [GestureTapDownCallback] will not end up causing a tap.
///
/// The raw pointer down event is available in the `pointerDownEvent`.
/// The raw pointer cancel event is available in the `cancel` when available.
/// The reason for the cancel is available in the `reason`.
///
/// See also:
///
///  * [DetailedGestureDetector.onTapCancel], which matches this signature.
///  * [DetailedTapGestureRecognizer], which uses this signature in one of its callbacks.
typedef DetailedGestureTapCancelCallback = void Function(PointerDownEvent pointerDownEvent, PointerCancelEvent? cancelEvent, String reason);

/// Recognizes taps.
///
/// Gesture recognizers take part in gesture arenas to enable potential gestures
/// to be disambiguated from each other. This process is managed by a
/// [GestureArenaManager].
///
/// [DetailedTapGestureRecognizer] considers all the pointers involved in the pointer
/// event sequence as contributing to one gesture. For this reason, extra
/// pointer interactions during a tap sequence are not recognized as additional
/// taps. For example, down-1, down-2, up-1, up-2 produces only one tap on up-1.
///
/// [DetailedTapGestureRecognizer] competes on pointer events of [kPrimaryButton] only
/// when it has at least one non-null `onTap*` callback, on events of
/// [kSecondaryButton] only when it has at least one non-null `onSecondaryTap*`
/// callback, and on events of [kTertiaryButton] only when it has at least
/// one non-null `onTertiaryTap*` callback. If it has no callbacks, it is a
/// no-op.
///
/// {@template gestures.tap.DetailedTapGestureRecognizer.allowedButtonsFilter}
/// The [allowedButtonsFilter] argument only gives this recognizer the
/// ability to limit the buttons it accepts. It does not provide the
/// ability to recognize any buttons beyond the ones it already accepts:
/// kPrimaryButton, kSecondaryButton or kTertiaryButton. Therefore, a
/// combined value of `kPrimaryButton & kSecondaryButton` would be ignored,
/// but `kPrimaryButton | kSecondaryButton` would be allowed, as long as
/// only one of them is selected at a time.
/// {@endtemplate}
///
/// See also:
///
///  * [DetailedGestureDetector.onTap], which uses this recognizer.
///  * [MultiTapGestureRecognizer]
class DetailedTapGestureRecognizer extends BaseTapGestureRecognizer {
  /// Creates a tap gesture recognizer.
  DetailedTapGestureRecognizer({
    super.debugOwner,
    super.supportedDevices,
    super.allowedButtonsFilter,
  });

  /// {@template gestures.tap.DetailedTapGestureRecognizer.onTapDown}
  /// A pointer has contacted the screen at a particular location with a primary
  /// button, which might be the start of a tap.
  /// {@endtemplate}
  ///
  /// This triggers after the down event, once a short timeout ([deadline]) has
  /// elapsed, or once the gestures has won the arena, whichever comes first.
  ///
  /// If this recognizer doesn't win the arena, [onTapCancel] is called next.
  /// Otherwise, [onTapUp] is called next.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  ///  * [onSecondaryTapDown], a similar callback but for a secondary button.
  ///  * [onTertiaryTapDown], a similar callback but for a tertiary button.
  ///  * [TapDownDetails], which is passed as an argument to this callback.
  ///  * [DetailedGestureDetector.onTapDown], which exposes this callback.
  DetailedGestureTapDownCallback? onTapDown;

  /// {@template gestures.tap.DetailedTapGestureRecognizer.onTapUp}
  /// A pointer has stopped contacting the screen at a particular location,
  /// which is recognized as a tap of a primary button.
  /// {@endtemplate}
  ///
  /// This triggers on the up event, if the recognizer wins the arena with it
  /// or has previously won, immediately followed by [onTap].
  ///
  /// If this recognizer doesn't win the arena, [onTapCancel] is called instead.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  ///  * [onSecondaryTapUp], a similar callback but for a secondary button.
  ///  * [onTertiaryTapUp], a similar callback but for a tertiary button.
  ///  * [TapUpDetails], which is passed as an argument to this callback.
  ///  * [DetailedGestureDetector.onTapUp], which exposes this callback.
  DetailedGestureTapUpCallback? onTapUp;

  /// A pointer has stopped contacting the screen, which is recognized as a tap
  /// of a primary button.
  ///
  /// This triggers on the up event, if the recognizer wins the arena with it
  /// or has previously won, immediately following [onTapUp].
  ///
  /// If this recognizer doesn't win the arena, [onTapCancel] is called instead.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  ///  * [onSecondaryTap], a similar callback but for a secondary button.
  ///  * [onTapUp], which has the same timing but with details.
  ///  * [DetailedGestureDetector.onTap], which exposes this callback.
  DetailedGestureTapCallback? onTap;

  /// {@template gestures.tap.DetailedTapGestureRecognizer.onTapCancel}
  /// A pointer that previously triggered [onTapDown] will not end up causing
  /// a tap.
  /// {@endtemplate}
  ///
  /// This triggers once the gesture loses the arena if [onTapDown] has
  /// previously been triggered.
  ///
  /// If this recognizer wins the arena, [onTapUp] and [onTap] are called
  /// instead.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  ///  * [onSecondaryTapCancel], a similar callback but for a secondary button.
  ///  * [onTertiaryTapCancel], a similar callback but for a tertiary button.
  ///  * [DetailedGestureDetector.onTapCancel], which exposes this callback.
  DetailedGestureTapCancelCallback? onTapCancel;

  /// {@template gestures.tap.DetailedTapGestureRecognizer.onSecondaryTap}
  /// A pointer has stopped contacting the screen, which is recognized as a tap
  /// of a secondary button.
  /// {@endtemplate}
  ///
  /// This triggers on the up event, if the recognizer wins the arena with it or
  /// has previously won, immediately following [onSecondaryTapUp].
  ///
  /// If this recognizer doesn't win the arena, [onSecondaryTapCancel] is called
  /// instead.
  ///
  /// See also:
  ///
  ///  * [kSecondaryButton], the button this callback responds to.
  ///  * [onSecondaryTapUp], which has the same timing but with details.
  ///  * [DetailedGestureDetector.onSecondaryTap], which exposes this callback.
  DetailedGestureTapCallback? onSecondaryTap;

  /// {@template gestures.tap.DetailedTapGestureRecognizer.onSecondaryTapDown}
  /// A pointer has contacted the screen at a particular location with a
  /// secondary button, which might be the start of a secondary tap.
  /// {@endtemplate}
  ///
  /// This triggers after the down event, once a short timeout ([deadline]) has
  /// elapsed, or once the gestures has won the arena, whichever comes first.
  ///
  /// If this recognizer doesn't win the arena, [onSecondaryTapCancel] is called
  /// next. Otherwise, [onSecondaryTapUp] is called next.
  ///
  /// See also:
  ///
  ///  * [kSecondaryButton], the button this callback responds to.
  ///  * [onTapDown], a similar callback but for a primary button.
  ///  * [onTertiaryTapDown], a similar callback but for a tertiary button.
  ///  * [TapDownDetails], which is passed as an argument to this callback.
  ///  * [DetailedGestureDetector.onSecondaryTapDown], which exposes this callback.
  DetailedGestureTapDownCallback? onSecondaryTapDown;

  /// {@template gestures.tap.DetailedTapGestureRecognizer.onSecondaryTapUp}
  /// A pointer has stopped contacting the screen at a particular location,
  /// which is recognized as a tap of a secondary button.
  /// {@endtemplate}
  ///
  /// This triggers on the up event if the recognizer wins the arena with it
  /// or has previously won.
  ///
  /// If this recognizer doesn't win the arena, [onSecondaryTapCancel] is called
  /// instead.
  ///
  /// See also:
  ///
  ///  * [onSecondaryTap], a handler triggered right after this one that doesn't
  ///    pass any details about the tap.
  ///  * [kSecondaryButton], the button this callback responds to.
  ///  * [onTapUp], a similar callback but for a primary button.
  ///  * [onTertiaryTapUp], a similar callback but for a tertiary button.
  ///  * [TapUpDetails], which is passed as an argument to this callback.
  ///  * [DetailedGestureDetector.onSecondaryTapUp], which exposes this callback.
  DetailedGestureTapUpCallback? onSecondaryTapUp;

  /// {@template gestures.tap.DetailedTapGestureRecognizer.onSecondaryTapCancel}
  /// A pointer that previously triggered [onSecondaryTapDown] will not end up
  /// causing a tap.
  /// {@endtemplate}
  ///
  /// This triggers once the gesture loses the arena if [onSecondaryTapDown]
  /// has previously been triggered.
  ///
  /// If this recognizer wins the arena, [onSecondaryTapUp] is called instead.
  ///
  /// See also:
  ///
  ///  * [kSecondaryButton], the button this callback responds to.
  ///  * [onTapCancel], a similar callback but for a primary button.
  ///  * [onTertiaryTapCancel], a similar callback but for a tertiary button.
  ///  * [DetailedGestureDetector.onSecondaryTapCancel], which exposes this callback.
  DetailedGestureTapCancelCallback? onSecondaryTapCancel;

  /// A pointer has contacted the screen at a particular location with a
  /// tertiary button, which might be the start of a tertiary tap.
  ///
  /// This triggers after the down event, once a short timeout ([deadline]) has
  /// elapsed, or once the gestures has won the arena, whichever comes first.
  ///
  /// If this recognizer doesn't win the arena, [onTertiaryTapCancel] is called
  /// next. Otherwise, [onTertiaryTapUp] is called next.
  ///
  /// See also:
  ///
  ///  * [kTertiaryButton], the button this callback responds to.
  ///  * [onTapDown], a similar callback but for a primary button.
  ///  * [onSecondaryTapDown], a similar callback but for a secondary button.
  ///  * [TapDownDetails], which is passed as an argument to this callback.
  ///  * [DetailedGestureDetector.onTertiaryTapDown], which exposes this callback.
  DetailedGestureTapDownCallback? onTertiaryTapDown;

  /// A pointer has stopped contacting the screen at a particular location,
  /// which is recognized as a tap of a tertiary button.
  ///
  /// This triggers on the up event if the recognizer wins the arena with it
  /// or has previously won.
  ///
  /// If this recognizer doesn't win the arena, [onTertiaryTapCancel] is called
  /// instead.
  ///
  /// See also:
  ///
  ///  * [kTertiaryButton], the button this callback responds to.
  ///  * [onTapUp], a similar callback but for a primary button.
  ///  * [onSecondaryTapUp], a similar callback but for a secondary button.
  ///  * [TapUpDetails], which is passed as an argument to this callback.
  ///  * [DetailedGestureDetector.onTertiaryTapUp], which exposes this callback.
  DetailedGestureTapUpCallback? onTertiaryTapUp;

  /// A pointer that previously triggered [onTertiaryTapDown] will not end up
  /// causing a tap.
  ///
  /// This triggers once the gesture loses the arena if [onTertiaryTapDown]
  /// has previously been triggered.
  ///
  /// If this recognizer wins the arena, [onTertiaryTapUp] is called instead.
  ///
  /// See also:
  ///
  ///  * [kSecondaryButton], the button this callback responds to.
  ///  * [onTapCancel], a similar callback but for a primary button.
  ///  * [onSecondaryTapCancel], a similar callback but for a secondary button.
  ///  * [DetailedGestureDetector.onTertiaryTapCancel], which exposes this callback.
  DetailedGestureTapCancelCallback? onTertiaryTapCancel;

  @override
  bool isPointerAllowed(PointerDownEvent event) {
    switch (event.buttons) {
      case kPrimaryButton:
        if (onTapDown == null &&
            onTap == null &&
            onTapUp == null &&
            onTapCancel == null) {
          return false;
        }
      case kSecondaryButton:
        if (onSecondaryTap == null &&
            onSecondaryTapDown == null &&
            onSecondaryTapUp == null &&
            onSecondaryTapCancel == null) {
          return false;
        }
      case kTertiaryButton:
        if (onTertiaryTapDown == null &&
            onTertiaryTapUp == null &&
            onTertiaryTapCancel == null) {
          return false;
        }
      default:
        return false;
    }
    return super.isPointerAllowed(event);
  }

  @protected
  @override
  void handleTapDown({required PointerDownEvent down}) {
    final TapDownDetails details = TapDownDetails(
      globalPosition: down.position,
      localPosition: down.localPosition,
      kind: getKindForPointer(down.pointer),
    );
    switch (down.buttons) {
      case kPrimaryButton:
        if (onTapDown != null) {
          invokeCallback<void>('onTapDown', () => onTapDown!(details, down));
        }
      case kSecondaryButton:
        if (onSecondaryTapDown != null) {
          invokeCallback<void>(
              'onSecondaryTapDown', () => onSecondaryTapDown!(details, down));
        }
      case kTertiaryButton:
        if (onTertiaryTapDown != null) {
          invokeCallback<void>(
              'onTertiaryTapDown', () => onTertiaryTapDown!(details, down));
        }
      default:
    }
  }

  @protected
  @override
  void handleTapUp(
      {required PointerDownEvent down, required PointerUpEvent up}) {
    final TapUpDetails details = TapUpDetails(
      kind: up.kind,
      globalPosition: up.position,
      localPosition: up.localPosition,
    );
    switch (down.buttons) {
      case kPrimaryButton:
        if (onTapUp != null) {
          invokeCallback<void>('onTapUp', () => onTapUp!(details, down, up));
        }
        if (onTap != null) {
          invokeCallback<void>('onTap', () => onTap!(down, up));
        }
      case kSecondaryButton:
        if (onSecondaryTapUp != null) {
          invokeCallback<void>(
              'onSecondaryTapUp', () => onSecondaryTapUp!(details, down, up));
        }
        if (onSecondaryTap != null) {
          invokeCallback<void>(
              'onSecondaryTap', () => onSecondaryTap!(down, up));
        }
      case kTertiaryButton:
        if (onTertiaryTapUp != null) {
          invokeCallback<void>(
              'onTertiaryTapUp', () => onTertiaryTapUp!(details, down, up));
        }
      default:
    }
  }

  @protected
  @override
  void handleTapCancel({required PointerDownEvent down, PointerCancelEvent? cancel, required String reason}) {
    final String note = reason == '' ? reason : '$reason ';
    switch (down.buttons) {
      case kPrimaryButton:
        if (onTapCancel != null) {
          invokeCallback<void>('${note}onTapCancel', () => onTapCancel!(down, cancel, reason));
        }
      case kSecondaryButton:
        if (onSecondaryTapCancel != null) {
          invokeCallback<void>('${note}onSecondaryTapCancel', () => onSecondaryTapCancel!(down, cancel, reason));
        }
      case kTertiaryButton:
        if (onTertiaryTapCancel != null) {
          invokeCallback<void>('${note}onTertiaryTapCancel', () => onTertiaryTapCancel!(down, cancel, reason));
        }
      default:
    }
  }

  @override
  String get debugDescription => 'tap';
}
