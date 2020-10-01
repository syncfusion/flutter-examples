///Dart import
import 'dart:math' as math;

///Package import
import 'package:flutter/material.dart';

///Local import
import '../model/model.dart';

///Backdrop widget holds the appbar, front panel, etc., widgets
class Backdrop extends StatefulWidget {
  /// Holds information of the appbar, front panel, etc.,
  Backdrop({
    this.sampleListModel,
    @required this.frontLayer,
    @required this.backLayer,
    this.toggleFrontLayer = true,
    this.color,

    //--------Appbar properties------------
    this.appBarTitle,
    this.appBarActions,
    this.panelVisible,
  })  : assert(frontLayer != null),
        assert(backLayer != null);

  //----------------------Front and Back Panel properties-----------------------

  /// This is the front panel which will contain the main body.
  final Widget frontLayer;

  /// This is the back panel where you can put menu Items.
  final Widget backLayer;

  /// If true it will toggle the position of your [frontLayer].
  ///
  /// Initially keep it false.
  /// Then make it true on Selecting any Menu item in [backLayer].
  final bool toggleFrontLayer;

  /// The primary widget displayed in the appbar.
  ///
  /// Typically a [Text] widget containing a description of the current contents
  /// of the app.
  final Widget appBarTitle;

  /// Color of the [Backdrop]
  final Color color;

  /// Widgets to display after the [appBarTitle] widget.
  ///
  /// Typically these widgets are [IconButton]s representing common operations.
  /// For less common operations, consider using a [PopupMenuButton] as the
  /// last action.
  ///
  /// {@tool snippet --template=stateless_widget}
  ///
  /// This sample shows adding an action to the appBar of your [Backdrop]
  /// that opens a shopping cart.
  ///
  /// ```dart
  /// Backdrop(
  ///   appBarActions: <Widget>[
  ///     IconButton(
  ///       icon: Icon(Icons.shopping_cart),
  ///       tooltip: 'Open shopping cart',
  ///       onPressed: () {
  ///         // ...
  ///       },
  ///     ),
  ///   ],
  /// ),
  /// ```
  /// {@end-tool}
  final List<Widget> appBarActions;

  /// Holds the SampleModel
  final SampleModel sampleListModel;

  /// Contains the front panel visibility
  final ValueNotifier<bool> panelVisible;

  @override
  BackdropState createState() => BackdropState(sampleListModel);
}

