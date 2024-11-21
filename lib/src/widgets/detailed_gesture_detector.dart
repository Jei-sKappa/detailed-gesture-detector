// -----------------------------------------------------------------------------
// Forked from Flutter's original 'src/widgets/gesture_detector.dart' file.
// -----------------------------------------------------------------------------
// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:detailed_gesture_detector/src/gestures/gestures.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// **Copied from Flutter's default [GestureDetector] class.**
///
/// A widget that detects gestures.
///
/// Attempts to recognize gestures that correspond to its non-null callbacks.
///
/// If this widget has a child, it defers to that child for its sizing behavior.
/// If it does not have a child, it grows to fit the parent instead.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=WhVXkCFPmK4}
///
/// By default a GestureDetector with an invisible child ignores touches;
/// this behavior can be controlled with [behavior].
///
/// GestureDetector also listens for accessibility events and maps
/// them to the callbacks. To ignore accessibility events, set
/// [excludeFromSemantics] to true.
///
/// See <http://flutter.dev/gestures/> for additional information.
///
/// Material design applications typically react to touches with ink splash
/// effects. The [InkWell] class implements this effect and can be used in place
/// of a [GestureDetector] for handling taps.
///
/// {@tool dartpad}
/// This example contains a black light bulb wrapped in a [GestureDetector]. It
/// turns the light bulb yellow when the "TURN LIGHT ON" button is tapped by
/// setting the `_lights` field, and off again when "TURN LIGHT OFF" is tapped.
///
/// ** See code in examples/api/lib/widgets/gesture_detector/gesture_detector.0.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// This example uses a [Container] that wraps a [GestureDetector] widget which
/// detects a tap.
///
/// Since the [GestureDetector] does not have a child, it takes on the size of its
/// parent, making the entire area of the surrounding [Container] clickable. When
/// tapped, the [Container] turns yellow by setting the `_color` field. When
/// tapped again, it goes back to white.
///
/// ** See code in examples/api/lib/widgets/gesture_detector/gesture_detector.1.dart **
/// {@end-tool}
///
/// ### Troubleshooting
///
/// Why isn't my parent [GestureDetector.onTap] method called?
///
/// Given a parent [GestureDetector] with an onTap callback, and a child
/// GestureDetector that also defines an onTap callback, when the inner
/// GestureDetector is tapped, both GestureDetectors send a [GestureRecognizer]
/// into the gesture arena. This is because the pointer coordinates are within the
/// bounds of both GestureDetectors. The child GestureDetector wins in this
/// scenario because it was the first to enter the arena, resolving as first come,
/// first served. The child onTap is called, and the parent's is not as the gesture has
/// been consumed.
/// For more information on gesture disambiguation see:
/// [Gesture disambiguation](https://docs.flutter.dev/development/ui/advanced/gestures#gesture-disambiguation).
///
/// Setting [GestureDetector.behavior] to [HitTestBehavior.opaque]
/// or [HitTestBehavior.translucent] has no impact on parent-child relationships:
/// both GestureDetectors send a GestureRecognizer into the gesture arena, only one wins.
///
/// Some callbacks (e.g. onTapDown) can fire before a recognizer wins the arena,
/// and others (e.g. onTapCancel) fire even when it loses the arena. Therefore,
/// the parent detector in the example above may call some of its callbacks even
/// though it loses in the arena.
///
/// {@tool dartpad}
/// This example uses a [GestureDetector] that wraps a green [Container] and a second
/// GestureDetector that wraps a yellow Container. The second GestureDetector is
/// a child of the green Container.
/// Both GestureDetectors define an onTap callback. When the callback is called it
/// adds a red border to the corresponding Container.
///
/// When the green Container is tapped, it's parent GestureDetector enters
/// the gesture arena. It wins because there is no competing GestureDetector and
/// the green Container shows a red border.
/// When the yellow Container is tapped, it's parent GestureDetector enters
/// the gesture arena. The GestureDetector that wraps the green Container also
/// enters the gesture arena (the pointer events coordinates are inside both
/// GestureDetectors bounds). The GestureDetector that wraps the yellow Container
/// wins because it was the first detector to enter the arena.
///
/// This example sets [debugPrintGestureArenaDiagnostics] to true.
/// This flag prints useful information about gesture arenas.
///
/// Changing the [GestureDetector.behavior] property to [HitTestBehavior.translucent]
/// or [HitTestBehavior.opaque] has no impact: both GestureDetectors send a [GestureRecognizer]
/// into the gesture arena, only one wins.
///
/// ** See code in examples/api/lib/widgets/gesture_detector/gesture_detector.2.dart **
/// {@end-tool}
///
/// ## Debugging
///
/// To see how large the hit test box of a [GestureDetector] is for debugging
/// purposes, set [debugPaintPointersEnabled] to true.
///
/// See also:
///
///  * [Listener], a widget for listening to lower-level raw pointer events.
///  * [MouseRegion], a widget that tracks the movement of mice, even when no
///    button is pressed.
///  * [RawGestureDetector], a widget that is used to detect custom gestures.
class DetailedGestureDetector extends StatelessWidget {
  /// Creates a widget that detects gestures.
  ///
  /// Pan and scale callbacks cannot be used simultaneously because scale is a
  /// superset of pan. Use the scale callbacks instead.
  ///
  /// Horizontal and vertical drag callbacks cannot be used simultaneously
  /// because a combination of a horizontal and vertical drag is a pan.
  /// Use the pan callbacks instead.
  ///
  /// {@youtube 560 315 https://www.youtube.com/watch?v=WhVXkCFPmK4}
  ///
  /// By default, gesture detectors contribute semantic information to the tree
  /// that is used by assistive technology.
  DetailedGestureDetector({
    super.key,
    this.child,
    this.onTapDown,
    this.onTapUp,
    this.onTap,
    this.onTapCancel,
    this.onSecondaryTap,
    this.onSecondaryTapDown,
    this.onSecondaryTapUp,
    this.onSecondaryTapCancel,
    this.onTertiaryTapDown,
    this.onTertiaryTapUp,
    this.onTertiaryTapCancel,
    this.onDoubleTapDown,
    this.onDoubleTap,
    this.onDoubleTapCancel,
    this.onLongPressDown,
    this.onLongPressCancel,
    this.onLongPress,
    this.onLongPressStart,
    this.onLongPressMoveUpdate,
    this.onLongPressUp,
    this.onLongPressEnd,
    this.onSecondaryLongPressDown,
    this.onSecondaryLongPressCancel,
    this.onSecondaryLongPress,
    this.onSecondaryLongPressStart,
    this.onSecondaryLongPressMoveUpdate,
    this.onSecondaryLongPressUp,
    this.onSecondaryLongPressEnd,
    this.onTertiaryLongPressDown,
    this.onTertiaryLongPressCancel,
    this.onTertiaryLongPress,
    this.onTertiaryLongPressStart,
    this.onTertiaryLongPressMoveUpdate,
    this.onTertiaryLongPressUp,
    this.onTertiaryLongPressEnd,
    this.onVerticalDragDown,
    this.onVerticalDragStart,
    this.onVerticalDragUpdate,
    this.onVerticalDragEnd,
    this.onVerticalDragCancel,
    this.onHorizontalDragDown,
    this.onHorizontalDragStart,
    this.onHorizontalDragUpdate,
    this.onHorizontalDragEnd,
    this.onHorizontalDragCancel,
    this.onForcePressStart,
    this.onForcePressPeak,
    this.onForcePressUpdate,
    this.onForcePressEnd,
    this.onPanDown,
    this.onPanStart,
    this.onPanUpdate,
    this.onPanEnd,
    this.onPanCancel,
    this.onScaleStart,
    this.onScaleUpdate,
    this.onScaleEnd,
    this.behavior,
    this.excludeFromSemantics = false,
    this.dragStartBehavior = DragStartBehavior.start,
    this.trackpadScrollCausesScale = false,
    this.trackpadScrollToScaleFactor = kDefaultTrackpadScrollToScaleFactor,
    this.supportedDevices,
  }) : assert(() {
         final bool haveVerticalDrag = onVerticalDragStart != null || onVerticalDragUpdate != null || onVerticalDragEnd != null;
         final bool haveHorizontalDrag = onHorizontalDragStart != null || onHorizontalDragUpdate != null || onHorizontalDragEnd != null;
         final bool havePan = onPanStart != null || onPanUpdate != null || onPanEnd != null;
         final bool haveScale = onScaleStart != null || onScaleUpdate != null || onScaleEnd != null;
         if (havePan || haveScale) {
           if (havePan && haveScale) {
             throw FlutterError.fromParts(<DiagnosticsNode>[
               ErrorSummary('Incorrect DetailedGestureDetector arguments.'),
               ErrorDescription(
                 'Having both a pan gesture recognizer and a scale gesture recognizer is redundant; scale is a superset of pan.',
               ),
               ErrorHint('Just use the scale gesture recognizer.'),
             ]);
           }
           final String recognizer = havePan ? 'pan' : 'scale';
           if (haveVerticalDrag && haveHorizontalDrag) {
             throw FlutterError(
               'Incorrect DetailedGestureDetector arguments.\n'
               'Simultaneously having a vertical drag gesture recognizer, a horizontal drag gesture recognizer, and a $recognizer gesture recognizer '
               'will result in the $recognizer gesture recognizer being ignored, since the other two will catch all drags.',
             );
           }
         }
         return true;
       }());

