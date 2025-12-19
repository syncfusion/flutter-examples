import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// Treemap import.
import 'package:syncfusion_flutter_treemap/treemap.dart';

/// Local import.
import '../../../model/sample_view.dart';

/// This sample demonstrates how to add a multiple level tiles in the treemap.
class HierarchicalTreemapSample extends SampleView {
  /// Creates [HierarchicalTreemapSample].
  const HierarchicalTreemapSample(Key key) : super(key: key);

  @override
  _HierarchicalTreemapSampleState createState() =>
      _HierarchicalTreemapSampleState();
}

class _HierarchicalTreemapSampleState extends SampleViewState {
  late List<_FootballTeamDetails> _europeanCupAndUEFALeagueWinners;
  late bool isDesktop;
  late List<DropdownMenuItem<TreemapLayoutDirection>> _dropDownMenuItems;
  TreemapLayoutDirection _layoutDirection = TreemapLayoutDirection.topLeft;

  @override
  void initState() {
    // Data source to the treemap.
    //
    // [titles] is used to get each tile's weight.
    // [nation] is the first level grouping key.
    // [team] is the second level grouping key.
    _europeanCupAndUEFALeagueWinners = <_FootballTeamDetails>[
      const _FootballTeamDetails(
        nation: 'ESP',
        team: 'Real Madrid',
        titles: 13,
      ),
      const _FootballTeamDetails(nation: 'ITA', team: 'Milan', titles: 7),
      const _FootballTeamDetails(
        nation: 'GER',
        team: 'Bayern Munich',
        titles: 6,
      ),
      const _FootballTeamDetails(nation: 'ENG', team: 'Liverpool', titles: 6),
      const _FootballTeamDetails(nation: 'ESP', team: 'Barcelona', titles: 5),
      const _FootballTeamDetails(nation: 'NED', team: 'Ajax', titles: 4),
      const _FootballTeamDetails(
        nation: 'ENG',
        team: 'Manchester United',
        titles: 3,
      ),
      const _FootballTeamDetails(nation: 'ITA', team: 'Inter Milan', titles: 3),
      const _FootballTeamDetails(nation: 'ITA', team: 'Juventus', titles: 2),
      const _FootballTeamDetails(nation: 'POR', team: 'Benfica', titles: 2),
      const _FootballTeamDetails(
        nation: 'ENG',
        team: 'Nottingham Forest',
        titles: 2,
      ),
      const _FootballTeamDetails(nation: 'POR', team: 'Porto', titles: 2),
      const _FootballTeamDetails(nation: 'SCO', team: 'Celtic', titles: 1),
      const _FootballTeamDetails(
        nation: 'GER',
        team: 'Hamburger SV',
        titles: 1,
      ),
      const _FootballTeamDetails(
        nation: 'ROU',
        team: 'Steaua București',
        titles: 1,
      ),
      const _FootballTeamDetails(nation: 'FRA', team: 'Marseille', titles: 1),
      const _FootballTeamDetails(
        nation: 'GER',
        team: 'Borussia Dortmund',
        titles: 1,
      ),
      const _FootballTeamDetails(nation: 'ENG', team: 'Chelsea', titles: 1),
      const _FootballTeamDetails(nation: 'NED', team: 'Feyenoord', titles: 1),
      const _FootballTeamDetails(nation: 'ENG', team: 'Aston Villa', titles: 1),
      const _FootballTeamDetails(
        nation: 'NED',
        team: 'PSV Eindhoven',
        titles: 1,
      ),
      const _FootballTeamDetails(
        nation: 'YUG',
        team: 'Red Star Belgrade',
        titles: 1,
      ),
    ];

    _dropDownMenuItems = _getDropDownMenuItems();
    _layoutDirection = _dropDownMenuItems[0].value!;
    super.initState();
  }

  @override
  void dispose() {
    _dropDownMenuItems.clear();
    _europeanCupAndUEFALeagueWinners.clear();
    super.dispose();
  }

