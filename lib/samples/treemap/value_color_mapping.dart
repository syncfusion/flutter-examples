import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// Treemap import.
import 'package:syncfusion_flutter_treemap/treemap.dart';

/// Local import.
import '../../../model/sample_view.dart';

/// This sample demonstrates how to apply color to the tiles based on the
/// specific value.
class TreemapValueColorMappingSample extends SampleView {
  /// Creates [TreemapValueColorMappingSample].
  const TreemapValueColorMappingSample(Key key) : super(key: key);

  @override
  _TreemapValueColorMappingSampleState createState() =>
      _TreemapValueColorMappingSampleState();
}

class _TreemapValueColorMappingSampleState extends SampleViewState {
  late List<_MarketPlace> _topOnlineMarketPlaces;
  late List<TreemapColorMapper> _colorMappers;
  late bool _isLightTheme;
  late bool isDesktop;

  @override
  void initState() {
    // Data source to the treemap.
    //
    // [visitorsInBillions] is used to get each tile's weight.
    // [name] is the flat level grouping key.
    _topOnlineMarketPlaces = <_MarketPlace>[
      const _MarketPlace(
        country: 'USA',
        name: 'Amazon',
        visitorsInBillions: 5.7,
      ),
      const _MarketPlace(
        country: 'Japan',
        name: 'PayPay Mall',
        visitorsInBillions: 2.1,
      ),
      const _MarketPlace(country: 'USA', name: 'eBay', visitorsInBillions: 1.6),
      const _MarketPlace(
        country: 'Argentina',
        name: 'Mercado Libre',
        visitorsInBillions: 0.6617,
      ),
      const _MarketPlace(
        country: 'China',
        name: 'AliExpress',
        visitorsInBillions: 0.6391,
      ),
      const _MarketPlace(
        country: 'Japan',
        name: 'Rakuten',
        visitorsInBillions: 0.6215,
      ),
      const _MarketPlace(
        country: 'China',
        name: 'Taobao',
        visitorsInBillions: 0.5452,
      ),
      const _MarketPlace(
        country: 'USA',
        name: 'Walmart.com',
        visitorsInBillions: 0.469,
      ),
      const _MarketPlace(
        country: 'China',
        name: 'JD.com',
        visitorsInBillions: 0.3182,
      ),
      const _MarketPlace(
        country: 'USA',
        name: 'Etsy',
        visitorsInBillions: 0.2663,
      ),
    ];

    _colorMappers = <TreemapColorMapper>[
      const TreemapColorMapper.value(
        value: 'USA',
        color: Color.fromRGBO(71, 94, 209, 1.0),
      ),
      const TreemapColorMapper.value(
        value: 'Japan',
        color: Color.fromRGBO(236, 105, 85, 1.0),
      ),
      const TreemapColorMapper.value(
        value: 'Argentina',
        color: Color.fromRGBO(78, 198, 125, 1.0),
      ),
      const TreemapColorMapper.value(
        value: 'China',
        color: Color.fromRGBO(240, 140, 86, 1.0),
      ),
    ];

    super.initState();
  }

  @override
  void dispose() {
    _topOnlineMarketPlaces.clear();
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
                ? const EdgeInsets.only(left: 12.5, right: 12.5, top: 12.5)
                : const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Top 10 Online Marketplaces',
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
                      dataCount: _topOnlineMarketPlaces.length,
                      // The value returned in the callback will specify the
                      // weight of each tile.
                      weightValueMapper: (int index) {
                        return _topOnlineMarketPlaces[index].visitorsInBillions;
                      },
                      tooltipSettings: TreemapTooltipSettings(
                        color: _isLightTheme
                            ? const Color.fromRGBO(45, 45, 45, 1)
                            : const Color.fromRGBO(242, 242, 242, 1),
                      ),
                      levels: _getTreemapLevels(themeData),
                      colorMappers: _colorMappers,
                      legend: TreemapLegend.bar(
                        position: TreemapLegendPosition.bottom,
                        segmentSize: isDesktop
                            ? const Size(80.0, 12.0)
                            : Size(
                                (size.width * 0.80) / _colorMappers.length,
                                12.0,
                              ),
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
        color: Colors.cyan,
        // Used for grouping the tiles based on the value returned from
        // this callback.
        //
        // Once grouped, we will get [labelBuilder], [tooltipBuilder], and
        // [colorValueMapper] callbacks respectively.
        groupMapper: (int index) => _topOnlineMarketPlaces[index].name,
        // Padding around the tile.
        padding: const EdgeInsets.all(1.0),
        // The value returned in the callback will specify the
        // color of each tile.
        colorValueMapper: (TreemapTile tile) {
          return _topOnlineMarketPlaces[tile.indices[0]].country;
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
            padding: const EdgeInsets.all(4.0),
            child: Text(
              tile.group,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
              ),
            ),
          );
        },
        // Returns a widget for each tile's tooltip.
        tooltipBuilder: (BuildContext context, TreemapTile tile) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: RichText(
              text: TextSpan(
                text:
                    'Country : ${_topOnlineMarketPlaces[tile.indices[0]].country}',
                style: themeData.textTheme.bodySmall!.copyWith(
                  height: 1.5,
                  color: _isLightTheme
                      ? const Color.fromRGBO(255, 255, 255, 1)
                      : const Color.fromRGBO(10, 10, 10, 1),
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: '\nVisitors : ${tile.weight}B',
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

class _MarketPlace {
  const _MarketPlace({
    required this.visitorsInBillions,
    required this.country,
    required this.name,
  });

  final String country;
  final String name;
  final double visitorsInBillions;
}
