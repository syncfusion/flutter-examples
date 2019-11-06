import 'dart:async';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ClockExample extends StatefulWidget {
  const ClockExample(this.sample, {Key key}) : super(key: key);
  final SubItemList sample;

  @override
  _ClockExampleState createState() => _ClockExampleState(sample);
}

class _ClockExampleState extends State<ClockExample> {
  _ClockExampleState(this.sample);
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
  void didUpdateWidget(ClockExample oldWidget) {
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
                          'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/gauge/showcase/clock_sample.dart');
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
  //ignore:prefer_const_constructors_in_immutables
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
    timer = Timer.periodic(const Duration(milliseconds: 1000), updateData);
  }

  void updateData(Timer timer){
    final double _previousValue = _value;
    setState((){
      if(_previousValue >= 0 &&_previousValue < 12){
        _value = _value + 0.2;
      }
      else {

        _value = 0.2;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }


  @override
  Widget build(BuildContext context) {
    setState((){
      _centerX = MediaQuery.of(context).orientation == Orientation.portrait ? 0.3 : 0.45;
    });

    return ScopedModelDescendant<SampleListModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleListModel model) {
          return Scaffold(
            backgroundColor: model.cardThemeColor,
              body: Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
                child: Container(child: getClockExample(false)),
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

SfRadialGauge getClockExample(bool isTileView) {
  return SfRadialGauge(
    axes: <RadialAxis>[
      RadialAxis(startAngle: 270,
          endAngle: 270,
          radiusFactor: 0.2,
          axisLabelStyle: GaugeTextStyle(fontSize: 6),
          minimum: 0,
          maximum: 12,
          showFirstLabel: false,
          offsetUnit: GaugeSizeUnit.factor,
          interval: 2,
          centerY: 0.65,
          tickOffset: 0.03,
          minorTicksPerInterval: 5,
          labelOffset: 0.2,
          minorTickStyle: MinorTickStyle(
              length: 0.09, lengthUnit: GaugeSizeUnit.factor,
              thickness: 0.5),
          majorTickStyle: MajorTickStyle(length: 0.15,
              lengthUnit: GaugeSizeUnit.factor,
              thickness: 1),
          axisLineStyle: AxisLineStyle(
              thickness: 0.03, thicknessUnit: GaugeSizeUnit.factor
          ),
          pointers: <GaugePointer>[
            NeedlePointer(value: 5,
              needleLength: 0.7,
              lengthUnit: GaugeSizeUnit.factor,
              needleColor: const Color(0xFF00A8B5),
              needleStartWidth: 0.5,
              needleEndWidth: 1,
              knobStyle: KnobStyle(knobRadius: 0,),
            )
          ]
      ),
      RadialAxis(startAngle: 270,
          endAngle: 270,
          axisLabelStyle: GaugeTextStyle(fontSize: 6,),
          radiusFactor: 0.2,
          labelOffset: 0.2,
          offsetUnit: GaugeSizeUnit.factor,
          minimum: 0,
          maximum: 12,
          showFirstLabel: false,
          interval: 2,
          centerX: isTileView ? 0.39 : _centerX,
          minorTicksPerInterval: 5,
          tickOffset: 0.03,
          minorTickStyle: MinorTickStyle(length: 0.09,
              lengthUnit: GaugeSizeUnit.factor,
              thickness: 0.5),
          majorTickStyle: MajorTickStyle(length: 0.15,
            lengthUnit: GaugeSizeUnit.factor,
            thickness: 1,),
          axisLineStyle: AxisLineStyle(
              thicknessUnit: GaugeSizeUnit.factor,
              thickness: 0.03
          ),
          pointers: <GaugePointer>[
            NeedlePointer(value: 8,
              needleLength: 0.7,
              lengthUnit: GaugeSizeUnit.factor,
              needleColor: const Color(0xFF00A8B5),
              needleStartWidth: 0.5,
              needleEndWidth: 1,
              knobStyle: KnobStyle(knobRadius: 0),
            )
          ]
      ),
      RadialAxis(startAngle: 270,
          endAngle: 270,
          minimum: 0,
          maximum: 12,
          showFirstLabel: false,
          interval: 1,
          radiusFactor: 0.95,
          labelOffset: 0.1,
          offsetUnit: GaugeSizeUnit.factor,
          minorTicksPerInterval: 4,
          tickOffset: 0.03,
          minorTickStyle: MinorTickStyle(length: 0.06,
              lengthUnit: GaugeSizeUnit.factor,
              thickness: 1),
          majorTickStyle: MajorTickStyle(length: 0.1,
              lengthUnit: GaugeSizeUnit.factor,
              thickness: 1.5),
          axisLabelStyle: GaugeTextStyle(fontSize: isTileView ? 12 : 14),
          axisLineStyle: AxisLineStyle(
              thickness: 0.01, thicknessUnit: GaugeSizeUnit.factor
          ),
          pointers: <GaugePointer>[


            NeedlePointer(needleLength: 0.6,
                lengthUnit: GaugeSizeUnit.factor,
                needleStartWidth: 1,
                needleEndWidth: 2,
                value: 10,
                needleColor:  _needleColor,
                knobStyle: KnobStyle(knobRadius: 0)
            ),
            NeedlePointer(needleLength: 0.85,
                lengthUnit: GaugeSizeUnit.factor,
                needleStartWidth: 0.5,
                needleEndWidth: 1.5,
                value: 2,
                knobStyle: KnobStyle(color: const Color(0xFF00A8B5),
                    sizeUnit: GaugeSizeUnit.factor,
                    knobRadius: 0.05),
                needleColor:  _needleColor
            ),
            NeedlePointer(needleLength: 0.9,
                lengthUnit: GaugeSizeUnit.factor,
                enableAnimation: true,
                animationType: AnimationType.bounceOut,
                needleStartWidth: 0.8,
                needleEndWidth: 0.8,
                value: _value,
                needleColor: const Color(0xFF00A8B5),
                tailStyle: TailStyle(width: 0.8, length: 0.2,
                    lengthUnit: GaugeSizeUnit.factor,
                    color: const Color(0xFF00A8B5)),
                knobStyle: KnobStyle(knobRadius: 0.03,
                    sizeUnit: GaugeSizeUnit.factor,
                    color: Colors.white)
            ),
          ]
      ),
    ],
  );
}

double _value = 0;
double _centerX = 0.3;
Color _needleColor = const Color(0xFF355C7D);





