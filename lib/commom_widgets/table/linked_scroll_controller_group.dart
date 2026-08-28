part of 'scrollable_table.dart';

/// A group of [ScrollController]s that keep their scroll offsets synchronized.
///
/// When any controller in the group scrolls (via drag, ballistic fling, or bounce),
/// all other controllers in the group follow immediately. Touching any controller
/// interrupts any running animation on peer controllers with zero delay.
class LinkedScrollControllerGroup {
  final List<_LinkedScrollController> _controllers = [];

  /// Creates and registers a new [ScrollController] belonging to this group.
  ScrollController addAndGet({
    double initialScrollOffset = 0.0,
    bool keepScrollOffset = true,
    String? debugLabel,
  }) {
    final controller = _LinkedScrollController(
      this,
      initialScrollOffset: initialScrollOffset,
      keepScrollOffset: keepScrollOffset,
      debugLabel: debugLabel,
    );
    _controllers.add(controller);
    return controller;
  }

  /// The current scroll offset of the group.
  double get offset {
    final positions = _attachedPositions.toList();
    if (positions.isEmpty) return 0.0;
    return positions.first.pixels;
  }

  /// Jumps all attached scroll positions to the given [value].
  void jumpTo(double value) {
    for (final position in _attachedPositions) {
      position.jumpTo(value);
    }
  }

  /// Animates all attached scroll positions to the given [offset].
  Future<void> animateTo(
    double offset, {
    required Duration duration,
    required Curve curve,
  }) async {
    final animations = <Future<void>>[];
    for (final position in _attachedPositions) {
      animations.add(
        position.animateTo(
          offset,
          duration: duration,
          curve: curve,
        ),
      );
    }
    await Future.wait(animations);
  }

  /// Resets all attached scroll positions to 0.0.
  void resetScroll() {
    jumpTo(0.0);
  }

  Iterable<_LinkedScrollPosition> get _attachedPositions sync* {
    for (final controller in _controllers) {
      for (final position in controller.positions) {
        if (position is _LinkedScrollPosition) {
          yield position;
        }
      }
    }
  }
}

class _LinkedScrollController extends ScrollController {
  _LinkedScrollController(
    this._group, {
    super.initialScrollOffset,
    super.keepScrollOffset,
    super.debugLabel,
  });

  final LinkedScrollControllerGroup _group;

  @override
  ScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) {
    return _LinkedScrollPosition(
      _group,
      physics: physics,
      context: context,
      initialPixels: initialScrollOffset,
      keepScrollOffset: keepScrollOffset,
      oldPosition: oldPosition,
      debugLabel: debugLabel,
    );
  }

  @override
  void attach(ScrollPosition position) {
    assert(
      position is _LinkedScrollPosition,
      '_LinkedScrollController can only attach _LinkedScrollPosition',
    );
    super.attach(position);
  }
}

class _LinkedScrollPosition extends ScrollPositionWithSingleContext {
  _LinkedScrollPosition(
    this._group, {
    required super.physics,
    required super.context,
    super.initialPixels = 0.0,
    super.keepScrollOffset = true,
    super.oldPosition,
    super.debugLabel,
  });

  final LinkedScrollControllerGroup _group;

  @override
  double setPixels(double newPixels) {
    final result = super.setPixels(newPixels);
    // Propagate offset changes to all peer controllers in the group within the same frame
    for (final position in _group._attachedPositions) {
      if (position != this &&
          position.hasPixels &&
          position.pixels != newPixels) {
        position.forcePixels(newPixels);
      }
    }
    return result;
  }

  @override
  void correctPixels(double value) {
    super.correctPixels(value);
    for (final position in _group._attachedPositions) {
      if (position != this &&
          position.hasPixels &&
          position.pixels != value) {
        position.correctPixels(value);
      }
    }
  }

  @override
  void forcePixels(double value) {
    if (pixels == value) return;
    super.forcePixels(value);
    notifyListeners();
  }

  @override
  ScrollHoldController hold(VoidCallback holdCancelCallback) {
    // Touching any column immediately cancels running animations (like iOS bounce/fling) on peer columns
    for (final position in _group._attachedPositions) {
      if (position != this) {
        position.goIdle();
      }
    }
    return super.hold(holdCancelCallback);
  }

  @override
  Drag drag(DragStartDetails details, VoidCallback dragCancelCallback) {
    // Ensure peer positions are idle when dragging begins to prevent input contention
    for (final position in _group._attachedPositions) {
      if (position != this) {
        position.goIdle();
      }
    }
    return super.drag(details, dragCancelCallback);
  }

  @override
  void beginActivity(ScrollActivity? newActivity) {
    if (newActivity == null) return;
    // When a new driving activity starts (drag, fling, programmatic scroll), stop active animations on peers
    if (newActivity is DragScrollActivity ||
        newActivity is BallisticScrollActivity ||
        newActivity is DrivenScrollActivity) {
      for (final position in _group._attachedPositions) {
        if (position != this && position.activity is! IdleScrollActivity) {
          position.goIdle();
        }
      }
    }
    super.beginActivity(newActivity);
  }
}
