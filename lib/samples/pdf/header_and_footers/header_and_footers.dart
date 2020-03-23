import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter_examples/samples/pdf/helper/save_file_mobile.dart'
    if (dart.library.html) 'package:flutter_examples/samples/pdf/helper/save_file_web.dart';

//ignore: must_be_immutable
class HeaderAndFooterPdf extends StatefulWidget {
  HeaderAndFooterPdf({this.sample, Key key}) : super(key: key);
  SubItem sample;
  @override
  _HeaderAndFooterPdfState createState() => _HeaderAndFooterPdfState(sample);
}

class _HeaderAndFooterPdfState extends State<HeaderAndFooterPdf> {
  _HeaderAndFooterPdfState(this.sample);

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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                        'This package provides support to create a header and a footer in a PDF document. You can add the following content to the header or footer using dynamic fields.\r\n',
                        style: TextStyle(fontSize: 16)),
                    const Text('      1. Text', style: TextStyle(fontSize: 16)),
                    const Text('      2. Images',
                        style: TextStyle(fontSize: 16)),
                    const Text('      3. Shapes',
                        style: TextStyle(fontSize: 16)),
                    const Text('      4. Page numbers',
                        style: TextStyle(fontSize: 16)),
                    const Text('      5. Date and time\r\n',
                        style: TextStyle(fontSize: 16)),
                    const Text(
                        'This sample explains how to add a simple header or footer to a PDF document.',
                        style: TextStyle(fontSize: 16)),
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
          );
        });
  }

  Future<void> generatePDF() async {
    //Create PDF document.
    final PdfDocument document = PdfDocument();
    //Create and add a header.
    document.template.top = _createHeader();
    //Create and add a footer.
    document.template.bottom = _createFooter();
    //Add page and draw text.
    final PdfPage page = document.pages.add();
    _drawPageContent(page);
    //Save and dispose
    final List<int> bytes = document.save();
    document.dispose();

    //Save and launch/download a file.
    FileSaveHelper.saveAndLaunchFile(bytes, 'Header and Footer.pdf');
  }

  PdfPageTemplateElement _createHeader() {
    //Create a header template and draw image/text.
    final PdfPageTemplateElement headerElement =
        PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 515, 50));
    headerElement.graphics.drawString(
        'This is page header', PdfStandardFont(PdfFontFamily.helvetica, 10),
        bounds: const Rect.fromLTWH(0, 0, 515, 50),
        format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));
    headerElement.graphics.setTransparency(0.6);
    headerElement.graphics.drawString(
        'PDF Succinctly', PdfStandardFont(PdfFontFamily.helvetica, 10),
        bounds: const Rect.fromLTWH(0, 0, 515, 50),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.right,
            lineAlignment: PdfVerticalAlignment.middle));
    headerElement.graphics
        .drawLine(PdfPens.gray, const Offset(0, 49), const Offset(515, 49));
    return headerElement;
  }

  PdfPageTemplateElement _createFooter() {
    //Create a footer template and draw a text.
    final PdfPageTemplateElement footerElement =
        PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 515, 50));
    footerElement.graphics.drawString(
      'This is page footer',
      PdfStandardFont(PdfFontFamily.helvetica, 10),
      bounds: const Rect.fromLTWH(0, 35, 515, 50),
    );
    footerElement.graphics.setTransparency(0.6);
    PdfCompositeField(text: 'Page {0} of {1}', fields: <PdfAutomaticField>[
      PdfPageNumberField(brush: PdfBrushes.black),
      PdfPageCountField(brush: PdfBrushes.black)
    ]).draw(footerElement.graphics, const Offset(450, 35));
    return footerElement;
  }

  void _drawPageContent(PdfPage page) {
    //Create font
    final PdfStandardFont h1Font =
        PdfStandardFont(PdfFontFamily.helvetica, 25, style: PdfFontStyle.bold);
    final PdfStandardFont contentFont = PdfStandardFont(
        PdfFontFamily.helvetica, 17,
        style: PdfFontStyle.regular);
    //Get the page client size
    final Size size = page.getClientSize();
    //Create a text element and draw it to the page
    PdfLayoutResult result = PdfTextElement(
            text: 'PDF Succinctly',
            font: PdfStandardFont(PdfFontFamily.helvetica, 30,
                style: PdfFontStyle.bold),
            brush: PdfBrushes.red,
            format: PdfStringFormat(alignment: PdfTextAlignment.center))
        .draw(
            page: page,
            bounds: Rect.fromLTWH(0, 30, size.width, size.height - 30));

    result = PdfTextElement(text: 'Introduction', font: h1Font).draw(
        page: page,
        bounds: Rect.fromLTWH(0, result.bounds.bottom + 30, size.width,
            size.height - result.bounds.bottom + 30));

    result = PdfTextElement(
            text:
                'Adobe Systems Incorporated\'s Portable Document Format (PDF) is the de facto standard for the accurate, reliable, and platform-independent representation of a paged document. It\'s the only universally accepted file format that allows pixel-perfect layouts. In addition, PDF supports user interaction and collaborative workflows that are not possible with printed documents.\r\n\r\nPDF documents have been in widespread use for years, and dozens of free and commercial PDF readers, editors, and libraries are readily available. However, despite this popularity, it\'s still difficult to find a succinct guide to the native PDF format. Understanding the internal workings of a PDF makes it possible to dynamically generate PDF documents. For example, a web server can extract information from a database, use it to customize an invoice, and serve it to the customer on the fly.',
            font: contentFont)
        .draw(
            page: result.page,
            bounds: Rect.fromLTWH(0, result.bounds.bottom + 30, size.width,
                size.height - result.bounds.bottom + 30));

    result = PdfTextElement(text: 'The PDF Standard', font: h1Font).draw(
        page: result.page,
        bounds: Rect.fromLTWH(0, result.bounds.bottom + 30, size.width,
            size.height - result.bounds.bottom + 30),
        format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate));

    result = PdfTextElement(
            text:
                'The PDF format is an open standard maintained by the International Organization for Standardization. The official specification is defined in ISO 32000-1:2008, but Adobe also provides a free, comprehensive guide called PDF Reference, Sixth Edition, version 1.7.',
            font: contentFont)
        .draw(
            page: result.page,
            bounds: Rect.fromLTWH(0, result.bounds.bottom + 30, size.width,
                size.height - result.bounds.bottom + 30),
            format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate));
    final PdfTextElement element =
        PdfTextElement(text: 'Conceptual Overview', font: h1Font);
    result = element.draw(
        page: result.page,
        bounds: Rect.fromLTWH(0, result.bounds.bottom + 30, size.width,
            size.height - result.bounds.bottom + 30),
        format: PdfLayoutFormat(
            paginateBounds:
                Rect.fromLTWH(0, 30, size.width, size.height - 30)));
    result = PdfTextElement(
            text:
                'We\'ll begin with a conceptual overview of a simple PDF document. This chapter is designed to be a brief orientation before diving in and creating a real document from scratch. A PDF file can be divided into four parts: a header, body, cross-reference table, and trailer. The header marks the file as a PDF, the body defines the visible document, the cross-reference table lists the location of everything in the file, and the trailer provides instructions for how to start reading the file.',
            font: contentFont)
        .draw(
            page: result.page,
            bounds: Rect.fromLTWH(0, result.bounds.bottom + 30, size.width,
                size.height - result.bounds.bottom + 30));
  }
}
