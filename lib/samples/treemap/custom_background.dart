import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// Treemap import.
import 'package:syncfusion_flutter_treemap/treemap.dart';

/// Local import.
import '../../../model/sample_view.dart';

/// This sample demonstrates how to add a background content to the tile.
class TreemapCustomBackgroundSample extends SampleView {
  /// Creates [TreemapCustomBackgroundSample].
  const TreemapCustomBackgroundSample(Key key) : super(key: key);

  @override
  _TreemapCustomBackgroundSampleState createState() =>
      _TreemapCustomBackgroundSampleState();
}

class _TreemapCustomBackgroundSampleState extends SampleViewState {
  late List<_MedalDetails> _topRioOlympicCountries;
  late bool isDesktop;

  @override
  void initState() {
    // Data source to the treemap.
    //
    // [medalCount] is used to get each tile's weight.
    // [country] is the first level grouping key.
    // [medal] is the second level grouping key.
    // [category] is the third level grouping key.
    _topRioOlympicCountries = <_MedalDetails>[
      const _MedalDetails(
        country: 'United States',
        medal: 'Gold',
        category: 'Swimming',
        medalCount: 16,
        icon: Icons.pool,
      ),
      const _MedalDetails(
        country: 'United States',
        medal: 'Gold',
        category: 'Athletics',
        medalCount: 13,
        icon: Icons.directions_run,
      ),
      const _MedalDetails(
        country: 'United States',
        medal: 'Gold',
        category: 'Gymnastics',
        medalCount: 4,
        icon: Icons.accessibility,
      ),
      const _MedalDetails(
        country: 'United States',
        medal: 'Gold',
        category: 'Cycling',
        medalCount: 2,
        icon: Icons.directions_bike,
      ),
      const _MedalDetails(
        country: 'United States',
        medal: 'Gold',
        category: 'Wrestling',
        medalCount: 2,
        icon: Icons.sports_kabaddi_outlined,
      ),
      const _MedalDetails(
        country: 'United States',
        medal: 'Gold',
        category: 'Basketball',
        medalCount: 2,
        icon: Icons.sports_basketball,
      ),
      const _MedalDetails(
        country: 'United States',
        medal: 'Silver',
        category: 'Swimming',
        medalCount: 8,
        icon: Icons.pool,
      ),
      const _MedalDetails(
        country: 'United States',
        medal: 'Silver',
        category: 'Athletics',
        medalCount: 10,
        icon: Icons.directions_run,
      ),
      const _MedalDetails(
        country: 'United States',
        medal: 'Silver',
        category: 'Gymnastics',
        medalCount: 6,
        icon: Icons.accessibility,
      ),
      const _MedalDetails(
        country: 'United States',
        medal: 'Silver',
        category: 'Cycling',
        medalCount: 3,
        icon: Icons.directions_bike,
      ),
      const _MedalDetails(
        country: 'United States',
        medal: 'Silver',
        category: 'Fencing',
        medalCount: 2,
        icon: Icons.colorize_rounded,
      ),
      const _MedalDetails(
        country: 'United States',
        medal: 'Silver',
        category: 'Diving',
        medalCount: 2,
        icon: Icons.emoji_people,
      ),
      const _MedalDetails(
        country: 'United States',
        medal: 'Bronze',
        category: 'Swimming',
        medalCount: 9,
        icon: Icons.pool,
      ),
      const _MedalDetails(
        country: 'United States',
        medal: 'Bronze',
        category: 'Athletics',
        medalCount: 9,
        icon: Icons.directions_run,
      ),
      const _MedalDetails(
        country: 'United States',
        medal: 'Bronze',
        category: 'Gymnastics',
        medalCount: 2,
        icon: Icons.accessibility,
      ),
      const _MedalDetails(
        country: 'United States',
        medal: 'Bronze',
        category: 'Volleyball',
        medalCount: 3,
        icon: Icons.sports_volleyball_rounded,
      ),
      const _MedalDetails(
        country: 'United States',
        medal: 'Bronze',
        category: 'Fencing',
        medalCount: 2,
        icon: Icons.colorize_rounded,
      ),
      const _MedalDetails(
        country: 'United States',
        medal: 'Bronze',
        category: 'Shooting',
        medalCount: 2,
        icon: Icons.gps_fixed,
      ),
      const _MedalDetails(
        country: 'United Kingdom',
        medal: 'Gold',
        category: 'Cycling',
        medalCount: 6,
        icon: Icons.directions_bike,
      ),
      const _MedalDetails(
        country: 'United Kingdom',
        medal: 'Gold',
        category: 'Rowing',
        medalCount: 3,
        icon: Icons.rowing,
      ),
      const _MedalDetails(
        country: 'United Kingdom',
        medal: 'Gold',
        category: 'Gymnastics',
        medalCount: 2,
        icon: Icons.accessibility,
      ),
      const _MedalDetails(
        country: 'United Kingdom',
        medal: 'Gold',
        category: 'Athletics',
        medalCount: 2,
        icon: Icons.directions_run,
      ),
      const _MedalDetails(
        country: 'United Kingdom',
        medal: 'Gold',
        category: 'Canoeing',
        medalCount: 2,
        icon: Icons.rowing,
      ),
      const _MedalDetails(
        country: 'United Kingdom',
        medal: 'Gold',
        category: 'Swimming',
        medalCount: 1,
        icon: Icons.pool,
      ),
      const _MedalDetails(
        country: 'United Kingdom',
        medal: 'Silver',
        category: 'Swimming',
        medalCount: 5,
        icon: Icons.pool,
      ),
      const _MedalDetails(
        country: 'United Kingdom',
        medal: 'Silver',
        category: 'Athletics',
        medalCount: 1,
        icon: Icons.directions_run,
      ),
      const _MedalDetails(
        country: 'United Kingdom',
        medal: 'Silver',
        category: 'Gymnastics',
        medalCount: 2,
        icon: Icons.accessibility,
      ),
      const _MedalDetails(
        country: 'United Kingdom',
        medal: 'Silver',
        category: 'Cycling',
        medalCount: 4,
        icon: Icons.directions_bike,
      ),
      const _MedalDetails(
        country: 'United Kingdom',
        medal: 'Silver',
        category: 'Rowing',
        medalCount: 2,
        icon: Icons.rowing,
      ),
      const _MedalDetails(
        country: 'United Kingdom',
        medal: 'Silver',
        category: 'Canoeing',
        medalCount: 2,
        icon: Icons.rowing,
      ),
      const _MedalDetails(
        country: 'United Kingdom',
        medal: 'Bronze',
        category: 'Boxing',
        medalCount: 1,
        icon: Icons.sports_mma,
      ),
      const _MedalDetails(
        country: 'United Kingdom',
        medal: 'Bronze',
        category: 'Athletics',
        medalCount: 4,
        icon: Icons.directions_run,
      ),
      const _MedalDetails(
        country: 'United Kingdom',
        medal: 'Bronze',
        category: 'Gymnastics',
        medalCount: 3,
        icon: Icons.accessibility,
      ),
      const _MedalDetails(
        country: 'United Kingdom',
        medal: 'Bronze',
        category: 'Shooting',
        medalCount: 2,
        icon: Icons.gps_fixed,
      ),
      const _MedalDetails(
        country: 'United Kingdom',
        medal: 'Bronze',
        category: 'Cycling',
        medalCount: 2,
        icon: Icons.directions_bike,
      ),
      const _MedalDetails(
        country: 'United Kingdom',
        medal: 'Bronze',
        category: 'Diving',
        medalCount: 1,
        icon: Icons.emoji_people,
      ),
      const _MedalDetails(
        country: 'China',
        medal: 'Gold',
        category: 'Diving',
        medalCount: 7,
        icon: Icons.emoji_people,
      ),
      const _MedalDetails(
        country: 'China',
        medal: 'Gold',
        category: 'Weightlifting',
        medalCount: 5,
        icon: Icons.fitness_center,
      ),
      const _MedalDetails(
        country: 'China',
        medal: 'Gold',
        category: 'Table tennis',
        medalCount: 2,
        icon: Icons.sports_tennis,
      ),
      const _MedalDetails(
        country: 'China',
        medal: 'Gold',
        category: 'Athletics',
        medalCount: 4,
        icon: Icons.directions_run,
      ),
      const _MedalDetails(
        country: 'China',
        medal: 'Gold',
        category: 'Badminton',
        medalCount: 2,
        icon: Icons.sports_tennis,
      ),
      const _MedalDetails(
        country: 'China',
        medal: 'Gold',
        category: 'Swimming',
        medalCount: 1,
        icon: Icons.pool,
      ),
      const _MedalDetails(
        country: 'China',
        medal: 'Silver',
        category: 'Diving',
        medalCount: 2,
        icon: Icons.emoji_people,
      ),
      const _MedalDetails(
        country: 'China',
        medal: 'Silver',
        category: 'Weightlifting',
        medalCount: 2,
        icon: Icons.fitness_center,
      ),
      const _MedalDetails(
        country: 'China',
        medal: 'Silver',
        category: 'Table tennis',
        medalCount: 2,
        icon: Icons.sports_tennis,
      ),
      const _MedalDetails(
        country: 'China',
        medal: 'Silver',
        category: 'Athletics',
        medalCount: 2,
        icon: Icons.directions_run,
      ),
      const _MedalDetails(
        country: 'China',
        medal: 'Silver',
        category: 'Boxing',
        medalCount: 1,
        icon: Icons.sports_mma,
      ),
      const _MedalDetails(
        country: 'China',
        medal: 'Silver',
        category: 'Wrestling',
        medalCount: 1,
        icon: Icons.sports_kabaddi_outlined,
      ),
      const _MedalDetails(
        country: 'China',
        medal: 'Bronze',
        category: 'Swimming',
        medalCount: 3,
        icon: Icons.pool,
      ),
      const _MedalDetails(
        country: 'China',
        medal: 'Bronze',
        category: 'Athletics',
        medalCount: 4,
        icon: Icons.directions_run,
      ),
      const _MedalDetails(
        country: 'China',
        medal: 'Bronze',
        category: 'Wrestling',
        medalCount: 2,
        icon: Icons.sports_kabaddi_outlined,
      ),
      const _MedalDetails(
        country: 'China',
        medal: 'Bronze',
        category: 'Shooting',
        medalCount: 4,
        icon: Icons.gps_fixed,
      ),
      const _MedalDetails(
        country: 'China',
        medal: 'Bronze',
        category: 'Boxing',
        medalCount: 3,
        icon: Icons.sports_mma,
      ),
      const _MedalDetails(
        country: 'China',
        medal: 'Bronze',
        category: 'Rowing',
        medalCount: 2,
        icon: Icons.rowing,
      ),
    ];

    super.initState();
  }

