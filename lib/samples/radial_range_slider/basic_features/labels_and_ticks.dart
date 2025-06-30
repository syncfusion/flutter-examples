/// Flutter package imports
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Gauge import
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local import
import '../../../model/sample_view.dart';

/// Widget of the RadialSlider ticks and labels.
class RadialRangeSliderLabelsTicks extends SampleView {
  /// Creates the RadialSlider ticks and labels sample.
  const RadialRangeSliderLabelsTicks(Key key) : super(key: key);

  @override
  _RadialRangeSliderLabelsTicksState createState() =>
      _RadialRangeSliderLabelsTicksState();
}

class _RadialRangeSliderLabelsTicksState extends SampleViewState {
  _RadialRangeSliderLabelsTicksState();

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      _firstMarkerSize = 35;
      _annotationFontSize = 15;
    } else {
      _firstMarkerSize = model.isWebFullView ? 35 : 15;
      _annotationFontSize = model.isWebFullView ? 25 : 15;
    }

    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape
        ? true
        : false;

    return Center(
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            showFirstLabel: false,
            startAngle: 270,
            endAngle: 270,
            radiusFactor: 0.85,
            maximum: 12,
            interval: 3,
            axisLineStyle: const AxisLineStyle(
              color: Color.fromRGBO(128, 94, 246, 0.3),
              thickness: 0.075,
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            tickOffset: 0.15,
            labelOffset: 0.1,
            offsetUnit: GaugeSizeUnit.factor,
            minorTicksPerInterval: 30,
            minorTickStyle: const MinorTickStyle(
              length: 0.05,
              lengthUnit: GaugeSizeUnit.factor,
            ),
            majorTickStyle: const MajorTickStyle(
              length: 0.1,
              lengthUnit: GaugeSizeUnit.factor,
            ),
            ranges: <GaugeRange>[
              GaugeRange(
                endValue: _secondMarkerValue,
                startValue: _firstMarkerValue,
                sizeUnit: GaugeSizeUnit.factor,
                color: const Color.fromRGBO(128, 94, 246, 1),
                endWidth: 0.075,
                startWidth: 0.075,
              ),
            ],
            pointers: <GaugePointer>[
              MarkerPointer(
                value: _firstMarkerValue,
                elevation: 5,
                enableDragging: true,
                color: const Color.fromRGBO(128, 94, 246, 1),
                markerHeight: _firstMarkerSize,
                markerWidth: _firstMarkerSize,
                markerType: MarkerType.circle,
                onValueChanged: _handleFirstPointerValueChanged,
                onValueChanging: _handleFirstPointerValueChanging,
                onValueChangeStart: _handleFirstPointerValueStart,
                onValueChangeEnd: _handleFirstPointerValueEnd,
              ),
              MarkerPointer(
                value: _secondMarkerValue,
                elevation: 5,
                markerOffset: 0.1,
                color: const Color.fromRGBO(128, 94, 246, 1),
                enableDragging: true,
                markerHeight: _firstMarkerSize,
                markerWidth: _firstMarkerSize,
                markerType: MarkerType.circle,
                onValueChanged: _handleSecondPointerValueChanged,
                onValueChanging: _handleSecondPointerValueChanging,
                onValueChangeStart: _handleSecondPointerValueStart,
                onValueChangeEnd: _handleSecondPointerValueEnd,
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: SizedBox(
                  width: 300,
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: <Widget>[
                      AnimatedPositioned(
                        right: (_isFirstPointer && !_isSecondPointer)
                            ? isWebOrDesktop
                                  ? 120
                                  : 130
                            : isWebOrDesktop
                            ? 165
                            : isLandscape
                            ? 158
                            : 165,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.decelerate,
                        child: AnimatedOpacity(
                          opacity: _isFirstPointer ? 1.0 : 0.0,
                          duration: (_isFirstPointer && _isSecondPointer)
                              ? const Duration(milliseconds: 800)
                              : const Duration(milliseconds: 200),
                          child: CustomAnimatedBuilder(
                            value: !_isSecondPointer
                                ? isLandscape
                                      ? 1.5
                                      : 2.0
                                : 1.0,
                            curve: Curves.decelerate,
                            duration: const Duration(milliseconds: 300),
                            builder:
                                (
                                  BuildContext context,
                                  Widget? child,
                                  Animation<dynamic> animation,
                                ) => Transform.scale(
                                  scale: animation.value,
                                  child: child,
                                ),
                            child: Text(
                              _annotationValue1,
                              style: TextStyle(
                                fontSize: _annotationFontSize,
                                fontFamily: 'Times',
                              ),
                            ),
                          ),
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: (_isSecondPointer && _isFirstPointer)
                            ? 1.0
                            : 0.0,
                        duration: (_isFirstPointer && _isSecondPointer)
                            ? const Duration(milliseconds: 800)
                            : const Duration(milliseconds: 200),
                        child: Text(
                          '-',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: _annotationFontSize,
                            fontFamily: 'Times',
                          ),
                        ),
                      ),
                      AnimatedPositioned(
                        left: (_isSecondPointer && !_isFirstPointer)
                            ? isWebOrDesktop
                                  ? 120
                                  : 135
                            : isWebOrDesktop
                            ? 165
                            : isLandscape
                            ? 158
                            : 165,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.decelerate,
                        child: AnimatedOpacity(
                          opacity: _isSecondPointer ? 1.0 : 0.0,
                          duration: (_isFirstPointer && _isSecondPointer)
                              ? const Duration(milliseconds: 800)
                              : const Duration(milliseconds: 200),
                          child: CustomAnimatedBuilder(
                            value: !_isFirstPointer
                                ? isLandscape
                                      ? 1.5
                                      : 2.0
                                : 1.0,
                            curve: Curves.decelerate,
                            duration: const Duration(milliseconds: 300),
                            builder:
                                (
                                  BuildContext context,
                                  Widget? child,
                                  Animation<dynamic> animation,
                                ) => Transform.scale(
                                  scale: animation.value,
                                  child: child,
                                ),
                            child: Text(
                              _annotationValue2,
                              style: TextStyle(
                                fontSize: _annotationFontSize,
                                fontFamily: 'Times',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                angle: 90,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Dragged pointer new value is updated to pointer and
  /// annotation current value.
  void _handleSecondPointerValueChanged(double markerValue) {
    setState(() {
      _secondMarkerValue = markerValue;
      final int value = _secondMarkerValue.round();
      _annotationValue2 = value == 12
          ? '$value PM'
          : value == 0
          ? ' 12 AM'
          : '$value AM';
    });
  }

  /// Pointer dragging is canceled when dragging pointer value is less than 6.
  void _handleSecondPointerValueChanging(ValueChangingArgs args) {
    if (args.value <= _firstMarkerValue ||
        (args.value - _secondMarkerValue).abs() > 1) {
      args.cancel = true;
    }
  }

  /// Value changed call back for first pointer
  void _handleFirstPointerValueChanged(double markerValue) {
    setState(() {
      _firstMarkerValue = markerValue;
      final int value = _firstMarkerValue.round();
      _annotationValue1 = value == 12
          ? '$value PM'
          : value == 0
          ? ' 12 AM'
          : '$value AM';
    });
  }

  /// Value changeing call back for first pointer
  void _handleFirstPointerValueChanging(ValueChangingArgs args) {
    if (args.value >= _secondMarkerValue ||
        (args.value - _firstMarkerValue).abs() > 1) {
      args.cancel = true;
    }
  }

  void _handleFirstPointerValueStart(double value) {
    _isSecondPointer = false;
  }

  void _handleFirstPointerValueEnd(double value) {
    setState(() {
      _isSecondPointer = true;
    });
  }

  void _handleSecondPointerValueStart(double value) {
    _isFirstPointer = false;
  }

  void _handleSecondPointerValueEnd(double value) {
    setState(() {
      _isFirstPointer = true;
    });
  }

  /// Renders a given fixed size widget
  bool get isWebOrDesktop {
    return defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        kIsWeb;
  }

  double _secondMarkerValue = 9;
  double _firstMarkerValue = 0;
  double _firstMarkerSize = 35;
  bool _isFirstPointer = true;
  bool _isSecondPointer = true;
  double _annotationFontSize = 25;
  String _annotationValue1 = '12 AM';
  String _annotationValue2 = '9 AM';
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
  )
  builder;

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
      builder: (BuildContext context, Widget? child) =>
          widget.builder(context, widget.child, _animationController),
    );
  }
}
