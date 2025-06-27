///Package imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///Pdf import
import 'package:syncfusion_flutter_pdf/pdf.dart';

///Local imports
import '../../model/sample_view.dart';
import 'helper/save_file_mobile.dart'
    if (dart.library.js_interop) 'helper/save_file_web.dart';

/// Render pdf with header and footer
class HeaderAndFooterPdf extends SampleView {
  /// Creates pdf with header and footer
  const HeaderAndFooterPdf(Key key) : super(key: key);
  @override
  _HeaderAndFooterPdfState createState() => _HeaderAndFooterPdfState();
}

class _HeaderAndFooterPdfState extends SampleViewState {
  _HeaderAndFooterPdfState();

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
                'This sample shows how to create a PDF document with a header and footer. Also, the generated PDF document contains hyperlinks, bookmarks, and table of contents.',
                style: TextStyle(fontSize: 16, color: model.textColor),
              ),
              const SizedBox(height: 20, width: 30),
              Align(
                child: TextButton(
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
                    'Generate PDF',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _generatePDF() async {
    //Create a new PDF document
    final PdfDocument document = PdfDocument();
    //Draw image
    document.pages.add().graphics.drawImage(
      PdfBitmap(await _readImageData('Pdf_Succinctly_img_1.jpg')),
      const Rect.fromLTWH(50, 50, 425, 642),
    );
    final PdfPage titlePage = document.pages.add();
    //Draw text
    titlePage.graphics.drawString(
      'PDF Succinctly',
      PdfStandardFont(PdfFontFamily.timesRoman, 30),
      bounds: Rect.fromLTWH(
        0,
        60,
        titlePage.getClientSize().width,
        titlePage.getClientSize().height,
      ),
      format: PdfStringFormat(alignment: PdfTextAlignment.center),
    );
    titlePage.graphics.drawImage(
      PdfBitmap(await _readImageData('Pdf_Succinctly_img_5.jpg')),
      const Rect.fromLTWH(40, 110, 435, 5),
    );
    final PdfStringFormat format = PdfStringFormat(
      alignment: PdfTextAlignment.center,
    );
    titlePage.graphics.drawString(
      'By\nRyan Hodson',
      PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold),
      bounds: Rect.fromLTWH(
        0,
        130,
        titlePage.getClientSize().width,
        titlePage.getClientSize().height,
      ),
      format: format,
    );
    titlePage.graphics.drawString(
      'Foreword by Daniel Jebaraj',
      PdfStandardFont(PdfFontFamily.helvetica, 20),
      bounds: Rect.fromLTWH(
        0,
        220,
        titlePage.getClientSize().width,
        titlePage.getClientSize().height,
      ),
      format: format,
    );
    //Add new Section
    final PdfSection section = document.sections!.add();
    final PdfPage contentPage = section.pages.add();
    _addParagraph(
      contentPage,
      'Table of Contents',
      Rect.fromLTWH(20, 60, 495, contentPage.getClientSize().height),
      true,
      mainTitle: true,
    );
    //Create a header template and draw a text.
    final PdfPageTemplateElement headerElement = PdfPageTemplateElement(
      const Rect.fromLTWH(0, 0, 515, 50),
      contentPage,
    );
    headerElement.graphics.setTransparency(0.6);
    headerElement.graphics.drawString(
      'PDF Succinctly',
      PdfStandardFont(PdfFontFamily.helvetica, 10),
      bounds: const Rect.fromLTWH(0, 0, 515, 50),
      format: PdfStringFormat(
        alignment: PdfTextAlignment.right,
        lineAlignment: PdfVerticalAlignment.middle,
      ),
    );
    headerElement.graphics.drawLine(
      PdfPens.gray,
      const Offset(0, 49),
      const Offset(515, 49),
    );
    section.template.top = headerElement;
    //Create a footer template and draw a text.
    final PdfPageTemplateElement footerElement = PdfPageTemplateElement(
      const Rect.fromLTWH(0, 0, 515, 50),
      contentPage,
    );
    footerElement.graphics.setTransparency(0.6);
    PdfCompositeField(
      text: 'Page {0} of {1}',
      fields: <PdfAutomaticField>[
        PdfPageNumberField(brush: PdfBrushes.black),
        PdfPageCountField(brush: PdfBrushes.black),
      ],
    ).draw(footerElement.graphics, const Offset(450, 35));
    section.template.bottom = footerElement;
    //Add a new PDF page
    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();
    //Draw string.
    //Draw text
    PdfLayoutResult result = _addParagraph(
      page,
      'Introduction',
      Rect.fromLTWH(20, 25, 495, pageSize.height),
      true,
      mainTitle: true,
    );
    //Add to table of content
    PdfLayoutResult tableContent = _addTableOfContents(
      contentPage,
      'Introduction',
      Rect.fromLTWH(20, 110, 470, result.page.getClientSize().height),
      true,
      4,
      20,
      result.bounds.top,
      result.page,
    );
    //Add bookmark
    _addBookmark(page, 'Introduction', result.bounds.topLeft, doc: document);
    result = _addParagraph(
      result.page,
      "Adobe Systems Incorporated's Portable Document Format (PDF) is the de facto standard for the accurate, reliable, and platform-independent representation of a paged document. It's the only universally accepted file format that allows pixel-perfect layouts. In addition, PDF supports user interaction and collaborative workflows that are not possible with printed documents.\n\nPDF documents have been in widespread use for years, and dozens of free and commercial PDF readers, editors, and libraries are readily available. However, despite this popularity, it's still difficult to find a succinct guide to the native PDF format. Understanding the internal workings of a PDF makes it possible to dynamically generate PDF documents. For example, a web server can extract information from a database, use it to customize an invoice, and serve it to the customer on the fly.",
      Rect.fromLTWH(20, result.bounds.bottom + 20, 495, pageSize.height),
      false,
    );
    result = _addParagraph(
      result.page,
      'The PDF Standard',
      Rect.fromLTWH(20, result.bounds.bottom + 25, 495, pageSize.height),
      true,
    );
    tableContent = _addTableOfContents(
      tableContent.page,
      'The PDF Standard',
      Rect.fromLTWH(
        20,
        tableContent.bounds.bottom,
        470,
        result.page.getClientSize().height,
      ),
      false,
      4,
      20,
      result.bounds.top,
      result.page,
    );
    _addBookmark(
      result.page,
      'The PDF Standard',
      result.bounds.topLeft,
      doc: document,
    );
    result = _addParagraph(
      result.page,
      'The PDF format is an open standard maintained by the International Organization for Standardization. The official specification is defined in ISO 32000-1:2008, but Adobe also provides a free, comprehensive guide called PDF Reference, Sixth Edition, version 1.7.',
      Rect.fromLTWH(20, result.bounds.bottom + 20, 495, pageSize.height),
      false,
    );
    result = _addParagraph(
      result.page,
      'Chapter 1 Conceptual Overview',
      Rect.fromLTWH(20, result.bounds.bottom + 25, 495, pageSize.height),
      true,
      mainTitle: true,
    );
    tableContent = _addTableOfContents(
      tableContent.page,
      'Chapter 1 Conceptual Overview',
      Rect.fromLTWH(
        20,
        tableContent.bounds.bottom,
        470,
        result.page.getClientSize().height,
      ),
      true,
      4,
      20,
      result.bounds.top,
      result.page,
    );
    final PdfBookmark standardBookmark = _addBookmark(
      result.page,
      'Chapter 1 Conceptual Overview',
      result.bounds.topLeft,
      doc: document,
    );
    result = _addParagraph(
      result.page,
      "We'll begin with a conceptual overview of a simple PDF document. This chapter is designed to be a brief orientation before diving in and creating a real document from scratch.\nA PDF file can be divided into four parts: a header, body, cross-reference table, and trailer. The header marks the file as a PDF, the body defines the visible document, the cross-reference table lists the location of everything in the file, and the trailer provides instructions for how to start reading the file.",
      Rect.fromLTWH(20, result.bounds.bottom + 20, 495, pageSize.height),
      false,
    );
    final PdfPage page2 = document.pages.add();
    page2.graphics.drawImage(
      PdfBitmap(await _readImageData('Pdf_Succinctly_img_2.jpg')),
      const Rect.fromLTWH(10, 0, 495, 600),
    );
    result = _addParagraph(
      page2,
      'Every PDF file must have these four components.',
      Rect.fromLTWH(20, 620, 495, page2.getClientSize().height),
      false,
    );
    result = _addParagraph(
      document.pages.add(),
      'Header',
      Rect.fromLTWH(20, 15, 495, pageSize.height),
      true,
    );
    tableContent = _addTableOfContents(
      tableContent.page,
      'Header',
      Rect.fromLTWH(
        20,
        tableContent.bounds.bottom,
        470,
        result.page.getClientSize().height,
      ),
      false,
      6,
      20,
      result.bounds.top,
      result.page,
    );
    _addBookmark(
      result.page,
      'Header',
      result.bounds.topLeft,
      bookmark: standardBookmark,
    );
    result = _addParagraph(
      result.page,
      'The header is simply a PDF version number and an arbitrary sequence of binary data. The binary data prevents naïve applications from processing the PDF as a text file. This would result in a corrupted file, since a PDF typically consists of both plain text and binary data (e.g., a binary font file can be directly embedded in a PDF).',
      Rect.fromLTWH(20, result.bounds.bottom + 20, 495, pageSize.height),
      false,
    );
    result = _addParagraph(
      result.page,
      'Body',
      Rect.fromLTWH(20, result.bounds.bottom + 25, 495, pageSize.height),
      true,
    );
    tableContent = _addTableOfContents(
      tableContent.page,
      'Body',
      Rect.fromLTWH(
        20,
        tableContent.bounds.bottom,
        470,
        result.page.getClientSize().height,
      ),
      false,
      6,
      20,
      result.bounds.top,
      result.page,
    );
    _addBookmark(
      result.page,
      'Body',
      result.bounds.topLeft,
      bookmark: standardBookmark,
    );
    result = _addParagraph(
      result.page,
      'The body of a PDF contains the entire visible document. The minimum elements required in a valid PDF body are:\n\n1. A page tree \n2. Pages \n3. Resources \n4. Content \n5. The catalog \n\nThe page tree serves as the root of the document. In the simplest case, it is just a list of the pages in the document. Each page is defined as an independent entity with metadata (e.g., page dimensions) and a reference to its resources and content, which are defined separately. Together, the page tree and page objects create the "paper" that composes the document.\n\nResources are objects that are required to render a page. For example, a single font is typically used across several pages, so storing the font information in an external resource is much more efficient. A content object defines the text and graphics that actually show up on the page. Together, content objects and resources define the appearance of an individual page.\nFinally, the document\'s catalog tells applications where to start reading the document. Often, this is just a pointer to the root page tree.',
      Rect.fromLTWH(20, result.bounds.bottom + 20, 495, pageSize.height),
      false,
    );
    final PdfPage page3 = document.pages.add();
    page3.graphics.drawImage(
      PdfBitmap(await _readImageData('Pdf_Succinctly_img_3.jpg')),
      const Rect.fromLTWH(20, 0, 300, 400),
    );
    result = _addParagraph(
      page3,
      'Cross-Reference Table',
      Rect.fromLTWH(20, 425, 495, pageSize.height),
      true,
    );
    tableContent = _addTableOfContents(
      tableContent.page,
      'Cross-Reference Table',
      Rect.fromLTWH(
        20,
        tableContent.bounds.bottom,
        470,
        result.page.getClientSize().height,
      ),
      false,
      7,
      20,
      result.bounds.top,
      result.page,
    );
    _addBookmark(
      result.page,
      'Cross-Reference Table',
      result.bounds.topLeft,
      bookmark: standardBookmark,
    );
    result = _addParagraph(
      result.page,
      'After the header and the body comes the cross-reference table. It records the byte location of each object in the body of the file. This enables random-access of the document, so when rendering a page, only the objects required for that page are read from the file. This makes PDFs much faster than their PostScript predecessors, which had to read in the entire file before processing it.',
      Rect.fromLTWH(20, result.bounds.bottom + 20, 495, pageSize.height),
      false,
    );
    result = _addParagraph(
      result.page,
      'Trailer',
      Rect.fromLTWH(20, result.bounds.bottom + 25, 495, pageSize.height),
      true,
    );
    tableContent = _addTableOfContents(
      tableContent.page,
      'Trailer',
      Rect.fromLTWH(
        20,
        tableContent.bounds.bottom,
        470,
        result.page.getClientSize().height,
      ),
      false,
      7,
      20,
      result.bounds.top,
      result.page,
    );
    _addBookmark(
      result.page,
      'Trailer',
      result.bounds.topLeft,
      bookmark: standardBookmark,
    );
    result = _addParagraph(
      result.page,
      'Finally, we come to the last component of a PDF document. The trailer tells applications how to start reading the file. At minimum, it contains three things:\n\n\n1. A reference to the catalog which links to the root of the document.\n2. The location of the cross-reference table.\n3. The size of the cross-reference table.\n\nSince a trailer is all you need to begin processing a document, PDFs are typically read back-to-front: first, the end of the file is found, and then you read backwards until you arrive at the beginning of the trailer. After that, you should have all the information you need to load any page in the PDF.',
      Rect.fromLTWH(20, result.bounds.bottom + 20, 495, pageSize.height),
      false,
    );
    result = _addParagraph(
      result.page,
      'Summary',
      Rect.fromLTWH(20, result.bounds.bottom + 25, 495, pageSize.height),
      true,
    );
    tableContent = _addTableOfContents(
      tableContent.page,
      'Summary',
      Rect.fromLTWH(
        20,
        tableContent.bounds.bottom,
        470,
        result.page.getClientSize().height,
      ),
      false,
      8,
      20,
      result.bounds.top,
      result.page,
    );
    _addBookmark(
      result.page,
      'Summary',
      result.bounds.topLeft,
      bookmark: standardBookmark,
    );
    result = _addParagraph(
      result.page,
      'To conclude our overview, a PDF document has a header, a body, a cross-reference table, and a trailer. The trailer serves as the entryway to the entire document, giving you access to any object via the cross-reference table, and pointing you toward the root of the document. The relationship between these elements is shown in the following figure.',
      Rect.fromLTWH(20, result.bounds.bottom + 20, 495, pageSize.height),
      false,
    );
    result.page.graphics.drawImage(
      PdfBitmap(await _readImageData('Pdf_Succinctly_img_4.jpg')),
      Rect.fromLTWH(20, result.bounds.bottom + 20, 495, 400),
    );

    //Save and dispose the document.
    final List<int> bytes = await document.save();
    document.dispose();
    //Launch file.
    await FileSaveHelper.saveAndLaunchFile(bytes, 'HeaderAndFooter.pdf');
  }

  PdfLayoutResult _addParagraph(
    PdfPage page,
    String text,
    Rect bounds,
    bool isTitle, {
    bool mainTitle = false,
  }) {
    return PdfTextElement(
      text: text,
      font: PdfStandardFont(
        PdfFontFamily.helvetica,
        isTitle
            ? mainTitle
                  ? 24
                  : 18
            : 13,
        style: (isTitle && !mainTitle)
            ? PdfFontStyle.bold
            : PdfFontStyle.regular,
      ),
      format: mainTitle
          ? PdfStringFormat(alignment: PdfTextAlignment.center)
          : PdfStringFormat(alignment: PdfTextAlignment.justify),
    ).draw(
      page: page,
      bounds: Rect.fromLTWH(
        bounds.left,
        bounds.top,
        bounds.width,
        bounds.height,
      ),
    )!;
  }

  PdfBookmark _addBookmark(
    PdfPage page,
    String text,
    Offset point, {
    PdfDocument? doc,
    PdfBookmark? bookmark,
    PdfColor? color,
  }) {
    PdfBookmark book;
    if (doc != null) {
      book = doc.bookmarks.add(text);
      book.destination = PdfDestination(page, point);
    } else {
      book = bookmark!.add(text);
      book.destination = PdfDestination(page, point);
    }
    book.color = color ?? PdfColor(0, 0, 0);
    return book;
  }

  PdfLayoutResult _addTableOfContents(
    PdfPage page,
    String text,
    Rect bounds,
    bool isTitle,
    int pageNo,
    double x,
    double y,
    PdfPage destPage,
  ) {
    final PdfFont font = PdfStandardFont(
      PdfFontFamily.helvetica,
      13,
      style: isTitle ? PdfFontStyle.bold : PdfFontStyle.regular,
    );
    page.graphics.drawString(
      pageNo.toString(),
      font,
      bounds: Rect.fromLTWH(480, bounds.top + 5, bounds.width, bounds.height),
    );
    final PdfDocumentLinkAnnotation annotation = PdfDocumentLinkAnnotation(
      Rect.fromLTWH(
        isTitle ? bounds.left : bounds.left + 20,
        bounds.top - 45,
        isTitle ? bounds.width : bounds.width - 20,
        font.height,
      ),
      PdfDestination(destPage, Offset(x, y)),
    );
    annotation.border.width = 0;
    page.annotations.add(annotation);
    String str = text + ' ';
    final num value = isTitle
        ? font.measureString(text).width.round() + 20
        : font.measureString(text).width.round() + 40;
    for (num i = value; i < 470;) {
      str = str + '.';
      i = i + 3.6140000000000003;
    }
    return PdfTextElement(text: str, font: font).draw(
      page: page,
      bounds: Rect.fromLTWH(
        isTitle ? bounds.left : bounds.left + 20,
        bounds.top + 5,
        bounds.width,
        bounds.height,
      ),
    )!;
  }

  Future<List<int>> _readImageData(String name) async {
    final ByteData data = await rootBundle.load('images/pdf/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }
}
