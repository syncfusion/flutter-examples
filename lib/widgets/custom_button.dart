///Package import
import 'package:flutter/material.dart';

/// Collection of left, right or up, down icon buttons with text widget
class CustomDirectionalButtons extends StatefulWidget {
  /// direction arrows surronding in text widget
  const CustomDirectionalButtons({
    double this.minValue = 0,
    required double this.maxValue,
    required double this.initialValue,
    required ValueChanged<double> this.onChanged,
    double this.step = 1,
    bool this.needNull = false,
    bool this.loop = false,
    this.horizontal = true,
    this.style,
    double this.padding = 0.0,
    Color this.iconColor = Colors.black,
  }) : assert(minValue != null),
       assert(maxValue != null),
       assert(initialValue != null),
       assert(onChanged != null),
       assert(step != null),
       assert(loop != null),
       assert(padding != null),
       assert(iconColor != null);
  // assert(initialValue >= minValue && initialValue <= maxValue),
  // assert(minValue < maxValue);

  /// minimal value
  final double? minValue;

  /// max value
  final double? maxValue;

  /// Initially displayed value in the [CustomDirectionalButtons]
  final double? initialValue;

  /// The callback that is called when the button is tapped
  /// or otherwise activated.
  ///
  /// If this is set to null, the button will be disabled.
  final ValueChanged<double>? onChanged;

  /// interval value
  final double? step;

  /// set left,right icons only
  final bool? horizontal;

  /// set after the max value reach, start again from min value
  final bool? loop;

  /// Holds the text widget style
  final TextStyle? style;

  /// The padding around the button's icon.
  /// The entire padded icon will react to input gestures.
  final double? padding;

  /// Color of the icon button
  final Color? iconColor;

  /// Add null instead of 0.
  final bool? needNull;

  @override
  State<StatefulWidget> createState() => _CustomButton();
}

/// Contains the direction (increse/decrease)
enum _CountDirection {
  /// To increase the counter
  Up,

  /// To decrese the counter
  Down,
}

class _CustomButton extends State<CustomDirectionalButtons> {
  late double _counter;

  @override
  void initState() {
    super.initState();
    _counter = widget.initialValue!;
  }

  /// Calculate next value for the CustomDirectionalButtons
  void _count(_CountDirection countDirection) {
    if (countDirection == _CountDirection.Up) {
      // To set the next value after null.
      if (_counter.isNaN) {
        setState(() => _counter = 0 + widget.step!);
      }
      /// Make sure you can't go over `maxValue` unless `loop == true`
      else if (_counter + widget.step! > widget.maxValue!) {
        if (widget.loop!) {
          setState(() {
            /// Calculate the correct value if you go over maxValue in a loop
            final num diff = (_counter + widget.step!) - widget.maxValue!;
            _counter = (diff >= 1
                ? widget.minValue! + diff - 1
                : widget.minValue)!;
          });
        }
      } else {
        if ((widget.initialValue!.isNaN || widget.needNull!) &&
            (_counter + widget.step! == 0)) {
          setState(() => _counter = double.nan);
        } else {
          setState(() {
            _counter = double.parse(
              (_counter + widget.step!).toStringAsFixed(2),
            );
          });
        }
      }
    } else {
      if ((widget.initialValue!.isNaN || widget.needNull!) &&
          _counter - widget.step! == 0) {
        setState(() => _counter = double.nan);
      } else if (_counter.isNaN) {
        setState(() => _counter = 0 - widget.step!);
      } else {
        setState(() {
          _counter = double.parse((_counter - widget.step!).toStringAsFixed(2));
        });
      }
    }

    widget.onChanged!(_counter);
  }

  Widget _getCount() {
    return SizedBox(
      width: 35,
      child: Text(
        widget.initialValue! % 1 == 0 && widget.step! % 1 == 0
            ? ((_counter.isNaN)
                  ? 'null'
                  : ((widget.needNull!)
                        ? _counter.toInt().toString()
                        : _counter.toString().split('.').last.length <= 1 ||
                              int.parse(_counter.toString().split('.').last) < 0
                        ? _counter.toStringAsFixed(0)
                        : _counter.toStringAsFixed(2)))
            : (_counter.isNaN)
            ? 'null'
            : (widget.needNull!)
            ? _counter.toInt().toString()
            : _counter.toString().split('.').last.length <= 1 ||
                  int.parse(_counter.toString().split('.').last) < 0
            ? _counter.toStringAsFixed(1)
            : _counter.toStringAsFixed(2),
        style: widget.style ?? Theme.of(context).textTheme.headlineSmall,
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Return different widgets for a horizontal and vertical BuildPicker
  Widget _buildCustomButton() {
    return (!widget.horizontal!)
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.arrow_drop_up),
                padding: EdgeInsets.only(bottom: widget.padding!),
                alignment: Alignment.bottomCenter,
                color: widget.iconColor,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _counter >= widget.maxValue!
                    ? null
                    : () {
                        _count(_CountDirection.Up);
                      },
              ),
              _getCount(),
              IconButton(
                icon: const Icon(Icons.arrow_drop_down),
                padding: EdgeInsets.only(top: widget.padding!),
                alignment: Alignment.topCenter,
                color: widget.iconColor,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _counter <= widget.minValue!
                    ? null
                    : () {
                        _count(_CountDirection.Down);
                      },
              ),
            ],
          )
        : Row(
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.arrow_left),
                padding: EdgeInsets.only(right: widget.padding!),
                color: widget.iconColor,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _counter <= widget.minValue!
                    ? null
                    : () {
                        _count(_CountDirection.Down);
                      },
              ),
              _getCount(),
              IconButton(
                icon: const Icon(Icons.arrow_right),
                padding: EdgeInsets.only(left: widget.padding!),
                color: widget.iconColor,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _counter >= widget.maxValue!
                    ? null
                    : () {
                        _count(_CountDirection.Up);
                      },
              ),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    return _buildCustomButton();
  }
}
