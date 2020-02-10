import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BottomSheetSwitch extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  BottomSheetSwitch(
      {@required this.switchValue,
      @required this.valueChanged,
      this.activeColor});

  final bool switchValue;
  final ValueChanged<dynamic> valueChanged;
  final Color activeColor;

  @override
  _BottomSheetSwitch createState() => _BottomSheetSwitch();
}

class _BottomSheetSwitch extends State<BottomSheetSwitch> {
  bool _switchValue;

  @override
  void initState() {
    _switchValue = widget.switchValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
