import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class RangeDataLabelExample extends StatefulWidget {
  const RangeDataLabelExample(this.sample, {Key key}) : super(key: key);
  final SubItemList sample;

  @override
  _RangeDataLabelExampleState createState() => _RangeDataLabelExampleState(sample);
}

class _RangeDataLabelExampleState extends State<RangeDataLabelExample> {
  _RangeDataLabelExampleState(this.sample);
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
  void didUpdateWidget(RangeDataLabelExample oldWidget) {
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
                          'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/gauge/ranges/range_dataLabel.dart');
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
    return ScopedModelDescendant<SampleListModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleListModel model) {
          return Scaffold(
            backgroundColor: model.cardThemeColor,
              body: Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
                child: Container(child: getRangeDataLabelExample(false)),
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

SfRadialGauge getRangeDataLabelExample(bool isTileView) {
  return SfRadialGauge(
    axes:<RadialAxis>[
      RadialAxis(showLabels: false, showAxisLine: false, showTicks: false,
        minimum: 0, maximum: 99, radiusFactor: 0.9,
        ranges: <GaugeRange>[GaugeRange(startValue: 0, endValue: 33,
          color: const Color(0xFFFE2A25), label: 'Slow',
            sizeUnit: GaugeSizeUnit.factor,
          labelStyle: GaugeTextStyle(fontFamily: 'Times', fontSize: isTileView ? 16 : 20),
          startWidth: 0.65, endWidth: 0.65
        ),GaugeRange(startValue: 33, endValue: 66,
            color: const Color(0xFFFFBA00), label: 'Moderate',
            labelStyle: GaugeTextStyle(fontFamily: 'Times', fontSize: isTileView ? 16 :  20),
            startWidth: 0.65, endWidth: 0.65, sizeUnit: GaugeSizeUnit.factor,
        ),
          GaugeRange(startValue: 66, endValue: 99,
            color: const Color(0xFF00AB47), label: 'Fast',
            labelStyle: GaugeTextStyle(fontFamily: 'Times', fontSize: isTileView ? 16 :  20),
            sizeUnit: GaugeSizeUnit.factor,
            startWidth: 0.65, endWidth: 0.65,
          ),
          GaugeRange(startValue: 0, endValue: 99,
            color: const Color.fromRGBO(155, 155, 155, 0.3),
         rangeOffset: 0.5,  sizeUnit: GaugeSizeUnit.factor,
            startWidth: 0.15, endWidth: 0.15,
          ),
        ],
        pointers: <GaugePointer>[NeedlePointer(value: 60, needleLength: 0.7,
            lengthUnit: GaugeSizeUnit.factor,
        needleStartWidth: 1, needleEndWidth: 10,
          knobStyle: KnobStyle(knobRadius: 12,
            sizeUnit: GaugeSizeUnit.logicalPixel,
             )
        )]
      )
    ],
  );
}





