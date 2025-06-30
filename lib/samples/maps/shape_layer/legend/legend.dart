///Flutter package imports
import 'package:flutter/material.dart';

///Core theme import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

///Map import
// ignore: import_of_legacy_library_into_null_safe
import 'package:syncfusion_flutter_maps/maps.dart';

///Local import
import '../../../../model/sample_view.dart';

/// Renders the legend map sample
class MapLegendPage extends SampleView {
  /// Creates the legend map sample
  const MapLegendPage(Key key) : super(key: key);

  @override
  _MapLegendPageState createState() => _MapLegendPageState();
}

class _MapLegendPageState extends SampleViewState {
  _MapLegendPageState();

  late MapShapeSource _mapBubbleSource;
  late MapShapeSource _mapShapeSource;

  late List<_InternetPrice> _internetPriceForShapes;
  late List<_InternetPrice> _internetPriceForBubbles;
  late List<MapColorMapper> _shapeColorMappers;
  late List<MapColorMapper> _bubbleColorMappers;
  late List<MapColorMapper> _shapeBarLegendColorMappers;
  late List<MapColorMapper> _bubbleBarLegendColorMappers;

  bool _showBubbleData = false;
  bool _showBarLegend = false;
  bool _enableToggleInteraction = true;
  bool _enableGradient = false;

  late List<DropdownMenuItem<String>> _dropDownMenuItems;
  late String _currentLegend;

