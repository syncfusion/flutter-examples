import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:flutter_examples/model/sample_view.dart';

class MapEqualColorMapping extends SampleView {
  const MapEqualColorMapping(Key key) : super(key: key);

  @override
  _MapEqualColorMappingState createState() => _MapEqualColorMappingState();
}

class _MapEqualColorMappingState extends SampleViewState {
  List<GMTModel> _gmtDetails;

  @override
  void initState() {
    super.initState();

    // Data source to the map.
    //
    // [countryName]: Field name in the .json file to identify the shape.
    // This is the name to be mapped with shapes in .json file.
    // This should be exactly same as the value of the [shapeDataField] in the .json file
    //
    // [gmtTime]: On the basis of this value, color mapping color has been
    // applied to the shape.
    _gmtDetails = <GMTModel>[
      GMTModel('Albania', 'GMT+2'),
      GMTModel('Aland', 'GMT+3'),
      GMTModel('Andorra', 'GMT+1'),
      GMTModel('Austria', 'GMT+2'),
      GMTModel('Belgium', 'GMT+2'),
      GMTModel('Bulgaria', 'GMT+3'),
      GMTModel('Bosnia and Herz.', 'GMT+2'),
      GMTModel('Belarus', 'GMT+3'),
      GMTModel('Switzerland', 'GMT+2'),
      GMTModel('Czech Rep.', 'GMT+2'),
      GMTModel('Germany', 'GMT+2'),
      GMTModel('Denmark', 'GMT+2'),
      GMTModel('Spain', 'GMT+2'),
      GMTModel('Estonia', 'GMT+3'),
      GMTModel('Finland', 'GMT+3'),
      GMTModel('France', 'GMT+2'),
      GMTModel('Faeroe Is.', 'GMT+1'),
      GMTModel('United Kingdom', 'GMT+1'),
      GMTModel('Guernsey', 'GMT+1'),
      GMTModel('Greece', 'GMT+3'),
      GMTModel('Croatia', 'GMT+2'),
      GMTModel('Hungary', 'GMT+2'),
      GMTModel('Isle of Man', 'GMT+1'),
      GMTModel('Ireland', 'GMT+1'),
      GMTModel('Iceland', 'GMT+0'),
      GMTModel('Italy', 'GMT+2'),
      GMTModel('Jersey', 'GMT+1'),
      GMTModel('Kosovo', 'GMT+2'),
      GMTModel('Liechtenstein', 'GMT+2'),
      GMTModel('Lithuania', 'GMT+3'),
      GMTModel('Luxembourg', 'GMT+2'),
      GMTModel('Latvia', 'GMT+3'),
      GMTModel('Monaco', 'GMT+2'),
      GMTModel('Moldova', 'GMT+3'),
      GMTModel('Macedonia', 'GMT+2'),
      GMTModel('Malta', 'GMT+2'),
      GMTModel('Montenegro', 'GMT+2'),
      GMTModel('Netherlands', 'GMT+2'),
      GMTModel('Poland', 'GMT+2'),
      GMTModel('Portugal', 'GMT+1'),
      GMTModel('Romania', 'GMT+3'),
      GMTModel('San Marino', 'GMT+2'),
      GMTModel('Serbia', 'GMT+2'),
      GMTModel('Slovakia', 'GMT+2'),
      GMTModel('Slovenia', 'GMT+2'),
      GMTModel('Sweden', 'GMT+2'),
      GMTModel('Ukraine', 'GMT+3'),
      GMTModel('Vatican', 'GMT+1'),
    ];
  }

  @override
  void dispose() {
    _gmtDetails?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait ||
            model.isWeb
        ? _getMapsWidget()
        : SingleChildScrollView(child: _getMapsWidget());
  }

