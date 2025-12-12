import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

/// DataGrid import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../../model/sample_view.dart';
import '../../../model/model.dart';
import '../../helper/ai_pop_up_api_key.dart';

/// Renders predictive data data grid
class PredictiveDataSample extends SampleView {
  /// Creates predictive data data grid
  const PredictiveDataSample({Key? key}) : super(key: key);

  @override
  _PredictiveDataSampleState createState() => _PredictiveDataSampleState();
}

class _PredictiveDataSampleState extends SampleViewState
    with SingleTickerProviderStateMixin {
  late final GenerativeModel _model;
  late final ChatSession _chat;
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isPressed = false;
  late StudentDataSource _studentDataSource;
  late List<StudentDetails> _studentDetails;
  bool _isLoading = false;
  late bool _isWebOrDesktop;
  late bool isMaterial3;

  @override
  void initState() {
    super.initState();
    _isWebOrDesktop = model.isWeb || model.isDesktop;
    _studentDetails = getStudentData();
    _model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: model.assistApiKey,
    );
    _chat = _model.startChat();
    _studentDataSource = StudentDataSource(
      student: _studentDetails,
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
    prompt += 'Each student should have the following properties: ';
    prompt +=
        '`studentID` (int), `finalYearGPA` (Double), `totalGPA` (Double), and `totalGrade` (String). ';
    prompt += 'Here is the data and calculation criteria:\n\n';

    prompt +=
        '1. `finalYearGPA` should be equal of the GPA from the third year (thirdYearGPA) only.\n';
    prompt +=
        "2. `totalGPA` should be the average of all three years' GPAs (first, second, and third years) with one decimal digit.\n";
    prompt +=
        '3. `totalGrade` should be assigned based on `totalGPA` following standard grading. Updated the grade based on following details, 0 - 2.5 = F, 2.6 - 2.9 = C, 3.0 - 3.4 = B, 3.5 - 3.9 = B+, 4.0 - 4.4 = A, 4.5 - 5 = A+.\n\n';

    final String studentJson = jsonEncode(
      _studentDetails.map((student) => student.toJson()).toList(),
    );

    prompt += studentJson;
    prompt += '\nRespond in this JSON format:\n';
    return prompt;
  }

  Future<List<StudentDetails>> _convertAIResponseToStudents(
    String? data,
  ) async {
    if (data != null) {
      data = data.replaceAll(RegExp(r'^```json|```$|\s*```\s*$'), '').trim();

      if (data.startsWith('[')) {
        final parsedResponse = jsonDecode(data);

        if (parsedResponse is List) {
          int rowIndex = 0;
          for (final student in parsedResponse) {
            final int studentID = student['studentID'];
            final double finalYearGPA = student['finalYearGPA'];
            final double totalGPA = (student['totalGPA'] as num).toDouble();
            final String totalGrade = student['totalGrade'];

            for (final student in _studentDetails) {
              if (student.studentID == studentID) {
                student.finalYearGPA = finalYearGPA;
                _studentDataSource.updateDataRow(rowIndex, student);
                _studentDataSource.updateDataGridSource(
                  rowColumnIndex: RowColumnIndex(rowIndex, 5),
                );
                student.totalGPA = totalGPA;
                _studentDataSource.updateDataRow(rowIndex, student);
                _studentDataSource.updateDataGridSource(
                  rowColumnIndex: RowColumnIndex(rowIndex, 6),
                );
                student.totalGrade = totalGrade;
                _studentDataSource.updateDataRow(rowIndex, student);
                _studentDataSource.updateDataGridSource(
                  rowColumnIndex: RowColumnIndex(rowIndex, 7),
                );
                rowIndex++;
                await Future.delayed(const Duration(milliseconds: 150));
                break;
              }
            }
            _studentDataSource.notifyListeners();
          }
        }
      }
    }

    return _studentDetails;
  }

  Future<void> _sendChatMessage(String message) async {
    _studentDataSource.addColumns();
    setState(() => _isLoading = true);
    List<StudentDetails> updatedStudents = [];

    try {
      final GenerateContentResponse response = await _chat.sendMessage(
        Content.text(message),
      );
      updatedStudents = await _convertAIResponseToStudents(response.text);
    } catch (e) {
      updatedStudents = await _convertAIResponseToStudents(studentData);
    } finally {
      if (updatedStudents.isNotEmpty) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          title: const Center(
            child: Text(
              'Predictive Data Entry',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          automaticallyImplyLeading: false,
          actions: [
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
            source: _studentDataSource,
            columns: _studentDataSource._columns,
            columnWidthMode: ColumnWidthMode.fill,
          ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  List<StudentDetails> getStudentData() {
    final List<StudentDetails> students = [];
    students.add(
      StudentDetails(
        studentID: 2001,
        studentName: 'John Smith',
        firstYearGPA: 4.7,
        secondYearGPA: 4.1,
        thirdYearGPA: 5.0,
      ),
    );
    students.add(
      StudentDetails(
        studentID: 2002,
        studentName: 'Emily Davis',
        firstYearGPA: 3.3,
        secondYearGPA: 3.5,
        thirdYearGPA: 3.7,
      ),
    );
    students.add(
      StudentDetails(
        studentID: 2003,
        studentName: 'Micheal Lee',
        firstYearGPA: 3.9,
        secondYearGPA: 3.8,
        thirdYearGPA: 3.9,
      ),
    );
    students.add(
      StudentDetails(
        studentID: 2004,
        studentName: 'Sarah Brown',
        firstYearGPA: 2.0,
        secondYearGPA: 2.7,
        thirdYearGPA: 2.5,
      ),
    );
    students.add(
      StudentDetails(
        studentID: 2005,
        studentName: 'James Wilson',
        firstYearGPA: 3.0,
        secondYearGPA: 3.5,
        thirdYearGPA: 3.2,
      ),
    );
    students.add(
      StudentDetails(
        studentID: 2006,
        studentName: 'Sarah Jane',
        firstYearGPA: 3.7,
        secondYearGPA: 3.0,
        thirdYearGPA: 4.3,
      ),
    );
    students.add(
      StudentDetails(
        studentID: 2007,
        studentName: 'Emily Rose',
        firstYearGPA: 5.0,
        secondYearGPA: 4.9,
        thirdYearGPA: 4.8,
      ),
    );
    students.add(
      StudentDetails(
        studentID: 2008,
        studentName: 'John Michael',
        firstYearGPA: 4.0,
        secondYearGPA: 4.1,
        thirdYearGPA: 4.2,
      ),
    );
    students.add(
      StudentDetails(
        studentID: 2009,
        studentName: 'David James',
        firstYearGPA: 1.5,
        secondYearGPA: 2.2,
        thirdYearGPA: 2.3,
      ),
    );
    students.add(
      StudentDetails(
        studentID: 2010,
        studentName: 'Mary Ann',
        firstYearGPA: 2.7,
        secondYearGPA: 2.1,
        thirdYearGPA: 3.0,
      ),
    );
    students.add(
      StudentDetails(
        studentID: 2011,
        studentName: 'Robert Paul',
        firstYearGPA: 2.9,
        secondYearGPA: 3.7,
        thirdYearGPA: 3.9,
      ),
    );
    students.add(
      StudentDetails(
        studentID: 2012,
        studentName: 'Laura Grace',
        firstYearGPA: 4.0,
        secondYearGPA: 3.1,
        thirdYearGPA: 3.7,
      ),
    );
    students.add(
      StudentDetails(
        studentID: 2013,
        studentName: 'William Henry',
        firstYearGPA: 4.0,
        secondYearGPA: 4.1,
        thirdYearGPA: 4.2,
      ),
    );
    students.add(
      StudentDetails(
        studentID: 2014,
        studentName: 'Anna Marie',
        firstYearGPA: 4.0,
        secondYearGPA: 4.0,
        thirdYearGPA: 4.1,
      ),
    );
    students.add(
      StudentDetails(
        studentID: 2015,
        studentName: 'Charles Thomas',
        firstYearGPA: 4.7,
        secondYearGPA: 4.8,
        thirdYearGPA: 4.9,
      ),
    );
    students.add(
      StudentDetails(
        studentID: 2016,
        studentName: 'Jennifer Lynn',
        firstYearGPA: 3.0,
        secondYearGPA: 3.1,
        thirdYearGPA: 3.2,
      ),
    );
    students.add(
      StudentDetails(
        studentID: 2017,
        studentName: 'Christopher Lee',
        firstYearGPA: 3.9,
        secondYearGPA: 3.9,
        thirdYearGPA: 4.2,
      ),
    );
    students.add(
      StudentDetails(
        studentID: 2018,
        studentName: 'Elizabeth Claire',
        firstYearGPA: 2.0,
        secondYearGPA: 2.1,
        thirdYearGPA: 2.2,
      ),
    );
    students.add(
      StudentDetails(
        studentID: 2019,
        studentName: 'Daniel Scott',
        firstYearGPA: 4.0,
        secondYearGPA: 4.1,
        thirdYearGPA: 3.3,
      ),
    );
    students.add(
      StudentDetails(
        studentID: 2020,
        studentName: 'Megan Louise',
        firstYearGPA: 3.0,
        secondYearGPA: 3.5,
        thirdYearGPA: 3.5,
      ),
    );
    return students;
  }

  @override
  void dispose() {
    _controller.dispose();
    _isPressed = false;
    _isLoading = false;
    super.dispose();
  }
}

class StudentDetails {
  StudentDetails({
    required this.studentID,
    required this.studentName,
    required this.firstYearGPA,
    required this.secondYearGPA,
    required this.thirdYearGPA,
    this.finalYearGPA,
    this.totalGPA,
    this.totalGrade,
  });

  final int studentID;
  final String studentName;
  final double firstYearGPA;
  final double secondYearGPA;
  final double thirdYearGPA;
  double? finalYearGPA;
  double? totalGPA;
  String? totalGrade;

  Map<String, dynamic> toJson() {
    return {
      'studentID': studentID,
      'firstYearGPA': firstYearGPA,
      'secondYearGPA': secondYearGPA,
      'thirdYearGPA': thirdYearGPA,
    };
  }

  Object? operator [](Object? value) {
    switch (value) {
      case 'StudentID':
        return studentID;
      case 'StudentName':
        return studentName;
      case 'FirstYearGPA':
        return firstYearGPA;
      case 'SecondYearGPA':
        return secondYearGPA;
      case 'ThirdYearGPA':
        return thirdYearGPA;
      case 'FinalYearGPA':
        return finalYearGPA;
      case 'TotalGPA':
        return totalGPA;
      case 'TotalGrade':
        return totalGrade;
      default:
        throw ArgumentError('Invalid property: $value');
    }
  }
}

class StudentDataSource extends DataGridSource {
  StudentDataSource({
    required this.student,
    required this.isWebOrDesktop,
    required this.model,
  }) {
    _columns = _obtainColumns();
    _buildDataGridRows();
  }

  List<GridColumn> _columns = [];

  bool isWebOrDesktop;

  SampleModel model;

  List<StudentDetails> student;

  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((e) {
        Color? getColor() {
          final bool isDarkMode = model.themeData.brightness == Brightness.dark;
          if (e.columnName == 'FinalYearGPA' || e.columnName == 'TotalGPA') {
            if (isDarkMode) {
              return const Color(0xFF095C37);
            } else {
              return const Color(0xFFAAF0C4);
            }
          } else if (e.columnName == 'TotalGrade') {
            if (e.value == 'A+' || e.value == 'A') {
              return isDarkMode
                  ? const Color(0xFF283618)
                  : const Color(0xFFD0EF84);
            } else if (e.value == 'B+' || e.value == 'B') {
              return isDarkMode
                  ? const Color(0xFFA15C07)
                  : const Color(0xFFFFD6AE);
            } else {
              return isDarkMode
                  ? const Color(0xFFDF2935)
                  : const Color(0xFFF08080);
            }
          }
          return null;
        }

        return Container(
          color: e.value == null ? null : getColor(),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(e.value == null ? '' : e.value.toString()),
        );
      }).toList(),
    );
  }

  void _buildDataGridRows() {
    _employeeData = student.map<DataGridRow>((student) {
      return DataGridRow(
        cells: _columns.map<DataGridCell>((column) {
          return DataGridCell(
            columnName: column.columnName,
            value: student[column.columnName],
          );
        }).toList(),
      );
    }).toList();
  }

  void updateDataRow(int rowIndex, StudentDetails student) {
    _employeeData[rowIndex] = DataGridRow(
      cells: _columns.map<DataGridCell>((column) {
        return DataGridCell(
          columnName: column.columnName,
          value: student[column.columnName],
        );
      }).toList(),
    );
  }

  void addColumns() {
    _columns.addAll([
      GridColumn(
        columnWidthMode: !isWebOrDesktop
            ? ColumnWidthMode.none
            : ColumnWidthMode.fill,
        width: !isWebOrDesktop
            ? 150
            : (isWebOrDesktop && model.isMobileResolution)
            ? 150.0
            : double.nan,
        minimumWidth: 150,
        columnName: 'FinalYearGPA',
        label: Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.center,
          child: const Text('Final Year GPA'),
        ),
      ),
      GridColumn(
        columnName: 'TotalGPA',
        minimumWidth: 150,
        columnWidthMode: !isWebOrDesktop
            ? ColumnWidthMode.none
            : ColumnWidthMode.fill,
        width: !isWebOrDesktop
            ? 150
            : (isWebOrDesktop && model.isMobileResolution)
            ? 150.0
            : double.nan,
        label: Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.center,
          child: const Text('Total GPA'),
        ),
      ),
      GridColumn(
        columnName: 'TotalGrade',
        minimumWidth: 150,
        columnWidthMode: !isWebOrDesktop
            ? ColumnWidthMode.none
            : ColumnWidthMode.fill,
        width: !isWebOrDesktop
            ? 150
            : (isWebOrDesktop && model.isMobileResolution)
            ? 150.0
            : double.nan,
        label: Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.center,
          child: const Text('Total Grade'),
        ),
      ),
    ]);
    _buildDataGridRows();
    notifyListeners();
  }

  List<GridColumn> _obtainColumns() {
    return <GridColumn>[
      GridColumn(
        columnName: 'StudentID',
        minimumWidth: 150,
        columnWidthMode: !isWebOrDesktop
            ? ColumnWidthMode.none
            : ColumnWidthMode.fill,
        width: isWebOrDesktop
            ? double.nan
            : (!isWebOrDesktop && model.isMobileResolution)
            ? 120.0
            : double.nan,
        label: Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.center,
          child: const Text('Student ID'),
        ),
      ),
      GridColumn(
        columnName: 'StudentName',
        minimumWidth: 150,
        columnWidthMode: !isWebOrDesktop
            ? ColumnWidthMode.none
            : ColumnWidthMode.fill,
        width: isWebOrDesktop
            ? double.nan
            : (!isWebOrDesktop && model.isMobileResolution)
            ? 150.0
            : double.nan,
        label: Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.center,
          child: const Text('Student Name'),
        ),
      ),
      GridColumn(
        columnName: 'FirstYearGPA',
        minimumWidth: 150,
        columnWidthMode: !isWebOrDesktop
            ? ColumnWidthMode.none
            : ColumnWidthMode.fill,
        width: isWebOrDesktop
            ? double.nan
            : (!isWebOrDesktop && model.isMobileResolution)
            ? 150.0
            : double.nan,
        label: Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.center,
          child: const Text('First Year GPA'),
        ),
      ),
      GridColumn(
        columnName: 'SecondYearGPA',
        minimumWidth: 150,
        columnWidthMode: !isWebOrDesktop
            ? ColumnWidthMode.none
            : ColumnWidthMode.fill,
        width: isWebOrDesktop
            ? double.nan
            : (!isWebOrDesktop && model.isMobileResolution)
            ? 150.0
            : double.nan,
        label: Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.center,
          child: const Text('Second Year GPA'),
        ),
      ),
      GridColumn(
        columnName: 'ThirdYearGPA',
        minimumWidth: 150,
        columnWidthMode: !isWebOrDesktop
            ? ColumnWidthMode.none
            : ColumnWidthMode.fill,
        width: isWebOrDesktop
            ? double.nan
            : (!isWebOrDesktop && model.isMobileResolution)
            ? 150.0
            : double.nan,
        label: Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.center,
          child: const Text('Third Year GPA'),
        ),
      ),
    ];
  }

  void updateDataGridSource({required RowColumnIndex rowColumnIndex}) {
    notifyDataSourceListeners(rowColumnIndex: rowColumnIndex);
  }
}

