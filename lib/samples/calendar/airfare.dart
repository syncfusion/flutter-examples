/// Dart import.
import 'dart:math';

/// Package import.
import 'package:flutter/material.dart';

/// Calendar import.
import 'package:syncfusion_flutter_calendar/calendar.dart';

/// Core import.
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/core.dart';

/// Local import.
import '../../model/sample_view.dart';

/// Smallest fare value.
const String _kBestPrice = r'$100.17';

/// Widget of air fare Calendar.
class AirFareCalendar extends SampleView {
  /// Creates default air fare Calendar.
  const AirFareCalendar(Key key) : super(key: key);

  @override
  _AirFareCalendarCalendarState createState() =>
      _AirFareCalendarCalendarState();
}

class _AirFareCalendarCalendarState extends SampleViewState {
  _AirFareCalendarCalendarState();

  final ScrollController _controller = ScrollController();
  List<AirFare> _airFareDataCollection = <AirFare>[];
  final List<int> _airlineId = <int>[1, 2, 3, 4];
  final List<String> _fares = <String>[];
  final DateTime _minDate = DateTime.now();
  late double _screenHeight;
  late Orientation _deviceOrientation;

  /// Global key used to maintain the state, when we change the parent of the
  /// widget.
  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    _addFareDataDetails();
    _addAirFareData();
    super.initState();
  }

  /// Creates required data for the air fare data.
  void _addFareDataDetails() {
    _fares.add(r'$134.50');
    _fares.add(r'$305.00');
    _fares.add(r'$152.66');
    _fares.add(r'$267.09');
    _fares.add(r'$189.20');
    _fares.add(r'$212.10');
    _fares.add(r'$350.50');
    _fares.add(r'$222.39');
    _fares.add(r'$238.83');
    _fares.add(r'$147.27');
    _fares.add(r'$115.43');
    _fares.add(r'$198.06');
    _fares.add(r'$189.83');
    _fares.add(r'$110.71');
    _fares.add(r'$152.10');
    _fares.add(r'$199.62');
    _fares.add(r'$146.15');
    _fares.add(r'$237.04');
    _fares.add(r'$100.17');
    _fares.add(r'$101.72');
    _fares.add(r'$266.69');
    _fares.add(r'$332.48');
    _fares.add(r'$256.77');
    _fares.add(r'$449.68');
    _fares.add(r'$100.17');
    _fares.add(r'$153.31');
    _fares.add(r'$249.92');
    _fares.add(r'$254.59');
    _fares.add(r'$332.48');
    _fares.add(r'$256.77');
    _fares.add(r'$449.68');
    _fares.add(r'$107.18');
    _fares.add(r'$219.04');
  }

  /// Returns color for the airplane data.
  Color _addAirPlaneColor(int id) {
    if (id == 1) {
      return Colors.grey;
    } else if (id == 2) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  /// Creates the air fare data with required information.
  void _addAirFareData() {
    _airFareDataCollection = <AirFare>[];
    for (int i = 0; i < 100; i++) {
      int id = i % _airlineId.length;
      if (id == 0) {
        id = 1;
      } else if (id > _airlineId.length) {
        id -= 1;
      }
      final String fare = _fares[i % _fares.length];
      final Color color = _addAirPlaneColor(id);
      _airFareDataCollection.add(
        AirFare(fare, color, 'Airways ' + id.toString()),
      );
    }
  }

  @override
  void didChangeDependencies() {
    _deviceOrientation = MediaQuery.of(context).orientation;
    _screenHeight = MediaQuery.of(context).size.height;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final Widget calendar = Theme(
      /// The key set here to maintain the state,
      /// when we change the parent of the widget.
      key: _globalKey,
      data: model.themeData.copyWith(
        colorScheme: model.themeData.colorScheme.copyWith(
          secondary: model.primaryColor,
        ),
      ),
      child: _buildAirFareCalendar(),
    );

    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child:
                (model.isWebFullView && _screenHeight < 800) ||
                    _deviceOrientation == Orientation.landscape
                ? Scrollbar(
                    thumbVisibility: true,
                    controller: _controller,
                    child: ListView(
                      controller: _controller,
                      children: <Widget>[
                        Container(
                          color: model.sampleOutputCardColor,
                          height: 600,
                          child: calendar,
                        ),
                      ],
                    ),
                  )
                : Container(
                    color: model.sampleOutputCardColor,
                    child: calendar,
                  ),
          ),
        ],
      ),
    );
  }

  /// Returns the Calendar widget based on the properties passed.
  SfCalendar _buildAirFareCalendar() {
    return SfCalendar(
      showNavigationArrow: model.isWebFullView,
      view: CalendarView.month,
      monthCellBuilder: _monthCellBuilder,
      showDatePickerButton: true,
      minDate: _minDate,
    );
  }

  /// Returns the builder for month cell.
  Widget _monthCellBuilder(
    BuildContext buildContext,
    MonthCellDetails details,
  ) {
    final Random random = Random.secure();
    final bool isToday = isSameDate(details.date, DateTime.now());
    final AirFare airFare = _airFareDataCollection[random.nextInt(100)];
    final Color defaultColor =
        model.themeData != null &&
            model.themeData.colorScheme.brightness == Brightness.dark
        ? Colors.white
        : Colors.black54;
    final bool isBestPrice = airFare.fare == _kBestPrice;
    final bool isDisabledDate =
        details.date.isBefore(_minDate) && !isSameDate(details.date, _minDate);
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 0.1, color: defaultColor),
          left: BorderSide(width: 0.1, color: defaultColor),
        ),
        color: isDisabledDate
            ? Colors.grey.withValues(alpha: 0.1)
            : isBestPrice
            ? Colors.yellow.withValues(alpha: 0.2)
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: model.isMobileResolution
                  ? MainAxisAlignment.center
                  : isBestPrice
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  details.date.day.toString(),
                  style: TextStyle(
                    color: isToday
                        ? model.primaryColor
                        : isDisabledDate
                        ? Colors.grey
                        : null,
                    fontWeight: isToday ? FontWeight.bold : null,
                  ),
                ),
                if (!model.isMobileResolution && airFare.fare == _kBestPrice)
                  Text(
                    'Best Price',
                    style: TextStyle(
                      color: isDisabledDate ? Colors.grey : Colors.green,
                    ),
                  )
                else
                  const Text(''),
              ],
            ),
          ),
          Text(
            airFare.fare,
            style: TextStyle(
              fontSize: model.isMobileResolution ? 12 : 15,
              color: const Color.fromRGBO(42, 138, 148, 1),
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Transform.rotate(
                angle: pi / 4,
                child: Text(
                  String.fromCharCode(Icons.airplanemode_active.codePoint),
                  style: TextStyle(
                    color: airFare.color,
                    fontFamily: Icons.airplanemode_active.fontFamily,
                    fontSize: !model.isMobileResolution ? 20 : 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              if (!model.isMobileResolution)
                Text(airFare.airline)
              else
                const Text(''),
            ],
          ),
        ],
      ),
    );
  }
}

/// Object to hold the air fare data.
class AirFare {
  /// Holds the data of air fares.
  const AirFare(this.fare, this.color, this.airline);

  /// Holds the string fare data.
  final String fare;

  /// Color of the fare.
  final Color color;

  /// Holds string of airline.
  final String airline;
}
