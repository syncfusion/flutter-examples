/// Flutter package imports
import 'package:flutter/material.dart';

/// Barcode imports
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

/// Local imports
import '../../../model/sample_view.dart';

///Renders data grid with auto row height

List<Employee> _employees;

class AutoRowHeightDataGrid extends SampleView {
  ///Creates data grid with auto row height
  const AutoRowHeightDataGrid({Key key}) : super(key: key);

  @override
  _AutoRowHeightDataGridState createState() => _AutoRowHeightDataGridState();
}

class _AutoRowHeightDataGridState extends SampleViewState {
  _AutoRowHeightDataGridState();

  final _AutoRowHeightDataGridSource _autoRowHeightDataGridSource =
      _AutoRowHeightDataGridSource();

  final ColumnSizer _columnSizer = ColumnSizer();

  void populateData() {
    _employees.add(Employee(
        'ALFKI',
        'Maria Anders',
        'Alfreds Futterkiste',
        'Obere Str. 57',
        'Berlin',
        'Germany',
        'Sales Representative',
        '12209',
        '030-0074321'));
    _employees.add(Employee(
        'ANATR',
        'Ana Trujillo',
        'Ana Trujillo Emparedados y helados',
        'Avda. de la Constitución 2222',
        'México D.F.',
        'Mexico',
        'Owner',
        '05021',
        '(5) 555-4729'));
    _employees.add(Employee(
        'ANTON',
        'Antonio Moreno',
        'Antonio Moreno Taquería',
        'Mataderos  2312',
        'México D.F',
        'Mexico',
        'Owner',
        '05023',
        '(5) 555-3932'));
    _employees.add(Employee(
        'AROUT',
        'Thomas Hardy',
        'Around the Horn',
        '120 Hanover Sq.',
        'London',
        'UK',
        'Sales Representative',
        'WA1 1DP',
        '(71) 555-7788'));
    _employees.add(Employee(
        'BERGS',
        'Christina Berglund',
        'Berglunds snabbköp',
        'Berguvsvägen  8',
        'Luleå',
        'Sweden',
        'Order Administrator',
        'S-958 22',
        '0921-12 34 65'));
    _employees.add(Employee(
        'BLAUS',
        'Hanna Moos',
        'Blauer See Delikatessen',
        'Forsterstr. 57',
        'Mannheim',
        'Germany',
        'Sales Representative',
        '68306',
        '0621-08460'));
    _employees.add(Employee(
        'BLONP',
        'Frédérique Citeaux',
        'Blondel père et fils',
        '24, place Kléber',
        'Strasbourg',
        'France',
        'Marketing Manager',
        '67000',
        '88.60.15.31'));
    _employees.add(Employee(
        'BOLID',
        'Martín Sommer',
        'Bólido Comidas preparadas',
        'C/ Araquil, 67',
        'Madrid',
        'Spain',
        'Marketing Manager' 'Owner',
        '28023',
        '(91) 555 22 82'));
    _employees.add(Employee(
        'BONAP',
        'Laurence Lebihan',
        ''' Bon app' ''',
        '12, rue des Bouchers',
        'Marseille',
        'France',
        'Owner',
        '13008',
        '91.24.45.40'));
    _employees.add(Employee(
        'BOTTM',
        'Elizabeth Lincoln',
        'Bottom-Dollar Markets',
        '23 Tsawassen Blvd.',
        'Tsawassen',
        'Canada',
        'Accounting Manager',
        'T2F 8M4',
        '(604) 555-4729'));
    _employees.add(Employee(
        'BSBEV',
        'Victoria Ashworth',
        '''B's Beverages''',
        'Fauntleroy Circus',
        'London',
        'UK',
        'Sales Representative',
        'EC2 5NT',
        '(71) 555-1212'));
    _employees.add(Employee(
        'CACTU',
        'Patricio Simpson',
        'Cactus Comidas para llevar',
        'Cerrito 333',
        'Buenos Aires',
        'Argentina',
        'Sales Agent',
        '1010',
        '(1) 135-5555'));
    _employees.add(Employee(
        'CENTC',
        'Francisco Chang',
        'Centro comercial Moctezuma',
        'Sierras de Granada 9993',
        'México D.F.',
        'Mexico',
        'Marketing Manager',
        '05022',
        '0452-076545'));
    _employees.add(Employee(
        'CHOPS',
        'Yang Wang',
        'Chop-suey Chinese',
        'Hauptstr. 29',
        'Bern',
        'Switzerland',
        'Owner',
        '3012',
        '(5) 555-3392'));
    _employees.add(Employee(
        'COMMI',
        'Pedro Afonso',
        'Comércio Mineiro',
        'Av. dos Lusíadas, 23',
        'São Paulo',
        'Brazil',
        'Sales Associate',
        '05432-043',
        '(11) 555-7647'));
    _employees.add(Employee(
        'CONSH',
        'Elizabeth Brown',
        'Consolidated Holdings',
        ''' Berkeley Gardens
12  Brewery ''',
        'London',
        'UK',
        'Sales Representative',
        'WX1 6LT',
        '7675-3425'));
    _employees.add(Employee(
        'DRACD',
        'Sven Ottlieb',
        'Drachenblut Delikatessen',
        'Walserweg 21',
        'Aachen',
        'Germany',
        'Order Administrator',
        '52066',
        '(71) 555-2282'));
    _employees.add(Employee(
        'DUMON',
        'Janine Labrune',
        'Du monde entier',
        '67, rue des Cinquante Otages',
        'Nantes',
        'France',
        'Owner',
        '44000',
        '0241-039123'));
    _employees.add(Employee(
        'EASTC',
        'Ann Devon',
        'Eastern Connection',
        '35 King George',
        'London',
        'UK',
        'Sales Agent',
        'WX3 6FW',
        '40.67.88.88'));
    _employees.add(Employee(
        'ERNSH',
        'Roland Mendel',
        'Ernst Handel',
        'Kirchgasse 6',
        'Graz',
        'Austria',
        'Sales Manager',
        '8010',
        '(71) 555-0297'));
  }

