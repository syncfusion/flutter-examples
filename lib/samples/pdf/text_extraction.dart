///Package imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///Pdf import
import 'package:syncfusion_flutter_pdf/pdf.dart';

///Local imports
import '../../model/sample_view.dart';
import 'helper/save_file_mobile.dart'
    if (dart.library.js_interop) 'helper/save_file_web.dart';

/// Extract text from the PDF document
class TextExtractionPdf extends SampleView {
  /// Extract text from the PDF document.
  const TextExtractionPdf(Key key) : super(key: key);
  @override
  _TextExtractionPdfState createState() => _TextExtractionPdfState();
}

class _TextExtractionPdfState extends SampleViewState {
  _TextExtractionPdfState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: model.sampleOutputCardColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'This sample shows how to extract text in an existing PDF document. It also supports extracting the text with its font name, size, and style.',
                style: TextStyle(fontSize: 16, color: model.textColor),
              ),
              const SizedBox(height: 20, width: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
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
                    onPressed: _generatePDF,
                    child: const Text(
                      'Extract Text',
                      style: TextStyle(color: Colors.white),
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

  Future<void> _viewTemplate() async {
    final List<int> documentBytes = await _readDocumentData(
      'pdf_succinctly_template.pdf',
    );
    await FileSaveHelper.saveAndLaunchFile(documentBytes, 'pdf_succinctly.pdf');
  }

  Future<void> _generatePDF() async {
    //Load the PDF document.
    final PdfDocument document = PdfDocument(
      inputBytes: await _readDocumentData('pdf_succinctly_template.pdf'),
    );

    //Create PDF text extractor to extract text.
    final PdfTextExtractor extractor = PdfTextExtractor(document);

    //Extract text.
    final String text = extractor.extractText(
      startPageIndex: 0,
      endPageIndex: 4,
    );

    //Dispose the document.
    document.dispose();
    //Show the extracted text.
    _showDialog(text);
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
          title: const Text('Extracted text'),
          content: SingleChildScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            child: Text(text),
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