  /// The widget below this widget in the tree.
  final Widget? child;

  /// A pointer that might cause a tap with a primary button has contacted the
  /// screen at a particular location.
  ///
  /// This is called after a short timeout, even if the winning gesture has not
  /// yet been selected. If the tap gesture wins, [onTapUp] will be called,
  /// otherwise [onTapCancel] will be called.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  final DetailedGestureTapDownCallback? onTapDown;

  /// A pointer that will trigger a tap with a primary button has stopped
  /// contacting the screen at a particular location.
  ///
  /// This triggers immediately before [onTap] in the case of the tap gesture
  /// winning. If the tap gesture did not win, [onTapCancel] is called instead.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  final DetailedGestureTapUpCallback? onTapUp;

  /// A tap with a primary button has occurred.
  ///
  /// This triggers when the tap gesture wins. If the tap gesture did not win,
  /// [onTapCancel] is called instead.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  ///  * [onTapUp], which is called at the same time but includes details
  ///    regarding the pointer position.
  final DetailedGestureTapCallback? onTap;

  /// The pointer that previously triggered [onTapDown] will not end up causing
  /// a tap.
  ///
  /// This is called after [onTapDown], and instead of [onTapUp] and [onTap], if
  /// the tap gesture did not win.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  final DetailedGestureTapCancelCallback? onTapCancel;

  /// A tap with a secondary button has occurred.
  ///
  /// This triggers when the tap gesture wins. If the tap gesture did not win,
  /// [onSecondaryTapCancel] is called instead.
  ///
  /// See also:
  ///
  ///  * [kSecondaryButton], the button this callback responds to.
  ///  * [onSecondaryTapUp], which is called at the same time but includes details
  ///    regarding the pointer position.
  final DetailedGestureTapCallback? onSecondaryTap;