/// Holds the appbar and front panel information
class BackdropState extends State<Backdrop>
    with SingleTickerProviderStateMixin {
  /// holds bropdrop state
  BackdropState(SampleModel _sampleListModel, {this.test = false}) {
    // ignore: prefer_initializing_formals
    sampleListModel = _sampleListModel;
  }

  final num _flingVelocity = 2.0;

  /// Holds height of the front panel
  static double frontPanelHeight = 0;

  /// Sets front panel visibility
  bool panelVisible;
  final GlobalKey _backDropKey = GlobalKey(debugLabel: 'Backdrop');

  ///Holds the dummy test
  bool test;
  AnimationController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey(debugLabel: 'Scaffold');

  ///Holds sample browser details
  SampleModel sampleListModel;

  @override
  void initState() {
    super.initState();
    panelVisible = widget.panelVisible?.value;
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 100),
        value: (widget.panelVisible?.value ?? true) ? 1.0 : 0.0)
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          panelVisible = true;
        } else if (status == AnimationStatus.dismissed) {
          panelVisible = false;
        }
      })
      ..addListener(() {
        setState(() {
          ///Back drop state changed
        });
      });

    widget.panelVisible?.addListener(_subscribeToValueNotifier);

    /// Ensure that the value notifier is updated
    /// when the panel is opened or closed
    if (widget.panelVisible != null) {
      _controller.addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          widget.panelVisible.value = true;
        } else if (status == AnimationStatus.dismissed) {
          widget.panelVisible.value = false;
        }
      });
    }
  }

  void _subscribeToValueNotifier() {
    if (widget.panelVisible.value != _backdropPanelVisible) {
      _toggleBackdropPanelVisibility();
    }
  }

  bool get _backdropPanelVisible =>
      _controller.status == AnimationStatus.completed ||
      _controller.status == AnimationStatus.forward;

  void _toggleBackdropPanelVisibility() {
    if (widget.toggleFrontLayer) {
      _controller.fling(
          velocity: _backdropPanelVisible ? -_flingVelocity : _flingVelocity);
    }
  }

  double get _backdropHeight {
    final RenderBox renderBox = _backDropKey.currentContext.findRenderObject();
    return math.max(0.0, renderBox.size.height);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_controller.isAnimating && widget.toggleFrontLayer) {
      _controller.value -= details.primaryDelta / _backdropHeight;
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed) {
      return;
    }

    final double fVelocity =
        details.velocity.pixelsPerSecond.dy / _backdropHeight;
    if (fVelocity < 0.0) {
      _controller.fling(velocity: _flingVelocity);
    } else if (fVelocity > 0.0) {
      _controller.fling(velocity: -_flingVelocity);
    } else {
      _controller.fling(
          velocity: _controller.value < 0.5 ? -_flingVelocity : _flingVelocity);
    }
  }

  List<Widget> _appBarMenuButton(Animation<double> progress) {
    List<Widget> toolBarWidgets = <Widget>[];
    if (widget.appBarActions != null) {
      toolBarWidgets = <Widget>[];
      for (int i = 0; i < widget.appBarActions.length; i++) {
        toolBarWidgets.add(widget.appBarActions[i]);
      }

      if (_controller.value < 0.5) {
        toolBarWidgets = <Widget>[
          Container(
              height: 60,
              width: 60,
              child: IconButton(
                icon: IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _toggleBackdropPanelVisibility();
                  },
                ),
                onPressed: () {},
              ))
        ];
      }

      final Widget res = _CrossFadeTransition(
        progress: _controller,
        alignment: AlignmentDirectional.centerStart,
        child0:
            Semantics(namesRoute: true, child: Row(children: toolBarWidgets)),
        child1: Semantics(
            namesRoute: true,
            child: Container(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 5),
                  child: Container(
                      color: Colors.transparent, child: toolBarWidgets[0]),
                ))),
      );
      toolBarWidgets = <Widget>[res];
      return toolBarWidgets;
    }
    return toolBarWidgets;
  }

  Size _panelSize = const Size(0, 0);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        _panelSize = constraints.biggest;
        double closedPercentage = 0;
        double closedPercentageSearch = 0;
        closedPercentage =
            (_panelSize.height - (_panelSize.height - frontPanelHeight)) /
                _panelSize.height;
        closedPercentageSearch = 0.0;

        final Animation<Offset> panelDetailsPosition = Tween<Offset>(
                begin: Offset(0.0, closedPercentage),
                end: Offset(0.0, closedPercentageSearch))
            .animate(_controller.view);
        return Theme(
          data: sampleListModel.themeData,
          child: Scaffold(
            resizeToAvoidBottomPadding: false,
            key: _scaffoldKey,
            backgroundColor: sampleListModel.paletteColor,
            appBar: PreferredSize(
                preferredSize:
                    const Size.fromHeight(60.0), // here the desired height
                child: AppBar(
                  title: _CrossFadeTransition(
                    progress: _controller,
                    alignment: AlignmentDirectional.centerStart,
                    child0:
                        Semantics(namesRoute: true, child: widget.appBarTitle),
                    child1: Semantics(namesRoute: true, child: const Text('')),
                  ),
                  actions: _appBarMenuButton(_controller),
                  elevation: 0.0,
                  backgroundColor: sampleListModel.backgroundColor,
                  titleSpacing: NavigationToolbar.kMiddleSpacing,
                )),
            body: Stack(
              overflow: Overflow.clip,
              key: _backDropKey,
              children: <Widget>[
                Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: widget.backLayer),
                SlideTransition(
                  position: panelDetailsPosition,
                  child: _BackdropPanel(
                    onTap: _toggleBackdropPanelVisibility,
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12), bottom: Radius.circular(0)),
                    frontHeaderHeight: 20.0,
                    padding: EdgeInsets.zero,
                    onVerticalDragUpdate: _handleDragUpdate,
                    onVerticalDragEnd: _handleDragEnd,
                    color: widget.color,
                    child: widget.frontLayer,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    widget.panelVisible?.removeListener(_subscribeToValueNotifier);
  }
}

class _CrossFadeTransition extends AnimatedWidget {
  const _CrossFadeTransition({
    Key key,
    this.alignment = Alignment.center,
    Animation<double> progress,
    this.child0,
    this.child1,
  }) : super(key: key, listenable: progress);

  final AlignmentGeometry alignment;
  final Widget child0;
  final Widget child1;

  @override
  Widget build(BuildContext context) {
    final Animation<double> progress = listenable;

    final double opacity1 = CurvedAnimation(
      parent: ReverseAnimation(progress),
      curve: const Interval(0.5, 1.0),
    ).value;

    final double opacity2 = CurvedAnimation(
      parent: progress,
      curve: const Interval(0.5, 1.0),
    ).value;

    return Stack(
      alignment: alignment,
      children: <Widget>[
        Opacity(
          opacity: opacity1,
          child: Semantics(
            scopesRoute: true,
            explicitChildNodes: true,
            child: child1,
          ),
        ),
        Opacity(
          opacity: opacity2,
          child: Semantics(
            scopesRoute: true,
            explicitChildNodes: true,
            child: child0,
          ),
        ),
      ],
    );
  }
}

class _BackdropPanel extends StatelessWidget {
  const _BackdropPanel({
    Key key,
    this.onTap,
    this.onVerticalDragUpdate,
    this.onVerticalDragEnd,
    this.frontHeader,
    this.child,
    this.shape,
    this.borderRadius,
    this.frontHeaderHeight,
    this.padding,
    this.color,
  }) : super(key: key);

  final VoidCallback onTap;
  final GestureDragUpdateCallback onVerticalDragUpdate;
  final GestureDragEndCallback onVerticalDragEnd;
  final Widget frontHeader;
  final Widget child;
  final BorderRadius borderRadius;
  final ShapeBorder shape;
  final double frontHeaderHeight;
  final EdgeInsets padding;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Material(
        color: color,
        elevation: 12.0,
        borderRadius: borderRadius,
        shape: shape,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //---------------------------HEADER-------------------------
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onVerticalDragUpdate: onVerticalDragUpdate,
              onVerticalDragEnd: onVerticalDragEnd,
              onTap: onTap,
              child: Container(
                height: frontHeaderHeight,
                child: frontHeader,
              ),
            ),

            //--------------------REST OF THE BODY----------------------
            Expanded(
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
