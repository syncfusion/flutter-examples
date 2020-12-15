///Flutter package imports
import 'package:flutter/material.dart';

///Core theme import
import 'package:syncfusion_flutter_core/theme.dart';

///Map import
import 'package:syncfusion_flutter_maps/maps.dart';

///Local import
import '../../../../model/sample_view.dart';

class MapLegendPage extends SampleView {
  const MapLegendPage(Key key) : super(key: key);
  @override
  _MapLegendPageState createState() => _MapLegendPageState();
}

class _MapLegendPageState extends SampleViewState {
  _MapLegendPageState();

  MapShapeSource _mapBubbleSource;
  MapShapeSource _mapShapeSource;

  List<InternetDataModel> _shapeInternetData;
  List<InternetDataModel> _bubbleInternetData;
  List<MapColorMapper> _shapeColorMappers;
  List<MapColorMapper> _bubbleColorMappers;
  List<MapColorMapper> _shapeBarLegendColorMappers;
  List<MapColorMapper> _bubbleBarLegendColorMappers;

  bool _showBubbleData = false;
  bool _showBarLegend = false;
  bool _enableToggleInteraction = true;
  bool _enableGradient = false;

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentLegend;

  @override
  void initState() {
    super.initState();

    _shapeInternetData = <InternetDataModel>[
      InternetDataModel('Algeria', price: 5.15),
      InternetDataModel('Angola', price: 7.95),
      InternetDataModel('Benin', price: 20.99),
      InternetDataModel('Botswana', price: 14.12),
      InternetDataModel('Burkina Faso', price: 4.69),
      InternetDataModel('Burundi', price: 2),
      InternetDataModel('Cameroon', price: 1.71),
      InternetDataModel('Cape Verde', price: 4.25),
      InternetDataModel('Central African Rep.',
          price: 6.03, countryName: 'Central African Republic'),
      InternetDataModel('Chad', price: 23.33),
      InternetDataModel('Comoros', price: 12.57),
      InternetDataModel('Congo', price: 5.63),
      InternetDataModel('C�te d\'Ivoire',
          price: 4.1, countryName: 'Ivory Coast'),
      InternetDataModel('Dem. Rep. Congo',
          price: 0.88, countryName: 'Democratic Republic of the Congo'),
      InternetDataModel('Djibouti', price: 37.92),
      InternetDataModel('Egypt', price: 1.49),
      InternetDataModel('Eq. Guinea',
          price: 65.83, countryName: 'Equatorial Guinea'),
      InternetDataModel('Eritrea'),
      InternetDataModel('Ethiopia', price: 2.91),
      InternetDataModel('Gabon', price: 5.84),
      InternetDataModel('Gambia', price: 5.33),
      InternetDataModel('Ghana', price: 1.56),
      InternetDataModel('Guinea', price: 1.97),
      InternetDataModel('Guinea-Bissau', price: 4.96),
      InternetDataModel('Kenya', price: 2.73),
      InternetDataModel('Lesotho', price: 2.43),
      InternetDataModel('Liberia', price: 3.75),
      InternetDataModel('Libya', price: 4.87),
      InternetDataModel('Madagascar', price: 3.39),
      InternetDataModel('Malawi', price: 3.59),
      InternetDataModel('Mali', price: 9.22),
      InternetDataModel('Mauritania', price: 3.12),
      InternetDataModel('Mauritius', price: 3.71),
      InternetDataModel('Mayotte', price: 10.18),
      InternetDataModel('Morocco', price: 1.6),
      InternetDataModel('Mozambique', price: 15.82),
      InternetDataModel('Namibia', price: 11.02),
      InternetDataModel('Niger', price: 2.98),
      InternetDataModel('Nigeria', price: 2.22),
      InternetDataModel('Rwanda', price: 0.56),
      InternetDataModel('Sao Tome and Principe', price: 5.33),
      InternetDataModel('Saint Helena', price: 55.47),
      InternetDataModel('Senegal', price: 3.28),
      InternetDataModel('Seychelles', price: 19.55),
      InternetDataModel('Sierra Leone', price: 5.79),
      InternetDataModel('Somalia', price: 6.19),
      InternetDataModel('Somaliland'),
      InternetDataModel('South Africa', price: 7.19),
      InternetDataModel('S. Sudan', countryName: 'South Sudan'),
      InternetDataModel('Sudan', price: 0.68),
      InternetDataModel('Swaziland', price: 12.14),
      InternetDataModel('Tanzania', price: 5.93),
      InternetDataModel('Togo', price: 11.76),
      InternetDataModel('Tunisia', price: 2.87),
      InternetDataModel('Uganda', price: 4.69),
      InternetDataModel('W. Sahara',
          price: 1.66, countryName: 'Western Sahara'),
      InternetDataModel('Zambia', price: 2.25),
      InternetDataModel('Zimbabwe', price: 75.2),
    ];

    _bubbleInternetData = <InternetDataModel>[
      InternetDataModel('Algeria', price: 5.15),
      InternetDataModel('Angola', price: 7.95),
      InternetDataModel('Benin', price: 20.99),
      InternetDataModel('Botswana', price: 14.12),
      InternetDataModel('Cape Verde', price: 4.25),
      InternetDataModel('Central African Rep.',
          price: 6.03, countryName: 'Central African Republic'),
      InternetDataModel('Chad', price: 23.33),
      InternetDataModel('Comoros', price: 12.57),
      InternetDataModel('Congo', price: 5.63),
      InternetDataModel('C�te d\'Ivoire',
          price: 4.1, countryName: 'Ivory Coast'),
      InternetDataModel('Dem. Rep. Congo',
          price: 0.88, countryName: 'Democratic Republic of the Congo'),
      InternetDataModel('Djibouti', price: 37.92),
      InternetDataModel('Egypt', price: 1.49),
      InternetDataModel('Eq. Guinea',
          price: 65.83, countryName: 'Equatorial Guinea'),
      InternetDataModel('Eritrea'),
      InternetDataModel('Guinea', price: 1.97),
      InternetDataModel('Kenya', price: 2.73),
      InternetDataModel('Madagascar', price: 3.39),
      InternetDataModel('Malawi', price: 3.59),
      InternetDataModel('Mali', price: 9.22),
      InternetDataModel('Mauritania', price: 3.12),
      InternetDataModel('Mauritius', price: 3.71),
      InternetDataModel('Mayotte', price: 10.18),
      InternetDataModel('Morocco', price: 1.6),
      InternetDataModel('Mozambique', price: 15.82),
      InternetDataModel('Namibia', price: 11.02),
      InternetDataModel('Niger', price: 2.98),
      InternetDataModel('Nigeria', price: 2.22),
      InternetDataModel('Rwanda', price: 0.56),
      InternetDataModel('Sao Tome and Principe', price: 5.33),
      InternetDataModel('Saint Helena', price: 55.47),
      InternetDataModel('Senegal', price: 3.28),
      InternetDataModel('Seychelles', price: 19.55),
      InternetDataModel('Somalia', price: 6.19),
      InternetDataModel('Somaliland'),
      InternetDataModel('South Africa', price: 7.19),
      InternetDataModel('S. Sudan', countryName: 'South Sudan'),
      InternetDataModel('Sudan', price: 0.68),
      InternetDataModel('Swaziland', price: 12.14),
      InternetDataModel('Tanzania', price: 5.93),
      InternetDataModel('Tunisia', price: 2.87),
      InternetDataModel('W. Sahara',
          price: 1.66, countryName: 'Western Sahara'),
      InternetDataModel('Zambia', price: 2.25),
      InternetDataModel('Zimbabwe', price: 75.2),
    ];

    _shapeColorMappers = [
      MapColorMapper(
          from: 0,
          to: 0.99,
          color: Color.fromRGBO(3, 192, 150, 1),
          text: '<\$1'),
      MapColorMapper(
          from: 1.0,
          to: 4.99,
          color: Color.fromRGBO(3, 192, 150, 0.6),
          text: '\$1 - \$4.99'),
      MapColorMapper(
          from: 5,
          to: 9.99,
          color: Color.fromRGBO(3, 192, 150, 0.35),
          text: '\$5 - \$9.99'),
      MapColorMapper(
          from: 10,
          to: 29.99,
          color: Color.fromRGBO(255, 175, 33, 0.70),
          text: '\$10 - \$29.99'),
      MapColorMapper(
          from: 30,
          to: 100,
          color: Color.fromRGBO(255, 175, 33, 1.0),
          text: '>\$30'),
    ];

    _bubbleColorMappers = [
      MapColorMapper(
          from: 0,
          to: 0.99,
          color: Color.fromRGBO(34, 205, 72, 0.6),
          text: '<\$1'),
      MapColorMapper(
          from: 1.0,
          to: 4.99,
          color: Color.fromRGBO(237, 171, 0, 0.6),
          text: '\$1 - \$4.99'),
      MapColorMapper(
          from: 5,
          to: 9.99,
          color: Color.fromRGBO(24, 152, 207, 0.6),
          text: '\$5 - \$9.99'),
      MapColorMapper(
          from: 10,
          to: 29.99,
          color: Color.fromRGBO(255, 0, 0, 0.6),
          text: '\$10 - \$29.99'),
      MapColorMapper(
          from: 30,
          to: 100,
          color: Color.fromRGBO(134, 0, 179, 0.6),
          text: '>\$30'),
    ];

    _shapeBarLegendColorMappers = [
      MapColorMapper(
          from: 0,
          to: 0.99,
          color: Color.fromRGBO(3, 192, 150, 1),
          text: '{\$0},{\$1}'),
      MapColorMapper(
          from: 1.0,
          to: 4.99,
          color: Color.fromRGBO(3, 192, 150, 0.6),
          text: '\$5'),
      MapColorMapper(
          from: 5,
          to: 9.99,
          color: Color.fromRGBO(3, 192, 150, 0.35),
          text: '\$10'),
      MapColorMapper(
          from: 10,
          to: 29.99,
          color: Color.fromRGBO(255, 175, 33, 0.70),
          text: '\$30'),
      MapColorMapper(
          from: 30,
          to: 100,
          color: Color.fromRGBO(255, 175, 33, 1.0),
          text: '\$100'),
    ];

    _bubbleBarLegendColorMappers = [
      MapColorMapper(
          from: 0,
          to: 0.99,
          color: Color.fromRGBO(34, 205, 72, 0.6),
          text: '{\$0},{\$1}'),
      MapColorMapper(
          from: 1.0,
          to: 4.99,
          color: Color.fromRGBO(237, 171, 0, 0.6),
          text: '\$5'),
      MapColorMapper(
          from: 5,
          to: 9.99,
          color: Color.fromRGBO(24, 152, 207, 0.6),
          text: '\$10'),
      MapColorMapper(
          from: 10,
          to: 29.99,
          color: Color.fromRGBO(255, 0, 0, 0.6),
          text: '\$30'),
      MapColorMapper(
          from: 30,
          to: 100,
          color: Color.fromRGBO(134, 0, 179, 0.6),
          text: '\$100'),
    ];

    _mapBubbleSource = MapShapeSource.asset(
      'assets/africa.json',
      shapeDataField: 'name',
      dataCount: _bubbleInternetData.length,
      primaryValueMapper: (int index) =>
          _bubbleInternetData[index].actualCountryName,
      bubbleSizeMapper: (int index) => _bubbleInternetData[index].price,
      bubbleColorValueMapper: (int index) => _bubbleInternetData[index].price,
      bubbleColorMappers: _bubbleColorMappers,
    );

    _mapShapeSource = MapShapeSource.asset(
      'assets/africa.json',
      shapeDataField: 'name',
      dataCount: _shapeInternetData.length,
      primaryValueMapper: (int index) =>
          _shapeInternetData[index].actualCountryName,
      shapeColorValueMapper: (int index) => _shapeInternetData[index].price,
      shapeColorMappers: _shapeColorMappers,
    );

    _dropDownMenuItems = _getDropDownMenuItems();
    _currentLegend = _dropDownMenuItems[0].value;
  }

