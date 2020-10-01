///package import
import 'package:flutter/material.dart';

/// Custom check box extend from [CheckboxListTile]  widget
/// To customize the check box
class CustomCheckBox extends StatefulWidget {
  /// Holds the CheckboxListTile information
  const CustomCheckBox(
      {@required this.switchValue,
      @required this.valueChanged,
      this.activeColor})
      : assert(switchValue != null),
        assert(valueChanged != null);

  /// Whether this checkbox is checked.
  ///
  /// This property must not be null.
  final bool switchValue;

  /// Called when the value of the checkbox should change.
  final ValueChanged<dynamic> valueChanged;

  /// The color to use when this checkbox is checked.
  ///
  /// Defaults to accent color of the current [Theme].
  final Color activeColor;

  @override
  _BottomSheetSwitch createState() => _BottomSheetSwitch();
}

class _BottomSheetSwitch extends State<CustomCheckBox> {
  bool _switchValue;

  @override
  void initState() {
    _switchValue = widget.switchValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      child: Column(
        children: <Widget>[
          CheckboxListTile(
              activeColor: widget.activeColor,
              value: _switchValue,
              onChanged: (bool value) {
                setState(() {
                  _switchValue = value;
                  widget.valueChanged(value);
                });
              })
        ],
      ),
    );
  }
}
