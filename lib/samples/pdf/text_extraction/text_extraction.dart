///Package imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///Pdf import
import 'package:syncfusion_flutter_pdf/pdf.dart';

///Local imports
import '../../../model/sample_view.dart';
import '../helper/save_file_mobile.dart'
    if (dart.library.html) '../helper/save_file_web.dart';

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
      backgroundColor: model.cardThemeColor,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                  'This sample shows how to extract text in an existing PDF document. It also supports extracting the text with its font name, size, and style.',
                  style: TextStyle(fontSize: 16, color: model.textColor)),
              const SizedBox(height: 20, width: 30),
              Container(
                child: Row(
                  children: [
                    FlatButton(
                        child: Text('View Template',
                            style: TextStyle(color: Colors.white)),
                        color: model.backgroundColor,
                        onPressed: _viewTemplate),
                    SizedBox(
                      height: 10,
                      width: 20,
                    ),
                    FlatButton(
                        child: const Text('Extract Text',
                            style: TextStyle(color: Colors.white)),
                        color: model.backgroundColor,
                        onPressed: _generatePDF)
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _viewTemplate() async {
    List<int> documentBytes =
        await _readDocumentData('pdf_succinctly_template.pdf');
    await FileSaveHelper.saveAndLaunchFile(documentBytes, 'PDF Succinctly.pdf');
  }

  Future<void> _generatePDF() async {
    //Load the PDF document.
    final PdfDocument document = PdfDocument(
        inputBytes: await _readDocumentData('pdf_succinctly_template.pdf'));

    //Create PDF text extractor to extract text.
    PdfTextExtractor extractor = PdfTextExtractor(document);

    //Extract text.
    String text = extractor.extractText(startPageIndex: 0, endPageIndex: 4);

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
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Extracted text'),
            content: Scrollbar(
              child: SingleChildScrollView(
                child: Text(text),
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
              ),
            ),
            actions: [
              FlatButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
