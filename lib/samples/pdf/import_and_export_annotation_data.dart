///Pdf import
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

///Local imports
import '../../model/sample_view.dart';
import 'helper/save_file_mobile.dart'
    if (dart.library.js_interop) 'helper/save_file_web.dart';

/// Import and export Annotation data from the PDF document.
class ImportAndExportAnnotationData extends SampleView {
  /// Import and export Annotation data from the PDF document.
  const ImportAndExportAnnotationData(Key key) : super(key: key);
  @override
  _ImportAndExportAnnotationDataState createState() =>
      _ImportAndExportAnnotationDataState();
}

class _ImportAndExportAnnotationDataState extends SampleViewState {
  _ImportAndExportAnnotationDataState();

  int _groupDataTypeValue = 0;
  int _groupProcessValue = 0;
  String _processText = 'Import Annotation Data';
  PdfAnnotationDataFormat _dataFormat = PdfAnnotationDataFormat.xfdf;
  String _fileExtension = 'xfdf';

  void _dataTypeChanged(int? value) {
    setState(() {
      _groupDataTypeValue = value!;
      switch (_groupDataTypeValue) {
        case 0:
          _dataFormat = PdfAnnotationDataFormat.xfdf;
          _fileExtension = 'xfdf';
          break;
        case 1:
          _dataFormat = PdfAnnotationDataFormat.json;
          _fileExtension = 'json';
          break;
        default:
          _dataFormat = PdfAnnotationDataFormat.fdf;
          _fileExtension = 'fdf';
          break;
      }
    });
  }

  void _processChanged(int? value) {
    setState(() {
      _groupProcessValue = value!;
      if (_groupProcessValue == 0) {
        _processText = 'Import Annotation Data';
      } else {
        _processText = 'Export Annotation Data';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: model.sampleOutputCardColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'This sample shows how to import or export annotation data from the PDF document. It supports XFDF, FDF, and JSON format for import and export.',
                style: TextStyle(fontSize: 16, color: model.textColor),
              ),
              const SizedBox(height: 20, width: 30),
              Text(
                'Choose the data type for import or export:',
                style: TextStyle(
                  fontSize: 16,
                  color: model.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10, width: 30),
              RadioGroup<int>(
                groupValue: _groupDataTypeValue,
                onChanged: _dataTypeChanged,
                child: (width > 800)
                    ? Row(children: getDataTypeChildWidgets(context))
                    : Column(children: getDataTypeChildWidgets(context)),
              ),
              const SizedBox(height: 20, width: 30),
              Text(
                'Select import or export:',
                style: TextStyle(
                  fontSize: 16,
                  color: model.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10, width: 30),
              RadioGroup<int>(
                groupValue: _groupProcessValue,
                onChanged: _processChanged,
                child: (width > 800)
                    ? Row(children: getProcessChildWidgets(context))
                    : Column(children: getProcessChildWidgets(context)),
              ),
              const SizedBox(height: 20, width: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 10, width: 30),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        model.primaryColor,
                      ),
                      padding: model.isMobile
                          ? null
                          : WidgetStateProperty.all(
                              const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 15,
                              ),
                            ),
                    ),
                    onPressed: _viewTemplate,
                    child: const Text(
                      'View Template',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10, width: 20),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        model.primaryColor,
                      ),
                      padding: model.isMobile
                          ? null
                          : WidgetStateProperty.all(
                              const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 15,
                              ),
                            ),
                    ),
                    onPressed: _processData,
                    child: Text(
                      _processText,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> getDataTypeChildWidgets(BuildContext context) {
    return <Widget>[
      Row(
        children: <Widget>[
          const Radio<int>(value: 0),
          Text('XFDF', style: TextStyle(fontSize: 16, color: model.textColor)),
        ],
      ),
      Row(
        children: <Widget>[
          const Radio<int>(value: 1),
          Text('JSON', style: TextStyle(fontSize: 16, color: model.textColor)),
        ],
      ),
      Row(
        children: <Widget>[
          const Radio<int>(value: 2),
          Text('FDF', style: TextStyle(fontSize: 16, color: model.textColor)),
        ],
      ),
    ];
  }

  List<Widget> getProcessChildWidgets(BuildContext context) {
    return <Widget>[
      Row(
        children: <Widget>[
          const Radio<int>(value: 0),
          Text(
            'Import',
            style: TextStyle(fontSize: 16, color: model.textColor),
          ),
        ],
      ),
      Row(
        children: <Widget>[
          const Radio<int>(value: 1),
          Text(
            'Export',
            style: TextStyle(fontSize: 16, color: model.textColor),
          ),
        ],
      ),
    ];
  }

  Future<void> _viewTemplate() async {
    final List<int> documentBytes = await _readDocumentData(
      _groupProcessValue == 0
          ? 'annotation_template.pdf'
          : 'annotations_export_template.pdf',
    );
    await FileSaveHelper.saveAndLaunchFile(
      documentBytes,
      'annotation_template.pdf',
    );
  }

  Future<void> _processData() async {
    if (_groupProcessValue == 0) {
      await _importData();
    } else {
      await _exportData();
    }
  }

  Future<void> _importData() async {
    //Read the input PDF docuemnt bytes.
    final List<int> inputBytes = await _readDocumentData(
      'annotation_template.pdf',
    );

    //Load the PDF data
    final PdfDocument document = PdfDocument(inputBytes: inputBytes);

    //Get input file name
    final String importFileName = 'import_annotation_data.$_fileExtension';

    //Read the input form data to import.
    final List<int> importData = await _readDocumentData(importFileName);

    //Import form data
    document.importAnnotation(importData, _dataFormat);

    //Save and launch the PDF document
    final List<int> documentBytes = await document.save();
    await FileSaveHelper.saveAndLaunchFile(
      documentBytes,
      'annotation_import.pdf',
    );
  }

  Future<void> _exportData() async {
    //Read the input PDF docuemnt bytes.
    final List<int> inputBytes = await _readDocumentData(
      'annotations_export_template.pdf',
    );

    //Load the PDF data
    final PdfDocument document = PdfDocument(inputBytes: inputBytes);

    //Export the form data
    final List<int> dataBytes = document.exportAnnotation(_dataFormat);

    //Show the extracted form data.
    _showDialog(utf8.decode(dataBytes));
  }

  Future<List<int>> _readDocumentData(String name) async {
    final ByteData data = await rootBundle.load('assets/pdf/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  void _showDialog(String text) {
    showDialog<Widget>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_fileExtension.toUpperCase() + ' Data'),
          content: Scrollbar(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              child: Text(text),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