  Widget _dataGridSample() {
    return SfDataGridTheme(
      data: SfDataGridThemeData(
        brightness: SfTheme.of(context).brightness,
        gridLineStrokeWidth: 1.4,
      ),
      child: SfDataGrid(
          source: _autoRowHeightDataGridSource,
          columnSizer: _columnSizer,
          onQueryRowHeight: (RowHeightDetails rowHeightDetails) {
            final double height =
                _columnSizer.getAutoRowHeight(rowHeightDetails.rowIndex);
            return height;
          },
          columns: <GridColumn>[
            GridTextColumn(
                mappingName: 'id',
                softWrap: true,
                overflow: TextOverflow.clip,
                width: model.isWeb ? 135 : 90,
                headerText: 'ID',
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16)),
            GridTextColumn(
                mappingName: 'contactName',
                softWrap: true,
                columnWidthMode:
                    model.isWeb ? ColumnWidthMode.auto : ColumnWidthMode.header,
                overflow: TextOverflow.clip,
                headerText: 'Contact Name',
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16)),
            GridTextColumn(
                mappingName: 'companyName',
                softWrap: true,
                overflow: TextOverflow.clip,
                width: model.isWeb ? 165 : 140,
                headerText: 'Company Name',
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16)),
            GridTextColumn(
                mappingName: 'address',
                softWrap: true,
                width: model.isWeb ? 180 : 140,
                overflow: TextOverflow.clip,
                headerText: 'Address',
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16)),
            GridTextColumn(
                mappingName: 'city',
                softWrap: true,
                overflow: TextOverflow.clip,
                width: model.isWeb ? 150 : 120,
                headerText: 'City',
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16)),
            GridTextColumn(
                mappingName: 'country',
                softWrap: true,
                overflow: TextOverflow.clip,
                width: model.isWeb ? 150 : 120,
                headerText: 'Country',
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16)),
            GridTextColumn(
                mappingName: 'designation',
                softWrap: true,
                overflow: TextOverflow.clip,
                columnWidthMode: ColumnWidthMode.auto,
                headerText: 'Designation',
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16)),
            GridTextColumn(
                mappingName: 'postalCode',
                columnWidthMode: ColumnWidthMode.header,
                headerText: 'Postal Code',
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16)),
            GridTextColumn(
                mappingName: 'phoneNumber',
                columnWidthMode: ColumnWidthMode.auto,
                headerText: 'Phone Number',
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16)),
          ]),
    );
  }

  @override
  void initState() {
    super.initState();
    _employees = <Employee>[];
    populateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _dataGridSample());
  }
}

class Employee {
  Employee(this.id, this.contactName, this.companyName, this.address, this.city,
      this.country, this.designation, this.postalCode, this.phoneNumber);
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

class _AutoRowHeightDataGridSource extends DataGridSource<Employee> {
  @override
  List<Employee> get dataSource => _employees;
  @override
  Object getValue(Employee _employee, String columnName) {
    switch (columnName) {
      case 'id':
        return _employee.id;
        break;
      case 'companyName':
        return _employee.companyName;
        break;
      case 'contactName':
        return _employee.contactName;
        break;
      case 'address':
        return _employee.address;
        break;
      case 'city':
        return _employee.city;
        break;
      case 'country':
        return _employee.country;
        break;
      case 'designation':
        return _employee.designation;
        break;
      case 'postalCode':
        return _employee.postalCode;
        break;
      case 'phoneNumber':
        return _employee.phoneNumber;
        break;
      default:
        return 'empty';
        break;
    }
  }
}
