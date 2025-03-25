/// Flutter package imports
// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';

/// Barcode imports
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Local imports
import '../../../model/sample_view.dart';
import 'datagridsource/employee_datagridsource.dart';

/// Renders data grid with row height
class RowHeightDataGrid extends SampleView {
  /// Creates data grid with row height
  const RowHeightDataGrid({Key? key}) : super(key: key);

  @override
  _RowHeightDataGridState createState() => _RowHeightDataGridState();
}

class _RowHeightDataGridState extends SampleViewState {
  /// DataGridSource required for SfDataGrid to obtain the row data.
  late EmployeeDataGridSource _rowHeightDataGridSource;

  late bool _isWebOrDesktop;

  Widget _buildDataGrid() {
    return SfDataGridTheme(
      data: const SfDataGridThemeData(gridLineStrokeWidth: 1.4),
      child: SfDataGrid(
        source: _rowHeightDataGridSource,
        rowHeight: 65.0,
        columns: <GridColumn>[
          GridColumn(
            columnName: 'id',
            width: _isWebOrDesktop ? 135 : 90,
            label: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              alignment: Alignment.centerLeft,
              child: const Text(
                'ID',
                softWrap: true,
                overflow: TextOverflow.clip,
              ),
            ),
          ),
          GridColumn(
            columnName: 'contactName',
            width: _isWebOrDesktop ? 135 : 140,
            label: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Contact Name',
                softWrap: true,
                overflow: TextOverflow.clip,
              ),
            ),
          ),
          GridColumn(
            columnName: 'companyName',
            width: _isWebOrDesktop ? 165 : 140,
            label: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Company Name',
                softWrap: true,
                overflow: TextOverflow.clip,
              ),
            ),
          ),
          GridColumn(
            columnName: 'address',
            width: _isWebOrDesktop ? 180 : 140,
            label: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Address',
                softWrap: true,
                overflow: TextOverflow.clip,
              ),
            ),
          ),
          GridColumn(
            columnName: 'city',
            width: _isWebOrDesktop ? 150 : 140,
            label: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              alignment: Alignment.centerLeft,
              child: const Text(
                'City',
                softWrap: true,
                overflow: TextOverflow.clip,
              ),
            ),
          ),
          GridColumn(
            columnName: 'country',
            width: _isWebOrDesktop ? 150 : 140,
            label: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Country',
                softWrap: true,
                overflow: TextOverflow.clip,
              ),
            ),
          ),
          GridColumn(
            columnName: 'designation',
            width: _isWebOrDesktop ? 150 : 140,
            label: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Designation',
                softWrap: true,
                overflow: TextOverflow.clip,
              ),
            ),
          ),
          GridColumn(
            columnName: 'postalCode',
            width: _isWebOrDesktop ? 150 : 140,
            label: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Postal Code',
                softWrap: true,
                overflow: TextOverflow.clip,
              ),
            ),
          ),
          GridColumn(
            columnName: 'phoneNumber',
            width: _isWebOrDesktop ? 150 : 140,
            label: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Phone Number',
                softWrap: true,
                overflow: TextOverflow.clip,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _isWebOrDesktop = model.isWeb || model.isDesktop;
    _rowHeightDataGridSource = EmployeeDataGridSource('RowHeight');
  }

  @override
  Widget build(BuildContext context) {
    return _buildDataGrid();
  }
}
