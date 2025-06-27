///Flutter package imports
import 'package:flutter/material.dart';

///Core theme import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

///Map import
// ignore: import_of_legacy_library_into_null_safe
import 'package:syncfusion_flutter_maps/maps.dart';

///Local import
import '../../model/sample_view.dart';

/// Renders the map widget with range color mapping
class MapsWithDirectionality extends DirectionalitySampleView {
  /// Creates the map widget with range color mapping
  const MapsWithDirectionality(Key key) : super(key: key);

  @override
  _MapsWithDirectionalityState createState() => _MapsWithDirectionalityState();
}

class _MapsWithDirectionalityState extends DirectionalitySampleViewState {
  late List<_StatesGRP> _stateWiseGRPDetails;
  late String _title;
  late bool _isLightTheme;
  late MapShapeSource _mapSource;

  @override
  void initState() {
    super.initState();

    // Data source to the map.
    //
    // [state]: Field name in the .json file to identify the shape.
    // This is the name to be mapped with shapes in .json file.
    // This should be exactly same as the value of the [shapeDataField]
    // in the .json file
    //
    // [grp]: On the basis of this value, color mapping color has been
    // applied to the shape.
    _stateWiseGRPDetails = <_StatesGRP>[
      _StatesGRP('Baden-Wuerttemberg', 500.790, 'بادن فورتمبيرغ'),
      _StatesGRP('Bavaria', 610.220, 'بافاريا'),
      _StatesGRP('Berlin', 154.630, 'برلين'),
      _StatesGRP('Brandenburg', 73.930, 'براندنبورغ'),
      _StatesGRP('Bremen', 31.580, 'بريمن'),
      _StatesGRP('Hamburg', 118.130, 'هامبورغ'),
      _StatesGRP('Hesse', 281.420, 'هيس'),
      _StatesGRP('Mecklenburg-Vorpommern', 46.010, 'مكلنبورغ فوربومرن'),
      _StatesGRP('Lower Saxony', 295.900, 'ساكسونيا السفلى'),
      _StatesGRP('North Rhine-Westphalia', 697.130, 'شمال الراين وستفاليا'),
      _StatesGRP('Rhineland-Palatinate', 141.900, 'راينلاند بالاتينات'),
      _StatesGRP('Saarland', 33.610, 'سارلاند'),
      _StatesGRP('Saxony', 125.570, 'ساكسونيا'),
      _StatesGRP('Saxony-Anhalt', 62.650, 'ساكسونيا أنهالت'),
      _StatesGRP('Schleswig-Holstein', 97.220, 'شليسفيغ هولشتاين'),
      _StatesGRP('Thuringia', 61.540, 'تورينجيا'),
    ];

    _mapSource = MapShapeSource.asset(
      // Path of the GeoJSON file.
      'assets/germany.json',
      // Field or group name in the .json file
      // to identify the shapes.
      //
      // Which is used to map the respective
      // shape to data source.
      //
      // On the basis of this value,
      // shape tooltip text is rendered.
      shapeDataField: 'name',
      // The number of data in your data source collection.
      //
      // The callback for the [primaryValueMapper]
      // will be called the number of times equal
      // to the [dataCount].
      // The value returned in the [primaryValueMapper]
      // should be exactly matched with the value of the
      // [shapeDataField] in the .json file. This is how
      // the mapping between the data source and the shapes
      // in the .json file is done.
      dataCount: _stateWiseGRPDetails.length,
      primaryValueMapper: (int index) => _stateWiseGRPDetails[index].state,
      // Used for color mapping.
      //
      // The value of the [MapColorMapper.from]
      // and [MapColorMapper.to]
      // will be compared with the value returned in the
      // [shapeColorValueMapper] and the respective
      // [MapColorMapper.color] will be applied to the shape.
      shapeColorValueMapper: (int index) => _stateWiseGRPDetails[index].grp,
      // Group and differentiate the shapes using the color
      // based on [MapColorMapper.from] and
      //[MapColorMapper.to] value.
      //
      // The value of the [MapColorMapper.from] and
      // [MapColorMapper.to] will be compared with the value
      // returned in the [shapeColorValueMapper] and
      // the respective [MapColorMapper.color] will be applied
      // to the shape.
      //
      // [MapColorMapper.text] which is used for the text of
      // legend item and [MapColorMapper.color] will be used for
      // the color of the legend icon respectively.
      shapeColorMappers: <MapColorMapper>[
        const MapColorMapper(
          from: 0,
          to: 50,
          color: Color.fromRGBO(173, 60, 44, 1),
          text: '{0},{50}',
        ),
        const MapColorMapper(
          from: 50,
          to: 100,
          color: Color.fromRGBO(182, 87, 0, 1),
          text: '100',
        ),
        const MapColorMapper(
          from: 100,
          to: 150,
          color: Color.fromRGBO(220, 121, 5, 1),
          text: '150',
        ),
        const MapColorMapper(
          from: 150,
          to: 300,
          color: Color.fromRGBO(221, 146, 0, 1),
          text: '300',
        ),
        const MapColorMapper(
          from: 300,
          to: 700,
          color: Color.fromRGBO(250, 189, 32, 1),
          text: '700',
        ),
      ],
    );
  }