  /// A pointer that might cause a tap with a secondary button has contacted the
  /// screen at a particular location.
  ///
  /// This is called after a short timeout, even if the winning gesture has not
  /// yet been selected. If the tap gesture wins, [onSecondaryTapUp] will be
  /// called, otherwise [onSecondaryTapCancel] will be called.
  ///
  /// See also:
  ///
  ///  * [kSecondaryButton], the button this callback responds to.
  final DetailedGestureTapDownCallback? onSecondaryTapDown;

  /// A pointer that will trigger a tap with a secondary button has stopped
  /// contacting the screen at a particular location.
  ///
  /// This triggers in the case of the tap gesture winning. If the tap gesture
  /// did not win, [onSecondaryTapCancel] is called instead.
  ///
  /// See also:
  ///
  ///  * [onSecondaryTap], a handler triggered right after this one that doesn't
  ///    pass any details about the tap.
  ///  * [kSecondaryButton], the button this callback responds to.
  final DetailedGestureTapUpCallback? onSecondaryTapUp;

  /// The pointer that previously triggered [onSecondaryTapDown] will not end up
  /// causing a tap.
  ///
  /// This is called after [onSecondaryTapDown], and instead of
  /// [onSecondaryTapUp], if the tap gesture did not win.
  ///
  /// See also:
  ///
  ///  * [kSecondaryButton], the button this callback responds to.
  final DetailedGestureTapCancelCallback? onSecondaryTapCancel;

  /// A pointer that might cause a tap with a tertiary button has contacted the
  /// screen at a particular location.
  ///
  /// This is called after a short timeout, even if the winning gesture has not
  /// yet been selected. If the tap gesture wins, [onTertiaryTapUp] will be
  /// called, otherwise [onTertiaryTapCancel] will be called.
  ///
  /// See also:
  ///
  ///  * [kTertiaryButton], the button this callback responds to.
  final DetailedGestureTapDownCallback? onTertiaryTapDown;

  /// A pointer that will trigger a tap with a tertiary button has stopped
  /// contacting the screen at a particular location.
  ///
  /// This triggers in the case of the tap gesture winning. If the tap gesture
  /// did not win, [onTertiaryTapCancel] is called instead.
  ///
  /// See also:
  ///
  ///  * [kTertiaryButton], the button this callback responds to.
  final DetailedGestureTapUpCallback? onTertiaryTapUp;

  /// The pointer that previously triggered [onTertiaryTapDown] will not end up
  /// causing a tap.
  ///
  /// This is called after [onTertiaryTapDown], and instead of
  /// [onTertiaryTapUp], if the tap gesture did not win.
  ///
  /// See also:
  ///
  ///  * [kTertiaryButton], the button this callback responds to.
  final DetailedGestureTapCancelCallback? onTertiaryTapCancel;

  /// A pointer that might cause a double tap has contacted the screen at a
  /// particular location.
  ///
  /// Triggered immediately after the down event of the second tap.
  ///
  /// If the user completes the double tap and the gesture wins, [onDoubleTap]
  /// will be called after this callback. Otherwise, [onDoubleTapCancel] will
  /// be called after this callback.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  final DetailedGestureDoubleTapDownCallback? onDoubleTapDown;

  /// The user has tapped the screen with a primary button at the same location
  /// twice in quick succession.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  final DetailedGestureDoubleTapCallback? onDoubleTap;

  /// The pointer that previously triggered [onDoubleTapDown] will not end up
  /// causing a double tap.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  final DetailedGestureDoubleTapCancelCallback? onDoubleTapCancel;

  /// The pointer has contacted the screen with a primary button, which might
  /// be the start of a long-press.
  ///
  /// This triggers after the pointer down event.
  ///
  /// If the user completes the long-press, and this gesture wins,
  /// [onLongPressStart] will be called after this callback. Otherwise,
  /// [onLongPressCancel] will be called after this callback.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  ///  * [onSecondaryLongPressDown], a similar callback but for a secondary button.
  ///  * [onTertiaryLongPressDown], a similar callback but for a tertiary button.
  ///  * [DetailedLongPressGestureRecognizer.onLongPressDown], which exposes this
  ///    callback at the gesture layer.
  final DetailedGestureLongPressDownCallback? onLongPressDown;

  /// A pointer that previously triggered [onLongPressDown] will not end up
  /// causing a long-press.
  ///
  /// This triggers once the gesture loses if [onLongPressDown] has previously
  /// been triggered.
  ///
  /// If the user completed the long-press, and the gesture won, then
  /// [onLongPressStart] and [onLongPress] are called instead.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  ///  * [DetailedLongPressGestureRecognizer.onLongPressCancel], which exposes this
  ///    callback at the gesture layer.
  final DetailedGestureLongPressCancelCallback? onLongPressCancel;

  /// Called when a long press gesture with a primary button has been recognized.
  ///
  /// Triggered when a pointer has remained in contact with the screen at the
  /// same location for a long period of time.
  ///
  /// This is equivalent to (and is called immediately after) [onLongPressStart].
  /// The only difference between the two is that this callback does not
  /// contain details of the position at which the pointer initially contacted
  /// the screen.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  ///  * [DetailedLongPressGestureRecognizer.onLongPress], which exposes this
  ///    callback at the gesture layer.
  final DetailedGestureLongPressCallback? onLongPress;

