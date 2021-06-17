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
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 4087631,
          votes: 2369612,
          percentage: 57.97),
      const _StateElectionDetails(
          state: 'Oregon',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 2374321,
          votes: 1340383,
          percentage: 56.45),
      const _StateElectionDetails(
          state: 'Alabama',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 2323282,
          votes: 1441170,
          percentage: 62.03),
      const _StateElectionDetails(
          state: 'Alaska',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 359530,
          votes: 189951,
          percentage: 52.83),
      const _StateElectionDetails(
          state: 'Arizona',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 3387326,
          votes: 1672143,
          percentage: 49.36),
      const _StateElectionDetails(
          state: 'Arkansas',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 1219069,
          votes: 760647,
          percentage: 62.40),
      const _StateElectionDetails(
          state: 'California',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 17500881,
          votes: 11110250,
          percentage: 63.48),
      const _StateElectionDetails(
          state: 'Colorado',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 3256980,
          votes: 1804352,
          percentage: 55.40),
      const _StateElectionDetails(
          state: 'Connecticut',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 1823857,
          votes: 1080831,
          percentage: 59.26),
      const _StateElectionDetails(
          state: 'Delaware',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 504346,
          votes: 296268,
          percentage: 58.74),
      const _StateElectionDetails(
          state: 'District of Columbia',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 344356,
          votes: 317323,
          percentage: 92.15),
      const _StateElectionDetails(
          state: 'Florida',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 11067456,
          votes: 5668731,
          percentage: 51.22),
      const _StateElectionDetails(
          state: 'Georgia',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 4999960,
          votes: 2473633,
          percentage: 49.47),
      const _StateElectionDetails(
          state: 'Hawaii',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 574469,
          votes: 366130,
          percentage: 63.73),
      const _StateElectionDetails(
          state: 'Idaho',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 868014,
          votes: 554119,
          percentage: 63.84),
      const _StateElectionDetails(
          state: 'Illinois',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 6033744,
          votes: 3471915,
          percentage: 57.54),
      const _StateElectionDetails(
          state: 'Indiana',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 3033121,
          votes: 1729519,
          percentage: 57.02),
      const _StateElectionDetails(
          state: 'Iowa',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 1690871,
          votes: 897672,
          percentage: 53.09),
      const _StateElectionDetails(
          state: 'Kansas',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 1372303,
          votes: 771406,
          percentage: 56.21),
      const _StateElectionDetails(
          state: 'Kentucky',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 2136768,
          votes: 1326646,
          percentage: 62.09),
      const _StateElectionDetails(
          state: 'Louisiana',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 2148062,
          votes: 1255776,
          percentage: 58.46),
      const _StateElectionDetails(
          state: 'Maine-1',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 443112,
          votes: 266376,
          percentage: 60.11),
      const _StateElectionDetails(
          state: 'Maine-2',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 376349,
          votes: 196692,
          percentage: 52.26),
      const _StateElectionDetails(
          state: 'Maryland',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 3037030,
          votes: 1985023,
          percentage: 65.36),
      const _StateElectionDetails(
          state: 'Massachusetts',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 3631402,
          votes: 2382202,
          percentage: 65.60),
      const _StateElectionDetails(
          state: 'Michigan',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 5539302,
          votes: 2804040,
          percentage: 50.62),
      const _StateElectionDetails(
          state: 'Minnesota',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 3277171,
          votes: 1717077,
          percentage: 52.40),
      const _StateElectionDetails(
          state: 'Mississippi',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 1313759,
          votes: 756764,
          percentage: 57.60),
      const _StateElectionDetails(
          state: 'Missouri',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 3025962,
          votes: 1718736,
          percentage: 56.80),
      const _StateElectionDetails(
          state: 'Montana',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 603674,
          votes: 343602,
          percentage: 56.92),
      const _StateElectionDetails(
          state: 'Nebraska-1',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 321886,
          votes: 180290,
          percentage: 56.01),
      const _StateElectionDetails(
          state: 'Nebraska-2',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 339666,
          votes: 176468,
          percentage: 51.95),
      const _StateElectionDetails(
          state: 'Nebraska-3',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 294831,
          votes: 222179,
          percentage: 75.36),
      const _StateElectionDetails(
          state: 'Nevada',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 1405376,
          votes: 703486,
          percentage: 50.06),
      const _StateElectionDetails(
          state: 'New Hampshire',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 806205,
          votes: 424937,
          percentage: 52.71),
      const _StateElectionDetails(
          state: 'New Jersey',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 4549353,
          votes: 2608335,
          percentage: 57.33),
      const _StateElectionDetails(
          state: 'New Mexico',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 923965,
          votes: 501614,
          percentage: 54.29),
      const _StateElectionDetails(
          state: 'New York',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 8594826,
          votes: 5230985,
          percentage: 60.86),
      const _StateElectionDetails(
          state: 'North Carolina',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 5524804,
          votes: 2758775,
          percentage: 49.93),
      const _StateElectionDetails(
          state: 'North Dakota',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 361819,
          votes: 235595,
          percentage: 65.11),
      const _StateElectionDetails(
          state: 'Ohio',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 5922202,
          votes: 3154834,
          percentage: 53.27),
      const _StateElectionDetails(
          state: 'Oklahoma',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 1560699,
          votes: 1020280,
          percentage: 65.37),
      const _StateElectionDetails(
          state: 'Pennsylvania',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 6915283,
          votes: 3458229,
          percentage: 50.01),
      const _StateElectionDetails(
          state: 'Rhode Island',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 517757,
          votes: 307486,
          percentage: 59.39),
      const _StateElectionDetails(
          state: 'South Carolina',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 2513329,
          votes: 1385103,
          percentage: 55.11),
      const _StateElectionDetails(
          state: 'South Dakota',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 422609,
          votes: 261043,
          percentage: 61.77),
      const _StateElectionDetails(
          state: 'Tennessee',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 3053851,
          votes: 1852475,
          percentage: 60.66),
      const _StateElectionDetails(
          state: 'Texas',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 11315056,
          votes: 5890347,
          percentage: 52.06),
      const _StateElectionDetails(
          state: 'Utah',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 1488289,
          votes: 865140,
          percentage: 58.13),
      const _StateElectionDetails(
          state: 'Vermont',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 367428,
          votes: 242820,
          percentage: 66.09),
      const _StateElectionDetails(
          state: 'Virginia',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 4460524,
          votes: 2413568,
          percentage: 54.11),
      const _StateElectionDetails(
          state: 'West Virginia',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 794731,
          votes: 235984,
          percentage: 68.62),
      const _StateElectionDetails(
          state: 'Wisconsin',
          candidate: 'Joe Biden',
          party: 'Democratic',
          totalVoters: 3298041,
          votes: 1610184,
          percentage: 49.45),
      const _StateElectionDetails(
          state: 'Wyoming',
          candidate: 'Donald Trump',
          party: 'Republican',
          totalVoters: 276765,
          votes: 193559,
          percentage: 69.94),
    ];

    _colorMappers = <TreemapColorMapper>[
      const TreemapColorMapper.range(
          from: 80,
          to: 100,
          color: Color.fromRGBO(0, 0, 81, 1.0),
          name: '{Democratic},{}'),
      const TreemapColorMapper.range(
          from: 75, to: 80, color: Color.fromRGBO(0, 43, 132, 1.0), name: ''),
      const TreemapColorMapper.range(
          from: 70, to: 75, color: Color.fromRGBO(6, 69, 180, 1.0), name: ''),
      const TreemapColorMapper.range(
          from: 65, to: 70, color: Color.fromRGBO(22, 102, 203, 1.0), name: ''),
      const TreemapColorMapper.range(
          from: 60, to: 65, color: Color.fromRGBO(67, 137, 227, 1.0), name: ''),
      const TreemapColorMapper.range(
          from: 55, to: 60, color: Color.fromRGBO(80, 154, 242, 1.0), name: ''),
      const TreemapColorMapper.range(
          from: 45,
          to: 55,
          color: Color.fromRGBO(134, 182, 242, 1.0),
          name: ''),
      const TreemapColorMapper.range(
          from: -55,
          to: -45,
          color: Color.fromRGBO(255, 178, 178, 1.0),
          name: ''),
      const TreemapColorMapper.range(
          from: -60,
          to: -55,
          color: Color.fromRGBO(255, 127, 127, 1.0),
          name: ''),
      const TreemapColorMapper.range(
          from: -65,
          to: -60,
          color: Color.fromRGBO(255, 76, 76, 1.0),
          name: ''),
      const TreemapColorMapper.range(
          from: -70,
          to: -65,
          color: Color.fromRGBO(255, 50, 50, 1.0),
          name: ''),
      const TreemapColorMapper.range(
          from: -75, to: -70, color: Color.fromRGBO(178, 0, 0, 1.0), name: ''),
      const TreemapColorMapper.range(
          from: -80, to: -75, color: Color.fromRGBO(127, 0, 0, 1.0), name: ''),
      const TreemapColorMapper.range(
          from: -100,
          to: -80,
          color: Color.fromRGBO(102, 0, 0, 1.0),
          name: 'Republican'),
    ];

    super.initState();
  }

  @override
  void dispose() {
    _stateWiseElectionResult.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    _isLightTheme = themeData.brightness == Brightness.light;
    isDesktop = kIsWeb ||
        themeData.platform == TargetPlatform.macOS ||
        themeData.platform == TargetPlatform.linux ||
        themeData.platform == TargetPlatform.windows;
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final Size size = Size(constraints.maxWidth, constraints.maxHeight);
      return Center(
        child: Padding(
          padding: MediaQuery.of(context).orientation == Orientation.portrait ||
                  isDesktop
              ? const EdgeInsets.all(12.5)
              : const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Text(
                '2020 US Election Results',
                style: Theme.of(context).textTheme.subtitle1,
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
                              (size.width * 0.80) / _colorMappers.length, 12.0),
                      edgeLabelsPlacement:
                          TreemapLegendEdgeLabelsPlacement.inside,
                      labelOverflow: TreemapLabelOverflow.visible,
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
    });
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
        // Padding around the tile.
        padding: const EdgeInsets.all(0.5),
        // The value returned in the callback will specify the
        // color of each tile.
        colorValueMapper: (TreemapTile tile) {
          if (_stateWiseElectionResult[tile.indices[0]].candidate ==
              'Joe Biden') {
            return _stateWiseElectionResult[tile.indices[0]].percentage;
          } else {
            return -_stateWiseElectionResult[tile.indices[0]].percentage!;
          }
        },
        // Returns a widget for each tile's data label.
        labelBuilder: (BuildContext context, TreemapTile tile) {
          final Brightness brightness =
              ThemeData.estimateBrightnessForColor(tile.color);
          final Color color =
              brightness == Brightness.dark ? Colors.white : Colors.black;
          return Padding(
            padding: const EdgeInsets.only(left: 4.0, top: 4.0),
            child: Text(
              tile.group,
              style: themeData.textTheme.caption!.copyWith(
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
                style: themeData.textTheme.caption!.copyWith(
                  height: 1.5,
                  color: _isLightTheme
                      ? const Color.fromRGBO(255, 255, 255, 1)
                      : const Color.fromRGBO(10, 10, 10, 1),
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: '\n${tile.group}',
                      style: themeData.textTheme.caption!.copyWith(
                        color: _isLightTheme
                            ? const Color.fromRGBO(255, 255, 255, 1)
                            : const Color.fromRGBO(10, 10, 10, 1),
                      )),
                  TextSpan(
                    text: '\nWon percentage : ' +
                        _stateWiseElectionResult[tile.indices[0]]
                            .percentage
                            .toString() +
                        '%',
                    style: themeData.textTheme.caption!.copyWith(
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
  const _StateElectionDetails(
      {required this.totalVoters,
      this.state,
      this.party,
      this.candidate,
      this.votes,
      this.percentage});

  final String? state;
  final double totalVoters;
  final String? party;
  final String? candidate;
  final double? votes;
  final double? percentage;
}
