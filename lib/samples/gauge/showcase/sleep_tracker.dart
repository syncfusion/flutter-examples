/// Flutter package imports
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Gauge import.
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local import.
import '../../../model/sample_view.dart';

/// Renders the gauge sleep tracker sample.
class SleepTrackerSample extends SampleView {
  /// Creates the gauge sleep tracker sample.
  const SleepTrackerSample(Key key) : super(key: key);

  @override
  _SleepTrackerSampleState createState() => _SleepTrackerSampleState();
}

class _SleepTrackerSampleState extends SampleViewState {
  _SleepTrackerSampleState();

  @override
  Widget build(BuildContext context) {
    final bool _isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape
            ? true
            : false;
    final bool _isDarkTheme =
        Theme.of(context).brightness == Brightness.dark ? true : false;
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if (!isCardView)
              Container(
                margin: isCardView ? null : const EdgeInsets.only(top: 20),
                width: isCardView ? 110 : 150,
                height: isCardView ? 20 : 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(width: 1, color: Colors.grey),
                    color: Colors.transparent),
                child: Center(
                  child: Text('Mon, 5 Apr',
                      style: TextStyle(fontSize: isCardView ? 12 : 14)),
                ),
              ),
            if (isCardView)
              const SizedBox(height: 10)
            else
              const SizedBox(height: 15),
            Container(
              height: isCardView ? 220 : MediaQuery.of(context).size.height / 2,
              child: SfRadialGauge(axes: <RadialAxis>[
                RadialAxis(
                    showFirstLabel: false,
                    axisLineStyle: AxisLineStyle(
                        thickness: 0.03,
                        thicknessUnit: GaugeSizeUnit.factor,
                        color: Colors.lightBlue[50]),
                    minorTicksPerInterval: 10,
                    majorTickStyle: const MajorTickStyle(length: 10),
                    minimum: 0,
                    maximum: 12,
                    interval: 3,
                    startAngle: 90,
                    endAngle: 90,
                    onLabelCreated: (AxisLabelCreatedArgs args) {
                      if (args.text == '6') {
                        args.text = '12';
                      } else if (args.text == '9') {
                        args.text = '3';
                      } else if (args.text == '12') {
                        args.text = '6';
                      } else if (args.text == '3') {
                        args.text = '9';
                      }
                    },
                    pointers: <GaugePointer>[
                      WidgetPointer(
                          enableDragging: true,
                          value: _wakeupTimeValue,
                          onValueChanged: _handleWakeupTimeValueChanged,
                          onValueChanging: _handleWakeupTimeValueChanging,
                          onValueChangeStart: _handleWakeupTimeValueStart,
                          onValueChangeEnd: _handleWakeupTimeValueEnd,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: model.themeData.brightness ==
                                            Brightness.light
                                        ? Colors.grey
                                        : Colors.white.withOpacity(0.2),
                                    offset: Offset.zero,
                                    blurRadius: 4.0,
                                  ),
                                ],
                                border: Border.all(
                                  color: _isDarkTheme
                                      ? Colors.white.withOpacity(0.1)
                                      : Colors.black.withOpacity(0.1),
                                  style: BorderStyle.solid,
                                  width: 0.0,
                                )),
                            height: _wakeupTimePointerHeight,
                            width: _wakeupTimePointerWidth,
                            child: const Center(
                                child: Icon(
                              Icons.bedtime,
                              size: 15,
                              color: Colors.white,
                            )),
                          )),
                      WidgetPointer(
                        enableDragging: true,
                        value: _bedTimeValue,
                        onValueChanged: _handleBedTimeValueChanged,
                        onValueChanging: _handleBedTimeValueChanging,
                        onValueChangeStart: _handleBedTimeValueStart,
                        onValueChangeEnd: _handleBedTimeValueEnd,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: _isDarkTheme
                                      ? Colors.white.withOpacity(0.2)
                                      : Colors.grey,
                                  offset: Offset.zero,
                                  blurRadius: 4.0,
                                ),
                              ],
                              border: Border.all(
                                color: _isDarkTheme
                                    ? Colors.white.withOpacity(0.1)
                                    : Colors.black.withOpacity(0.1),
                                style: BorderStyle.solid,
                                width: 0.0,
                              )),
                          height: _bedTimePointerHeight,
                          width: _bedTimePointerWidth,
                          child: const Center(
                              child: Icon(
                            Icons.wb_sunny,
                            color: Colors.white,
                            size: 15,
                          )),
                        ),
                      ),
                    ],
                    ranges: <GaugeRange>[
                      GaugeRange(
                          endValue: _bedTimeValue,
                          sizeUnit: GaugeSizeUnit.factor,
                          startValue: _wakeupTimeValue,
                          color: Colors.blue,
                          startWidth: 0.03,
                          endWidth: 0.03)
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                          widget: SizedBox(
                            width: 300,
                            height: 200,
                            child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: <Widget>[
                                AnimatedPositioned(
                                  right: (_isWakeupTime && !_isBedTime)
                                      ? isWebOrDesktop
                                          ? 94
                                          : isCardView
                                              ? 110
                                              : 120
                                      : isWebOrDesktop
                                          ? 155
                                          : (_isLandscape || isCardView)
                                              ? 152
                                              : 180,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.decelerate,
                                  child: AnimatedOpacity(
                                    opacity: _isWakeupTime ? 1.0 : 0.0,
                                    duration: (_isWakeupTime && _isBedTime)
                                        ? const Duration(milliseconds: 800)
                                        : const Duration(milliseconds: 200),
                                    child: CustomAnimatedBuilder(
                                      value: !_isBedTime
                                          ? (_isLandscape || isCardView)
                                              ? 1.1
                                              : 2.0
                                          : (_isLandscape || isCardView)
                                              ? 0.6
                                              : 1.3,
                                      curve: Curves.decelerate,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      builder: (BuildContext context,
                                              Widget? child,
                                              Animation<dynamic> animation) =>
                                          Transform.scale(
                                        scale: animation.value,
                                        child: child,
                                      ),
                                      child: Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(
                                              '4 Apr',
                                              style: TextStyle(
                                                fontSize: isWebOrDesktop
                                                    ? 24
                                                    : isCardView
                                                        ? 14
                                                        : 10,
                                                color: Colors.blue,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              _wakeupTimeAnnotation,
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: isWebOrDesktop
                                                      ? 28
                                                      : isCardView
                                                          ? 20
                                                          : 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                AnimatedOpacity(
                                  opacity:
                                      (_isBedTime && _isWakeupTime) ? 1.0 : 0.0,
                                  duration: (_isWakeupTime && _isBedTime)
                                      ? const Duration(milliseconds: 800)
                                      : const Duration(milliseconds: 200),
                                  child: Container(
                                    margin: (_isLandscape || isCardView)
                                        ? const EdgeInsets.only(top: 8.0)
                                        : const EdgeInsets.only(top: 16.0),
                                    child: const Text(
                                      '-',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                                AnimatedPositioned(
                                  left: (_isBedTime && !_isWakeupTime)
                                      ? isWebOrDesktop
                                          ? 94
                                          : isCardView
                                              ? 110
                                              : 120
                                      : isWebOrDesktop
                                          ? 155
                                          : (_isLandscape || isCardView)
                                              ? 152
                                              : 180,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.decelerate,
                                  child: AnimatedOpacity(
                                    opacity: _isBedTime ? 1.0 : 0.0,
                                    duration: (_isWakeupTime && _isBedTime)
                                        ? const Duration(milliseconds: 800)
                                        : const Duration(milliseconds: 200),
                                    child: CustomAnimatedBuilder(
                                      value: !_isWakeupTime
                                          ? (_isLandscape || isCardView)
                                              ? 1.1
                                              : 2.0
                                          : (_isLandscape || isCardView)
                                              ? 0.6
                                              : 1.3,
                                      curve: Curves.decelerate,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      builder: (BuildContext context,
                                              Widget? child,
                                              Animation<dynamic> animation) =>
                                          Transform.scale(
                                        scale: animation.value,
                                        child: child,
                                      ),
                                      child: Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(
                                              '5 Apr',
                                              style: TextStyle(
                                                fontSize: isWebOrDesktop
                                                    ? 24
                                                    : isCardView
                                                        ? 14
                                                        : 10,
                                                color: Colors.blue,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              _bedTimeAnnotation,
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: isWebOrDesktop
                                                      ? 28
                                                      : isCardView
                                                          ? 20
                                                          : 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          positionFactor: 0.05,
                          angle: 0),
                    ])
              ]),
            ),
            if (!isCardView) const SizedBox(height: 15),
            if (!isCardView)
              Text(
                _sleepMinutes == '00'
                    ? '$_sleepHours hrs'
                    : '$_sleepHours hrs ' '$_sleepMinutes mins',
                style: TextStyle(
                    fontSize: isCardView ? 14 : 20,
                    fontWeight: FontWeight.w500),
              ),
            if (!isCardView) const SizedBox(height: 4),
            if (!isCardView)
              Text(
                'Sleep time',
                style: TextStyle(
                    fontSize: isCardView ? 10 : 15,
                    fontWeight: FontWeight.w400),
              )
          ],
        ),
      ),
    );
  }

  /// Dragged pointer new value is updated to range.
  void _handleWakeupTimeValueChanged(double value) {
    setState(() {
      _wakeupTimeValue = value;
      final int _value = _wakeupTimeValue.abs().toInt();
      final int _hourValue = _value;
      final List<String> _minList =
          _wakeupTimeValue.toStringAsFixed(2).split('.');
      double _currentMinutes = double.parse(_minList[1]);
      _currentMinutes = (_currentMinutes * 60) / 100;
      final String _minutesValue = _currentMinutes.toStringAsFixed(0);

      final double hour = (_hourValue >= 0 && _hourValue <= 6)
          ? (_hourValue + 6)
          : (_hourValue >= 6 && _hourValue <= 12)
              ? _hourValue - 6
              : 0;
      final String hourValue = hour.toString().split('.')[0];

      _wakeupTimeAnnotation = ((hour >= 6 && hour < 10)
              ? '0' + hourValue
              : hourValue) +
          ':' +
          (_minutesValue.length == 1 ? '0' + _minutesValue : _minutesValue) +
          (_hourValue >= 6 ? ' pm' : ' pm');

      _wakeupTime = (_hourValue + 6 < 10
              ? '0' + _hourValue.toString()
              : _hourValue.toString()) +
          ':' +
          (_minutesValue.length == 1 ? '0' + _minutesValue : _minutesValue);

      final DateFormat dateFormat = DateFormat('HH:mm');
      final DateTime _wakeup = dateFormat.parse(_wakeupTime);
      final DateTime _sleep =
          dateFormat.parse(_bedTime == '09:00 pm' ? '12:00' : _bedTime);
      final String _sleepDuration = _sleep.difference(_wakeup).toString();
      _sleepHours = _sleepDuration.toString().split(':')[0];
      _sleepMinutes = _sleepDuration.toString().split(':')[1];
    });
  }

  /// Cancelled the dragging when pointer value reaching the axis end/start value, greater/less than another
  /// pointer value
  void _handleWakeupTimeValueChanging(ValueChangingArgs args) {
    if (args.value >= 6 && args.value < 12) {
      args.cancel = true;
    }

    _wakeupTimePointerWidth = _wakeupTimePointerHeight = 40.0;
  }

  /// Cancelled the dragging when pointer value reaching the axis end/start value, greater/less than another
  /// pointer value
  void _handleBedTimeValueChanging(ValueChangingArgs args) {
    if (args.value >= 0 && args.value < 6) {
      args.cancel = true;
    }

    _bedTimePointerWidth = _bedTimePointerHeight = 40.0;
  }

  /// Dragged pointer new value is updated to range.
  void _handleBedTimeValueChanged(double value) {
    setState(() {
      _bedTimeValue = value;
      final int _value = _bedTimeValue.abs().toInt();
      final int _hourValue = _value;

      final List<String> _minList = _bedTimeValue.toStringAsFixed(2).split('.');
      double _currentMinutes = double.parse(_minList[1]);
      _currentMinutes = (_currentMinutes * 60) / 100;
      final String _minutesValue = _currentMinutes.toStringAsFixed(0);

      _bedTimeAnnotation = ((_hourValue >= 0 && _hourValue <= 6)
              ? (_hourValue + 6).toString()
              : (_hourValue >= 6 && _hourValue <= 12)
                  ? '0' + (_hourValue - 6).toString()
                  : '') +
          ':' +
          (_minutesValue.length == 1 ? '0' + _minutesValue : _minutesValue) +
          (_value >= 6 ? ' am' : ' pm');

      _bedTime = (_hourValue < 10
              ? '0' + _hourValue.toString()
              : _hourValue.toString()) +
          ':' +
          (_minutesValue.length == 1 ? '0' + _minutesValue : _minutesValue);

      final DateFormat dateFormat = DateFormat('HH:mm');
      final DateTime _wakeup =
          dateFormat.parse(_wakeupTime == '06:00 am' ? '03:00' : _wakeupTime);
      final DateTime _sleep = dateFormat.parse(_bedTime);
      final String _sleepDuration = _sleep.difference(_wakeup).toString();
      _sleepHours = _sleepDuration.toString().split(':')[0];
      _sleepMinutes = _sleepDuration.toString().split(':')[1];
    });
  }

  void _handleWakeupTimeValueStart(double value) {
    _isBedTime = false;
  }

  void _handleWakeupTimeValueEnd(double value) {
    setState(() {
      _isBedTime = true;
    });

    _wakeupTimePointerWidth = _wakeupTimePointerHeight = 30.0;
  }

  void _handleBedTimeValueStart(double value) {
    _isWakeupTime = false;
  }

  void _handleBedTimeValueEnd(double value) {
    setState(() {
      _isWakeupTime = true;
    });

    _bedTimePointerWidth = _bedTimePointerHeight = 30.0;
  }

  /// Renders a given fixed size widget
  bool get isWebOrDesktop {
    return defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        kIsWeb;
  }

  double _wakeupTimeValue = 3;
  double _bedTimeValue = 12;
  String _wakeupTimeAnnotation = '09:00 pm';
  String _bedTimeAnnotation = '06:00 am';
  bool _isWakeupTime = true;
  bool _isBedTime = true;
  String _sleepHours = '9';
  String _sleepMinutes = '00';
  String _bedTime = '09:00 pm';
  String _wakeupTime = '06:00 am';
  double _bedTimePointerWidth = 30.0;
  double _bedTimePointerHeight = 30.0;
  double _wakeupTimePointerWidth = 30.0;
  double _wakeupTimePointerHeight = 30.0;
}

/// Widget of custom animated builder.
class CustomAnimatedBuilder extends StatefulWidget {
  /// Creates a instance for [CustomAnimatedBuilder].
  const CustomAnimatedBuilder({
    Key? key,
    required this.value,
    required this.builder,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeInOut,
    this.child,
  }) : super(key: key);

  /// Specifies the animation duration.
  final Duration duration;

  /// Specifies the curve of animation.
  final Curve curve;

  /// Specifies the animation controller value.
  final double value;

  /// Specifies the child widget.
  final Widget? child;

  /// Specifies the builder function.
  final Widget Function(
    BuildContext context,
    Widget? child,
    Animation<dynamic> animation,
  ) builder;

  @override
  _CustomAnimatedBuilderState createState() => _CustomAnimatedBuilderState();
}

class _CustomAnimatedBuilderState extends State<CustomAnimatedBuilder>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      value: widget.value,
      lowerBound: double.negativeInfinity,
      upperBound: double.infinity,
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CustomAnimatedBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      _animationController.animateTo(
        widget.value,
        duration: widget.duration,
        curve: widget.curve,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget? child) => widget.builder(
        context,
        widget.child,
        _animationController,
      ),
    );
  }
}