  /// Called when a long press gesture with a primary button has been recognized.
  ///
  /// Triggered when a pointer has remained in contact with the screen at the
  /// same location for a long period of time.
  ///
  /// This is equivalent to (and is called immediately before) [onLongPress].
  /// The only difference between the two is that this callback contains
  /// details of the position at which the pointer initially contacted the
  /// screen, whereas [onLongPress] does not.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  ///  * [DetailedLongPressGestureRecognizer.onLongPressStart], which exposes this
  ///    callback at the gesture layer.
  final DetailedGestureLongPressStartCallback? onLongPressStart;

  /// A pointer has been drag-moved after a long-press with a primary button.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  ///  * [DetailedLongPressGestureRecognizer.onLongPressMoveUpdate], which exposes this
  ///    callback at the gesture layer.
  final DetailedGestureLongPressMoveUpdateCallback? onLongPressMoveUpdate;

  /// A pointer that has triggered a long-press with a primary button has
  /// stopped contacting the screen.
  ///
  /// This is equivalent to (and is called immediately after) [onLongPressEnd].
  /// The only difference between the two is that this callback does not
  /// contain details of the state of the pointer when it stopped contacting
  /// the screen.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  ///  * [DetailedLongPressGestureRecognizer.onLongPressUp], which exposes this
  ///    callback at the gesture layer.
  final DetailedGestureLongPressUpCallback? onLongPressUp;

  /// A pointer that has triggered a long-press with a primary button has
  /// stopped contacting the screen.
  ///
  /// This is equivalent to (and is called immediately before) [onLongPressUp].
  /// The only difference between the two is that this callback contains
  /// details of the state of the pointer when it stopped contacting the
  /// screen, whereas [onLongPressUp] does not.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  ///  * [DetailedLongPressGestureRecognizer.onLongPressEnd], which exposes this
  ///    callback at the gesture layer.
  final DetailedGestureLongPressEndCallback? onLongPressEnd;

  /// The pointer has contacted the screen with a secondary button, which might
  /// be the start of a long-press.
  ///
  /// This triggers after the pointer down event.
  ///
  /// If the user completes the long-press, and this gesture wins,
  /// [onSecondaryLongPressStart] will be called after this callback. Otherwise,
  /// [onSecondaryLongPressCancel] will be called after this callback.
  ///
  /// See also:
  ///
  ///  * [kSecondaryButton], the button this callback responds to.
  ///  * [onLongPressDown], a similar callback but for a secondary button.
  ///  * [onTertiaryLongPressDown], a similar callback but for a tertiary button.
  ///  * [DetailedLongPressGestureRecognizer.onSecondaryLongPressDown], which exposes
  ///    this callback at the gesture layer.
  final DetailedGestureLongPressDownCallback? onSecondaryLongPressDown;

  /// A pointer that previously triggered [onSecondaryLongPressDown] will not
  /// end up causing a long-press.
  ///
  /// This triggers once the gesture loses if [onSecondaryLongPressDown] has
  /// previously been triggered.
  ///
  /// If the user completed the long-press, and the gesture won, then
  /// [onSecondaryLongPressStart] and [onSecondaryLongPress] are called instead.
  ///
  /// See also:
  ///
  ///  * [kSecondaryButton], the button this callback responds to.
  ///  * [DetailedLongPressGestureRecognizer.onSecondaryLongPressCancel], which exposes
  ///    this callback at the gesture layer.
  final DetailedGestureLongPressCancelCallback? onSecondaryLongPressCancel;

  /// Called when a long press gesture with a secondary button has been
  /// recognized.
  ///
  /// Triggered when a pointer has remained in contact with the screen at the
  /// same location for a long period of time.
  ///
  /// This is equivalent to (and is called immediately after)
  /// [onSecondaryLongPressStart]. The only difference between the two is that
  /// this callback does not contain details of the position at which the
  /// pointer initially contacted the screen.
  ///
  /// See also:
  ///
  ///  * [kSecondaryButton], the button this callback responds to.
  ///  * [DetailedLongPressGestureRecognizer.onSecondaryLongPress], which exposes
  ///    this callback at the gesture layer.
  final DetailedGestureLongPressCallback? onSecondaryLongPress;

  /// Called when a long press gesture with a secondary button has been
  /// recognized.
  ///
  /// Triggered when a pointer has remained in contact with the screen at the
  /// same location for a long period of time.
  ///
  /// This is equivalent to (and is called immediately before)
  /// [onSecondaryLongPress]. The only difference between the two is that this
  /// callback contains details of the position at which the pointer initially
  /// contacted the screen, whereas [onSecondaryLongPress] does not.
  ///
  /// See also:
  ///
  ///  * [kSecondaryButton], the button this callback responds to.
  ///  * [DetailedLongPressGestureRecognizer.onSecondaryLongPressStart], which exposes
  ///    this callback at the gesture layer.
  final DetailedGestureLongPressStartCallback? onSecondaryLongPressStart;

  /// A pointer has been drag-moved after a long press with a secondary button.
  ///
  /// See also:
  ///
  ///  * [kSecondaryButton], the button this callback responds to.
  ///  * [DetailedLongPressGestureRecognizer.onSecondaryLongPressMoveUpdate], which exposes
  ///    this callback at the gesture layer.
  final DetailedGestureLongPressMoveUpdateCallback? onSecondaryLongPressMoveUpdate;

  /// A pointer that has triggered a long-press with a secondary button has
  /// stopped contacting the screen.
  ///
  /// This is equivalent to (and is called immediately after)
  /// [onSecondaryLongPressEnd]. The only difference between the two is that
  /// this callback does not contain details of the state of the pointer when
  /// it stopped contacting the screen.
  ///
  /// See also:
  ///
  ///  * [kSecondaryButton], the button this callback responds to.
  ///  * [DetailedLongPressGestureRecognizer.onSecondaryLongPressUp], which exposes
  ///    this callback at the gesture layer.
  final DetailedGestureLongPressUpCallback? onSecondaryLongPressUp;

