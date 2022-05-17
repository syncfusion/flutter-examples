/// Flutter package imports
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

/// Barcode imports
// ignore: depend_on_referenced_packages
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
  late EmployeeDataGridSource rowHeightDataGridSource;

  late bool isWebOrDesktop;

  Widget _buildDataGrid() {
    return SfDataGridTheme(
      data: SfDataGridThemeData(
        brightness: model.themeData.colorScheme.brightness,
        gridLineStrokeWidth: 1.4,
      ),
      child: SfDataGrid(
          source: rowHeightDataGridSource,
          rowHeight: 65.0,
          columns: <GridColumn>[
            GridColumn(
              columnName: 'id',
              width: isWebOrDesktop ? 135 : 90,
              label: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
              width: isWebOrDesktop ? 135 : 140,
              label: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
              width: isWebOrDesktop ? 165 : 140,
              label: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
              width: isWebOrDesktop ? 180 : 140,
              label: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
              width: isWebOrDesktop ? 150 : 140,
              label: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
              width: isWebOrDesktop ? 150 : 140,
              label: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
              width: isWebOrDesktop ? 150 : 140,
              label: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
              width: isWebOrDesktop ? 150 : 140,
              label: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
              width: isWebOrDesktop ? 150 : 140,
              label: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Phone Number',
                  softWrap: true,
                  overflow: TextOverflow.clip,
                ),
              ),
            ),
          ]),
    );
  }

  @override
  void initState() {
    super.initState();
    isWebOrDesktop = model.isWeb || model.isDesktop;
    rowHeightDataGridSource = EmployeeDataGridSource('RowHeight');
  }

  @override
  Widget build(BuildContext context) {
    return _buildDataGrid();
  }
}
