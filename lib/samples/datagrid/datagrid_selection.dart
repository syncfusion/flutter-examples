/// Package imports
import 'package:flutter/material.dart';

/// Barcode import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Local import
import '../../../model/sample_view.dart';
import 'datagridsource/orderinfo_datagridsource.dart';

/// Renders datagrid with selection option(single/multiple and select/unselect)
class SelectionDataGrid extends SampleView {
  /// Creates datagrid with selection option(single/multiple and select/unselect)
  const SelectionDataGrid({Key? key}) : super(key: key);

  @override
  _SelectionDataGridPageState createState() => _SelectionDataGridPageState();
}

class _SelectionDataGridPageState extends SampleViewState {
  /// Determine to decide whether the device in landscape or in portrait.
  bool _isLandscapeInMobileView = false;

  /// Determine the selection mode of SfDatGrid.
  SelectionMode selectionMode = SelectionMode.multiple;
  String _selectionMode = '';

  /// Determine the navigation mode of SfDatGrid.
  GridNavigationMode navigationMode = GridNavigationMode.cell;
  String _navigationMode = '';

  /// DataGridSource required for SfDataGrid to obtain the row data.
  late OrderInfoDataGridSource _selectionDataGridSource;

  final DataGridController _dataGridController = DataGridController();

  late bool _isWebOrDesktop;

  /// Selection modes for drop down widget
  final List<String> _encoding = <String>[
    'none',
    'single',
    'singleDeselect',
    'multiple',
  ];

  /// Navigation modes for drop down widget
  final List<String> _navigation = <String>['cell', 'row'];

  /// DataGridController to do the programmatical selection.
  DataGridController _buildDataGridController() {
    _dataGridController.selectedRows.add(
      _selectionDataGridSource.dataGridRows[2],
    );
    _dataGridController.selectedRows.add(
      _selectionDataGridSource.dataGridRows[4],
    );
    _dataGridController.selectedRows.add(
      _selectionDataGridSource.dataGridRows[6],
    );
    return _dataGridController;
  }

  void _onSelectionModeChanged(String item) {
    _selectionMode = item;
    switch (_selectionMode) {
      case 'none':
        selectionMode = SelectionMode.none;
        break;
      case 'single':
        selectionMode = SelectionMode.single;
        break;
      case 'singleDeselect':
        selectionMode = SelectionMode.singleDeselect;
        break;
      case 'multiple':
        selectionMode = SelectionMode.multiple;
        break;
    }
    setState(() {
      /// update the selection mode changes
    });
  }

  void _onNavigationModeChanged(String item) {
    _navigationMode = item;
    switch (_navigationMode) {
      case 'cell':
        navigationMode = GridNavigationMode.cell;
        break;
      case 'row':
        navigationMode = GridNavigationMode.row;
        break;
    }
    setState(() {
      /// update the grid navigation changes
    });
  }

