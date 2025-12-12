///Package imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

///Pdf import
import 'package:syncfusion_flutter_pdf/pdf.dart';

///Local imports
import '../../model/sample_view.dart';
import 'helper/save_file_mobile.dart'
    if (dart.library.js_interop) 'helper/save_file_web.dart';

/// Render pdf of course completion certificate
class FormFillingPdf extends SampleView {
  /// Creates pdf of course completion certificate
  const FormFillingPdf(Key key) : super(key: key);
  @override
  _FormFillingPdfState createState() => _FormFillingPdfState();
}

class _FormFillingPdfState extends SampleViewState {
  _FormFillingPdfState();

  @override
  void dispose() {
    _dateController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  final TextEditingController _dateController = TextEditingController(
    text: DateFormat('MMMM d, yyyy').format(DateTime(2000, 5, 12)),
  );
  final TextEditingController _nameController = TextEditingController(
    text: 'John Milton',
  );
  final TextEditingController _emailController = TextEditingController(
    text: 'john.milton@example.com',
  );
  int _groupValue = 0;
  String _dropdownValue = 'Alabama';
  bool _newsletter = true;
  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('MMMM d, yyyy').format(selectedDate);
      });
    }
  }

  void _changed(int? value) {
    setState(() {
      _groupValue = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: model.sampleOutputCardColor,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'This sample shows how to fill the existing form fields in a PDF document. It also supports flattening the form fields.',
                  style: TextStyle(fontSize: 16, color: model.textColor),
                ),
                const SizedBox(height: 20, width: 30),
                TextFormField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Name',
                    labelStyle: TextStyle(
                      color:
                          model.themeData.colorScheme.brightness ==
                              Brightness.light
                          ? Colors.grey
                          : Colors.lightBlue,
                    ),
                  ),
                  controller: _nameController,
                  style: TextStyle(color: model.textColor),
                ),
                const SizedBox(height: 20, width: 30),
                TextFormField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      color:
                          model.themeData.colorScheme.brightness ==
                              Brightness.light
                          ? Colors.grey
                          : Colors.lightBlue,
                    ),
                  ),
                  controller: _emailController,
                  style: TextStyle(color: model.textColor),
                ),
                const SizedBox(height: 20, width: 30),
                InputDecorator(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Gender',
                    labelStyle: TextStyle(
                      color:
                          model.themeData.colorScheme.brightness ==
                              Brightness.light
                          ? Colors.grey
                          : Colors.lightBlue,
                    ),
                  ),
                  child: SizedBox(
                    height: 25,
                    child: RadioGroup<int>(
                      groupValue: _groupValue,
                      onChanged: _changed,
                      child: Row(children: _getGenderWidgets(context)),
                    ),
                  ),
                ),
                const SizedBox(height: 20, width: 30),
                TextFormField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Date Of Birth',
                    labelStyle: TextStyle(
                      color:
                          model.themeData.colorScheme.brightness ==
                              Brightness.light
                          ? Colors.grey
                          : Colors.lightBlue,
                    ),
                  ),
                  controller: _dateController,
                  style: TextStyle(color: model.textColor),
                  onTap: () {
                    _selectDate(context);
                  },
                ),
                const SizedBox(height: 20, width: 30),
                DropdownButtonFormField<String>(
                  initialValue: _dropdownValue,
                  onChanged: (String? newValue) {
                    _dropdownValue = newValue!;
                  },
                  items:
                      <String>[
                            'Alabama',
                            'Alaska',
                            'Arizona',
                            'Arkansas',
                            'California',
                            'Colorado',
                            'Connecticut',
                            'Delaware',
                            'Florida',
                            'Georgia',
                            'Hawaii',
                            'Idaho',
                            'Illinois',
                            'Indiana',
                            'Iowa',
                            'Kansas',
                            'Kentucky',
                            'Louisiana',
                            'Maine',
                            'Maryland',
                            'Massachusetts',
                            'Michigan',
                            'Minnesota',
                            'Mississippi',
                            'Missouri',
                            'Montana',
                            'Nebraska',
                            'Nevada',
                            'New Jersey',
                            'New Mexico',
                            'New York',
                            'North Carolina',
                            'North Dakota',
                            'Ohio',
                            'Oklahoma',
                            'Oregon',
                            'Pennsylvania',
                            'South Carolina',
                            'South Dakota',
                            'Tennessee',
                            'Texas',
                            'Utah',
                            'Vermont',
                            'Virginia',
                            'Washington',
                            'West Virginia',
                            'Wisconsin',
                            'Wyoming',
                          ]
                          .map<DropdownMenuItem<String>>(
                            (String e) => DropdownMenuItem<String>(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList(),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Coming from',
                    labelStyle: TextStyle(
                      color:
                          model.themeData.colorScheme.brightness ==
                              Brightness.light
                          ? Colors.grey
                          : Colors.lightBlue,
                    ),
                  ),
                ),
                const SizedBox(height: 5, width: 30),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: _newsletter,
                      onChanged: (bool? value) {
                        setState(() {
                          _newsletter = value!;
                        });
                      },
                    ),
                    const Text('Would you like to receive our Newsletter?'),
                  ],
                ),
                const SizedBox(height: 10, width: 30),
                Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: _getButtonWidgets(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getButtonWidgets(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextButton(
          onPressed: _viewTemplate,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(model.primaryColor),
            padding: model.isMobile
                ? null
                : WidgetStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  ),
          ),
          child: const Text(
            'View Template',
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 0, width: 12),
        TextButton(
          onPressed: () => _fillFormFields(false),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(model.primaryColor),
            padding: model.isMobile
                ? null
                : WidgetStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  ),
          ),
          child: const Text('Fill Form', style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(height: 0, width: 12),
        TextButton(
          onPressed: () => _fillFormFields(true),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(model.primaryColor),
            padding: model.isMobile
                ? null
                : WidgetStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  ),
          ),
          child: const Text(
            'Fill And Flatten',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  List<Widget> _getGenderWidgets(BuildContext context) {
    return <Widget>[
      Row(
        children: <Widget>[
          const Radio<int>(
            value: 0,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          Text('Male', style: TextStyle(fontSize: 16, color: model.textColor)),
        ],
      ),
      Row(
        children: <Widget>[
          const Radio<int>(
            value: 2,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          Text(
            'Female',
            style: TextStyle(fontSize: 16, color: model.textColor),
          ),
        ],
      ),
      Row(
        children: <Widget>[
          const Radio<int>(
            value: 1,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          Text(
            'Unspecified',
            style: TextStyle(fontSize: 16, color: model.textColor),
          ),
        ],
      ),
    ];
  }

  Future<void> _fillFormFields(bool isFlatten) async {
    //Load the existing PDF document
    final PdfDocument document = PdfDocument(
      inputBytes: await _readData('form_template.pdf'),
    );

    //Get the form
    final PdfForm form = document.form;

    //Get text box and fill value
    final PdfTextBoxField name = document.form.fields[1] as PdfTextBoxField;
    name.text = _nameController.text;

    final PdfTextBoxField email = document.form.fields[2] as PdfTextBoxField;
    email.text = _emailController.text;

    //Get the radio button and select
    final PdfRadioButtonListField gender =
        form.fields[3] as PdfRadioButtonListField;
    gender.selectedIndex = _groupValue;

    final PdfTextBoxField dob = form.fields[0] as PdfTextBoxField;
    dob.text = _dateController.text;

    //Get the combo box field and select
    final PdfComboBoxField country = form.fields[4] as PdfComboBoxField;
    country.selectedValue = _dropdownValue;

    //Get the checkbox field
    final PdfCheckBoxField newsletter = form.fields[5] as PdfCheckBoxField;
    newsletter.isChecked = _newsletter;

    //Disable to view the form field values properly in mobile viewers
    form.setDefaultAppearance(false);

    // Set flatten
    if (isFlatten) {
      form.flattenAllFields();
    }

    //Save and launch the document
    final List<int> bytes = await document.save();
    //Dispose the document.
    document.dispose();

    //Save and launch file.
    await FileSaveHelper.saveAndLaunchFile(
      bytes,
      isFlatten ? 'Flatten.pdf' : 'Form.pdf',
    );
  }

  Future<void> _viewTemplate() async {
    final List<int> documentBytes = await _readData('form_template.pdf');
    await FileSaveHelper.saveAndLaunchFile(documentBytes, 'form_template.pdf');
  }

  Future<List<int>> _readData(String name) async {
    final ByteData data = await rootBundle.load('assets/pdf/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }
}
