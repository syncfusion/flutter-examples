/// Dart import
import 'dart:math' as math;

/// Packages import
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// DataGrid import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../model/team.dart';

/// Set team's data collection to data grid source.
class TeamDataGridSource extends DataGridSource {
  /// Creates the team data source class with required details.
  TeamDataGridSource() {
    _teams = _fetchTeams(_teamNames.length);
    _buildDataGridRows();
  }

  List<Team> _teams = <Team>[];

  List<DataGridRow> _dataGridRows = <DataGridRow>[];

  /// Building DataGridRows
  void _buildDataGridRows() {
    _dataGridRows = _teams.map<DataGridRow>((Team team) {
      return DataGridRow(
        cells: <DataGridCell>[
          DataGridCell<Image>(columnName: 'image', value: team.image),
          DataGridCell<String>(columnName: 'team', value: team.team),
          DataGridCell<int>(columnName: 'wins', value: team.wins),
          DataGridCell<int>(columnName: 'losses', value: team.losses),
          DataGridCell<double>(columnName: 'pct', value: team.winPercentage),
          DataGridCell<double>(columnName: 'gb', value: team.gamesBehind),
        ],
      );
    }).toList();
  }

  // Overrides
  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: <Widget>[
        Container(
          padding: const EdgeInsets.all(8.0),
          child: row.getCells()[0].value,
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: Text(row.getCells()[1].value.toString(), softWrap: true),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(
            row.getCells()[2].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(
            row.getCells()[3].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(
            row.getCells()[4].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(
            row.getCells()[5].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // Team data's
  final List<String> _teamNames = <String>[
    'Denver',
    'Charllote',
    'Memphis',
    'New York',
    'Detroit',
    'L.A Lakers',
    'Miami',
    'Orlando',
    'L.A Clippers',
    'San Francisco',
    'Dallas',
    'Milwaukke',
    'Oklahoma',
    'Cleveland',
  ];

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
    Image.asset('images/Cavaliers.png'),
  ];

  final List<double> _gb = <double>[
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
    16.6,
    10.3,
  ];
  final List<int> _wins = <int>[
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
    66,
    23,
    45,
  ];
  final List<double> _pct = <double>[
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
    .437,
    .567,
    .345,
  ];
  final List<int> _losses = <int>[
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
    68,
    78,
  ];

  List<Team> _fetchTeams(int count) {
    final List<Team> teamData = <Team>[];
    for (int i = 0; i < count; i++) {
      teamData.add(
        Team(
          _teamNames[i],
          _pct[i],
          _gb[i],
          _wins[i],
          _losses[i],
          _teamLogos[i],
        ),
      );
    }
    return teamData;
  }
}

/// Set employee's data collection to data grid source.
class EmployeeDataGridSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  EmployeeDataGridSource() {
    _employees = _obtainEmployees(20);
    _buildDataGridRows();
  }

  final math.Random _random = math.Random.secure();
  List<DataGridRow> _dataGridRows = <DataGridRow>[];
  List<Employee> _employees = <Employee>[];

  /// Building DataGridRows
  void _buildDataGridRows() {
    _dataGridRows = _employees.map<DataGridRow>((Employee employee) {
      return DataGridRow(
        cells: <DataGridCell>[
          DataGridCell<String>(
            columnName: 'employeeName',
            value: employee.employeeName,
          ),
          DataGridCell<String>(
            columnName: 'designation',
            value: employee.designation,
          ),
          DataGridCell<String>(columnName: 'mail', value: employee.mail),
          DataGridCell<String>(
            columnName: 'location',
            value: employee.location,
          ),
          DataGridCell<String>(columnName: 'status', value: employee.status),
          DataGridCell<String>(
            columnName: 'trustworthiness',
            value: employee.trustworthiness,
          ),
          DataGridCell<int>(
            columnName: 'softwareProficiency',
            value: employee.softwareProficiency,
          ),
          DataGridCell<int>(columnName: 'salary', value: employee.salary),
          DataGridCell<String>(columnName: 'address', value: employee.address),
        ],
      );
    }).toList();
  }

  // Overrides
  @override
  List<DataGridRow> get rows => _dataGridRows;

  Widget _buildEmployeeName(dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: _buildWidget(
        Icon(Icons.account_circle, size: 30, color: Colors.blue[300]),
        value,
      ),
    );
  }

  Widget _buildLocation(dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: _buildWidget(const Icon(Icons.location_on, size: 20), value),
    );
  }

  Widget _buildTrustWorthiness(String value) {
    final String trust = value;
    if (value == 'Perfect') {
      return Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: _buildWidget(_images[trust]!, trust),
      );
    } else if (value == 'Insufficient') {
      return Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: _buildWidget(_images[trust]!, trust),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: _buildWidget(_images[trust]!, trust),
      );
    }
  }

