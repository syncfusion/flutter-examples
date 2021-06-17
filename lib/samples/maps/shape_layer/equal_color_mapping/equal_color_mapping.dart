///Flutter package imports
import 'package:flutter/material.dart';

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
      _CountryTimeInGMT('Albania', 'GMT+2'),
      _CountryTimeInGMT('Aland', 'GMT+3'),
      _CountryTimeInGMT('Andorra', 'GMT+1'),
      _CountryTimeInGMT('Austria', 'GMT+2'),
      _CountryTimeInGMT('Belgium', 'GMT+2'),
      _CountryTimeInGMT('Bulgaria', 'GMT+3'),
      _CountryTimeInGMT('Bosnia and Herz.', 'GMT+2'),
      _CountryTimeInGMT('Belarus', 'GMT+3'),
      _CountryTimeInGMT('Switzerland', 'GMT+2'),
      _CountryTimeInGMT('Czech Rep.', 'GMT+2'),
      _CountryTimeInGMT('Germany', 'GMT+2'),
      _CountryTimeInGMT('Denmark', 'GMT+2'),
      _CountryTimeInGMT('Spain', 'GMT+2'),
      _CountryTimeInGMT('Estonia', 'GMT+3'),
      _CountryTimeInGMT('Finland', 'GMT+3'),
      _CountryTimeInGMT('France', 'GMT+2'),
      _CountryTimeInGMT('Faeroe Is.', 'GMT+1'),
      _CountryTimeInGMT('United Kingdom', 'GMT+1'),
      _CountryTimeInGMT('Guernsey', 'GMT+1'),
      _CountryTimeInGMT('Greece', 'GMT+3'),
      _CountryTimeInGMT('Croatia', 'GMT+2'),
      _CountryTimeInGMT('Hungary', 'GMT+2'),
      _CountryTimeInGMT('Isle of Man', 'GMT+1'),
      _CountryTimeInGMT('Ireland', 'GMT+1'),
      _CountryTimeInGMT('Iceland', 'GMT+0'),
      _CountryTimeInGMT('Italy', 'GMT+2'),
      _CountryTimeInGMT('Jersey', 'GMT+1'),
      _CountryTimeInGMT('Kosovo', 'GMT+2'),
      _CountryTimeInGMT('Liechtenstein', 'GMT+2'),
      _CountryTimeInGMT('Lithuania', 'GMT+3'),
      _CountryTimeInGMT('Luxembourg', 'GMT+2'),
      _CountryTimeInGMT('Latvia', 'GMT+3'),
      _CountryTimeInGMT('Monaco', 'GMT+2'),
      _CountryTimeInGMT('Moldova', 'GMT+3'),
      _CountryTimeInGMT('Macedonia', 'GMT+2'),
      _CountryTimeInGMT('Malta', 'GMT+2'),
      _CountryTimeInGMT('Montenegro', 'GMT+2'),
      _CountryTimeInGMT('Netherlands', 'GMT+2'),
      _CountryTimeInGMT('Poland', 'GMT+2'),
      _CountryTimeInGMT('Portugal', 'GMT+1'),
      _CountryTimeInGMT('Romania', 'GMT+3'),
      _CountryTimeInGMT('San Marino', 'GMT+2'),
      _CountryTimeInGMT('Serbia', 'GMT+2'),
      _CountryTimeInGMT('Slovakia', 'GMT+2'),
      _CountryTimeInGMT('Slovenia', 'GMT+2'),
      _CountryTimeInGMT('Sweden', 'GMT+2'),
      _CountryTimeInGMT('Ukraine', 'GMT+3'),
      _CountryTimeInGMT('Vatican', 'GMT+1'),
    ];

    _mapSource = MapShapeSource.asset(
      // Path of the GeoJSON file.
      'assets/europe.json',
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
      shapeColorValueMapper: (int index) => _timeZones[index].gmtTime,
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
        const MapColorMapper(
            value: 'GMT+0', color: Colors.lightBlue, text: 'GMT+0'),
        const MapColorMapper(
            value: 'GMT+1', color: Colors.orangeAccent, text: 'GMT+1'),
        const MapColorMapper(
            value: 'GMT+2', color: Colors.lightGreen, text: 'GMT+2'),
        const MapColorMapper(
            value: 'GMT+3', color: Colors.purple, text: 'GMT+3'),
      ],
    );
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
    });
  }

  Widget _buildMapsWidget(ThemeData themeData, bool scrollEnabled) {
    final bool isLightTheme = themeData.brightness == Brightness.light;
    return Center(
        child: Padding(
      padding: scrollEnabled
          ? EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.05,
              bottom: MediaQuery.of(context).size.height * 0.05,
              right: 10,
              left: 10)
          : const EdgeInsets.only(left: 10, right: 10, bottom: 15),
      child: Column(children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 30),
            child: Align(
                alignment: Alignment.center,
                child: Text('European Time Zones',
                    style: Theme.of(context).textTheme.subtitle1))),
        Expanded(
            child: SfMaps(
          layers: <MapLayer>[
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
              strokeColor: isLightTheme
                  ? Colors.white
                  : const Color.fromRGBO(224, 224, 224, 0.5),
              // Returns the custom tooltip for each shape.
              shapeTooltipBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _timeZones[index].countryName +
                        ' : ' +
                        _timeZones[index].gmtTime,
                    style: themeData.textTheme.caption!.copyWith(
                      color: isLightTheme
                          ? const Color.fromRGBO(255, 255, 255, 1)
                          : const Color.fromRGBO(10, 10, 10, 1),
                    ),
                  ),
                );
              },
              legend: const MapLegend.bar(
                MapElement.shape,
                position: MapLegendPosition.bottom,
                padding: EdgeInsets.only(top: 15),
                segmentSize: Size(60.0, 10.0),
              ),
              tooltipSettings: MapTooltipSettings(
                color: isLightTheme
                    ? const Color.fromRGBO(45, 45, 45, 1)
                    : const Color.fromRGBO(242, 242, 242, 1),
              ),
            ),
          ],
        )),
      ]),
    ));
  }
}

class _CountryTimeInGMT {
  _CountryTimeInGMT(this.countryName, this.gmtTime);

  final String countryName;
  final String gmtTime;
}
