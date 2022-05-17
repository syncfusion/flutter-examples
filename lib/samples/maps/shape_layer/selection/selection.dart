/// Flutter package imports
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// Map import
import 'package:syncfusion_flutter_maps/maps.dart';

/// Local import
import '../../../../model/sample_view.dart';

/// Renders the map widget with range color mapping
class MapSelectionPage extends SampleView {
  /// Creates the map widget with range color mapping
  const MapSelectionPage(Key key) : super(key: key);

  @override
  _MapSelectionPageState createState() => _MapSelectionPageState();
}

class _MapSelectionPageState extends SampleViewState {
  late List<_StateElectionDetails> _stateWiseElectionResult;
  late List<MapColorMapper> _colorMappers;
  late MapShapeSource _selectionMapSource;
  late bool isDesktop;
  int _selectedIndex = -1;

  @override
  void initState() {
    // Data source to the map.
    //
    // [primaryKey]: Field name in the .json file to identify the shape.
    // This is the name to be mapped with shapes in .json file.
    // This should be exactly same as the value of the
    // [shapeDataField] in the .json file
    //
    // [wonBy]: On the basis of this value, color mapping color has been
    // applied to the shape.
    _stateWiseElectionResult = <_StateElectionDetails>[
      const _StateElectionDetails(
          state: 'Washington',
          stateCode: 'DC',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 4087631,
          votes: 2369612,
          percentage: 57.97),
      const _StateElectionDetails(
          state: 'Oregon',
          stateCode: 'OR',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 2374321,
          votes: 1340383,
          percentage: 56.45),
      const _StateElectionDetails(
          state: 'Alabama',
          stateCode: 'AL',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 2323282,
          votes: 1441170,
          percentage: 62.03),
      const _StateElectionDetails(
          state: 'Alaska',
          stateCode: 'AK',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 359530,
          votes: 189951,
          percentage: 52.83),
      const _StateElectionDetails(
          state: 'Arizona',
          stateCode: 'AZ',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 3387326,
          votes: 1672143,
          percentage: 49.36),
      const _StateElectionDetails(
          state: 'Arkansas',
          stateCode: 'AR',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 1219069,
          votes: 760647,
          percentage: 62.40),
      const _StateElectionDetails(
          state: 'California',
          stateCode: 'CA',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 17500881,
          votes: 11110250,
          percentage: 63.48),
      const _StateElectionDetails(
          state: 'Colorado',
          stateCode: 'CO',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 3256980,
          votes: 1804352,
          percentage: 55.40),
      const _StateElectionDetails(
          state: 'Connecticut',
          stateCode: 'CT',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 1823857,
          votes: 1080831,
          percentage: 59.26),
      const _StateElectionDetails(
          state: 'Delaware',
          stateCode: 'DE',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 504346,
          votes: 296268,
          percentage: 58.74),
      const _StateElectionDetails(
          state: 'Florida',
          stateCode: 'FL',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 11067456,
          votes: 5668731,
          percentage: 51.22),
      const _StateElectionDetails(
          state: 'Georgia',
          stateCode: 'GA',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 4999960,
          votes: 2473633,
          percentage: 49.47),
      const _StateElectionDetails(
          state: 'Hawaii',
          stateCode: 'HI',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 574469,
          votes: 366130,
          percentage: 63.73),
      const _StateElectionDetails(
          state: 'Idaho',
          stateCode: 'ID',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 868014,
          votes: 554119,
          percentage: 63.84),
      const _StateElectionDetails(
          state: 'Illinois',
          stateCode: 'IL',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 6033744,
          votes: 3471915,
          percentage: 57.54),
      const _StateElectionDetails(
          state: 'Indiana',
          stateCode: 'IN',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 3033121,
          votes: 1729519,
          percentage: 57.02),
      const _StateElectionDetails(
          state: 'Lowa',
          stateCode: 'IA',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 1690871,
          votes: 897672,
          percentage: 53.09),
      const _StateElectionDetails(
          state: 'Kansas',
          stateCode: 'KS',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 1372303,
          votes: 771406,
          percentage: 56.21),
      const _StateElectionDetails(
          state: 'Kentucky',
          stateCode: 'KY',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 2136768,
          votes: 1326646,
          percentage: 62.09),
      const _StateElectionDetails(
          state: 'Louisiana',
          stateCode: 'LA',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 2148062,
          votes: 1255776,
          percentage: 58.46),
      const _StateElectionDetails(
          state: 'Maine',
          stateCode: 'ME',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 443112,
          votes: 266376,
          percentage: 60.11),
      const _StateElectionDetails(
          state: 'Maryland',
          stateCode: 'MD',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 3037030,
          votes: 1985023,
          percentage: 65.36),
      const _StateElectionDetails(
          state: 'Massachusetts',
          stateCode: 'MA',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 3631402,
          votes: 2382202,
          percentage: 65.60),
      const _StateElectionDetails(
          state: 'Michigan',
          stateCode: 'MI',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 5539302,
          votes: 2804040,
          percentage: 50.62),
      const _StateElectionDetails(
          state: 'Minnesota',
          stateCode: 'MN',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 3277171,
          votes: 1717077,
          percentage: 52.40),
      const _StateElectionDetails(
          state: 'Mississippi',
          stateCode: 'MS',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 1313759,
          votes: 756764,
          percentage: 57.60),
      const _StateElectionDetails(
          state: 'Missouri',
          stateCode: 'MO',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 3025962,
          votes: 1718736,
          percentage: 56.80),
      const _StateElectionDetails(
          state: 'Montana',
          stateCode: 'MT',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 603674,
          votes: 343602,
          percentage: 56.92),
      const _StateElectionDetails(
          state: 'Nebraska',
          stateCode: 'NE',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 321886,
          votes: 180290,
          percentage: 56.01),
      const _StateElectionDetails(
          state: 'Nevada',
          stateCode: 'NV',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 1405376,
          votes: 703486,
          percentage: 50.06),
      const _StateElectionDetails(
          state: 'New Hampshire',
          stateCode: 'NH',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 806205,
          votes: 424937,
          percentage: 52.71),
      const _StateElectionDetails(
          state: 'New Jersey',
          stateCode: 'NJ',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 4549353,
          votes: 2608335,
          percentage: 57.33),
      const _StateElectionDetails(
          state: 'New Mexico',
          stateCode: 'NM',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 923965,
          votes: 501614,
          percentage: 54.29),
      const _StateElectionDetails(
          state: 'New York',
          stateCode: 'NY',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 8594826,
          votes: 5230985,
          percentage: 60.86),
      const _StateElectionDetails(
          state: 'North Carolina',
          stateCode: 'NC',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 5524804,
          votes: 2758775,
          percentage: 49.93),
      const _StateElectionDetails(
          state: 'North Dakota',
          stateCode: 'ND',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 361819,
          votes: 235595,
          percentage: 65.11),
      const _StateElectionDetails(
          state: 'Ohio',
          stateCode: 'OH',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 5922202,
          votes: 3154834,
          percentage: 53.27),
      const _StateElectionDetails(
          state: 'Oklahoma',
          stateCode: 'OK',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 1560699,
          votes: 1020280,
          percentage: 65.37),
      const _StateElectionDetails(
          state: 'Pennsylvania',
          stateCode: 'PA',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 6915283,
          votes: 3458229,
          percentage: 50.01),
      const _StateElectionDetails(
          state: 'Rhode Island',
          stateCode: 'RI',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 517757,
          votes: 307486,
          percentage: 59.39),
      const _StateElectionDetails(
          state: 'South Carolina',
          stateCode: 'SC',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 2513329,
          votes: 1385103,
          percentage: 55.11),
      const _StateElectionDetails(
          state: 'South Dakota',
          stateCode: 'SD',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 422609,
          votes: 261043,
          percentage: 61.77),
      const _StateElectionDetails(
          state: 'Tennessee',
          stateCode: 'TN',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 3053851,
          votes: 1852475,
          percentage: 60.66),
      const _StateElectionDetails(
          state: 'Texas',
          stateCode: 'TX',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 11315056,
          votes: 5890347,
          percentage: 52.06),
      const _StateElectionDetails(
          state: 'Utah',
          stateCode: 'UT',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 1488289,
          votes: 865140,
          percentage: 58.13),
      const _StateElectionDetails(
          state: 'Vermont',
          stateCode: 'VT',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 367428,
          votes: 242820,
          percentage: 66.09),
      const _StateElectionDetails(
          state: 'Virginia',
          stateCode: 'VA',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 4460524,
          votes: 2413568,
          percentage: 54.11),
      const _StateElectionDetails(
          state: 'West Virginia',
          stateCode: 'WV',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 794731,
          votes: 235984,
          percentage: 68.62),
      const _StateElectionDetails(
          state: 'Wisconsin',
          stateCode: 'WI',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 3298041,
          votes: 1610184,
          percentage: 49.45),
      const _StateElectionDetails(
          state: 'Wyoming',
          stateCode: 'WY',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 276765,
          votes: 193559,
          percentage: 69.94),
    ];

    _colorMappers = <MapColorMapper>[
      const MapColorMapper(
          from: 80,
          to: 100,
          color: Color.fromRGBO(0, 0, 81, 1.0),
          text: '{Democratic},{}'),
      const MapColorMapper(
          from: 75, to: 80, color: Color.fromRGBO(0, 43, 132, 1.0), text: ''),
      const MapColorMapper(
          from: 70, to: 75, color: Color.fromRGBO(6, 69, 180, 1.0), text: ''),
      const MapColorMapper(
          from: 65, to: 70, color: Color.fromRGBO(22, 102, 203, 1.0), text: ''),
      const MapColorMapper(
          from: 60, to: 65, color: Color.fromRGBO(67, 137, 227, 1.0), text: ''),
      const MapColorMapper(
          from: 55, to: 60, color: Color.fromRGBO(80, 154, 242, 1.0), text: ''),
      const MapColorMapper(
          from: 45,
          to: 55,
          color: Color.fromRGBO(134, 182, 242, 1.0),
          text: ''),
      const MapColorMapper(
          from: -55,
          to: -45,
          color: Color.fromRGBO(255, 178, 178, 1.0),
          text: ''),
      const MapColorMapper(
          from: -60,
          to: -55,
          color: Color.fromRGBO(255, 127, 127, 1.0),
          text: ''),
      const MapColorMapper(
          from: -65,
          to: -60,
          color: Color.fromRGBO(255, 76, 76, 1.0),
          text: ''),
      const MapColorMapper(
          from: -70,
          to: -65,
          color: Color.fromRGBO(255, 50, 50, 1.0),
          text: ''),
      const MapColorMapper(
          from: -75, to: -70, color: Color.fromRGBO(178, 0, 0, 1.0), text: ''),
      const MapColorMapper(
          from: -80, to: -75, color: Color.fromRGBO(127, 0, 0, 1.0), text: ''),
      const MapColorMapper(
          from: -100,
          to: -80,
          color: Color.fromRGBO(102, 0, 0, 1.0),
          text: 'Republican'),
    ];

    _selectionMapSource = MapShapeSource.asset(
      // Path of the GeoJSON file.
      'assets/usa.json',
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
      dataCount: _stateWiseElectionResult.length,
      primaryValueMapper: (int index) => _stateWiseElectionResult[index].state!,
      // Used for color mapping.
      //
      // The value of the [MapColorMapper.value] will be compared with the value
      // returned in the [shapeColorValueMapper]. If it is equal, the respective
      // [MapColorMapper.color] will be applied to the shape.
      shapeColorValueMapper: (int index) {
        if (_stateWiseElectionResult[index].candidate == 'Joe Biden') {
          return _stateWiseElectionResult[index].percentage;
        } else {
          return -_stateWiseElectionResult[index].percentage!;
        }
      },
      // Group and differentiate the shapes using the color
      // based on [MapColorMapper.value] value.
      //
      // The value of the [MapColorMapper.value]
      // will be compared with the value returned in the
      // [shapeColorValueMapper] and the respective [MapColorMapper.color]
      // will be applied to the shape.
      shapeColorMappers: _colorMappers,
      dataLabelMapper: (int index) =>
          _stateWiseElectionResult[index].stateCode!,
    );
    super.initState();
  }

