/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/model/sample_view.dart';
import 'package:flutter_examples/widgets/checkbox.dart';
import 'package:flutter_examples/widgets/custom_button.dart';

class FunnelDefault extends SampleView {
  const FunnelDefault(Key key) : super(key: key);

  @override
  _FunnelDefaultState createState() => _FunnelDefaultState();
}

class _FunnelDefaultState extends SampleViewState {
  _FunnelDefaultState();
  double gapRatio = 0;
  int neckWidth = 20;
  int neckHeight = 20;
  bool explode = false;

  Widget buildSettings(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('Gap ratio  ',
                  style: TextStyle(fontSize: 16.0, color: model.textColor)),
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                  child: CustomButton(
                    minValue: 0,
                    maxValue: 0.5,
                    initialValue: gapRatio,
                    onChanged: (dynamic val) => setState(() {
                      gapRatio = val;
                    }),
                    step: 0.1,
                    horizontal: true,
                    loop: false,
                    iconUpRightColor: model.textColor,
                    iconDownLeftColor: model.textColor,
                    style: TextStyle(fontSize: 20.0, color: model.textColor),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('Neck height  ',
                  style: TextStyle(fontSize: 16.0, color: model.textColor)),
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                  child: CustomButton(
                    minValue: 0,
                    maxValue: 50,
                    initialValue: neckHeight.toDouble(),
                    onChanged: (dynamic val) => setState(() {
                      neckHeight = val.toInt();
                    }),
                    step: 10,
                    horizontal: true,
                    loop: false,
                    iconUpRightColor: model.textColor,
                    iconDownLeftColor: model.textColor,
                    style: TextStyle(fontSize: 20.0, color: model.textColor),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('Neck width',
                  style: TextStyle(fontSize: 16.0, color: model.textColor)),
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                  child: CustomButton(
                    minValue: 0,
                    maxValue: 50,
                    initialValue: neckWidth.toDouble(),
                    onChanged: (dynamic val) => setState(() {
                      neckWidth = val.toInt();
                    }),
                    step: 10,
                    horizontal: true,
                    loop: false,
                    iconUpRightColor: model.textColor,
                    iconDownLeftColor: model.textColor,
                    style: TextStyle(fontSize: 20.0, color: model.textColor),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              Text('Explode',
                  style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                      letterSpacing: 0.34,
                      fontWeight: FontWeight.normal)),
              const Padding(padding: EdgeInsets.fromLTRB(30, 0, 0, 0)),
              BottomSheetCheckbox(
                activeColor: model.backgroundColor,
                switchValue: explode,
                valueChanged: (dynamic value) {
                  setState(() {
                    explode = value;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return getDefaultFunnelChart();
  }

SfFunnelChart getDefaultFunnelChart() {
  gapRatio = gapRatio ?? 0;
  neckWidth = neckWidth ?? 20;
  neckHeight = neckHeight ?? 20;
  explode = explode ?? true;
  return SfFunnelChart(
    smartLabelMode: SmartLabelMode.shift,
    title: ChartTitle(text: isCardView ? '' : 'Website conversion rate'),
    tooltipBehavior: TooltipBehavior(enable: true),
    series:
        _getFunnelSeries(isCardView, gapRatio, neckWidth, neckHeight, explode),
  );
}

/// This method returns the funnel series and its correspoding values to chart.
FunnelSeries<ChartSampleData, String> _getFunnelSeries(bool isCardView,
    [double _gapRatio, int _neckWidth, int _neckHeight, bool _explode]) {
  final List<ChartSampleData> pieData = <ChartSampleData>[
    ChartSampleData(x: 'Purchased ', y: 150),
    ChartSampleData(x: 'Requested price list', y: 300),
    ChartSampleData(x: 'Downloaded trail', y: 600),
    ChartSampleData(x: 'Visit download page', y: 1500),
    ChartSampleData(x: 'Watched demo', y: 2600),
    ChartSampleData(x: 'Website visitors', y: 3000)
  ];
  return FunnelSeries<ChartSampleData, String>(
      dataSource: pieData,
      xValueMapper: (ChartSampleData data, _) => data.x,
      yValueMapper: (ChartSampleData data, _) => data.y,
      explode: isCardView ? false : _explode,
      gapRatio: isCardView ? 0 : _gapRatio,
      neckHeight: isCardView ? '20%' : _neckHeight.toString() + '%',
      neckWidth: isCardView ? '20%' : _neckWidth.toString() + '%',
      dataLabelSettings: DataLabelSettings(isVisible: true));
}
}
// //ignore: must_be_immutable
// class DefaultFunnelFrontPanel extends StatefulWidget {
//   //ignore: prefer_const_constructors_in_immutables
//   DefaultFunnelFrontPanel([this.sample]);
//   SubItem sample;

//   @override
//   _DefaultFunnelFrontPanelState createState() =>
//       _DefaultFunnelFrontPanelState(sample);
// }

// class _DefaultFunnelFrontPanelState extends State<DefaultFunnelFrontPanel> {
//   _DefaultFunnelFrontPanelState(this.sample);
//   final SubItem sample;

//   @override
//   void initState() {
//     initProperties();
//     super.initState();
//   }

//   void initProperties([SampleModel sampleModel, bool init]) {
//     gapRatio = 0;
//     neckWidth = 20;
//     neckHeight = 20;
//     explode = false;
//     if (sampleModel != null && init) {
//       sampleModel.properties.addAll(<dynamic, dynamic>{
//         'FunnelGapRatio': gapRatio,
//         'FunnelNeckWidth': neckWidth,
//         'FunnelNeckHeight': neckHeight,
//         'FunnelExplode': explode
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ScopedModelDescendant<SampleModel>(
//         rebuildOnChange: true,
//         builder: (BuildContext context, _, SampleModel model) {
//           return Scaffold(
//               backgroundColor: model.cardThemeColor,
//               body: !model.isWeb
//                   ? Padding(
//                       padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
//                       child: Container(
//                           child: getDefaultFunnelChart(
//                               false, gapRatio, neckWidth, neckHeight, explode)),
//                     )
//                   : Padding(
//                       padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
//                       child: Container(
//                           child: getDefaultFunnelChart(
//                               false, null, null, null, null, model)),
//                     ),
//               floatingActionButton: model.isWeb
//                   ? null
//                   : Stack(children: <Widget>[
//                       Align(
//                         alignment: Alignment.bottomRight,
//                         child: FloatingActionButton(
//                           heroTag: null,
//                           onPressed: () {
//                             _showSettingsPanel(model, false, context);
//                           },
//                           child: Icon(Icons.graphic_eq, color: Colors.white),
//                           backgroundColor: model.backgroundColor,
//                         ),
//                       ),
//                     ]));
//         });
//   }

// }
