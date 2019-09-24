import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class GaugeCustomLabels extends StatefulWidget {
  final SubItemList sample;
  const GaugeCustomLabels(this.sample, {Key key}) : super(key: key);

  @override
  _GaugeCustomLabelsState createState() => _GaugeCustomLabelsState(sample);
}

class _GaugeCustomLabelsState extends State<GaugeCustomLabels> {
  final SubItemList sample;
  _GaugeCustomLabelsState(this.sample);
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
  void didUpdateWidget(GaugeCustomLabels oldWidget) {
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
                          'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/gauge/axis_feature/custom_labels.dart');
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
      _endWidth = MediaQuery.of(context).orientation == Orientation.portrait ? 18 : 10;
      if(Theme.of(context).brightness == Brightness.dark){
        _cutsomLabelNeedleColor = const Color(0xFF888888);
      }else{
        _cutsomLabelNeedleColor = const Color(0xFFFCACACA);
      }
    });
    return ScopedModelDescendant<SampleListModel>(
        rebuildOnChange: true,
        builder: (context, _, model) {
          return Scaffold(
            backgroundColor: model.cardThemeColor,
              body: Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
                child: Container(child: getGaugeCustomLabels(false)),
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

SfRadialGauge getGaugeCustomLabels(bool isTileView) {
  return SfRadialGauge(
    axes: <RadialAxis>[
      RadialAxis(startAngle: 270,
        endAngle: 270, radiusFactor: 0.9,
        minimum: 0, maximum: 80,
        axisLineStyle: AxisLineStyle(
            thicknessUnit: GaugeSizeUnit.factor,
            thickness: 0.1
        ),
        interval: 10, needsRotateLabels: true,
        axisLabelStyle: GaugeTextStyle(fontSize: 12),
        minorTicksPerInterval: 0,
        majorTickStyle: MajorTickStyle(thickness: 1.5,
            lengthUnit: GaugeSizeUnit.factor,
            length: 0.07),
        showLabels: true, onLabelCreated: labelCreated,
        pointers: <GaugePointer>[
          NeedlePointer(value: 70, lengthUnit: GaugeSizeUnit.factor,
              needleLength: 0.55, needleEndWidth:  isTileView ? 10 : _endWidth,
              needleColor: Color(0xFFF67280), knobStyle: KnobStyle(knobRadius: 0.1,
                  sizeUnit: GaugeSizeUnit.factor,
                  color: Colors.white)),

          NeedlePointer(value: 30, needleLength: 0.55,
             lengthUnit: GaugeSizeUnit.factor, needleColor: _cutsomLabelNeedleColor,
              needleEndWidth: isTileView ? 10 : _endWidth,
              knobStyle:KnobStyle(knobRadius:  0.1,
                  sizeUnit: GaugeSizeUnit.factor,
                  color: Colors.white)
          )
        ],
      )
    ],
  );
}

double _endWidth = 18;
Color _cutsomLabelNeedleColor = const Color(0xFFFCACACA);

void labelCreated(AxisLabelCreatedArgs args){
  if(args.text == '80' || args.text == '0'){
    args.text ='N';
  }else if(args.text == '10'){
    args.text ='NE';
  }else if(args.text == '20'){
    args.text ='E';
  }else if(args.text == '30'){
    args.text ='SE';
  }else if(args.text == '40'){
    args.text ='S';
  }else if(args.text == '50'){
    args.text ='SW';
  }else if(args.text == '60'){
    args.text ='W';
  }else if(args.text == '70'){
    args.text ='NW';
  }
}







