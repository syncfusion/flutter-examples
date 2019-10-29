import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';

const num _flingVelocity = 2.0;

// ignore: must_be_immutable
class Backdrop extends StatefulWidget {
  Backdrop({
    this.needCloseButton = true,
    this.enableBackPanelAnimation = false,
    this.frontPanelOpenPercentage = 0.3,
    this.sampleListModel,
    @required this.frontLayer,
    @required this.backLayer,
    @required this.sideDrawer,
    this.frontHeader,
    this.borderRadius,
    this.shape,
    this.frontHeaderHeight = 20.0,
    this.headerClosingHeight,
    this.titleVisibleOnPanelClosed = true,
    this.frontPanelPadding = EdgeInsets.zero,
    this.toggleFrontLayer = true,
    this.color,

    //--------Appbar properties------------
    this.appBarLeadingMenuIcon,
    this.appBarAnimatedLeadingMenuIcon,
    this.appBarAutomaticallyImplyLeading = true,
    this.appBarTitle,
    this.appBarActions,
    this.appBarBackgroundColor,
    this.appBarIconTheme,
    this.appBarTextTheme,
    this.appBarCenterTitle,
    this.appBarTitleSpacing = NavigationToolbar.kMiddleSpacing,
    this.panelVisible,
  })  : assert(frontLayer != null),
        assert(frontHeaderHeight > 0.0 ||
            (appBarLeadingMenuIcon != null ||
                appBarAnimatedLeadingMenuIcon != null)),
        assert(backLayer != null);

  //----------------------Front and Back Panel properties-----------------------

  /// This is the front panel which will contain the main body.
  final Widget frontLayer;

  /// This is the back panel where you can put menu Items.
  final Widget backLayer;

  /// This widget should contain your title which will appear above [frontLayer].
  /// Remember to modify it properly if you are using [shape] or [borderRadius] mentioned below.
  final Widget frontHeader;

  /// This decides the height of [frontHeader].
  /// Provide 0.0 if you don't want it.
  final double frontHeaderHeight;

  /// Gives a Circular radius to the [frontLayer].
  /// Provide radius only for topLeft or/and topRight for best output.
  final BorderRadius borderRadius;

  /// Gives a shape to border like [BeveledRectangleBorder] to give an effect.
  /// Provide radius only for topLeft or/and topRight for best output.
  final ShapeBorder shape;

  /// [frontHeader] will be visible or not when [backLayer] is visible.
  /// If true [frontHeader] will be visible if [frontHeaderHeight] > 0.0.
  /// If false [frontHeader] will be invisible.
  final bool titleVisibleOnPanelClosed;

  /// Default [Padding] for [frontPanel].
  /// By default [Padding] is [EdgeInsets.zero].
  final EdgeInsets frontPanelPadding;

  /// If true it will toggle the position of your [frontLayer].
  ///
  /// Initially keep it false. Then make it true on Selecting any Menu item in [backLayer].
  final bool toggleFrontLayer;

  //------------------------Appbar properties-----------------------------

  /// Non-animated Leading menu icon. Should be [IconData].
  /// If provided [appBarAnimatedLeadingMenuIcon] should be null.
  final IconData appBarLeadingMenuIcon;

  /// Animated Leading menu icon. Should be [AnimatedIconData].
  /// If provided [appBarLeadingMenuIcon] should be null.
  final AnimatedIconData appBarAnimatedLeadingMenuIcon;

  /// Controls whether we should try to imply the leading widget if null.
  ///
  /// If true and [appBarAnimatedLeadingMenuIcon] or [appBarLeadingMenuIcon] is null,
  /// automatically try to deduce what the leading widget should be.
  /// If false and [appBarAnimatedLeadingMenuIcon] or [appBarLeadingMenuIcon] is null,
  /// leading space is given to [appBarTitle].
  /// If leading widget is not null, this parameter has no effect.
  final bool appBarAutomaticallyImplyLeading;

  /// The primary widget displayed in the appbar.
  ///
  /// Typically a [Text] widget containing a description of the current contents
  /// of the app.
  final Widget appBarTitle;

  final Color color;

