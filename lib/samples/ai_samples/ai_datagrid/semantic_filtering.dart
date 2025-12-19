import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../model/model.dart';
import '../../../model/sample_view.dart';

/// Renders semantic filtering data grid
class SemanticFilteringSample extends SampleView {
  /// Creates semantic filtering data grid
  const SemanticFilteringSample({Key? key}) : super(key: key);

  @override
  _SemanticFilteringSampleState createState() =>
      _SemanticFilteringSampleState();
}

class _SemanticFilteringSampleState extends SampleViewState
    with SingleTickerProviderStateMixin {
  late final GenerativeModel _model;
  late final ChatSession _chat;
  late PatientDataSource _patientDataSource;
  late List<PatientRecord> _patientRecord;
  final TextEditingController searchController = TextEditingController();
  late bool _isWebOrDesktop;
  late ValueNotifier<bool> isLoadingNotifier;
  late bool isMaterial3;

  @override
  void initState() {
    super.initState();
    _isWebOrDesktop = model.isWeb || model.isDesktop;
    _patientRecord = getPatientRecords();
    _model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: model.assistApiKey,
    );
    _chat = _model.startChat();
    _isWebOrDesktop = model.isWeb || model.isDesktop;
    _patientDataSource = PatientDataSource(
      patient: _patientRecord,
      isWebOrDesktop: _isWebOrDesktop,
      model: model,
    );
    isLoadingNotifier = ValueNotifier(false);
    isMaterial3 = model.themeData.useMaterial3;
  }

  String _generatePrompt() {
    // Extract all symptoms from local patient records.
    final List<String> allSymptoms = _patientRecord
        .map((record) => record.symptoms)
        .expand(
          (symptom) =>
              symptom.split(RegExp(r',|\band\b', caseSensitive: false)),
        )
        .map((symptom) => symptom.trim())
        .where((symptom) => symptom.isNotEmpty)
        .toSet()
        .toList();

    final String availableSymptoms = allSymptoms.join(', ');

    return '''
The user is searching for medical records based on symptoms.

**Task:**
- Given the input symptom: "${searchController.text}", return the **only 5 most closely related symptoms** from the provided list.
- **Do not add any new symptoms** outside the given list.
- The result must include the **original input symptom** - it should not exceed 5 symptoms.
- Format the output as a **comma-separated list**.
- The response must be **deterministic** — strictly always return the same result for the same input.
- Strictly do not re-rank, reshuffle, or vary results across repeated queries for the same input.

**Available Symptoms in Local Data:**
$availableSymptoms

**Example Input:** "Fever" 
**Example Output:** "Fever, high temperature, chills, sweating" (Only if these exist in the provided list)

**Important: STRICTLY follow these rules — NO EXCEPTIONS:**
- Output must be a **comma-separated list of symptoms only** (no bullet points, no explanation).
- Include **only symptoms from the provided list**.
- Return **a maximum of 5 symptoms**, including the input - it should not exceed 5 symptoms.
- Return a list of up to 5 symptoms, ensuring the original input symptom is included. Do not return more than 5 symptoms under any circumstance. Fewer than 5 is acceptable, but absolutely no more than 5.
- The **original input must be included**, even if it has no close matches.
- If the input is not in the list, return the **most closest matching symptoms only** — do not include the input itself.
- If fewer than 5 related symptoms exist, include only what is available — but never more than 5 in total.
- If more than 5 related symptoms exist, **only include the most relevant ones up to 5** — ignore the rest.
- The output must be **consistent for the same input** — always return the same result when the same symptom is entered again.
- For a given input, **always return the same output**. The result must be deterministic — **do not vary the output for the same input across different calls**.

Now, generate a similar list for "${searchController.text}".

''';
  }

  Future<void> _convertAIResponseToPatients(String? data) async {
    if (data == null || data.isEmpty) {
      return;
    }

    _patientDataSource.clearFilters(columnName: 'Symptoms');

    // Split the response into individual terms.
    final relatedTerms = data
        .split(',')
        .map((e) => e.trim().toLowerCase())
        .where((term) => term.isNotEmpty)
        .toList();

    // Apply each related term as a separate filter condition.
    // ignore: prefer_foreach
    for (final String term in relatedTerms) {
      _filteringRows(term);
    }
  }

  void _filteringRows(String value) {
    _patientDataSource.addFilter(
      'Symptoms',
      FilterCondition(
        type: FilterType.contains,
        filterBehavior: FilterBehavior.stringDataType,
        value: value,
      ),
    );
  }

  Future<void> _sendChatMessage(String message) async {
    isLoadingNotifier.value = true;
    try {
      final response = await _chat.sendMessage(Content.text(message));
      await _convertAIResponseToPatients(response.text);
    } catch (e) {
      _patientDataSource.clearFilters();
      _filteringRows(searchController.text);
    } finally {
      isLoadingNotifier.value = false;
    }
  }

  Widget _buildSearchTextField() {
    return SizedBox(
      width: 250,
      height: 45,
      child: ValueListenableBuilder(
        valueListenable: searchController,
        builder: (context, value, child) {
          return TextField(
            controller: searchController,
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                _sendChatMessage(_generatePrompt());
              }
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              hintText: 'Search',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  _isWebOrDesktop || !isMaterial3 ? 4 : 100,
                ),
              ),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                        isLoadingNotifier.value = true;

                        Future.delayed(const Duration(seconds: 1), () {
                          _patientDataSource.clearFilters();
                          isLoadingNotifier.value = false;
                        });
                      },
                    )
                  : null,
            ),
            onChanged: (value) {
              if (value.trim().isEmpty) {
                isLoadingNotifier.value = true;

                Future.delayed(const Duration(seconds: 1), () {
                  _patientDataSource.clearFilters();
                  isLoadingNotifier.value = false;
                });
                return;
              }
            },
          );
        },
      ),
    );
  }

  Widget searchField() {
    return Padding(
      padding: EdgeInsets.only(
        left: 12,
        top: 10,
        right: !_isWebOrDesktop && model.isMobileResolution ? 12 : 0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!_isWebOrDesktop && model.isMobileResolution)
            Expanded(child: _buildSearchTextField())
          else
            _buildSearchTextField(),
          const SizedBox(width: 10),
          SizedBox(
            height: 45,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: model.themeData.colorScheme.primary,
              ),
              onPressed: () {
                if (searchController.text.trim().isNotEmpty) {
                  _sendChatMessage(_generatePrompt());
                }
              },
              child: Text(
                'Search',
                style: TextStyle(color: model.themeData.colorScheme.onPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          title: const Center(
            child: Text(
              'AI-Powered Smart Filtering',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          automaticallyImplyLeading: false,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: isMaterial3 ? Colors.transparent : null,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!_isWebOrDesktop && model.isMobileResolution)
                  Expanded(child: searchField())
                else
                  searchField(),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                SfDataGrid(
                  source: _patientDataSource,
                  columns: _patientDataSource._columns,
                  columnWidthMode: !_isWebOrDesktop && !model.isMobileResolution
                      ? ColumnWidthMode.fill
                      : ColumnWidthMode.auto,
                  onQueryRowHeight: (details) => _isWebOrDesktop ? 60.0 : 80.0,
                  placeholder: const Center(
                    child: Text(
                      'No Records Found',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),

                ValueListenableBuilder<bool>(
                  valueListenable: isLoadingNotifier,
                  builder: (context, isLoading, child) {
                    return isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PatientRecord> getPatientRecords() {
    return [
      PatientRecord(
        recordId: 1,
        patientId: 615001,
        symptoms: 'Fever, cough, and shortness of breath.',
        diagnosis: 'Pneumonia',
        doctorInfo: 'Dr. John Smith - Specialized in Pulmonology',
      ),
      PatientRecord(
        recordId: 2,
        patientId: 615002,
        symptoms: 'Severe headache, nausea, and sensitivity to light.',
        diagnosis: 'Migraine',
        doctorInfo: 'Dr. Alice Brown - Specialized in Neurology',
      ),
      PatientRecord(
        recordId: 3,
        patientId: 615003,
        symptoms: 'Fatigue, weight gain, and hair loss.',
        diagnosis: 'Hypothyroidism',
        doctorInfo: 'Dr. Robert Johnson - Specialized in Endocrinology',
      ),
      PatientRecord(
        recordId: 4,
        patientId: 615004,
        symptoms: 'Chest pain, shortness of breath, and sweating.',
        diagnosis: 'Heart Attack',
        doctorInfo: 'Dr. Michael Williams - Specialized in Cardiology',
      ),
      PatientRecord(
        recordId: 5,
        patientId: 615005,
        symptoms: 'Joint pain, stiffness, and swelling.',
        diagnosis: 'Arthritis',
        doctorInfo: 'Dr. Mary Jones - Specialized in Rheumatology',
      ),
      PatientRecord(
        recordId: 6,
        patientId: 615006,
        symptoms: 'Abdominal pain, bloating, and irregular bowel movements.',
        diagnosis: 'Irritable Bowel Syndrome (IBS)',
        doctorInfo: 'Dr. Patricia Garcia - Specialized in Gastroenterology',
      ),
      PatientRecord(
        recordId: 7,
        patientId: 615007,
        symptoms:
            'Frequent urination, excessive thirst, and unexplained weight loss.',
        diagnosis: 'Diabetes',
        doctorInfo: 'Dr. Robert Johnson - Specialized in Endocrinology',
      ),
      PatientRecord(
        recordId: 8,
        patientId: 615008,
        symptoms: 'Persistent sadness, loss of interest, and fatigue.',
        diagnosis: 'Depression',
        doctorInfo: 'Dr. Linda Martinez - Specialized in Psychiatry',
      ),
      PatientRecord(
        recordId: 9,
        patientId: 615009,
        symptoms: 'Shortness of breath, wheezing, and chronic cough.',
        diagnosis: 'Asthma',
        doctorInfo: 'Dr. John Smith - Specialized in Pulmonology',
      ),
      PatientRecord(
        recordId: 10,
        patientId: 615010,
        symptoms: 'High blood pressure, headaches, and blurred vision.',
        diagnosis: 'Hypertension',
        doctorInfo: 'Dr. Michael Williams - Specialized in Cardiology',
      ),
      PatientRecord(
        recordId: 11,
        patientId: 615011,
        symptoms: 'Skin rash, itching, and redness.',
        diagnosis: 'Eczema',
        doctorInfo: 'Dr. Susan Clark - Specialized in Dermatology',
      ),
      PatientRecord(
        recordId: 12,
        patientId: 615012,
        symptoms: 'Frequent heartburn, chest discomfort, and acid reflux.',
        diagnosis: 'Gastroesophageal Reflux Disease (GERD)',
        doctorInfo: 'Dr. Patricia Garcia - Specialized in Gastroenterology',
      ),
      PatientRecord(
        recordId: 13,
        patientId: 615013,
        symptoms: 'Tremors, slow movement, and muscle stiffness.',
        diagnosis: "Parkinson's Disease",
        doctorInfo: 'Dr. Alice Brown - Specialized in Neurology',
      ),
      PatientRecord(
        recordId: 14,
        patientId: 615014,
        symptoms: 'Severe lower back pain and difficulty moving.',
        diagnosis: 'Herniated Disc',
        doctorInfo: 'Dr. Michael Williams - Specialized in Cardiology',
      ),
      PatientRecord(
        recordId: 15,
        patientId: 615015,
        symptoms: 'Sudden vision loss, eye pain, and redness.',
        diagnosis: 'Glaucoma',
        doctorInfo: 'Dr. Nancy Wilson - Specialized in Ophthalmology',
      ),
      PatientRecord(
        recordId: 16,
        patientId: 615016,
        symptoms: 'Episodes of unconsciousness and muscle spasms.',
        diagnosis: 'Epilepsy',
        doctorInfo: 'Dr. Alice Brown - Specialized in Neurology',
      ),
      PatientRecord(
        recordId: 17,
        patientId: 615017,
        symptoms:
            'Painful urination, lower abdominal pain, and frequent urge to urinate.',
        diagnosis: 'Urinary Tract Infection (UTI)',
        doctorInfo: 'Dr. Linda Martinez - Specialized in Psychiatry',
      ),
      PatientRecord(
        recordId: 18,
        patientId: 615018,
        symptoms:
            'Persistent dry mouth, difficulty swallowing, and joint pain.',
        diagnosis: "Sjogren's Syndrome",
        doctorInfo: 'Dr. Mary Jones - Specialized in Rheumatology',
      ),
      PatientRecord(
        recordId: 19,
        patientId: 615019,
        symptoms: 'Loss of balance, dizziness, and vision problems.',
        diagnosis: 'Multiple Sclerosis',
        doctorInfo: 'Dr. Alice Brown - Specialized in Neurology',
      ),
      PatientRecord(
        recordId: 20,
        patientId: 615020,
        symptoms: 'Persistent cough with blood, chest pain, and weight loss.',
        diagnosis: 'Tuberculosis',
        doctorInfo: 'Dr. John Smith - Specialized in Pulmonology',
      ),
    ];
  }

  @override
  void dispose() {
    isLoadingNotifier.dispose();
    super.dispose();
  }
}

class PatientRecord {
  PatientRecord({
    required this.recordId,
    required this.patientId,
    required this.symptoms,
    required this.diagnosis,
    required this.doctorInfo,
  });

  final int recordId;
  final int patientId;
  final String symptoms;
  final String diagnosis;
  final String doctorInfo;

  Map<String, dynamic> toJson() {
    return {
      'recordId': recordId,
      'patientId': patientId,
      'symptoms': symptoms,
      'diagnosis': diagnosis,
      'doctorInfo': doctorInfo,
    };
  }

  Object? operator [](Object? value) {
    switch (value) {
      case 'RecordID':
        return recordId;
      case 'PatientID':
        return patientId;
      case 'Symptoms':
        return symptoms;
      case 'Diagnosis':
        return diagnosis;
      case 'DoctorInfo':
        return doctorInfo;
      default:
        throw ArgumentError('Invalid property: $value');
    }
  }
}

class PatientDataSource extends DataGridSource {
  PatientDataSource({
    required this.patient,
    required this.isWebOrDesktop,
    required this.model,
  }) {
    _columns = _obtainColumns();
    _buildDataGridRows();
  }

  List<GridColumn> _columns = [];

  List<PatientRecord> patient;

  bool isWebOrDesktop;

  SampleModel model;

  List<DataGridRow> _patientData = [];

  @override
  List<DataGridRow> get rows => _patientData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((e) {
        final columnAlignment =
            e.columnName == 'PatientID' || e.columnName == 'RecordID'
            ? Alignment.center
            : Alignment.centerLeft;
        return Container(
          alignment: columnAlignment,
          padding: const EdgeInsets.all(8.0),
          child: Text(e.value == null ? '' : e.value.toString()),
        );
      }).toList(),
    );
  }

  void _buildDataGridRows() {
    _patientData = patient.map<DataGridRow>((cell) {
      return DataGridRow(
        cells: _columns.map<DataGridCell>((column) {
          return DataGridCell(
            columnName: column.columnName,
            value: cell[column.columnName],
          );
        }).toList(),
      );
    }).toList();
  }

  void updateDataRow(int rowIndex, PatientRecord student) {
    _patientData[rowIndex] = DataGridRow(
      cells: _columns.map<DataGridCell>((column) {
        return DataGridCell(
          columnName: column.columnName,
          value: student[column.columnName],
        );
      }).toList(),
    );
  }

  List<GridColumn> _obtainColumns() {
    return <GridColumn>[
      GridColumn(
        columnName: 'RecordID',
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
          child: const Text('Record ID', softWrap: true),
        ),
      ),
      GridColumn(
        columnName: 'PatientID',
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
          child: const Text('Patient ID', softWrap: true),
        ),
      ),
      GridColumn(
        columnName: 'Symptoms',
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
          child: const Text('Symptoms', softWrap: true),
        ),
      ),
      GridColumn(
        columnName: 'Diagnosis',
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
          child: const Text('Diagnosis', softWrap: true),
        ),
      ),
      GridColumn(
        columnName: 'DoctorInfo',
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
          child: const Text('Doctor Information', softWrap: true),
        ),
      ),
    ];
  }
}
