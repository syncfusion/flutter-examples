/// Dart import
import 'dart:async';

/// Package imports
import 'package:flutter/material.dart';

/// DataGrid import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Local import
import '../../../model/sample_view.dart';
import 'datagridsource/realtime_datagridsource.dart';

/// Renders real time value change data grid
class RealTimeUpdateDataGrid extends SampleView {
  /// Creates real time value change data grid
  const RealTimeUpdateDataGrid({Key? key}) : super(key: key);

  @override
  _RealTimeUpdateDataGridPageState createState() =>
      _RealTimeUpdateDataGridPageState();
}

class _RealTimeUpdateDataGridPageState extends SampleViewState {
  /// Used to refresh the widget for every 200ms respectively.
  late Timer timer;

  /// Decide whether to use the sample in  mobile or web mode.
  bool isLandscapeInMobileView = false;

  /// DataGridSource required for SfDataGrid to obtain the row data.
  late RealTimeUpdateDataGridSource realTimeUpdateDataGridSource;

  late bool isWebOrDesktop;

  @override
  void initState() {
    super.initState();
    isWebOrDesktop = model.isWeb || model.isDesktop;
    realTimeUpdateDataGridSource =
        RealTimeUpdateDataGridSource(isWebOrDesktop: isWebOrDesktop);
    timer = Timer.periodic(const Duration(milliseconds: 200), (Timer args) {
      realTimeUpdateDataGridSource.timerTick(args);
    });
  }

  SfDataGrid _buildDataGrid() {
    return SfDataGrid(
      source: realTimeUpdateDataGridSource,
      columnWidthMode: isWebOrDesktop || isLandscapeInMobileView
          ? ColumnWidthMode.fill
          : ColumnWidthMode.none,
      columns: <GridColumn>[
        GridColumn(
            columnName: 'symbol',
            width: (isWebOrDesktop && model.isMobileResolution)
                ? 150.0
                : double.nan,
            label: Container(
              alignment: Alignment.center,
              child: const Text('Symbol'),
            )),
        GridColumn(
          columnName: 'stock',
          width:
              (isWebOrDesktop && model.isMobileResolution) ? 150.0 : double.nan,
          label: Container(
            alignment: Alignment.center,
            child: const Text('Stock'),
          ),
        ),
        GridColumn(
          columnName: 'open',
          width:
              (isWebOrDesktop && model.isMobileResolution) ? 150.0 : double.nan,
          label: Container(
            alignment: Alignment.center,
            child: const Text(' Open'),
          ),
        ),
        GridColumn(
          width: (isWebOrDesktop && model.isMobileResolution) ? 150.0 : 130.0,
          columnName: 'previousClose',
          label: Container(
            alignment: Alignment.center,
            child: const Text('Previous Close'),
          ),
        ),
        GridColumn(
          columnName: 'lastTrade',
          width:
              (isWebOrDesktop && model.isMobileResolution) ? 150.0 : double.nan,
          label: Container(
            alignment: Alignment.center,
            child: const Text('Last Trade'),
          ),
        ),
      ],
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isLandscapeInMobileView = !isWebOrDesktop &&
        MediaQuery.of(context).orientation == Orientation.landscape;
  }

  @override
  Widget build(BuildContext context) {
    return _buildDataGrid();
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }
}
