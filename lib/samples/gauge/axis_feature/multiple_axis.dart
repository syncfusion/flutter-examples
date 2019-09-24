import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class MultipleAxisExample extends StatefulWidget {
  final SubItemList sample;
  const MultipleAxisExample(this.sample, {Key key}) : super(key: key);

  @override
  _MultipleAxisExampleState createState() => _MultipleAxisExampleState(sample);
}

class _MultipleAxisExampleState extends State<MultipleAxisExample> {
  final SubItemList sample;
  _MultipleAxisExampleState(this.sample);
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
  void didUpdateWidget(MultipleAxisExample oldWidget) {
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
                          'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/gauge/axis_feature/multiple_axis.dart');
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
    setState((){
      _radius = MediaQuery.of(context).orientation == Orientation.portrait ?  0.6 :  0.5;
    });
    return ScopedModelDescendant<SampleListModel>(
        rebuildOnChange: true,
        builder: (context, _, model) {
          return Scaffold(
            backgroundColor: model.cardThemeColor,
              body: Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
                child: Container(child: getMultipleAxisGauge(false)),
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

SfRadialGauge getMultipleAxisGauge(bool isTileView) {
  return SfRadialGauge(
    axes: <RadialAxis>[

      RadialAxis(minimum:  32 , maximum: 212, interval: 36,
        radiusFactor: isTileView ? 0.5 :_radius, labelOffset: 15, needsRotateLabels: true,
        minorTickStyle: MinorTickStyle(color: Color(0xFF00A8B5), thickness: 1.5,
            lengthUnit: GaugeSizeUnit.factor,
            length: 0.07),
        majorTickStyle: MajorTickStyle(color: Color(0xFF00A8B5), thickness: 1.5,
            lengthUnit: GaugeSizeUnit.factor,
            length: 0.15),
        axisLineStyle: AxisLineStyle(color:Color(0xFF00A8B5), thickness: 3, ),
        axisLabelStyle: GaugeTextStyle(color: Color(0xFF00A8B5), fontSize: 12),

      ),
      RadialAxis(minimum:  0 , maximum: 100, interval: 10,
          ticksPosition: ElementsPosition.outside,
          labelsPosition: ElementsPosition.outside,

          minorTicksPerInterval: 5,
          radiusFactor: 0.95, labelOffset: 15,
          minorTickStyle: MinorTickStyle( thickness: 1.5,
              length: 0.07, lengthUnit: GaugeSizeUnit.factor),
          majorTickStyle: MinorTickStyle(thickness: 1.5,
              length: 0.15, lengthUnit: GaugeSizeUnit.factor,),
          axisLineStyle: AxisLineStyle( thickness: 3, ),
          axisLabelStyle: GaugeTextStyle(fontSize: 12),
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(angle: 90, positionFactor: 1,
              widget: Row(children: <Widget>[Container(child: Text('33°C  :', style: TextStyle(fontSize: 12,
                   fontWeight: FontWeight.bold, fontFamily: 'Times'),)),
                Container(child: Text(' 91.4°F', style: TextStyle(fontSize: 12,
                    color: Color(0xFF00A8B5), fontWeight: FontWeight.bold, fontFamily: 'Times'),))],)
            )
          ],
          pointers: <GaugePointer>[NeedlePointer(needleLength: 0.68,
           lengthUnit: GaugeSizeUnit.factor,
              needleStartWidth: 0, needleEndWidth: 3, value: 33,
              enableAnimation: true,
              knobStyle: KnobStyle(knobRadius: 6.5,
                  sizeUnit: GaugeSizeUnit.logicalPixel
              ),)]
      ),
    ]
  );
}

double _radius = 0.6;





