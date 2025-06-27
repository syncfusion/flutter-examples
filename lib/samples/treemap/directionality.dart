import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// Treemap import.
import 'package:syncfusion_flutter_treemap/treemap.dart';

/// Local import.
import '../../../model/sample_view.dart';

/// This sample demonstrates how to apply color to the tiles based on the
/// specific value.
class TreemapTextDirectionPage extends DirectionalitySampleView {
  /// Creates [TreemapTextDirectionPage].
  const TreemapTextDirectionPage(Key key) : super(key: key);

  @override
  _TreemapTextDirectionPageState createState() =>
      _TreemapTextDirectionPageState();
}

class _TreemapTextDirectionPageState extends DirectionalitySampleViewState {
  late List<_StateGRP> _statesGRPData;
  late List<TreemapColorMapper> _colorMappers;
  late bool _isLightTheme;
  late bool isDesktop;
  late String _title;

  @override
  void initState() {
    // Data source to the treemap.
    //
    // [visitorsInBillions] is used to get each tile's weight.
    // [name] is the flat level grouping key.
    _statesGRPData = <_StateGRP>[
      _StateGRP('Baden-Wuerttemberg', 500.790, 'بادن فورتمبيرغ'),
      _StateGRP('Bavaria', 610.220, 'بافاريا'),
      _StateGRP('Berlin', 154.630, 'برلين'),
      _StateGRP('Brandenburg', 73.930, 'براندنبورغ'),
      _StateGRP('Bremen', 31.580, 'بريمن'),
      _StateGRP('Hamburg', 118.130, 'هامبورغ'),
      _StateGRP('Hesse', 281.420, 'هيس'),
      _StateGRP('Mecklenburg-Vorpommern', 46.010, 'مكلنبورغ فوربومرن'),
      _StateGRP('Lower Saxony', 295.900, 'ساكسونيا السفلى'),
      _StateGRP('North Rhine-Westphalia', 697.130, 'شمال الراين وستفاليا'),
      _StateGRP('Rhineland-Palatinate', 141.900, 'راينلاند بالاتينات'),
      _StateGRP('Saarland', 33.610, 'سارلاند'),
      _StateGRP('Saxony', 125.570, 'ساكسونيا'),
      _StateGRP('Saxony-Anhalt', 62.650, 'ساكسونيا أنهالت'),
      _StateGRP('Schleswig-Holstein', 97.220, 'شليسفيغ هولشتاين'),
      _StateGRP('Thuringia', 61.540, 'تورينجيا'),
    ];

    _colorMappers = <TreemapColorMapper>[
      const TreemapColorMapper.range(
        from: 0,
        to: 50,
        color: Color.fromRGBO(250, 189, 32, 1),
        name: '{0},{50}',
      ),
      const TreemapColorMapper.range(
        from: 50,
        to: 100,
        color: Color.fromRGBO(221, 146, 0, 1),
        name: '100',
      ),
      const TreemapColorMapper.range(
        from: 100,
        to: 150,
        color: Color.fromRGBO(220, 121, 5, 1),
        name: '150',
      ),
      const TreemapColorMapper.range(
        from: 150,
        to: 300,
        color: Color.fromRGBO(182, 87, 0, 1),
        name: '300',
      ),
      const TreemapColorMapper.range(
        from: 300,
        to: 700,
        color: Color.fromRGBO(173, 60, 44, 1),
        name: '700',
      ),
    ];

    super.initState();
  }

  @override
  void dispose() {
    _statesGRPData.clear();
    super.dispose();
  }

  @override
  Widget buildSample(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    _updateTitleBasedOnLocale();
    _isLightTheme = themeData.colorScheme.brightness == Brightness.light;
    isDesktop =
        kIsWeb ||
        themeData.platform == TargetPlatform.macOS ||
        themeData.platform == TargetPlatform.linux ||
        themeData.platform == TargetPlatform.windows;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
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
                  _title,
                  style: Theme.of(context).textTheme.titleMedium,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: (model.isMobile)
                          ? (MediaQuery.of(context).orientation ==
                                    Orientation.portrait
                                ? 60.0
                                : 30)
                          : 0,
                    ),
                    child: SfTreemap(
                      // The number of data in your data source collection.
                      //
                      // The callback for the [weightValueMapper] and
                      // [TreemapLevel.groupMapper] will be called
                      // the number of times equal to the [dataCount].
                      dataCount: _statesGRPData.length,
                      // The value returned in the callback will specify the
                      // weight of each tile.
                      weightValueMapper: (int index) {
                        return _statesGRPData[index].grp;
                      },
                      colorMappers: _colorMappers,
                      tooltipSettings: TreemapTooltipSettings(
                        color: _isLightTheme
                            ? const Color.fromRGBO(45, 45, 45, 1)
                            : const Color.fromRGBO(242, 242, 242, 1),
                      ),
                      levels: _getTreemapLevels(themeData),
                      legend: TreemapLegend.bar(
                        position: model.isWebFullView
                            ? TreemapLegendPosition.bottom
                            : TreemapLegendPosition.top,
                        showPointerOnHover: true,
                        segmentSize: Size(
                          (constraints.maxWidth * (isDesktop ? 0.50 : 0.80)) /
                              _colorMappers.length,
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

  void _updateTitleBasedOnLocale() {
    if (model.locale == const Locale('ar', 'AE')) {
      _title = '2020 - تفاصيل GRP الحكيمة الدولة ألمانيا';
    } else {
      _title = 'Germany state wise GRP details - 2020';
    }
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
        groupMapper: (int index) => _statesGRPData[index].state,
        // Padding around the tile.
        // The value returned in the callback will specify the
        // color of each tile.
        colorValueMapper: (TreemapTile tile) {
          return tile.weight;
        },
        // Padding around the tile.
        padding: const EdgeInsets.all(1.0),
        // Returns a widget for each tile's data label.
        labelBuilder: (BuildContext context, TreemapTile tile) {
          final Brightness brightness = ThemeData.estimateBrightnessForColor(
            tile.color,
          );
          final Color color = brightness == Brightness.dark
              ? Colors.white
              : Colors.black;
          return Padding(
            padding: const EdgeInsetsDirectional.only(start: 4.0, top: 4.0),
            child: Text(
              model.locale == const Locale('ar', 'AE')
                  ? _statesGRPData[tile.indices[0]].stateLocale
                  : tile.group,
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
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 7.0, 10.0, 8.5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: model.locale == const Locale('ar', 'AE')
                            ? _statesGRPData[tile.indices[0]].stateLocale
                            : tile.group,
                        style: themeData.textTheme.bodySmall!.copyWith(
                          height: 1.5,
                          color: _isLightTheme
                              ? const Color.fromRGBO(255, 255, 255, 1)
                              : const Color.fromRGBO(10, 10, 10, 1),
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: '\n€' + tile.weight.toStringAsFixed(2) + 'B',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    ];
  }
}

class _StateGRP {
  _StateGRP(this.state, this.grp, this.stateLocale);

  final String state;
  final double grp;
  final String stateLocale;
}
