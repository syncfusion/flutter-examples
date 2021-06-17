///Dart import
import 'dart:math' as math;

/// Package imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

/// Barcode import
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Local import
import '../../../model/sample_view.dart';

/// Render getting started data grid
class GettingStartedDataGrid extends SampleView {
  /// Creates getting started data grid
  const GettingStartedDataGrid({Key? key}) : super(key: key);

  @override
  _GettingStartedDataGridState createState() => _GettingStartedDataGridState();
}

class _GettingStartedDataGridState extends SampleViewState {
  /// DataGridSource required for SfDataGrid to obtain the row data.
  _TeamDataGridSource teamDataGridSource = _TeamDataGridSource();

  /// DataGridSource required for SfDataGrid to obtain the row data.
  late _EmployeeDataGridSource employeeDataGridSource;

  late bool isWebOrDesktop;

  SfDataGrid _buildDataGridForMobile() {
    return SfDataGrid(
      source: teamDataGridSource,
      columnWidthMode: ColumnWidthMode.fill,
      rowHeight: 50,
      columns: <GridColumn>[
        GridTextColumn(
          columnName: 'image',
          width: 51,
          label: const SizedBox.shrink(),
        ),
        GridTextColumn(
          columnName: 'team',
          width: !isWebOrDesktop ? 90 : double.nan,
          label: Container(
            alignment: Alignment.centerLeft,
            child: const Text('Team'),
          ),
        ),
        GridTextColumn(
          columnName: 'wins',
          label: const Center(
            child: Text('W'),
          ),
        ),
        GridTextColumn(
            columnName: 'losses',
            label: const Center(
              child: Text('L'),
            )),
        GridTextColumn(
            columnName: 'pct', label: const Center(child: Text('WPCT'))),
        GridTextColumn(
          columnName: 'gb',
          label: const Center(child: Text('GB')),
        ),
      ],
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

  SfDataGrid _buildDataGridForWeb() {
    return SfDataGrid(
      source: employeeDataGridSource,
      columns: <GridColumn>[
        GridTextColumn(
            width: 130,
            columnName: 'employeeName',
            label: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Employee Name',
                overflow: TextOverflow.ellipsis,
              ),
            )),
        GridTextColumn(
          columnName: 'designation',
          width: (model.isWeb || model.isMacOS || model.isLinux) ? 150 : 130,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Designation',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        GridTextColumn(
          columnName: 'mail',
          width: 180.0,
          label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Mail',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        GridTextColumn(
          columnName: 'location',
          width: model.isLinux ? 120.0 : 105.0,
          label: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Location',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        GridTextColumn(
          columnName: 'status',
          label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text(
                'Status',
                overflow: TextOverflow.ellipsis,
              )),
        ),
        GridTextColumn(
            columnName: 'trustworthiness',
            width: 130,
            label: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'Trustworthiness',
                  overflow: TextOverflow.ellipsis,
                ))),
        GridTextColumn(
            columnName: 'softwareProficiency',
            width: 165,
            label: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'Software Proficiency',
                  overflow: TextOverflow.ellipsis,
                ))),
        GridTextColumn(
          columnName: 'salary',
          label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.centerRight,
              child: const Text(
                'Salary',
                overflow: TextOverflow.ellipsis,
              )),
        ),
        GridTextColumn(
          columnName: 'address',
          width: 200,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Address',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    isWebOrDesktop = model.isWeb || model.isDesktop;
    employeeDataGridSource =
        _EmployeeDataGridSource(brightness: model.themeData.brightness);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isWebOrDesktop ? _buildDataGridForWeb() : _buildDataGridForMobile(),
    );
  }
}