  @override
  void initState() {
    super.initState();

    _internetPriceForShapes = <_InternetPrice>[
      const _InternetPrice('Algeria', price: 5.15),
      const _InternetPrice('Angola', price: 7.95),
      const _InternetPrice('Benin', price: 20.99),
      const _InternetPrice('Botswana', price: 14.12),
      const _InternetPrice('Burkina Faso', price: 4.69),
      const _InternetPrice('Burundi', price: 2),
      const _InternetPrice('Cameroon', price: 1.71),
      const _InternetPrice('Cape Verde', price: 4.25),
      const _InternetPrice(
        'Central African Rep.',
        price: 6.03,
        countryName: 'Central African Republic',
      ),
      const _InternetPrice('Chad', price: 23.33),
      const _InternetPrice('Comoros', price: 12.57),
      const _InternetPrice('Congo', price: 5.63),
      const _InternetPrice(
        "C�te d'Ivoire",
        price: 4.1,
        countryName: 'Ivory Coast',
      ),
      const _InternetPrice(
        'Dem. Rep. Congo',
        price: 0.88,
        countryName: 'Democratic Republic of the Congo',
      ),
      const _InternetPrice('Djibouti', price: 37.92),
      const _InternetPrice('Egypt', price: 1.49),
      const _InternetPrice(
        'Eq. Guinea',
        price: 65.83,
        countryName: 'Equatorial Guinea',
      ),
      const _InternetPrice('Eritrea'),
      const _InternetPrice('Ethiopia', price: 2.91),
      const _InternetPrice('Gabon', price: 5.84),
      const _InternetPrice('Gambia', price: 5.33),
      const _InternetPrice('Ghana', price: 1.56),
      const _InternetPrice('Guinea', price: 1.97),
      const _InternetPrice('Guinea-Bissau', price: 4.96),
      const _InternetPrice('Kenya', price: 2.73),
      const _InternetPrice('Lesotho', price: 2.43),
      const _InternetPrice('Liberia', price: 3.75),
      const _InternetPrice('Libya', price: 4.87),
      const _InternetPrice('Madagascar', price: 3.39),
      const _InternetPrice('Malawi', price: 3.59),
      const _InternetPrice('Mali', price: 9.22),
      const _InternetPrice('Mauritania', price: 3.12),
      const _InternetPrice('Mauritius', price: 3.71),
      const _InternetPrice('Mayotte', price: 10.18),
      const _InternetPrice('Morocco', price: 1.6),
      const _InternetPrice('Mozambique', price: 15.82),
      const _InternetPrice('Namibia', price: 11.02),
      const _InternetPrice('Niger', price: 2.98),
      const _InternetPrice('Nigeria', price: 2.22),
      const _InternetPrice('Rwanda', price: 0.56),
      const _InternetPrice('Sao Tome and Principe', price: 5.33),
      const _InternetPrice('Saint Helena', price: 55.47),
      const _InternetPrice('Senegal', price: 3.28),
      const _InternetPrice('Seychelles', price: 19.55),
      const _InternetPrice('Sierra Leone', price: 5.79),
      const _InternetPrice('Somalia', price: 6.19),
      const _InternetPrice('Somaliland'),
      const _InternetPrice('South Africa', price: 7.19),
      const _InternetPrice('S. Sudan', countryName: 'South Sudan'),
      const _InternetPrice('Sudan', price: 0.68),
      const _InternetPrice('Swaziland', price: 12.14),
      const _InternetPrice('Tanzania', price: 5.93),
      const _InternetPrice('Togo', price: 11.76),
      const _InternetPrice('Tunisia', price: 2.87),
      const _InternetPrice('Uganda', price: 4.69),
      const _InternetPrice(
        'W. Sahara',
        price: 1.66,
        countryName: 'Western Sahara',
      ),
      const _InternetPrice('Zambia', price: 2.25),
      const _InternetPrice('Zimbabwe', price: 75.2),
    ];

    _internetPriceForBubbles = <_InternetPrice>[
      const _InternetPrice('Algeria', price: 5.15),
      const _InternetPrice('Angola', price: 7.95),
      const _InternetPrice('Benin', price: 20.99),
      const _InternetPrice('Botswana', price: 14.12),
      const _InternetPrice('Cape Verde', price: 4.25),
      const _InternetPrice(
        'Central African Rep.',
        price: 6.03,
        countryName: 'Central African Republic',
      ),
      const _InternetPrice('Chad', price: 23.33),
      const _InternetPrice('Comoros', price: 12.57),
      const _InternetPrice('Congo', price: 5.63),
      const _InternetPrice(
        "C�te d'Ivoire",
        price: 4.1,
        countryName: 'Ivory Coast',
      ),
      const _InternetPrice(
        'Dem. Rep. Congo',
        price: 0.88,
        countryName: 'Democratic Republic of the Congo',
      ),
      const _InternetPrice('Djibouti', price: 37.92),
      const _InternetPrice('Egypt', price: 1.49),
      const _InternetPrice(
        'Eq. Guinea',
        price: 65.83,
        countryName: 'Equatorial Guinea',
      ),
      const _InternetPrice('Eritrea'),
      const _InternetPrice('Guinea', price: 1.97),
      const _InternetPrice('Kenya', price: 2.73),
      const _InternetPrice('Madagascar', price: 3.39),
      const _InternetPrice('Malawi', price: 3.59),
      const _InternetPrice('Mali', price: 9.22),
      const _InternetPrice('Mauritania', price: 3.12),
      const _InternetPrice('Mauritius', price: 3.71),
      const _InternetPrice('Mayotte', price: 10.18),
      const _InternetPrice('Morocco', price: 1.6),
      const _InternetPrice('Mozambique', price: 15.82),
      const _InternetPrice('Namibia', price: 11.02),
      const _InternetPrice('Niger', price: 2.98),
      const _InternetPrice('Nigeria', price: 2.22),
      const _InternetPrice('Rwanda', price: 0.56),
      const _InternetPrice('Sao Tome and Principe', price: 5.33),
      const _InternetPrice('Saint Helena', price: 55.47),
      const _InternetPrice('Senegal', price: 3.28),
      const _InternetPrice('Seychelles', price: 19.55),
      const _InternetPrice('Somalia', price: 6.19),
      const _InternetPrice('Somaliland'),
      const _InternetPrice('South Africa', price: 7.19),
      const _InternetPrice('S. Sudan', countryName: 'South Sudan'),
      const _InternetPrice('Sudan', price: 0.68),
      const _InternetPrice('Swaziland', price: 12.14),
      const _InternetPrice('Tanzania', price: 5.93),
      const _InternetPrice('Tunisia', price: 2.87),
      const _InternetPrice(
        'W. Sahara',
        price: 1.66,
        countryName: 'Western Sahara',
      ),
      const _InternetPrice('Zambia', price: 2.25),
      const _InternetPrice('Zimbabwe', price: 75.2),
    ];

    _shapeColorMappers = <MapColorMapper>[
      const MapColorMapper(
        from: 0,
        to: 0.99,
        color: Color.fromRGBO(3, 192, 150, 1),
        text: r'<$1',
      ),
      const MapColorMapper(
        from: 1.0,
        to: 4.99,
        color: Color.fromRGBO(3, 192, 150, 0.6),
        text: r'$1 - $4.99',
      ),
      const MapColorMapper(
        from: 5,
        to: 9.99,
        color: Color.fromRGBO(3, 192, 150, 0.35),
        text: r'$5 - $9.99',
      ),
      const MapColorMapper(
        from: 10,
        to: 29.99,
        color: Color.fromRGBO(255, 175, 33, 0.70),
        text: r'$10 - $29.99',
      ),
      const MapColorMapper(
        from: 30,
        to: 100,
        color: Color.fromRGBO(255, 175, 33, 1.0),
        text: r'>$30',
      ),
    ];

    _bubbleColorMappers = <MapColorMapper>[
      const MapColorMapper(
        from: 0,
        to: 0.99,
        color: Color.fromRGBO(34, 205, 72, 0.6),
        text: r'<$1',
      ),
      const MapColorMapper(
        from: 1.0,
        to: 4.99,
        color: Color.fromRGBO(237, 171, 0, 0.6),
        text: r'$1 - $4.99',
      ),
      const MapColorMapper(
        from: 5,
        to: 9.99,
        color: Color.fromRGBO(24, 152, 207, 0.6),
        text: r'$5 - $9.99',
      ),
      const MapColorMapper(
        from: 10,
        to: 29.99,
        color: Color.fromRGBO(255, 0, 0, 0.6),
        text: r'$10 - $29.99',
      ),
      const MapColorMapper(
        from: 30,
        to: 100,
        color: Color.fromRGBO(134, 0, 179, 0.6),
        text: r'>$30',
      ),
    ];

    _shapeBarLegendColorMappers = <MapColorMapper>[
      const MapColorMapper(
        from: 0,
        to: 0.99,
        color: Color.fromRGBO(3, 192, 150, 1),
        text: r'{$0},{$1}',
      ),
      const MapColorMapper(
        from: 1.0,
        to: 4.99,
        color: Color.fromRGBO(3, 192, 150, 0.6),
        text: r'$5',
      ),
      const MapColorMapper(
        from: 5,
        to: 9.99,
        color: Color.fromRGBO(3, 192, 150, 0.35),
        text: r'$10',
      ),
      const MapColorMapper(
        from: 10,
        to: 29.99,
        color: Color.fromRGBO(255, 175, 33, 0.70),
        text: r'$30',
      ),
      const MapColorMapper(
        from: 30,
        to: 100,
        color: Color.fromRGBO(255, 175, 33, 1.0),
        text: r'$100',
      ),
    ];

    _bubbleBarLegendColorMappers = <MapColorMapper>[
      const MapColorMapper(
        from: 0,
        to: 0.99,
        color: Color.fromRGBO(34, 205, 72, 0.6),
        text: r'{$0},{$1}',
      ),
      const MapColorMapper(
        from: 1.0,
        to: 4.99,
        color: Color.fromRGBO(237, 171, 0, 0.6),
        text: r'$5',
      ),
      const MapColorMapper(
        from: 5,
        to: 9.99,
        color: Color.fromRGBO(24, 152, 207, 0.6),
        text: r'$10',
      ),
      const MapColorMapper(
        from: 10,
        to: 29.99,
        color: Color.fromRGBO(255, 0, 0, 0.6),
        text: r'$30',
      ),
      const MapColorMapper(
        from: 30,
        to: 100,
        color: Color.fromRGBO(134, 0, 179, 0.6),
        text: r'$100',
      ),
    ];

    _mapBubbleSource = MapShapeSource.asset(
      'assets/africa.json',
      shapeDataField: 'name',
      dataCount: _internetPriceForBubbles.length,
      primaryValueMapper: (int index) =>
          _internetPriceForBubbles[index].actualCountryName,
      bubbleSizeMapper: (int index) => _internetPriceForBubbles[index].price,
      bubbleColorValueMapper: (int index) =>
          _internetPriceForBubbles[index].price,
      bubbleColorMappers: _bubbleColorMappers,
    );

    _mapShapeSource = MapShapeSource.asset(
      'assets/africa.json',
      shapeDataField: 'name',
      dataCount: _internetPriceForShapes.length,
      primaryValueMapper: (int index) =>
          _internetPriceForShapes[index].actualCountryName,
      shapeColorValueMapper: (int index) =>
          _internetPriceForShapes[index].price,
      shapeColorMappers: _shapeColorMappers,
    );

    _dropDownMenuItems = _getDropDownMenuItems();
    _currentLegend = _dropDownMenuItems[0].value!;
  }

