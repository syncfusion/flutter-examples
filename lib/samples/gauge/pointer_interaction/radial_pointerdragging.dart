import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class RadialPointerDragging extends StatefulWidget {
  const RadialPointerDragging(this.sample, {Key key}) : super(key: key);
  final SubItemList sample;

  @override
  _RadialPointerDraggingState createState() => _RadialPointerDraggingState(sample);
}

class _RadialPointerDraggingState extends State<RadialPointerDragging> {
  _RadialPointerDraggingState(this.sample);
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
  void didUpdateWidget(RadialPointerDragging oldWidget) {
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
                          'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/gauge/pointer_interaction/radial_pointerdragging.dart');
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
  //ignore:prefer_const_constructors_in_immutables
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
    setState((){
      _interval = MediaQuery.of(context).orientation == Orientation.portrait ?  10 :  20;
    });
    return ScopedModelDescendant<SampleListModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleListModel model) {
          return Scaffold(
            backgroundColor: model.cardThemeColor,
              body: Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
                child: Container(child: getRadialPointerDragging(false)),
              ));
        });
  }
}

class BackPanel extends StatefulWidget {
  //ignore:prefer_const_constructors_in_immutables
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

SfRadialGauge getRadialPointerDragging(bool isTileView) {
  return SfRadialGauge(
    axes:<RadialAxis>[
      RadialAxis(minimum: 0, maximum: 120, showLabels: true,
        radiusFactor: 0.95,
        offsetUnit: GaugeSizeUnit.factor,
        interval: isTileView ? 20 : _interval, tickOffset: 0.2, labelOffset: 0.1,
        minorTicksPerInterval: 7,
        axisLineStyle: AxisLineStyle(thickness: 0.1, thicknessUnit: GaugeSizeUnit.factor,
          color: Colors.transparent
        ),
        minorTickStyle: MinorTickStyle(thickness: 1,
            lengthUnit: GaugeSizeUnit.factor,
            length: 0.06),
          majorTickStyle: MajorTickStyle(thickness: 1, length: 0.15,
              lengthUnit: GaugeSizeUnit.factor),
        axisLabelStyle: GaugeTextStyle(fontSize: 12),
        pointers: <GaugePointer>[MarkerPointer(value: 25, enableDragging: true,
          markerHeight: 30, markerWidth: 30, offsetUnit: GaugeSizeUnit.factor,

          color: Colors.white,
          markerType: MarkerType.circle, borderWidth: 8,borderColor: const Color(0xFFFFCD60)
        ),
        ],
        ranges: <GaugeRange>[GaugeRange(startValue: 0, endValue: 19.5,
            color: const Color(0xFF355C7D),
            sizeUnit: GaugeSizeUnit.factor,
            startWidth: 0.1, endWidth: 0.1),
          GaugeRange(startValue: 20, endValue: 39.5,
              color: const Color(0xFFC06C84),
              sizeUnit: GaugeSizeUnit.factor,
              startWidth: 0.1, endWidth: 0.1),
          GaugeRange(startValue: 40, endValue: 59.5,
              color: const Color(0xFFF67280),
              sizeUnit: GaugeSizeUnit.factor,
              startWidth: 0.1, endWidth: 0.1),
          GaugeRange(startValue: 60, endValue: 79.5,
              color: const Color(0xFFF8B195),
              sizeUnit: GaugeSizeUnit.factor,
              startWidth: 0.1, endWidth: 0.1),
          GaugeRange(startValue: 80, endValue: 99.5,
              color: const Color(0xFF74B49B),
              sizeUnit: GaugeSizeUnit.factor,
              startWidth: 0.1, endWidth: 0.1),
          GaugeRange(startValue: 100, endValue: 120,
              color: const Color(0xFF00A8B5),
              sizeUnit: GaugeSizeUnit.factor,
              startWidth: 0.1, endWidth: 0.1),
        ]
      )
    ],
  );
}

double _interval = 10;



