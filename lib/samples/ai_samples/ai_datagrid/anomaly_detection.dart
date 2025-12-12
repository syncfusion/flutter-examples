import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

/// DataGrid import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../../model/sample_view.dart';
import '../../../model/model.dart';
import '../../helper/ai_pop_up_api_key.dart';

/// Renders anomaly detection data grid
class AnomalyDetectionSample extends SampleView {
  /// Creates  anomaly detection data grid
  const AnomalyDetectionSample({Key? key}) : super(key: key);

  @override
  _AnomalyDetectionSampleState createState() => _AnomalyDetectionSampleState();
}

class _AnomalyDetectionSampleState extends SampleViewState
    with SingleTickerProviderStateMixin {
  late final GenerativeModel _model;
  late final ChatSession _chat;
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isPressed = false;
  late MachineDataSource _machineDataSource;
  late List<MachineData> _machineDetails;
  bool _isLoading = false;
  late bool _isWebOrDesktop;
  late bool isMaterial3;

  @override
  void initState() {
    super.initState();
    _isWebOrDesktop = model.isWeb || model.isDesktop;
    _machineDetails = getMachineData();
    _model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: model.assistApiKey,
    );
    _chat = _model.startChat();
    _machineDataSource = MachineDataSource(
      machine: _machineDetails,
      isWebOrDesktop: _isWebOrDesktop,
      model: model,
    );

    // Initialize the animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true); // Repeats the animation back and forth

    // Define the animation
    _animation = Tween<double>(
      begin: 0.8,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Show the dialog when the app starts.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (model.isFirstTime) {
        showDialog(
          context: context,
          builder: (context) => WelcomeDialog(
            primaryColor: model.primaryColor,
            apiKey: model.assistApiKey,
            onApiKeySaved: (newApiKey) {
              setState(() {
                model.assistApiKey = newApiKey;
              });
            },
          ),
        );
        model.isFirstTime = false;
      }
    });

    isMaterial3 = model.themeData.useMaterial3;
  }

  String _generatePrompt() {
    String prompt = 'Provide the results in strict JSON format only.';
    prompt += 'Each machine should have the following properties: ';
    prompt +=
        '`machineID` (String), `temperature` (int), `pressure` (int), `voltage` (int), `motorSpeed` (int), `productionRate` (int), and `anomalyDescription` (String). ';
    prompt += 'Here is the data and calculation criteria:\n\n';

    prompt +=
        '1. Check the production rate (`productionRate`) and ensure that it aligns with the expected factors used to achieve this rate (Temperature, Pressure, Motor Speed).\n';
    prompt +=
        '2. If the production rate does not correlate with the expected factors, mark it as anomaly data.\n';
    prompt += '3. Include only entries that have been marked as anomalies.\n';
    prompt +=
        '4. The anomaly field should be updated with the column name that caused the anomaly (e.g., temperature, pressure, motor speed).\n';
    prompt +=
        '5. Add a short description in the anomalyDescription field explaining why the data was marked as an anomaly (e.g., "Since the mentioned temperature is too high than expected, it is marked as anomaly data").\n\n';

    final String machineJson = jsonEncode(
      _machineDetails.map((machine) => machine.toJson()).toList(),
    );

    prompt += machineJson;
    prompt += '\n\nOutput Format (strict JSON):\n';
    prompt +=
        '[{"machineID": "M001", "anomalyDescription": "Since the mentioned temperature is too high than expected, it is marked as anomaly data"}]\n';
    return prompt;
  }

  Future<List<MachineData>> _convertAIResponseToMachine(String? data) async {
    if (data != null) {
      data = data.replaceAll(RegExp(r'^```json|```$|\s*```\s*$'), '').trim();

      if (data.startsWith('[')) {
        final parsedResponse = jsonDecode(data);

        if (parsedResponse is List) {
          for (final machine in parsedResponse) {
            final String machineID = machine['machineID'];
            final String anomalyDescription = machine['anomalyDescription'];

            for (final machine in _machineDetails) {
              if (machine.machineID == machineID) {
                machine.anomalyDescription = anomalyDescription;
                _machineDataSource._anomalyData.add(anomalyDescription);
                break;
              }
            }
          }
        }
      }
    }

    return _machineDetails;
  }

  Future<void> _sendChatMessage(String message) async {
    setState(() => _isLoading = true);
    List<MachineData> updatedMachineDetails = [];
    try {
      final GenerateContentResponse response = await _chat.sendMessage(
        Content.text(message),
      );
      updatedMachineDetails = await _convertAIResponseToMachine(response.text);
    } catch (e) {
      updatedMachineDetails = await _convertAIResponseToMachine(machineData);
    } finally {
      if (updatedMachineDetails.isNotEmpty) {
        _machineDataSource.addColumns();
      }
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          title: const Center(
            child: Text(
              'Anomaly Detection',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          actions: [
            // Floating Action Button at the top
            Align(
              alignment: Alignment.topCenter,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (BuildContext context, Widget? child) {
                  return Container(
                    padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                    child: Transform.scale(
                      scale: _isPressed ? 1 : _animation.value,
                      child: FloatingActionButton(
                        mini: true,
                        backgroundColor: model.primaryColor,
                        onPressed: () {
                          if (!_isPressed) {
                            _sendChatMessage(_generatePrompt());
                            _isPressed = true;
                          }
                        },
                        child: Image.asset(
                          'images/ai_assist_view.png',
                          height: 30,
                          width: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: isMaterial3 ? Colors.transparent : null,
        ),
      ),
      body: Stack(
        children: [
          SfDataGrid(
            source: _machineDataSource,
            columns: _machineDataSource._columns,
            columnWidthMode: !_isWebOrDesktop && !model.isMobileResolution
                ? ColumnWidthMode.fill
                : ColumnWidthMode.none,
          ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  List<MachineData> getMachineData() {
    final List<MachineData> machineData = [
      MachineData('M001', 85, 120, 220, 1500, 100),
      MachineData('M002', 788, 115, 230, 1520, 105),
      MachineData('M003', 90, 118, 225, 1480, 95),
      MachineData('M004', 87, 112, 228, 1515, 110),
      MachineData('M005', 92, 116, 222, 21457, 980),
      MachineData('M006', 85, 119, 220, 1490, 102),
      MachineData('M007', 88, 114, 230, 1500, 104),
      MachineData('M008', 90, 1120, 225, 1470, 89),
      MachineData('M009', 87, 121, 228, 1505, 108),
      MachineData('M0010', 92, 117, 222, 1480, 100),
      MachineData('M0011', 86, 118, 2221, 1925, 103),
      MachineData('M0012', 89, 116, 229, 1519, 107),
    ];

    return machineData;
  }

  @override
  void dispose() {
    _controller.dispose();
    _isPressed = false;
    _isLoading = false;
    super.dispose();
  }
}

class MachineData {
  MachineData(
    this.machineID,
    this.temperature,
    this.pressure,
    this.voltage,
    this.motorSpeed,
    this.productionRate, {
    this.anomalyDescription =
        'The factor that supporting the Production rate is releveant to the count produced, hence the row data is marked as normal data',
  });

  final String machineID;
  final int temperature;
  final int pressure;
  final int voltage;
  final int motorSpeed;
  final int productionRate;
  String anomalyDescription;

  Map<String, dynamic> toJson() {
    return {
      'machineID': machineID,
      'temperature': temperature,
      'pressure': pressure,
      'voltage': voltage,
      'motorSpeed': motorSpeed,
      'productionRate': productionRate,
      'anomalyDescription': anomalyDescription,
    };
  }

  dynamic operator [](String key) {
    switch (key) {
      case 'MachineID':
        return machineID;
      case 'Temperature':
        return temperature;
      case 'Pressure':
        return pressure;
      case 'Voltage':
        return voltage;
      case 'MotorSpeed':
        return motorSpeed;
      case 'ProductionRate':
        return productionRate;
      case 'AnomalyDescription':
        return anomalyDescription;
      default:
        throw ArgumentError('Invalid property: $key');
    }
  }
}

class MachineDataSource extends DataGridSource {
  MachineDataSource({
    required this.machine,
    required this.isWebOrDesktop,
    required this.model,
  }) {
    _columns = _obtainColumns();
    _buildDataGridRows();
  }

  List<GridColumn> _columns = [];

  List<MachineData> machine;

  List<DataGridRow> _employeeData = [];

  final List<String> _anomalyData = [];

  bool isWebOrDesktop;

  SampleModel model;

  final conditions = {
    'Temperature': 'temperature',
    'Voltage': 'voltage',
    'Pressure': 'pressure',
    'MotorSpeed': 'motorSpeed',
  };

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((e) {
        Color? getColor() {
          final bool isDarkMode = model.themeData.brightness == Brightness.dark;
          if (e.columnName == 'AnomalyDescription') {
            return _anomalyData.contains(e.value)
                ? (isDarkMode
                      ? const Color(0xFFA15C07)
                      : const Color(0xFFFFD6AE))
                : (isDarkMode
                      ? const Color(0xFF4F7A21)
                      : const Color(0xFFD0F8AB));
          }

          final String? keyword = conditions[e.columnName];
          if (keyword != null && _anomalyData.isNotEmpty) {
            final cell = row.getCells()[6];
            if (cell.value != null && cell.value.toString().contains(keyword)) {
              return isDarkMode
                  ? const Color(0xFFA15C07)
                  : const Color(0xFFFFD6AE);
            }
          }
          return null;
        }

        return Container(
          color: getColor(),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(e.value.toString()),
        );
      }).toList(),
    );
  }

  void _buildDataGridRows() {
    _employeeData = machine.map<DataGridRow>((machine) {
      return DataGridRow(
        cells: _columns.map<DataGridCell>((column) {
          return DataGridCell(
            columnName: column.columnName,
            value: machine[column.columnName],
          );
        }).toList(),
      );
    }).toList();
  }

  void addColumns() {
    _columns.addAll([
      GridColumn(
        columnName: 'AnomalyDescription',
        columnWidthMode: ColumnWidthMode.fitByCellValue,
        minimumWidth: 120,
        label: Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.center,
          child: const Text('Anomaly Description'),
        ),
      ),
    ]);
    _buildDataGridRows();
    notifyListeners();
  }

  List<GridColumn> _obtainColumns() {
    return <GridColumn>[
      GridColumn(
        columnName: 'MachineID',
        columnWidthMode: !isWebOrDesktop
            ? ColumnWidthMode.none
            : ColumnWidthMode.fill,
        minimumWidth: 120,
        label: Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.center,
          child: const Text('Machine ID'),
        ),
      ),
      GridColumn(
        columnName: 'Temperature',
        columnWidthMode: !isWebOrDesktop
            ? ColumnWidthMode.none
            : ColumnWidthMode.fill,
        minimumWidth: 120,
        label: Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.center,
          child: const Text('Temperature'),
        ),
      ),
      GridColumn(
        columnName: 'Pressure',
        columnWidthMode: !isWebOrDesktop
            ? ColumnWidthMode.none
            : ColumnWidthMode.fill,
        minimumWidth: 120,
        label: Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.center,
          child: const Text('Pressure'),
        ),
      ),
      GridColumn(
        columnName: 'Voltage',
        columnWidthMode: !isWebOrDesktop
            ? ColumnWidthMode.none
            : ColumnWidthMode.fill,
        minimumWidth: 120,
        label: Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.center,
          child: const Text('Voltage'),
        ),
      ),
      GridColumn(
        columnName: 'MotorSpeed',
        columnWidthMode: !isWebOrDesktop
            ? ColumnWidthMode.none
            : ColumnWidthMode.fill,
        minimumWidth: 120,
        label: Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.center,
          child: const Text('Motor Speed'),
        ),
      ),
      GridColumn(
        columnName: 'ProductionRate',
        columnWidthMode: !isWebOrDesktop
            ? ColumnWidthMode.none
            : ColumnWidthMode.fill,
        minimumWidth: 160,
        label: Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.center,
          child: const Text('Production Rate'),
        ),
      ),
    ];
  }
}

const String machineData = '''
[
  {
    "machineID": "M002",
    "temperature": 788,
    "pressure": 115,
    "voltage": 230,
    "motorSpeed": 1520,
    "productionRate": 105,
    "anomalyDescription": "Since the mentioned temperature is too high than expected, it is marked as anomaly data."
  },
  {
    "machineID": "M005",
    "temperature": 92,
    "pressure": 116,
    "voltage": 222,
    "motorSpeed": 21457,
    "productionRate": 980,
    "anomalyDescription": "Since the mentioned motorSpeed is too high than expected, it is marked as anomaly data."
  },
  {
    "machineID": "M008",
    "temperature": 90,
    "pressure": 1120,
    "voltage": 225,
    "motorSpeed": 1470,
    "productionRate": 89,
    "anomalyDescription": "Since the mentioned pressure is too high than expected, it is marked as anomaly data."
  },
  {
    "machineID": "M0011",
    "temperature": 86,
    "pressure": 118,
    "voltage": 2221,
    "motorSpeed": 1925,
    "productionRate": 103,
    "anomalyDescription": "Since the mentioned voltage is too high than expected, it is marked as anomaly data."
  }
]
''';
