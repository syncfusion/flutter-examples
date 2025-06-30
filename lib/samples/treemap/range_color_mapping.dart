import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// Treemap import.
import 'package:syncfusion_flutter_treemap/treemap.dart';

/// Local import.
import '../../../model/sample_view.dart';

/// This sample demonstrates how to apply color to a tile based on the range
/// of values.
class TreemapRangeColorMappingSample extends SampleView {
  /// Creates [TreemapRangeColorMappingSample].
  const TreemapRangeColorMappingSample(Key key) : super(key: key);

  @override
  _TreemapRangeColorMappingSampleState createState() =>
      _TreemapRangeColorMappingSampleState();
}

class _TreemapRangeColorMappingSampleState extends SampleViewState {
  late List<_StateElectionDetails> _stateWiseElectionResult;
  late List<TreemapColorMapper> _colorMappers;
  late bool _isLightTheme;
  late bool isDesktop;

  @override
  void initState() {
    // Data source to the treemap.
    //
    // [totalVoters] is used to get each tile's weight.
    // [state] is the flat level grouping key.
    _stateWiseElectionResult = <_StateElectionDetails>[
      const _StateElectionDetails(
        state: 'Washington',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 3317019,
        votes: 1742718,
        percentage: 52.54,
      ),
      const _StateElectionDetails(
        state: 'Oregon',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 2001336,
        votes: 1002106,
        percentage: 50.07,
      ),
      const _StateElectionDetails(
        state: 'Alabama',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 2123372,
        votes: 1318255,
        percentage: 62.08,
      ),
      const _StateElectionDetails(
        state: 'Alaska',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 318608,
        votes: 163387,
        percentage: 51.28,
      ),
      const _StateElectionDetails(
        state: 'Arizona',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 2604657,
        votes: 1252401,
        percentage: 48.08,
      ),
      const _StateElectionDetails(
        state: 'Arkansas',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 1130676,
        votes: 684872,
        percentage: 60.57,
      ),
      const _StateElectionDetails(
        state: 'California',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 14181595,
        votes: 8753788,
        percentage: 61.73,
      ),
      const _StateElectionDetails(
        state: 'Colorado',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 2780247,
        votes: 1338870,
        percentage: 48.16,
      ),
      const _StateElectionDetails(
        state: 'Connecticut',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 1644920,
        votes: 897572,
        percentage: 54.57,
      ),
      const _StateElectionDetails(
        state: 'Delaware',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 443814,
        votes: 235603,
        percentage: 53.09,
      ),
      const _StateElectionDetails(
        state: 'Florida',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 9420039,
        votes: 4617886,
        percentage: 49.02,
      ),
      const _StateElectionDetails(
        state: 'Georgia',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 4114732,
        votes: 2089104,
        percentage: 50.77,
      ),
      const _StateElectionDetails(
        state: 'Hawaii',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 428937,
        votes: 266891,
        percentage: 62.22,
      ),
      const _StateElectionDetails(
        state: 'Idaho',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 690255,
        votes: 409055,
        percentage: 59.26,
      ),
      const _StateElectionDetails(
        state: 'Illinois',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 5536424,
        votes: 3090729,
        percentage: 55.83,
      ),
      const _StateElectionDetails(
        state: 'Indiana',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 2734958,
        votes: 1557286,
        percentage: 56.82,
      ),
      const _StateElectionDetails(
        state: 'Lowa',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 1566031,
        votes: 800983,
        percentage: 51.15,
      ),
      const _StateElectionDetails(
        state: 'Kansas',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 1184402,
        votes: 671018,
        percentage: 56.65,
      ),
      const _StateElectionDetails(
        state: 'Kentucky',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 1924149,
        votes: 1202971,
        percentage: 62.52,
      ),
      const _StateElectionDetails(
        state: 'Louisiana',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 2029032,
        votes: 1178638,
        percentage: 58.09,
      ),
      const _StateElectionDetails(
        state: 'Maine',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 747927,
        votes: 357735,
        percentage: 47.83,
      ),
      const _StateElectionDetails(
        state: 'Maryland',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 2781446,
        votes: 1677928,
        percentage: 60.33,
      ),
      const _StateElectionDetails(
        state: 'Massachusetts',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 3325046,
        votes: 1995196,
        percentage: 60.01,
      ),
      const _StateElectionDetails(
        state: 'Michigan',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 4799284,
        votes: 2279543,
        percentage: 47.50,
      ),
      const _StateElectionDetails(
        state: 'Minnesota',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 2944813,
        votes: 1367716,
        percentage: 46.44,
      ),
      const _StateElectionDetails(
        state: 'Mississippi',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 1209357,
        votes: 700714,
        percentage: 57.86,
      ),
      const _StateElectionDetails(
        state: 'Missouri',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 2808605,
        votes: 1594511,
        percentage: 56.77,
      ),
      const _StateElectionDetails(
        state: 'Montana',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 497147,
        votes: 279240,
        percentage: 56.17,
      ),
      const _StateElectionDetails(
        state: 'Nebraska',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 844227,
        votes: 495961,
        percentage: 58.75,
      ),
      const _StateElectionDetails(
        state: 'Nevada',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 1125385,
        votes: 539260,
        percentage: 47.92,
      ),
      const _StateElectionDetails(
        state: 'New Hampshire',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 744296,
        votes: 348526,
        percentage: 46.98,
      ),
      const _StateElectionDetails(
        state: 'New Jersey',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 3874046,
        votes: 2148278,
        percentage: 55.45,
      ),
      const _StateElectionDetails(
        state: 'New Mexico',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 798319,
        votes: 385234,
        percentage: 48.26,
      ),
      const _StateElectionDetails(
        state: 'New York',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 7721453,
        votes: 4556124,
        percentage: 59.01,
      ),
      const _StateElectionDetails(
        state: 'North Carolina',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 4741564,
        votes: 2362631,
        percentage: 49.83,
      ),
      const _StateElectionDetails(
        state: 'North Dakota',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 344360,
        votes: 216794,
        percentage: 62.96,
      ),
      const _StateElectionDetails(
        state: 'Ohio',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 5496487,
        votes: 2841005,
        percentage: 51.69,
      ),
      const _StateElectionDetails(
        state: 'Oklahoma',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 1452992,
        votes: 949136,
        percentage: 65.32,
      ),
      const _StateElectionDetails(
        state: 'Pennsylvania',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 6165478,
        votes: 2970733,
        percentage: 48.18,
      ),
      const _StateElectionDetails(
        state: 'Rhode Island',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 464144,
        votes: 252525,
        percentage: 54.41,
      ),
      const _StateElectionDetails(
        state: 'South Carolina',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 2103027,
        votes: 1155389,
        percentage: 54.94,
      ),
      const _StateElectionDetails(
        state: 'South Dakota',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 370093,
        votes: 227721,
        percentage: 61.53,
      ),
      const _StateElectionDetails(
        state: 'Tennessee',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 2508027,
        votes: 1522925,
        percentage: 60.72,
      ),
      const _StateElectionDetails(
        state: 'Texas',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 8969226,
        votes: 4685047,
        percentage: 52.23,
      ),
      const _StateElectionDetails(
        state: 'Utah',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 1131430,
        votes: 515231,
        percentage: 45.54,
      ),
      const _StateElectionDetails(
        state: 'Vermont',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 315067,
        votes: 178573,
        percentage: 56.68,
      ),
      const _StateElectionDetails(
        state: 'Virginia',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 3984631,
        votes: 1981473,
        percentage: 49.73,
      ),
      const _StateElectionDetails(
        state: 'West Virginia',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 714423,
        votes: 489371,
        percentage: 68.50,
      ),
      const _StateElectionDetails(
        state: 'Wisconsin',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 2976150,
        votes: 1405284,
        percentage: 47.22,
      ),
      const _StateElectionDetails(
        state: 'Wyoming',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 255849,
        votes: 174419,
        percentage: 68.17,
      ),
    ];

    _colorMappers = <TreemapColorMapper>[
      const TreemapColorMapper.range(
        from: 80,
        to: 100,
        color: Color.fromRGBO(0, 0, 81, 1.0),
        name: '{Democratic},{}',
      ),
      const TreemapColorMapper.range(
        from: 75,
        to: 80,
        color: Color.fromRGBO(0, 43, 132, 1.0),
        name: '',
      ),
      const TreemapColorMapper.range(
        from: 70,
        to: 75,
        color: Color.fromRGBO(6, 69, 180, 1.0),
        name: '',
      ),
      const TreemapColorMapper.range(
        from: 65,
        to: 70,
        color: Color.fromRGBO(22, 102, 203, 1.0),
        name: '',
      ),
      const TreemapColorMapper.range(
        from: 60,
        to: 65,
        color: Color.fromRGBO(67, 137, 227, 1.0),
        name: '',
      ),
      const TreemapColorMapper.range(
        from: 55,
        to: 60,
        color: Color.fromRGBO(80, 154, 242, 1.0),
        name: '',
      ),
      const TreemapColorMapper.range(
        from: 45,
        to: 55,
        color: Color.fromRGBO(134, 182, 242, 1.0),
        name: '',
      ),
      const TreemapColorMapper.range(
        from: -55,
        to: -45,
        color: Color.fromRGBO(255, 178, 178, 1.0),
        name: '',
      ),
      const TreemapColorMapper.range(
        from: -60,
        to: -55,
        color: Color.fromRGBO(255, 127, 127, 1.0),
        name: '',
      ),
      const TreemapColorMapper.range(
        from: -65,
        to: -60,
        color: Color.fromRGBO(255, 76, 76, 1.0),
        name: '',
      ),
      const TreemapColorMapper.range(
        from: -70,
        to: -65,
        color: Color.fromRGBO(255, 50, 50, 1.0),
        name: '',
      ),
      const TreemapColorMapper.range(
        from: -75,
        to: -70,
        color: Color.fromRGBO(178, 0, 0, 1.0),
        name: '',
      ),
      const TreemapColorMapper.range(
        from: -80,
        to: -75,
        color: Color.fromRGBO(127, 0, 0, 1.0),
        name: '',
      ),
      const TreemapColorMapper.range(
        from: -100,
        to: -80,
        color: Color.fromRGBO(102, 0, 0, 1.0),
        name: 'Republican',
      ),
    ];

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
    _isLightTheme = themeData.colorScheme.brightness == Brightness.light;
    isDesktop =
        kIsWeb ||
        themeData.platform == TargetPlatform.macOS ||
        themeData.platform == TargetPlatform.linux ||
        themeData.platform == TargetPlatform.windows;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Size size = Size(constraints.maxWidth, constraints.maxHeight);
        return Center(
          child: Padding(
            padding:
                MediaQuery.of(context).orientation == Orientation.portrait ||
                    isDesktop
                ? const EdgeInsets.all(12.5)
                : const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Text(
                  '2016 US Election Results',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SfTreemap(
                      // The number of data in your data source collection.
                      //
                      // The callback for the [weightValueMapper] and
                      // [TreemapLevel.groupMapper] will be called
                      // the number of times equal to the [dataCount].
                      dataCount: _stateWiseElectionResult.length,
                      // The value returned in the callback will specify the
                      // weight of each tile.
                      weightValueMapper: (int index) {
                        return _stateWiseElectionResult[index].totalVoters;
                      },
                      tooltipSettings: TreemapTooltipSettings(
                        color: _isLightTheme
                            ? const Color.fromRGBO(45, 45, 45, 1)
                            : const Color.fromRGBO(242, 242, 242, 1),
                      ),
                      colorMappers: _colorMappers,
                      levels: _getTreemapLevels(themeData),
                      legend: TreemapLegend.bar(
                        segmentSize: isDesktop
                            ? const Size(25, 12)
                            : Size(
                                (size.width * 0.80) / _colorMappers.length,
                                12.0,
                              ),
                        spacing: 0.0,
                        textStyle: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<TreemapLevel> _getTreemapLevels(ThemeData themeData) {
    return <TreemapLevel>[
      TreemapLevel(
        color: Colors.red,
        // Used for grouping the tiles based on the value returned from
        // this callback.
        //
        // Once grouped, we will get [labelBuilder], [tooltipBuilder], and
        // [colorValueMapper] callbacks respectively.
        groupMapper: (int index) => _stateWiseElectionResult[index].state,
        // The value returned in the callback will specify the
        // color of each tile.
        colorValueMapper: (TreemapTile tile) {
          if (_stateWiseElectionResult[tile.indices[0]].candidate ==
              'Hillary Clinton') {
            return _stateWiseElectionResult[tile.indices[0]].percentage;
          } else {
            return -_stateWiseElectionResult[tile.indices[0]].percentage!;
          }
        },
        // Returns a widget for each tile's data label.
        labelBuilder: (BuildContext context, TreemapTile tile) {
          final Brightness brightness = ThemeData.estimateBrightnessForColor(
            tile.color,
          );
          final Color color = brightness == Brightness.dark
              ? Colors.white
              : Colors.black;
          return Padding(
            padding: const EdgeInsets.only(left: 4.0, top: 4.0),
            child: Text(
              tile.group,
              style: themeData.textTheme.bodySmall!.copyWith(
                fontSize: 11,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          );
        },
        // Returns a widget for each tile's tooltip.
        tooltipBuilder: (BuildContext context, TreemapTile tile) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: RichText(
              text: TextSpan(
                text: _stateWiseElectionResult[tile.indices[0]].candidate,
                style: themeData.textTheme.bodySmall!.copyWith(
                  height: 1.5,
                  color: _isLightTheme
                      ? const Color.fromRGBO(255, 255, 255, 1)
                      : const Color.fromRGBO(10, 10, 10, 1),
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: '\n${tile.group}',
                    style: themeData.textTheme.bodySmall!.copyWith(
                      color: _isLightTheme
                          ? const Color.fromRGBO(255, 255, 255, 1)
                          : const Color.fromRGBO(10, 10, 10, 1),
                    ),
                  ),
                  TextSpan(
                    text:
                        '\nWon percentage : ' +
                        _stateWiseElectionResult[tile.indices[0]].percentage
                            .toString() +
                        '%',
                    style: themeData.textTheme.bodySmall!.copyWith(
                      color: _isLightTheme
                          ? const Color.fromRGBO(255, 255, 255, 1)
                          : const Color.fromRGBO(10, 10, 10, 1),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ];
  }
}

class _StateElectionDetails {
  const _StateElectionDetails({
    required this.totalVoters,
    this.state,
    this.party,
    this.candidate,
    this.votes,
    this.percentage,
  });

  final String? state;
  final double totalVoters;
  final String? party;
  final String? candidate;
  final double? votes;
  final double? percentage;
}
