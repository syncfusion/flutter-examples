import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/sample_view.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter_examples/model/model.dart';

class GettingStartedDataGrid extends SampleView {
  const GettingStartedDataGrid({Key key}) : super(key: key);

  @override
  _GettingStartedDataGridState createState() => _GettingStartedDataGridState();
}

List<Team> _teamData;
List<Employee> _employeeCollection;

class _GettingStartedDataGridState extends SampleViewState {
  _GettingStartedDataGridState();
  final math.Random random = math.Random();

  final TeamDataGridSource _teamDataGridSource = TeamDataGridSource();
  final EmployeeDataGridSource _employeeDataGridSource =
      EmployeeDataGridSource();
  final List<String> employees = <String>[
    'Michael',
    'Kathryn',
    'Tamer',
    'Martin',
    'Davolio',
    'Nancy',
    'Fuller',
    'Leverling',
    'Therasa',
    'Margaret',
    'Buchanan',
    'Janet',
    'Andrew',
    'Callahan',
    'Laura',
    'Dodsworth',
    'Anne',
    'Bergs',
    'Vinet',
    'Anto',
    'Fleet',
    'Zachery',
    'Van',
    'Edward',
    'Jack',
    'Rose'
  ];
  final List<String> address = <String>[
    '59 rue de lAbbaye',
    'Luisenstr. 48',
    'Rua do Paço 67',
    '2 rue du Commerce',
    'Boulevard Tirou 255',
    'Rua do mailPaço 67',
    'Hauptstr. 31',
    'Starenweg 5',
    'Rua do Mercado ,12',
    'Carrera 22 con Ave.',
    'Carlos Soublette #8-35',
    'Kirchgasse 6',
    'Sierras de Granada 9993',
    'Mehrheimerstr. 369',
    'Rua da Panificadora 12',
    '2817 Milton Dr.',
    'Kirchgasse 6',
    'Åkergatan 24',
    '24, place Kléber',
    'Torikatu 38',
    'Berliner Platz 43',
    '5ª Ave. Los Palos Grandes',
    '1029 - 12th Ave. S.',
    'Torikatu 38',
    'P.O. Box 555',
    '2817 Milton Dr.',
    'Taucherstraße 10',
    '59 rue de lAbbaye',
    'Via Ludovico il Moro 22',
    'Avda. Azteca 123',
    'Heerstr. 22',
    'Berguvsvägen  8',
    'Magazinweg 7',
    'Berguvsvägen  8',
    'Gran Vía, 1',
    'Gran Vía, 1',
    'Bolívar #65-98 Llano Largo',
    'Magazinweg 7',
    'Taucherstraße 10',
    'Taucherstraße 10',
  ];
  final List<String> designation = <String>[
    'Designer',
    'Manager',
    'Developer',
    'Project Lead',
    'Program Directory',
    'System Analyst',
    'CFO'
  ];
  final List<String> mail = <String>[
    'arpy.com',
    'sample.com',
    'rpy.com',
    'jourrapide.com'
  ];
  final List<String> status = <String>['Inactive', 'Active'];
  final List<String> trusts = <String>['Sufficient', 'Perfect', 'Insufficient'];
  final List<String> locations = <String>[
    'UK',
    'USA',
    'Sweden',
    'France',
    'Canada',
    'Argentina',
    'Austria',
    'Germany',
    'Mexico'
  ];
  final Map<String, Image> images = <String, Image>{
    'Perfect': Image.asset('images/Perfect.png'),
    'Insufficient': Image.asset('images/Insufficient.png'),
    'Sufficient': Image.asset('images/Sufficient.png'),
  };
  final List<Image> _teamLogos = <Image>[
    Image.asset('images/DenverNuggets.png'),
    Image.asset('images/Hornets.png'),
    Image.asset('images/Memphis.png'),
    Image.asset('images/NewYork.png'),
    Image.asset('images/DetroitPistons.png'),
    Image.asset('images/LosAngeles.png'),
    Image.asset('images/Miami.png'),
    Image.asset('images/Orlando.png'),
    Image.asset('images/Clippers.png'),
    Image.asset('images/GoldenState.png'),
    Image.asset('images/Mavericks.png'),
    Image.asset('images/Milwakke.png'),
    Image.asset('images/Thunder_Logo.png'),
  ];

  final List<String> genders = <String>[
    '1',
    '2',
    '1',
    '1',
    '2',
    '2',
    '1',
    '2',
    '2',
    '2',
    '1',
    '2',
    '1',
    '1',
    '2',
    '1',
    '2',
    '1',
    '1',
    '1',
    '1',
    '1',
    '1',
    '1',
    '1',
    '2'
  ];
  final List<String> teamName = <String>[
    'Denver',
    'Hornets',
    'Memphis',
    'New York',
    'Detroit',
    'Los Angeles',
    'Miami',
    'Orlando',
    'Clippers',
    'Golden State',
    'Mavericks',
    'Milwakke',
    'Thunder',
  ];
  final List<double> gb = <double>[
    0,
    10,
    15.5,
    15.5,
    40.5,
    0,
    2,
    3,
    14.5,
    19,
    0,
    20,
    24.5,
    28.5,
    31,
  ];
  final List<int> wins = <int>[
    93,
    82,
    76,
    77,
    52,
    84,
    82,
    81,
    70,
    65,
    97,
    77,
    72,
    68,
    66
  ];
  final List<double> pct = <double>[
    .616,
    .550,
    .514,
    .513,
    .347,
    .560,
    .547,
    .540,
    .464,
    .433,
    .642,
    .510,
    .480,
    .453,
    .437
  ];
  final List<int> losses = <int>[
    58,
    67,
    72,
    73,
    98,
    66,
    68,
    69,
    81,
    85,
    54,
    74,
    78,
    82,
    85,
  ];