  @override
  void dispose() {
    _stateWiseElectionResult.clear();
    _colorMappers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    isDesktop = kIsWeb ||
        themeData.platform == TargetPlatform.macOS ||
        themeData.platform == TargetPlatform.linux ||
        themeData.platform == TargetPlatform.windows;
    return Scaffold(
        backgroundColor:
            model.isWebFullView ? model.cardThemeColor : model.cardThemeColor,
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          final bool scrollEnabled = constraints.maxHeight > 400;
          double height = scrollEnabled ? constraints.maxHeight : 400;
          if (model.isWebFullView ||
              (model.isMobile &&
                  MediaQuery.of(context).orientation ==
                      Orientation.landscape)) {
            final double refHeight = height * 0.6;
            height =
                height > 500 ? (refHeight < 500 ? 500 : refHeight) : height;
          }

          final Size size = Size(constraints.maxWidth, height);
          return Center(
            child: SingleChildScrollView(
              child: SizedBox(
                width: constraints.maxWidth,
                height: height,
                child: _buildMapsWidget(scrollEnabled, size, themeData),
              ),
            ),
          );
        }));
  }

  Widget _buildMapsWidget(bool scrollEnabled, Size size, ThemeData themeData) {
    return Center(
        child: Padding(
      padding: scrollEnabled
          ? EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.05,
              bottom: MediaQuery.of(context).size.height * 0.05,
              right: 10,
            )
          : const EdgeInsets.only(right: 10, bottom: 15),
      child: Column(children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 30),
            child: Align(
                child: Text('2020 US Election Results',
                    style: Theme.of(context).textTheme.subtitle1))),
        Expanded(
            child: SfMaps(
          layers: <MapLayer>[
            MapShapeLayer(
              loadingBuilder: (BuildContext context) {
                return const SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                  ),
                );
              },
              source: _selectionMapSource,
              showDataLabels: true,
              dataLabelSettings: const MapDataLabelSettings(
                overflowMode: MapLabelOverflow.hide,
                textStyle: TextStyle(color: Colors.black, fontSize: 9),
              ),
              // Selection will not work if [MapShapeLayerDelegate.dataCount]
              // is null or empty.
              selectedIndex: _selectedIndex,
              strokeColor: Colors.white30,
              legend: MapLegend.bar(
                MapElement.shape,
                segmentSize: isDesktop
                    ? const Size(25, 12)
                    : Size((size.width * 0.80) / _colorMappers.length, 12.0),
                position: MapLegendPosition.bottom,
                padding: const EdgeInsets.only(top: 15),
                spacing: 0.0,
                textStyle: const TextStyle(fontSize: 10),
              ),
              selectionSettings: const MapSelectionSettings(
                  color: Color.fromRGBO(252, 177, 0, 1),
                  strokeColor: Colors.white,
                  strokeWidth: 2),
              // Passes the tapped or clicked shape index to the callback.
              onSelectionChanged: (int index) {
                if (index != _selectedIndex) {
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor:
                        _stateWiseElectionResult[index].party == 'Republican'
                            ? Colors.red
                            : Colors.blue,
                    content: Container(
                      height: 100,
                      padding: const EdgeInsets.only(top: 8),
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(_stateWiseElectionResult[index].state!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                Expanded(
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          ScaffoldMessenger.of(context)
                                              .removeCurrentSnackBar();
                                        },
                                        child: const Icon(Icons.close,
                                            color: Colors.white),
                                      )),
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: <Widget>[
                                Text('Won candidate :   ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                Text(
                                    _stateWiseElectionResult[index].party ==
                                            'Republican'
                                        ? 'Donald Trump'
                                        : 'Joe Biden',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(
                                            fontStyle: FontStyle.italic,
                                            color: Colors.white))
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: <Widget>[
                                Text('Percentage :         ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                Text(
                                    _stateWiseElectionResult[index]
                                            .percentage
                                            .toString() +
                                        '%',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(
                                            fontStyle: FontStyle.italic,
                                            color: Colors.white))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    duration: const Duration(seconds: 3),
                  ));
                }
                // Tapped or clicked shape UI won't change until the parent widget
                // rebuilds the maps widget with the new selected [index].
                //
                // Passing -1 to the [MapShapeLayer.selectedIndex] for unselecting
                // the previous selected shape.
                setState(() {
                  _selectedIndex = (index == _selectedIndex) ? -1 : index;
                });
              },
            ),
          ],
        )),
      ]),
    ));
  }
}

class _StateElectionDetails {
  const _StateElectionDetails(
      {required this.totalVoters,
      this.state,
      this.stateCode,
      this.party,
      this.candidate,
      this.votes,
      this.percentage});

  final String? state;
  final String? stateCode;
  final double totalVoters;
  final String? party;
  final String? candidate;
  final double? votes;
  final double? percentage;
}
