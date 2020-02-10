import 'package:flutter/material.dart';

Future<T> showRoundedModalBottomSheet<T>({
  @required BuildContext context,
  @required WidgetBuilder builder,
  Color color = Colors.white,
  double radius = 10.0,
  bool autoResize = true,
  bool dismissOnTap = true,
}) {
  assert(context != null);
  assert(builder != null);
  assert(radius != null && radius > 0.0);
  assert(color != null && color != Colors.transparent);
  return Navigator.push<T>(
    context,
    RoundedCornerModalRoute<T>(
      builder: builder,
      color: color,
      radius: radius,
      autoResize: autoResize,
      dismissOnTap: dismissOnTap,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    ),
  );
}

const Duration _kRoundedBottomSheetDuration = Duration(milliseconds: 300);
const double _kMinFlingVelocity = 600.0;
const double _kCloseProgressThreshold = 0.5;

class CustomBottomSheet extends StatefulWidget {
  const CustomBottomSheet(
      {Key key,
      this.animationController,
      @required this.onClosing,
      @required this.builder})
      : assert(onClosing != null),
        assert(builder != null),
        super(key: key);

  /// The animation that controls the bottom sheet's position.
  ///
  /// The BottomSheet widget will manipulate the position of this animation, it
  /// is not just a passive observer.
  final AnimationController animationController;

  /// Called when the bottom sheet begins to close.
  ///
  /// A bottom sheet might be be prevented from closing (e.g., by user
  /// interaction) even after this callback is called. For this reason, this
  /// callback might be call multiple times for a given bottom sheet.
  final VoidCallback onClosing;

  /// A builder for the contents of the sheet.
  ///
  /// The bottom sheet will wrap the widget produced by this builder in a
  /// [Material] widget.
  final WidgetBuilder builder;

  @override
  _CustomBottomSheetState createState() => _CustomBottomSheetState();

  /// Creates an animation controller suitable for controlling a [CustomBottomSheet].
  static AnimationController createAnimationController(TickerProvider vsync) {
    return AnimationController(
      duration: _kRoundedBottomSheetDuration,
      debugLabel: 'RoundedBottomSheet',
      vsync: vsync,
    );
  }
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  final GlobalKey _childKey = GlobalKey(debugLabel: 'RoundedBottomSheet child');

  double get _childHeight {
    final RenderBox renderBox = _childKey.currentContext.findRenderObject();
    return renderBox.size.height;
  }

  bool get _dismissUnderway =>
      widget.animationController.status == AnimationStatus.reverse;

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_dismissUnderway) 
      return;
    widget.animationController.value -=
        details.primaryDelta / (_childHeight ?? details.primaryDelta);
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_dismissUnderway) 
      return;
    if (details.velocity.pixelsPerSecond.dy > _kMinFlingVelocity) {
      final double flingVelocity =
          -details.velocity.pixelsPerSecond.dy / _childHeight;
      if (widget.animationController.value > 0.0)
        widget.animationController.fling(velocity: flingVelocity);
      if (flingVelocity < 0.0) {
        widget.onClosing();
      }        
    } else if (widget.animationController.value < _kCloseProgressThreshold) {
      if (widget.animationController.value > 0.0)
        widget.animationController.fling(velocity: -1.0);
      widget.onClosing();
    } else {
      widget.animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: _handleDragUpdate,
      onVerticalDragEnd: _handleDragEnd,
      child: Material(
        key: _childKey,
        child: widget.builder(context),
      ),
    );
  }
}

class _RoundedModalBottomSheetLayout extends SingleChildLayoutDelegate {
  _RoundedModalBottomSheetLayout(this.bottomInset, this.progress);

  final double bottomInset;
  final double progress;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
        minWidth: constraints.maxWidth,
        maxWidth: constraints.maxWidth,
        minHeight: 0.0,
        maxHeight: constraints.maxHeight * 9.0 / 16.0);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(0.0, size.height - bottomInset - childSize.height * progress);
  }

  @override
  bool shouldRelayout(_RoundedModalBottomSheetLayout oldDelegate) {
    return progress != oldDelegate.progress ||
        bottomInset != oldDelegate.bottomInset;
  }
}

class RoundedCornerModalRoute<T> extends PopupRoute<T> {
  RoundedCornerModalRoute({
    this.builder,
    this.barrierLabel,
    this.color,
    this.radius,
    this.autoResize = false,
    this.dismissOnTap = true,
    RouteSettings settings,
  }) : super(settings: settings);

  final WidgetBuilder builder;
  final double radius;
  final Color color;
  final bool autoResize;
  final bool dismissOnTap;

  @override
  Duration get transitionDuration => _kRoundedBottomSheetDuration;

  @override
  Color get barrierColor => Colors.black54;

  @override
  bool get barrierDismissible => true;

  @override
  bool get opaque => false;

  @override
  bool get maintainState => false;

  @override
  String barrierLabel;

  AnimationController animationController;

  @override
  AnimationController createAnimationController() {
    assert(animationController == null);
    animationController =
        BottomSheet.createAnimationController(navigator.overlay);
    return animationController;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
        child: RoundedModalBottomSheet<T>(route: this),
      ),
    );
  }
}

class RoundedModalBottomSheet<T> extends StatefulWidget {
  const RoundedModalBottomSheet({Key key, this.route}) : super(key: key);

  final RoundedCornerModalRoute<T> route;

  @override
  _RoundedModalBottomSheetState<T> createState() =>
      _RoundedModalBottomSheetState<T>();
}

class _RoundedModalBottomSheetState<T>
    extends State<RoundedModalBottomSheet<T>> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AnimatedBuilder(
        animation: widget.route.animation,
        builder: (BuildContext context, Widget child) => CustomSingleChildLayout(
              delegate: _RoundedModalBottomSheetLayout(
                  widget.route.autoResize
                      ? MediaQuery.of(context).viewInsets.bottom
                      : 0.0,
                  widget.route.animation.value),
              child: CustomBottomSheet(
                animationController: widget.route.animationController,
                onClosing: () => Navigator.pop(context),
                builder: (BuildContext context) => Container(
                      decoration: BoxDecoration(
                        color: widget.route.color,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(widget.route.radius),
                          topRight: Radius.circular(widget.route.radius),
                        ),
                      ),
                      child: SafeArea(
                        child: Builder(builder: widget.route.builder),
                      ),
                    ),
              ),
            ),
      ),
    );
  }
}