  Widget sampleWidget(SampleModel model) => const GettingStartedDataGrid();

  List<Team> generateTeam(int count) {
    final List<Team> teamData = <Team>[];
    for (int i = 0; i < count - 1; i++) {
      teamData.add(Team(
        teamName[i],
        pct[i],
        gb[i],
        wins[i],
        losses[i],
        images[i],
      ));
    }

    return teamData;
  }

  List<Employee> generateEmployeeData(int count) {
    final List<Employee> employee = <Employee>[];
    for (int i = 0; i < employees.length - 1; i++) {
      employee.add(Employee(
          employees[i],
          designation[random.nextInt(designation.length - 1)],
          employees[i].toLowerCase() +
              '@' +
              mail[random.nextInt(mail.length - 1)],
          locations[random.nextInt(locations.length - 1)],
          status[random.nextInt(status.length)],
          trusts[random.nextInt(trusts.length - 1)],
          20 + random.nextInt(80),
          10000 + random.nextInt(70000),
          address[random.nextInt(address.length - 1)]));
    }
    return employee;
  }

  SfDataGrid _mobileSample() {
    return SfDataGrid(
      source: _teamDataGridSource,
      columnWidthMode: ColumnWidthMode.fill,
      cellBuilder: (BuildContext context, GridColumn column, int rowIndex) =>
          Container(
        child: _teamLogos[rowIndex],
        padding: const EdgeInsets.all(8),
      ),
      rowHeight: 50,
      columns: <GridColumn>[
        GridWidgetColumn(mappingName: 'image')
          ..width = 51
          ..headerText = ''
          ..padding = const EdgeInsets.all(8.0),
        GridTextColumn(mappingName: 'team')
          ..columnWidthMode = ColumnWidthMode.cells
          ..headerText = 'Team'
          ..headerTextAlignment = Alignment.centerLeft,
        GridNumericColumn(mappingName: 'wins')
          ..headerText = 'W'
          ..padding = const EdgeInsets.all(8)
          ..headerTextAlignment = Alignment.center
          ..textAlignment = Alignment.center,
        GridNumericColumn(mappingName: 'losses')
          ..padding = const EdgeInsets.all(8)
          ..textAlignment = Alignment.center
          ..headerTextAlignment = Alignment.center
          ..headerText = 'L',
        GridNumericColumn(mappingName: 'pct')
          ..headerText = 'WPCT'
          ..padding = const EdgeInsets.all(8)
          ..textAlignment = Alignment.center
          ..headerTextAlignment = Alignment.center
          ..columnWidthMode = ColumnWidthMode.auto,
        GridNumericColumn(mappingName: 'gb')
          ..headerText = 'GB'
          ..textAlignment = Alignment.center
          ..headerTextAlignment = Alignment.center
          ..padding = const EdgeInsets.all(8),
      ],
    );
  }

  Widget getWidget(dynamic image, String text) {
    return Container(
      color: Colors.transparent,
      child: Row(
        children: <Widget>[
          Container(
            child: image,),
          const SizedBox(width: 6),
          Expanded(child: Text(text,overflow: TextOverflow.ellipsis,))
        ],
      ),
    );
  }

