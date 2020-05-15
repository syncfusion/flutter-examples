import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart' show NumberFormat;

import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class DivisorCustomizedRangeSlider extends StatefulWidget {
  @override
  _DivisorCustomizedRangeSliderState createState() =>
      _DivisorCustomizedRangeSliderState();
}

class _DivisorCustomizedRangeSliderState
    extends State<DivisorCustomizedRangeSlider> {
  final Color _inactiveColor = const Color.fromARGB(255, 194, 194, 194);
  final Color _activeColor = const Color.fromARGB(255, 255, 0, 58);
  SfRangeValues _values = const SfRangeValues(30.0, 70.0);

  @override
  Widget build(BuildContext context) {
    return SfRangeSliderTheme(
      data: SfRangeSliderThemeData(
          inactiveTrackColor: _inactiveColor.withOpacity(0.5),
          activeTrackColor: _activeColor,
          thumbColor: _activeColor,
          inactiveDivisorColor:
              const Color.fromARGB(255, 214, 214, 214).withOpacity(1),
          activeDivisorColor: const Color.fromARGB(255, 255, 0, 58),
          overlayColor: _activeColor.withOpacity(0.12),
          tooltipBackgroundColor: _activeColor),
      child: SfRangeSlider(
        min: 0.0,
        max: 100.0,
        values: _values,
        onChanged: (SfRangeValues values) {
          setState(() {
            _values = values;
          });
        },
        interval: 10,
        showDivisors: true,
        showTooltip: true,
        numberFormat: NumberFormat('#'),
        divisorShape: _DivisorShape(),
      ),
    );
  }
}

class _DivisorShape extends SfDivisorShape {
  Size getPreferredSize(SfRangeSliderThemeData themeData, bool isEnabled) {
    return const Size.fromRadius(4);
  }
}
