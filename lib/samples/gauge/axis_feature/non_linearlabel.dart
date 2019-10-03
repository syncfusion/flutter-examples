import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class RadialNonLinearLabel extends StatefulWidget {
  final SubItemList sample;
  const  RadialNonLinearLabel (this.sample, {Key key}) : super(key: key);

  @override
  _RadialNonLinearLabelState createState() => _RadialNonLinearLabelState(sample);
}

class _RadialNonLinearLabelState extends State<RadialNonLinearLabel> {
  final SubItemList sample;
  _RadialNonLinearLabelState(this.sample);
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
  void didUpdateWidget(RadialNonLinearLabel oldWidget) {
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
                          'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/gauge/axis_feature/non_linearlabel.dart');
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
            color: model.cardThemeColor,
            titleVisibleOnPanelClosed: true,
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
      _radius = MediaQuery.of(context).orientation == Orientation.portrait ?  0.06 :  0.1;
    });
    return ScopedModelDescendant<SampleListModel>(
        rebuildOnChange: true,
        builder: (context, _, model) {
          return Scaffold(
            backgroundColor: model.cardThemeColor,
              body: Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
                child: Container(child: getRadialNonLinearLabel(false)),
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

SfRadialGauge getRadialNonLinearLabel(bool isTileView) {
  return SfRadialGauge(
    axes: <RadialAxis>[
      CustomAxis(labelOffset: 15,
          axisLineStyle: AxisLineStyle(
            thicknessUnit: GaugeSizeUnit.factor,
            thickness: 0.15
          ),
          radiusFactor: 0.9, minimum: 0,
          showTicks: false, maximum: 150,
          axisLabelStyle: GaugeTextStyle(
              fontSize: 12),
          pointers: <GaugePointer>[NeedlePointer(enableAnimation: true,
              animationType: AnimationType.easeOutBack,
              value: 60,
            lengthUnit: GaugeSizeUnit.factor, animationDuration: 1300,
              needleStartWidth: 0, needleEndWidth: isTileView ? 5 : 7, needleLength: 0.8,
              tailStyle: TailStyle(width: isTileView ? 5 : 7, lengthUnit: GaugeSizeUnit.logicalPixel,
                length: 23, ),
              knobStyle: KnobStyle(knobRadius: isTileView ? 0.07 : _radius,
                  sizeUnit: GaugeSizeUnit.factor,),
          ), RangePointer(value: 60, width: 0.15,
              sizeUnit: GaugeSizeUnit.factor,
              color: _pointerColor, animationDuration: 1300,
              animationType: AnimationType.easeOutBack,
              enableAnimation: true)]
      )
    ],
  );
}

Color _pointerColor = const Color(0xFF494CA2);
double _radius = 0.06;

class CustomAxis extends RadialAxis{
  CustomAxis({
    double radiusFactor = 1,
    double centerX = 0.5,
    List<GaugePointer> pointers,
    GaugeTextStyle axisLabelStyle,
    AxisLineStyle axisLineStyle,
    double minimum,
    double maximum,
    bool showTicks,
    double labelOffset,}) :super(
      pointers: pointers ?? <GaugePointer>[],
      minimum: minimum ,
      maximum: maximum ,
      showTicks: showTicks ?? true,
      labelOffset: labelOffset ?? 20,
      axisLabelStyle: axisLabelStyle ?? GaugeTextStyle(color: Colors.black,
          fontSize: 15.0,
          fontFamily: 'Segoe UI',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal),
      axisLineStyle: axisLineStyle ?? AxisLineStyle(
        color: Colors.grey,
        thickness: 10,),
      radiusFactor: radiusFactor,
  );

  @override
  List<CircularAxisLabel> generateVisibleLabels(){
    final List<CircularAxisLabel> _visibleLabels = <CircularAxisLabel>[];
    for (num i = 0; i < 9; i++) {
      double _value = _calculateLabelValue(i);
      final CircularAxisLabel label =
      CircularAxisLabel(axisLabelStyle, _value.toInt().toString(), i, false);
      label.value = _value;
      _visibleLabels.add(label);
    }

    return _visibleLabels;
  }

  @override
  double valueToFactor(double value)
  {
    if(value >= 0 && value <=2){
      return (value * 0.125)/2;
    }else if(value > 2 && value <=5){
      return (((value - 2) * 0.125)/(5 - 2)) + (1 * 0.125);
    }else if(value > 5 && value <=10){
      return (((value - 5) * 0.125)/(10 - 5)) + (2 * 0.125);
    }else if(value > 10 && value <=20){
      return (((value - 10) * 0.125)/(20 - 10)) + (3 * 0.125);
    }else if(value > 20 && value <=30){
      return (((value - 20) * 0.125)/(30 - 20)) + (4 * 0.125);
    }else if(value > 30 && value <=50){
      return (((value - 30) * 0.125)/(50 - 30)) + (5 * 0.125);
    }else if(value > 50 && value <=100){
      return (((value - 50) * 0.125)/(100 - 50)) + (6 * 0.125);
    }else if(value > 100 && value <=150){
      return (((value - 100) * 0.125)/(150 - 100)) + (7 * 0.125);
    }else{
      return 1;
    }
  }


  /// To return the label value based on interval
   double _calculateLabelValue(num value){
    if(value == 0){
      return 0;
    }else if(value == 1){
      return 2;
    }else if(value == 2){
      return 5;
    }else if(value == 3){
      return 10;
    }else if(value == 4){
      return 20;
    }else if(value == 5){
      return 30;
    }else if(value == 6){
      return 50;
    }else if(value == 7){
      return 100;
    }else{
      return 150;
    }
  }

}