class _Team {
  _Team(
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

class _TeamDataGridSource extends DataGridSource {
  _TeamDataGridSource() {
    teams = getTeams(teamNames.length);
    buildDataGridRows();
  }

  List<_Team> teams = <_Team>[];

  List<DataGridRow> dataGridRows = <DataGridRow>[];

  // Building DataGridRows

  void buildDataGridRows() {
    dataGridRows = teams.map<DataGridRow>((_Team team) {
      return DataGridRow(cells: <DataGridCell>[
        DataGridCell<Image>(columnName: 'image', value: team.image),
        DataGridCell<String>(columnName: 'team', value: team.team),
        DataGridCell<int>(columnName: 'wins', value: team.wins),
        DataGridCell<int>(columnName: 'losses', value: team.losses),
        DataGridCell<double>(columnName: 'pct', value: team.winPercentage),
        DataGridCell<double>(columnName: 'gb', value: team.gamesBehind),
      ]);
    }).toList();
  }

  // Overrides

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: <Widget>[
      Container(
        padding: const EdgeInsets.all(8.0),
        child: row.getCells()[0].value,
      ),
      Container(
        alignment: Alignment.centerLeft,
        child: Text(
          row.getCells()[1].value.toString(),
          softWrap: true,
        ),
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
    ]);
  }

  // Team data's

  final List<String> teamNames = <String>[
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
    16.6,
    10.3
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
    66,
    23,
    45
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
    .437,
    .567,
    .345
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
    68,
    78
  ];

  List<_Team> getTeams(int count) {
    final List<_Team> teamData = <_Team>[];
    for (int i = 0; i < count; i++) {
      teamData.add(_Team(
        teamNames[i],
        pct[i],
        gb[i],
        wins[i],
        losses[i],
        _teamLogos[i],
      ));
    }
    return teamData;
  }
}

class _Employee {
  _Employee(
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

class _EmployeeDataGridSource extends DataGridSource {
  _EmployeeDataGridSource({required this.brightness}) {
    employees = getEmployees(20);
    buildDataGridRows();
  }

  final Brightness brightness;
  final math.Random random = math.Random();
  List<DataGridRow> dataGridRows = <DataGridRow>[];
  List<_Employee> employees = <_Employee>[];

  // Building DataGridRows

  void buildDataGridRows() {
    dataGridRows = employees.map<DataGridRow>((_Employee employee) {
      return DataGridRow(cells: <DataGridCell>[
        DataGridCell<String>(
            columnName: 'employeeName', value: employee.employeeName),
        DataGridCell<String>(
            columnName: 'designation', value: employee.designation),
        DataGridCell<String>(columnName: 'mail', value: employee.mail),
        DataGridCell<String>(columnName: 'location', value: employee.location),
        DataGridCell<String>(columnName: 'status', value: employee.status),
        DataGridCell<String>(
            columnName: 'trustworthiness', value: employee.trustworthiness),
        DataGridCell<int>(
            columnName: 'softwareProficiency',
            value: employee.softwareProficiency),
        DataGridCell<int>(columnName: 'salary', value: employee.salary),
        DataGridCell<String>(columnName: 'address', value: employee.address),
      ]);
    }).toList();
  }

  // Overrides
  @override
  List<DataGridRow> get rows => dataGridRows;

  Widget buildEmployeeName(dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: getWidget(
          Icon(Icons.account_circle, size: 30, color: Colors.blue[300]), value),
    );
  }

  Widget buildLocation(dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: getWidget(const Icon(Icons.location_on, size: 20), value),
    );
  }

  Widget buildTrustWorthiness(String value) {
    final String trust = value;
    if (value == 'Perfect') {
      return Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: getWidget(images[trust]!, trust),
      );
    } else if (value == 'Insufficient') {
      return Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: getWidget(images[trust]!, trust),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: getWidget(images[trust]!, trust),
      );
    }
  }

  Widget buildSoftwareProficiency(dynamic value) {
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

    return getLinearProgressBar(value);
  }

  Widget getWidget(Widget image, String text) {
    return Container(
      color: Colors.transparent,
      child: Row(
        children: <Widget>[
          Container(
            child: image,
          ),
          const SizedBox(width: 6),
          Expanded(
              child: Text(
            text,
            overflow: TextOverflow.ellipsis,
          ))
        ],
      ),
    );
  }

  TextStyle getStatusTextStyle(dynamic value) {
    if (value == 'Active') {
      return const TextStyle(color: Colors.green);
    } else {
      return TextStyle(color: Colors.red[500]);
    }
  }

  final Map<String, Image> images = <String, Image>{
    'Perfect': Image.asset('images/Perfect.png'),
    'Insufficient': Image.asset('images/Insufficient.png'),
    'Sufficient': Image.asset('images/Sufficient.png'),
  };

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: <Widget>[
      buildEmployeeName(row.getCells()[0].value),
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
      buildLocation(row.getCells()[3].value),
      Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(
            row.getCells()[4].value.toString(),
            style: getStatusTextStyle(row.getCells()[4].value),
          )),
      buildTrustWorthiness(row.getCells()[5].value.toString()),
      buildSoftwareProficiency(row.getCells()[6].value),
      Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.centerRight,
        child: Text(NumberFormat.currency(locale: 'en_US', symbol: r'$')
            .format(row.getCells()[7].value)
            .toString()),
      ),
      Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.centerLeft,
        child: Text(row.getCells()[8].value.toString()),
      ),
    ]);
  }

  // Employee Data's

  final List<String> employeeNames = <String>[
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
  final List<String> addresses = <String>[
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
  final List<String> designations = <String>[
    'Designer',
    'Manager',
    'Developer',
    'Project Lead',
    'Program Directory',
    'System Analyst',
    'CFO'
  ];
  final List<String> mails = <String>[
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

  List<_Employee> getEmployees(int count) {
    final List<_Employee> employeeData = <_Employee>[];
    for (int i = 0; i < employeeNames.length - 1; i++) {
      employeeData.add(_Employee(
          employeeNames[i],
          designations[random.nextInt(designations.length - 1)],
          employeeNames[i].toLowerCase() +
              '@' +
              mails[random.nextInt(mails.length - 1)],
          locations[random.nextInt(locations.length - 1)],
          status[random.nextInt(status.length)],
          trusts[random.nextInt(trusts.length - 1)],
          20 + random.nextInt(80),
          10000 + random.nextInt(70000),
          addresses[random.nextInt(addresses.length - 1)]));
    }
    return employeeData;
  }
}