const String studentData = '''
[
    {
      "studentID": 2001,
      "finalYearGPA": 4.6,
      "totalGPA": 4.6,
      "totalGrade": "A+"
    },
    {
      "studentID": 2002,
      "finalYearGPA": 3.8,
      "totalGPA": 3.58,
      "totalGrade": "B+"
    },
    {
      "studentID": 2003,
      "finalYearGPA": 3.5,
      "totalGPA": 3.78,
      "totalGrade": "B+"
    },
    {
      "studentID": 2004,
      "finalYearGPA": 2.88,
      "totalGPA": 2.53,
      "totalGrade": "F"
    },
    {
      "studentID": 2005,
      "finalYearGPA": 3.5,
      "totalGPA": 3.3,
      "totalGrade": "B"
    },
    {
      "studentID": 2006,
      "finalYearGPA": 4.2,
      "totalGPA": 3.81,
      "totalGrade": "B+"
    },
    {
      "studentID": 2007,
      "finalYearGPA": 4.52,
      "totalGPA": 4.81,
      "totalGrade": "A+"
    },
    {
      "studentID": 2008,
      "finalYearGPA": 4.52,
      "totalGPA": 4.21,
      "totalGrade": "A"
    },
    {
      "studentID": 2009,
      "finalYearGPA": 2.52,
      "totalGPA": 2.13,
      "totalGrade": "F"
    },
    {
      "studentID": 2010,
      "finalYearGPA": 2.9,
      "totalGPA": 2.7,
      "totalGrade": "C"
    },
    {
      "studentID": 2011,
      "finalYearGPA": 4.05,
      "totalGPA": 3.64,
      "totalGrade": "B+"
    },
    {
      "studentID": 2012,
      "finalYearGPA": 4.2,
      "totalGPA": 3.75,
      "totalGrade": "B+"
    },
    {
      "studentID": 2013,
      "finalYearGPA": 4.5,
      "totalGPA": 4.2,
      "totalGrade": "A"
    },
    {
      "studentID": 2014,
      "finalYearGPA": 4.56,
      "totalGPA": 4.17,
      "totalGrade": "A"
    },
    {
      "studentID": 2015,
      "finalYearGPA": 4.55,
      "totalGPA": 4.73,
      "totalGrade": "A+"
    },
    {
      "studentID": 2016,
      "finalYearGPA": 3.9,
      "totalGPA": 3.3,
      "totalGrade": "B"
    },
    {
      "studentID": 2017,
      "finalYearGPA": 3.6,
      "totalGPA": 3.9,
      "totalGrade": "B+"
    },
    {
      "studentID": 2018,
      "finalYearGPA": 2.56,
      "totalGPA": 2.21,
      "totalGrade": "F"
    },
    {
      "studentID": 2019,
      "finalYearGPA": 4.21,
      "totalGPA": 3.9,
      "totalGrade": "B+"
    },
    {
      "studentID": 2020,
      "finalYearGPA": 3.6,
      "totalGPA": 3.4,
      "totalGrade": "B"
    }
]
''';
