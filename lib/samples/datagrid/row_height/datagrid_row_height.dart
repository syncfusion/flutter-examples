/// Flutter package imports
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// Barcode imports
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

/// Local imports
import '../../../model/sample_view.dart';

/// Renders data grid with row height
class RowHeightDataGrid extends SampleView {
  /// Creates data grid with row height
  const RowHeightDataGrid({Key? key}) : super(key: key);

  @override
  _RowHeightDataGridState createState() => _RowHeightDataGridState();
}

class _RowHeightDataGridState extends SampleViewState {
  /// DataGridSource required for SfDataGrid to obtain the row data.
  _RowHeightDataGridSource rowHeightDataGridSource = _RowHeightDataGridSource();

  late bool isWebOrDesktop;

  Widget _buildDataGrid() {
    return SfDataGridTheme(
      data: SfDataGridThemeData(
        brightness: SfTheme.of(context).brightness,
        gridLineStrokeWidth: 1.4,
      ),
      child: SfDataGrid(
          source: rowHeightDataGridSource,
          rowHeight: 65.0,
          columns: <GridColumn>[
            GridTextColumn(
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
            GridTextColumn(
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
            GridTextColumn(
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
            GridTextColumn(
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
            GridTextColumn(
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
            GridTextColumn(
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
            GridTextColumn(
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
            GridTextColumn(
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
            GridTextColumn(
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildDataGrid());
  }
}

class _Employee {
  _Employee(
      this.id,
      this.contactName,
      this.companyName,
      this.address,
      this.city,
      this.country,
      this.designation,
      this.postalCode,
      this.phoneNumber);
  final String id;
  final String contactName;
  final String companyName;
  final String address;
  final String city;
  final String country;
  final String designation;
  final String postalCode;
  final String phoneNumber;
}

class _RowHeightDataGridSource extends DataGridSource {
  _RowHeightDataGridSource() {
    employees = getEmployees();
    buildDataGridRow();
  }

  List<_Employee> employees = <_Employee>[];
  List<DataGridRow> dataGridRows = <DataGridRow>[];

  // Building DataGridRows

  void buildDataGridRow() {
    dataGridRows = employees.map<DataGridRow>((_Employee employee) {
      return DataGridRow(cells: <DataGridCell<String>>[
        DataGridCell<String>(columnName: 'id', value: employee.id),
        DataGridCell<String>(
            columnName: 'contactName', value: employee.contactName),
        DataGridCell<String>(
            columnName: 'companyName', value: employee.companyName),
        DataGridCell<String>(columnName: 'address', value: employee.address),
        DataGridCell<String>(columnName: 'city', value: employee.city),
        DataGridCell<String>(columnName: 'country', value: employee.country),
        DataGridCell<String>(
            columnName: 'designation', value: employee.designation),
        DataGridCell<String>(
            columnName: 'postalCode', value: employee.postalCode),
        DataGridCell<String>(
            columnName: 'phoneNumber', value: employee.phoneNumber),
      ]);
    }).toList();
  }

  // Overrides

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((DataGridCell dataCell) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16),
        alignment: Alignment.centerLeft,
        child: Text(dataCell.value.toString()),
      );
    }).toList());
  }

  // Employee Data collection set.

  List<_Employee> getEmployees() {
    return <_Employee>[
      _Employee('ALFKI', 'Maria Anders', 'Alfreds Futterkiste', 'Obere Str. 57',
          'Berlin', 'Germany', 'Sales Representative', '12209', '030-0074321'),
      _Employee(
          'ANATR',
          'Ana Trujillo',
          'Ana Trujillo Emparedados',
          'Avda. de la Constitución 2222',
          'México D.F.',
          'Mexico',
          'Owner',
          '05021',
          '(5) 555-4729'),
      _Employee(
          'ANTON',
          'Antonio Moreno',
          'Antonio Moreno Taquería',
          'Mataderos  2312',
          'México D.F',
          'Mexico',
          'Owner',
          '05023',
          '(5) 555-3932'),
      _Employee('AROUT', 'Thomas Hardy', 'Around the Horn', '120 Hanover Sq.',
          'London', 'UK', 'Sales Representative', 'WA1 1DP', '(71) 555-7788'),
      _Employee(
          'BERGS',
          'Christina Berglund',
          'Berglunds snabbköp',
          'Berguvsvägen  8',
          'Luleå',
          'Sweden',
          'Order Administrator',
          'S-958 22',
          '0921-12 34 65'),
      _Employee(
          'BLAUS',
          'Hanna Moos',
          'Blauer See Delikatessen',
          'Forsterstr. 57',
          'Mannheim',
          'Germany',
          'Sales Representative',
          '68306',
          '0621-08460'),
      _Employee(
          'BLONP',
          'Frédérique Citeaux',
          'Blondel père et fils',
          '24, place Kléber',
          'Strasbourg',
          'France',
          'Marketing Manager',
          '67000',
          '88.60.15.31'),
      _Employee(
          'BOLID',
          'Martín Sommer',
          'Bólido Comidas preparadas',
          'C/ Araquil, 67',
          'Madrid',
          'Spain',
          'Marketing Manager' 'Owner',
          '28023',
          '(91) 555 22 82'),
      _Employee(
          'BONAP',
          'Laurence Lebihan',
          ''' Bon app' ''',
          '12, rue des Bouchers',
          'Marseille',
          'France',
          'Owner',
          '13008',
          '91.24.45.40'),
      _Employee(
          'BOTTM',
          'Elizabeth Lincoln',
          'Bottom-Dollar Markets',
          '23 Tsawassen Blvd.',
          'Tsawassen',
          'Canada',
          'Accounting Manager',
          'T2F 8M4',
          '(604) 555-4729'),
      _Employee(
          'BSBEV',
          'Victoria Ashworth',
          '''B's Beverages''',
          'Fauntleroy Circus',
          'London',
          'UK',
          'Sales Representative',
          'EC2 5NT',
          '(71) 555-1212'),
      _Employee(
          'CACTU',
          'Patricio Simpson',
          'Cactus Comidas para llevar',
          'Cerrito 333',
          'Buenos Aires',
          'Argentina',
          'Sales Agent',
          '1010',
          '(1) 135-5555'),
      _Employee(
          'CENTC',
          'Francisco Chang',
          'Centro comercial Moctezuma',
          'Sierras de Granada 9993',
          'México D.F.',
          'Mexico',
          'Marketing Manager',
          '05022',
          '0452-076545'),
      _Employee('CHOPS', 'Yang Wang', 'Chop-suey Chinese', 'Hauptstr. 29',
          'Bern', 'Switzerland', 'Owner', '3012', '(5) 555-3392'),
      _Employee(
          'COMMI',
          'Pedro Afonso',
          'Comércio Mineiro',
          'Av. dos Lusíadas, 23',
          'São Paulo',
          'Brazil',
          'Sales Associate',
          '05432-043',
          '(11) 555-7647'),
      _Employee(
          'CONSH',
          'Elizabeth Brown',
          'Consolidated Holdings',
          'Berkeley Gardens \n 12  Brewery',
          'London',
          'UK',
          'Sales Representative',
          'WX1 6LT',
          '7675-3425'),
      _Employee(
          'DRACD',
          'Sven Ottlieb',
          'Drachenblut Delikatessen',
          'Walserweg 21',
          'Aachen',
          'Germany',
          'Order Administrator',
          '52066',
          '(71) 555-2282'),
      _Employee(
          'DUMON',
          'Janine Labrune',
          'Du monde entier',
          '67, rue des Cinquante Otages',
          'Nantes',
          'France',
          'Owner',
          '44000',
          '0241-039123'),
      _Employee('EASTC', 'Ann Devon', 'Eastern Connection', '35 King George',
          'London', 'UK', 'Sales Agent', 'WX3 6FW', '40.67.88.88'),
      _Employee('ERNSH', 'Roland Mendel', 'Ernst Handel', 'Kirchgasse 6',
          'Graz', 'Austria', 'Sales Manager', '8010', '(71) 555-0297')
    ];
  }
}
