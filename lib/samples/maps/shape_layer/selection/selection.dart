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
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 3317019,
        votes: 1742718,
        percentage: 52.54,
      ),
      const _StateElectionDetails(
        state: 'Oregon',
        stateCode: 'OR',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 2001336,
        votes: 1002106,
        percentage: 50.07,
      ),
      const _StateElectionDetails(
        state: 'Alabama',
        stateCode: 'AL',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 2123372,
        votes: 1318255,
        percentage: 62.08,
      ),
      const _StateElectionDetails(
        state: 'Alaska',
        stateCode: 'AK',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 318608,
        votes: 163387,
        percentage: 51.28,
      ),
      const _StateElectionDetails(
        state: 'Arizona',
        stateCode: 'AZ',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 2604657,
        votes: 1252401,
        percentage: 48.08,
      ),
      const _StateElectionDetails(
        state: 'Arkansas',
        stateCode: 'AR',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 1130676,
        votes: 684872,
        percentage: 60.57,
      ),
      const _StateElectionDetails(
        state: 'California',
        stateCode: 'CA',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 14181595,
        votes: 8753788,
        percentage: 61.73,
      ),
      const _StateElectionDetails(
        state: 'Colorado',
        stateCode: 'CO',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 2780247,
        votes: 1338870,
        percentage: 48.16,
      ),
      const _StateElectionDetails(
        state: 'Connecticut',
        stateCode: 'CT',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 1644920,
        votes: 897572,
        percentage: 54.57,
      ),
      const _StateElectionDetails(
        state: 'Delaware',
        stateCode: 'DE',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 443814,
        votes: 235603,
        percentage: 53.09,
      ),
      const _StateElectionDetails(
        state: 'Florida',
        stateCode: 'FL',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 9420039,
        votes: 4617886,
        percentage: 49.02,
      ),
      const _StateElectionDetails(
        state: 'Georgia',
        stateCode: 'GA',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 4114732,
        votes: 2089104,
        percentage: 50.77,
      ),
      const _StateElectionDetails(
        state: 'Hawaii',
        stateCode: 'HI',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 428937,
        votes: 266891,
        percentage: 62.22,
      ),
      const _StateElectionDetails(
        state: 'Idaho',
        stateCode: 'ID',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 690255,
        votes: 409055,
        percentage: 59.26,
      ),
      const _StateElectionDetails(
        state: 'Illinois',
        stateCode: 'IL',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 5536424,
        votes: 3090729,
        percentage: 55.83,
      ),
      const _StateElectionDetails(
        state: 'Indiana',
        stateCode: 'IN',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 2734958,
        votes: 1557286,
        percentage: 56.82,
      ),
      const _StateElectionDetails(
        state: 'Lowa',
        stateCode: 'IA',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 1566031,
        votes: 800983,
        percentage: 51.15,
      ),
      const _StateElectionDetails(
        state: 'Kansas',
        stateCode: 'KS',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 1184402,
        votes: 671018,
        percentage: 56.65,
      ),
      const _StateElectionDetails(
        state: 'Kentucky',
        stateCode: 'KY',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 1924149,
        votes: 1202971,
        percentage: 62.52,
      ),
      const _StateElectionDetails(
        state: 'Louisiana',
        stateCode: 'LA',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 2029032,
        votes: 1178638,
        percentage: 58.09,
      ),
      const _StateElectionDetails(
        state: 'Maine',
        stateCode: 'ME',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 747927,
        votes: 357735,
        percentage: 47.83,
      ),
      const _StateElectionDetails(
        state: 'Maryland',
        stateCode: 'MD',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 2781446,
        votes: 1677928,
        percentage: 60.33,
      ),
      const _StateElectionDetails(
        state: 'Massachusetts',
        stateCode: 'MA',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 3325046,
        votes: 1995196,
        percentage: 60.01,
      ),
      const _StateElectionDetails(
        state: 'Michigan',
        stateCode: 'MI',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 4799284,
        votes: 2279543,
        percentage: 47.50,
      ),
      const _StateElectionDetails(
        state: 'Minnesota',
        stateCode: 'MN',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 2944813,
        votes: 1367716,
        percentage: 46.44,
      ),
      const _StateElectionDetails(
        state: 'Mississippi',
        stateCode: 'MS',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 1209357,
        votes: 700714,
        percentage: 57.86,
      ),
      const _StateElectionDetails(
        state: 'Missouri',
        stateCode: 'MO',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 2808605,
        votes: 1594511,
        percentage: 56.77,
      ),
      const _StateElectionDetails(
        state: 'Montana',
        stateCode: 'MT',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 497147,
        votes: 279240,
        percentage: 56.17,
      ),
      const _StateElectionDetails(
        state: 'Nebraska',
        stateCode: 'NE',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 844227,
        votes: 495961,
        percentage: 58.75,
      ),
      const _StateElectionDetails(
        state: 'Nevada',
        stateCode: 'NV',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 1125385,
        votes: 539260,
        percentage: 47.92,
      ),
      const _StateElectionDetails(
        state: 'New Hampshire',
        stateCode: 'NH',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 744296,
        votes: 348526,
        percentage: 46.98,
      ),
      const _StateElectionDetails(
        state: 'New Jersey',
        stateCode: 'NJ',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 3874046,
        votes: 2148278,
        percentage: 55.45,
      ),
      const _StateElectionDetails(
        state: 'New Mexico',
        stateCode: 'NM',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 798319,
        votes: 385234,
        percentage: 48.26,
      ),
      const _StateElectionDetails(
        state: 'New York',
        stateCode: 'NY',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 7721453,
        votes: 4556124,
        percentage: 59.01,
      ),
      const _StateElectionDetails(
        state: 'North Carolina',
        stateCode: 'NC',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 4741564,
        votes: 2362631,
        percentage: 49.83,
      ),
      const _StateElectionDetails(
        state: 'North Dakota',
        stateCode: 'ND',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 344360,
        votes: 216794,
        percentage: 62.96,
      ),
      const _StateElectionDetails(
        state: 'Ohio',
        stateCode: 'OH',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 5496487,
        votes: 2841005,
        percentage: 51.69,
      ),
      const _StateElectionDetails(
        state: 'Oklahoma',
        stateCode: 'OK',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 1452992,
        votes: 949136,
        percentage: 65.32,
      ),
      const _StateElectionDetails(
        state: 'Pennsylvania',
        stateCode: 'PA',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 6165478,
        votes: 2970733,
        percentage: 48.18,
      ),
      const _StateElectionDetails(
        state: 'Rhode Island',
        stateCode: 'RI',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 464144,
        votes: 252525,
        percentage: 54.41,
      ),
      const _StateElectionDetails(
        state: 'South Carolina',
        stateCode: 'SC',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 2103027,
        votes: 1155389,
        percentage: 54.94,
      ),
      const _StateElectionDetails(
        state: 'South Dakota',
        stateCode: 'SD',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 370093,
        votes: 227721,
        percentage: 61.53,
      ),
      const _StateElectionDetails(
        state: 'Tennessee',
        stateCode: 'TN',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 2508027,
        votes: 1522925,
        percentage: 60.72,
      ),
      const _StateElectionDetails(
        state: 'Texas',
        stateCode: 'TX',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 8969226,
        votes: 4685047,
        percentage: 52.23,
      ),
      const _StateElectionDetails(
        state: 'Utah',
        stateCode: 'UT',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 1131430,
        votes: 515231,
        percentage: 45.54,
      ),
      const _StateElectionDetails(
        state: 'Vermont',
        stateCode: 'VT',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 315067,
        votes: 178573,
        percentage: 56.68,
      ),
      const _StateElectionDetails(
        state: 'Virginia',
        stateCode: 'VA',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 3984631,
        votes: 1981473,
        percentage: 49.73,
      ),
      const _StateElectionDetails(
        state: 'West Virginia',
        stateCode: 'WV',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 714423,
        votes: 489371,
        percentage: 68.50,
      ),
      const _StateElectionDetails(
        state: 'Wisconsin',
        stateCode: 'WI',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 2976150,
        votes: 1405284,
        percentage: 47.22,
      ),
      const _StateElectionDetails(
        state: 'Wyoming',
        stateCode: 'WY',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 255849,
        votes: 174419,
        percentage: 68.17,
      ),
    ];

    _colorMappers = <MapColorMapper>[
      const MapColorMapper(
        from: 80,
        to: 100,
        color: Color.fromRGBO(0, 0, 81, 1.0),
        text: '{Democratic},{}',
      ),
      const MapColorMapper(
        from: 75,
        to: 80,
        color: Color.fromRGBO(0, 43, 132, 1.0),
        text: '',
      ),
      const MapColorMapper(
        from: 70,
        to: 75,
        color: Color.fromRGBO(6, 69, 180, 1.0),
        text: '',
      ),
      const MapColorMapper(
        from: 65,
        to: 70,
        color: Color.fromRGBO(22, 102, 203, 1.0),
        text: '',
      ),
      const MapColorMapper(
        from: 60,
        to: 65,
        color: Color.fromRGBO(67, 137, 227, 1.0),
        text: '',
      ),
      const MapColorMapper(
        from: 55,
        to: 60,
        color: Color.fromRGBO(80, 154, 242, 1.0),
        text: '',
      ),
      const MapColorMapper(
        from: 45,
        to: 55,
        color: Color.fromRGBO(134, 182, 242, 1.0),
        text: '',
      ),
      const MapColorMapper(
        from: -55,
        to: -45,
        color: Color.fromRGBO(255, 178, 178, 1.0),
        text: '',
      ),
      const MapColorMapper(
        from: -60,
        to: -55,
        color: Color.fromRGBO(255, 127, 127, 1.0),
        text: '',
      ),
      const MapColorMapper(
        from: -65,
        to: -60,
        color: Color.fromRGBO(255, 76, 76, 1.0),
        text: '',
      ),
      const MapColorMapper(
        from: -70,
        to: -65,
        color: Color.fromRGBO(255, 50, 50, 1.0),
        text: '',
      ),
      const MapColorMapper(
        from: -75,
        to: -70,
        color: Color.fromRGBO(178, 0, 0, 1.0),
        text: '',
      ),
      const MapColorMapper(
        from: -80,
        to: -75,
        color: Color.fromRGBO(127, 0, 0, 1.0),
        text: '',
      ),
      const MapColorMapper(
        from: -100,
        to: -80,
        color: Color.fromRGBO(102, 0, 0, 1.0),
        text: 'Republican',
      ),
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
        if (_stateWiseElectionResult[index].candidate == 'Hillary Clinton') {
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
    isDesktop =
        kIsWeb ||
        themeData.platform == TargetPlatform.macOS ||
        themeData.platform == TargetPlatform.linux ||
        themeData.platform == TargetPlatform.windows;
    return Scaffold(
      backgroundColor: model.isWebFullView
          ? model.sampleOutputCardColor
          : model.sampleOutputCardColor,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool scrollEnabled = constraints.maxHeight > 400;
          double height = scrollEnabled ? constraints.maxHeight : 400;
          if (model.isWebFullView ||
              (model.isMobile &&
                  MediaQuery.of(context).orientation ==
                      Orientation.landscape)) {
            final double refHeight = height * 0.6;
            height = height > 500
                ? (refHeight < 500 ? 500 : refHeight)
                : height;
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
        },
      ),
    );
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
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 30),
              child: Align(
                child: Text(
                  '2016 US Election Results',
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
                          : Size(
                              (size.width * 0.80) / _colorMappers.length,
                              12.0,
                            ),
                      position: MapLegendPosition.bottom,
                      padding: const EdgeInsets.only(top: 15),
                      spacing: 0.0,
                      textStyle: const TextStyle(fontSize: 10),
                    ),
                    selectionSettings: const MapSelectionSettings(
                      color: Color.fromRGBO(252, 177, 0, 1),
                      strokeColor: Colors.white,
                      strokeWidth: 2,
                    ),
                    // Passes the tapped or clicked shape index to the callback.
                    onSelectionChanged: (int index) {
                      if (index != _selectedIndex) {
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor:
                                _stateWiseElectionResult[index].party ==
                                    'Republican'
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
                                        Text(
                                          _stateWiseElectionResult[index]
                                              .state!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: GestureDetector(
                                              onTap: () {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).removeCurrentSnackBar();
                                              },
                                              child: const Icon(
                                                Icons.close,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          'Won candidate :   ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                        ),
                                        Text(
                                          _stateWiseElectionResult[index]
                                                      .party ==
                                                  'Republican'
                                              ? 'Donald Trump'
                                              : 'Hillary Clinton',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.white,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          'Percentage :         ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                        ),
                                        Text(
                                          _stateWiseElectionResult[index]
                                                  .percentage
                                                  .toString() +
                                              '%',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.white,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            duration: const Duration(seconds: 3),
                          ),
                        );
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StateElectionDetails {
  const _StateElectionDetails({
    required this.totalVoters,
    this.state,
    this.stateCode,
    this.party,
    this.candidate,
    this.votes,
    this.percentage,
  });

  final String? state;
  final String? stateCode;
  final double totalVoters;
  final String? party;
  final String? candidate;
  final double? votes;
  final double? percentage;
}
