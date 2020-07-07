import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter_examples/samples/pdf/helper/save_file_mobile.dart'
    if (dart.library.html) 'package:flutter_examples/samples/pdf/helper/save_file_web.dart';

//ignore: must_be_immutable
class CourseCompletionCertificatePdf extends StatefulWidget {
  CourseCompletionCertificatePdf({this.sample, Key key}) : super(key: key);
  SubItem sample;
  @override
  _CertificatePdfState createState() => _CertificatePdfState(sample);
}

class _CertificatePdfState extends State<CourseCompletionCertificatePdf> {
  _CertificatePdfState(this.sample);

  final SubItem sample;

  final TextEditingController _dateController = TextEditingController(
      text: DateFormat('MMMM d, yyyy').format(DateTime.now()));
  final TextEditingController _nameController =
      TextEditingController(text: 'John Milton');
  final TextEditingController _courceNameController =
      TextEditingController(text: 'Getting Started with PDF Development');
  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('MMMM d, yyyy').format(selectedDate);
      });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleModel model) {
          return Scaffold(
            backgroundColor: model.cardThemeColor,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        'This sample showcase how to dynamically generates the course completion certificate for online learning portal with participant name, course name and date of completion.',
                        style: TextStyle(fontSize: 16, color: model.textColor)),
                    TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Recipient Name',
                            labelStyle: TextStyle(
                                color: model.isLightThemeSelected
                                    ? Colors.grey
                                    : Colors.lightBlue)),
                        controller: _nameController,
                        style: TextStyle(color: model.textColor)),
                    TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Course Name',
                            labelStyle: TextStyle(
                                color: model.isLightThemeSelected
                                    ? Colors.grey
                                    : Colors.lightBlue)),
                        controller: _courceNameController,
                        style: TextStyle(color: model.textColor)),
                    TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Date',
                            labelStyle: TextStyle(
                                color: model.isLightThemeSelected
                                    ? Colors.grey
                                    : Colors.lightBlue)),
                        controller: _dateController,
                        style: TextStyle(color: model.textColor),
                        onTap: () {
                          _selectDate(context);
                        }),
                    FlatButton(
                      child: const Text(
                        'Generate PDF',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: _createCertificate,
                      color: model.backgroundColor,
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<void> _createCertificate() async {
    //Create a PDF document.
    final PdfDocument document = PdfDocument();
    document.pageSettings.orientation = PdfPageOrientation.landscape;
    document.pageSettings.margins.all = 0;
    //Add page to the PDF
    final PdfPage page = document.pages.add();
    //Get the page size
    final Size pageSize = page.getClientSize();
    //Draw image
    page.graphics.drawImage(PdfBitmap(await _readImageDate('certificate.jpg')),
        Rect.fromLTWH(0, 0, pageSize.width, pageSize.height));
    //Create font
    final PdfFont nameFont = PdfStandardFont(PdfFontFamily.helvetica, 22);
    final PdfFont controlFont = PdfStandardFont(PdfFontFamily.helvetica, 19);
    final PdfFont dateFont = PdfStandardFont(PdfFontFamily.helvetica, 16);
    double x =
        calculateXPosition(_nameController.text, nameFont, pageSize.width);
    page.graphics.drawString(_nameController.text, nameFont,
        bounds: Rect.fromLTWH(x, 253, 0, 0),
        brush: PdfSolidBrush(PdfColor(20, 58, 86)));
    x = calculateXPosition(
        _courceNameController.text, controlFont, pageSize.width);
    page.graphics.drawString(_courceNameController.text, controlFont,
        bounds: Rect.fromLTWH(x, 340, 0, 0),
        brush: PdfSolidBrush(PdfColor(20, 58, 86)));
    final String dateText = 'on ' + _dateController.text;
    x = calculateXPosition(dateText, dateFont, pageSize.width);
    page.graphics.drawString(dateText, dateFont,
        bounds: Rect.fromLTWH(x, 385, 0, 0),
        brush: PdfSolidBrush(PdfColor(20, 58, 86)));
    //Save and launch the document
    final List<int> bytes = document.save();
    //Dispose the document.
    document.dispose();
    //Save and launch file.
    FileSaveHelper.saveAndLaunchFile(bytes, 'Certificate.pdf');
  }

  double calculateXPosition(String text, PdfFont font, double pageWidth) {
    final Size textSize =
        font.measureString(text, layoutArea: Size(pageWidth, 0));
    return (pageWidth - textSize.width) / 2;
  }

  Future<List<int>> _readImageDate(String name) async {
    final ByteData data = await rootBundle.load('images/pdf/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }
}
