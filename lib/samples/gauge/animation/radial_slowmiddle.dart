import 'dart:async';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class RadialSlowMiddleAnimation extends StatefulWidget {
  const RadialSlowMiddleAnimation(this.sample, {Key key}) : super(key: key);
  final SubItemList sample;

  @override
  _RadialSlowMiddleAnimationState createState() => _RadialSlowMiddleAnimationState(sample);
}

class _RadialSlowMiddleAnimationState extends State<RadialSlowMiddleAnimation> {
  _RadialSlowMiddleAnimationState(this.sample);
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
  void didUpdateWidget(RadialSlowMiddleAnimation oldWidget) {
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
                          'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/gauge/animation/radial_slowmiddle.dart');
                    },
                  ),
                ),
              ),
            ],
            appBarTitle: AnimatedSwitcher(
                duration: const Duration(milliseconds: 1000),
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
    return ScopedModelDescendant<SampleListModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleListModel model) {
          return Scaffold(
            backgroundColor: model.cardThemeColor,
              body: Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
                child: Container(child: getRadialSlowMiddleAnimation(false)),
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

SfRadialGauge getRadialSlowMiddleAnimation(bool isTileView) {
  return SfRadialGauge(
    axes: <RadialAxis>[
      RadialAxis(startAngle: 270, endAngle: 270, showAxisLine: false,
        ticksPosition: ElementsPosition.outside,
          labelsPosition: ElementsPosition.outside, minimum: 0, maximum: 12,
          interval: 1,   needsRotateLabels: true,
          majorTickStyle: MajorTickStyle(length: 0.15,
              lengthUnit: GaugeSizeUnit.factor, thickness: 1.5),
          minorTicksPerInterval: 4,  showFirstLabel: false,
          axisLabelStyle: GaugeTextStyle(fontSize: 12),
          minorTickStyle: MinorTickStyle(length: 0.07,
              lengthUnit: GaugeSizeUnit.factor, thickness: 1.5),
        pointers: <GaugePointer>[
          NeedlePointer(needleLength: 0.95, needleStartWidth: 0,
              lengthUnit: GaugeSizeUnit.factor,
            needleEndWidth: 5, needleColor: const Color(0xFFC06C84),
            knobStyle: KnobStyle(knobRadius: 0),
            value: 11, enableAnimation: true, animationType: AnimationType.slowMiddle
          ),
          NeedlePointer(needleLength: 0.7, needleStartWidth: 0,
            lengthUnit: GaugeSizeUnit.factor,
              needleEndWidth: 5, needleColor:  const Color(0xFFF67280),
              value: 2, enableAnimation: true, animationType: AnimationType.slowMiddle,
            knobStyle: KnobStyle(color: const Color(0xFFF67280),
                sizeUnit: GaugeSizeUnit.logicalPixel,
                knobRadius: 10),
          ),
          NeedlePointer(needleLength: 0.8, needleStartWidth: 1,
              lengthUnit: GaugeSizeUnit.factor,
              needleEndWidth: 1, needleColor: _slowMiddleNeedleColor,
              knobStyle: KnobStyle(knobRadius: 5, sizeUnit: GaugeSizeUnit.logicalPixel,
                  color: _slowMiddleNeedleColor),
              value: 10.4, enableAnimation: true, animationType: AnimationType.slowMiddle
          ),
        ]
      )
    ],
  );
}

Color _slowMiddleNeedleColor = const Color(0xFF355C7D);