  Widget _getMapsWidget() {
    return FutureBuilder<dynamic>(
      future: Future<dynamic>.delayed(
          const Duration(milliseconds: kIsWeb ? 0 : 500), () => 'Loaded'),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Center(
            child: Padding(
              padding:
                  MediaQuery.of(context).orientation == Orientation.portrait ||
                          model.isWeb
                      ? EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.05,
                          bottom: MediaQuery.of(context).size.height * 0.05,
                          right: 10,
                          left: 10)
                      : const EdgeInsets.only(left: 10, right: 10, bottom: 15),
              child: SfMaps(
                title: const MapTitle(
                  text: 'European Time Zones',
                  padding: EdgeInsets.only(top: 15, bottom: 30),
                ),
                layers: <MapLayer>[
                  MapShapeLayer(
                    delegate: MapShapeLayerDelegate(
                      // Path of the GeoJSON file.
                      shapeFile: 'assets/europe.json',
                      // Field or group name in the .json file to identify the shapes.
                      //
                      // Which is used to map the respective shape to data source.
                      //
                      // On the basis of this value, shape tooltip text is rendered.
                      shapeDataField: 'name',
                      // The number of data in your data source collection.
                      //
                      // The callback for the [primaryValueMapper] will be called
                      // the number of times equal to the [dataCount].
                      // The value returned in the [primaryValueMapper] should be
                      // exactly matched with the value of the [shapeDataField]
                      // in the .json file. This is how the mapping between the
                      // data source and the shapes in the .json file is done.
                      dataCount: _gmtDetails.length,
                      primaryValueMapper: (int index) =>
                          _gmtDetails[index].countryName,
                      // Used for color mapping.
                      //
                      // The value of the [MapColorMapper.value] will be compared
                      // with the value returned in the [shapeColorValueMapper].
                      // If it is equal, the respective [MapColorMapper.color]
                      // will be applied to the shape.
                      shapeColorValueMapper: (int index) =>
                          _gmtDetails[index].gmtTime,
                      // Returns the custom tooltip text for each shape.
                      //
                      // By default, the value returned in the [primaryValueMapper]
                      // will be used for tooltip text.
                      shapeTooltipTextMapper: (int index) =>
                          _gmtDetails[index].countryName +
                          ' : ' +
                          _gmtDetails[index].gmtTime,
                      // Group and differentiate the shapes using the color
                      // based on [MapColorMapper.value] value.
                      //
                      // The value of the [MapColorMapper.value]
                      // will be compared with the value returned in the
                      // [shapeColorValueMapper] and the respective [MapColorMapper.color]
                      // will be applied to the shape.
                      //
                      // [MapColorMapper.text] which is used for the text of
                      // legend item and [MapColorMapper.color] will be used for
                      // the color of the legend icon respectively.
                      shapeColorMappers: const <MapColorMapper>[
                        MapColorMapper(
                            value: 'GMT+0',
                            color: Colors.lightBlue,
                            text: 'GMT+0'),
                        MapColorMapper(
                            value: 'GMT+1',
                            color: Colors.orangeAccent,
                            text: 'GMT+1'),
                        MapColorMapper(
                            value: 'GMT+2',
                            color: Colors.lightGreen,
                            text: 'GMT+2'),
                        MapColorMapper(
                            value: 'GMT+3',
                            color: Colors.purple,
                            text: 'GMT+3'),
                      ],
                    ),
                    showLegend: true,
                    strokeColor: model.themeData.brightness == Brightness.light
                        ? Colors.white
                        : const Color.fromRGBO(224, 224, 224, 0.5),
                    enableShapeTooltip: true,
                    legendSettings: const MapLegendSettings(
                        position: MapLegendPosition.bottom,
                        padding: EdgeInsets.only(top: 15)),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: Container(
              height: 25,
              width: 25,
              child: const CircularProgressIndicator(
                strokeWidth: 3,
              ),
            ),
          );
        }
      },
    );
  }
}

class GMTModel {
  GMTModel(this.countryName, this.gmtTime);

  final String countryName;
  final String gmtTime;
}
