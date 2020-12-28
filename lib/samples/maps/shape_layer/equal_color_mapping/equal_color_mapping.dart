///Flutter package imports
import 'package:flutter/material.dart';

///Map import
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
  List<_GMTModel> _gmtDetails;
  MapShapeSource _mapSource;

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
    _gmtDetails = <_GMTModel>[
      _GMTModel('Albania', 'GMT+2'),
      _GMTModel('Aland', 'GMT+3'),
      _GMTModel('Andorra', 'GMT+1'),
      _GMTModel('Austria', 'GMT+2'),
      _GMTModel('Belgium', 'GMT+2'),
      _GMTModel('Bulgaria', 'GMT+3'),
      _GMTModel('Bosnia and Herz.', 'GMT+2'),
      _GMTModel('Belarus', 'GMT+3'),
      _GMTModel('Switzerland', 'GMT+2'),
      _GMTModel('Czech Rep.', 'GMT+2'),
      _GMTModel('Germany', 'GMT+2'),
      _GMTModel('Denmark', 'GMT+2'),
      _GMTModel('Spain', 'GMT+2'),
      _GMTModel('Estonia', 'GMT+3'),
      _GMTModel('Finland', 'GMT+3'),
      _GMTModel('France', 'GMT+2'),
      _GMTModel('Faeroe Is.', 'GMT+1'),
      _GMTModel('United Kingdom', 'GMT+1'),
      _GMTModel('Guernsey', 'GMT+1'),
      _GMTModel('Greece', 'GMT+3'),
      _GMTModel('Croatia', 'GMT+2'),
      _GMTModel('Hungary', 'GMT+2'),
      _GMTModel('Isle of Man', 'GMT+1'),
      _GMTModel('Ireland', 'GMT+1'),
      _GMTModel('Iceland', 'GMT+0'),
      _GMTModel('Italy', 'GMT+2'),
      _GMTModel('Jersey', 'GMT+1'),
      _GMTModel('Kosovo', 'GMT+2'),
      _GMTModel('Liechtenstein', 'GMT+2'),
      _GMTModel('Lithuania', 'GMT+3'),
      _GMTModel('Luxembourg', 'GMT+2'),
      _GMTModel('Latvia', 'GMT+3'),
      _GMTModel('Monaco', 'GMT+2'),
      _GMTModel('Moldova', 'GMT+3'),
      _GMTModel('Macedonia', 'GMT+2'),
      _GMTModel('Malta', 'GMT+2'),
      _GMTModel('Montenegro', 'GMT+2'),
      _GMTModel('Netherlands', 'GMT+2'),
      _GMTModel('Poland', 'GMT+2'),
      _GMTModel('Portugal', 'GMT+1'),
      _GMTModel('Romania', 'GMT+3'),
      _GMTModel('San Marino', 'GMT+2'),
      _GMTModel('Serbia', 'GMT+2'),
      _GMTModel('Slovakia', 'GMT+2'),
      _GMTModel('Slovenia', 'GMT+2'),
      _GMTModel('Sweden', 'GMT+2'),
      _GMTModel('Ukraine', 'GMT+3'),
      _GMTModel('Vatican', 'GMT+1'),
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
      dataCount: _gmtDetails.length,
      primaryValueMapper: (int index) => _gmtDetails[index].countryName,
      // Used for color mapping.
      //
      // The value of the [MapColorMapper.value] will be
      // compared with the value returned in the
      // [shapeColorValueMapper]. If it is equal, the respective
      // [MapColorMapper.color] will be applied to the shape.
      shapeColorValueMapper: (int index) => _gmtDetails[index].gmtTime,
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
      shapeColorMappers: const <MapColorMapper>[
        MapColorMapper(value: 'GMT+0', color: Colors.lightBlue, text: 'GMT+0'),
        MapColorMapper(
            value: 'GMT+1', color: Colors.orangeAccent, text: 'GMT+1'),
        MapColorMapper(value: 'GMT+2', color: Colors.lightGreen, text: 'GMT+2'),
        MapColorMapper(value: 'GMT+3', color: Colors.purple, text: 'GMT+3'),
      ],
    );
  }

  @override
  void dispose() {
    _gmtDetails?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return MediaQuery.of(context).orientation == Orientation.portrait ||
            model.isWeb
        ? _getMapsWidget(themeData)
        : SingleChildScrollView(child: _getMapsWidget(themeData));
  }

  Widget _getMapsWidget(ThemeData themeData) {
    final bool isLightTheme = themeData.brightness == Brightness.light;
    return Center(
      child: Padding(
        padding: MediaQuery.of(context).orientation == Orientation.portrait ||
                model.isWeb
            ? EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.05,
                bottom: MediaQuery.of(context).size.height * 0.05,
                right: 10,
                left: 10)
            : const EdgeInsets.only(left: 10, right: 10, bottom: 15),
        child: SfMaps(
          title: const MapTitle(
            'European Time Zones',
            padding: EdgeInsets.only(top: 15, bottom: 30),
          ),
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
                    _gmtDetails[index].countryName +
                        ' : ' +
                        _gmtDetails[index].gmtTime,
                    style: themeData.textTheme.caption.copyWith(
                      color: isLightTheme
                          ? Color.fromRGBO(255, 255, 255, 1)
                          : Color.fromRGBO(10, 10, 10, 1),
                    ),
                  ),
                );
              },
              legend: const MapLegend.bar(
                MapElement.shape,
                position: MapLegendPosition.bottom,
                padding: EdgeInsets.only(top: 15),
                segmentSize: const Size(60.0, 10.0),
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
}

class _GMTModel {
  _GMTModel(this.countryName, this.gmtTime);

  final String countryName;
  final String gmtTime;
}