  /// A pointer that has triggered a long-press with a secondary button has
  /// stopped contacting the screen.
  ///
  /// This is equivalent to (and is called immediately before)
  /// [onSecondaryLongPressUp]. The only difference between the two is that
  /// this callback contains details of the state of the pointer when it
  /// stopped contacting the screen, whereas [onSecondaryLongPressUp] does not.
  ///
  /// See also:
  ///
  ///  * [kSecondaryButton], the button this callback responds to.
  ///  * [DetailedLongPressGestureRecognizer.onSecondaryLongPressEnd], which exposes
  ///    this callback at the gesture layer.
  final DetailedGestureLongPressEndCallback? onSecondaryLongPressEnd;

  /// The pointer has contacted the screen with a tertiary button, which might
  /// be the start of a long-press.
  ///
  /// This triggers after the pointer down event.
  ///
  /// If the user completes the long-press, and this gesture wins,
  /// [onTertiaryLongPressStart] will be called after this callback. Otherwise,
  /// [onTertiaryLongPressCancel] will be called after this callback.
  ///
  /// See also:
  ///
  ///  * [kTertiaryButton], the button this callback responds to.
  ///  * [onLongPressDown], a similar callback but for a primary button.
  ///  * [onSecondaryLongPressDown], a similar callback but for a secondary button.
  ///  * [DetailedLongPressGestureRecognizer.onTertiaryLongPressDown], which exposes
  ///    this callback at the gesture layer.
  final DetailedGestureLongPressDownCallback? onTertiaryLongPressDown;

  /// A pointer that previously triggered [onTertiaryLongPressDown] will not
  /// end up causing a long-press.
  ///
  /// This triggers once the gesture loses if [onTertiaryLongPressDown] has
  /// previously been triggered.
  ///
  /// If the user completed the long-press, and the gesture won, then
  /// [onTertiaryLongPressStart] and [onTertiaryLongPress] are called instead.
  ///
  /// See also:
  ///
  ///  * [kTertiaryButton], the button this callback responds to.
  ///  * [DetailedLongPressGestureRecognizer.onTertiaryLongPressCancel], which exposes
  ///    this callback at the gesture layer.
  final DetailedGestureLongPressCancelCallback? onTertiaryLongPressCancel;

  /// Called when a long press gesture with a tertiary button has been
  /// recognized.
  ///
  /// Triggered when a pointer has remained in contact with the screen at the
  /// same location for a long period of time.
  ///
  /// This is equivalent to (and is called immediately after)
  /// [onTertiaryLongPressStart]. The only difference between the two is that
  /// this callback does not contain details of the position at which the
  /// pointer initially contacted the screen.
  ///
  /// See also:
  ///
  ///  * [kTertiaryButton], the button this callback responds to.
  ///  * [DetailedLongPressGestureRecognizer.onTertiaryLongPress], which exposes
  ///    this callback at the gesture layer.
  final DetailedGestureLongPressCallback? onTertiaryLongPress;

  /// Called when a long press gesture with a tertiary button has been
  /// recognized.
  ///
  /// Triggered when a pointer has remained in contact with the screen at the
  /// same location for a long period of time.
  ///
  /// This is equivalent to (and is called immediately before)
  /// [onTertiaryLongPress]. The only difference between the two is that this
  /// callback contains details of the position at which the pointer initially
  /// contacted the screen, whereas [onTertiaryLongPress] does not.
  ///
  /// See also:
  ///
  ///  * [kTertiaryButton], the button this callback responds to.
  ///  * [DetailedLongPressGestureRecognizer.onTertiaryLongPressStart], which exposes
  ///    this callback at the gesture layer.
  final DetailedGestureLongPressStartCallback? onTertiaryLongPressStart;

  /// A pointer has been drag-moved after a long press with a tertiary button.
  ///
  /// See also:
  ///
  ///  * [kTertiaryButton], the button this callback responds to.
  ///  * [DetailedLongPressGestureRecognizer.onTertiaryLongPressMoveUpdate], which exposes
  ///    this callback at the gesture layer.
  final DetailedGestureLongPressMoveUpdateCallback? onTertiaryLongPressMoveUpdate;

  /// A pointer that has triggered a long-press with a tertiary button has
  /// stopped contacting the screen.
  ///
  /// This is equivalent to (and is called immediately after)
  /// [onTertiaryLongPressEnd]. The only difference between the two is that
  /// this callback does not contain details of the state of the pointer when
  /// it stopped contacting the screen.
  ///
  /// See also:
  ///
  ///  * [kTertiaryButton], the button this callback responds to.
  ///  * [DetailedLongPressGestureRecognizer.onTertiaryLongPressUp], which exposes
  ///    this callback at the gesture layer.
  final DetailedGestureLongPressUpCallback? onTertiaryLongPressUp;

  /// A pointer that has triggered a long-press with a tertiary button has
  /// stopped contacting the screen.
  ///
  /// This is equivalent to (and is called immediately before)
  /// [onTertiaryLongPressUp]. The only difference between the two is that
  /// this callback contains details of the state of the pointer when it
  /// stopped contacting the screen, whereas [onTertiaryLongPressUp] does not.
  ///
  /// See also:
  ///
  ///  * [kTertiaryButton], the button this callback responds to.
  ///  * [DetailedLongPressGestureRecognizer.onTertiaryLongPressEnd], which exposes
  ///    this callback at the gesture layer.
  final DetailedGestureLongPressEndCallback? onTertiaryLongPressEnd;