  @override
  void dispose() {
    _shapeInternetData?.clear();
    _bubbleInternetData?.clear();
    _shapeColorMappers?.clear();
    _bubbleColorMappers?.clear();
    _shapeBarLegendColorMappers?.clear();
    _bubbleBarLegendColorMappers?.clear();
    super.dispose();
  }

  List<DropdownMenuItem<String>> _getDropDownMenuItems() {
    List<DropdownMenuItem<String>> legendItems = List()
      ..add(DropdownMenuItem(value: 'Default', child: Text('Default')))
      ..add(DropdownMenuItem(value: 'Bar', child: Text('Bar')));
    return legendItems;
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait ||
            model.isWeb
        ? _getMapsWidget()
        : SingleChildScrollView(
            child: Container(height: 400, child: _getMapsWidget()));
  }

  Widget _getMapsWidget() {
    bool isLightTheme = model?.themeData?.brightness == Brightness.light;
    return Padding(
      padding: MediaQuery.of(context).orientation == Orientation.portrait ||
              model.isWeb
          ? EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.05,
              right: 10,
              left: 5)
          : const EdgeInsets.only(left: 5, right: 10),
      child: SfMapsTheme(
        data: SfMapsThemeData(
          brightness: model?.themeData?.brightness,
          shapeHoverColor: _showBubbleData
              ? Colors.transparent
              : (isLightTheme
                  ? const Color.fromRGBO(204, 204, 204, 0.8)
                  : const Color.fromRGBO(77, 77, 77, 0.8)),
          shapeHoverStrokeColor: _showBubbleData
              ? Colors.transparent
              : (isLightTheme
                  ? const Color.fromRGBO(158, 158, 158, 1)
                  : const Color.fromRGBO(255, 255, 255, 1)),
          bubbleHoverColor: _showBubbleData
              ? (isLightTheme
                  ? const Color.fromRGBO(204, 204, 204, 0.8)
                  : const Color.fromRGBO(115, 115, 115, 0.8))
              : Colors.transparent,
          bubbleHoverStrokeColor: _showBubbleData
              ? const Color.fromRGBO(158, 158, 158, 1)
              : Colors.transparent,
          toggledItemColor: Colors.transparent,
          toggledItemStrokeColor: _showBubbleData ? Colors.transparent : null,
        ),
        child: SfMaps(
          title: const MapTitle(
            'Average Internet Prices in Africa',
            padding: EdgeInsets.only(top: 15, bottom: 30),
          ),
          layers: <MapShapeLayer>[
            MapShapeLayer(
              loadingBuilder: (BuildContext context) {
                return Container(
                  height: 25,
                  width: 25,
                  child: const CircularProgressIndicator(
                    strokeWidth: 3,
                  ),
                );
              },

              /// Changing the data based on whether data will be
              /// visualized using the shape colors or bubbles.
              source: _showBubbleData ? _mapBubbleSource : _mapShapeSource,
              // Returns the custom tooltip for each shape.
              shapeTooltipBuilder: _showBubbleData
                  ? null
                  : (BuildContext context, int index) {
                      if (_shapeInternetData[index].price == null) {
                        return null;
                      }
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Country : ' +
                              (_shapeInternetData[index].countryName ??
                                  _shapeInternetData[index].actualCountryName) +
                              '\nPrice : \$' +
                              _shapeInternetData[index].price.toString(),
                          style: Theme.of(context).textTheme.caption.copyWith(
                                color: isLightTheme
                                    ? Color.fromRGBO(255, 255, 255, 1)
                                    : Color.fromRGBO(10, 10, 10, 1),
                              ),
                        ),
                      );
                    },
              // Returns the custom tooltip for each bubble.
              bubbleTooltipBuilder: _showBubbleData
                  ? (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Country : ' +
                              (_bubbleInternetData[index].countryName ??
                                  _bubbleInternetData[index]
                                      .actualCountryName) +
                              '\nPrice : \$' +
                              _bubbleInternetData[index].price.toString(),
                          style: Theme.of(context).textTheme.caption.copyWith(
                                color: isLightTheme
                                    ? Color.fromRGBO(255, 255, 255, 1)
                                    : Color.fromRGBO(10, 10, 10, 1),
                              ),
                        ),
                      );
                    }
                  : null,
              color: _showBubbleData
                  ? (isLightTheme
                      ? Color.fromRGBO(204, 204, 204, 1)
                      : Color.fromRGBO(103, 103, 103, 1))
                  : null,
              strokeColor: _showBubbleData
                  ? (isLightTheme
                      ? Color.fromRGBO(255, 255, 255, 1)
                      : Color.fromRGBO(49, 49, 49, 1))
                  : Color.fromRGBO(255, 255, 255, 1),
              bubbleSettings: MapBubbleSettings(
                minRadius: 13,
                maxRadius: 20,
                strokeColor: Colors.black,
                strokeWidth: 0.5,
              ),
              legend: _showBarLegend
                  ? MapLegend.bar(
                      /// You can show legend for the shapes or bubbles. By
                      /// default, the legend will not be shown.
                      _showBubbleData ? MapElement.bubble : MapElement.shape,
                      edgeLabelsPlacement: MapLegendEdgeLabelsPlacement.inside,
                      labelsPlacement: MapLegendLabelsPlacement.betweenItems,
                      position: MapLegendPosition.top,
                      spacing: _enableGradient ? 10.0 : 1.0,
                      segmentPaintingStyle: _enableGradient
                          ? MapLegendPaintingStyle.gradient
                          : MapLegendPaintingStyle.solid,
                      segmentSize:
                          _enableGradient ? Size(300.0, 9.0) : Size(55.0, 9.0),
                      padding: EdgeInsets.only(bottom: 20),
                    )
                  : MapLegend(
                      /// You can show legend for the shapes or bubbles. By
                      /// default, the legend will not be shown.
                      _showBubbleData ? MapElement.bubble : MapElement.shape,
                      position: MapLegendPosition.left,
                      offset: Offset(
                          MediaQuery.of(context).size.width *
                              (model.isWeb ? 0.25 : 0.12),
                          50),
                      iconType: MapIconType.rectangle,
                      enableToggleInteraction: _enableToggleInteraction,
                    ),
              tooltipSettings: MapTooltipSettings(
                color: isLightTheme
                    ? Color.fromRGBO(45, 45, 45, 1)
                    : Color.fromRGBO(242, 242, 242, 1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return SingleChildScrollView(
          child: Container(
              height: 220,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Legend type",
                        style: TextStyle(
                          color: model.textColor,
                          fontSize: 16,
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(right: 15.0),
                          child: DropdownButton(
                            value: _currentLegend,
                            items: _dropDownMenuItems,
                            onChanged: (String value) {
                              setState(() {
                                _currentLegend = value;
                                if (_currentLegend == 'Bar') {
                                  _showBarLegend = true;
                                  _mapBubbleSource = MapShapeSource.asset(
                                    'assets/africa.json',
                                    shapeDataField: 'name',
                                    dataCount: _bubbleInternetData.length,
                                    primaryValueMapper: (int index) =>
                                        _bubbleInternetData[index]
                                            .actualCountryName,
                                    bubbleSizeMapper: (int index) =>
                                        _bubbleInternetData[index].price,
                                    bubbleColorValueMapper: (int index) =>
                                        _bubbleInternetData[index].price,
                                    bubbleColorMappers:
                                        _bubbleBarLegendColorMappers,
                                  );

                                  _mapShapeSource = MapShapeSource.asset(
                                    'assets/africa.json',
                                    shapeDataField: 'name',
                                    dataCount: _shapeInternetData.length,
                                    primaryValueMapper: (int index) =>
                                        _shapeInternetData[index]
                                            .actualCountryName,
                                    shapeColorValueMapper: (int index) =>
                                        _shapeInternetData[index].price,
                                    shapeColorMappers:
                                        _shapeBarLegendColorMappers,
                                  );
                                } else {
                                  _showBarLegend = false;
                                  _mapBubbleSource = MapShapeSource.asset(
                                    'assets/africa.json',
                                    shapeDataField: 'name',
                                    dataCount: _bubbleInternetData.length,
                                    primaryValueMapper: (int index) =>
                                        _bubbleInternetData[index]
                                            .actualCountryName,
                                    bubbleSizeMapper: (int index) =>
                                        _bubbleInternetData[index].price,
                                    bubbleColorValueMapper: (int index) =>
                                        _bubbleInternetData[index].price,
                                    bubbleColorMappers: _bubbleColorMappers,
                                  );

                                  _mapShapeSource = MapShapeSource.asset(
                                    'assets/africa.json',
                                    shapeDataField: 'name',
                                    dataCount: _shapeInternetData.length,
                                    primaryValueMapper: (int index) =>
                                        _shapeInternetData[index]
                                            .actualCountryName,
                                    shapeColorValueMapper: (int index) =>
                                        _shapeInternetData[index].price,
                                    shapeColorMappers: _shapeColorMappers,
                                  );
                                }
                                stateSetter(() {});
                              });
                            },
                          ))
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Enable legend for bubbles',
                          style: TextStyle(
                            color: model.textColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                          width: 90,
                          child: CheckboxListTile(
                              activeColor: model.backgroundColor,
                              value: _showBubbleData,
                              onChanged: (bool value) {
                                setState(() {
                                  _showBubbleData = value;
                                  stateSetter(() {});
                                });
                              })),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Enable toggle interaction',
                          style: TextStyle(
                            color: _showBarLegend
                                ? model.textColor.withOpacity(0.5)
                                : model.textColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        width: 90,
                        child: CheckboxListTile(
                            activeColor: model.backgroundColor,
                            value: _enableToggleInteraction,
                            onChanged: !_showBarLegend
                                ? (bool value) {
                                    setState(() {
                                      _enableToggleInteraction = value;
                                      stateSetter(() {});
                                    });
                                  }
                                : null),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Enable gradient',
                          style: TextStyle(
                            color: _showBarLegend
                                ? model.textColor
                                : model.textColor.withOpacity(0.5),
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        width: 90,
                        child: CheckboxListTile(
                            activeColor: model.backgroundColor,
                            value: _enableGradient,
                            onChanged: _showBarLegend
                                ? (bool value) {
                                    setState(() {
                                      _enableGradient = value;
                                      stateSetter(() {});
                                    });
                                  }
                                : null),
                      ),
                    ],
                  ),
                ],
              )));
    });
  }
}

class InternetDataModel {
  const InternetDataModel(
    this.actualCountryName, {
    this.price,
    this.countryName,
  });

  final String actualCountryName;
  final double price;
  final String countryName;
}
