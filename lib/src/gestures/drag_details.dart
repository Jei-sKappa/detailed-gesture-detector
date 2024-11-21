// -----------------------------------------------------------------------------
// Forked from Flutter's original 'src/gestures/drag_details.dart' file.
// -----------------------------------------------------------------------------
// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/gestures.dart';

/// Signature for when a pointer has contacted the screen and might begin to
/// move.
///
/// The `details` object provides the position of the touch.
/// 
/// The `event` object provides the original pointer event.
///
/// See [DetailedDragGestureRecognizer.onDown].
typedef DetailedGestureDragDownCallback = void Function(DragDownDetails details, PointerEvent event);

/// {@template gestures.dragdetails.DetailedGestureDragStartCallback}
/// Signature for when a pointer has contacted the screen and has begun to move.
///
/// The `details` object provides the position of the touch when it first
/// touched the surface.
/// 
/// The `event` object provides the original pointer event.
/// {@endtemplate}
///
/// See [DetailedDragGestureRecognizer.onStart].
typedef DetailedGestureDragStartCallback = void Function(DragStartDetails details, PointerEvent event);

/// {@template gestures.dragdetails.DetailedGestureDragUpdateCallback}
/// Signature for when a pointer that is in contact with the screen and moving
/// has moved again.
///
/// The `details` object provides the position of the touch and the distance it
/// has traveled since the last update.
/// 
/// The `initialEvent` object provides the original pointer event.
/// 
/// The `event` object provides the current pointer event if available.
/// {@endtemplate}
///
/// See [DetailedDragGestureRecognizer.onUpdate].
typedef DetailedGestureDragUpdateCallback = void Function(DragUpdateDetails details, PointerEvent initialEvent, PointerEvent? event);
