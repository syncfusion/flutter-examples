///Flutter package imports
import 'package:flutter/material.dart';

///Core theme import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

///Map import
import 'package:syncfusion_flutter_maps/maps.dart';

///Local import
import '../../../../model/sample_view.dart';

/// Renders the map tooltip sample.
// ignore: must_be_immutable
class MapTooltipPage extends SampleView {
  /// Creates the map tooltip sample.
  MapTooltipPage(Key key) : super(key: key) {
    needsPropertyPanel = hideSampleStatus = false;
  }

  /// Specifies whether the property panel is required in web and other desktop platforms
  bool? needsPropertyPanel;

  /// Specifies whether to display sample status such as updated tag in web and other desktop platforms
  bool? hideSampleStatus;

  @override
  _MapTooltipPageState createState() => _MapTooltipPageState();
}

class _MapTooltipPageState extends SampleViewState {
  late List<_Area> _forestArea;
  late List<_Area> _riverArea;
  late List<_Area> _rainfallArea;

  late MapShapeSource _forestMapSource;
  late MapShapeSource _riverMapSource;
  late MapShapeSource _rainfallMapSource;
  late MapShapeSource _mapSource;

  late Color _bubbleColor;

  // Index of either forest, river or rainfall data.
  int _currentDataTypeIndex = 0;
  bool _autoHide = true;

  late String _title;

  @override
  void initState() {
    _forestArea = <_Area>[
      const _Area(
        'Madhya Pradesh',
        areaInSqKm: 77414,
        percent: 25.11,
        imageSource: 'images/maps_forest_1.jpg',
      ),
      const _Area(
        'Arunachal Pradesh',
        areaInSqKm: 66964,
        percent: 79.96,
        imageSource: 'images/maps_forest_2.jpg',
      ),
      const _Area(
        'Chhattisgarh',
        areaInSqKm: 55547,
        percent: 41.09,
        imageSource: 'images/maps_forest_3.jpg',
      ),
      const _Area(
        'Orissa',
        areaInSqKm: 51345,
        percent: 32.98,
        imageSource: 'images/maps_forest_1.jpg',
      ),
      const _Area(
        'Maharashtra',
        areaInSqKm: 50682,
        percent: 16.47,
        imageSource: 'images/maps_forest_2.jpg',
      ),
      const _Area(
        'Karnataka',
        areaInSqKm: 37550,
        percent: 19.58,
        imageSource: 'images/maps_forest_3.jpg',
      ),
      const _Area(
        'Andhra Pradesh',
        areaInSqKm: 28147,
        percent: 17.27,
        imageSource: 'images/maps_forest_1.jpg',
      ),
      const _Area(
        'Assam',
        areaInSqKm: 28105,
        percent: 35.83,
        imageSource: 'images/maps_forest_2.jpg',
      ),
      const _Area(
        'Tamil Nadu',
        areaInSqKm: 26281,
        percent: 20.21,
        imageSource: 'images/maps_forest_3.jpg',
      ),
      const _Area(
        'Uttaranchal',
        areaInSqKm: 24295,
        percent: 45.43,
        imageSource: 'images/maps_forest_1.jpg',
      ),
    ];

    _riverArea = <_Area>[
      const _Area(
        'Kerala',
        riversCount: 20,
        imageSource: 'images/maps_river_1.jpg',
      ),
      const _Area(
        'Maharashtra',
        riversCount: 15,
        imageSource: 'images/maps_river_2.jpg',
      ),
      const _Area(
        'Uttar Pradesh',
        riversCount: 15,
        imageSource: 'images/maps_river_3.jpg',
      ),
      const _Area(
        'West Bengal',
        riversCount: 15,
        imageSource: 'images/maps_river_1.jpg',
      ),
      const _Area(
        'Karnataka',
        riversCount: 14,
        imageSource: 'images/maps_river_2.jpg',
      ),
      const _Area(
        'Madhya Pradesh',
        riversCount: 13,
        imageSource: 'images/maps_river_3.jpg',
      ),
      const _Area(
        'Bihar',
        riversCount: 11,
        imageSource: 'images/maps_river_1.jpg',
      ),
      const _Area(
        'Andhra Pradesh',
        riversCount: 10,
        imageSource: 'images/maps_river_2.jpg',
      ),
      const _Area(
        'Tamil Nadu',
        riversCount: 10,
        imageSource: 'images/maps_river_3.jpg',
      ),
      const _Area(
        'Rajasthan',
        riversCount: 10,
        imageSource: 'images/maps_river_1.jpg',
      ),
      const _Area(
        'Assam',
        riversCount: 10,
        imageSource: 'images/maps_river_2.jpg',
      ),
      const _Area(
        'Gujarat',
        riversCount: 10,
        imageSource: 'images/maps_river_3.jpg',
      ),
      const _Area(
        'Uttaranchal',
        riversCount: 10,
        imageSource: 'images/maps_river_1.jpg',
      ),
    ];

    _rainfallArea = <_Area>[
      const _Area(
        'Arunachal Pradesh',
        rainfallInMillimeter: 2782,
        imageSource: 'images/maps_rainfall_1.jpg',
      ),
      const _Area(
        'Meghalaya',
        rainfallInMillimeter: 2818,
        imageSource: 'images/maps_rainfall_2.jpg',
      ),
      const _Area(
        'Goa',
        rainfallInMillimeter: 3005,
        imageSource: 'images/maps_rainfall_3.jpg',
      ),
      const _Area(
        'Madhya Pradesh',
        rainfallInMillimeter: 1178,
        imageSource: 'images/maps_rainfall_1.jpg',
      ),
      const _Area(
        'Maharastra',
        rainfallInMillimeter: 2739,
        imageSource: 'images/maps_rainfall_2.jpg',
      ),
      const _Area(
        'Uttar Pradesh',
        rainfallInMillimeter: 3005,
        imageSource: 'images/maps_rainfall_3.jpg',
      ),
      const _Area(
        'Karnataka',
        rainfallInMillimeter: 1771,
        imageSource: 'images/maps_rainfall_1.jpg',
      ),
      const _Area(
        'Kerala',
        rainfallInMillimeter: 3055,
        imageSource: 'images/maps_rainfall_2.jpg',
      ),
      const _Area(
        'Andhra Pradesh',
        rainfallInMillimeter: 912,
        imageSource: 'images/maps_rainfall_3.jpg',
      ),
      const _Area(
        'Tamil Nadu',
        rainfallInMillimeter: 998,
        imageSource: 'images/maps_rainfall_1.jpg',
      ),
      const _Area(
        'Orissa',
        rainfallInMillimeter: 1489,
        imageSource: 'images/maps_rainfall_2.jpg',
      ),
    ];

    _forestMapSource = MapShapeSource.asset(
      'assets/india.json',
      shapeDataField: 'name',
      dataCount: _forestArea.length,
      primaryValueMapper: (int index) => _forestArea[index].state,
      bubbleSizeMapper: (int index) =>
          _forestArea[index].areaInSqKm!.toDouble(),
    );

    _riverMapSource = MapShapeSource.asset(
      'assets/india.json',
      shapeDataField: 'name',
      dataCount: _riverArea.length,
      primaryValueMapper: (int index) => _riverArea[index].state,
      bubbleSizeMapper: (int index) => _riverArea[index].riversCount,
    );

    _rainfallMapSource = MapShapeSource.asset(
      'assets/india.json',
      shapeDataField: 'name',
      dataCount: _rainfallArea.length,
      primaryValueMapper: (int index) => _rainfallArea[index].state,
      bubbleSizeMapper: (int index) =>
          _rainfallArea[index].rainfallInMillimeter,
    );

    _setMapDelegate(_currentDataTypeIndex);

    super.initState();
  }

