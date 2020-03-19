import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter_examples/samples/pdf/helper/save_file_mobile.dart'
    if (dart.library.html) 'package:flutter_examples/samples/pdf/helper/save_file_web.dart';

//ignore: must_be_immutable
class BookmarksPdf extends StatefulWidget {
  BookmarksPdf({this.sample, Key key}) : super(key: key);
  SubItem sample;
  @override
  _BookmarksPdfState createState() => _BookmarksPdfState(sample);
}

class _BookmarksPdfState extends State<BookmarksPdf> {
  _BookmarksPdfState(this.sample);

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
                        'This package allows users to add bookmarks to a PDF document to navigate interactively from one part of the document to another. It provides customizations like title font, color, size, and more.\r\n\r\nThis sample explains how to add a bookmark to the PDF document.',
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
    //Create a PDF document
    final PdfDocument document = PdfDocument();
    //Add a new PDF page
    final PdfPage page = document.pages.add();

    final Size pageSize = page.getClientSize();
    //Draw string.
    page.graphics.drawString(
        'PDF Succinctly', PdfStandardFont(PdfFontFamily.helvetica, 30),
        brush: PdfBrushes.red,
        bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
        format: PdfStringFormat(alignment: PdfTextAlignment.center));

    _createAndAddBookmarks(document, page, pageSize);

    //Save and dispose the document.
    final List<int> bytes = document.save();
    document.dispose();

