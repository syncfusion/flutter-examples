import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../model/model.dart';

// ignore: must_be_immutable
class GaugeCompassExample extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  GaugeCompassExample({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _GaugeCompassExampleState createState() => _GaugeCompassExampleState(sample);
}

class _GaugeCompassExampleState extends State<GaugeCompassExample> {
  _GaugeCompassExampleState(this.sample);
  final SubItem sample;
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
  void didUpdateWidget(GaugeCompassExample oldWidget) {
    super.didUpdateWidget(oldWidget);
    frontPanelVisible.removeListener(_subscribeToValueNotifier);
    frontPanelVisible.addListener(_subscribeToValueNotifier);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleModel>(
        builder: (BuildContext context, _, SampleModel model) => SafeArea(
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
                              'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/gauge/showcase/distance_tracker.dart');
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
                color: const Color(0xFF484848),
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12), bottom: Radius.circular(0)),
              ),
            ));
  }
}

class FrontPanel extends StatefulWidget {
  //ignore:prefer_const_constructors_in_immutables
  FrontPanel(this.subItemList);
  final SubItem subItemList;

  @override
  _FrontPanelState createState() => _FrontPanelState(subItemList);
}

class _FrontPanelState extends State<FrontPanel> {
  _FrontPanelState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    setState(() {
      if (MediaQuery.of(context).orientation == Orientation.portrait) {
        _annotationTextSize = 22;
        _markerOffset = 0.71;
        _positionFactor = 0.025;
        _markerHeight = 10;
        _markerWidth = 15;
        _labelfontSize = 11;
      } else {
        _annotationTextSize = 16;
        _markerOffset = 0.69;
        _positionFactor = 0.05;
        _markerHeight = 5;
        _markerWidth = 10;
        _labelfontSize = 10;
      }
    });
    return ScopedModelDescendant<SampleModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleModel model) {
          return Scaffold(
              backgroundColor: model.cardThemeColor,
              //    backgroundColor: const Color(0xFF484848),
              body: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: const <Color>[
                      Color(0xFF484848),
                      Color(0xFF030303)
                    ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
                    child: Container(child: getGaugeCompassExample(false)),
                  )));
        });
  }
}

class BackPanel extends StatefulWidget {
  //ignore:prefer_const_constructors_in_immutables
  BackPanel(this.sample);
  final SubItem sample;

  @override
  _BackPanelState createState() => _BackPanelState(sample);
}

class _BackPanelState extends State<BackPanel> {
  _BackPanelState(this.sample);
  final SubItem sample;
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
    return ScopedModelDescendant<SampleModel>(
      rebuildOnChange: true,
      builder: (BuildContext context, _, SampleModel model) {
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

Widget getGaugeCompassExample(bool isTileView) {
  _isTileView = isTileView;
  final Widget _widget = SfRadialGauge(
    axes: <RadialAxis>[
      RadialAxis(
          showAxisLine: false,
          radiusFactor: 1,
          showLastLabel: false,
          needsRotateLabels: true,
          tickOffset: 0.32,
          offsetUnit: GaugeSizeUnit.factor,
          onLabelCreated: axisLabelCreated,
          startAngle: 270,
          endAngle: 270,
          labelOffset: 0.05,
          maximum: 360,
          minimum: 0,
          interval: 30,
          minorTicksPerInterval: 4,
          axisLabelStyle: GaugeTextStyle(
              color: const Color(0xFF949494),
              fontSize: isTileView ? 10 : _labelfontSize),
          minorTickStyle: MinorTickStyle(
              color: const Color(0xFF616161),
              thickness: 1.6,
              length: 0.058,
              lengthUnit: GaugeSizeUnit.factor),
          majorTickStyle: MajorTickStyle(
              color: const Color(0xFF949494),
              thickness: 2.3,
              length: 0.087,
              lengthUnit: GaugeSizeUnit.factor),
          backgroundImage: const AssetImage('images/dark_theme_gauge.png'),
          pointers: <GaugePointer>[
            MarkerPointer(
                value: 90,
                color: const Color(0xFFDF5F2D),
                enableAnimation: true,
                animationDuration: 1200,
                markerOffset: isTileView ? 0.69 : _markerOffset,
                offsetUnit: GaugeSizeUnit.factor,
                markerType: MarkerType.triangle,
                markerHeight: isTileView ? 8 : _markerHeight,
                markerWidth: isTileView ? 8 : _markerWidth)
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
                angle: 270,
                positionFactor: _positionFactor,
                widget: Text(
                  '90',
                  style: TextStyle(
                      color: const Color(0xFFDF5F2D),
                      fontWeight: FontWeight.bold,
                      fontSize: isTileView ? 16 : _annotationTextSize),
                ))
          ])
    ],
  );
  if (kIsWeb) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: _widget,
    );
  } else {
    return _widget;
  }
}

void axisLabelCreated(AxisLabelCreatedArgs args) {
  if (args.text == '90') {
    args.text = 'E';
    args.labelStyle = GaugeTextStyle(
        color: const Color(0xFFDF5F2D),
        fontSize: _isTileView ? 10 : _labelfontSize);
  } else {
    if (args.text == '0') {
      args.text = 'N';
    } else if (args.text == '180') {
      args.text = 'S';
    } else if (args.text == '270') {
      args.text = 'W';
    }

    args.labelStyle = GaugeTextStyle(
        color: const Color(0xFFFFFFFF),
        fontSize: _isTileView ? 10 : _labelfontSize);
  }
}

double _annotationTextSize = 22;
double _positionFactor = 0.025;
double _markerHeight = 10;
double _markerWidth = 15;
double _markerOffset = 0.71;
bool _isTileView = true;
double _labelfontSize = 10;