  /// A pointer has contacted the screen with a primary button and might begin
  /// to move vertically.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  final DetailedGestureDragDownCallback? onVerticalDragDown;

  /// A pointer has contacted the screen with a primary button and has begun to
  /// move vertically.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  final DetailedGestureDragStartCallback? onVerticalDragStart;

  /// A pointer that is in contact with the screen with a primary button and
  /// moving vertically has moved in the vertical direction.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  final DetailedGestureDragUpdateCallback? onVerticalDragUpdate;

  /// A pointer that was previously in contact with the screen with a primary
  /// button and moving vertically is no longer in contact with the screen and
  /// was moving at a specific velocity when it stopped contacting the screen.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  final DetailedGestureDragEndCallback? onVerticalDragEnd;

  /// The pointer that previously triggered [onVerticalDragDown] did not
  /// complete.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  final DetailedGestureDragCancelCallback? onVerticalDragCancel;

  /// A pointer has contacted the screen with a primary button and might begin
  /// to move horizontally.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  final DetailedGestureDragDownCallback? onHorizontalDragDown;

  /// A pointer has contacted the screen with a primary button and has begun to
  /// move horizontally.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  final DetailedGestureDragStartCallback? onHorizontalDragStart;

  /// A pointer that is in contact with the screen with a primary button and
  /// moving horizontally has moved in the horizontal direction.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  final DetailedGestureDragUpdateCallback? onHorizontalDragUpdate;

  /// A pointer that was previously in contact with the screen with a primary
  /// button and moving horizontally is no longer in contact with the screen and
  /// was moving at a specific velocity when it stopped contacting the screen.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  final DetailedGestureDragEndCallback? onHorizontalDragEnd;

  /// The pointer that previously triggered [onHorizontalDragDown] did not
  /// complete.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  final DetailedGestureDragCancelCallback? onHorizontalDragCancel;

  /// A pointer has contacted the screen with a primary button and might begin
  /// to move.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  final DetailedGestureDragDownCallback? onPanDown;

  /// A pointer has contacted the screen with a primary button and has begun to
  /// move.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  final DetailedGestureDragStartCallback? onPanStart;

  /// A pointer that is in contact with the screen with a primary button and
  /// moving has moved again.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  final DetailedGestureDragUpdateCallback? onPanUpdate;

  /// A pointer that was previously in contact with the screen with a primary
  /// button and moving is no longer in contact with the screen and was moving
  /// at a specific velocity when it stopped contacting the screen.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  final DetailedGestureDragEndCallback? onPanEnd;

  /// The pointer that previously triggered [onPanDown] did not complete.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  final DetailedGestureDragCancelCallback? onPanCancel;

  /// The pointers in contact with the screen have established a focal point and
  /// initial scale of 1.0.
  final DetailedGestureScaleStartCallback? onScaleStart;

  /// The pointers in contact with the screen have indicated a new focal point
  /// and/or scale.
  final DetailedGestureScaleUpdateCallback? onScaleUpdate;

  /// The pointers are no longer in contact with the screen.
  final DetailedGestureScaleEndCallback? onScaleEnd;

  /// The pointer is in contact with the screen and has pressed with sufficient
  /// force to initiate a force press. The amount of force is at least
  /// [DetailedForcePressGestureRecognizer.startPressure].
  ///
  /// This callback will only be fired on devices with pressure
  /// detecting screens.
  final DetailedGestureForcePressStartCallback? onForcePressStart;

  /// The pointer is in contact with the screen and has pressed with the maximum
  /// force. The amount of force is at least
  /// [DetailedForcePressGestureRecognizer.peakPressure].
  ///
  /// This callback will only be fired on devices with pressure
  /// detecting screens.
  final DetailedGestureForcePressPeakCallback? onForcePressPeak;

  /// A pointer is in contact with the screen, has previously passed the
  /// [DetailedForcePressGestureRecognizer.startPressure] and is either moving on the
  /// plane of the screen, pressing the screen with varying forces or both
  /// simultaneously.
  ///
  /// This callback will only be fired on devices with pressure
  /// detecting screens.
  final DetailedGestureForcePressUpdateCallback? onForcePressUpdate;

  /// The pointer tracked by [onForcePressStart] is no longer in contact with the screen.
  ///
  /// This callback will only be fired on devices with pressure
  /// detecting screens.
  final DetailedGestureForcePressEndCallback? onForcePressEnd;

  /// How this gesture detector should behave during hit testing when deciding
  /// how the hit test propagates to children and whether to consider targets
  /// behind this one.
  ///
  /// This defaults to [HitTestBehavior.deferToChild] if [child] is not null and
  /// [HitTestBehavior.translucent] if child is null.
  ///
  /// See [HitTestBehavior] for the allowed values and their meanings.
  final HitTestBehavior? behavior;

  /// Whether to exclude these gestures from the semantics tree. For
  /// example, the long-press gesture for showing a tooltip is
  /// excluded because the tooltip itself is included in the semantics
  /// tree directly and so having a gesture to show it would result in
  /// duplication of information.
  final bool excludeFromSemantics;

