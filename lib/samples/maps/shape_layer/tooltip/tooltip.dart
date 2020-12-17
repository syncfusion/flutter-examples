///Flutter package imports
import 'package:flutter/material.dart';

///Core theme import
import 'package:syncfusion_flutter_core/theme.dart';

///Map import
import 'package:syncfusion_flutter_maps/maps.dart';

///Local import
import '../../../../model/sample_view.dart';

class MapTooltipPage extends SampleView {
  const MapTooltipPage(Key key) : super(key: key);
  @override
  _MapTooltipPageState createState() => _MapTooltipPageState();
}

class _MapTooltipPageState extends SampleViewState {
  List<IndiaDataModel> _forestData;
  List<IndiaDataModel> _riverData;
  List<IndiaDataModel> _rainfallData;

  MapShapeSource _forestMapSource;
  MapShapeSource _riverMapSource;
  MapShapeSource _rainfallMapSource;
  MapShapeSource _mapSource;

  Color _bubbleColor;

  // Index of either forest, river or rainfall data.
  int _currentDataTypeIndex = 0;

  String _mapTitle;

  @override
  void initState() {
    _forestData = <IndiaDataModel>[
      IndiaDataModel('Madhya Pradesh',
          areaInSqKm: 77414,
          percent: 25.11,
          imageSource: 'images/maps_forest_1.jpg'),
      IndiaDataModel('Arunachal Pradesh',
          areaInSqKm: 66964,
          percent: 79.96,
          imageSource: 'images/maps_forest_2.jpg'),
      IndiaDataModel('Chhattisgarh',
          areaInSqKm: 55547,
          percent: 41.09,
          imageSource: 'images/maps_forest_3.jpg'),
      IndiaDataModel('Orissa',
          areaInSqKm: 51345,
          percent: 32.98,
          imageSource: 'images/maps_forest_1.jpg'),
      IndiaDataModel('Maharashtra',
          areaInSqKm: 50682,
          percent: 16.47,
          imageSource: 'images/maps_forest_2.jpg'),
      IndiaDataModel('Karnataka',
          areaInSqKm: 37550,
          percent: 19.58,
          imageSource: 'images/maps_forest_3.jpg'),
      IndiaDataModel('Andhra Pradesh',
          areaInSqKm: 28147,
          percent: 17.27,
          imageSource: 'images/maps_forest_1.jpg'),
      IndiaDataModel('Assam',
          areaInSqKm: 28105,
          percent: 35.83,
          imageSource: 'images/maps_forest_2.jpg'),
      IndiaDataModel('Tamil Nadu',
          areaInSqKm: 26281,
          percent: 20.21,
          imageSource: 'images/maps_forest_3.jpg'),
      IndiaDataModel('Uttaranchal',
          areaInSqKm: 24295,
          percent: 45.43,
          imageSource: 'images/maps_forest_1.jpg'),
    ];

    _riverData = <IndiaDataModel>[
      IndiaDataModel('Kerala',
          riversCount: 20, imageSource: 'images/maps_river_1.jpg'),
      IndiaDataModel('Maharashtra',
          riversCount: 15, imageSource: 'images/maps_river_2.jpg'),
      IndiaDataModel('Uttar Pradesh',
          riversCount: 15, imageSource: 'images/maps_river_3.jpg'),
      IndiaDataModel('West Bengal',
          riversCount: 15, imageSource: 'images/maps_river_1.jpg'),
      IndiaDataModel('Karnataka',
          riversCount: 14, imageSource: 'images/maps_river_2.jpg'),
      IndiaDataModel('Madhya Pradesh',
          riversCount: 13, imageSource: 'images/maps_river_3.jpg'),
      IndiaDataModel('Bihar',
          riversCount: 11, imageSource: 'images/maps_river_1.jpg'),
      IndiaDataModel('Andhra Pradesh',
          riversCount: 10, imageSource: 'images/maps_river_2.jpg'),
      IndiaDataModel('Tamil Nadu',
          riversCount: 10, imageSource: 'images/maps_river_3.jpg'),
      IndiaDataModel('Rajasthan',
          riversCount: 10, imageSource: 'images/maps_river_1.jpg'),
      IndiaDataModel('Assam',
          riversCount: 10, imageSource: 'images/maps_river_2.jpg'),
      IndiaDataModel('Gujarat',
          riversCount: 10, imageSource: 'images/maps_river_3.jpg'),
      IndiaDataModel('Uttaranchal',
          riversCount: 10, imageSource: 'images/maps_river_1.jpg'),
    ];

    _rainfallData = <IndiaDataModel>[
      IndiaDataModel('Arunachal Pradesh',
          rainfallInMillimeter: 2782,
          imageSource: 'images/maps_rainfall_1.jpg'),
      IndiaDataModel('Meghalaya',
          rainfallInMillimeter: 2818,
          imageSource: 'images/maps_rainfall_2.jpg'),
      IndiaDataModel('Goa',
          rainfallInMillimeter: 3005,
          imageSource: 'images/maps_rainfall_3.jpg'),
      IndiaDataModel('Madhya Pradesh',
          rainfallInMillimeter: 1178,
          imageSource: 'images/maps_rainfall_1.jpg'),
      IndiaDataModel('Maharastra',
          rainfallInMillimeter: 2739,
          imageSource: 'images/maps_rainfall_2.jpg'),
      IndiaDataModel('Uttar Pradesh',
          rainfallInMillimeter: 3005,
          imageSource: 'images/maps_rainfall_3.jpg'),
      IndiaDataModel('Karnataka',
          rainfallInMillimeter: 1771,
          imageSource: 'images/maps_rainfall_1.jpg'),
      IndiaDataModel('Kerala',
          rainfallInMillimeter: 3055,
          imageSource: 'images/maps_rainfall_2.jpg'),
      IndiaDataModel('Andhra Pradesh',
          rainfallInMillimeter: 912, imageSource: 'images/maps_rainfall_3.jpg'),
      IndiaDataModel('Tamil Nadu',
          rainfallInMillimeter: 998, imageSource: 'images/maps_rainfall_1.jpg'),
      IndiaDataModel('Orissa',
          rainfallInMillimeter: 1489,
          imageSource: 'images/maps_rainfall_2.jpg'),
    ];

    _forestMapSource = MapShapeSource.asset(
      'assets/india.json',
      shapeDataField: 'name',
      dataCount: _forestData.length,
      primaryValueMapper: (index) => _forestData[index].state,
      bubbleSizeMapper: (index) => _forestData[index].areaInSqKm.toDouble(),
    );

    _riverMapSource = MapShapeSource.asset(
      'assets/india.json',
      shapeDataField: 'name',
      dataCount: _riverData.length,
      primaryValueMapper: (index) => _riverData[index].state,
      bubbleSizeMapper: (index) => _riverData[index].riversCount,
    );

    _rainfallMapSource = MapShapeSource.asset(
      'assets/india.json',
      shapeDataField: 'name',
      dataCount: _rainfallData.length,
      primaryValueMapper: (index) => _rainfallData[index].state,
      bubbleSizeMapper: (index) => _rainfallData[index].rainfallInMillimeter,
    );

    _setMapDelegate(_currentDataTypeIndex);

    super.initState();
  }

