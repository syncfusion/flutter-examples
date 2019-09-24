import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class RangeDataLabelExample extends StatefulWidget {
  final SubItemList sample;
  const RangeDataLabelExample(this.sample, {Key key}) : super(key: key);

  @override
  _RangeDataLabelExampleState createState() => _RangeDataLabelExampleState(sample);
}

class _RangeDataLabelExampleState extends State<RangeDataLabelExample> {
  final SubItemList sample;
  _RangeDataLabelExampleState(this.sample);
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
  void didUpdateWidget(RangeDataLabelExample oldWidget) {
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
                child: Container(child: getRangeDataLabelExample(false)),
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

SfRadialGauge getRangeDataLabelExample(bool isTileView) {
  return SfRadialGauge(
    axes:<RadialAxis>[
      RadialAxis(showLabels: false, showAxisLine: false, showTicks: false,
        minimum: 0, maximum: 99, radiusFactor: 0.9,
        ranges: <GaugeRange>[GaugeRange(startValue: 0, endValue: 33,
          color: Color(0xFFFE2A25), label: 'Slow',
            sizeUnit: GaugeSizeUnit.factor,
          labelStyle: GaugeTextStyle(fontFamily: 'Times', fontSize: isTileView ? 16 : 20),
          startWidth: 0.65, endWidth: 0.65
        ),GaugeRange(startValue: 33, endValue: 66,
            color:Color(0xFFFFBA00), label: 'Moderate',
            labelStyle: GaugeTextStyle(fontFamily: 'Times', fontSize: isTileView ? 16 :  20),
            startWidth: 0.65, endWidth: 0.65, sizeUnit: GaugeSizeUnit.factor,
        ),
          GaugeRange(startValue: 66, endValue: 99,
            color:Color(0xFF00AB47), label: 'Fast',
            labelStyle: GaugeTextStyle(fontFamily: 'Times', fontSize: isTileView ? 16 :  20),
            sizeUnit: GaugeSizeUnit.factor,
            startWidth: 0.65, endWidth: 0.65,
          ),
          GaugeRange(startValue: 0, endValue: 99,
            color:Color.fromRGBO(155, 155, 155, 0.3),
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





