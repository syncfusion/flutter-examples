/// Package import
import 'package:flutter/material.dart';

/// PDF Viewer import
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

/// Core theme import
import 'package:syncfusion_flutter_core/theme.dart';

/// Local import
import '../../../model/sample_view.dart';

/// Widget of [SfPdfViewer] with custom toolbar.
class CustomToolbarPdfViewer extends SampleView {
  /// Creates a [SfPdfViewer] with custom toolbar.
  const CustomToolbarPdfViewer(Key key) : super(key: key);

  @override
  _CustomToolbarPdfViewerState createState() => _CustomToolbarPdfViewerState();
}

/// State for the [SfPdfViewer] widget with custom toolbar
class _CustomToolbarPdfViewerState extends SampleViewState {
  String _documentPath;
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final PdfViewerController _pdfViewerController = PdfViewerController();
  bool _showPdf;
  bool _showToolbar;

  @override
  void initState() {
    _documentPath = 'assets/pdf/pdf_succinctly.pdf';
    _showPdf = false;
    _showToolbar = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _showToolbar
          ? AppBar(
              flexibleSpace: Toolbar(
                showTooltip: true,
                controller: _pdfViewerController,
                onTap: (Object toolbarItem) {
                  if (_pdfViewerKey.currentState.isBookmarkViewOpen) {
                    Navigator.pop(context);
                  }
                  if (toolbarItem != 'Jump to the page') {
                    final currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.requestFocus(FocusNode());
                    }
                  }
                  if (toolbarItem is Document) {
                    setState(() {
                      _documentPath = toolbarItem.path;
                    });
                  } else if (toolbarItem.toString() == 'Bookmarks') {
                    setState(() {
                      _showToolbar = false;
                    });
                    _pdfViewerKey.currentState?.openBookmarkView();
                  }
                },
              ),
              automaticallyImplyLeading: false,
              backgroundColor:
                  SfPdfViewerTheme.of(context).bookmarkViewStyle.headerBarColor,
            )
          : PreferredSize(
              child: Container(),
              preferredSize: Size.zero,
            ),
      body: FutureBuilder(
        future: Future.delayed(Duration(milliseconds: 200)).then((value) {
          _showPdf = true;
        }),
        builder: (context, snapshot) {
          if (_showPdf) {
            return SfPdfViewerTheme(
              data:
                  SfPdfViewerThemeData(brightness: model.themeData.brightness),
              child: WillPopScope(
                onWillPop: () async {
                  setState(() {
                    _showToolbar = true;
                  });
                  return true;
                },
                child: SfPdfViewer.asset(
                  _documentPath,
                  key: _pdfViewerKey,
                  controller: _pdfViewerController,
                  onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
                    showErrorDialog(
                        context, details.error, details.description);
                  },
                ),
              ),
            );
          } else {
            return Container(
              color: SfPdfViewerTheme.of(context).backgroundColor,
            );
          }
        },
      ),
    );
  }
}

/// Represents PDF document.
class Document {
  /// Constructs Document instance.
  Document(this.name, this.path);

  /// Name of the PDF document.
  final String name;

  /// Path of the PDF document.
  final String path;
}

/// Signature for [FileExplorer.onDocumentTap] callback.
typedef PdfDocumentTapCallback = void Function(Document document);

/// File Explorer widget
class FileExplorer extends StatefulWidget {
  /// Creates a File Explorer
  FileExplorer({Key key, this.brightness, this.onDocumentTap});

  /// Brightness theme for the file explorer.
  final Brightness brightness;

  /// Called when the document is selected.
  final PdfDocumentTapCallback onDocumentTap;

  @override
  FileExplorerState createState() => FileExplorerState();
}

/// State for the File Explorer widget
class FileExplorerState extends State<FileExplorer> {
  Color _foregroundColor;
  Color _backgroundColor;
  List<Document> _documents = [
    Document('PDF Succinctly', 'assets/pdf/pdf_succinctly.pdf'),
    Document('HTTP Succinctly', 'assets/pdf/http_succinctly.pdf'),
    Document('JavaScript Succinctly', 'assets/pdf/javascript_succinctly.pdf'),
    Document('Single Page Document', 'assets/pdf/single_page_document.pdf'),
    Document('Corrupted Document', 'assets/pdf/corrupted_document.pdf')
  ];

