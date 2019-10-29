import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class RadialCompass extends StatefulWidget {
  const RadialCompass(this.sample, {Key key}) : super(key: key);
  final SubItemList sample;

  @override
  _RadialCompassState createState() => _RadialCompassState(sample);
}

class _RadialCompassState extends State<RadialCompass> {
  _RadialCompassState(this.sample);
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
  void didUpdateWidget(RadialCompass oldWidget) {
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
                          'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/gauge/annotation/direction_compass.dart');
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
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleListModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleListModel model) {
          return Scaffold(
            backgroundColor: model.cardThemeColor,
              body: Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
                child: Container(child: getRadialCompass(false)),
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

SfRadialGauge getRadialCompass(bool isTileView) {
  return SfRadialGauge(
    axes: <RadialAxis>[
      RadialAxis(showAxisLine: false,
        ticksPosition: ElementsPosition.outside,

        labelsPosition: ElementsPosition.outside,
        startAngle: 320, endAngle: 320, minorTicksPerInterval: 10,
        minimum: 0, maximum: 360, showLastLabel: false,
        interval: 30, labelOffset: 20,
        majorTickStyle: MajorTickStyle(length: 0.16,
            lengthUnit: GaugeSizeUnit.factor),
        minorTickStyle: MinorTickStyle(length: 0.16,
            lengthUnit: GaugeSizeUnit.factor, thickness: 1),
        axisLabelStyle: GaugeTextStyle(fontSize: 12),
        pointers: <GaugePointer>[MarkerPointer(value: 90,
            markerType: MarkerType.triangle),
            NeedlePointer(value: 310, needleLength: 0.5,
                lengthUnit: GaugeSizeUnit.factor,
              needleColor: const Color(0xFFC4C4C4), needleStartWidth: 1,
              needleEndWidth: 1, knobStyle: KnobStyle(knobRadius: 0),
              tailStyle: TailStyle(color: const Color(0xFFC4C4C4), width: 1,
                  lengthUnit: GaugeSizeUnit.factor,
                  length: 0.5)),
             NeedlePointer(value: 221, needleLength: 0.5,
               lengthUnit:GaugeSizeUnit.factor,
              needleColor: const Color(0xFFC4C4C4), needleStartWidth: 1,
              needleEndWidth: 1, knobStyle: KnobStyle(knobRadius: 0,
                 sizeUnit: GaugeSizeUnit.factor
               ),),
          NeedlePointer(value: 40, needleLength: 0.5,
            lengthUnit: GaugeSizeUnit.factor,
            needleColor: const Color(0xFFC4C4C4), needleStartWidth: 1,
            needleEndWidth: 1, knobStyle: KnobStyle(knobRadius: 0),)
        ],
        annotations: <GaugeAnnotation>[GaugeAnnotation(angle: 230, positionFactor: 0.38,
        widget: Container(child: Text('W',
            style: TextStyle(
                fontFamily: 'Times',
                fontWeight: FontWeight.bold,
                fontSize: isTileView ? 12 : 18)),)),
          GaugeAnnotation(angle: 310, positionFactor: 0.38,
              widget: Container(child: Text('N',
                  style: TextStyle(
                      fontFamily: 'Times',
                      fontWeight: FontWeight.bold,
                      fontSize:isTileView ? 12 : 18)),)),
          GaugeAnnotation(angle: 129, positionFactor: 0.38,
              widget: Container(child: Text('S',
                  style: TextStyle(
                      fontFamily: 'Times',
                      fontWeight: FontWeight.bold,
                      fontSize:isTileView ? 12 : 18)),)),
          GaugeAnnotation(angle: 50, positionFactor: 0.38,
              widget: Container(child: Text('E',
                  style: TextStyle(
                      fontFamily: 'Times',
                      fontWeight: FontWeight.bold,
                      fontSize: isTileView ? 12 : 18)),))
        ]
      )
    ],
  );
}