  /// Determines the way that drag start behavior is handled.
  ///
  /// If set to [DragStartBehavior.start], gesture drag behavior will
  /// begin at the position where the drag gesture won the arena. If set to
  /// [DragStartBehavior.down] it will begin at the position where a down event
  /// is first detected.
  ///
  /// In general, setting this to [DragStartBehavior.start] will make drag
  /// animation smoother and setting it to [DragStartBehavior.down] will make
  /// drag behavior feel slightly more reactive.
  ///
  /// By default, the drag start behavior is [DragStartBehavior.start].
  ///
  /// Only the [DragGestureRecognizer.onStart] callbacks for the
  /// [DetailedVerticalDragGestureRecognizer], [DetailedHorizontalDragGestureRecognizer] and
  /// [DetailedPanGestureRecognizer] are affected by this setting.
  ///
  /// See also:
  ///
  ///  * [DragGestureRecognizer.dragStartBehavior], which gives an example for the different behaviors.
  final DragStartBehavior dragStartBehavior;

  /// The kind of devices that are allowed to be recognized.
  ///
  /// If set to null, events from all device types will be recognized. Defaults to null.
  final Set<PointerDeviceKind>? supportedDevices;

  /// {@macro flutter.gestures.scale.trackpadScrollCausesScale}
  final bool trackpadScrollCausesScale;

  /// {@macro flutter.gestures.scale.trackpadScrollToScaleFactor}
  final Offset trackpadScrollToScaleFactor;

