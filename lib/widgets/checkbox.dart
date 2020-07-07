import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BottomSheetCheckbox extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  BottomSheetCheckbox(
      {@required this.switchValue,
      @required this.valueChanged,
      this.activeColor});

  final bool switchValue;
  final ValueChanged<dynamic> valueChanged;
  final Color activeColor;

  @override
  _BottomSheetSwitch createState() => _BottomSheetSwitch();
}

class _BottomSheetSwitch extends State<BottomSheetCheckbox> {
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
