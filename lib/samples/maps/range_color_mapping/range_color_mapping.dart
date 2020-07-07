import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:flutter_examples/model/sample_view.dart';
import 'package:intl/intl.dart' show NumberFormat;

class MapRangeColorMapping extends SampleView {
  const MapRangeColorMapping(Key key) : super(key: key);

  @override
  _MapRangeColorMappingState createState() => _MapRangeColorMappingState();
}

class _MapRangeColorMappingState extends SampleViewState {
  List<CountryDensityModel> _worldPopulationDensityDetails;

  // The format which is used for formatting the tooltip text.
  final NumberFormat _numberFormat = NumberFormat('#.#');

  @override
  void initState() {
    super.initState();

    // Data source to the map.
    //
    // [countryName]: Field name in the .json file to identify the shape.
    // This is the name to be mapped with shapes in .json file.
    // This should be exactly same as the value of the [shapeDataField] in the .json file
    //
    // [density]: On the basis of this value, color mapping color has been
    // applied to the shape.
    _worldPopulationDensityDetails = <CountryDensityModel>[
      CountryDensityModel('Monaco', 26337),
      CountryDensityModel('Macao', 21717),
      CountryDensityModel('Singapore', 8358),
      CountryDensityModel('Hong kong', 7140),
      CountryDensityModel('Gibraltar', 3369),
      CountryDensityModel('Bahrain', 2239),
      CountryDensityModel('Holy See', 1820),
      CountryDensityModel('Maldives', 1802),
      CountryDensityModel('Malta', 1380),
      CountryDensityModel('Bangladesh', 1265),
      CountryDensityModel('Sint Maarten', 1261),
      CountryDensityModel('Bermuda', 1246),
      CountryDensityModel('Channel Islands', 915),
      CountryDensityModel('State of Palestine', 847),
      CountryDensityModel('Saint-Martin', 729),
      CountryDensityModel('Mayotte', 727),
      CountryDensityModel('Taiwan', 672),
      CountryDensityModel('Barbados', 668),
      CountryDensityModel('Lebanon', 667),
      CountryDensityModel('Mauritius', 626),
      CountryDensityModel('Aruba', 593),
      CountryDensityModel('San Marino', 565),
      CountryDensityModel('Nauru', 541),
      CountryDensityModel('Korea', 527),
      CountryDensityModel('Rwanda', 525),
      CountryDensityModel('Netherlands', 508),
      CountryDensityModel('Comoros', 467),
      CountryDensityModel('India', 464),
      CountryDensityModel('Burundi', 463),
      CountryDensityModel('Saint-Barthélemy', 449),
      CountryDensityModel('Haiti', 413),
      CountryDensityModel('Israel', 400),
      CountryDensityModel('Tuvalu', 393),
      CountryDensityModel('Belgium', 382),
      CountryDensityModel('Curacao', 369),
      CountryDensityModel('Philippines', 367),
      CountryDensityModel('Reunion', 358),
      CountryDensityModel('Martinique', 354),
      CountryDensityModel('Japan', 346),
      CountryDensityModel('Sri Lanka', 341),
      CountryDensityModel('Grenada', 331),
      CountryDensityModel('Marshall Islands', 328),
      CountryDensityModel('Puerto Rico', 322),
      CountryDensityModel('Vietnam', 313),
      CountryDensityModel('El Salvador', 313),
      CountryDensityModel('Guam', 312),
      CountryDensityModel('Saint Lucia', 301),
      CountryDensityModel('United States Virgin Islands', 298),
      CountryDensityModel('Pakistan', 286),
      CountryDensityModel('Saint Vincent and the Grenadines', 284),
      CountryDensityModel('United Kingdom', 280),
      CountryDensityModel('American Samoa', 276),
      CountryDensityModel('Cayman Islands', 273),
      CountryDensityModel('Jamaica', 273),
      CountryDensityModel('Trinidad and Tobago', 272),
      CountryDensityModel('Qatar', 248),
      CountryDensityModel('Guadeloupe', 245),
      CountryDensityModel('Luxembourg', 241),
      CountryDensityModel('Germany', 240),
      CountryDensityModel('Kuwait', 239),
      CountryDensityModel('Gambia', 238),
      CountryDensityModel('Liechtenstein', 238),
      CountryDensityModel('Uganda', 228),
      CountryDensityModel('Sao Tome and Principe', 228),
      CountryDensityModel('Nigeria', 226),
      CountryDensityModel('Dominican Rep.', 224),
      CountryDensityModel('Antigua and Barbuda', 222),
      CountryDensityModel('Switzerland', 219),
      CountryDensityModel('Dem. Rep. Korea', 214),
      CountryDensityModel('Seychelles', 213),
      CountryDensityModel('Italy', 205),
      CountryDensityModel('Saint Kitts and Nevis', 204),
      CountryDensityModel('Nepal', 203),
      CountryDensityModel('Malawi', 202),
      CountryDensityModel('British Virgin Islands', 201),
      CountryDensityModel('Guatemala', 167),
      CountryDensityModel('Anguilla', 166),
      CountryDensityModel('Andorra', 164),
      CountryDensityModel('Micronesia', 164),
      CountryDensityModel('China', 153),
      CountryDensityModel('Togo', 152),
      CountryDensityModel('Indonesia', 151),
      CountryDensityModel('Isle of Man', 149),
      CountryDensityModel('Kiribati', 147),
      CountryDensityModel('Tonga', 146),
      CountryDensityModel('Czech Rep.', 138),
      CountryDensityModel('Cabo Verde', 138),
      CountryDensityModel('Thailand', 136),
      CountryDensityModel('Ghana', 136),
      CountryDensityModel('Denmark', 136),
      CountryDensityModel('Tokelau', 135),
      CountryDensityModel('Cyprus', 130),
      CountryDensityModel('Northern Mariana Islands', 125),
      CountryDensityModel('Poland', 123),
      CountryDensityModel('Moldova', 122),
      CountryDensityModel('Azerbaijan', 122),
      CountryDensityModel('France', 119),
      CountryDensityModel('United Arab Emirates', 118),
      CountryDensityModel('Ethiopia', 115),
      CountryDensityModel('Jordan', 114),
      CountryDensityModel('Slovakia', 113),
      CountryDensityModel('Portugal', 111),
      CountryDensityModel('Sierra Leone', 110),
      CountryDensityModel('Turkey', 109),
      CountryDensityModel('Austria', 109),
      CountryDensityModel('Benin', 107),
      CountryDensityModel('Hungary', 106),
      CountryDensityModel('Cuba', 106),
      CountryDensityModel('Albania', 105),
      CountryDensityModel('Armenia', 104),
      CountryDensityModel('Slovenia', 103),
      CountryDensityModel('Egypt', 102),
      CountryDensityModel('Serbia', 99),
      CountryDensityModel('Costa Rica', 99),
      CountryDensityModel('Malaysia', 98),
      CountryDensityModel('Dominica', 95),
      CountryDensityModel('Syria', 95),
      CountryDensityModel('Cambodia', 94),
      CountryDensityModel('Kenya', 94),
      CountryDensityModel('Spain', 93),
      CountryDensityModel('Iraq', 92),
      CountryDensityModel('Timor-Leste', 88),
      CountryDensityModel('Honduras', 88),
      CountryDensityModel('Senegal', 86),
      CountryDensityModel('Romania', 83),
      CountryDensityModel('Myanmar', 83),
      CountryDensityModel('Brunei Darussalam', 83),
      CountryDensityModel("Côte d'Ivoire", 82),
      CountryDensityModel('Morocco', 82),
      CountryDensityModel('Macedonia', 82),
      CountryDensityModel('Greece', 80),
      CountryDensityModel('Wallis and Futuna Islands', 80),
      CountryDensityModel('Bonaire, Sint Eustatius and Saba', 79),
      CountryDensityModel('Uzbekistan', 78),
      CountryDensityModel('French Polynesia', 76),
      CountryDensityModel('Burkina Faso', 76),
      CountryDensityModel('Tunisia', 76),
      CountryDensityModel('Ukraine', 75),
      CountryDensityModel('Croatia', 73),
      CountryDensityModel('Cook Islands', 73),
      CountryDensityModel('Ireland', 71),
      CountryDensityModel('Ecuador', 71),
      CountryDensityModel('Lesotho', 70),
      CountryDensityModel('Samoa', 70),
      CountryDensityModel('Guinea-Bissau', 69),
      CountryDensityModel('Tajikistan', 68),
      CountryDensityModel('Eswatini', 67),
      CountryDensityModel('Tanzania', 67),
      CountryDensityModel('Mexico', 66),
      CountryDensityModel('Bosnia and Herz.', 64),
      CountryDensityModel('Bulgaria', 64),
      CountryDensityModel('Afghanistan', 59),
      CountryDensityModel('Panama', 58),
      CountryDensityModel('Georgia', 57),
      CountryDensityModel('Yemen', 56),
      CountryDensityModel('Cameroon', 56),
      CountryDensityModel('Nicaragua', 55),
      CountryDensityModel('Guinea', 53),
      CountryDensityModel('Liberia', 52),
      CountryDensityModel('Iran', 51),
      CountryDensityModel('Eq. Guinea', 50),
      CountryDensityModel('Montserrat', 49),
      CountryDensityModel('Fiji', 49),
      CountryDensityModel('South Africa', 48),
      CountryDensityModel('Madagascar', 47),
      CountryDensityModel('Montenegro', 46),
      CountryDensityModel('Belarus', 46),
      CountryDensityModel('Colombia', 45),
      CountryDensityModel('Lithuania', 43),
      CountryDensityModel('Djibouti', 42),
      CountryDensityModel('Turks and Caicos Islands', 40),
      CountryDensityModel('Mozambique', 39),
      CountryDensityModel('Dem. Rep. Congo', 39),
      CountryDensityModel('Palau', 39),
      CountryDensityModel('Bahamas', 39),
      CountryDensityModel('Zimbabwe', 38),
      CountryDensityModel('United States of America', 36),
      CountryDensityModel('Eritrea', 35),
      CountryDensityModel('Faroe Islands', 35),
      CountryDensityModel('Kyrgyzstan', 34),
      CountryDensityModel('Venezuela', 32),
      CountryDensityModel('Lao PDR', 31),
      CountryDensityModel('Estonia', 31),
      CountryDensityModel('Latvia', 30),
      CountryDensityModel('Angola', 26),
      CountryDensityModel('Peru', 25),
      CountryDensityModel('Chile', 25),
      CountryDensityModel('Brazil', 25),
      CountryDensityModel('Somalia', 25),
      CountryDensityModel('Vanuatu', 25),
      CountryDensityModel('Saint Pierre and Miquelon', 25),
      CountryDensityModel('Sudan', 24),
      CountryDensityModel('Zambia', 24),
      CountryDensityModel('Sweden', 24),
      CountryDensityModel('Solomon Islands', 24),
      CountryDensityModel('Bhutan', 20),
      CountryDensityModel('Uruguay', 19),
      CountryDensityModel('Papua New Guinea', 19),
      CountryDensityModel('Niger', 19),
      CountryDensityModel('Algeria', 18),
      CountryDensityModel('S. Sudan', 18),
      CountryDensityModel('New Zealand', 18),
      CountryDensityModel('Finland', 18),
      CountryDensityModel('Paraguay', 17),
      CountryDensityModel('Belize', 17),
      CountryDensityModel('Mali', 16),
      CountryDensityModel('Argentina', 16),
      CountryDensityModel('Oman', 16),
      CountryDensityModel('Saudi Arabia', 16),
      CountryDensityModel('Congo', 16),
      CountryDensityModel('New Caledonia', 15),
      CountryDensityModel('Saint Helena', 15),
      CountryDensityModel('Norway', 14),
      CountryDensityModel('Chad', 13),
      CountryDensityModel('Turkmenistan', 12),
      CountryDensityModel('Bolivia', 10),
      CountryDensityModel('Russia', 8),
      CountryDensityModel('Gabon', 8),
      CountryDensityModel('Central African Rep.', 7),
      CountryDensityModel('Kazakhstan', 6),
      CountryDensityModel('Niue', 6),
      CountryDensityModel('Mauritania', 4),
      CountryDensityModel('Canada', 4),
      CountryDensityModel('Botswana', 4),
      CountryDensityModel('Guyana', 3),
      CountryDensityModel('Libya', 3),
      CountryDensityModel('Suriname', 3),
      CountryDensityModel('French Guiana', 3),
      CountryDensityModel('Iceland', 3),
      CountryDensityModel('Australia', 3),
      CountryDensityModel('Namibia', 3),
      CountryDensityModel('W. Sahara', 2),
      CountryDensityModel('Mongolia', 2),
      CountryDensityModel('Falkland Is.', 0.2),
      CountryDensityModel('Greenland', 0.1),
    ];
  }

