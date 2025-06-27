///Package imports
import 'package:flutter/material.dart';

///Chart import
import 'package:syncfusion_flutter_charts/charts.dart' hide LabelPlacement;

///Core import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/core.dart';

///Core theme import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

///Slider import
import 'package:syncfusion_flutter_sliders/sliders.dart';

///Local import
import '../../../model/sample_view.dart';

/// Renders the range selector with histogram chart selection option
class RangeSelectorHistogramChartPage extends SampleView {
  /// Creates the range selector with histogram chart selection option
  const RangeSelectorHistogramChartPage(Key key) : super(key: key);

  @override
  _RangeSelectorHistogramChartPageState createState() =>
      _RangeSelectorHistogramChartPageState();
}

class _RangeSelectorHistogramChartPageState extends SampleViewState
    with SingleTickerProviderStateMixin {
  _RangeSelectorHistogramChartPageState();

  final double _min = 100.0;
  final double _max = 1000.0;
  SfRangeValues _values = const SfRangeValues(400.0, 700.0);

  late RangeController _rangeController;
  final TextEditingController _textController = TextEditingController();

  late List<_RoomData> _chartData;
  final List<_RoomData> _updatedChartData = <_RoomData>[];

  bool _needBanquetHall = false;
  bool _needHealthSpa = false;
  bool _needPets = false;
  bool _needIndoorEntertainment = false;

  @override
  void initState() {
    _rangeController = RangeController(start: _values.start, end: _values.end);
    _chartData = <_RoomData>[
      _RoomData(rate: 300, hasBanquetHall: true),
      _RoomData(
        rate: 762,
        hasBanquetHall: true,
        hasHealthSpa: true,
        petsAllowed: true,
      ),
      _RoomData(rate: 550, hasBanquetHall: true, petsAllowed: true),
      _RoomData(rate: 336, hasHealthSpa: true),
      _RoomData(rate: 150),
      _RoomData(rate: 440, hasBanquetHall: true, hasHealthSpa: true),
      _RoomData(rate: 350, hasIndoorEntertainment: true),
      _RoomData(rate: 300, petsAllowed: true),
      _RoomData(rate: 550, hasHealthSpa: true, petsAllowed: true),
      _RoomData(rate: 199, hasHealthSpa: true),
      _RoomData(rate: 729, hasIndoorEntertainment: true, hasBanquetHall: true),
      _RoomData(rate: 179, petsAllowed: true),
      _RoomData(
        rate: 969,
        hasBanquetHall: true,
        hasHealthSpa: true,
        petsAllowed: true,
        hasIndoorEntertainment: true,
      ),
      _RoomData(rate: 699, hasBanquetHall: true, petsAllowed: true),
      _RoomData(rate: 288, petsAllowed: true),
      _RoomData(rate: 399, petsAllowed: true),
      _RoomData(rate: 429, petsAllowed: true, hasHealthSpa: true),
      _RoomData(rate: 316, hasBanquetHall: true),
      _RoomData(rate: 778, hasHealthSpa: true, hasIndoorEntertainment: true),
      _RoomData(
        rate: 899,
        hasBanquetHall: true,
        hasHealthSpa: true,
        petsAllowed: true,
        hasIndoorEntertainment: true,
      ),
      _RoomData(rate: 199, hasBanquetHall: true),
      _RoomData(rate: 299, hasHealthSpa: true),
      _RoomData(
        rate: 947,
        hasBanquetHall: true,
        hasHealthSpa: true,
        petsAllowed: true,
        hasIndoorEntertainment: true,
      ),
      _RoomData(
        rate: 899,
        hasBanquetHall: true,
        hasIndoorEntertainment: true,
        petsAllowed: true,
      ),
      _RoomData(
        rate: 794,
        hasBanquetHall: true,
        petsAllowed: true,
        hasHealthSpa: true,
      ),
      _RoomData(
        rate: 969,
        hasBanquetHall: true,
        hasHealthSpa: true,
        petsAllowed: true,
        hasIndoorEntertainment: true,
      ),
      _RoomData(
        rate: 849,
        hasHealthSpa: true,
        petsAllowed: true,
        hasIndoorEntertainment: true,
      ),
      _RoomData(rate: 724, hasBanquetHall: true, hasIndoorEntertainment: true),
      _RoomData(rate: 449, hasBanquetHall: true, hasHealthSpa: true),
      _RoomData(rate: 409, petsAllowed: true),
      _RoomData(rate: 699, hasBanquetHall: true, petsAllowed: true),
      _RoomData(rate: 474, hasHealthSpa: true),
      _RoomData(rate: 599, hasIndoorEntertainment: true, petsAllowed: true),
      _RoomData(rate: 639, hasHealthSpa: true, petsAllowed: true),
      _RoomData(rate: 618, hasHealthSpa: true, petsAllowed: true),
      _RoomData(rate: 549, petsAllowed: true),
      _RoomData(rate: 399, hasHealthSpa: true),
      _RoomData(rate: 215),
      _RoomData(rate: 287, hasIndoorEntertainment: true),
      _RoomData(rate: 100),
      _RoomData(
        rate: 999,
        hasBanquetHall: true,
        hasHealthSpa: true,
        petsAllowed: true,
        hasIndoorEntertainment: true,
      ),
    ];

    _updateChartData(_values);

    super.initState();
  }

  @override
  void dispose() {
    _rangeController.dispose();
    _textController.dispose();
    _chartData.clear();
    _updatedChartData.clear();
    super.dispose();
  }

  void _updateChartData(
    SfRangeValues values, {
    bool hasBanquetHall = false,
    bool hasHealthSpa = false,
    bool arePetsAllowed = false,
    bool hasIndoorEntertainment = false,
  }) {
    _updatedChartData.clear();
    for (int i = 0; i < _chartData.length; i++) {
      if (hasBanquetHall &&
          hasHealthSpa &&
          arePetsAllowed &&
          hasIndoorEntertainment) {
        if (_chartData[i].petsAllowed &&
            _chartData[i].hasHealthSpa &&
            _chartData[i].hasBanquetHall &&
            _chartData[i].hasIndoorEntertainment) {
          _updatedChartData.add(_chartData[i]);
        }
      } else if (hasBanquetHall && hasHealthSpa && arePetsAllowed) {
        if (_chartData[i].petsAllowed &&
            _chartData[i].hasHealthSpa &&
            _chartData[i].hasBanquetHall) {
          _updatedChartData.add(_chartData[i]);
        }
      } else if (hasBanquetHall && hasHealthSpa && hasIndoorEntertainment) {
        if (_chartData[i].hasIndoorEntertainment &&
            _chartData[i].hasHealthSpa &&
            _chartData[i].hasBanquetHall) {
          _updatedChartData.add(_chartData[i]);
        }
      } else if (hasBanquetHall && arePetsAllowed && hasIndoorEntertainment) {
        if (_chartData[i].hasIndoorEntertainment &&
            _chartData[i].petsAllowed &&
            _chartData[i].hasBanquetHall) {
          _updatedChartData.add(_chartData[i]);
        }
      } else if (hasHealthSpa && arePetsAllowed && hasIndoorEntertainment) {
        if (_chartData[i].hasIndoorEntertainment &&
            _chartData[i].petsAllowed &&
            _chartData[i].hasHealthSpa) {
          _updatedChartData.add(_chartData[i]);
        }
      } else if (hasBanquetHall && hasHealthSpa) {
        if (_chartData[i].hasBanquetHall && _chartData[i].hasHealthSpa) {
          _updatedChartData.add(_chartData[i]);
        }
      } else if (hasBanquetHall && arePetsAllowed) {
        if (_chartData[i].hasBanquetHall && _chartData[i].petsAllowed) {
          _updatedChartData.add(_chartData[i]);
        }
      } else if (hasBanquetHall && hasIndoorEntertainment) {
        if (_chartData[i].hasBanquetHall &&
            _chartData[i].hasIndoorEntertainment) {
          _updatedChartData.add(_chartData[i]);
        }
      } else if (hasHealthSpa && arePetsAllowed) {
        if (_chartData[i].hasHealthSpa && _chartData[i].petsAllowed) {
          _updatedChartData.add(_chartData[i]);
        }
      } else if (hasHealthSpa && hasIndoorEntertainment) {
        if (_chartData[i].hasHealthSpa &&
            _chartData[i].hasIndoorEntertainment) {
          _updatedChartData.add(_chartData[i]);
        }
      } else if (arePetsAllowed && hasIndoorEntertainment) {
        if (_chartData[i].petsAllowed && _chartData[i].hasIndoorEntertainment) {
          _updatedChartData.add(_chartData[i]);
        }
      } else if (hasBanquetHall) {
        if (_chartData[i].hasBanquetHall) {
          _updatedChartData.add(_chartData[i]);
        }
      } else if (hasHealthSpa) {
        if (_chartData[i].hasHealthSpa) {
          _updatedChartData.add(_chartData[i]);
        }
      } else if (arePetsAllowed) {
        if (_chartData[i].petsAllowed) {
          _updatedChartData.add(_chartData[i]);
        }
      } else if (hasIndoorEntertainment) {
        if (_chartData[i].hasIndoorEntertainment) {
          _updatedChartData.add(_chartData[i]);
        }
      } else {
        _updatedChartData.add(_chartData[i]);
      }
    }

    _updateRoomCount(values);
  }

  void _updateRoomCount(SfRangeValues values) {
    int roomCount = 0;
    for (int i = 0; i < _updatedChartData.length; i++) {
      if (_updatedChartData[i].rate >= values.start &&
          _updatedChartData[i].rate <= values.end) {
        roomCount += 1;
      }
    }

    _textController.text = 'Number of rooms available: $roomCount';
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final bool isLightTheme = Theme.of(context).brightness == Brightness.light;
    return Center(
      child: SingleChildScrollView(
        child: Container(
          color: isLightTheme ? const Color.fromRGBO(250, 250, 250, 1) : null,
          padding: model.isWebFullView
              ? const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 20.0)
              : const EdgeInsets.fromLTRB(10.0, 12.5, 10.0, 10.0),
          child: _buildRangeSelector(mediaQueryData, isLightTheme),
        ),
      ),
    );
  }

  Widget _buildRangeSelector(MediaQueryData mediaQueryData, bool isLightTheme) {
    final Axis direction =
        (mediaQueryData.orientation == Orientation.landscape ||
                model.isWebFullView) &&
            mediaQueryData.size.width > mediaQueryData.size.height
        ? Axis.horizontal
        : Axis.vertical;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Text('Room availability', style: TextStyle(fontSize: 20)),
        ),
        Flex(
          direction: direction,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (direction == Axis.horizontal)
              Expanded(child: _buildRangeSelectorWidget(isLightTheme))
            else
              _buildRangeSelectorWidget(isLightTheme),
            if (direction == Axis.horizontal)
              Expanded(child: _buildAmenities())
            else
              _buildAmenities(),
          ],
        ),
      ],
    );
  }

  Widget _buildRangeSelectorWidget(bool isLightTheme) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        color: model.sampleOutputCardColor,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
        child: Padding(
          padding: model.isWebFullView
              ? const EdgeInsets.all(20.0)
              : const EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  left: model.isWebFullView ? 5.0 : 15.0,
                ),
                child: const Text(
                  r'$100 to $1000',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  model.isWebFullView ? 5.0 : 15.0,
                  5.0,
                  0.0,
                  5.0,
                ),
                child: Text(_textController.text),
              ),
              SfRangeSelectorTheme(
                data: SfRangeSelectorThemeData(
                  thumbColor: Colors.white,
                  thumbStrokeColor: const Color.fromRGBO(0, 179, 134, 1.0),
                  thumbStrokeWidth: 2.0,
                  thumbRadius: 15,
                  tooltipBackgroundColor: isLightTheme
                      ? const Color.fromRGBO(0, 153, 115, 1.0)
                      : const Color.fromRGBO(0, 204, 153, 1.0),
                  overlayColor: const Color.fromRGBO(0, 179, 134, 0.12),
                  inactiveRegionColor: model.sampleOutputCardColor.withValues(
                    alpha: 0.75,
                  ),
                  activeTrackColor: const Color.fromRGBO(0, 179, 134, 1.0),
                  inactiveTrackColor: const Color.fromRGBO(0, 179, 134, 0.5),
                ),

                /// Range selector which has histogram chart as its child.
                child: SfRangeSelector(
                  min: _min,
                  max: _max,
                  controller: _rangeController,
                  interval: 225,
                  showTicks: true,
                  showLabels: true,
                  enableTooltip: true,
                  initialValues: _values,
                  tooltipTextFormatterCallback:
                      (dynamic actualValue, String formattedText) {
                        return '\$${actualValue.toInt()}';
                      },
                  labelFormatterCallback:
                      (dynamic actualValue, String formattedText) {
                        return '\$$formattedText';
                      },
                  onChanged: (SfRangeValues values) {
                    _values = values;
                    setState(() {
                      _updateRoomCount(values);
                    });
                  },
                  child: SfCartesianChart(
                    margin: EdgeInsets.zero,
                    plotAreaBorderWidth: 0,
                    enableAxisAnimation: true,
                    primaryXAxis: const NumericAxis(
                      isVisible: false,
                      minimum: 100,
                      maximum: 1000,
                    ),
                    primaryYAxis: const NumericAxis(isVisible: false),
                    series: _getHistogramSeries(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///Get the histogram series
  List<HistogramSeries<_RoomData, double>> _getHistogramSeries() {
    return <HistogramSeries<_RoomData, double>>[
      HistogramSeries<_RoomData, double>(
        dataSource: _updatedChartData,
        binInterval: 100,
        width: 1.0,
        color: const Color.fromRGBO(0, 179, 134, 0.5),
        yValueMapper: (_RoomData sales, _) => sales.rate,
      ),
    ];
  }

  /// UI part of amenities section.
  Widget _buildAmenities() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Card(
            color: model.sampleOutputCardColor,
            surfaceTintColor: Colors.transparent,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3.0),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
              child: SizedBox(
                height: 327,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(bottom: 5, left: 8),
                      child: Text(
                        'Amenities:',
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    CheckboxListTile(
                      contentPadding: const EdgeInsets.only(left: 8),
                      title: const Text(
                        'Basic',
                        style: TextStyle(fontSize: 16),
                      ),
                      value: true,
                      activeColor: Colors.grey,
                      onChanged: (bool? value) {},
                    ),
                    CheckboxListTile(
                      contentPadding: const EdgeInsets.only(left: 8),
                      title: const Text(
                        'Banquet hall',
                        style: TextStyle(fontSize: 16),
                      ),
                      value: _needBanquetHall,
                      onChanged: (bool? value) {
                        setState(() {
                          _needBanquetHall = value!;
                        });
                      },
                    ),
                    CheckboxListTile(
                      contentPadding: const EdgeInsets.only(left: 8),
                      title: const Text(
                        'Health spa',
                        style: TextStyle(fontSize: 16),
                      ),
                      value: _needHealthSpa,
                      onChanged: (bool? value) {
                        setState(() {
                          _needHealthSpa = value!;
                        });
                      },
                    ),
                    CheckboxListTile(
                      contentPadding: const EdgeInsets.only(left: 8),
                      title: const Text(
                        'Pets allowed',
                        style: TextStyle(fontSize: 16),
                      ),
                      value: _needPets,
                      onChanged: (bool? value) {
                        setState(() {
                          _needPets = value!;
                        });
                      },
                    ),
                    CheckboxListTile(
                      contentPadding: const EdgeInsets.only(left: 8),
                      title: const Text(
                        'Indoor entertainment',
                        style: TextStyle(fontSize: 16),
                      ),
                      value: _needIndoorEntertainment,
                      onChanged: (bool? value) {
                        setState(() {
                          _needIndoorEntertainment = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
          child: _buildFilterButton(),
        ),
      ],
    );
  }

  Widget _buildFilterButton() {
    return SizedBox(
      width: 350,
      height: 50,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(
            const Color.fromRGBO(255, 102, 102, 1.0),
          ),
        ),

        /// On clicking the button, chart inside the range selector will be
        /// updated with the filtered data.
        onPressed: () {
          setState(() {
            _updateChartData(
              _values,
              hasBanquetHall: _needBanquetHall,
              hasHealthSpa: _needHealthSpa,
              arePetsAllowed: _needPets,
              hasIndoorEntertainment: _needIndoorEntertainment,
            );
          });
        },
        child: const Text(
          'Apply filter',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

///Chart sample data
class _RoomData {
  _RoomData({
    required this.rate,
    this.hasBanquetHall = false,
    this.hasHealthSpa = false,
    this.petsAllowed = false,
    this.hasIndoorEntertainment = false,
  });

  final double rate;

  final bool hasBanquetHall;

  final bool hasHealthSpa;

  final bool petsAllowed;

  final bool hasIndoorEntertainment;
}