  /// Widgets to display after the [appBarTitle] widget.
  ///
  /// Typically these widgets are [IconButton]s representing common operations.
  /// For less common operations, consider using a [PopupMenuButton] as the
  /// last action.
  ///
  /// {@tool snippet --template=stateless_widget}
  ///
  /// This sample shows adding an action to the appBar of your [Backdrop] that opens a shopping cart.
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

  /// The color to use for the app bar's material. Typically this should be set
  /// along with [appBarIconTheme], [appBarTextTheme].
  ///
  /// Defaults to [ThemeData.primaryColor].
  final Color appBarBackgroundColor;

  /// The color, opacity, and size to use for app bar icons. Typically this
  /// is set along with [appBarBackgroundColor], [appBarTextTheme].
  ///
  /// Defaults to [ThemeData.primaryIconTheme].
  final IconThemeData appBarIconTheme;

  /// The typographic styles to use for text in the app bar. Typically this is
  /// set along with [appBarBackgroundColor], [appBarIconTheme].
  ///
  /// Defaults to [ThemeData.primaryTextTheme].
  final TextTheme appBarTextTheme;

  /// Whether the title should be centered.
  ///
  /// Defaults to being adapted to the current [TargetPlatform].
  final bool appBarCenterTitle;

  /// The spacing around [appBarTitle] content on the horizontal axis. This spacing is
  /// applied even if there is no leading content or trailing actions. If you want
  /// [appBarTitle] to take all the space available, set this value to 0.0.
  ///
  /// Defaults to [NavigationToolbar.kMiddleSpacing].
  final double appBarTitleSpacing;

  final double headerClosingHeight;

  final Widget sideDrawer;

  AnimationController controller;

  final SampleListModel sampleListModel;

  final double frontPanelOpenPercentage;

  final bool enableBackPanelAnimation;

  final ValueNotifier<bool> panelVisible;

  final bool needCloseButton;

  @override
  BackdropState createState() => BackdropState(controller, sampleListModel);
}