  @override
  void dispose() {
    _worldPopulationDensityDetails?.clear();
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
                          right: 10)
                      : const EdgeInsets.only(right: 10, bottom: 15),
              child: SfMaps(
                title: const MapTitle(
                  text: 'World Population Density (per sq. km.)',
                  padding: EdgeInsets.only(top: 15, bottom: 30),
                ),
                layers: <MapLayer>[
                  MapShapeLayer(
                    delegate: MapShapeLayerDelegate(
                      // Path of the GeoJSON file.
                      shapeFile: 'assets/world_map.json',
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
                      dataCount: _worldPopulationDensityDetails.length,
                      primaryValueMapper: (int index) =>
                          _worldPopulationDensityDetails[index].countryName,
                      // Used for color mapping.
                      //
                      // The value of the [MapColorMapper.from] and [MapColorMapper.to]
                      // will be compared with the value returned in the
                      // [shapeColorValueMapper] and the respective
                      // [MapColorMapper.color] will be applied to the shape.
                      shapeColorValueMapper: (int index) =>
                          _worldPopulationDensityDetails[index].density,
                      // Returns the custom tooltip text for each shape.
                      //
                      // By default, the value returned in the [primaryValueMapper]
                      // will be used for tooltip text.
                      shapeTooltipTextMapper: (int index) =>
                          _worldPopulationDensityDetails[index].countryName +
                          ' : ' +
                          _numberFormat
                              .format(
                                  _worldPopulationDensityDetails[index].density)
                              .toString() +
                          ' per sq. km.',
                      // Group and differentiate the shapes using the color
                      // based on [MapColorMapper.from] and [MapColorMapper.to] value.
                      //
                      // The value of the [MapColorMapper.from] and [MapColorMapper.to]
                      // will be compared with the value returned in the
                      // [shapeColorValueMapper] and the respective [MapColorMapper.color]
                      // will be applied to the shape.
                      //
                      // [MapColorMapper.text] which is used for the text of
                      // legend item and [MapColorMapper.color] will be used for
                      // the color of the legend icon respectively.
                      shapeColorMappers: const <MapColorMapper>[
                        MapColorMapper(
                            from: 0,
                            to: 50,
                            color: Color.fromRGBO(128, 159, 255, 1),
                            text: '<50'),
                        MapColorMapper(
                            from: 50,
                            to: 100,
                            color: Color.fromRGBO(51, 102, 255, 1),
                            text: '50 - 100'),
                        MapColorMapper(
                            from: 100,
                            to: 250,
                            color: Color.fromRGBO(0, 57, 230, 1),
                            text: '100 - 250'),
                        MapColorMapper(
                            from: 250,
                            to: 500,
                            color: Color.fromRGBO(0, 51, 204, 1),
                            text: '250 - 500'),
                        MapColorMapper(
                            from: 500,
                            to: 1000,
                            color: Color.fromRGBO(0, 45, 179, 1),
                            text: '500 - 1k'),
                        MapColorMapper(
                            from: 1000,
                            to: 5000,
                            color: Color.fromRGBO(0, 38, 153, 1),
                            text: '1k - 5k'),
                        MapColorMapper(
                            from: 5000,
                            to: 10000,
                            color: Color.fromRGBO(0, 32, 128, 1),
                            text: '5k - 10k'),
                        MapColorMapper(
                            from: 10000,
                            to: 50000,
                            color: Color.fromRGBO(0, 26, 102, 1),
                            text: '10k - 30k'),
                      ],
                    ),
                    showLegend: true,
                    enableShapeTooltip: true,
                    strokeColor: Colors.white30,
                    legendSettings: const MapLegendSettings(
                        position: MapLegendPosition.bottom,
                        iconType: MapIconType.square,
                        overflowMode: MapLegendOverflowMode.wrap,
                        padding: EdgeInsets.only(top: 15)),
                    tooltipSettings: MapTooltipSettings(
                        color: model.themeData.brightness == Brightness.light
                            ? const Color.fromRGBO(0, 32, 128, 1)
                            : const Color.fromRGBO(226, 233, 255, 1),
                        strokeColor:
                            model.themeData.brightness == Brightness.light
                                ? Colors.white
                                : Colors.black),
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

class CountryDensityModel {
  CountryDensityModel(this.countryName, this.density);

  final String countryName;
  final double density;
}
