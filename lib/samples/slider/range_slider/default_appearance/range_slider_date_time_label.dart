import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/samples/slider/slider_utils.dart';

//ignore: must_be_immutable
class DateRangeSliderPage extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  DateRangeSliderPage([this.sample]);
  SubItem sample;

  @override
  _DateRangeSliderPageState createState() => _DateRangeSliderPageState(sample);
}

class _DateRangeSliderPageState extends State<DateRangeSliderPage> {
  _DateRangeSliderPageState(this.sample);
  final SubItem sample;
  Widget rangeSlider;
  Widget sampleWidget(SampleModel model) => DateRangeSliderPage();

  @override
  void initState() {
    super.initState();
    rangeSlider = DateRangeSlider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.of(context).orientation == Orientation.portrait || kIsWeb
          ? rangeSlider
          : SingleChildScrollView(
              child: Container(height: 300, child: rangeSlider)),
    );
  }
}

// ignore: must_be_immutable
class DateRangeSlider extends StatefulWidget {
  @override
  _DateRangeSliderState createState() => _DateRangeSliderState();
}

class _DateRangeSliderState extends State<DateRangeSlider> {
  SfRangeValues _yearValues =
      SfRangeValues(DateTime(2002, 4, 01), DateTime(2003, 10, 01));
  SfRangeValues _hourValues = SfRangeValues(
      DateTime(2010, 01, 01, 13, 00, 00), DateTime(2010, 01, 01, 17, 00, 00));

  SfRangeSlider _yearRangeSlider() {
    return SfRangeSlider(
      min: DateTime(2001, 01, 01),
      max: DateTime(2005, 01, 01),
      showLabels: true,
      interval: 1,
      dateFormat: DateFormat.y(),
      labelPlacement: LabelPlacement.betweenTicks,
      dateIntervalType: DateIntervalType.years,
      showTicks: true,
      values: _yearValues,
      onChanged: (SfRangeValues values) {
        setState(() {
          _yearValues = values;
        });
      },
      showTooltip: true,
      tooltipTextFormatterCallback:
          (dynamic actualLabel, String formattedText) {
        return DateFormat.yMMM().format(actualLabel);
      },
    );
  }

  SfRangeSlider _hourRangeSlider() {
    return SfRangeSlider(
      min: DateTime(2010, 01, 01, 9, 00, 00),
      max: DateTime(2010, 01, 01, 21, 05, 00),
      showLabels: true,
      interval: 4,
      showTicks: true,
      minorTicksPerInterval: 3,
      dateFormat: DateFormat('h a'),
      labelPlacement: LabelPlacement.onTicks,
      dateIntervalType: DateIntervalType.hours,
      values: _hourValues,
      onChanged: (SfRangeValues values) {
        setState(() {
          _hourValues = values;
        });
      },
      showTooltip: true,
      tooltipTextFormatterCallback:
          (dynamic actualLabel, String formattedText) {
        return DateFormat('h:mm a').format(actualLabel);
      },
    );
  }

  Widget _getWebLayout() {
    return Container(
      alignment: Alignment.center,
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width >= 1000 ? 500 : 400,
        child: _getMobileLayout(),
      ),
    );
  }

  Widget _getMobileLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        title('Interval as year'),
        columnSpacing10,
        _yearRangeSlider(),
        columnSpacing40,
        title('Interval as hour'),
        columnSpacing10,
        _hourRangeSlider(),
        columnSpacing40,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: kIsWeb ? _getWebLayout() : _getMobileLayout());
  }
}