  @override
  void didChangeDependencies() {
    _backgroundColor = widget.brightness == Brightness.light
        ? Color(0xFFFAFAFA)
        : Color(0xFF424242);
    _foregroundColor =
        widget.brightness == Brightness.light ? Colors.black : Colors.white;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Choose File', style: TextStyle(color: _foregroundColor)),
          backgroundColor: _backgroundColor,
        ),
        body: Container(
          color: widget.brightness == Brightness.light
              ? Colors.white
              : Color(0xFF212121),
          child: ListView.builder(
              itemCount: _documents.length,
              itemBuilder: (context, index) {
                final document = _documents[index];
                return ListTile(
                  title: Text(document.name,
                      style: TextStyle(color: _foregroundColor, fontSize: 14)),
                  leading: Icon(Icons.picture_as_pdf, color: _foregroundColor),
                  onTap: () {
                    widget.onDocumentTap(document);
                  },
                );
              }),
        ));
  }
}

/// Signature for [Toolbar.onTap] callback.
typedef TapCallback = void Function(Object item);

/// Toolbar widget
class Toolbar extends StatefulWidget {
  ///it describe top toolbar constructor
  Toolbar({
    this.controller,
    this.onTap,
    this.showTooltip = true,
    Key key,
  }) : super(key: key);

  /// Indicates whether tooltip for the toolbar items need to be shown or not..
  final bool showTooltip;

  /// An object that is used to control the [SfPdfViewer].
  final PdfViewerController controller;

  /// Called when the toolbar item is selected.
  final TapCallback onTap;

  @override
  ToolbarState createState() => ToolbarState();
}

/// State for the Toolbar widget
class ToolbarState extends State<Toolbar> {
  SfPdfViewerThemeData _pdfViewerThemeData;
  Color _color;
  Color _disabledColor;
  int _pageCount;

  /// An object that is used to control the Text Field.
  TextEditingController _textEditingController;

