///Flutter package imports
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' show NumberFormat;

///Core theme import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

///Map import
// ignore: import_of_legacy_library_into_null_safe
import 'package:syncfusion_flutter_maps/maps.dart';

///Local import
import '../../../../model/sample_view.dart';

/// Renders the map widget with range color mapping
class MapRangeColorMappingPage extends SampleView {
  /// Creates the map widget with range color mapping
  const MapRangeColorMappingPage(Key key) : super(key: key);

  @override
  _MapRangeColorMappingPageState createState() =>
      _MapRangeColorMappingPageState();
}

class _MapRangeColorMappingPageState extends SampleViewState {
  late List<_CountryDensity> _worldPopulationDensity;

  // The format which is used for formatting the tooltip text.
  final NumberFormat _numberFormat = NumberFormat('#.#');

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
    // [density]: On the basis of this value, color mapping color has been
    // applied to the shape.
    _worldPopulationDensity = <_CountryDensity>[
      _CountryDensity('Monaco', 26337),
      _CountryDensity('Macao', 21717),
      _CountryDensity('Singapore', 8358),
      _CountryDensity('Hong kong', 7140),
      _CountryDensity('Gibraltar', 3369),
      _CountryDensity('Bahrain', 2239),
      _CountryDensity('Holy See', 1820),
      _CountryDensity('Maldives', 1802),
      _CountryDensity('Malta', 1380),
      _CountryDensity('Bangladesh', 1265),
      _CountryDensity('Sint Maarten', 1261),
      _CountryDensity('Bermuda', 1246),
      _CountryDensity('Channel Islands', 915),
      _CountryDensity('State of Palestine', 847),
      _CountryDensity('Saint-Martin', 729),
      _CountryDensity('Mayotte', 727),
      _CountryDensity('Taiwan', 672),
      _CountryDensity('Barbados', 668),
      _CountryDensity('Lebanon', 667),
      _CountryDensity('Mauritius', 626),
      _CountryDensity('Aruba', 593),
      _CountryDensity('San Marino', 565),
      _CountryDensity('Nauru', 541),
      _CountryDensity('Korea', 527),
      _CountryDensity('Rwanda', 525),
      _CountryDensity('Netherlands', 508),
      _CountryDensity('Comoros', 467),
      _CountryDensity('India', 464),
      _CountryDensity('Burundi', 463),
      _CountryDensity('Saint-Barthélemy', 449),
      _CountryDensity('Haiti', 413),
      _CountryDensity('Israel', 400),
      _CountryDensity('Tuvalu', 393),
      _CountryDensity('Belgium', 382),
      _CountryDensity('Curacao', 369),
      _CountryDensity('Philippines', 367),
      _CountryDensity('Reunion', 358),
      _CountryDensity('Martinique', 354),
      _CountryDensity('Japan', 346),
      _CountryDensity('Sri Lanka', 341),
      _CountryDensity('Grenada', 331),
      _CountryDensity('Marshall Islands', 328),
      _CountryDensity('Puerto Rico', 322),
      _CountryDensity('Vietnam', 313),
      _CountryDensity('El Salvador', 313),
      _CountryDensity('Guam', 312),
      _CountryDensity('Saint Lucia', 301),
      _CountryDensity('United States Virgin Islands', 298),
      _CountryDensity('Pakistan', 286),
      _CountryDensity('Saint Vincent and the Grenadines', 284),
      _CountryDensity('United Kingdom', 280),
      _CountryDensity('American Samoa', 276),
      _CountryDensity('Cayman Islands', 273),
      _CountryDensity('Jamaica', 273),
      _CountryDensity('Trinidad and Tobago', 272),
      _CountryDensity('Qatar', 248),
      _CountryDensity('Guadeloupe', 245),
      _CountryDensity('Luxembourg', 241),
      _CountryDensity('Germany', 240),
      _CountryDensity('Kuwait', 239),
      _CountryDensity('Gambia', 238),
      _CountryDensity('Liechtenstein', 238),
      _CountryDensity('Uganda', 228),
      _CountryDensity('Sao Tome and Principe', 228),
      _CountryDensity('Nigeria', 226),
      _CountryDensity('Dominican Rep.', 224),
      _CountryDensity('Antigua and Barbuda', 222),
      _CountryDensity('Switzerland', 219),
      _CountryDensity('Dem. Rep. Korea', 214),
      _CountryDensity('Seychelles', 213),
      _CountryDensity('Italy', 205),
      _CountryDensity('Saint Kitts and Nevis', 204),
      _CountryDensity('Nepal', 203),
      _CountryDensity('Malawi', 202),
      _CountryDensity('British Virgin Islands', 201),
      _CountryDensity('Guatemala', 167),
      _CountryDensity('Anguilla', 166),
      _CountryDensity('Andorra', 164),
      _CountryDensity('Micronesia', 164),
      _CountryDensity('China', 153),
      _CountryDensity('Togo', 152),
      _CountryDensity('Indonesia', 151),
      _CountryDensity('Isle of Man', 149),
      _CountryDensity('Kiribati', 147),
      _CountryDensity('Tonga', 146),
      _CountryDensity('Czech Rep.', 138),
      _CountryDensity('Cabo Verde', 138),
      _CountryDensity('Thailand', 136),
      _CountryDensity('Ghana', 136),
      _CountryDensity('Denmark', 136),
      _CountryDensity('Tokelau', 135),
      _CountryDensity('Cyprus', 130),
      _CountryDensity('Northern Mariana Islands', 125),
      _CountryDensity('Poland', 123),
      _CountryDensity('Moldova', 122),
      _CountryDensity('Azerbaijan', 122),
      _CountryDensity('France', 119),
      _CountryDensity('United Arab Emirates', 118),
      _CountryDensity('Ethiopia', 115),
      _CountryDensity('Jordan', 114),
      _CountryDensity('Slovakia', 113),
      _CountryDensity('Portugal', 111),
      _CountryDensity('Sierra Leone', 110),
      _CountryDensity('Turkey', 109),
      _CountryDensity('Austria', 109),
      _CountryDensity('Benin', 107),
      _CountryDensity('Hungary', 106),
      _CountryDensity('Cuba', 106),
      _CountryDensity('Albania', 105),
      _CountryDensity('Armenia', 104),
      _CountryDensity('Slovenia', 103),
      _CountryDensity('Egypt', 102),
      _CountryDensity('Serbia', 99),
      _CountryDensity('Costa Rica', 99),
      _CountryDensity('Malaysia', 98),
      _CountryDensity('Dominica', 95),
      _CountryDensity('Syria', 95),
      _CountryDensity('Cambodia', 94),
      _CountryDensity('Kenya', 94),
      _CountryDensity('Spain', 93),
      _CountryDensity('Iraq', 92),
      _CountryDensity('Timor-Leste', 88),
      _CountryDensity('Honduras', 88),
      _CountryDensity('Senegal', 86),
      _CountryDensity('Romania', 83),
      _CountryDensity('Myanmar', 83),
      _CountryDensity('Brunei Darussalam', 83),
      _CountryDensity("Côte d'Ivoire", 82),
      _CountryDensity('Morocco', 82),
      _CountryDensity('Macedonia', 82),
      _CountryDensity('Greece', 80),
      _CountryDensity('Wallis and Futuna Islands', 80),
      _CountryDensity('Bonaire, Sint Eustatius and Saba', 79),
      _CountryDensity('Uzbekistan', 78),
      _CountryDensity('French Polynesia', 76),
      _CountryDensity('Burkina Faso', 76),
      _CountryDensity('Tunisia', 76),
      _CountryDensity('Ukraine', 75),
      _CountryDensity('Croatia', 73),
      _CountryDensity('Cook Islands', 73),
      _CountryDensity('Ireland', 71),
      _CountryDensity('Ecuador', 71),
      _CountryDensity('Lesotho', 70),
      _CountryDensity('Samoa', 70),
      _CountryDensity('Guinea-Bissau', 69),
      _CountryDensity('Tajikistan', 68),
      _CountryDensity('Eswatini', 67),
      _CountryDensity('Tanzania', 67),
      _CountryDensity('Mexico', 66),
      _CountryDensity('Bosnia and Herz.', 64),
      _CountryDensity('Bulgaria', 64),
      _CountryDensity('Afghanistan', 59),
      _CountryDensity('Panama', 58),
      _CountryDensity('Georgia', 57),
      _CountryDensity('Yemen', 56),
      _CountryDensity('Cameroon', 56),
      _CountryDensity('Nicaragua', 55),
      _CountryDensity('Guinea', 53),
      _CountryDensity('Liberia', 52),
      _CountryDensity('Iran', 51),
      _CountryDensity('Eq. Guinea', 50),
      _CountryDensity('Montserrat', 49),
      _CountryDensity('Fiji', 49),
      _CountryDensity('South Africa', 48),
      _CountryDensity('Madagascar', 47),
      _CountryDensity('Montenegro', 46),
      _CountryDensity('Belarus', 46),
      _CountryDensity('Colombia', 45),
      _CountryDensity('Lithuania', 43),
      _CountryDensity('Djibouti', 42),
      _CountryDensity('Turks and Caicos Islands', 40),
      _CountryDensity('Mozambique', 39),
      _CountryDensity('Dem. Rep. Congo', 39),
      _CountryDensity('Palau', 39),
      _CountryDensity('Bahamas', 39),
      _CountryDensity('Zimbabwe', 38),
      _CountryDensity('United States of America', 36),
      _CountryDensity('Eritrea', 35),
      _CountryDensity('Faroe Islands', 35),
      _CountryDensity('Kyrgyzstan', 34),
      _CountryDensity('Venezuela', 32),
      _CountryDensity('Lao PDR', 31),
      _CountryDensity('Estonia', 31),
      _CountryDensity('Latvia', 30),
      _CountryDensity('Angola', 26),
      _CountryDensity('Peru', 25),
      _CountryDensity('Chile', 25),
      _CountryDensity('Brazil', 25),
      _CountryDensity('Somalia', 25),
      _CountryDensity('Vanuatu', 25),
      _CountryDensity('Saint Pierre and Miquelon', 25),
      _CountryDensity('Sudan', 24),
      _CountryDensity('Zambia', 24),
      _CountryDensity('Sweden', 24),
      _CountryDensity('Solomon Islands', 24),
      _CountryDensity('Bhutan', 20),
      _CountryDensity('Uruguay', 19),
      _CountryDensity('Papua New Guinea', 19),
      _CountryDensity('Niger', 19),
      _CountryDensity('Algeria', 18),
      _CountryDensity('S. Sudan', 18),
      _CountryDensity('New Zealand', 18),
      _CountryDensity('Finland', 18),
      _CountryDensity('Paraguay', 17),
      _CountryDensity('Belize', 17),
      _CountryDensity('Mali', 16),
      _CountryDensity('Argentina', 16),
      _CountryDensity('Oman', 16),
      _CountryDensity('Saudi Arabia', 16),
      _CountryDensity('Congo', 16),
      _CountryDensity('New Caledonia', 15),
      _CountryDensity('Saint Helena', 15),
      _CountryDensity('Norway', 14),
      _CountryDensity('Chad', 13),
      _CountryDensity('Turkmenistan', 12),
      _CountryDensity('Bolivia', 10),
      _CountryDensity('Russia', 8),
      _CountryDensity('Gabon', 8),
      _CountryDensity('Central African Rep.', 7),
      _CountryDensity('Kazakhstan', 6),
      _CountryDensity('Niue', 6),
      _CountryDensity('Mauritania', 4),
      _CountryDensity('Canada', 4),
      _CountryDensity('Botswana', 4),
      _CountryDensity('Guyana', 3),
      _CountryDensity('Libya', 3),
      _CountryDensity('Suriname', 3),
      _CountryDensity('French Guiana', 3),
      _CountryDensity('Iceland', 3),
      _CountryDensity('Australia', 3),
      _CountryDensity('Namibia', 3),
      _CountryDensity('W. Sahara', 2),
      _CountryDensity('Mongolia', 2),
      _CountryDensity('Falkland Is.', 0.2),
      _CountryDensity('Greenland', 0.1),
    ];

