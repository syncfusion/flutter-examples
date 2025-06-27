///Dart imports
import 'dart:async';

///Package imports
import 'package:flutter/material.dart';

///calendar import
import 'package:syncfusion_flutter_gauges/gauges.dart';

///Local import
import '../../model/sample_view.dart';

/// Widget of the AgendaView Calendar.
class ProgressBarAngles extends SampleView {
  /// Creates AgendaView Calendar sample.
  const ProgressBarAngles(Key key) : super(key: key);

  @override
  _ProgressBarAnglesState createState() => _ProgressBarAnglesState();
}

class _ProgressBarAnglesState extends SampleViewState {
  _ProgressBarAnglesState();

  double _size = 150;
  late Timer _timer;
  double _value = 0;
  ProgressBarColor? _progressBarColor;
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    if (mounted) {
      _timer = Timer.periodic(const Duration(milliseconds: 20), (Timer timer) {
        setState(() {
          if (_value == 100) {
            _value = 0;
          } else {
            _value++;
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _progressBarColor = ProgressBarColor(model);
    if (MediaQuery.of(context).size.height >
        MediaQuery.of(context).size.width) {
      _size = model.isWebFullView
          ? MediaQuery.of(context).size.height / 6
          : MediaQuery.of(context).size.height / 5.5;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _getFirstProgressBar(),
            Align(
              alignment: !model.isWebFullView
                  ? const Alignment(-0.3, 0)
                  : Alignment.center,
              child: _getSecondProgressBar(),
            ),
            Align(
              alignment: !model.isWebFullView
                  ? const Alignment(0.3, 0)
                  : Alignment.center,
              child: _getThirdProgressBar(),
            ),
            _getFourthProgressBar(),
          ],
        ),
      );
    } else {
      _size = MediaQuery.of(context).size.width / 5.5;
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _getFirstProgressBar(),
            _getSecondProgressBar(),
            _getThirdProgressBar(),
            Align(
              alignment: model.isWebFullView
                  ? const Alignment(0, -0.5)
                  : Alignment.center,
              child: _getFourthProgressBar(),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget _getFirstProgressBar() {
    return SizedBox(
      height: _size,
      width: _size,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            showLabels: false,
            showTicks: false,
            radiusFactor: 0.9,
            axisLineStyle: AxisLineStyle(
              thickness: 0.05,
              color: _progressBarColor!.axisLineColor,
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            pointers: <GaugePointer>[
              RangePointer(
                value: _value,
                width: 0.05,
                color: _progressBarColor!.pointerColor,
                sizeUnit: GaugeSizeUnit.factor,
                enableAnimation: true,
                animationDuration: 20,
                animationType: AnimationType.linear,
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(widget: Text(_value.toStringAsFixed(0) + '%')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getSecondProgressBar() {
    return Center(
      child: SizedBox(
        height: _size,
        width: _size,
        child: SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(
              showLabels: false,
              showTicks: false,
              startAngle: 90,
              endAngle: 270,
              radiusFactor: 0.9,
              axisLineStyle: AxisLineStyle(
                thickness: 0.05,
                color: _progressBarColor!.axisLineColor,
                thicknessUnit: GaugeSizeUnit.factor,
              ),
              pointers: <GaugePointer>[
                RangePointer(
                  value: _value,
                  width: 0.05,
                  color: _progressBarColor!.pointerColor,
                  sizeUnit: GaugeSizeUnit.factor,
                  enableAnimation: true,
                  animationDuration: 20,
                  animationType: AnimationType.linear,
                ),
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(widget: Text(_value.toStringAsFixed(0) + '%')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getThirdProgressBar() {
    return Center(
      child: SizedBox(
        height: _size,
        width: _size,
        child: SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(
              showLabels: false,
              showTicks: false,
              startAngle: 270,
              endAngle: 90,
              radiusFactor: 0.9,
              axisLineStyle: AxisLineStyle(
                thickness: 0.05,
                color: _progressBarColor!.axisLineColor,
                thicknessUnit: GaugeSizeUnit.factor,
              ),
              pointers: <GaugePointer>[
                RangePointer(
                  value: _value,
                  width: 0.05,
                  color: _progressBarColor!.pointerColor,
                  sizeUnit: GaugeSizeUnit.factor,
                  enableAnimation: true,
                  animationDuration: 20,
                  animationType: AnimationType.linear,
                ),
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(widget: Text(_value.toStringAsFixed(0) + '%')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getFourthProgressBar() {
    return Center(
      child: SizedBox(
        height: _size,
        width: _size,
        child: SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(
              showLabels: false,
              showTicks: false,
              startAngle: 180,
              endAngle: 0,
              canScaleToFit: true,
              radiusFactor: 0.9,
              axisLineStyle: AxisLineStyle(
                thickness: 0.05,
                color: _progressBarColor!.axisLineColor,
                thicknessUnit: GaugeSizeUnit.factor,
              ),
              pointers: <GaugePointer>[
                RangePointer(
                  value: _value,
                  width: 0.05,
                  color: _progressBarColor!.pointerColor,
                  sizeUnit: GaugeSizeUnit.factor,
                  enableAnimation: true,
                  animationDuration: 20,
                  animationType: AnimationType.linear,
                ),
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(widget: Text(_value.toStringAsFixed(0) + '%')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