  List<DropdownMenuItem<TreemapLayoutDirection>> _getDropDownMenuItems() {
    return <DropdownMenuItem<TreemapLayoutDirection>>[
      const DropdownMenuItem<TreemapLayoutDirection>(
        value: TreemapLayoutDirection.topLeft,
        child: Text('topLeft'),
      ),
      const DropdownMenuItem<TreemapLayoutDirection>(
        value: TreemapLayoutDirection.bottomLeft,
        child: Text('bottomLeft'),
      ),
      const DropdownMenuItem<TreemapLayoutDirection>(
        value: TreemapLayoutDirection.topRight,
        child: Text('topRight'),
      ),
      const DropdownMenuItem<TreemapLayoutDirection>(
        value: TreemapLayoutDirection.bottomRight,
        child: Text('bottomRight'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    isDesktop =
        kIsWeb ||
        themeData.platform == TargetPlatform.macOS ||
        themeData.platform == TargetPlatform.linux ||
        themeData.platform == TargetPlatform.windows;
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
              'European Cup and UEFA Champions League Winners',
              style: themeData.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 12.5),
                child: SfTreemap(
                  // The number of data in your data source collection.
                  //
                  // The callback for the [weightValueMapper] and
                  // [TreemapLevel.groupMapper] will be called
                  // the number of times equal to the [dataCount].
                  dataCount: _europeanCupAndUEFALeagueWinners.length,
                  // The value returned in the callback will specify the
                  // weight of each tile.
                  weightValueMapper: (int index) {
                    return _europeanCupAndUEFALeagueWinners[index].titles;
                  },
                  layoutDirection: _layoutDirection,
                  tooltipSettings: const TreemapTooltipSettings(
                    color: Color.fromRGBO(2, 99, 103, 1.0),
                  ),
                  levels: _getTreemapLevels(themeData),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<TreemapLevel> _getTreemapLevels(ThemeData themeData) {
    return <TreemapLevel>[
      TreemapLevel(
        color: const Color.fromRGBO(1, 166, 172, 1.0),
        // Used for grouping the tiles based on the value returned from
        // this callback.
        //
        // Once grouped, we will get [labelBuilder] and [tooltipBuilder]
        // callbacks respectively.
        groupMapper: (int index) =>
            _europeanCupAndUEFALeagueWinners[index].nation,
        // Padding around the tile.
        padding: const EdgeInsets.all(1.5),
        // Returns a widget for each tile's data label.
        labelBuilder: (BuildContext context, TreemapTile tile) {
          return Padding(
            padding: _getHeaderLabelPadding(),
            child: Align(
              alignment: _getLabelAlignment(),
              child: Text(
                tile.group,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                ),
              ),
            ),
          );
        },
      ),
      TreemapLevel(
        color: const Color.fromRGBO(103, 206, 208, 1.0),
        // Used for grouping the tiles based on the value returned from
        // this callback.
        //
        // Once grouped, we will get [labelBuilder] and [tooltipBuilder]
        // callbacks respectively.
        groupMapper: (int index) =>
            _europeanCupAndUEFALeagueWinners[index].team,
        // Padding around the tile.
        padding: const EdgeInsets.all(1.0),
        // Returns a widget for each tile's data label.
        labelBuilder: (BuildContext context, TreemapTile tile) {
          return Padding(
            padding: _getLabelPadding(),
            child: Align(
              alignment: _getLabelAlignment(),
              child: Text(
                tile.group,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                ),
              ),
            ),
          );
        },
        // Returns a widget for each tile's tooltip.
        tooltipBuilder: (BuildContext context, TreemapTile tile) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: RichText(
              text: TextSpan(
                text: tile.group,
                style: themeData.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.5,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: '\nTitles : ${tile.weight.round()}',
                    style: themeData.textTheme.bodySmall!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
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

  EdgeInsets _getHeaderLabelPadding() {
    switch (_layoutDirection) {
      case TreemapLayoutDirection.topLeft:
        return const EdgeInsets.only(left: 6.0, top: 4.0);
      case TreemapLayoutDirection.topRight:
        return const EdgeInsets.only(right: 6.0, top: 4.0);
      case TreemapLayoutDirection.bottomLeft:
        return const EdgeInsets.only(left: 6.0, top: 4.0);
      case TreemapLayoutDirection.bottomRight:
        return const EdgeInsets.only(right: 6.0, top: 4.0);
    }
  }

  EdgeInsets _getLabelPadding() {
    switch (_layoutDirection) {
      case TreemapLayoutDirection.topLeft:
        return const EdgeInsets.only(left: 4.0, top: 2.0);
      case TreemapLayoutDirection.topRight:
        return const EdgeInsets.only(right: 4.0, top: 2.0, left: 4.0);
      case TreemapLayoutDirection.bottomLeft:
        return const EdgeInsets.only(left: 4.0, bottom: 2.0);
      case TreemapLayoutDirection.bottomRight:
        return const EdgeInsets.only(right: 4.0, bottom: 2.0, left: 4.0);
    }
  }

  Alignment _getLabelAlignment() {
    switch (_layoutDirection) {
      case TreemapLayoutDirection.topLeft:
        return Alignment.topLeft;
      case TreemapLayoutDirection.topRight:
        return Alignment.topRight;
      case TreemapLayoutDirection.bottomLeft:
        return Alignment.bottomLeft;
      case TreemapLayoutDirection.bottomRight:
        return Alignment.bottomRight;
    }
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Layout direction',
                  style: TextStyle(color: model.textColor, fontSize: 16),
                ),
                DropdownButton<TreemapLayoutDirection>(
                  dropdownColor: model.drawerBackgroundColor,
                  value: _layoutDirection,
                  items: _dropDownMenuItems,
                  onChanged: (TreemapLayoutDirection? value) {
                    setState(() {
                      _layoutDirection = value!;
                      switch (_layoutDirection) {
                        case TreemapLayoutDirection.topLeft:
                          _layoutDirection = TreemapLayoutDirection.topLeft;
                          break;
                        case TreemapLayoutDirection.topRight:
                          _layoutDirection = TreemapLayoutDirection.topRight;
                          break;
                        case TreemapLayoutDirection.bottomLeft:
                          _layoutDirection = TreemapLayoutDirection.bottomLeft;
                          break;
                        case TreemapLayoutDirection.bottomRight:
                          _layoutDirection = TreemapLayoutDirection.bottomRight;
                          break;
                      }
                      stateSetter(() {});
                    });
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _FootballTeamDetails {
  const _FootballTeamDetails({required this.titles, this.nation, this.team});

  final String? nation;
  final String? team;
  final double titles;
}