    _mapSource = MapShapeSource.asset(
      // Path of the GeoJSON file.
      'assets/world_map.json',
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
      dataCount: _worldPopulationDensity.length,
      primaryValueMapper: (int index) =>
          _worldPopulationDensity[index].countryName,
      // Used for color mapping.
      //
      // The value of the [MapColorMapper.from]
      // and [MapColorMapper.to]
      // will be compared with the value returned in the
      // [shapeColorValueMapper] and the respective
      // [MapColorMapper.color] will be applied to the shape.
      shapeColorValueMapper: (int index) =>
          _worldPopulationDensity[index].density,
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
          to: 100,
          color: Color.fromRGBO(128, 159, 255, 1),
          text: '{0},{100}',
        ),
        const MapColorMapper(
          from: 100,
          to: 500,
          color: Color.fromRGBO(51, 102, 255, 1),
          text: '500',
        ),
        const MapColorMapper(
          from: 500,
          to: 1000,
          color: Color.fromRGBO(0, 57, 230, 1),
          text: '1k',
        ),
        const MapColorMapper(
          from: 1000,
          to: 5000,
          color: Color.fromRGBO(0, 45, 179, 1),
          text: '5k',
        ),
        const MapColorMapper(
          from: 5000,
          to: 50000,
          color: Color.fromRGBO(0, 26, 102, 1),
          text: '50k',
        ),
      ],
    );
  }

  @override
  void dispose() {
    _worldPopulationDensity.clear();
    super.dispose();
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
          data: const SfMapsThemeData(
            shapeHoverColor: Color.fromRGBO(176, 237, 131, 1),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 30),
                child: Align(
                  child: Text(
                    'World Population Density (per sq. km.)',
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
                      // Returns the custom tooltip for each shape.
                      shapeTooltipBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _worldPopulationDensity[index].countryName +
                                ' : ' +
                                _numberFormat.format(
                                  _worldPopulationDensity[index].density,
                                ) +
                                ' per sq. km.',
                            style: Theme.of(context).textTheme.bodySmall!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                          ),
                        );
                      },
                      strokeColor: Colors.white30,
                      legend: const MapLegend.bar(
                        MapElement.shape,
                        position: MapLegendPosition.bottom,
                        overflowMode: MapLegendOverflowMode.wrap,
                        labelsPlacement: MapLegendLabelsPlacement.betweenItems,
                        padding: EdgeInsets.only(top: 15),
                        spacing: 1.0,
                        segmentSize: Size(55.0, 9.0),
                      ),
                      tooltipSettings: MapTooltipSettings(
                        color:
                            model.themeData.colorScheme.brightness ==
                                Brightness.light
                            ? const Color.fromRGBO(0, 32, 128, 1)
                            : const Color.fromRGBO(226, 233, 255, 1),
                        strokeColor:
                            model.themeData.colorScheme.brightness ==
                                Brightness.light
                            ? Colors.white
                            : Colors.black,
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

class _CountryDensity {
  _CountryDensity(this.countryName, this.density);

  final String countryName;
  final double density;
}
