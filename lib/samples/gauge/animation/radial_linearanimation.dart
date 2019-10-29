import 'dart:async';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class RadialLinearAnimation extends StatefulWidget {
  const RadialLinearAnimation(this.sample, {Key key}) : super(key: key);
  final SubItemList sample;

  @override
  _RadialLinearAnimationState createState() => _RadialLinearAnimationState(sample);
}

class _RadialLinearAnimationState extends State<RadialLinearAnimation> {
  _RadialLinearAnimationState(this.sample);
  final SubItemList sample;
  bool panelOpen;

  final ValueNotifier<bool> frontPanelVisible = ValueNotifier<bool>(true);

  @override
  void initState() {
    panelOpen = frontPanelVisible.value;
    frontPanelVisible.addListener(_subscribeToValueNotifier);
    super.initState();
  }

  void _subscribeToValueNotifier() => panelOpen = frontPanelVisible.value;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(RadialLinearAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    frontPanelVisible.removeListener(_subscribeToValueNotifier);
    frontPanelVisible.addListener(_subscribeToValueNotifier);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleListModel>(
        builder: (BuildContext context, _, SampleListModel model) => SafeArea(
          child: Backdrop(
            needCloseButton: false,
            panelVisible: frontPanelVisible,
            sampleListModel: model,
            frontPanelOpenPercentage: 0.28,
            toggleFrontLayer: false,
            appBarAnimatedLeadingMenuIcon: AnimatedIcons.close_menu,
            appBarActions: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Container(
                  height: 40,
                  width: 40,
                  child: IconButton(
                    icon: Image.asset(model.codeViewerIcon,
                        color: Colors.white),
                    onPressed: () {
                      launch(
                          'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/gauge/animation/radial_linearanimation.dart');
                    },
                  ),
                ),
              ),
            ],
            appBarTitle: AnimatedSwitcher(
                duration: Duration(milliseconds: 1000),
                child: Text(sample.title.toString())),
            backLayer: BackPanel(sample),
            frontLayer: FrontPanel(sample),
            sideDrawer: null,
            headerClosingHeight: 350,
            titleVisibleOnPanelClosed: true,
            color: model.cardThemeColor,
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12), bottom: Radius.circular(0)),
          ),
        ));
  }
}

class FrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  FrontPanel(this.subItemList);
  final SubItemList subItemList;
  
  @override
  _FrontPanelState createState() => _FrontPanelState(subItemList);
}

class _FrontPanelState extends State<FrontPanel> {
  _FrontPanelState(this.sample);
  final SubItemList sample;
  Timer timer;

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState((){
      _radius = MediaQuery.of(context).orientation == Orientation.portrait ? 0.05 : 0.07;
    });
    return ScopedModelDescendant<SampleListModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleListModel model) {
          return Scaffold(
            backgroundColor: model.cardThemeColor,
              body: Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
                child: Container(child: getRadialLinearAnimation(false)),
              ));
        });
  }
}

class BackPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  BackPanel(this.sample);
  final SubItemList sample;

  @override
  _BackPanelState createState() => _BackPanelState(sample);
}

class _BackPanelState extends State<BackPanel> {
  _BackPanelState(this.sample);
  final SubItemList sample;
  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  void _afterLayout(dynamic _) {
    _getSizesAndPosition();
  }

  void _getSizesAndPosition() {
    final RenderBox renderBoxRed = _globalKey.currentContext.findRenderObject();
    final Size size = renderBoxRed.size;
    final Offset position = renderBoxRed.localToGlobal(Offset.zero);
    const double appbarHeight = 60;
    BackdropState.frontPanelHeight =
        position.dy + (size.height - appbarHeight) + 20;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleListModel>(
      rebuildOnChange: true,
      builder: (BuildContext context, _, SampleListModel model) {
        return Container(
          color: model.backgroundColor,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  sample.title,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28.0,
                      color: Colors.white,
                      letterSpacing: 0.53),
                ),
                Padding(
                  key: _globalKey,
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    sample.description,
                    style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15.0,
                        color: Colors.white,
                        letterSpacing: 0.3,
                        height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

SfRadialGauge getRadialLinearAnimation(bool isTileView) {
  final SfRadialGauge _gauge = SfRadialGauge(
    axes: <RadialAxis>[
      RadialAxis(startAngle: 270, endAngle: 270, showLabels: false,
          radiusFactor: 0.8,
          pointers: <GaugePointer>[MarkerPointer(markerHeight: 20, markerWidth: 20,
              markerType: MarkerType.triangle, markerOffset: 17, value: 80,
              enableAnimation: true, animationType: AnimationType.linear,
              color:  _linearMarkerColor),
            NeedlePointer(knobStyle: KnobStyle(knobRadius: isTileView? 0.065: _radius,
              color:  _linearNeedleColor

            ),
                needleStartWidth: 0, needleEndWidth: 5, value: 12,
                enableAnimation: true,animationType: AnimationType.linear,
                lengthUnit:GaugeSizeUnit.factor,
                needleLength: 0.8, needleColor: _linearNeedleColor )
          ],
          axisLineStyle: AxisLineStyle(
              thickness: 3), tickOffset: 2,
          majorTickStyle: MajorTickStyle(thickness: 2,
              length: 0.02, lengthUnit:GaugeSizeUnit.factor),
          minorTicksPerInterval: 0

      ),
    ],
  );

  return _gauge;
}

double _radius = 0.05;
Color _linearNeedleColor = const Color(0xFF355C7D);
Color _linearMarkerColor = const Color(0xFFF67280);





