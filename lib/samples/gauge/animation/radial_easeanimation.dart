import 'dart:async';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class RadialEaseExample extends StatefulWidget {
  final SubItemList sample;
  const RadialEaseExample(this.sample, {Key key}) : super(key: key);

  @override
  _RadialEaseExampleState createState() => _RadialEaseExampleState(sample);
}

class _RadialEaseExampleState extends State<RadialEaseExample> {
  final SubItemList sample;
  _RadialEaseExampleState(this.sample);
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
  void didUpdateWidget(RadialEaseExample oldWidget) {
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
                          'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/gauge/animation/radial_easeanimation.dart');
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
    setState((){
      _interval = MediaQuery.of(context).orientation == Orientation.portrait ?  1 :  2;
    });
    return ScopedModelDescendant<SampleListModel>(
        rebuildOnChange: true,
        builder: (context, _, model) {
          return Scaffold(
            backgroundColor: model.cardThemeColor,
              body: Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
                child: Container(child: getRadialEaseExample(false)),
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

SfRadialGauge getRadialEaseExample(bool isTileView) {
  return SfRadialGauge(
    axes: <RadialAxis>[
      RadialAxis(startAngle: 0, endAngle: 360, showLabels: false, showTicks: false,
    radiusFactor: 0.9, axisLineStyle: AxisLineStyle(
              thicknessUnit: GaugeSizeUnit.factor,
              thickness: isTileView ? 0.07 : 0.1)
  ),
      RadialAxis(startAngle: 170, endAngle: 170, showTicks: false, labelFormat: '{value}M',
        showAxisLine: false, radiusFactor: 0.9, minimum: 0, maximum: 15, showLastLabel: false,
        axisLabelStyle: GaugeTextStyle(fontSize: isTileView ? 10 : 12, fontWeight: FontWeight.w500),
          labelOffset: 25, interval: isTileView ? 1: _interval,
        needsRotateLabels: true,
        annotations: <GaugeAnnotation>[
          GaugeAnnotation( positionFactor: 1, axisValue: 0,
        widget: Container(height: isTileView ? 30 : 45, width:isTileView ? 30 : 45,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: ExactAssetImage('images/shotput.png'),
                fit: BoxFit.fitHeight,
              ),
        ))),

          GaugeAnnotation(widget: Container(child: Text('Distance',
              style: TextStyle( fontSize: 20)),))
        ],
        pointers: <GaugePointer>[
          RangePointer(value: 11.5, width:  0.1, color: Color(0xFFF67280),
            enableAnimation: true, sizeUnit: GaugeSizeUnit.factor,
            animationType: AnimationType.ease,),
          MarkerPointer(value: 11.5, markerType: MarkerType.image,
              enableAnimation: true, animationType: AnimationType.ease,
              imageUrl: 'images/ball.png' , markerHeight: isTileView ? 30 : 40,
              markerOffset:   4, markerWidth: isTileView ? 30 : 40),
        ]
      )

    ],
  );
}

double _interval = 1;

