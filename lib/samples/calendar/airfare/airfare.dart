///Dart imports
import 'dart:math';

///Package imports
import 'package:flutter/material.dart';

///calendar import
import 'package:syncfusion_flutter_calendar/calendar.dart';

/// core import
import 'package:syncfusion_flutter_core/core.dart';

///Local import
import '../../../model/sample_view.dart';

/// Smallest fare value
const String _kBestPrice = "\$100.17";

/// Widget of air fare calendar
class AirFareCalendar extends SampleView {
  /// Creates default air fare calendar
  const AirFareCalendar(Key key) : super(key: key);

  @override
  _AirFareCalendarCalendarState createState() =>
      _AirFareCalendarCalendarState();
}

class _AirFareCalendarCalendarState extends SampleViewState {
  _AirFareCalendarCalendarState();

  ScrollController controller;
  List<AirFare> airFareDataCollection;
  List<int> airlineId;
  List<String> fares;
  DateTime minDate;

  /// Global key used to maintain the state, when we change the parent of the
  /// widget
  GlobalKey _globalKey;
  double _screenHeight;
  Orientation _deviceOrientation;

  @override
  void initState() {
    _globalKey = GlobalKey();
    controller = ScrollController();
    airFareDataCollection = <AirFare>[];
    airlineId = <int>[];
    fares = <String>[];
    minDate = DateTime.now();
    _addFareDataDetails();
    _addAirFareData();
    super.initState();
  }

  /// Creates required data for the air fare data.
  void _addFareDataDetails() {
    airlineId = <int>[1, 2, 3, 4];
    fares.add("\$134.50");
    fares.add("\$305.00");
    fares.add("\$152.66");
    fares.add("\$267.09");
    fares.add("\$189.20");
    fares.add("\$212.10");
    fares.add("\$350.50");
    fares.add("\$222.39");
    fares.add("\$238.83");
    fares.add("\$147.27");
    fares.add("\$115.43");
    fares.add("\$198.06");
    fares.add("\$189.83");
    fares.add("\$110.71");
    fares.add("\$152.10");
    fares.add("\$199.62");
    fares.add("\$146.15");
    fares.add("\$237.04");
    fares.add("\$100.17");
    fares.add("\$101.72");
    fares.add("\$266.69");
    fares.add("\$332.48");
    fares.add("\$256.77");
    fares.add("\$449.68");
    fares.add("\$100.17");
    fares.add("\$153.31");
    fares.add("\$249.92");
    fares.add("\$254.59");
    fares.add("\$332.48");
    fares.add("\$256.77");
    fares.add("\$449.68");
    fares.add("\$107.18");
    fares.add("\$219.04");
  }

  /// Returns color for the airplane data.
  Color _getAirPlaneColor(int id) {
    if (id == 1) {
      return Colors.grey;
    } else if (id == 2) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  /// Creates the air fare data with required information
  void _addAirFareData() {
    airFareDataCollection = <AirFare>[];
    for (int i = 0; i < 100; i++) {
      int id = i % airlineId.length;
      if (id == 0) {
        id = 1;
      } else if (id > airlineId.length) {
        id -= 1;
      }
      final String fare = fares[i % fares.length];
      final Color color = _getAirPlaneColor(id);
      airFareDataCollection
          .add(AirFare(fare, color, 'Airways ' + id.toString()));
    }
  }

  @override
  @override
  void didChangeDependencies() {
    _deviceOrientation = MediaQuery.of(context).orientation;
    _screenHeight = MediaQuery.of(context).size.height;
    super.didChangeDependencies();
  }

  Widget build([BuildContext context]) {
    final Widget _calendar = Theme(

        /// The key set here to maintain the state,
        ///  when we change the parent of the widget
        key: _globalKey,
        data: model.themeData.copyWith(accentColor: model.backgroundColor),
        child: _getAirFareCalendar());

    return Scaffold(
      body:
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Expanded(
          child: (model.isWeb && _screenHeight < 800) ||
                  _deviceOrientation == Orientation.landscape
              ? Scrollbar(
                  isAlwaysShown: true,
                  controller: controller,
                  child: ListView(
                    controller: controller,
                    children: <Widget>[
                      Container(
                        color: model.cardThemeColor,
                        height: 600,
                        child: _calendar,
                      )
                    ],
                  ))
              : Container(color: model.cardThemeColor, child: _calendar),
        )
      ]),
    );
  }

  /// Returns the calendar widget based on the properties passed.
  SfCalendar _getAirFareCalendar() {
    return SfCalendar(
      showNavigationArrow: model.isWeb,
      view: CalendarView.month,
      monthCellBuilder: _monthCellBuilder,
      showDatePickerButton: true,
      minDate: minDate,
    );
  }

  /// Returns the builder for month cell.
  Widget _monthCellBuilder(
      BuildContext buildContext, MonthCellDetails details) {
    Random random = Random();
    final bool isToday = isSameDate(details.date, DateTime.now());
    final AirFare airFare = airFareDataCollection[random.nextInt(100)];
    final Color defaultColor =
        model.themeData != null && model.themeData.brightness == Brightness.dark
            ? Colors.white
            : Colors.black54;
    final bool isBestPrice = airFare.fare == _kBestPrice;
    final bool isDisabledDate =
        details.date.isBefore(minDate) && !isSameDate(details.date, minDate);
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: defaultColor, width: 0.1),
          color: isDisabledDate
              ? Colors.grey.withOpacity(0.1)
              : isBestPrice ? Colors.yellow.withOpacity(0.2) : null),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: model.isMobileResolution
                  ? MainAxisAlignment.center
                  : isBestPrice
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  details.date.day.toString(),
                  style: TextStyle(
                      color: isToday
                          ? model.backgroundColor
                          : isDisabledDate ? Colors.grey : null,
                      fontWeight: isToday ? FontWeight.bold : null),
                ),
                !model.isMobileResolution && airFare.fare == _kBestPrice
                    ? Text(
                        'Best Price',
                        style: TextStyle(
                            color: isDisabledDate ? Colors.grey : Colors.green),
                      )
                    : Text('')
              ],
            ),
          ),
          Text(
            airFare.fare,
            style: TextStyle(
                fontSize: model.isMobileResolution ? 12 : 15,
                color: Color.fromRGBO(42, 138, 148, 1),
                fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Transform.rotate(
                angle: -pi / 4,
                child: Text(
                  '\u2708',
                  style: TextStyle(
                      color: airFare.color,
                      fontFamily: 'Roboto',
                      fontSize: !model.isMobileResolution ? 20 : 14),
                  textAlign: TextAlign.center,
                ),
              ),
              !model.isMobileResolution ? Text(airFare.airline) : Text('')
            ],
          )
        ],
      ),
    );
  }
}

/// Object to hold the air fare data.
class AirFare {
  const AirFare(this.fare, this.color, this.airline);

  final String fare;
  final Color color;
  final String airline;
}
