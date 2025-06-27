/// Package imports
import 'package:flutter/material.dart';

/// Barcode import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Local import
import '../../../model/sample_view.dart';
import 'datagridsource/team_datagridsource.dart';

/// Render getting started data grid
class GettingStartedDataGrid extends SampleView {
  /// Creates getting started data grid
  const GettingStartedDataGrid({Key? key}) : super(key: key);

  @override
  _GettingStartedDataGridState createState() => _GettingStartedDataGridState();
}

class _GettingStartedDataGridState extends SampleViewState {
  /// DataGridSource required for SfDataGrid to obtain the row data.
  final TeamDataGridSource _teamDataGridSource = TeamDataGridSource();

  /// DataGridSource required for SfDataGrid to obtain the row data.
  late EmployeeDataGridSource _employeeDataGridSource;

  late bool _isWebOrDesktop;

  SfDataGrid _buildDataGridForMobile() {
    return SfDataGrid(
      source: _teamDataGridSource,
      columnWidthMode: ColumnWidthMode.fill,
      rowHeight: 50,
      columns: <GridColumn>[
        GridColumn(
          columnName: 'image',
          width: 51,
          label: const SizedBox.shrink(),
        ),
        GridColumn(
          columnName: 'team',
          width: !_isWebOrDesktop ? 90 : double.nan,
          label: Container(
            alignment: Alignment.centerLeft,
            child: const Text('Team'),
          ),
        ),
        GridColumn(
          columnName: 'wins',
          label: const Center(child: Text('W')),
        ),
        GridColumn(
          columnName: 'losses',
          label: const Center(child: Text('L')),
        ),
        GridColumn(
          columnName: 'pct',
          label: const Center(child: Text('WPCT')),
        ),
        GridColumn(
          columnName: 'gb',
          label: const Center(child: Text('GB')),
        ),
      ],
    );
  }

  Widget buildLocationWidget(String location) {
    return Row(
      children: <Widget>[
        Image.asset('images/location.png'),
        Text(' ' + location),
      ],
    );
  }

  Widget buildTrustWidget(String trust) {
    return Row(
      children: <Widget>[
        Row(children: <Widget>[Image.asset('images/Perfect.png'), Text(trust)]),
      ],
    );
  }

  SfDataGrid _buildDataGridForWeb() {
    return SfDataGrid(
      source: _employeeDataGridSource,
      columns: <GridColumn>[
        GridColumn(
          width: 130,
          columnName: 'employeeName',
          label: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: const Text('Employee Name', overflow: TextOverflow.ellipsis),
          ),
        ),
        GridColumn(
          columnName: 'designation',
          width: (model.isWeb || model.isMacOS || model.isLinux) ? 150 : 130,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: const Text('Designation', overflow: TextOverflow.ellipsis),
          ),
        ),
        GridColumn(
          columnName: 'mail',
          width: 180.0,
          label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.centerLeft,
            child: const Text('Mail', overflow: TextOverflow.ellipsis),
          ),
        ),
        GridColumn(
          columnName: 'location',
          width: model.isLinux ? 120.0 : 105.0,
          label: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: const Text('Location', overflow: TextOverflow.ellipsis),
          ),
        ),
        GridColumn(
          columnName: 'status',
          label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: const Text('Status', overflow: TextOverflow.ellipsis),
          ),
        ),
        GridColumn(
          columnName: 'trustworthiness',
          width: 130,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Trustworthiness',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        GridColumn(
          columnName: 'softwareProficiency',
          width: 165,
          label: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Software Proficiency',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        GridColumn(
          columnName: 'salary',
          label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.centerRight,
            child: const Text('Salary', overflow: TextOverflow.ellipsis),
          ),
        ),
        GridColumn(
          columnName: 'address',
          width: 200,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: const Text('Address', overflow: TextOverflow.ellipsis),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _isWebOrDesktop = model.isWeb || model.isDesktop;
    _employeeDataGridSource = EmployeeDataGridSource();
  }

  @override
  Widget build(BuildContext context) {
    return _isWebOrDesktop ? _buildDataGridForWeb() : _buildDataGridForMobile();
  }
}
