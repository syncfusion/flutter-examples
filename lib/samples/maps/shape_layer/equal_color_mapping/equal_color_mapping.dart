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

/// Renders the map widget with equla color mapping
class MapEqualColorMappingPage extends SampleView {
  /// Creates the map widget to a finding time zone
  const MapEqualColorMappingPage(Key key) : super(key: key);

  @override
  _MapEqualColorMappingPageState createState() =>
      _MapEqualColorMappingPageState();
}

class _MapEqualColorMappingPageState extends SampleViewState {
  late List<_CountryTimeInGMT> _timeZones;
  late MapShapeSource _mapSource;
  Brightness? brightness;

  void _createOrUpdateMapSource(Brightness brightness) {
    final bool isLight = brightness == Brightness.light;
    _mapSource = MapShapeSource.asset(
      // Path of the GeoJSON file.
      'assets/world_map.json',
      // Field or group name in the .json file to identify
      // the shapes.
      //
      // Which is used to map the respective shape
      // to data source.
      //
      // On the basis of this value, shape tooltip text
      // is rendered.
      shapeDataField: 'name',
      // The number of data in your data source collection.
      //
      // The callback for the [primaryValueMapper] will be
      // called the number of times equal to the [dataCount].
      // The value returned in the [primaryValueMapper] should
      // exactly matched with the value of the [shapeDataField]
      // in the .json file. This is how the mapping between the
      // data source and the shapes in the .json file is done.
      dataCount: _timeZones.length,
      primaryValueMapper: (int index) => _timeZones[index].countryName,
      // Used for color mapping.
      //
      // The value of the [MapColorMapper.value] will be
      // compared with the value returned in the
      // [shapeColorValueMapper]. If it is equal, the respective
      // [MapColorMapper.color] will be applied to the shape.
      shapeColorValueMapper: (int index) => _timeZones[index].game,
      // Group and differentiate the shapes using the color
      // based on [MapColorMapper.value] value.
      //
      // The value of the [MapColorMapper.value]
      // will be compared with the value returned in the
      // [shapeColorValueMapper] and the respective
      // [MapColorMapper.color] will be applied to the shape.
      //
      // [MapColorMapper.text] which is used for the text of
      // legend item and [MapColorMapper.color] will be used for
      // the color of the legend icon respectively.
      shapeColorMappers: <MapColorMapper>[
        MapColorMapper(
          value: 'Soccer',
          color: isLight ? const Color(0xFF06AEE0) : const Color(0xFF4DAAFF),
          text: 'Football (Soccer)',
        ),
        MapColorMapper(
          value: 'Basketball',
          color: isLight ? const Color(0xFF6355C7) : const Color(0xFF33B677),
          text: 'Basketball',
        ),
        MapColorMapper(
          value: 'Cricket',
          color: isLight ? const Color(0xFFEC5C7B) : const Color(0xFFB93CE4),
          text: 'Cricket',
        ),
        MapColorMapper(
          value: 'Baseball',
          color: isLight ? const Color(0xFFFFB400) : const Color(0xFFB2F32E),
          text: 'Baseball',
        ),
        MapColorMapper(
          value: 'Football (NFL)',
          color: isLight ? const Color(0xFF3BA31A) : const Color(0xFFFF9D45),
          text: 'American Football',
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    // Data source to the map.
    //
    // [countryName]: Field name in the .json file to identify the shape.
    // This is the name to be mapped with shapes in .json file.
    // This should be exactly same as the value of the [shapeDataField]
    // in the .json file
    //
    // [gmtTime]: On the basis of this value, color mapping color has been
    // applied to the shape.
    _timeZones = <_CountryTimeInGMT>[
      _CountryTimeInGMT('China', 'Basketball'),
      _CountryTimeInGMT('India', 'Cricket'),
      _CountryTimeInGMT('United States of America', 'Football (NFL)'),
      _CountryTimeInGMT('Indonesia', 'Soccer'),
      _CountryTimeInGMT('Pakistan', 'Cricket'),
      _CountryTimeInGMT('Brazil', 'Soccer'),
      _CountryTimeInGMT('Nigeria', 'Soccer'),
      _CountryTimeInGMT('Bangladesh', 'Cricket'),
      _CountryTimeInGMT('Russia', 'Soccer'),
      _CountryTimeInGMT('Mexico', 'Soccer'),
      _CountryTimeInGMT('Japan', 'Baseball'),
      _CountryTimeInGMT('Ethiopia', 'Soccer'),
      _CountryTimeInGMT('Philippines', 'Basketball'),
      _CountryTimeInGMT('Egypt', 'Soccer'),
      _CountryTimeInGMT('Vietnam', 'Soccer'),
      _CountryTimeInGMT('Democratic Republic of the Congo', 'Soccer'),
      _CountryTimeInGMT('Turkey', 'Soccer'),
      _CountryTimeInGMT('Iran', 'Soccer'),
      _CountryTimeInGMT('Germany', 'Soccer'),
      _CountryTimeInGMT('Thailand', 'Soccer'),
      _CountryTimeInGMT('England', 'Soccer'),
      _CountryTimeInGMT('France', 'Soccer'),
      _CountryTimeInGMT('Italy', 'Soccer'),
      _CountryTimeInGMT('Tanzania', 'Soccer'),
      _CountryTimeInGMT('South Africa', 'Soccer'),
      _CountryTimeInGMT('Myanmar', 'Soccer'),
      _CountryTimeInGMT('Kenya', 'Soccer'),
      _CountryTimeInGMT('South Korea', 'Soccer'),
      _CountryTimeInGMT('Colombia', 'Soccer'),
      _CountryTimeInGMT('Spain', 'Soccer'),
    ];
  }

  @override
  void didChangeDependencies() {
    final Brightness newBrightness = Theme.of(context).brightness;
    if (brightness != newBrightness) {
      _createOrUpdateMapSource(newBrightness);
      brightness = newBrightness;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _timeZones.clear();
    super.dispose();
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
    return Center(
      child: Padding(
        padding: scrollEnabled
            ? EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.05,
                bottom: MediaQuery.of(context).size.height * 0.05,
                right: 10,
                left: 10,
              )
            : const EdgeInsets.only(left: 10, right: 10, bottom: 15),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 30),
              child: Align(
                child: Text(
                  'Most Popular Sports in the 30 Most Populous Countries',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
            Expanded(
              child: SfMapsTheme(
                data: const SfMapsThemeData(
                  shapeHoverColor: Colors.transparent,
                  shapeHoverStrokeColor: Colors.transparent,
                ),
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
                      strokeColor: isLightTheme
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.12),
                      // Returns the custom tooltip for each shape.
                      shapeTooltipBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _timeZones[index].countryName +
                                ' : ' +
                                _timeZones[index].game,
                            style: themeData.textTheme.bodySmall!.copyWith(
                              color: isLightTheme
                                  ? const Color.fromRGBO(255, 255, 255, 1)
                                  : const Color.fromRGBO(10, 10, 10, 1),
                            ),
                          ),
                        );
                      },
                      legend: const MapLegend(
                        MapElement.shape,
                        position: MapLegendPosition.bottom,
                        padding: EdgeInsets.only(top: 15),
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
            ),
          ],
        ),
      ),
    );
  }
}

class _CountryTimeInGMT {
  _CountryTimeInGMT(this.countryName, this.game);

  final String countryName;
  final String game;
}