  @override
  void dispose() {
    _forestArea.clear();
    _riverArea.clear();
    _rainfallArea.clear();
    super.dispose();
  }

  void _setMapDelegate(int index) {
    switch (index) {
      case 0:
        _title = 'Indian States with the Most Forest Area';
        _bubbleColor = const Color.fromRGBO(34, 205, 72, 0.7);
        _mapSource = _forestMapSource;
        break;
      case 1:
        _title = 'Indian States with the Most Rivers';
        _bubbleColor = const Color.fromRGBO(237, 171, 0, 0.7);
        _mapSource = _riverMapSource;
        break;
      case 2:
        _title = 'Indian States with the Most Rainfall';
        _bubbleColor = const Color.fromRGBO(24, 152, 207, 0.7);
        _mapSource = _rainfallMapSource;
        break;
    }
  }

  Widget _buildCustomTooltipWidget(
    _Area model,
    ThemeData themeData,
    bool isLightTheme,
  ) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 5),
                Text(
                  model.state,
                  textAlign: TextAlign.center,
                  style: themeData.textTheme.bodyMedium!.copyWith(
                    color: isLightTheme
                        ? const Color.fromRGBO(0, 0, 0, 0.87)
                        : const Color.fromRGBO(255, 255, 255, 0.87),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _getTooltipText(model),
                  style: themeData.textTheme.bodySmall!.copyWith(
                    color: isLightTheme
                        ? const Color.fromRGBO(0, 0, 0, 0.87)
                        : const Color.fromRGBO(255, 255, 255, 0.87),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: Image.asset(
              model.imageSource,
              height: 80.0,
              width: 80.0,
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }

  _Area _getSelectedIndexModel(int index) {
    if (_currentDataTypeIndex == 0) {
      return _forestArea[index];
    } else if (_currentDataTypeIndex == 1) {
      return _riverArea[index];
    } else {
      return _rainfallArea[index];
    }
  }

  // ignore: missing_return
  String _getTooltipText(_Area model) {
    switch (_currentDataTypeIndex) {
      case 0:
        return '${model.areaInSqKm} sq. km of forest area, which is ${model.percent}% of the state’s geographical area.';
      case 1:
        return 'More than ${model.riversCount!.toInt()} rivers flow in this state.';
      case 2:
        return 'Annual rainfall in this state is ${model.rainfallInMillimeter!.toInt()} mm.';
    }

    return '';
  }

  Widget _buildChipWidget(int index, String text) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ChoiceChip(
        label: Text(text, style: TextStyle(color: model.textColor)),
        shape: const StadiumBorder(side: BorderSide(color: Colors.transparent)),
        showCheckmark: false,
        selected: _currentDataTypeIndex == index,
        selectedColor: _bubbleColor,
        onSelected: (bool isSelected) {
          setState(() {
            _currentDataTypeIndex = isSelected ? index : 0;
            _setMapDelegate(_currentDataTypeIndex);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
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
              child: _buildMapsWidget(themeData, scrollEnabled),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMapsWidget(ThemeData themeData, bool scrollEnabled) {
    final bool isLightTheme =
        themeData.colorScheme.brightness == Brightness.light;
    return Stack(
      children: <Widget>[
        Container(
          padding: scrollEnabled
              ? EdgeInsets.only(
                  left: 15,
                  top: MediaQuery.of(context).size.height * 0.05,
                  bottom: MediaQuery.of(context).size.height * 0.075,
                )
              : const EdgeInsets.only(bottom: 70.0),
          child: SfMapsTheme(
            data: SfMapsThemeData(
              shapeHoverColor: Colors.transparent,
              shapeHoverStrokeWidth: 0,
              shapeHoverStrokeColor: Colors.transparent,
              bubbleHoverColor: _bubbleColor.withValues(alpha: 0.4),
              bubbleHoverStrokeColor: Colors.black,
              bubbleHoverStrokeWidth: 1.0,
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 30),
                  child: Align(
                    child: Text(
                      _title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
                Expanded(
                  child: SfMaps(
                    layers: <MapLayer>[
                      MapShapeLayer(
                        loadingBuilder: (BuildContext context) {
                          return const SizedBox(
                            height: 25,
                            width: 25,
                            child: CircularProgressIndicator(strokeWidth: 3),
                          );
                        },
                        source: _mapSource,

                        /// This callback returns the custom widget to be shown
                        /// as the tooltip. The custom widget will be wrapped
                        /// inside the tooltip. Hence, the nose will still be
                        /// there. You can customize the stroke around the
                        /// tooltip if needed.
                        bubbleTooltipBuilder:
                            (BuildContext context, int index) {
                              return _buildCustomTooltipWidget(
                                _getSelectedIndexModel(index),
                                themeData,
                                isLightTheme,
                              );
                            },
                        color: isLightTheme
                            ? const Color.fromRGBO(204, 204, 204, 1)
                            : const Color.fromRGBO(103, 103, 103, 1),
                        strokeColor: isLightTheme
                            ? const Color.fromRGBO(255, 255, 255, 1)
                            : const Color.fromRGBO(49, 49, 49, 1),
                        strokeWidth: 0.5,
                        bubbleSettings: MapBubbleSettings(
                          minRadius: 15,
                          maxRadius: 30,
                          color: _bubbleColor,
                          strokeColor: Colors.black,
                          strokeWidth: 0.5,
                        ),
                        tooltipSettings: MapTooltipSettings(
                          color: isLightTheme
                              ? const Color.fromRGBO(255, 255, 255, 1)
                              : const Color.fromRGBO(66, 66, 66, 1),
                          strokeColor: const Color.fromRGBO(153, 153, 153, 1),
                          strokeWidth: 0.5,
                          hideDelay: _autoHide ? 3.0 : double.infinity,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildChipWidget(0, 'Forest'),
              _buildChipWidget(1, 'River'),
              _buildChipWidget(2, 'Rainfall'),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          value: _autoHide,
          title: const Text('Auto hide'),
          activeColor: model.primaryColor,
          onChanged: (bool? value) {
            setState(() {
              _autoHide = value!;
              stateSetter(() {});
            });
          },
        );
      },
    );
  }
}

class _Area {
  const _Area(
    this.state, {
    required this.imageSource,
    this.areaInSqKm,
    this.percent,
    this.riversCount,
    this.rainfallInMillimeter,
  });

  final String state;

  final String imageSource;

  final int? areaInSqKm;

  final double? percent;

  final double? riversCount;

  final double? rainfallInMillimeter;
}
