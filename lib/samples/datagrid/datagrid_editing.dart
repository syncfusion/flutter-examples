/// Dart import
import 'dart:core';

/// Package import
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../model/sample_view.dart';

/// Local import
import 'datagridsource/dealer_datagridsource.dart';

/// Render data grid with editing.
class EditingDataGrid extends SampleView {
  /// Create data grid with editing.
  const EditingDataGrid({Key? key}) : super(key: key);

  @override
  _EditingDataGridState createState() => _EditingDataGridState();
}

class _EditingDataGridState extends SampleViewState {
  @override
  void initState() {
    super.initState();
    isWebOrDesktop = model.isWeb || model.isDesktop;
    editingDataGridSource = DealerDataGridSource(model);
    panelOpen = frontPanelVisible.value;
    frontPanelVisible.addListener(_subscribeToValueNotifier);
  }

  final ValueNotifier<bool> frontPanelVisible = ValueNotifier<bool>(true);
  void _subscribeToValueNotifier() => panelOpen = frontPanelVisible.value;
  bool panelOpen = false;

  /// DataGridSource of [SfDataGrid]
  late DealerDataGridSource editingDataGridSource;

  /// Determine to decide whether the device in landscape or in portrait.
  late bool isLandscapeInMobileView;

  /// Help to identify the desktop or mobile.
  late bool isWebOrDesktop;

  /// Determine the editing action on [SfDataGrid]
  EditingGestureType editingGestureType = EditingGestureType.doubleTap;

  SfDataGrid _buildDataGrid(BuildContext context) {
    return SfDataGrid(
      source: editingDataGridSource,
      allowEditing: true,
      navigationMode: GridNavigationMode.cell,
      selectionMode: SelectionMode.single,
      editingGestureType: editingGestureType,
      columnWidthMode: isWebOrDesktop
          ? (isWebOrDesktop && model.isMobileResolution)
              ? ColumnWidthMode.none
              : ColumnWidthMode.fill
          : isLandscapeInMobileView
              ? ColumnWidthMode.fill
              : ColumnWidthMode.none,
      columns: <GridColumn>[
        GridColumn(
            columnName: 'Product No',
            width: isWebOrDesktop ? double.nan : 110,
            label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.centerRight,
              child: const Text(
                'Product No',
                overflow: TextOverflow.ellipsis,
              ),
            )),
        GridColumn(
            columnName: 'Dealer Name',
            width: isWebOrDesktop ? double.nan : 110,
            label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Dealer Name',
                overflow: TextOverflow.ellipsis,
              ),
            )),
        GridColumn(
            columnName: 'Shipped Date',
            width: isWebOrDesktop ? double.nan : 110,
            label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.centerRight,
              child: const Text(
                'Shipped Date',
                overflow: TextOverflow.ellipsis,
              ),
            )),
        GridColumn(
            columnName: 'Ship Country',
            width: isWebOrDesktop ? double.nan : 110,
            label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Ship Country',
                overflow: TextOverflow.ellipsis,
              ),
            )),
        GridColumn(
            columnName: 'Ship City',
            width: isWebOrDesktop ? double.nan : 110,
            label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Ship City',
                overflow: TextOverflow.ellipsis,
              ),
            )),
        GridColumn(
            columnName: 'Price',
            label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.centerRight,
              child: const Text(
                'Price',
                overflow: TextOverflow.ellipsis,
              ),
            )),
      ],
    );
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              model.isWebFullView
                  ? 'Editing \ngesture type'
                  : 'Editing gesture type',
              softWrap: false,
              style: TextStyle(fontSize: 16.0, color: model.textColor),
            ),
            Theme(
              data: ThemeData(canvasColor: model.bottomSheetBackgroundColor),
              child: DropdownButton<String>(
                  focusColor: Colors.transparent,
                  value: editingGestureType.toString().split('.')[1],
                  items: <String>['tap', 'doubleTap'].map((String value) {
                    return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,
                            softWrap: false,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: model.textColor)));
                  }).toList(),
                  onChanged: (dynamic value) {
                    if (value == 'tap') {
                      editingGestureType = EditingGestureType.tap;
                    } else {
                      editingGestureType = EditingGestureType.doubleTap;
                    }
                    stateSetter(() {});
                    setState(() {});
                  }),
            )
          ]);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    editingDataGridSource.sampleModel = model;
    isLandscapeInMobileView = !isWebOrDesktop &&
        MediaQuery.of(context).orientation == Orientation.landscape;
  }

  @override
  Widget build(BuildContext context) {
    return _buildDataGrid(context);
  }
}
