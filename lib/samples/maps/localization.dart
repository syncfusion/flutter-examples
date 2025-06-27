///Flutter package imports
import 'package:flutter/material.dart';

///Core theme import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

///Map import
// ignore: import_of_legacy_library_into_null_safe
import 'package:syncfusion_flutter_maps/maps.dart';

///Local import
import '../../../model/sample_view.dart';

/// Renders the map widget with range color mapping
class MapsWithLocalization extends LocalizationSampleView {
  /// Creates the map widget with range color mapping
  const MapsWithLocalization(Key key) : super(key: key);

  @override
  _MapsWithLocalizationState createState() => _MapsWithLocalizationState();
}

class _MapsWithLocalizationState extends LocalizationSampleViewState {
  late List<_Model> _australiaData;
  late List<String> _stateDataLabelsLocale;
  late MapShapeSource _mapShapeSource;
  late String _title;
  late bool _isLightTheme;
  late ThemeData _themeData;

  @override
  Widget buildSample(BuildContext context) {
    _themeData = Theme.of(context);
    _isLightTheme = _themeData.brightness == Brightness.light;
    _australiaData = <_Model>[
      const _Model(0.809, 'New South Wales'),
      const _Model(1.857, 'Queensland'),
      const _Model(1.419, 'Northern Territory'),
      const _Model(0.237, 'Victoria'),
      const _Model(1.044, 'South Australia'),
      const _Model(2.642, 'Western Australia'),
      const _Model(0.0907, 'Tasmania'),
      const _Model(0.0023, 'Australian Capital Territory'),
    ];

    _updateLabelsBasedOnLocale();

    _mapShapeSource = MapShapeSource.asset(
      'assets/australia.json',
      shapeDataField: 'STATE_NAME',
      dataCount: _australiaData.length,
      primaryValueMapper: (int index) => _australiaData[index].state,
      dataLabelMapper: (int index) => _stateDataLabelsLocale[index],
      shapeColorValueMapper: (int index) => _australiaData[index].state,
      shapeColorMappers: <MapColorMapper>[
        MapColorMapper(
          value: 'New South Wales',
          color: const Color.fromRGBO(255, 215, 0, 1.0),
          text: _stateDataLabelsLocale[0],
        ),
        MapColorMapper(
          value: 'Queensland',
          color: const Color.fromRGBO(72, 209, 204, 1.0),
          text: _stateDataLabelsLocale[1],
        ),
        MapColorMapper(
          value: 'Northern Territory',
          color: const Color.fromRGBO(255, 78, 66, 1.0),
          text: _stateDataLabelsLocale[2],
        ),
        MapColorMapper(
          value: 'Victoria',
          color: const Color.fromRGBO(171, 56, 224, 0.75),
          text: _stateDataLabelsLocale[3],
        ),
        MapColorMapper(
          value: 'South Australia',
          color: const Color.fromRGBO(126, 247, 74, 0.75),
          text: _stateDataLabelsLocale[4],
        ),
        MapColorMapper(
          value: 'Western Australia',
          color: const Color.fromRGBO(79, 60, 201, 0.7),
          text: _stateDataLabelsLocale[5],
        ),
        MapColorMapper(
          value: 'Tasmania',
          color: const Color.fromRGBO(99, 164, 230, 1),
          text: _stateDataLabelsLocale[6],
        ),
        MapColorMapper(
          value: 'Australian Capital Territory',
          color: Colors.teal,
          text: _stateDataLabelsLocale[7],
        ),
      ],
    );

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
            child: ColoredBox(
              color: model.sampleOutputCardColor,
              child: SizedBox(
                width: constraints.maxWidth,
                height: height,
                child: _buildMapsWidget(scrollEnabled),
              ),
            ),
          ),
        );
      },
    );
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
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 30),
              child: Align(
                child: Text(
                  _title,
                  textDirection: TextDirection.rtl,
                  style: _themeData.textTheme.titleMedium,
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
                  layers: <MapShapeLayer>[
                    MapShapeLayer(
                      source: _mapShapeSource,
                      strokeColor: model.homeCardColor,
                      strokeWidth: 0.5,
                      showDataLabels: true,
                      legend: const MapLegend(
                        MapElement.shape,
                        position: MapLegendPosition.bottom,
                        iconType: MapIconType.diamond,
                      ),
                      dataLabelSettings: const MapDataLabelSettings(
                        overflowMode: MapLabelOverflow.ellipsis,
                      ),
                      tooltipSettings: MapTooltipSettings(
                        color: _isLightTheme
                            ? const Color.fromRGBO(45, 45, 45, 1)
                            : const Color.fromRGBO(242, 242, 242, 1),
                      ),
                      shapeTooltipBuilder: (BuildContext context, int index) {
                        final Color textColor = _isLightTheme
                            ? const Color.fromRGBO(255, 255, 255, 1)
                            : const Color.fromRGBO(10, 10, 10, 1);
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
                              child: IntrinsicWidth(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _stateDataLabelsLocale[index],
                                      textDirection: TextDirection.ltr,
                                      style: _themeData.textTheme.bodySmall!
                                          .copyWith(color: textColor),
                                    ),
                                    const SizedBox(height: 5.0),
                                    Text(
                                      _australiaData[index].areaInMillionSqKm
                                              .toString() +
                                          'M sq. km',
                                      textDirection: TextDirection.ltr,
                                      style: _themeData.textTheme.bodySmall!
                                          .copyWith(color: textColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
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

  void _updateLabelsBasedOnLocale() {
    if (model.locale == const Locale('en', 'US')) {
      _stateDataLabelsLocale = const <String>[
        'New South Wales',
        'Queensland',
        'Northern Territory',
        'Victoria',
        'South Australia',
        'Western Australia',
        'Tasmania',
        'Australian Capital Territory',
      ];
      _title = 'Australia - Land Area (sq. Km)';
    }
    //Arabic.
    else if (model.locale == const Locale('ar', 'AE')) {
      _stateDataLabelsLocale = const <String>[
        'نيو ساوث ويلز',
        'كوينزلاند',
        'الإقليم الشمالي',
        'فيكتوريا',
        'جنوب استراليا',
        'القسم الغربي من استراليا',
        'تسمانيا',
        'إقليم العاصمة الأسترالية',
      ];
      _title = '(كيلومتر مربع) - مساحة الأرض أستراليا';
    }
    //French.
    else if (model.locale == const Locale('fr', 'FR')) {
      _stateDataLabelsLocale = const <String>[
        'Nouvelle Galles du Sud',
        'Queensland',
        'Territoire du Nord',
        'Victoria',
        'Le sud de lAustralie',
        'Australie occidentale',
        'Tasmanie',
        'Territoire de la capitale australienne',
      ];
      _title = 'Australie - Superficie terrestre (km²)';
    }
    //Chinese.
    else if (model.locale == const Locale('zh', 'CN')) {
      _stateDataLabelsLocale = const <String>[
        '新南威尔士州',
        '昆士兰',
        '北方领土',
        '维多利亚',
        '南澳大利亚',
        '澳大利亚西部',
        '塔斯马尼亚',
        '澳大利亚首都领地',
      ];
      _title = '澳大利亚 - 土地面积（平方公里）';
    }
    //Spanish.
    else {
      _stateDataLabelsLocale = const <String>[
        'Nueva Gales del Sur',
        'Queensland',
        'Territorio del Norte',
        'Victoria',
        'Sur de Australia',
        'El oeste de Australia',
        'Tasmania',
        'Territorio de la Capital Australiana',
      ];
      _title = 'Australia - Superficie terrestre (kilómetros cuadrados)';
    }
  }
}

class _Model {
  const _Model(this.areaInMillionSqKm, this.state);
  final String state;
  final double areaInMillionSqKm;
}
