import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DropDown extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  DropDown({@required this.value, @required this.valueChanged, this.item});

  final String value;
  final List<DropdownMenuItem<dynamic>> item;
  final ValueChanged<dynamic> valueChanged;

  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  String _value;

  @override
  void initState() {
    _value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropdownButton<String>(
        isExpanded: false,
        value: _value,
        items: widget.item,
        onChanged: (String value) {
          setState(() {
            _value = value;
            widget.valueChanged(value);
          });
        },
      ),
    );
  }
}
