///Package import
import 'package:flutter/material.dart';

/// Custom dropdown acts like [DropdownButton]
class DropDown extends StatefulWidget {
  /// Holds the DropdownButton details
  const DropDown(
      {@required this.value,
      @required this.valueChanged,
      this.item,
      this.isExpanded = false})
      : assert(value != null),
        assert(valueChanged != null);

  /// The value of the currently selected [DropdownMenuItem].
  final String value;

  /// The list of items the user can select.
  final List<DropdownMenuItem<String>> item;

  /// Called when the user selects an item.
  final ValueChanged<dynamic> valueChanged;

  /// Set the dropdown's inner contents to horizontally fill its parent.
  final bool isExpanded;

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
        isExpanded: widget.isExpanded,
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
