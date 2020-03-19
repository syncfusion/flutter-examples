import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter_examples/samples/pdf/helper/save_file_mobile.dart'
    if (dart.library.html) 'package:flutter_examples/samples/pdf/helper/save_file_web.dart';

//ignore: must_be_immutable
class HelloWorldPdf extends StatefulWidget {
  HelloWorldPdf({this.sample, Key key}) : super(key: key);
  SubItem sample;
  @override
  _HelloWorldPdfState createState() => _HelloWorldPdfState(sample);
}

class _HelloWorldPdfState extends State<HelloWorldPdf> {
  _HelloWorldPdfState(this.sample);

  final SubItem sample;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleModel model) {
          return Scaffold(
            backgroundColor: model.cardThemeColor,
            body: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'The PDF package is a non-UI and reusable flutter library to create PDF reports programmatically with formatted text, images, tables, links, list, header and footer, and more.\r\n\r\nThe creation of a PDF file follows the most popular PDF 1.7 (ISO 32000-1) and PDF 2.0 (ISO 32000-2) specifications.\r\n\r\nThis sample explains how to create a simple PDF document from scratch using the Syncfusion Flutter PDF package.',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20, width: 30),
                      Align(
                          alignment: Alignment.center,
                          child: FlatButton(
                              child: const Text('Generate PDF',
                                  style: TextStyle(color: Colors.white)),
                              color: model.backgroundColor,
                              onPressed: generatePDF))
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void generatePDF() {
    //Create a new PDF document.
    final PdfDocument document = PdfDocument();

    //Add a new PDF page.
    final PdfPage page = document.pages.add();

    //Draw text to the PDF page.
    page.graphics.drawString(
        'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 20),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: const Rect.fromLTWH(0, 40, 200, 30));

    page.graphics.drawString('Hello World!',
        PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold),
        brush: PdfBrushes.blue, bounds: const Rect.fromLTWH(0, 80, 200, 30));

    page.graphics.drawString(
        'Hello World!',
        PdfStandardFont(PdfFontFamily.helvetica, 20,
            style: PdfFontStyle.italic),
        brush: PdfBrushes.red,
        bounds: const Rect.fromLTWH(0, 120, 200, 30));

    page.graphics.drawString(
        'Hello World!',
        PdfStandardFont(PdfFontFamily.helvetica, 20,
            style: PdfFontStyle.underline),
        brush: PdfBrushes.green,
        bounds: const Rect.fromLTWH(0, 160, 200, 30));

    page.graphics.drawString(
        'Hello World!',
        PdfStandardFont(PdfFontFamily.helvetica, 20,
            style: PdfFontStyle.strikethrough),
        brush: PdfBrushes.brown,
        bounds: const Rect.fromLTWH(0, 200, 200, 30));

    //Save and dispose the PDF document.
    final List<int> bytes = document.save();
    document.dispose();

    //Launch the PDF file.
    FileSaveHelper.saveAndLaunchFile(bytes, 'Hello World.pdf');
  }
}