  @override
  Widget build(BuildContext context) {
    final Map<Type, GestureRecognizerFactory> gestures = <Type, GestureRecognizerFactory>{};
    final DeviceGestureSettings? gestureSettings = MediaQuery.maybeGestureSettingsOf(context);
    final ScrollBehavior configuration = ScrollConfiguration.of(context);

    if (onTapDown != null ||
        onTapUp != null ||
        onTap != null ||
        onTapCancel != null ||
        onSecondaryTap != null ||
        onSecondaryTapDown != null ||
        onSecondaryTapUp != null ||
        onSecondaryTapCancel != null||
        onTertiaryTapDown != null ||
        onTertiaryTapUp != null ||
        onTertiaryTapCancel != null
    ) {
      gestures[DetailedTapGestureRecognizer] = GestureRecognizerFactoryWithHandlers<DetailedTapGestureRecognizer>(
        () => DetailedTapGestureRecognizer(debugOwner: this, supportedDevices: supportedDevices),
        (DetailedTapGestureRecognizer instance) {
          instance
            ..onTapDown = onTapDown
            ..onTapUp = onTapUp
            ..onTap = onTap
            ..onTapCancel = onTapCancel
            ..onSecondaryTap = onSecondaryTap
            ..onSecondaryTapDown = onSecondaryTapDown
            ..onSecondaryTapUp = onSecondaryTapUp
            ..onSecondaryTapCancel = onSecondaryTapCancel
            ..onTertiaryTapDown = onTertiaryTapDown
            ..onTertiaryTapUp = onTertiaryTapUp
            ..onTertiaryTapCancel = onTertiaryTapCancel
            ..gestureSettings = gestureSettings
            ..supportedDevices = supportedDevices;
        },
      );
    }

    if (onDoubleTap != null ||
        onDoubleTapDown != null ||
        onDoubleTapCancel != null) {
      gestures[DetailedDoubleTapGestureRecognizer] = GestureRecognizerFactoryWithHandlers<DetailedDoubleTapGestureRecognizer>(
        () => DetailedDoubleTapGestureRecognizer(debugOwner: this, supportedDevices: supportedDevices),
        (DetailedDoubleTapGestureRecognizer instance) {
          instance
            ..onDoubleTapDown = onDoubleTapDown
            ..onDoubleTap = onDoubleTap
            ..onDoubleTapCancel = onDoubleTapCancel
            ..gestureSettings = gestureSettings
            ..supportedDevices = supportedDevices;
        },
      );
    }

    if (onLongPressDown != null ||
        onLongPressCancel != null ||
        onLongPress != null ||
        onLongPressStart != null ||
        onLongPressMoveUpdate != null ||
        onLongPressUp != null ||
        onLongPressEnd != null ||
        onSecondaryLongPressDown != null ||
        onSecondaryLongPressCancel != null ||
        onSecondaryLongPress != null ||
        onSecondaryLongPressStart != null ||
        onSecondaryLongPressMoveUpdate != null ||
        onSecondaryLongPressUp != null ||
        onSecondaryLongPressEnd != null ||
        onTertiaryLongPressDown != null ||
        onTertiaryLongPressCancel != null ||
        onTertiaryLongPress != null ||
        onTertiaryLongPressStart != null ||
        onTertiaryLongPressMoveUpdate != null ||
        onTertiaryLongPressUp != null ||
        onTertiaryLongPressEnd != null) {
      gestures[DetailedLongPressGestureRecognizer] = GestureRecognizerFactoryWithHandlers<DetailedLongPressGestureRecognizer>(
        () => DetailedLongPressGestureRecognizer(debugOwner: this, supportedDevices: supportedDevices),
        (DetailedLongPressGestureRecognizer instance) {
          instance
            ..onLongPressDown = onLongPressDown
            ..onLongPressCancel = onLongPressCancel
            ..onLongPress = onLongPress
            ..onLongPressStart = onLongPressStart
            ..onLongPressMoveUpdate = onLongPressMoveUpdate
            ..onLongPressUp = onLongPressUp
            ..onLongPressEnd = onLongPressEnd
            ..onSecondaryLongPressDown = onSecondaryLongPressDown
            ..onSecondaryLongPressCancel = onSecondaryLongPressCancel
            ..onSecondaryLongPress = onSecondaryLongPress
            ..onSecondaryLongPressStart = onSecondaryLongPressStart
            ..onSecondaryLongPressMoveUpdate = onSecondaryLongPressMoveUpdate
            ..onSecondaryLongPressUp = onSecondaryLongPressUp
            ..onSecondaryLongPressEnd = onSecondaryLongPressEnd
            ..onTertiaryLongPressDown = onTertiaryLongPressDown
            ..onTertiaryLongPressCancel = onTertiaryLongPressCancel
            ..onTertiaryLongPress = onTertiaryLongPress
            ..onTertiaryLongPressStart = onTertiaryLongPressStart
            ..onTertiaryLongPressMoveUpdate = onTertiaryLongPressMoveUpdate
            ..onTertiaryLongPressUp = onTertiaryLongPressUp
            ..onTertiaryLongPressEnd = onTertiaryLongPressEnd
            ..gestureSettings = gestureSettings
            ..supportedDevices = supportedDevices;
        },
      );
    }

    if (onVerticalDragDown != null ||
        onVerticalDragStart != null ||
        onVerticalDragUpdate != null ||
        onVerticalDragEnd != null ||
        onVerticalDragCancel != null) {
      gestures[DetailedVerticalDragGestureRecognizer] = GestureRecognizerFactoryWithHandlers<DetailedVerticalDragGestureRecognizer>(
        () => DetailedVerticalDragGestureRecognizer(debugOwner: this, supportedDevices: supportedDevices),
        (DetailedVerticalDragGestureRecognizer instance) {
          instance
            ..onDown = onVerticalDragDown
            ..onStart = onVerticalDragStart
            ..onUpdate = onVerticalDragUpdate
            ..onEnd = onVerticalDragEnd
            ..onCancel = onVerticalDragCancel
            ..dragStartBehavior = dragStartBehavior
            ..multitouchDragStrategy = configuration.getMultitouchDragStrategy(context)
            ..gestureSettings = gestureSettings
            ..supportedDevices = supportedDevices;
        },
      );
    }

    if (onHorizontalDragDown != null ||
        onHorizontalDragStart != null ||
        onHorizontalDragUpdate != null ||
        onHorizontalDragEnd != null ||
        onHorizontalDragCancel != null) {
      gestures[DetailedHorizontalDragGestureRecognizer] = GestureRecognizerFactoryWithHandlers<DetailedHorizontalDragGestureRecognizer>(
        () => DetailedHorizontalDragGestureRecognizer(debugOwner: this, supportedDevices: supportedDevices),
        (DetailedHorizontalDragGestureRecognizer instance) {
          instance
            ..onDown = onHorizontalDragDown
            ..onStart = onHorizontalDragStart
            ..onUpdate = onHorizontalDragUpdate
            ..onEnd = onHorizontalDragEnd
            ..onCancel = onHorizontalDragCancel
            ..dragStartBehavior = dragStartBehavior
            ..multitouchDragStrategy = configuration.getMultitouchDragStrategy(context)
            ..gestureSettings = gestureSettings
            ..supportedDevices = supportedDevices;
        },
      );
    }

    if (onPanDown != null ||
        onPanStart != null ||
        onPanUpdate != null ||
        onPanEnd != null ||
        onPanCancel != null) {
      gestures[DetailedPanGestureRecognizer] = GestureRecognizerFactoryWithHandlers<DetailedPanGestureRecognizer>(
        () => DetailedPanGestureRecognizer(debugOwner: this, supportedDevices: supportedDevices),
        (DetailedPanGestureRecognizer instance) {
          instance
            ..onDown = onPanDown
            ..onStart = onPanStart
            ..onUpdate = onPanUpdate
            ..onEnd = onPanEnd
            ..onCancel = onPanCancel
            ..dragStartBehavior = dragStartBehavior
            ..multitouchDragStrategy = configuration.getMultitouchDragStrategy(context)
            ..gestureSettings = gestureSettings
            ..supportedDevices = supportedDevices;
        },
      );
    }

    if (onScaleStart != null || onScaleUpdate != null || onScaleEnd != null) {
      gestures[DetailedScaleGestureRecognizer] = GestureRecognizerFactoryWithHandlers<DetailedScaleGestureRecognizer>(
        () => DetailedScaleGestureRecognizer(debugOwner: this, supportedDevices: supportedDevices),
        (DetailedScaleGestureRecognizer instance) {
          instance
            ..onStart = onScaleStart
            ..onUpdate = onScaleUpdate
            ..onEnd = onScaleEnd
            ..dragStartBehavior = dragStartBehavior
            ..gestureSettings = gestureSettings
            ..trackpadScrollCausesScale = trackpadScrollCausesScale
            ..trackpadScrollToScaleFactor = trackpadScrollToScaleFactor
            ..supportedDevices = supportedDevices;
        },
      );
    }

    if (onForcePressStart != null ||
        onForcePressPeak != null ||
        onForcePressUpdate != null ||
        onForcePressEnd != null) {
      gestures[DetailedForcePressGestureRecognizer] = GestureRecognizerFactoryWithHandlers<DetailedForcePressGestureRecognizer>(
        () => DetailedForcePressGestureRecognizer(debugOwner: this, supportedDevices: supportedDevices),
        (DetailedForcePressGestureRecognizer instance) {
          instance
            ..onStart = onForcePressStart
            ..onPeak = onForcePressPeak
            ..onUpdate = onForcePressUpdate
            ..onEnd = onForcePressEnd
            ..gestureSettings = gestureSettings
            ..supportedDevices = supportedDevices;
        },
      );
    }

    return RawGestureDetector(
      gestures: gestures,
      behavior: behavior,
      excludeFromSemantics: excludeFromSemantics,
      child: child,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<DragStartBehavior>('startBehavior', dragStartBehavior));
  }
}