  @override
  void dispose() {
    _internetPriceForShapes.clear();
    _internetPriceForBubbles.clear();
    _shapeColorMappers.clear();
    _bubbleColorMappers.clear();
    _shapeBarLegendColorMappers.clear();
    _bubbleBarLegendColorMappers.clear();
    super.dispose();
  }

  List<DropdownMenuItem<String>> _getDropDownMenuItems() {
    const List<DropdownMenuItem<String>> legendItems =
        <DropdownMenuItem<String>>[
          DropdownMenuItem<String>(value: 'default', child: Text('default')),
          DropdownMenuItem<String>(value: 'bar', child: Text('bar')),
        ];
    return legendItems;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool scrollEnabled = constraints.maxHeight > 400;
        double height = scrollEnabled ? constraints.maxHeight : 400;
        if (model.isWebFullView ||
            (model.isMobile &&
                MediaQuery.of(context).orientation == Orientation.landscape)) {
          final double refHeight = height * 0.6;
          height = height > 500 ? (refHeight < 500 ? 500 : refHeight) : height;
        }
        return Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: constraints.maxWidth,
              height: height,
              child: _buildMapsWidget(scrollEnabled),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMapsWidget(bool scrollEnabled) {
    final bool isLightTheme =
        model.themeData.colorScheme.brightness == Brightness.light;
    return Padding(
      padding: scrollEnabled
          ? EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.05,
              right: 10,
              left: 5,
            )
          : const EdgeInsets.only(left: 5, right: 10),
      child: SfMapsTheme(
        data: SfMapsThemeData(
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
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: 15,
                bottom: (_enableGradient && !model.isMobile) ? 18 : 30,
              ),
              child: Align(
                child: Text(
                  'Average Internet Prices in Africa',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
            Expanded(
              child: SfMaps(
                layers: <MapShapeLayer>[
                  MapShapeLayer(
                    loadingBuilder: (BuildContext context) {
                      return const SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(strokeWidth: 3),
                      );
                    },

                    /// Changing the data based on whether data will be
                    /// visualized using the shape colors or bubbles.
                    source: _showBubbleData
                        ? _mapBubbleSource
                        : _mapShapeSource,
                    // Returns the custom tooltip for each shape.
                    shapeTooltipBuilder: _showBubbleData
                        ? null
                        : (BuildContext context, int index) {
                            if (_internetPriceForShapes[index].price == null) {
                              return const SizedBox();
                            }
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Country : ' +
                                    (_internetPriceForShapes[index]
                                            .countryName ??
                                        _internetPriceForShapes[index]
                                            .actualCountryName) +
                                    '\nPrice : \$' +
                                    _internetPriceForShapes[index].price
                                        .toString(),
                                style: Theme.of(context).textTheme.bodySmall!
                                    .copyWith(
                                      color: isLightTheme
                                          ? const Color.fromRGBO(
                                              255,
                                              255,
                                              255,
                                              1,
                                            )
                                          : const Color.fromRGBO(10, 10, 10, 1),
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
                                    (_internetPriceForBubbles[index]
                                            .countryName ??
                                        _internetPriceForBubbles[index]
                                            .actualCountryName) +
                                    '\nPrice : \$' +
                                    _internetPriceForBubbles[index].price
                                        .toString(),
                                style: Theme.of(context).textTheme.bodySmall!
                                    .copyWith(
                                      color: isLightTheme
                                          ? const Color.fromRGBO(
                                              255,
                                              255,
                                              255,
                                              1,
                                            )
                                          : const Color.fromRGBO(10, 10, 10, 1),
                                    ),
                              ),
                            );
                          }
                        : null,
                    color: _showBubbleData
                        ? (isLightTheme
                              ? const Color.fromRGBO(204, 204, 204, 1)
                              : const Color.fromRGBO(103, 103, 103, 1))
                        : null,
                    strokeColor: _showBubbleData
                        ? (isLightTheme
                              ? const Color.fromRGBO(255, 255, 255, 1)
                              : const Color.fromRGBO(49, 49, 49, 1))
                        : const Color.fromRGBO(255, 255, 255, 1),
                    bubbleSettings: const MapBubbleSettings(
                      minRadius: 13,
                      maxRadius: 20,
                      strokeColor: Colors.black,
                      strokeWidth: 0.5,
                    ),
                    legend: _showBarLegend
                        ? MapLegend.bar(
                            /// You can show legend for the shapes or bubbles. By
                            /// default, the legend will not be shown.
                            _showBubbleData
                                ? MapElement.bubble
                                : MapElement.shape,
                            labelsPlacement:
                                MapLegendLabelsPlacement.betweenItems,
                            spacing: _enableGradient ? 10.0 : 1.0,
                            segmentPaintingStyle: _enableGradient
                                ? MapLegendPaintingStyle.gradient
                                : MapLegendPaintingStyle.solid,
                            segmentSize: _enableGradient
                                ? const Size(279.0, 9.0)
                                : const Size(55.0, 9.0),
                            showPointerOnHover: true,
                            padding: const EdgeInsets.only(bottom: 20),
                          )
                        : MapLegend(
                            /// You can show legend for the shapes or bubbles. By
                            /// default, the legend will not be shown.
                            _showBubbleData
                                ? MapElement.bubble
                                : MapElement.shape,
                            position: MapLegendPosition.left,
                            offset: Offset(
                              MediaQuery.of(context).size.width *
                                  (model.isWebFullView && model.needToMaximize
                                      ? 0.25
                                      : 0.12),
                              50,
                            ),
                            iconType: MapIconType.rectangle,
                            enableToggleInteraction: _enableToggleInteraction,
                          ),
                    tooltipSettings: MapTooltipSettings(
                      color: isLightTheme
                          ? const Color.fromRGBO(45, 45, 45, 1)
                          : const Color.fromRGBO(242, 242, 242, 1),
                    ),
                  ),
                ],
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Legend type',
                    softWrap: false,
                    style: TextStyle(color: model.textColor, fontSize: 16),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: DropdownButton<String>(
                      dropdownColor: model.drawerBackgroundColor,
                      focusColor: Colors.transparent,
                      value: _currentLegend,
                      items: _dropDownMenuItems,
                      onChanged: (String? value) {
                        setState(() {
                          _currentLegend = value!;
                          if (_currentLegend == 'bar') {
                            _showBarLegend = true;
                            _mapBubbleSource = MapShapeSource.asset(
                              'assets/africa.json',
                              shapeDataField: 'name',
                              dataCount: _internetPriceForBubbles.length,
                              primaryValueMapper: (int index) =>
                                  _internetPriceForBubbles[index]
                                      .actualCountryName,
                              bubbleSizeMapper: (int index) =>
                                  _internetPriceForBubbles[index].price,
                              bubbleColorValueMapper: (int index) =>
                                  _internetPriceForBubbles[index].price,
                              bubbleColorMappers: _bubbleBarLegendColorMappers,
                            );

                            _mapShapeSource = MapShapeSource.asset(
                              'assets/africa.json',
                              shapeDataField: 'name',
                              dataCount: _internetPriceForShapes.length,
                              primaryValueMapper: (int index) =>
                                  _internetPriceForShapes[index]
                                      .actualCountryName,
                              shapeColorValueMapper: (int index) =>
                                  _internetPriceForShapes[index].price,
                              shapeColorMappers: _shapeBarLegendColorMappers,
                            );
                          } else {
                            _showBarLegend = false;
                            _mapBubbleSource = MapShapeSource.asset(
                              'assets/africa.json',
                              shapeDataField: 'name',
                              dataCount: _internetPriceForBubbles.length,
                              primaryValueMapper: (int index) =>
                                  _internetPriceForBubbles[index]
                                      .actualCountryName,
                              bubbleSizeMapper: (int index) =>
                                  _internetPriceForBubbles[index].price,
                              bubbleColorValueMapper: (int index) =>
                                  _internetPriceForBubbles[index].price,
                              bubbleColorMappers: _bubbleColorMappers,
                            );

                            _mapShapeSource = MapShapeSource.asset(
                              'assets/africa.json',
                              shapeDataField: 'name',
                              dataCount: _internetPriceForShapes.length,
                              primaryValueMapper: (int index) =>
                                  _internetPriceForShapes[index]
                                      .actualCountryName,
                              shapeColorValueMapper: (int index) =>
                                  _internetPriceForShapes[index].price,
                              shapeColorMappers: _shapeColorMappers,
                            );
                          }
                          stateSetter(() {});
                        });
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      model.isWebFullView
                          ? 'Enable legend for \nbubbles'
                          : 'Enable legend for bubbles',
                      softWrap: false,
                      style: TextStyle(color: model.textColor, fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    child: CheckboxListTile(
                      activeColor: model.primaryColor,
                      value: _showBubbleData,
                      onChanged: (bool? value) {
                        setState(() {
                          _showBubbleData = value!;
                          stateSetter(() {});
                        });
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      model.isWebFullView
                          ? 'Enable toggle \ninteraction'
                          : 'Enable toggle interaction',
                      softWrap: false,
                      style: TextStyle(
                        color: _showBarLegend
                            ? model.textColor.withValues(alpha: 0.5)
                            : model.textColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    child: CheckboxListTile(
                      activeColor: model.primaryColor,
                      value: _enableToggleInteraction,
                      onChanged: !_showBarLegend
                          ? (bool? value) {
                              setState(() {
                                _enableToggleInteraction = value!;
                                stateSetter(() {});
                              });
                            }
                          : null,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Enable gradient',
                      softWrap: false,
                      style: TextStyle(
                        color: _showBarLegend
                            ? model.textColor
                            : model.textColor.withValues(alpha: 0.5),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    child: CheckboxListTile(
                      activeColor: model.primaryColor,
                      value: _enableGradient,
                      onChanged: _showBarLegend
                          ? (bool? value) {
                              setState(() {
                                _enableGradient = value!;
                                stateSetter(() {});
                              });
                            }
                          : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _InternetPrice {
  const _InternetPrice(this.actualCountryName, {this.price, this.countryName});

  final String actualCountryName;
  final double? price;
  final String? countryName;
}
