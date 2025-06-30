/// Packages import
import 'package:flutter/material.dart';

/// DataGrid import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Local import
import '../../../model/sample_view.dart';
import '../datagridsource/employee_datagridsource.dart';

/// Renders column type data grid
class JsonDataSourceDataGrid extends SampleView {
  /// Creates column type data grid
  const JsonDataSourceDataGrid({Key? key}) : super(key: key);

  @override
  _JsonDataSourceDataGridState createState() => _JsonDataSourceDataGridState();
}

class _JsonDataSourceDataGridState extends SampleViewState {
  /// DataGridSource Required for SfDataGrid to obtain the row data.
  late EmployeeDataGridSource _jsonDataGridSource;

  late bool _isWebOrDesktop;

  Widget sampleWidget() => const JsonDataSourceDataGrid();

  List<GridColumn> _obtainColumns() {
    List<GridColumn> columns;
    columns = <GridColumn>[
      GridColumn(
        columnName: 'id',
        width: _isWebOrDesktop ? 135 : 90,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: const Text('ID', overflow: TextOverflow.clip, softWrap: true),
        ),
      ),
      GridColumn(
        columnName: 'contactName',
        width: 150,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Contact Name',
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),
      GridColumn(
        columnName: 'companyName',
        width: _isWebOrDesktop ? 165 : 140,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Company',
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),
      GridColumn(
        columnName: 'city',
        width: _isWebOrDesktop ? 150 : 120,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: const Text(
            'City',
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),
      GridColumn(
        columnName: 'country',
        width: _isWebOrDesktop ? 150 : 120,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Country',
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),
      GridColumn(
        columnName: 'designation',
        width: 170,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Job Title',
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),
      GridColumn(
        columnName: 'postalCode',
        width: 110,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: const Text('Postal Code'),
        ),
      ),
      GridColumn(
        columnName: 'phoneNumber',
        width: 150,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerRight,
          child: const Text('Phone Number'),
        ),
      ),
    ];
    return columns;
  }

  @override
  void initState() {
    super.initState();
    _isWebOrDesktop = model.isWeb || model.isDesktop;
    _jsonDataGridSource = EmployeeDataGridSource('JSON');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: Future<String>.delayed(
        const Duration(milliseconds: 500),
        () => 'Loaded',
      ),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return _jsonDataGridSource.employees.isEmpty
            ? const Center(child: CircularProgressIndicator(strokeWidth: 3))
            : SfDataGrid(
                source: _jsonDataGridSource,
                columns: _obtainColumns(),
              );
      },
    );
  }
}
