import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class RadialTextPointer extends StatefulWidget {
  final SubItemList sample;
  const RadialTextPointer(this.sample, {Key key}) : super(key: key);

  @override
  _RadialTextPointerState createState() => _RadialTextPointerState(sample);
}

class _RadialTextPointerState extends State<RadialTextPointer> {
  final SubItemList sample;
  _RadialTextPointerState(this.sample);
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
  void didUpdateWidget(RadialTextPointer oldWidget) {
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
                          'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/gauge/pointers/text_pointer.dart');
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
                child: Container(child: getRadialTextPointer(false)),
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

SfRadialGauge getRadialTextPointer(bool isTileView) {
  return SfRadialGauge(
    axes:<RadialAxis>[
      RadialAxis(showAxisLine:false,showLabels:false,showTicks:false,
          startAngle:180,endAngle:360,minimum:0,maximum:120,
          centerY:0.65, radiusFactor: 0.79,
          pointers: <GaugePointer>[NeedlePointer(needleStartWidth:1,
              lengthUnit: GaugeSizeUnit.factor,
              needleEndWidth:5,needleLength:0.7, value: 82,
              knobStyle:KnobStyle(knobRadius:0)),],

          ranges:<GaugeRange>[
            GaugeRange(startValue:0,endValue:20,startWidth:0.45,endWidth:0.45,
                sizeUnit: GaugeSizeUnit.factor,
                color:Color(0xFFDD3800)),
            GaugeRange(startValue:20.5,endValue:40,startWidth:0.45,
                sizeUnit: GaugeSizeUnit.factor,
                endWidth:0.45,color:Color(0xFFFF4100)),
            GaugeRange(startValue:40.5,endValue:60,startWidth:0.45,
                sizeUnit: GaugeSizeUnit.factor,
                endWidth:0.45,color:Color(0xFFFFBA00)),
            GaugeRange(startValue:60.5,endValue:80,startWidth:0.45,
                sizeUnit: GaugeSizeUnit.factor,
                endWidth:0.45,color:Color(0xFFFFDF10)),
            GaugeRange(startValue:80.5,endValue:100,  sizeUnit: GaugeSizeUnit.factor,
                startWidth:0.45,endWidth:0.45,color:Color(0xFF8BE724)),
            GaugeRange(startValue:100.5,endValue:120,startWidth:0.45,endWidth:0.45,
                sizeUnit: GaugeSizeUnit.factor,
                color:Color(0xFF64BE00)),


          ]
      ),
      RadialAxis(showAxisLine:false,showLabels:false,showTicks:false,
        startAngle:180,endAngle:360,minimum:0,maximum:120, radiusFactor: 0.85, centerY:0.65,
        pointers:<GaugePointer>[
          MarkerPointer(markerType: MarkerType.text, text: 'Poor', value: 20.5,
              textStyle: GaugeTextStyle(fontWeight:
          FontWeight.bold, fontSize: isTileView ? 14 : 18,
                  fontFamily: 'Times'),
              offsetUnit: GaugeSizeUnit.factor,
              markerOffset: -0.12),
          MarkerPointer(markerType: MarkerType.text, text: 'Average', value: 60.5,
              textStyle: GaugeTextStyle(fontWeight:
          FontWeight.bold, fontSize: isTileView ? 14 : 18,
                  fontFamily: 'Times'),
              offsetUnit: GaugeSizeUnit.factor,
              markerOffset: -0.12),
          MarkerPointer(markerType: MarkerType.text, text: 'Good', value: 100.5,
              textStyle: GaugeTextStyle(fontWeight:
          FontWeight.bold, fontSize: isTileView ? 14 : 18,
              fontFamily: 'Times'),
              offsetUnit: GaugeSizeUnit.factor,
              markerOffset: -0.12)
        ],

      ),

    ],
  );
}