    //Launch file.
    FileSaveHelper.saveAndLaunchFile(bytes, 'Bookmarks.pdf');
  }

  void _createAndAddBookmarks(
      PdfDocument document, PdfPage page, Size pageSize) {
    //Draw text
    PdfLayoutResult result = _addParagraph(page, 'Introduction',
        Rect.fromLTWH(0, 60, pageSize.width, pageSize.height), true);

    //Add bookmark
    _addBookmark(page, 'Introduction', result.bounds.topLeft, doc: document);
    result = _addParagraph(
        result.page,
        'Adobe Systems Incorporated\'s Portable Document Format (PDF) is the de facto standard for the accurate, reliable, and platform-independent representation of a paged document. It\'s the only universally accepted file format that allows pixel-perfect layouts.In addition, PDF supports user interaction and collaborative workflows that are not possible with printed documents.',
        Rect.fromLTWH(
            0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
        false);
    result = _addParagraph(
        result.page,
        'The PDF Standard',
        Rect.fromLTWH(
            0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
        true);
    final PdfBookmark _standardBookmark = _addBookmark(
        result.page, 'The PDF Standard', result.bounds.topLeft,
        doc: document);
    result = _addParagraph(
        result.page,
        'The PDF format is an open standard maintained by the International Organization for Standardization. The official specification is defined in ISO 32000-1:2008, but Adobe also provides a free, comprehensive guide called PDF Reference - Sixth Edition.\nConceptual Overview: A PDF file can be divided into four parts: a header, body, cross-reference table, and trailer. The header marks the file as a PDF, the body defines the visible document, the cross-reference table lists the location of everything in the file, and the trailer provides instructions for how to start reading the file.',
        Rect.fromLTWH(
            0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
        false);
    result = _addParagraph(
        result.page,
        'Header',
        Rect.fromLTWH(
            0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
        true);
    _addBookmark(result.page, 'Header', result.bounds.topLeft,
        bookmark: _standardBookmark);
    result = _addParagraph(
        result.page,
        'The header is simply a PDF version number and an arbitrary sequence of binary data. The binary data prevents naïve applications from processing the PDF as a text file. This would result in a corrupted file, since a PDF typically consists of both plain text and binary data (e.g., a binary font file can be directly embedded in a PDF).',
        Rect.fromLTWH(
            0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
        false);
    result = _addParagraph(
        result.page,
        'Body',
        Rect.fromLTWH(
            0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
        true);
    final PdfBookmark _bodyBookmark = _addBookmark(
        result.page, 'Body', result.bounds.topLeft,
        bookmark: _standardBookmark);

    result = _addParagraph(
        result.page,
        'The body of a PDF contains the entire visible document. The minimum elements required in a valid PDF body are:\n1) A page tree \n2) Pages \n3) Resources \n4) Content \n5) The catalog',
        Rect.fromLTWH(
            0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
        false);
    result = _addParagraph(
        result.page,
        '1. The Page Tree',
        Rect.fromLTWH(
            0, result.bounds.bottom + 50, pageSize.width, pageSize.height),
        true,
        subTitle: true);
    _addBookmark(result.page, '1. The Page Tree', result.bounds.topLeft,
        bookmark: _bodyBookmark);

    result = _addParagraph(
        result.page,
        'The page tree is a dictionary object containing a list of the pages that make up the document. A minimal page tree contains just one page. Objects are enclosed in the obj and endobj tags, and they begin with a unique identification number (1 0). The first number is the object number, and the second is the generation number. The latter is only used for incremental updates, so all the generation numbers in our examples will be 0. As we\'ll see in a moment, PDFs use these identifiers to refer to individual objects from elsewhere in the document.',
        Rect.fromLTWH(
            0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
        false);
    result = _addParagraph(
        result.page,
        '2. Page(s)',
        Rect.fromLTWH(
            0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
        true,
        subTitle: true);
    _addBookmark(result.page, '2. Page(s)', result.bounds.topLeft,
        bookmark: _bodyBookmark);

    result = _addParagraph(
        result.page,
        'Next, we\'ll create the second object, which is the only page referenced by /Kids in the previous section. The /Type entry always specifies the type of the object. Many times, this can be omitted if the object type can be inferred by context. Note that PDF uses a name to identify the object type-not a literal string.',
        Rect.fromLTWH(
            0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
        false);
    result = _addParagraph(
        result.page,
        '3. Resources',
        Rect.fromLTWH(
            0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
        true,
        subTitle: true);
    _addBookmark(result.page, '3. Resources', result.bounds.topLeft,
        bookmark: _bodyBookmark);

    result = _addParagraph(
        result.page,
        'The third object is a resource defining a font configuration. The /Font key contains a whole dictionary, opposed to the name/value pairs we\'ve seen previously (e.g., /Type /Page). The font we configured is called /F0, and the font face we selected is /Times-Roman. The /Subtype is the format of the font file, and /Type1 refers to the PostScript type 1 file format.',
        Rect.fromLTWH(
            0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
        false);
    result = _addParagraph(
        result.page,
        '4. Content',
        Rect.fromLTWH(
            0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
        true,
        subTitle: true);
    _addBookmark(result.page, '4. Content', result.bounds.topLeft,
        bookmark: _bodyBookmark);

    result = _addParagraph(
        result.page,
        'Finally, we are able to specify the actual content of the page. Page content is represented as a stream object. Stream objects consist of a dictionary of metadata and a stream of bytes.',
        Rect.fromLTWH(
            0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
        false,
        subTitle: true);
    result = _addParagraph(
        result.page,
        '5. Catalog',
        Rect.fromLTWH(
            0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
        true,
        subTitle: true);
    _addBookmark(result.page, '5. Catalog', result.bounds.topLeft,
        bookmark: _bodyBookmark);

    result = _addParagraph(
        result.page,
        'The last section of the body is the catalog, which points to the root page tree (1 0 R). This may seem like an unnecessary reference, but dividing a document into multiple page trees is a common way to optimize PDFs. In such a case, programs need to know where the document starts.',
        Rect.fromLTWH(
            0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
        false);
    result = _addParagraph(
        result.page,
        'Cross-Reference Table',
        Rect.fromLTWH(
            0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
        true);
    _addBookmark(result.page, 'Cross-Reference Table', result.bounds.topLeft,
        bookmark: _standardBookmark);
    result = _addParagraph(
        result.page,
        'The cross-reference table provides the location of each object in the body of the file. Locations are recorded as byte-offsets from the beginning of the file. This is another job for pdftk-all we have to do is add the xref keyword. We\'ll take a closer look at the cross-reference table after we generate the final PDF.',
        Rect.fromLTWH(
            0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
        false);
    result = _addParagraph(
        result.page,
        'Trailer',
        Rect.fromLTWH(
            0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
        true);
    _addBookmark(result.page, 'Trailer', result.bounds.topLeft,
        bookmark: _standardBookmark);
    result = _addParagraph(
        result.page,
        'The last part of the file is the trailer. It\'s comprised of the trailer keyword, followed by a dictionary that contains a reference to the catalog, then a pointer to the crossreference table, and finally an end-of-file marker. The /Root points to the catalog, not the root page tree. This is important because the catalog can also contain important information about the document structure. The startxref keyword points to the location (in bytes) of the beginning of the crossreference table.',
        Rect.fromLTWH(
            0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
        false);
  }

  PdfLayoutResult _addParagraph(
      PdfPage page, String text, Rect bounds, bool isTitle,
      {bool subTitle = false}) {
    return PdfTextElement(
      text: text,
      font: PdfStandardFont(
          PdfFontFamily.helvetica, isTitle ? subTitle ? 16 : 18 : 13,
          style: isTitle ? PdfFontStyle.bold : PdfFontStyle.regular),
    ).draw(
        page: page,
        bounds: Rect.fromLTWH(
            bounds.left, bounds.top, bounds.width, bounds.height));
  }

  PdfBookmark _addBookmark(PdfPage page, String text, Offset point,
      {PdfDocument doc, PdfBookmark bookmark, PdfColor color}) {
    PdfBookmark book;
    if (doc != null) {
      book = doc.bookmarks.add(text);
      book.destination = PdfDestination(page, point);
    } else if (bookmark != null) {
      book = bookmark.add(text);
      book.destination = PdfDestination(page, point);
    }
    book.color = color;
    return book;
  }
}