  @override
  void dispose() {
    _stateWiseGRPDetails.clear();
    super.dispose();
  }

  late ThemeData _themeData;

  @override
  Widget buildSample(BuildContext context) {
    _themeData = Theme.of(context);
    _updateTitleBasedOnLocale();
    _isLightTheme = _themeData.colorScheme.brightness == Brightness.light;
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

  void _updateTitleBasedOnLocale() {
    if (model.locale == const Locale('ar', 'AE')) {
      _title = '2020 - تفاصيل GRP الحكيمة الدولة ألمانيا';
    } else {
      _title = 'Germany state wise GRP details - 2020';
    }
  }

  Widget _buildMapsWidget(bool scrollEnabled) {
    return Center(
      child: Padding(
        padding: scrollEnabled
            ? EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.05,
                bottom: MediaQuery.of(context).size.height * 0.05,
                right: 10,
              )
            : const EdgeInsets.only(right: 10, bottom: 15),
        child: SfMapsTheme(
          data: const SfMapsThemeData(),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 30),
                child: Align(
                  child: Text(
                    _title,
                    textDirection: TextDirection.rtl,
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
                      strokeColor: model.homeCardColor,
                      strokeWidth: 0.5,
                      // Returns the custom tooltip for each shape.
                      shapeTooltipBuilder: (BuildContext context, int index) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                10.0,
                                7.0,
                                10.0,
                                8.5,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      text:
                                          model.locale ==
                                              const Locale('ar', 'AE')
                                          ? _stateWiseGRPDetails[index]
                                                .stateLocale
                                          : _stateWiseGRPDetails[index].state,
                                      style: _themeData.textTheme.bodySmall!
                                          .copyWith(
                                            height: 1.5,
                                            color: _isLightTheme
                                                ? const Color.fromRGBO(
                                                    255,
                                                    255,
                                                    255,
                                                    1,
                                                  )
                                                : const Color.fromRGBO(
                                                    10,
                                                    10,
                                                    10,
                                                    1,
                                                  ),
                                          ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text:
                                              '\n€' +
                                              _stateWiseGRPDetails[index].grp
                                                  .toStringAsFixed(2) +
                                              'B',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                      legend: const MapLegend.bar(
                        MapElement.shape,
                        position: MapLegendPosition.bottom,
                        showPointerOnHover: true,
                        overflowMode: MapLegendOverflowMode.wrap,
                        labelsPlacement: MapLegendLabelsPlacement.betweenItems,
                        padding: EdgeInsets.only(top: 15),
                        spacing: 1.0,
                        segmentSize: Size(55.0, 9.0),
                      ),
                      tooltipSettings: MapTooltipSettings(
                        color: _isLightTheme
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
      ),
    );
  }
}

class _StatesGRP {
  _StatesGRP(this.state, this.grp, this.stateLocale);

  final String state;
  final String stateLocale;
  final double grp;
}
