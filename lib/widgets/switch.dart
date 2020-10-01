///Package imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Custom switch extends from the [CupertinoSwitch] widget
class CustomSwitch extends StatefulWidget {
  /// Holds the switch informations
  const CustomSwitch(
      {@required this.switchValue,
      @required this.valueChanged,
      this.activeColor})
      : assert(switchValue != null),
        assert(valueChanged != null);

  /// Contains the information of switch state (on/off)
  final bool switchValue;

  /// Holds the action of on/off change
  final ValueChanged<dynamic> valueChanged;

  /// Holds the color of the switch
  final Color activeColor;

  @override
  _BottomSheetSwitch createState() => _BottomSheetSwitch();
}

class _BottomSheetSwitch extends State<CustomSwitch> {
  bool _switchValue;

  @override
  void initState() {
    _switchValue = widget.switchValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.8,
      child: CupertinoSwitch(
          activeColor: widget.activeColor,
          value: _switchValue,
          onChanged: (bool value) {
            setState(() {
              _switchValue = value;
              widget.valueChanged(value);
            });
          }),
    );
  }
}