class BackdropState extends State<Backdrop>
    with SingleTickerProviderStateMixin {
  BackdropState(
      AnimationController _controller, SampleListModel _sampleListModel,
      {this.test = false}) {
    // ignore: prefer_initializing_formals
    controller = _controller;
    // ignore: prefer_initializing_formals
    sampleListModel = _sampleListModel;
  }

  static double frontPanelHeight = 0;
  bool panelVisible;
  final dynamic _backDropKey = GlobalKey(debugLabel: 'Backdrop');
  bool test;
  AnimationController controller;
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey(debugLabel: 'Scaffold');
  SampleListModel sampleListModel;

  @override
  void initState() {
    super.initState();
    panelVisible = widget.panelVisible?.value;
    controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 100),
        value: (widget.panelVisible?.value ?? true) ? 1.0 : 0.0)
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed)
          panelVisible = true;
        else if (status == AnimationStatus.dismissed) {
          panelVisible = false;
        }
      })
      ..addListener(() {
        setState(() {});
      });

    widget.panelVisible?.addListener(_subscribeToValueNotifier);

    // Ensure that the value notifier is updated when the panel is opened or closed
    if (widget.panelVisible != null) {
      controller.addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed)
          widget.panelVisible.value = true;
        else if (status == AnimationStatus.dismissed)
          widget.panelVisible.value = false;
      });
    }
  }

  void _subscribeToValueNotifier() {
    if (widget.panelVisible.value != _backdropPanelVisible)
      toggleBackdropPanelVisibility();
  }

  bool get _backdropPanelVisible =>
      controller.status == AnimationStatus.completed ||
      controller.status == AnimationStatus.forward;

  void toggleBackdropPanelVisibility() {
    if (widget.toggleFrontLayer) {
      controller.fling(
          velocity: _backdropPanelVisible ? -_flingVelocity : _flingVelocity);
    }
  }

  double get _backdropHeight {
    final RenderBox renderBox = _backDropKey.currentContext.findRenderObject();
    return math.max(0.0, renderBox.size.height);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!controller.isAnimating && widget.toggleFrontLayer) {
      controller.value -= details.primaryDelta / _backdropHeight;
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    if (controller.isAnimating ||
        controller.status == AnimationStatus.completed) 
          return;

    final double fVelocity =
        details.velocity.pixelsPerSecond.dy / _backdropHeight;
    if (fVelocity < 0.0)
      controller.fling(velocity: _flingVelocity);
    else if (fVelocity > 0.0)
      controller.fling(velocity: -_flingVelocity);
    else
      controller.fling(
          velocity: controller.value < 0.5 ? -_flingVelocity : _flingVelocity);
  }

  List<Widget> appBarMenuButton(Animation<double> progress) {
    List<Widget> toolBarWidgets = <Widget>[];
    if (widget.appBarActions != null) {
      toolBarWidgets = <Widget>[];
      for (int i = 0; i < widget.appBarActions.length; i++) {
        toolBarWidgets.add(widget.appBarActions[i]);
      }

      if (controller.value < 0.5) {
        toolBarWidgets = <Widget>[
          IconButton(
            icon: IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.white,
              ),
              onPressed: () {
                toggleBackdropPanelVisibility();
              },
            ),
            onPressed: () {},
          )
        ];
      }

      final Widget res = CrossFadeTransition(
        progress: controller,
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

  Size panelSize = const Size(0, 0);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        panelSize = constraints.biggest;
        double closedPercentage = 0;
        double closedPercentageSearch = 0;
        if (widget.enableBackPanelAnimation) {
          closedPercentage = widget.titleVisibleOnPanelClosed
              ? (panelSize.height - (panelSize.height - frontPanelHeight)) /
                  panelSize.height
              : 1.0;

          closedPercentageSearch = widget.titleVisibleOnPanelClosed
              ? (panelSize.height - (panelSize.height - (50 + 20))) /
                  panelSize.height
              : 1.0;
        } else {
          closedPercentage =
              (panelSize.height - (panelSize.height - frontPanelHeight)) /
                  panelSize.height;
          closedPercentageSearch = 0.0;
        }
        final Animation<Offset> panelDetailsPosition = Tween<Offset>(
                begin: Offset(0.0, closedPercentage),
                end: Offset(0.0, closedPercentageSearch))
            .animate(controller.view);
        return Theme(
          data: sampleListModel.themeData,
          child: Scaffold(
            resizeToAvoidBottomPadding: false,
            key: _scaffoldKey,
            backgroundColor: sampleListModel.backgroundColor,
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(60.0), // here the desired height
                child: AppBar(
                  automaticallyImplyLeading:
                      widget.appBarAutomaticallyImplyLeading,
                  title: CrossFadeTransition(
                    progress: controller,
                    alignment: AlignmentDirectional.centerStart,
                    child0:
                        Semantics(namesRoute: true, child: widget.appBarTitle),
                    child1: Semantics(namesRoute: true, child: const Text('')),
                  ),
                  actions: appBarMenuButton(controller),
                  elevation: 0.0,
                  backgroundColor: sampleListModel.backgroundColor,
                  iconTheme: widget.appBarIconTheme,
                  textTheme: widget.appBarTextTheme,
                  centerTitle: widget.appBarCenterTitle,
                  titleSpacing: widget.appBarTitleSpacing,
                )),
            drawer: widget.sideDrawer != null
                ? SizedBox(
                    width: panelSize.width * 3 / 4, child: widget.sideDrawer)
                : null,
            body: Stack(
              overflow: Overflow.clip,
              key: _backDropKey,
              children: <Widget>[
                Positioned(
                    top: _getParallax(),
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: widget.backLayer),
                SlideTransition(
                  position: panelDetailsPosition,
                  child: BackdropPanel(
                    onTap: toggleBackdropPanelVisibility,
                    borderRadius: widget.borderRadius,
                    shape: widget.shape,
                    onVerticalDragUpdate: _handleDragUpdate,
                    onVerticalDragEnd: _handleDragEnd,
                    frontHeader: widget.frontHeader,
                    frontHeaderHeight: widget.frontHeaderHeight,
                    padding: widget.frontPanelPadding,
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

  double _getParallax() {
    if (widget.enableBackPanelAnimation) {
      return -controller.value * frontPanelHeight * 0.5;
    } else {
      return 0;
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}

class CrossFadeTransition extends AnimatedWidget {
  const CrossFadeTransition({
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

class BackdropPanel extends StatelessWidget {
  const BackdropPanel({
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
