import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// Treemap import.
import 'package:syncfusion_flutter_treemap/treemap.dart';

/// Local import.
import '../../../model/sample_view.dart';

/// This sample demonstrates how to apply color to the tiles based on the
/// specific value.
class TreemapLocalizationPage extends LocalizationSampleView {
  /// Creates [TreemapLocalizationPage].
  const TreemapLocalizationPage(Key key) : super(key: key);

  @override
  _TreemapLocalizationPageState createState() =>
      _TreemapLocalizationPageState();
}

class _TreemapLocalizationPageState extends LocalizationSampleViewState {
  late List<_State> _statesAreaData;
  late bool _isLightTheme;
  late bool _isDesktop;
  late String _title;

  @override
  void dispose() {
    _statesAreaData.clear();
    super.dispose();
  }

  @override
  Widget buildSample(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    _isLightTheme = themeData.colorScheme.brightness == Brightness.light;
    _isDesktop =
        kIsWeb ||
        themeData.platform == TargetPlatform.macOS ||
        themeData.platform == TargetPlatform.linux ||
        themeData.platform == TargetPlatform.windows;
    _loadTreeMapData();

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Center(
          child: Padding(
            padding:
                MediaQuery.of(context).orientation == Orientation.portrait ||
                    _isDesktop
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
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 8.0,
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
                      key: UniqueKey(),
                      dataCount: _statesAreaData.length,
                      // The value returned in the callback will specify the
                      // weight of each tile.
                      weightValueMapper: (int index) {
                        return _statesAreaData[index].areaInSqKm;
                      },
                      tooltipSettings: TreemapTooltipSettings(
                        color: _isLightTheme
                            ? const Color.fromRGBO(45, 45, 45, 1)
                            : const Color.fromRGBO(242, 242, 242, 1),
                      ),
                      levels: _getTreemapLevels(themeData),
                      legend: TreemapLegend(
                        position: model.isWebFullView
                            ? TreemapLegendPosition.bottom
                            : TreemapLegendPosition.top,
                        iconType: TreemapIconType.diamond,
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

  void _loadTreeMapData() {
    if (model.locale == const Locale('en', 'US')) {
      _statesAreaData = <_State>[
        const _State(
          0.809,
          Color.fromRGBO(255, 215, 0, 1.0),
          'New South Wales',
        ),
        const _State(1.857, Color.fromRGBO(72, 209, 204, 1.0), 'Queensland'),
        const _State(
          1.419,
          Color.fromRGBO(255, 78, 66, 1.0),
          'Northern Territory',
        ),
        const _State(0.237, Color.fromRGBO(171, 56, 224, 0.75), 'Victoria'),
        const _State(
          1.044,
          Color.fromRGBO(126, 247, 74, 0.75),
          'South Australia',
        ),
        const _State(
          2.642,
          Color.fromRGBO(79, 60, 201, 0.7),
          'Western Australia',
        ),
        const _State(0.0907, Color.fromRGBO(99, 164, 230, 1), 'Tasmania'),
        const _State(0.0023, Colors.teal, 'Australian Capital Territory'),
      ];
      _title = 'Australia - Land Area (sq. Km)';
    }
    //Arabic.
    else if (model.locale == const Locale('ar', 'AE')) {
      _statesAreaData = <_State>[
        const _State(0.809, Color.fromRGBO(255, 215, 0, 1.0), 'نيو ساوث ويلز'),
        const _State(1.857, Color.fromRGBO(72, 209, 204, 1.0), 'كوينزلاند'),
        const _State(
          1.419,
          Color.fromRGBO(255, 78, 66, 1.0),
          'الإقليم الشمالي',
        ),
        const _State(0.237, Color.fromRGBO(171, 56, 224, 0.75), 'فيكتوريا'),
        const _State(
          1.044,
          Color.fromRGBO(126, 247, 74, 0.75),
          'جنوب استراليا',
        ),
        const _State(
          2.642,
          Color.fromRGBO(79, 60, 201, 0.7),
          'القسم الغربي من استراليا',
        ),
        const _State(0.0907, Color.fromRGBO(99, 164, 230, 1), 'تسمانيا'),
        const _State(0.0023, Colors.teal, 'إقليم العاصمة الأسترالية'),
      ];
      _title = '(كيلومتر مربع) - مساحة الأرض أستراليا';
    }
    //French.
    else if (model.locale == const Locale('fr', 'FR')) {
      _statesAreaData = <_State>[
        const _State(
          0.809,
          Color.fromRGBO(255, 215, 0, 1.0),
          'Nouvelle Galles du Sud',
        ),
        const _State(1.857, Color.fromRGBO(72, 209, 204, 1.0), 'Queensland'),
        const _State(
          1.419,
          Color.fromRGBO(255, 78, 66, 1.0),
          'Territoire du Nord',
        ),
        const _State(0.237, Color.fromRGBO(171, 56, 224, 0.75), 'Victoria'),
        const _State(
          1.044,
          Color.fromRGBO(126, 247, 74, 0.75),
          'Le sud de lAustralie',
        ),
        const _State(
          2.642,
          Color.fromRGBO(79, 60, 201, 0.7),
          'Australie occidentale',
        ),
        const _State(0.0907, Color.fromRGBO(99, 164, 230, 1), 'Tasmanie'),
        const _State(
          0.0023,
          Colors.teal,
          'Territoire de la capitale australienne',
        ),
      ];
      _title = 'Australie - Superficie terrestre (km²)';
    }
    //Chinese.
    else if (model.locale == const Locale('zh', 'CN')) {
      _statesAreaData = <_State>[
        const _State(0.809, Color.fromRGBO(255, 215, 0, 1.0), '新南威尔士州'),
        const _State(1.857, Color.fromRGBO(72, 209, 204, 1.0), '昆士兰'),
        const _State(1.419, Color.fromRGBO(255, 78, 66, 1.0), '北方领土'),
        const _State(0.237, Color.fromRGBO(171, 56, 224, 0.75), '维多利亚'),
        const _State(1.044, Color.fromRGBO(126, 247, 74, 0.75), '南澳大利亚'),
        const _State(2.642, Color.fromRGBO(79, 60, 201, 0.7), '澳大利亚西部'),
        const _State(0.0907, Color.fromRGBO(99, 164, 230, 1), '塔斯马尼亚'),
        const _State(0.0023, Colors.teal, '澳大利亚首都领地'),
      ];
      _title = '澳大利亚 - 土地面积（平方公里）';
    }
    //Spanish.
    else {
      _statesAreaData = <_State>[
        const _State(
          0.809,
          Color.fromRGBO(255, 215, 0, 1.0),
          'Nueva Gales del Sur',
        ),
        const _State(1.857, Color.fromRGBO(72, 209, 204, 1.0), 'Queensland'),
        const _State(
          1.419,
          Color.fromRGBO(255, 78, 66, 1.0),
          'Territorio del Norte',
        ),
        const _State(0.237, Color.fromRGBO(171, 56, 224, 0.75), 'Victoria'),
        const _State(
          1.044,
          Color.fromRGBO(126, 247, 74, 0.75),
          'Sur de Australia',
        ),
        const _State(
          2.642,
          Color.fromRGBO(79, 60, 201, 0.7),
          'El oeste de Australia',
        ),
        const _State(0.0907, Color.fromRGBO(99, 164, 230, 1), 'Tasmania'),
        const _State(
          0.0023,
          Colors.teal,
          'Territorio de la Capital Australiana',
        ),
      ];
      _title = 'Australia - Superficie terrestre (kilómetros cuadrados)';
    }
  }

  List<TreemapLevel> _getTreemapLevels(ThemeData themeData) {
    return <TreemapLevel>[
      TreemapLevel(
        // Used for grouping the tiles based on the value returned from
        // this callback.
        //
        // Once grouped, we will get [labelBuilder], [tooltipBuilder], and
        // [colorValueMapper] callbacks respectively.
        groupMapper: (int index) => _statesAreaData[index].state,
        // Padding around the tile.
        // The value returned in the callback will specify the
        // color of each tile.
        colorValueMapper: (TreemapTile tile) {
          return _statesAreaData[tile.indices[0]].color;
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
          final Color textColor = _isLightTheme
              ? const Color.fromRGBO(255, 255, 255, 1)
              : const Color.fromRGBO(10, 10, 10, 1);
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 7.0, 10.0, 8.5),
                child: IntrinsicWidth(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        tile.group,
                        textDirection: TextDirection.ltr,
                        style: themeData.textTheme.bodySmall!.copyWith(
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        tile.weight.toString() + 'M sq. km',
                        textDirection: TextDirection.ltr,
                        style: themeData.textTheme.bodySmall!.copyWith(
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ];
  }
}

class _State {
  const _State(this.areaInSqKm, this.color, this.state);
  final String state;
  final Color color;
  final double areaInSqKm;
}
