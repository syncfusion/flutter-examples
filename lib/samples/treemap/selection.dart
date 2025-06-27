import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// Treemap import.
import 'package:syncfusion_flutter_treemap/treemap.dart';

/// Local import.
import '../../../model/sample_view.dart';

/// This sample demonstrates how to select a particular tile in the treemap.
class TreemapSelectionSample extends SampleView {
  /// Creates [TreemapSelectionSample].
  const TreemapSelectionSample(Key key) : super(key: key);

  @override
  _TreemapSelectionSampleState createState() => _TreemapSelectionSampleState();
}

class _TreemapSelectionSampleState extends SampleViewState {
  late List<_ImportAndExportDetails> _topImportsAndExports;
  late TextEditingController _importTextEditingController;
  late TextEditingController _exportTextEditingController;
  late bool isDesktop;
  TreemapTile? _selectedTile;

  @override
  void initState() {
    // Data source to the treemap.
    //
    // [valueInBillions] is used to get each tile's weight.
    // [type] is the first level grouping key.
    // [product] is the second level grouping key.
    _topImportsAndExports = <_ImportAndExportDetails>[
      const _ImportAndExportDetails(
        type: 'Import',
        product: 'Cars',
        valueInBillions: 145.66,
        color: Color.fromRGBO(64, 116, 218, 1.0),
      ),
      const _ImportAndExportDetails(
        type: 'Import',
        product: 'PC, optical readers',
        valueInBillions: 104.95,
        color: Color.fromRGBO(85, 126, 213, 1.0),
      ),
      const _ImportAndExportDetails(
        type: 'Import',
        product: 'Phone devices',
        valueInBillions: 102.55,
        color: Color.fromRGBO(98, 136, 217, 1.0),
      ),
      const _ImportAndExportDetails(
        type: 'Import',
        product: 'Medication',
        valueInBillions: 95.18,
        color: Color.fromRGBO(109, 145, 219, 1.0),
      ),
      const _ImportAndExportDetails(
        type: 'Import',
        product: 'Crude oil',
        valueInBillions: 81.86,
        color: Color.fromRGBO(121, 154, 222, 1.0),
      ),
      const _ImportAndExportDetails(
        type: 'Import',
        product: 'Automobile parts',
        valueInBillions: 81.63,
        color: Color.fromRGBO(134, 163, 225, 1.0),
      ),
      const _ImportAndExportDetails(
        type: 'Import',
        product: 'Blood fractions',
        valueInBillions: 60.04,
        color: Color.fromRGBO(158, 181, 230, 1.0),
      ),
      const _ImportAndExportDetails(
        type: 'Import',
        product: 'Petroleum oils',
        valueInBillions: 51.38,
        color: Color.fromRGBO(171, 191, 234, 1.0),
      ),
      const _ImportAndExportDetails(
        type: 'Import',
        product: 'Gold',
        valueInBillions: 36.32,
        color: Color.fromRGBO(182, 200, 236, 1.0),
      ),
      const _ImportAndExportDetails(
        type: 'Import',
        product: 'IC',
        valueInBillions: 34.69,
        color: Color.fromRGBO(202, 215, 241, 1.0),
      ),
      const _ImportAndExportDetails(
        type: 'Export',
        product: 'Petroleum oils',
        valueInBillions: 60.71,
        color: Color.fromRGBO(83, 192, 83, 1.0),
      ),
      const _ImportAndExportDetails(
        type: 'Export',
        product: 'Crude oil',
        valueInBillions: 50.29,
        color: Color.fromRGBO(121, 193, 106, 1.0),
      ),
      const _ImportAndExportDetails(
        type: 'Export',
        product: 'Cars',
        valueInBillions: 45.64,
        color: Color.fromRGBO(129, 197, 115, 1.0),
      ),
      const _ImportAndExportDetails(
        type: 'Export',
        product: 'IC',
        valueInBillions: 44.21,
        color: Color.fromRGBO(138, 201, 126, 1.0),
      ),
      const _ImportAndExportDetails(
        type: 'Export',
        product: 'Petroleum gases',
        valueInBillions: 33.34,
        color: Color.fromRGBO(147, 205, 136, 1.0),
      ),
      const _ImportAndExportDetails(
        type: 'Export',
        product: 'Automobile parts',
        valueInBillions: 33.17,
        color: Color.fromRGBO(156, 210, 146, 1.0),
      ),
      const _ImportAndExportDetails(
        type: 'Export',
        product: 'Phone devices',
        valueInBillions: 28.09,
        color: Color.fromRGBO(165, 214, 156, 1.0),
      ),
      const _ImportAndExportDetails(
        type: 'Export',
        product: 'Electro-medical',
        valueInBillions: 28.02,
        color: Color.fromRGBO(174, 218, 166, 1.0),
      ),
      const _ImportAndExportDetails(
        type: 'Export',
        product: 'Blood fractions',
        valueInBillions: 26.09,
        color: Color.fromRGBO(184, 222, 177, 1.0),
      ),
      const _ImportAndExportDetails(
        type: 'Export',
        product: 'Soya beans',
        valueInBillions: 25.85,
        color: Color.fromRGBO(202, 231, 198, 1.0),
      ),
    ];

    _importTextEditingController = TextEditingController();
    _exportTextEditingController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _topImportsAndExports.clear();
    _importTextEditingController.dispose();
    _exportTextEditingController.dispose();
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
              'Top 10 Imports and Exports of USA 2020',
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
                  dataCount: _topImportsAndExports.length,
                  // The value returned in the callback will specify the
                  // weight of each tile.
                  weightValueMapper: (int index) {
                    return _topImportsAndExports[index].valueInBillions;
                  },
                  // The callback will be called while doing selection on the
                  // tile.
                  onSelectionChanged: (TreemapTile tile) {
                    _updateLabelBuilderText(tile);
                  },
                  tileHoverBorder: const RoundedRectangleBorder(
                    side: BorderSide(
                      width: 2,
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                    ),
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

  void _updateLabelBuilderText(TreemapTile tile) {
    if (tile != _selectedTile) {
      _selectedTile = tile;
      if (_topImportsAndExports[tile.indices[0]].type == 'Import') {
        _importTextEditingController.text = tile.group == 'Import'
            ? 'Import - ${tile.weight.toStringAsFixed(2)}B'
            : 'Import -  ${tile.group} (${tile.weight.toStringAsFixed(2)}B)';
        _exportTextEditingController.text = 'Export';
      } else {
        _exportTextEditingController.text = tile.group == 'Export'
            ? 'Export - ${tile.weight.toStringAsFixed(2)}B'
            : 'Export -  ${tile.group} (${tile.weight.toStringAsFixed(2)}B)';
        _importTextEditingController.text = 'Import';
      }
    } else {
      _selectedTile = null;
      if (_topImportsAndExports[tile.indices[0]].type == 'Import') {
        _importTextEditingController.text =
            _topImportsAndExports[tile.indices[0]].type!;
      } else {
        _exportTextEditingController.text =
            _topImportsAndExports[tile.indices[0]].type!;
      }
    }
  }

  List<TreemapLevel> _getTreemapLevels() {
    return <TreemapLevel>[
      TreemapLevel(
        // Used for grouping the tiles based on the value returned from
        // this callback.
        //
        // Once grouped, we will get [labelBuilder] and [colorValueMapper]
        // callbacks respectively.
        groupMapper: (int index) {
          return _topImportsAndExports[index].type;
        },
        // Padding around the tile.
        padding: const EdgeInsets.all(2.0),
        color: Colors.transparent,
        // Returns a widget for each tile's data label.
        labelBuilder: (BuildContext context, TreemapTile tile) {
          final Brightness brightness = ThemeData.estimateBrightnessForColor(
            tile.color,
          );
          final Color color = brightness == Brightness.dark
              ? Colors.white
              : Colors.black;
          if (tile.group == 'Import') {
            _importTextEditingController.text = tile.group;
            return Padding(
              padding: const EdgeInsets.only(bottom: 1.0),
              child: IgnorePointer(
                child: ColoredBox(
                  color: const Color.fromRGBO(52, 94, 176, 1.0),
                  child: Center(
                    child: TextField(
                      controller: _importTextEditingController,
                      enabled: false,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: color),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            _exportTextEditingController.text = tile.group;
            return Padding(
              padding: const EdgeInsets.only(bottom: 1.0),
              child: IgnorePointer(
                child: Container(
                  color: const Color.fromRGBO(67, 156, 67, 1.0),
                  child: Center(
                    child: TextField(
                      controller: _exportTextEditingController,
                      enabled: false,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: color),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
      TreemapLevel(
        // Used for grouping the tiles based on the value returned from
        // this callback.
        //
        // Once grouped, we will get [labelBuilder] and [colorValueMapper]
        // callbacks respectively.
        groupMapper: (int index) {
          return _topImportsAndExports[index].product;
        },
        // Padding around the tile.
        padding: EdgeInsets.zero,
        // Border around the tile.
        border: const RoundedRectangleBorder(
          side: BorderSide(color: Colors.transparent),
        ),
        // The value returned in the callback will specify the
        // color of each tile.
        colorValueMapper: (TreemapTile tile) {
          return _topImportsAndExports[tile.indices[0]].color;
        },
        // Returns a widget for each tile's data label.
        labelBuilder: (BuildContext context, TreemapTile tile) {
          final Brightness brightness = ThemeData.estimateBrightnessForColor(
            tile.color,
          );
          final Color color = brightness == Brightness.dark
              ? Colors.white
              : Colors.black;
          return IgnorePointer(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                child: Text(
                  tile.group,
                  style: TextStyle(color: color),
                  softWrap: isDesktop,
                  overflow: isDesktop
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                ),
              ),
            ),
          );
        },
      ),
    ];
  }
}

class _ImportAndExportDetails {
  const _ImportAndExportDetails({
    required this.valueInBillions,
    this.type,
    this.product,
    this.color,
  });

  final String? type;
  final String? product;
  final double valueInBillions;
  final Color? color;
}
