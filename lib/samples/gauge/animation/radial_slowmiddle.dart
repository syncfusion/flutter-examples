import 'dart:async';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class RadialSlowMiddleAnimation extends StatefulWidget {
  final SubItemList sample;
  const RadialSlowMiddleAnimation(this.sample, {Key key}) : super(key: key);

  @override
  _RadialSlowMiddleAnimationState createState() => _RadialSlowMiddleAnimationState(sample);
}

class _RadialSlowMiddleAnimationState extends State<RadialSlowMiddleAnimation> {
  final SubItemList sample;
  _RadialSlowMiddleAnimationState(this.sample);
  bool panelOpen;

  final frontPanelVisible = ValueNotifier<bool>(true);

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
        builder: (context, _, model) => SafeArea(
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
                duration: Duration(milliseconds: 1000),
                child: Text(sample.title.toString())),
            backLayer: BackPanel(sample),
            frontLayer: FrontPanel(sample),
            sideDrawer: null,
            headerClosingHeight: 350,
            titleVisibleOnPanelClosed: true,
            color: model.cardThemeColor,
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(12), bottom: Radius.circular(0)),
          ),
        ));
  }
}

class FrontPanel extends StatefulWidget {
  final SubItemList subItemList;
  FrontPanel(this.subItemList);

  @override
  _FrontPanelState createState() => _FrontPanelState(this.subItemList);
}

class _FrontPanelState extends State<FrontPanel> {
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


  _FrontPanelState(this.sample);
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleListModel>(
        rebuildOnChange: true,
        builder: (context, _, model) {
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
  final SubItemList sample;
  BackPanel(this.sample);

  @override
  _BackPanelState createState() => _BackPanelState(sample);
}

class _BackPanelState extends State<BackPanel> {
  final SubItemList sample;
  GlobalKey _globalKey = GlobalKey();
  _BackPanelState(this.sample);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  _afterLayout(_) {
    _getSizesAndPosition();
  }

  _getSizesAndPosition() {
    final RenderBox renderBoxRed = _globalKey.currentContext.findRenderObject();
    final size = renderBoxRed.size;
    final position = renderBoxRed.localToGlobal(Offset.zero);
    double appbarHeight = 60;
    BackdropState.frontPanelHeight =
        position.dy + (size.height - appbarHeight) + 20;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleListModel>(
      rebuildOnChange: true,
      builder: (context, _, model) {
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
            needleEndWidth: 5, needleColor: Color(0xFFC06C84),
            knobStyle: KnobStyle(knobRadius: 0),
            value: 11, enableAnimation: true, animationType: AnimationType.slowMiddle
          ),
          NeedlePointer(needleLength: 0.7, needleStartWidth: 0,
            lengthUnit: GaugeSizeUnit.factor,
              needleEndWidth: 5, needleColor:  Color(0xFFF67280),
              value: 2, enableAnimation: true, animationType: AnimationType.slowMiddle,
            knobStyle: KnobStyle(color: Color(0xFFF67280),
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



