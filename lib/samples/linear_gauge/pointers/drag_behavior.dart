/// Flutter package imports
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local imports
import '../../../model/sample_view.dart';
import '../utils.dart';

/// Shows the linear gauge multiple pointer drag behavior.
class DragBehavior extends SampleView {
  /// Creates linear gauge with different pointer drag behavior.
  const DragBehavior(Key key) : super(key: key);

  @override
  _DragBehaviorState createState() => _DragBehaviorState();
}

/// State class of linear gauge widget pointer.
class _DragBehaviorState extends SampleViewState {
  _DragBehaviorState();
  double _firstLoosePointerValue = 40;
  double _middleLoosePointerValue = 60;
  double _firstLockPointerValue = 40;
  double _middleLockPointerValue = 60;
  final bool _isHorizontalOrientation = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: getScreenWidth(context, _isHorizontalOrientation),
                    child: _buildWidgetPointer(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Returns the linear gauge widget pointer.
  Widget _buildWidgetPointer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildHorizontalGauges(
            'Free',
            _buildIconWidgetPointer(context, LinearMarkerDragBehavior.free),
          ),
          _buildHorizontalGauges(
            'Constrained',
            _buildIconWidgetPointer(
              context,
              LinearMarkerDragBehavior.constrained,
            ),
          ),
        ],
      ),
    );
  }

  /// Returns the horizontal axis track.
  Widget _buildHorizontalGauges(String axisTrackName, Widget linearGauge) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(axisTrackName),
        linearGauge,
        const SizedBox(height: 10),
      ],
    );
  }

  /// Returns the icon widget pointer sample.
  Widget _buildIconWidgetPointer(
    BuildContext context,
    LinearMarkerDragBehavior dragMode,
  ) {
    return SizedBox(
      height: 100,
      child: SfLinearGauge(
        animateAxis: true,
        interval: 10,
        axisTrackStyle: const LinearAxisTrackStyle(thickness: 3),
        markerPointers: <LinearMarkerPointer>[
          LinearWidgetPointer(
            value: dragMode == LinearMarkerDragBehavior.free
                ? _firstLoosePointerValue
                : _firstLockPointerValue,
            onChanged: (dynamic value) {
              setState(() {
                if (dragMode == LinearMarkerDragBehavior.free) {
                  _firstLoosePointerValue = value as double;
                } else {
                  _firstLockPointerValue = value as double;
                }
              });
            },
            dragBehavior: dragMode == LinearMarkerDragBehavior.free
                ? LinearMarkerDragBehavior.free
                : LinearMarkerDragBehavior.constrained,
            position: LinearElementPosition.outside,
            child: RotatedBox(
              quarterTurns: 3,
              child: SizedBox(
                width: 20,
                height: 16,
                child: Image.asset('images/rectangle_pointer.png'),
              ),
            ),
          ),
          LinearWidgetPointer(
            value: dragMode == LinearMarkerDragBehavior.free
                ? _middleLoosePointerValue
                : _middleLockPointerValue,
            onChanged: (dynamic value) {
              setState(() {
                if (dragMode == LinearMarkerDragBehavior.free) {
                  _middleLoosePointerValue = value as double;
                } else {
                  _middleLockPointerValue = value as double;
                }
              });
            },
            dragBehavior: dragMode == LinearMarkerDragBehavior.free
                ? LinearMarkerDragBehavior.free
                : LinearMarkerDragBehavior.constrained,
            position: LinearElementPosition.outside,
            child: RotatedBox(
              quarterTurns: 3,
              child: SizedBox(
                width: 20,
                height: 16,
                child: Image.asset(
                  'images/rectangle_pointer.png',
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