  @override
  void dispose() {
    _forestData?.clear();
    _riverData?.clear();
    _rainfallData?.clear();
    super.dispose();
  }

  void _setMapDelegate(int index) {
    switch (index) {
      case 0:
        _mapTitle = 'Indian States with the Most Forest Area';
        _bubbleColor = Color.fromRGBO(34, 205, 72, 0.7);
        _mapSource = _forestMapSource;
        break;
      case 1:
        _mapTitle = 'Indian States with the Most Rivers';
        _bubbleColor = Color.fromRGBO(237, 171, 0, 0.7);
        _mapSource = _riverMapSource;
        break;
      case 2:
        _mapTitle = 'Indian States with the Most Rainfall';
        _bubbleColor = Color.fromRGBO(24, 152, 207, 0.7);
        _mapSource = _rainfallMapSource;
        break;
    }
  }

  Widget _getCustomTooltipWidget(
      IndiaDataModel model, ThemeData themeData, bool isLightTheme) {
    return Container(
        width: 300,
        padding: EdgeInsets.all(10),
        child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      model.state,
                      textAlign: TextAlign.center,
                      style: themeData.textTheme.bodyText2.copyWith(
                          color: isLightTheme
                              ? Color.fromRGBO(0, 0, 0, 0.87)
                              : Color.fromRGBO(255, 255, 255, 0.87),
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(_getTooltipText(model),
                        style: themeData.textTheme.caption.copyWith(
                          color: isLightTheme
                              ? Color.fromRGBO(0, 0, 0, 0.87)
                              : Color.fromRGBO(255, 255, 255, 0.87),
                        )),
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
            ]));
  }

  IndiaDataModel _getSelectedIndexModel(int index) {
    if (_currentDataTypeIndex == 0) {
      return _forestData[index];
    } else if (_currentDataTypeIndex == 1) {
      return _riverData[index];
    } else {
      return _rainfallData[index];
    }
  }

  // ignore: missing_return
  String _getTooltipText(IndiaDataModel model) {
    switch (_currentDataTypeIndex) {
      case 0:
        return '${model.areaInSqKm} sq. km of forest area, which is ${model.percent}% of the state’s geographical area.';
        break;
      case 1:
        return 'More than ${model.riversCount.toInt()} rivers flow in this state.';
        break;
      case 2:
        return 'Annual rainfall in this state is ${model.rainfallInMillimeter.toInt()} mm.';
        break;
    }
  }

  Widget _getChipWidget(int index, String text) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ChoiceChip(
        label: Text(
          text,
          style: TextStyle(
            color: model.textColor,
          ),
        ),
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
    return MediaQuery.of(context).orientation == Orientation.portrait ||
            model.isWeb
        ? _getMapsWidget(themeData)
        : SingleChildScrollView(
            child: Container(height: 400, child: _getMapsWidget(themeData)),
          );
  }

  Widget _getMapsWidget(ThemeData themeData) {
    final bool isLightTheme = themeData.brightness == Brightness.light;
    return Stack(
      children: [
        Container(
          padding: MediaQuery.of(context).orientation == Orientation.portrait ||
                  model.isWeb
              ? EdgeInsets.only(
                  left: 15,
                  top: MediaQuery.of(context).size.height * 0.05,
                  bottom: MediaQuery.of(context).size.height * 0.15)
              : const EdgeInsets.only(bottom: 75.0),
          child: SfMapsTheme(
            data: SfMapsThemeData(
              shapeHoverColor: Colors.transparent,
              shapeHoverStrokeWidth: 0,
              shapeHoverStrokeColor: Colors.transparent,
              bubbleHoverColor: _bubbleColor.withOpacity(0.4),
              bubbleHoverStrokeColor: Colors.black,
              bubbleHoverStrokeWidth: 1.0,
            ),
            child: SfMaps(
              title: MapTitle(
                _mapTitle,
                padding: const EdgeInsets.only(top: 15, bottom: 30),
              ),
              layers: [
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
                  source: _mapSource,

                  /// This callback returns the custom widget to be shown
                  /// as the tooltip. The custom widget will be wrapped
                  /// inside the tooltip. Hence, the nose will still be
                  /// there. You can customize the stroke around the
                  /// tooltip if needed.
                  bubbleTooltipBuilder: (BuildContext context, int index) {
                    return _getCustomTooltipWidget(
                        _getSelectedIndexModel(index), themeData, isLightTheme);
                  },
                  color: isLightTheme
                      ? Color.fromRGBO(204, 204, 204, 1)
                      : Color.fromRGBO(103, 103, 103, 1),
                  strokeColor: isLightTheme
                      ? Color.fromRGBO(255, 255, 255, 1)
                      : Color.fromRGBO(49, 49, 49, 1),
                  bubbleSettings: MapBubbleSettings(
                    minRadius: 15,
                    maxRadius: 30,
                    color: _bubbleColor,
                    strokeColor: Colors.black,
                    strokeWidth: 0.5,
                  ),
                  tooltipSettings: MapTooltipSettings(
                    color: isLightTheme
                        ? Color.fromRGBO(255, 255, 255, 1)
                        : Color.fromRGBO(66, 66, 66, 1),
                    strokeColor: Color.fromRGBO(153, 153, 153, 1),
                    strokeWidth: 0.5,
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
            children: [
              _getChipWidget(0, 'Forest'),
              _getChipWidget(1, 'River'),
              _getChipWidget(2, 'Rainfall'),
            ],
          ),
        )
      ],
    );
  }
}

class IndiaDataModel {
  const IndiaDataModel(
    this.state, {
    this.imageSource,
    this.areaInSqKm,
    this.percent,
    this.riversCount,
    this.rainfallInMillimeter,
  });

  final String state;

  final String imageSource;

  final int areaInSqKm;

  final double percent;

  final double riversCount;

  final double rainfallInMillimeter;
}
