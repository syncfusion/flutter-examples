///Dart imports
import 'dart:async';

///Package imports
import 'package:flutter/material.dart';

///calendar import
import 'package:syncfusion_flutter_gauges/gauges.dart';

///Local import
import '../../model/sample_view.dart';

/// Widget of the AgendaView Calendar.
class ProgressBarCustomLabels extends SampleView {
  /// Creates progress bar with custom labels.
  const ProgressBarCustomLabels(Key key) : super(key: key);

  @override
  _ProgressBarCustomLabelsState createState() =>
      _ProgressBarCustomLabelsState();
}

class _ProgressBarCustomLabelsState extends SampleViewState {
  _ProgressBarCustomLabelsState();

  double _size = 150;
  late Timer _timer;
  double _value = 0;
  late Widget _pauseImage;
  late Widget _downloadImage;

  @override
  void initState() {
    super.initState();
    _pauseImage = Container(
      height: 40,
      width: 40,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: ExactAssetImage('images/pause.png'),
          fit: BoxFit.fill,
        ),
      ),
    );
    _downloadImage = Container(
      height: 40,
      width: 40,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: ExactAssetImage('images/download.png'),
          fit: BoxFit.fill,
        ),
      ),
    );
    _startTimer();
  }

  void _startTimer() {
    if (mounted) {
      _timer = Timer.periodic(const Duration(milliseconds: 20), (Timer timer) {
        _incrementPointerValue();
      });
    }
  }

  void _incrementPointerValue() {
    setState(() {
      if (_value == 100) {
        _timer.cancel();
        _pauseImage = Container(
          height: 40,
          width: 40,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage('images/play.png'),
              fit: BoxFit.fill,
            ),
          ),
        );
        _downloadImage = Container(
          height: 40,
          width: 40,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage('images/Check.png'),
              fit: BoxFit.fill,
            ),
          ),
        );
        Future<dynamic>.delayed(const Duration(milliseconds: 500));
        _startTimer();
      } else {
        _value++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.height >
        MediaQuery.of(context).size.width) {
      _size = model.isWebFullView
          ? MediaQuery.of(context).size.height / 6.5
          : MediaQuery.of(context).size.height / 5.5;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _getFirstProgressBar(),
            _getSecondProgressBar(),
            _getThirdProgressBar(),
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
            _getFourthProgressBar(),
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
            radiusFactor: 0.8,
            axisLineStyle: const AxisLineStyle(
              thickness: 0.2,
              cornerStyle: CornerStyle.bothCurve,
              color: Color.fromARGB(30, 0, 169, 181),
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            pointers: <GaugePointer>[
              RangePointer(
                value: _value,
                cornerStyle: CornerStyle.bothCurve,
                width: 0.2,
                color: const Color.fromRGBO(3, 218, 198, 1),
                sizeUnit: GaugeSizeUnit.factor,
                enableAnimation: true,
                animationDuration: 20,
                animationType: AnimationType.linear,
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                angle: 90,
                widget: Text(
                  _value.toStringAsFixed(0) + ' / 100',
                  style: const TextStyle(fontSize: 11),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getSecondProgressBar() {
    return SizedBox(
      height: _size,
      width: _size,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            showLabels: false,
            showTicks: false,
            startAngle: 270,
            endAngle: 270,
            radiusFactor: 0.8,
            axisLineStyle: const AxisLineStyle(
              thickness: 0.05,
              color: Color.fromARGB(30, 0, 169, 181),
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            pointers: <GaugePointer>[
              RangePointer(
                value: _value,
                width: 0.05,
                color: const Color.fromRGBO(3, 218, 198, 1),
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

  Widget _getThirdProgressBar() {
    return SizedBox(
      height: _size,
      width: _size,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            showLabels: false,
            showTicks: false,
            startAngle: 270,
            endAngle: 270,
            radiusFactor: 0.8,
            axisLineStyle: const AxisLineStyle(
              thickness: 0.05,
              color: Color.fromARGB(30, 0, 169, 181),
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            pointers: <GaugePointer>[
              RangePointer(
                value: _value,
                width: 0.05,
                color: const Color.fromRGBO(3, 218, 198, 1),
                sizeUnit: GaugeSizeUnit.factor,
                enableAnimation: true,
                animationDuration: 20,
                animationType: AnimationType.linear,
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(widget: _pauseImage),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getFourthProgressBar() {
    return SizedBox(
      height: _size,
      width: _size,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            showLabels: false,
            showTicks: false,
            startAngle: 270,
            endAngle: 270,
            radiusFactor: 0.8,
            axisLineStyle: const AxisLineStyle(
              thickness: 0.05,
              color: Color.fromARGB(30, 0, 169, 181),
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            pointers: <GaugePointer>[
              RangePointer(
                value: _value,
                width: 0.05,
                color: const Color.fromRGBO(3, 218, 198, 1),
                sizeUnit: GaugeSizeUnit.factor,
                enableAnimation: true,
                animationDuration: 20,
                animationType: AnimationType.linear,
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(widget: _downloadImage),
            ],
          ),
        ],
      ),
    );
  }
}