  Widget _buildSoftwareProficiency(dynamic value) {
    Widget createLinearProgressBar(int progressValue) {
      return SizedBox(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 50,
              child: LinearProgressIndicator(
                value: progressValue / 100,
                valueColor: AlwaysStoppedAnimation<Color>(
                  progressValue < 50 ? Colors.red : Colors.green,
                ),
                backgroundColor: progressValue < 50
                    ? Colors.red[100]
                    : Colors.green[100],
              ),
            ),
            Text(' ' + (progressValue.toString() + '%')),
          ],
        ),
      );
    }

    return createLinearProgressBar(value);
  }

  Widget _buildWidget(Widget image, String text) {
    return Container(
      color: Colors.transparent,
      child: Row(
        children: <Widget>[
          Container(child: image),
          const SizedBox(width: 6),
          Expanded(child: Text(text, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  TextStyle _styleForStatusText(dynamic value) {
    if (value == 'Active') {
      return const TextStyle(color: Colors.green);
    } else {
      return TextStyle(color: Colors.red[500]);
    }
  }

  final Map<String, Image> _images = <String, Image>{
    'Perfect': Image.asset('images/Perfect.png'),
    'Insufficient': Image.asset('images/Insufficient.png'),
    'Sufficient': Image.asset('images/Sufficient.png'),
  };

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: <Widget>[
        _buildEmployeeName(row.getCells()[0].value),
        Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.centerLeft,
          child: Text(row.getCells()[1].value.toString()),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.centerLeft,
          child: Text(row.getCells()[2].value.toString()),
        ),
        _buildLocation(row.getCells()[3].value),
        Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(
            row.getCells()[4].value.toString(),
            style: _styleForStatusText(row.getCells()[4].value),
          ),
        ),
        _buildTrustWorthiness(row.getCells()[5].value.toString()),
        _buildSoftwareProficiency(row.getCells()[6].value),
        Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.centerRight,
          child: Text(
            NumberFormat.currency(
              locale: 'en_US',
              symbol: r'$',
            ).format(row.getCells()[7].value),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.centerLeft,
          child: Text(row.getCells()[8].value.toString()),
        ),
      ],
    );
  }

  // Employee Data's
  final List<String> _employeeNames = <String>[
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
    'Rose',
  ];
  final List<String> _addresses = <String>[
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
  final List<String> _designations = <String>[
    'Designer',
    'Manager',
    'Developer',
    'Project Lead',
    'Program Directory',
    'System Analyst',
    'CFO',
  ];
  final List<String> _mails = <String>[
    'arpy.com',
    'sample.com',
    'rpy.com',
    'jourrapide.com',
  ];
  final List<String> _status = <String>['Inactive', 'Active'];
  final List<String> _trusts = <String>[
    'Sufficient',
    'Perfect',
    'Insufficient',
  ];
  final List<String> _locations = <String>[
    'UK',
    'USA',
    'Sweden',
    'France',
    'Canada',
    'Argentina',
    'Austria',
    'Germany',
    'Mexico',
  ];

  List<Employee> _obtainEmployees(int count) {
    final List<Employee> employeeData = <Employee>[];
    for (int i = 0; i < _employeeNames.length - 1; i++) {
      employeeData.add(
        Employee(
          _employeeNames[i],
          _designations[_random.nextInt(_designations.length - 1)],
          _employeeNames[i].toLowerCase() +
              '@' +
              _mails[_random.nextInt(_mails.length - 1)],
          _locations[_random.nextInt(_locations.length - 1)],
          _status[_random.nextInt(_status.length)],
          _trusts[_random.nextInt(_trusts.length - 1)],
          20 + _random.nextInt(80),
          10000 + _random.nextInt(70000),
          _addresses[_random.nextInt(_addresses.length - 1)],
        ),
      );
    }
    return employeeData;
  }
}