  @override
  void initState() {
    widget.controller?.addListener(_pageChanged);
    _textEditingController =
        TextEditingController(text: widget.controller.pageNumber.toString());
    _pageCount = widget.controller.pageCount;
    super.initState();
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_pageChanged);
    super.dispose();
  }

  /// Called when the page changes and updates the page number text field.
  void _pageChanged({String property}) {
    if (widget.controller?.pageCount != null &&
        _pageCount != widget.controller.pageCount) {
      _pageCount = widget.controller.pageCount;
      setState(() {});
    }
    if (widget.controller?.pageNumber != null &&
        _textEditingController.text !=
            widget.controller.pageNumber.toString()) {
      _textEditingController.text = widget.controller.pageNumber.toString();
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    _pdfViewerThemeData = SfPdfViewerTheme.of(context);
    _color = _pdfViewerThemeData.brightness == Brightness.light
        ? Colors.black.withOpacity(0.54)
        : Colors.white.withOpacity(0.65);
    _disabledColor = _pdfViewerThemeData.brightness == Brightness.light
        ? Colors.black12
        : Colors.white12;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final canJumpToPreviousPage = widget.controller.pageNumber > 1;
    final canJumpToNextPage =
        widget.controller.pageNumber < widget.controller.pageCount;
    return GestureDetector(
      onTap: () {
        widget.onTap?.call('Toolbar');
      },
      child: Container(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ToolbarItem(
                height: 40,
                width: 40,
                child: Material(
                    color: Colors.transparent,
                    child: IconButton(
                      icon: Icon(
                        Icons.folder_open,
                        color: _color,
                        size: 24,
                      ),
                      onPressed: () {
                        widget.onTap?.call('File Explorer');
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => FileExplorer(
                                  brightness: _pdfViewerThemeData.brightness,
                                  onDocumentTap: (document) {
                                    widget.onTap?.call(document);
                                    Navigator.of(context, rootNavigator: true)
                                        .pop(context);
                                  },
                                )));
                      },
                      tooltip: widget.showTooltip ? 'Choose file' : null,
                    )),
              ),
              Row(children: <Widget>[
                ToolbarItem(
                    height: 25,
                    width: 75,
                    child: Row(children: [
                      Flexible(
                        child: paginationTextField(context),
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Text(
                            '/',
                            style: TextStyle(color: _color, fontSize: 16),
                          )),
                      Text(
                        _pageCount.toString(),
                        style: TextStyle(color: _color, fontSize: 16),
                      )
                    ])),
                Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child: ToolbarItem(
                      height: 40,
                      width: 40,
                      child: Material(
                          color: Colors.transparent,
                          child: IconButton(
                            icon: Icon(
                              Icons.keyboard_arrow_up,
                              color: canJumpToPreviousPage
                                  ? _color
                                  : _disabledColor,
                              size: 24,
                            ),
                            onPressed: canJumpToPreviousPage
                                ? () {
                                    widget.onTap?.call('Previous page');
                                    widget.controller?.previousPage();
                                  }
                                : null,
                            tooltip:
                                widget.showTooltip ? 'Previous page' : null,
                          )),
                    )),
                Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child: ToolbarItem(
                      height: 40,
                      width: 40,
                      child: Material(
                          color: Colors.transparent,
                          child: IconButton(
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              color:
                                  canJumpToNextPage ? _color : _disabledColor,
                              size: 24,
                            ),
                            onPressed: canJumpToNextPage
                                ? () {
                                    widget.onTap?.call('Next page');
                                    widget.controller?.nextPage();
                                  }
                                : null,
                            tooltip: widget.showTooltip ? 'Next page' : null,
                          )),
                    ))
              ]),
              ToolbarItem(
                  height: 40,
                  width: 40,
                  child: Material(
                    color: Colors.transparent,
                    child: IconButton(
                      icon: Icon(
                        Icons.bookmark,
                        color: widget.controller.pageNumber == 0
                            ? Colors.black12
                            : _color,
                        size: 24,
                      ),
                      onPressed: widget.controller.pageNumber == 0
                          ? null
                          : () {
                              _textEditingController.selection = TextSelection(
                                  baseOffset: -1, extentOffset: -1);
                              widget.onTap?.call('Bookmarks');
                            },
                      tooltip: widget.showTooltip ? 'Bookmarks' : null,
                    ),
                  )),
            ],
          )),
    );
  }

  /// Pagination text field widget
  Widget paginationTextField(BuildContext context) {
    return TextField(
      style: TextStyle(color: _color),
      enableInteractiveSelection: false,
      keyboardType: TextInputType.number,
      controller: _textEditingController,
      textAlign: TextAlign.center,
      maxLength: 3,
      maxLines: 1,
      decoration: InputDecoration(
        counterText: '',
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
      enabled: widget.controller.pageCount == 0 ? false : true,
      onTap: widget.controller.pageCount == 0
          ? null
          : () {
              _textEditingController.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: _textEditingController.value.text.length);
              widget.onTap?.call('Jump to the page');
            },
      onEditingComplete: () {
        final str = _textEditingController.text;
        if (str != widget.controller.pageNumber.toString()) {
          try {
            final int index = int.parse(str);
            if (index > 0 && index <= widget.controller.pageCount) {
              widget.controller?.jumpToPage(index);
              FocusScope.of(context).requestFocus(FocusNode());
              widget.onTap?.call('Navigated');
            } else {
              _textEditingController.text =
                  widget.controller.pageNumber.toString();
              showErrorDialog(
                  context, 'Error', 'Please enter a valid page number.');
            }
          } catch (exception) {
            return showErrorDialog(
                context, 'Error', 'Please enter a valid page number.');
          }
        }
        widget.onTap?.call('Navigated');
      },
    );
  }
}

/// Toolbar item widget
class ToolbarItem extends StatelessWidget {
  ///Creates a toolbar item
  ToolbarItem({
    this.height,
    this.width,
    @required this.child,
  });

  /// Height of the toolbar item
  final double height;

  /// Width of the toolbar item
  final double width;

  /// Child widget of the toolbar item
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: child,
    );
  }
}

/// Displays the error message
void showErrorDialog(BuildContext context, String error, String description) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(error),
        content: Text(description),
        actions: [
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          )
        ],
      );
    },
  );
}
