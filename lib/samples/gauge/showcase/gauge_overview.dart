import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class GaugeOverviewExample extends StatefulWidget {
  const GaugeOverviewExample(this.sample, {Key key}) : super(key: key);
  final SubItemList sample;

  @override
  _GaugeOverviewExampleState createState() => _GaugeOverviewExampleState(sample);
}

class _GaugeOverviewExampleState extends State<GaugeOverviewExample> {
  _GaugeOverviewExampleState(this.sample);
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
  void didUpdateWidget(GaugeOverviewExample oldWidget) {
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
                          'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/gauge/showcase/gauge_overview.dart');
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
                child: Container(child: getGaugeOverviewExample(false)),
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

SfRadialGauge getGaugeOverviewExample(bool isTileView) {
  return SfRadialGauge(
    axes: <RadialAxis>[
      RadialAxis(startAngle: 130,
          endAngle: 50,
          minimum: -50,
          maximum: 150,
          interval:  isTileView ? 20 : _interval,
          minorTicksPerInterval: 9,
          showAxisLine: false,
          radiusFactor: 0.9,
          labelOffset: 8,
          ranges: <GaugeRange>[
            GaugeRange(startValue: -50,
                endValue: 0,
                startWidth: 0.265,
                sizeUnit: GaugeSizeUnit.factor,
                endWidth: 0.265,
                color: const Color.fromRGBO(34,144,199, 0.75)),
            GaugeRange(startValue: 0,
                endValue: 10,
                startWidth: 0.265,
                sizeUnit: GaugeSizeUnit.factor,
                endWidth: 0.265,
                color: const Color.fromRGBO(34,195,199, 0.75)),
            GaugeRange(startValue: 10,
                endValue: 30,
                startWidth: 0.265,
                sizeUnit: GaugeSizeUnit.factor,
                endWidth: 0.265,
                color: const Color.fromRGBO(123,199,34, 0.75)),
            GaugeRange(startValue: 30,
                endValue: 40,
                startWidth: 0.265,
                sizeUnit: GaugeSizeUnit.factor,
                endWidth: 0.265,
                color: const Color.fromRGBO(238,193,34, 0.75)),
            GaugeRange(startValue: 40,
                endValue: 150,
                startWidth: 0.265,
                sizeUnit: GaugeSizeUnit.factor,
                endWidth: 0.265,
                color: const Color.fromRGBO(238,79,34, 0.65)),
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(angle: 90, positionFactor: 0.35,
                widget:  Container(child: const Text(
                    'Temp.°C', style:  TextStyle(color: Color(0xFFF8B195),
                    fontSize: 16)))),
            GaugeAnnotation(angle: 90, positionFactor: 0.8,
                widget: Container(
                  child: const Text('  22.5  ', style: TextStyle(
                    fontWeight: FontWeight.bold,
                      fontSize: 20),),
                )
            )
          ],

          pointers: <GaugePointer>[
            NeedlePointer(value: 22.5,
              needleLength: 0.6,
              lengthUnit: GaugeSizeUnit.factor,
              needleStartWidth: isTileView ? 0 : 1,
              needleEndWidth:isTileView ?  5 : 8,
              animationType: AnimationType.easeOutBack,
              enableAnimation: true,
              animationDuration: 1200,
              knobStyle: KnobStyle(knobRadius: isTileView ? 0.06 : 0.09,
                  sizeUnit: GaugeSizeUnit.factor,
                  borderColor: const Color(0xFFF8B195),
                  color: Colors.white,
                  borderWidth: isTileView ? 0.035 : 0.05),
              tailStyle: TailStyle(color: const Color(0xFFF8B195),
                  width:isTileView ?  4 : 8,
                  lengthUnit: GaugeSizeUnit.factor,
                  length: isTileView ? 0.15 : 0.2),
              needleColor: const Color(0xFFF8B195),)
          ],
          axisLabelStyle: GaugeTextStyle(fontSize: isTileView ? 10 : 12),
          majorTickStyle: MajorTickStyle(
              length: 0.25, lengthUnit: GaugeSizeUnit.factor,
              thickness: 1.5),
          minorTickStyle: MinorTickStyle(length: 0.13,
              lengthUnit: GaugeSizeUnit.factor,
              thickness: 1)
      )

    ],
  );
}

double _interval = 10;