  Widget getLocationWidget(String location) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            child: Image.asset('images/location.png'),
          ),
          Text(
            ' ' + location,
          )
        ],
      ),
    );
  }

  Widget getLinearProgressBar(int progressValue) {
    return Container(
      width: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              width: 50,
              child: LinearProgressIndicator(
                value: progressValue / 100,
                valueColor: AlwaysStoppedAnimation<Color>(
                    progressValue < 50 ? Colors.red : Colors.green),
                backgroundColor:
                    progressValue < 50 ? Colors.red[100] : Colors.green[100],
              )),
          Text(' ' + (progressValue.toString() + '%')),
        ],
      ),
    );
  }

  Widget getTrustWidget(String trust) {
    return Container(
        child: Row(children: <Widget>[
      Container(
          child: Row(
        children: <Widget>[
          Container(
            child: Image.asset('images/Perfect.png'),
          ),
          Text(trust)
        ],
      ))
    ]));
  }

  Widget getCellWidget(BuildContext context, GridColumn column, int rowIndex) {
    if (column.mappingName == 'location') {
      final String location = _employeeCollection[rowIndex].location;
      return Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: getWidget(Icon(Icons.location_on,size: 20), location),
      );
    } else if (column.mappingName == 'employeeName') {
      final String employeeName = _employeeCollection[rowIndex].employeeName;
        return Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: getWidget(Icon(Icons.account_circle,size: 30,color: Colors.blue[300]), employeeName),
        );
    } else if (column.mappingName == 'trustworthiness') {
      final String trust = _employeeCollection[rowIndex].trustworthiness;
      if (trust == 'Perfect') {
        return Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: getWidget(images[trust], trust),
        );
      } else if (trust == 'Insufficient') {
        return Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: getWidget(images[trust], trust),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: getWidget(images[trust], trust),
        );
      }
    } else if (column.mappingName == 'softwareProficiency') {
      return getLinearProgressBar(
          _employeeCollection[rowIndex].softwareProficiency);
    } else {
      return null;
    }
  }

  SfDataGrid _webSample() {
    return SfDataGrid(
      source: _employeeDataGridSource,
      columnWidthMode: ColumnWidthMode.auto,
      cellBuilder: getCellWidget,
      onQueryCellStyle: (QueryCellStyleArgs args) {
        if (args.column.mappingName == 'status') {
          if (args.cellValue == 'Active') {
            return const DataGridCellStyle(
                textStyle: TextStyle(color: Colors.green));
          } else {
            return DataGridCellStyle(
                textStyle: TextStyle(color: Colors.red[500]));
          }
        } else
          return null;
      },
      columns: <GridColumn>[
        GridWidgetColumn(mappingName: 'employeeName')
          ..columnWidthMode = ColumnWidthMode.header
          ..headerText = 'Employee Name',
        GridTextColumn(mappingName: 'designation')
          ..headerText = 'Designation'
          ..headerTextAlignment = Alignment.centerLeft,
        GridTextColumn(mappingName: 'mail')
          ..headerText = 'Mail'
          ..headerTextAlignment = Alignment.centerLeft,
        GridWidgetColumn(mappingName: 'location')
          ..width = 105
          ..headerText = 'Location'
          ..headerTextAlignment = Alignment.centerLeft,
        GridTextColumn(mappingName: 'status')
          ..headerText = 'Status'
          ..headerTextAlignment = Alignment.centerLeft,
        GridWidgetColumn(mappingName: 'trustworthiness')
          ..columnWidthMode = ColumnWidthMode.header
          ..headerText = 'Trustworthiness',
        GridWidgetColumn(mappingName: 'softwareProficiency')
          ..columnWidthMode = ColumnWidthMode.header
          ..headerText = 'Software Proficiency',
        GridNumericColumn(mappingName: 'salary')
          ..headerText = 'Salary'
          ..headerTextAlignment = Alignment.centerRight
          ..numberFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$'),
        GridTextColumn(mappingName: 'address')
          ..headerText = 'Address'
          ..headerTextAlignment = Alignment.centerLeft,
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _teamData = generateTeam(13);
    _employeeCollection = generateEmployeeData(20);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: kIsWeb ? _webSample() : _mobileSample());
  }
}

class Team {
  Team(
    this.team,
    this.winPercentage,
    this.gamesBehind,
    this.wins,
    this.losses,
    this.image,
  );
  final String team;
  final double winPercentage;
  final double gamesBehind;
  final int wins;
  final int losses;
  final Image image;
}

class TeamDataGridSource extends DataGridSource {
  TeamDataGridSource();
  @override
  List<Object> get dataSource => _teamData;
  @override
  Object getCellValue(int rowIndex, String columnName) {
    switch (columnName) {
      case 'team':
        return _teamData[rowIndex].team;
        break;
      case 'pct':
        return _teamData[rowIndex].winPercentage;
        break;
      case 'gb':
        return _teamData[rowIndex].gamesBehind;
        break;
      case 'wins':
        return _teamData[rowIndex].wins;
        break;
      case 'losses':
        return _teamData[rowIndex].losses;
        break;
      default:
        return 'empty';
        break;
    }
  }
}

class Employee {
  Employee(
    this.employeeName,
    this.designation,
    this.mail,
    this.location,
    this.status,
    this.trustworthiness,
    this.softwareProficiency,
    this.salary,
    this.address,
  );
  final String location;
  final String employeeName;
  final String designation;
  final String mail;
  final String trustworthiness;
  final String status;
  final int softwareProficiency;
  final int salary;
  final String address;
}

class EmployeeDataGridSource extends DataGridSource {
  EmployeeDataGridSource();
  @override
  List<Object> get dataSource => _employeeCollection;
  @override
  Object getCellValue(int rowIndex, String columnName) {
    switch (columnName) {
      case 'mail':
        return _employeeCollection[rowIndex].mail;
        break;
      case 'status':
        return _employeeCollection[rowIndex].status;
        break;
      case 'designation':
        return _employeeCollection[rowIndex].designation;
        break;
      case 'salary':
        return _employeeCollection[rowIndex].salary;
        break;
      case 'address':
        return _employeeCollection[rowIndex].address;
        break;
      default:
        return 'empty';
        break;
    }
  }
}