  List<GridColumn> _obtainColumns() {
    List<GridColumn> columns;

    columns = _isWebOrDesktop
        ? <GridColumn>[
            GridColumn(
              width: (_isWebOrDesktop && model.isMobileResolution)
                  ? 120.0
                  : double.nan,
              columnName: 'id',
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerRight,
                child: const Text('Order ID', overflow: TextOverflow.ellipsis),
              ),
            ),
            GridColumn(
              width: (_isWebOrDesktop && model.isMobileResolution)
                  ? 150.0
                  : double.nan,
              columnName: 'customerId',
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerRight,
                child: const Text(
                  'Customer ID',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            GridColumn(
              width: (_isWebOrDesktop && model.isMobileResolution)
                  ? 120.0
                  : double.nan,
              columnName: 'name',
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerLeft,
                child: const Text('Name', overflow: TextOverflow.ellipsis),
              ),
            ),
            GridColumn(
              width: (_isWebOrDesktop && model.isMobileResolution)
                  ? 110.0
                  : double.nan,
              columnName: 'freight',
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerRight,
                child: const Text('Freight', overflow: TextOverflow.ellipsis),
              ),
            ),
            GridColumn(
              width: (_isWebOrDesktop && model.isMobileResolution)
                  ? 120.0
                  : double.nan,
              columnName: 'city',
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerLeft,
                child: const Text('City', overflow: TextOverflow.ellipsis),
              ),
            ),
            GridColumn(
              width: (_isWebOrDesktop && model.isMobileResolution)
                  ? 120.0
                  : double.nan,
              columnName: 'price',
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerRight,
                child: const Text('Price', overflow: TextOverflow.ellipsis),
              ),
            ),
          ]
        : <GridColumn>[
            GridColumn(
              columnName: 'id',
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerRight,
                child: const Text('Order ID', overflow: TextOverflow.ellipsis),
              ),
            ),
            GridColumn(
              columnName: 'customerId',
              width: 110,
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerRight,
                child: const Text(
                  'Customer ID',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            GridColumn(
              columnName: 'name',
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerLeft,
                child: const Text('Name', overflow: TextOverflow.ellipsis),
              ),
            ),
            GridColumn(
              columnName: 'city',
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerLeft,
                child: const Text('City', overflow: TextOverflow.ellipsis),
              ),
              columnWidthMode: ColumnWidthMode.lastColumnFill,
            ),
          ];
    return columns;
  }

  SfDataGrid _buildDataGrid(
    SelectionMode selectionMode,
    GridNavigationMode navigationMode,
  ) {
    return SfDataGrid(
      columnWidthMode: _isWebOrDesktop || _isLandscapeInMobileView
          ? ColumnWidthMode.fill
          : ColumnWidthMode.none,
      source: _selectionDataGridSource,
      selectionMode: selectionMode,
      navigationMode: navigationMode,
      controller: _buildDataGridController(),
      columns: _obtainColumns(),
    );
  }

  @override
  void initState() {
    super.initState();
    _isWebOrDesktop = model.isWeb || model.isDesktop;
    _selectionMode = 'multiple';
    selectionMode = SelectionMode.multiple;
    _navigationMode = _isWebOrDesktop ? 'cell' : 'row';
    navigationMode = _isWebOrDesktop
        ? GridNavigationMode.cell
        : GridNavigationMode.row;
    _selectionDataGridSource = OrderInfoDataGridSource(
      isWebOrDesktop: _isWebOrDesktop,
      orderDataCount: 100,
    );
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: SizedBox(
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: _isWebOrDesktop ? 100 : 175,
                      child: Text(
                        model.isWebFullView
                            ? 'Selection \nmode'
                            : 'Selection mode',
                        softWrap: false,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: model.textColor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        height: 40,
                        alignment: Alignment.bottomLeft,
                        child: DropdownButton<String>(
                          dropdownColor: model.drawerBackgroundColor,
                          focusColor: Colors.transparent,
                          underline: Container(
                            color: const Color(0xFFBDBDBD),
                            height: 1,
                          ),
                          value: _selectionMode,
                          items: _encoding.map((String value) {
                            return DropdownMenuItem<String>(
                              value: (value != null) ? value : 'multiple',
                              child: Text(
                                value,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: model.textColor),
                              ),
                            );
                          }).toList(),
                          onChanged: (dynamic value) {
                            _onSelectionModeChanged(value);
                            stateSetter(() {});
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: _selectionDropDown(stateSetter),
            ),
          ],
        );
      },
    );
  }

  Widget _selectionDropDown(StateSetter stateSetter) {
    return SizedBox(
      child: Row(
        children: <Widget>[
          SizedBox(
            width: _isWebOrDesktop ? 100 : 175,
            child: Text(
              model.isWebFullView ? 'Navigation \nmode' : 'Navigation mode',
              softWrap: false,
              style: TextStyle(fontSize: 16.0, color: model.textColor),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              height: 40,
              alignment: Alignment.bottomLeft,
              child: DropdownButton<String>(
                dropdownColor: model.drawerBackgroundColor,
                focusColor: Colors.transparent,
                underline: Container(color: const Color(0xFFBDBDBD), height: 1),
                value: _navigationMode,
                items: _navigation.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: model.textColor),
                    ),
                  );
                }).toList(),
                onChanged: (dynamic value) {
                  _onNavigationModeChanged(value);
                  stateSetter(() {});
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isLandscapeInMobileView =
        !_isWebOrDesktop &&
        MediaQuery.of(context).orientation == Orientation.landscape;
  }

  @override
  Widget build(BuildContext context) {
    return _buildDataGrid(selectionMode, navigationMode);
  }
}
