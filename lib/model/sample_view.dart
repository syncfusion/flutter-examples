/// Package import
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

/// Local import
import 'model.dart';

/// Base class of the sample's stateful widget class
abstract class SampleView extends StatefulWidget {
  /// base class constructor of sample's stateful widget class
  const SampleView({Key? key}) : super(key: key);
}

/// Base class of the sample's state class
abstract class SampleViewState<T extends SampleView> extends State<T> {
  /// Holds the SampleModel information
  late SampleModel model;

  /// Holds the information of current page is card view or not
  late bool isCardView;

  @override
  void initState() {
    model = SampleModel.instance;
    isCardView = model.isCardView && !model.isWebFullView;
    super.initState();
  }

  /// Must call super.
  @override
  void dispose() {
    model.isCardView = true;
    super.dispose();
  }

  /// Get the settings panel content.
  Widget? buildSettings(BuildContext context) {
    return null;
  }
}

/// Base class of the localization sample's stateful widget class
class LocalizationSampleView extends SampleView {
  /// base class constructor of sample's stateful widget class
  const LocalizationSampleView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LocalizationSampleViewState();
}

/// Base class of the localization sample's state class
class LocalizationSampleViewState<T extends LocalizationSampleView>
    extends SampleViewState<T> {
  late List<Locale> _supportedLocales;

  @override
  void initState() {
    if (this is! DirectionalitySampleViewState) {
      _supportedLocales = <Locale>[
        const Locale('ar', 'AE'),
        const Locale('en', 'US'),
        const Locale('es', 'ES'),
        const Locale('fr', 'FR'),
        const Locale('zh', 'CN'),
      ];
    } else {
      _supportedLocales = <Locale>[
        const Locale('ar', 'AE'),
        const Locale('en', 'US'),
      ];
    }

    super.initState();
  }

  /// Add the localization selection widget.
  Widget localizationSelectorWidget(BuildContext context) {
    final double screenWidth = model.isWebFullView
        ? 250
        : MediaQuery.of(context).size.width;
    final double dropDownWidth = 0.6 * screenWidth;
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return Row(
          children: <Widget>[
            Text(
              this is DirectionalitySampleViewState ? 'Language' : 'Locale',
              softWrap: false,
              style: TextStyle(fontSize: 16, color: model.textColor),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
              width: dropDownWidth,
              child: DropdownButton<Locale>(
                dropdownColor: model.drawerBackgroundColor,
                focusColor: Colors.transparent,
                isExpanded: true,
                underline: Container(color: const Color(0xFFBDBDBD), height: 1),
                value: model.locale,
                items: _supportedLocales.map((Locale value) {
                  String localeString = value.toString();
                  if (this is DirectionalitySampleViewState) {
                    localeString = (localeString == 'ar_AE')
                        ? 'Arabic'
                        : 'English';
                  } else {
                    localeString =
                        localeString.substring(0, 2) +
                        '-' +
                        localeString.substring(3, 5);
                  }

                  return DropdownMenuItem<Locale>(
                    value: value,
                    child: Text(
                      localeString,
                      style: TextStyle(color: model.textColor),
                    ),
                  );
                }).toList(),
                onChanged: (Locale? value) {
                  if (model.locale != value) {
                    setState(() {
                      stateSetter(() {
                        model.isInitialRender = false;
                        model.locale = value;
                        if (this is! DirectionalitySampleViewState) {
                          if (model.locale == const Locale('ar', 'AE')) {
                            model.textDirection = TextDirection.rtl;
                          } else {
                            model.textDirection = TextDirection.ltr;
                          }
                        }
                      });
                    });
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDirectionalityWidget() {
    return Localizations(
      locale: model.locale!,
      delegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        SfGlobalLocalizations.delegate,
      ],
      child: Directionality(
        textDirection: model.textDirection,
        child: buildSample(context) ?? Container(),
      ),
    );
  }

  /// Method to get the widget's color based on the widget state
  Color? getColor(Set<WidgetState> states) {
    const Set<WidgetState> interactiveStates = <WidgetState>{
      WidgetState.pressed,
      WidgetState.selected,
    };
    if (states.any(interactiveStates.contains)) {
      return model.primaryColor;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return _buildDirectionalityWidget();
  }

  /// Get the settings panel content.
  Widget? buildSample(BuildContext context) {
    return null;
  }

  /// Must call super.
  @override
  void dispose() {
    super.dispose();
  }
}

/// Base class of the directionality sample's stateful widget class
class DirectionalitySampleView extends LocalizationSampleView {
  /// base class constructor of sample's stateful widget class
  const DirectionalitySampleView({Key? key}) : super(key: key);
}

/// Base class of the directionality sample's state class
class DirectionalitySampleViewState<T extends DirectionalitySampleView>
    extends LocalizationSampleViewState<T> {
  final List<TextDirection> _supportedTextDirection = <TextDirection>[
    TextDirection.ltr,
    TextDirection.rtl,
  ];

  /// Must call super.
  @override
  void dispose() {
    super.dispose();
  }

  /// Close all overlay when property panel is opened. Implemented for PdfViewer
  /// RTL sample.
  void closeAllOverlay() {}

  /// Add the localization selection widget.
  Widget textDirectionSelectorWidget(BuildContext context) {
    final double screenWidth = model.isWebFullView
        ? 250
        : MediaQuery.of(context).size.width;
    closeAllOverlay();
    final double dropDownWidth = 0.6 * screenWidth;
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return Row(
          children: <Widget>[
            Text(
              'Rendering\nDirection',
              maxLines: 2,
              textAlign: TextAlign.left,
              softWrap: false,
              style: TextStyle(fontSize: 16, color: model.textColor),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
              width: dropDownWidth,
              child: DropdownButton<TextDirection>(
                dropdownColor: model.drawerBackgroundColor,
                focusColor: Colors.transparent,
                isExpanded: true,
                underline: Container(color: const Color(0xFFBDBDBD), height: 1),
                value: model.textDirection,
                items: _supportedTextDirection.map((TextDirection value) {
                  return DropdownMenuItem<TextDirection>(
                    value: value,
                    child: Text(
                      value.toString().split('.')[1].toUpperCase(),
                      style: TextStyle(color: model.textColor),
                    ),
                  );
                }).toList(),
                onChanged: (TextDirection? value) {
                  if (model.textDirection != value) {
                    setState(() {
                      stateSetter(() {
                        model.isInitialRender = false;
                        model.textDirection = value!;
                      });
                    });
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

///Chart sample data
class ChartSampleData {
  /// Holds the datapoint values like x, y, etc.,
  ChartSampleData({
    this.x,
    this.y,
    this.xValue,
    this.yValue,
    this.secondSeriesYValue,
    this.thirdSeriesYValue,
    this.pointColor,
    this.size,
    this.text,
    this.open,
    this.close,
    this.low,
    this.high,
    this.volume,
  });

  /// Holds x value of the datapoint
  final dynamic x;

  /// Holds y value of the datapoint
  final num? y;

  /// Holds x value of the datapoint
  final dynamic xValue;

  /// Holds y value of the datapoint
  final num? yValue;

  /// Holds y value of the datapoint(for 2nd series)
  final num? secondSeriesYValue;

  /// Holds y value of the datapoint(for 3nd series)
  final num? thirdSeriesYValue;

  /// Holds point color of the datapoint
  final Color? pointColor;

  /// Holds size of the datapoint
  final num? size;

  /// Holds datalabel/text value mapper of the datapoint
  final String? text;

  /// Holds open value of the datapoint
  final num? open;

  /// Holds close value of the datapoint
  final num? close;

  /// Holds low value of the datapoint
  final num? low;

  /// Holds high value of the datapoint
  final num? high;

  /// Holds open value of the datapoint
  final num? volume;
}

/// Chart Sales Data
class SalesData {
  /// Holds the datapoint values like x, y, etc.,
  SalesData(this.x, this.y, [this.date, this.color]);

  /// X value of the data point
  final dynamic x;

  /// y value of the data point
  final dynamic y;

  /// color value of the data point
  final Color? color;

  /// Date time value of the data point
  final DateTime? date;
}

/// Circular progress bar color
class ProgressBarColor {
  /// creating constructor of progress bar color.
  ProgressBarColor(this.model);

  /// Holds the SampleModel information.
  final SampleModel model;

  /// Get the pointer color based on the theme.
  Color? get pointerColor => model.themeData.useMaterial3
      ? model.primaryColor.withValues(alpha: 0.8)
      : null;

  /// Get the axis line color based on the theme.
  Color get axisLineColor => model.themeData.useMaterial3
      ? model.primaryColor.withAlpha(30)
      : const Color.fromARGB(30, 0, 169, 181);

  /// Get the buffer color based on the theme.
  Color get bufferColor => model.themeData.useMaterial3
      ? model.primaryColor.withAlpha(90)
      : const Color.fromARGB(90, 0, 169, 181);
}