  @override
  void dispose() {
    _topRioOlympicCountries.clear();
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
              'Top 3 Winningest Countries in Rio Olympics 2016',
              style: Theme.of(context).textTheme.titleMedium,
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
                  dataCount: _topRioOlympicCountries.length,
                  // The value returned in the callback will specify the
                  // weight of each tile.
                  weightValueMapper: (int index) {
                    return _topRioOlympicCountries[index].medalCount;
                  },
                  tooltipSettings: const TreemapTooltipSettings(
                    color: Color.fromRGBO(57, 65, 9, 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(2.0)),
                  ),
                  levels: _getTreemapLevels(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<TreemapLevel> _getTreemapLevels() {
    final ThemeData themeData = Theme.of(context);
    return <TreemapLevel>[
      TreemapLevel(
        color: Colors.transparent,
        // Used for grouping the tiles based on the value returned from
        // this callback.
        //
        // Once grouped, we will get [labelBuilder], [tooltipBuilder],
        // [colorValueMapper], and [itemBuilder] callbacks respectively.
        groupMapper: (int index) => _topRioOlympicCountries[index].country,
        // Padding around the tile.
        padding: const EdgeInsets.all(2.0),
        // Returns a widget for each tile's data label.
        labelBuilder: (BuildContext context, TreemapTile tile) {
          final Brightness brightness = ThemeData.estimateBrightnessForColor(
            tile.color,
          );
          final Color color = brightness == Brightness.dark
              ? Colors.white
              : Colors.black;
          return ColoredBox(
            color: const Color.fromRGBO(121, 137, 27, 1.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 4.0,
                  top: 2.0,
                  bottom: 2.0,
                ),
                child: Text(
                  tile.group,
                  style: themeData.textTheme.bodyMedium!.copyWith(color: color),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          );
        },
        // Returns a widget for each tile's tooltip.
        tooltipBuilder: (BuildContext context, TreemapTile tile) {
          return Padding(
            padding: EdgeInsets.zero,
            child: Text(
              '${tile.group}'
              '\nMedals : ${tile.weight.round()}',
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      ),
      TreemapLevel(
        groupMapper: (int index) => _topRioOlympicCountries[index].medal,
        padding: EdgeInsets.zero,
        colorValueMapper: (TreemapTile tile) {
          if (tile.group == 'Gold') {
            return const Color.fromRGBO(237, 176, 62, 1.0);
          } else if (tile.group == 'Silver') {
            return const Color.fromRGBO(207, 212, 216, 1.0);
          } else {
            return const Color.fromRGBO(189, 126, 64, 1.0);
          }
        },
        // Returns a widget for each tile's content.
        itemBuilder: (BuildContext context, TreemapTile tile) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(
                'images/treemap_medal.png',
                fit: BoxFit.contain,
              ),
            ),
          );
        },
      ),
      TreemapLevel(
        color: Colors.transparent,
        padding: EdgeInsets.zero,
        border: RoundedRectangleBorder(
          side: BorderSide(
            color: themeData.colorScheme.brightness == Brightness.light
                ? const Color.fromRGBO(255, 255, 255, 1.0)
                : const Color.fromRGBO(0, 0, 0, 1.0),
            width: 0.5,
          ),
        ),
        groupMapper: (int index) {
          return _topRioOlympicCountries[index].category;
        },
        tooltipBuilder: (BuildContext context, TreemapTile tile) {
          return _buildTooltip(tile);
        },
        labelBuilder: (BuildContext context, TreemapTile tile) {
          Color color;
          if (_topRioOlympicCountries[tile.indices[0]].medal == 'Bronze') {
            color = const Color.fromRGBO(255, 255, 255, 1.0);
          } else {
            color = const Color.fromRGBO(72, 72, 72, 1.0);
          }

          return Padding(
            padding: const EdgeInsets.only(left: 2.0, top: 2.0, bottom: 2.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                tile.group,
                style: themeData.textTheme.bodySmall!.copyWith(color: color),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        },
      ),
    ];
  }

  Widget _buildTooltip(TreemapTile tile) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Transform.translate(
                offset: const Offset(-3, 0),
                child: Icon(
                  _topRioOlympicCountries[tile.indices[0]].icon,
                  color: Colors.white,
                  size: 15,
                ),
              ),
              const SizedBox(height: 5),
              Text(tile.group, style: const TextStyle(color: Colors.white)),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            _topRioOlympicCountries[tile.indices[0]].medal! +
                ' : ' +
                tile.weight.round().toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _MedalDetails {
  const _MedalDetails({
    required this.medalCount,
    this.country,
    this.medal,
    this.category,
    this.icon,
  });

  final String? country;
  final String? medal;
  final String? category;
  final double medalCount;
  final IconData? icon;
}
