import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../model/sample_view.dart';

import '../pdf/helper/save_file_mobile.dart'
    if (dart.library.html) '../pdf/helper/save_file_web.dart';

/// Form filling.
class FormFilling extends SampleView {
  /// Form filling.
  const FormFilling(Key key) : super(key: key);

  @override
  _FormFillingState createState() => _FormFillingState();
}

class _FormFillingState extends SampleViewState {
  final String _documentPath = 'assets/pdf/form_document.pdf';
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final PdfViewerController _pdfViewerController = PdfViewerController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor:
            ((model.themeData.colorScheme.brightness == Brightness.light)
                ? const Color(0xFFFAFAFA)
                : const Color(0xFF424242)),
        actions: [
          Tooltip(
            message: 'Save',
            child: IconButton(
              color:
                  (model.themeData.colorScheme.brightness == Brightness.light)
                      ? Colors.black.withOpacity(0.54)
                      : Colors.white.withOpacity(0.65),
              icon: const Icon(Icons.save),
              iconSize: 20,
              onPressed: () async {
                final List<int> savedBytes =
                    await _pdfViewerController.saveDocument();
                _saveDocument(
                    savedBytes,
                    'The document was saved and reloaded in the viewer. Also,'
                        ' it was saved at the location ',
                    'form.pdf');
              },
            ),
          ),
          _divider(),
          Tooltip(
              message: 'Export Form Data',
              child: IconButton(
                color:
                    (model.themeData.colorScheme.brightness == Brightness.light)
                        ? Colors.black.withOpacity(0.54)
                        : Colors.white.withOpacity(0.65),
                icon: const Icon(Icons.outbox),
                iconSize: 20,
                onPressed: () async {
                  final List<int> formDataBytes = _pdfViewerController
                      .exportFormData(dataFormat: DataFormat.xfdf);
                  _saveDocument(
                      formDataBytes,
                      'The exported file was saved in the location ',
                      'form.xfdf');
                },
              ))
        ],
      ),
      body: SfPdfViewer.asset(
        _documentPath,
        key: _pdfViewerKey,
        controller: _pdfViewerController,
      ),
    );
  }

  /// Save document
  Future<void> _saveDocument(
      List<int> dataBytes, String message, String fileName) async {
    if (kIsWeb) {
      await FileSaveHelper.saveAndLaunchFile(dataBytes, fileName);
    } else {
      final Directory directory = await getApplicationSupportDirectory();
      final String path = directory.path;
      final File file = File('$path/$fileName');
      await file.writeAsBytes(dataBytes);
      _showDialog(message + path + r'\' + fileName);
    }
  }

  /// Alert dialog for save and export
  void _showDialog(String text) {
    showDialog<Widget>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Document saved'),
            content: Scrollbar(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: Text(text),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              )
            ],
          );
        });
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: VerticalDivider(
        width: 1.0,
        // width of vertical divider
        thickness: 1.0,
        // thickness of vertical divider
        indent: 12.0,
        // top indent of vertical divider
        endIndent: 12.0,
        // bottom indent of vertical divider
        color: model.themeData.colorScheme.brightness == Brightness.light
            ? Colors.black.withOpacity(0.24)
            : const Color.fromRGBO(255, 255, 255, 0.26),
      ),
    );
  }
}
