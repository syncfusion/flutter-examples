/// Package import
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

/// PDF Viewer import
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

/// Core theme import
import 'package:syncfusion_flutter_core/theme.dart';

/// Local import
import '../../model/sample_view.dart';

import './shared/mobile_helper.dart'
    if (dart.library.html) './shared/web_helper.dart' as helper;

/// Widget of [SfPdfViewer] with custom toolbar.
class CustomToolbarPdfViewer extends SampleView {
  /// Creates a [SfPdfViewer] with custom toolbar.
  const CustomToolbarPdfViewer(Key key) : super(key: key);

  @override
  _CustomToolbarPdfViewerState createState() => _CustomToolbarPdfViewerState();
}

/// State for the [SfPdfViewer] widget with custom toolbar
class _CustomToolbarPdfViewerState extends SampleViewState {
  bool _showPdf = false;
  bool _showToolbar = false;
  bool _showToast = false;
  bool _showScrollHead = false;
  OverlayEntry? _selectionOverlayEntry;
  PdfTextSelectionChangedDetails? _textSelectionDetails;
  Color? _contextMenuColor;
  Color? _copyColor;
  double _contextMenuWidth = 0.0;
  double _contextMenuHeight = 0.0;
  OverlayEntry? _textSearchOverlayEntry;
  OverlayEntry? _chooseFileOverlayEntry;
  LocalHistoryEntry? _historyEntry;
  bool _isNeedToMaximize = false;
  String? _documentPath;
  PdfInteractionMode _interactionMode = PdfInteractionMode.selection;
  final FocusNode _focusNode = FocusNode()..requestFocus();
  final GlobalKey<ToolbarState>? _toolbarKey = GlobalKey();
  final GlobalKey<SfPdfViewerState>? _pdfViewerKey = GlobalKey();
  final PdfViewerController _pdfViewerController = PdfViewerController();
  final GlobalKey<SearchToolbarState>? _textSearchKey = GlobalKey();
  final GlobalKey<_TextSearchOverlayState>? _textSearchOverlayKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _documentPath = 'assets/pdf/gis_succinctly.pdf';
    _showPdf = false;
    _showToolbar = true;
    _showToast = false;
    _showScrollHead = true;
    _contextMenuHeight = 48;
    _contextMenuWidth = 100;
    if (kIsWeb &&
        model.isMobileResolution != null &&
        !model.isMobileResolution) {
      helper.preventDefaultMenu();
    }
  }

  @override
  void didChangeDependencies() {
    /// Used figma colors for context menu color and copy text color.
    _contextMenuColor = model.themeData.brightness == Brightness.light
        ? Color(0xFFFFFFFF)
        : Color(0xFF424242);
    _copyColor = model.themeData.brightness == Brightness.light
        ? Color(0xFF000000)
        : Color(0xFFFFFFFF);
    if (_isNeedToMaximize != model.needToMaximize) {
      _closeOverlay();
      _isNeedToMaximize = model.needToMaximize;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _closeOverlay();
    super.dispose();
  }

  // Closes all overlay entry when drawer is opened.
  void _closeOverlay() {
    _closeChooseFileMenu();
    _toolbarKey?.currentState?.closeZoomPercentageMenu();
    _textSearchKey?.currentState?._pdfTextSearchResult.clear();
    _handleSearchMenuClose();
    _checkAndCloseContextMenu();
  }

  /// Show Context menu for Text Selection.
  void _showContextMenu(BuildContext context, Offset? offset) {
    _contextMenuHeight = (kIsWeb &&
            model.isMobileResolution != null &&
            !model.isMobileResolution)
        ? 32
        : 48;
    final PdfTextSelectionChangedDetails? details = _textSelectionDetails;
    final RenderBox? renderBoxContainer =
        // ignore: avoid_as
        context.findRenderObject()! as RenderBox;
    if (renderBoxContainer != null) {
      final Offset containerOffset = renderBoxContainer.localToGlobal(
        renderBoxContainer.paintBounds.topLeft,
      );
      if (details != null &&
              containerOffset.dy <
                  details.globalSelectedRegion!.topLeft.dy - 55 ||
          (containerOffset.dy <
                  details!.globalSelectedRegion!.center.dy -
                      (_contextMenuHeight / 2) &&
              details.globalSelectedRegion!.height > _contextMenuWidth)) {
        double top = details.globalSelectedRegion!.height > _contextMenuWidth
            ? details.globalSelectedRegion!.center.dy - (_contextMenuHeight / 2)
            : details.globalSelectedRegion!.topLeft.dy - 55;
        double left = details.globalSelectedRegion!.height > _contextMenuWidth
            ? details.globalSelectedRegion!.center.dx - (_contextMenuWidth / 2)
            : details.globalSelectedRegion!.bottomLeft.dx;
        if ((details.globalSelectedRegion!.top) >
            MediaQuery.of(context).size.height / 2) {
          top = details.globalSelectedRegion!.topLeft.dy - 55;
          left = details.globalSelectedRegion!.bottomLeft.dx;
        }
        if (offset != null) {
          top = offset.dy;
          left = offset.dx;
        }
        final OverlayState? _overlayState =
            Overlay.of(context, rootOverlay: true);
        _selectionOverlayEntry = OverlayEntry(
          builder: (context) => Positioned(
            top: top,
            left: left,
            child: Container(
              decoration: BoxDecoration(
                color: _contextMenuColor,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.14),
                    blurRadius: 2,
                    offset: Offset(0, 0),
                  ),
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.12),
                    blurRadius: 2,
                    offset: Offset(0, 2),
                  ),
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.2),
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              constraints: BoxConstraints.tightFor(
                  width: _contextMenuWidth, height: _contextMenuHeight),
              child: TextButton(
                onPressed: () async {
                  _checkAndCloseContextMenu();
                  _pdfViewerController.clearSelection();
                  if (!kIsWeb &&
                          _textSearchKey?.currentState?._pdfTextSearchResult !=
                              null &&
                          _textSearchKey!
                              .currentState!._pdfTextSearchResult.hasResult ||
                      (kIsWeb &&
                              model.isMobileResolution != null &&
                              model.isMobileResolution) &&
                          _textSearchKey?.currentState?._pdfTextSearchResult !=
                              null &&
                          _textSearchKey!
                              .currentState!._pdfTextSearchResult.hasResult) {
                    setState(() {
                      _showToolbar = false;
                    });
                  }
                  await Clipboard.setData(
                      ClipboardData(text: details.selectedText));
                  setState(() {
                    _showToast = true;
                  });
                  await Future.delayed(Duration(seconds: 1));
                  setState(() {
                    _showToast = false;
                  });
                },
                child: Text(
                  'Copy',
                  style: (kIsWeb &&
                          model.isMobileResolution != null &&
                          !model.isMobileResolution)
                      ? TextStyle(
                          color: _copyColor,
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400)
                      : TextStyle(fontSize: 17, color: _copyColor),
                ),
              ),
            ),
          ),
        );
        _overlayState?.insert(_selectionOverlayEntry!);
      }
    }
  }

  /// Check and close the text selection context menu.
  void _checkAndCloseContextMenu() {
    if (_selectionOverlayEntry != null) {
      _selectionOverlayEntry?.remove();
      _selectionOverlayEntry = null;
    }
  }

  /// Ensure the entry history of text search.
  void _ensureHistoryEntry() {
    if (_historyEntry == null) {
      final ModalRoute<dynamic>? route = ModalRoute.of(context);
      if (route != null) {
        _historyEntry = LocalHistoryEntry(onRemove: _handleHistoryEntryRemoved);
        route.addLocalHistoryEntry(_historyEntry!);
      }
    }
  }

  /// Remove history entry for text search.
  void _handleHistoryEntryRemoved() {
    _textSearchKey?.currentState?.clearSearch();
    _historyEntry = null;
    _showScrollHead = true;
  }

  /// Show text search menu for web platform.
  void _showTextSearchMenu() {
    if (_textSearchOverlayEntry == null) {
      _toolbarKey?.currentState?._focusToolbarButton('Search');
      final RenderBox? searchRenderBox =
          _toolbarKey?.currentState?._searchKey.currentContext
              // ignore: avoid_as
              ?.findRenderObject() as RenderBox;
      if (searchRenderBox != null) {
        final Offset position = searchRenderBox.localToGlobal(Offset.zero);
        final OverlayState? overlayState =
            Overlay.of(context, rootOverlay: true);
        overlayState?.insert(_textSearchOverlayEntry = OverlayEntry(
          builder: (BuildContext context) {
            return Positioned(
              top: position.dy + 40.0, // y position of search menu
              left: (MediaQuery.of(context).size.width - 8) -
                  412, // x position of search menu
              child: TextSearchOverlay(
                key: _textSearchOverlayKey!,
                controller: _pdfViewerController,
                textSearchOverlayEntry: _textSearchOverlayEntry!,
                onClose: _handleSearchMenuClose,
                brightness: model.themeData.brightness,
                primaryColor: model.backgroundColor,
              ),
            );
          },
        ));
      }
    }
  }

  /// Close search menu for web platform.
  void _handleSearchMenuClose() {
    if (_textSearchOverlayEntry != null) {
      _toolbarKey?.currentState?._unFocusToolbarButton('Search');
      _textSearchOverlayKey?.currentState?._pdfTextSearchResult.clear();
      _textSearchOverlayEntry?.remove();
      _textSearchOverlayEntry = null;
    }
  }

  /// Get choose file list to change pdf for web platform.
  Widget _getChooseFileList(String fileName, String path) {
    return Container(
      height: 32, // height of each file list
      width: 202, // width of each file list
      child: RawMaterialButton(
        onPressed: () {
          _closeChooseFileMenu();
          setState(() {
            _documentPath = path;
          });
        },
        child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.01),
            child: Text(
              fileName,
              style: TextStyle(
                  color: model.themeData.brightness == Brightness.light
                      ? Color(0x00000000).withOpacity(0.87)
                      : Color(0x00ffffff).withOpacity(0.87),
                  fontSize: 14,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ),
    );
  }

  /// Shows choose file menu for selecting PDF file to be loaded in SfPdfViewer Widget.
  /// This is for web platform.
  void _showChooseFileMenu(BuildContext context) {
    _toolbarKey?.currentState?._focusToolbarButton('ChooseFile');
    final RenderBox? chooseFileRenderBox =
        _toolbarKey?.currentState?._chooseFileKey.currentContext
            // ignore: avoid_as
            ?.findRenderObject() as RenderBox;
    if (chooseFileRenderBox != null) {
      final Offset position = chooseFileRenderBox.localToGlobal(Offset.zero);
      final OverlayState? overlayState = Overlay.of(context, rootOverlay: true);
      _chooseFileOverlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          top: position.dy + 40.0, // y position of choose file overlay
          left: position.dx, // x position of choose file overlay
          child: Container(
            decoration: BoxDecoration(
              color: _contextMenuColor,
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.26),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            constraints: BoxConstraints.tightFor(width: 202, height: 171),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _getChooseFileList(
                    'GIS Succinctly', 'assets/pdf/gis_succinctly.pdf'),
                _getChooseFileList(
                    'HTTP Succinctly', 'assets/pdf/http_succinctly.pdf'),
                _getChooseFileList('JavaScript Succinctly',
                    'assets/pdf/javascript_succinctly.pdf'),
                _getChooseFileList('Single Page Document',
                    'assets/pdf/single_page_document.pdf'),
                _getChooseFileList(
                    'Corrupted Document', 'assets/pdf/corrupted_document.pdf'),
              ],
            ),
          ),
        ),
      );
      overlayState?.insert(_chooseFileOverlayEntry!);
    }
  }

  /// Close choose file menu for web platform.
  void _closeChooseFileMenu() {
    if (_chooseFileOverlayEntry != null) {
      _toolbarKey?.currentState?._unFocusToolbarButton('ChooseFile');
      _chooseFileOverlayEntry?.remove();
      _chooseFileOverlayEntry = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      final bool? isDrawerOpened = model.webOutputContainerState.widget
          .webLayoutPageState?.scaffoldKey.currentState?.isEndDrawerOpen;
      if (isDrawerOpened != null && isDrawerOpened) {
        _closeOverlay();
      }
    }

    PreferredSizeWidget appBar = AppBar(
      flexibleSpace: RawKeyboardListener(
        focusNode: _focusNode,
        onKey: (event) {
          if (event.isControlPressed &&
              event.logicalKey == LogicalKeyboardKey.keyF) {
            _showTextSearchMenu();
          }
        },
        child: Toolbar(
          key: _toolbarKey!,
          showTooltip: true,
          controller: _pdfViewerController,
          onTap: (Object toolbarItem) {
            if (kIsWeb && !model.isMobileResolution) {
              if (toolbarItem == 'Pan mode') {
                setState(() {
                  if (_interactionMode == PdfInteractionMode.selection) {
                    _pdfViewerController.clearSelection();
                    _interactionMode = PdfInteractionMode.pan;
                  } else {
                    _interactionMode = PdfInteractionMode.selection;
                  }
                });
              }
              if (toolbarItem == 'Choose file') {
                _handleSearchMenuClose();
                if (_chooseFileOverlayEntry == null) {
                  _showChooseFileMenu(context);
                } else {
                  _closeChooseFileMenu();
                }
              } else {
                _closeChooseFileMenu();
              }
              if (toolbarItem != 'Zoom Percentage') {
                _toolbarKey?.currentState?.closeZoomPercentageMenu();
              }
              if (toolbarItem.toString() == 'Bookmarks') {
                _handleSearchMenuClose();
                _pdfViewerKey?.currentState?.openBookmarkView();
              }
              if (toolbarItem.toString() != 'Bookmarks' &&
                  _pdfViewerKey!.currentState!.isBookmarkViewOpen) {
                Navigator.pop(context);
              }
              if (toolbarItem == 'Search') {
                _showTextSearchMenu();
              }
            } else {
              if (_pdfViewerKey!.currentState!.isBookmarkViewOpen) {
                Navigator.pop(context);
              }
              if (toolbarItem is Document) {
                setState(() {
                  _documentPath = toolbarItem.path;
                });
              }
              if (toolbarItem.toString() == 'Bookmarks') {
                setState(() {
                  _showToolbar = false;
                });
                _pdfViewerKey?.currentState?.openBookmarkView();
              } else if (toolbarItem.toString() == 'Search') {
                setState(() {
                  _showToolbar = false;
                  _showScrollHead = false;
                  _ensureHistoryEntry();
                });
              }
            }
            if (toolbarItem.toString() != 'Bookmarks') {
              _checkAndCloseContextMenu();
            }
            if (toolbarItem != 'Jump to the page') {
              final currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                if (!kIsWeb ||
                    (kIsWeb &&
                        model.isMobileResolution != null &&
                        model.isMobileResolution)) {
                  currentFocus.requestFocus(FocusNode());
                }
              }
            }
          },
        ),
      ),
      automaticallyImplyLeading: false,
      backgroundColor:
          SfPdfViewerTheme.of(context)!.bookmarkViewStyle.headerBarColor,
    );
    if (kIsWeb &&
        model.isMobileResolution != null &&
        !model.isMobileResolution) {
      appBar = appBar;
    } else {
      appBar = _showToolbar
          ? appBar
          : !_pdfViewerKey!.currentState!.isBookmarkViewOpen
              ? AppBar(
                  flexibleSpace: SearchToolbar(
                    key: _textSearchKey!,
                    showTooltip: true,
                    controller: _pdfViewerController,
                    brightness: model.themeData.brightness,
                    primaryColor: model.backgroundColor,
                    onTap: (Object toolbarItem) async {
                      if (toolbarItem.toString() == 'Cancel Search') {
                        setState(() {
                          _showToolbar = true;
                          _showScrollHead = true;
                          if (Navigator.canPop(context)) {
                            Navigator.of(context).maybePop();
                          }
                        });
                      }
                      if (toolbarItem.toString() == 'Previous Instance') {
                        setState(() {
                          _showToolbar = false;
                        });
                      }
                      if (toolbarItem.toString() == 'Next Instance') {
                        setState(() {
                          _showToolbar = false;
                        });
                      }
                      if (toolbarItem.toString() == 'Clear Text') {
                        setState(() {
                          _showToolbar = false;
                        });
                      }
                      if (toolbarItem.toString() == 'noResultFound') {
                        setState(() {
                          _textSearchKey?.currentState?._showToast = true;
                        });
                        await Future.delayed(Duration(seconds: 1));
                        setState(() {
                          _textSearchKey?.currentState?._showToast = false;
                        });
                      }
                    },
                  ),
                  automaticallyImplyLeading: false,
                  backgroundColor: SfPdfViewerTheme.of(context)!
                      .bookmarkViewStyle
                      .headerBarColor,
                )
              : PreferredSize(
                  preferredSize: Size.zero,
                  child: Container(),
                );
    }
    return Scaffold(
      appBar: appBar,
      body: FutureBuilder(
        future: Future.delayed(Duration(milliseconds: 200)).then((value) {
          _showPdf = true;
        }),
        builder: (context, snapshot) {
          final Widget pdfViewer = SfPdfViewer.asset(
            _documentPath!,
            key: _pdfViewerKey,
            controller: _pdfViewerController,
            interactionMode: _interactionMode,
            canShowScrollHead: (kIsWeb) ? false : _showScrollHead,
            onTextSelectionChanged:
                (PdfTextSelectionChangedDetails details) async {
              if (details.selectedText == null &&
                  _selectionOverlayEntry != null) {
                _textSelectionDetails = null;
                _checkAndCloseContextMenu();
              } else if (details.selectedText != null &&
                  _selectionOverlayEntry == null) {
                _textSelectionDetails = details;
                _showContextMenu(context, null);
              }
            },
            onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
              showErrorDialog(context, details.error, details.description);
            },
          );
          final Widget copyToast = Visibility(
            visible: _showToast,
            child: Positioned.fill(
              bottom: 25.0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                          left: 16, top: 6, right: 16, bottom: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey[600],
                        borderRadius: BorderRadius.all(
                          Radius.circular(16.0),
                        ),
                      ),
                      child: Text(
                        'Copied',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
          if (_showPdf) {
            if (kIsWeb &&
                model.isMobileResolution != null &&
                !model.isMobileResolution) {
              return Stack(children: [
                Listener(
                  onPointerDown: (details) {
                    _closeChooseFileMenu();
                    _toolbarKey?.currentState?.closeZoomPercentageMenu();
                  },
                  child: RawKeyboardListener(
                    focusNode: _focusNode,
                    onKey: (event) {
                      if (event.isControlPressed &&
                          event.logicalKey == LogicalKeyboardKey.keyF) {
                        _showTextSearchMenu();
                      }
                    },
                    child: GestureDetector(
                        onSecondaryTapDown: (details) {
                          if (_textSelectionDetails != null &&
                              _textSelectionDetails!.globalSelectedRegion!
                                  .contains(details.globalPosition)) {
                            if (_selectionOverlayEntry != null) {
                              _checkAndCloseContextMenu();
                              _showContextMenu(context, details.globalPosition);
                            } else if (_selectionOverlayEntry == null) {
                              _showContextMenu(context, details.globalPosition);
                            }
                          }
                        },
                        child: pdfViewer),
                  ),
                ),
                copyToast,
              ]);
            }
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
                child: Stack(children: [
                  pdfViewer,
                  Visibility(
                    visible: _textSearchKey?.currentState?._showToast ?? false,
                    child: Align(
                      alignment: Alignment.center,
                      child: Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                                left: 15, top: 7, right: 15, bottom: 7),
                            decoration: BoxDecoration(
                              color: Colors.grey[600],
                              borderRadius: BorderRadius.all(
                                Radius.circular(16.0),
                              ),
                            ),
                            child: Text(
                              'No result',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  copyToast,
                ]),
              ),
            );
          } else {
            return Container(
              color: SfPdfViewerTheme.of(context)!.backgroundColor,
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
  FileExplorer({Key? key, this.brightness, this.onDocumentTap});

  /// Brightness theme for the file explorer.
  final Brightness? brightness;

  /// Called when the document is selected.
  final PdfDocumentTapCallback? onDocumentTap;

  @override
  FileExplorerState createState() => FileExplorerState();
}

/// State for the File Explorer widget
class FileExplorerState extends State<FileExplorer> {
  Color? _foregroundColor;
  Color? _backgroundColor;
  final List<Document> _documents = [
    Document('GIS Succinctly', 'assets/pdf/gis_succinctly.pdf'),
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
                    widget.onDocumentTap!(document);
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
    Key? key,
  }) : super(key: key);

  /// Indicates whether tooltip for the toolbar items need to be shown or not..
  final bool showTooltip;

  /// An object that is used to control the [SfPdfViewer].
  final PdfViewerController? controller;

  /// Called when the toolbar item is selected.
  final TapCallback? onTap;

  @override
  ToolbarState createState() => ToolbarState();
}

/// State for the Toolbar widget
class ToolbarState extends State<Toolbar> {
  SfPdfViewerThemeData? _pdfViewerThemeData;
  Color? _color;
  Color? _disabledColor;
  Color? _textColor;
  Color? _fillColor;
  Color? _panFillColor;
  Color? _chooseFileFillColor;
  Color? _zoomFillColor;
  Color? _searchFillColor;
  int _pageCount = 0;
  double _zoomLevel = 1;
  OverlayEntry? _zoomPercentageOverlay;
  final GlobalKey _searchKey = GlobalKey();
  final GlobalKey _chooseFileKey = GlobalKey();
  final GlobalKey _zoomPercentageKey = GlobalKey();
  final FocusNode? _focusNode = FocusNode();

  /// An object that is used to control the Text Field.
  TextEditingController? _textEditingController;

  @override
  void initState() {
    widget.controller?.addListener(_pageChanged);
    _textEditingController =
        TextEditingController(text: widget.controller!.pageNumber.toString());
    _pageCount = widget.controller!.pageCount;
    super.initState();
  }

  @override
  void dispose() {
    closeZoomPercentageMenu();
    widget.controller?.removeListener(_pageChanged);
    super.dispose();
  }

  /// Called when the page changes and updates the page number text field.
  void _pageChanged({String? property}) {
    if (kIsWeb && !_isMobile && _zoomLevel != widget.controller!.zoomLevel) {
      setState(() {
        _zoomLevel = widget.controller!.zoomLevel;
      });
    }
    if (widget.controller?.pageCount != null &&
        _pageCount != widget.controller!.pageCount) {
      _pageCount = widget.controller!.pageCount;
      setState(() {});
    }
    if (widget.controller?.pageNumber != null &&
        _textEditingController!.text !=
            widget.controller!.pageNumber.toString()) {
      _textEditingController!.text = widget.controller!.pageNumber.toString();
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    _pdfViewerThemeData = SfPdfViewerTheme.of(context);
    _color = _pdfViewerThemeData!.brightness == Brightness.light
        ? Colors.black.withOpacity(0.54)
        : Colors.white.withOpacity(0.65);
    _disabledColor = _pdfViewerThemeData!.brightness == Brightness.light
        ? Colors.black12
        : Colors.white12;
    _textColor = _pdfViewerThemeData!.brightness == Brightness.light
        ? Color(0x00000000).withOpacity(0.87)
        : Color(0x00ffffff).withOpacity(0.87);
    _fillColor = _pdfViewerThemeData!.brightness == Brightness.light
        ? Color(0xFFD2D2D2)
        : Color(0xFF525252);
    super.didChangeDependencies();
  }

  /// Get zoom percentage list for web platform.
  Widget _getZoomPercentageList(String percentage, double zoomLevel) {
    return Container(
      height: 32, // height of each percentage list
      width: 120, // width of each percentage list
      child: RawMaterialButton(
        onPressed: () {
          closeZoomPercentageMenu();
          setState(() {
            _zoomLevel = zoomLevel;
            widget.controller!.zoomLevel = _zoomLevel;
          });
        },
        child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0),
            child: Text(
              percentage,
              style: TextStyle(
                  color: _textColor,
                  fontSize: 14,
                  fontFamily: 'Roboto',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ),
    );
  }

  /// Shows drop down list of zoom levels for web platform.
  void _showZoomPercentageMenu(BuildContext context) {
    _focusToolbarButton('Zoom');
    final RenderBox? zoomPercentageRenderBox =
        // ignore: avoid_as
        _zoomPercentageKey.currentContext?.findRenderObject() as RenderBox;
    if (zoomPercentageRenderBox != null) {
      final Offset position =
          zoomPercentageRenderBox.localToGlobal(Offset.zero);
      final OverlayState? overlayState = Overlay.of(context, rootOverlay: true);
      _zoomPercentageOverlay = OverlayEntry(
        builder: (context) => Positioned(
          top: position.dy + 40.0, // y position of zoom percentage menu
          left: position.dx, // x position of zoom percentage menu
          child: Container(
            decoration: BoxDecoration(
              color: _pdfViewerThemeData!.brightness == Brightness.light
                  ? Color(0xFFFFFFFF)
                  : Color(0xFF424242),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.26),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            constraints: BoxConstraints.tightFor(width: 120, height: 160),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _getZoomPercentageList('100%', 1),
                _getZoomPercentageList('125%', 1.25),
                _getZoomPercentageList('150%', 1.50),
                _getZoomPercentageList('200%', 2),
                _getZoomPercentageList('300%', 3),
              ],
            ),
          ),
        ),
      );
      overlayState?.insert(_zoomPercentageOverlay!);
    }
  }

  /// Close zoom percentage menu for web platform.
  void closeZoomPercentageMenu() {
    if (_zoomPercentageOverlay != null) {
      _unFocusToolbarButton('Zoom');
      _zoomPercentageOverlay?.remove();
      _zoomPercentageOverlay = null;
    }
  }

  void _focusToolbarButton(String toolbarItem) {
    setState(() {
      if (toolbarItem == 'ChooseFile') {
        _chooseFileFillColor = _fillColor;
      } else if (toolbarItem == 'Zoom') {
        _zoomFillColor = _fillColor;
      } else if (toolbarItem == 'Search') {
        _searchFillColor = _fillColor;
      }
    });
  }

  void _unFocusToolbarButton(String toolbarItem) {
    setState(() {
      if (toolbarItem == 'ChooseFile') {
        _chooseFileFillColor = null;
      } else if (toolbarItem == 'Zoom') {
        _zoomFillColor = null;
      } else if (toolbarItem == 'Search') {
        _searchFillColor = null;
      }
    });
  }

  /// Get custom toolbar for web platform.
  Widget _getToolbarForWeb(bool canJumpToPreviousPage, bool canJumpToNextPage) {
    return Container(
        height: 56, // height of toolbar for web
        width: 1200, // width of toolbar for web
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Tooltip(
                    message: 'Choose file',
                    child: Container(
                      key: _chooseFileKey,
                      height: 36, // height of choose file menu
                      width: 50, // width of choose file menu
                      child: RawMaterialButton(
                        fillColor: _chooseFileFillColor,
                        elevation: 0.0,
                        hoverElevation: 0.0,
                        onPressed: () {
                          widget.onTap?.call('Choose file');
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Icon(
                                Icons.folder_open,
                                color: _color,
                                size: 20,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                color: _color,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Container(
                    height: 20, // height of text field
                    width: 48, // width of text field
                    child: paginationTextField(context),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 6.0),
                    child: Text(
                      'of  ${widget.controller!.pageCount}',
                      style: TextStyle(
                          color: _textColor,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontFamily: 'Roboto',
                          fontSize: 14),
                    )),
                Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      height: 36, // height of previous page button
                      width: 36, // width of previous page button
                      child: Tooltip(
                        message: 'Previous page',
                        child: RawMaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                          onPressed: canJumpToPreviousPage
                              ? () {
                                  widget.onTap?.call('Previous Page');
                                  widget.controller?.previousPage();
                                }
                              : null,
                          child: Icon(
                            Icons.keyboard_arrow_left,
                            color:
                                canJumpToPreviousPage ? _color : _disabledColor,
                            size: 20,
                          ),
                        ),
                      ),
                    )),
                Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      height: 36, // height of next page button
                      width: 36, // width of next page button
                      child: Tooltip(
                        message: 'Next page',
                        child: RawMaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                          onPressed: canJumpToNextPage
                              ? () {
                                  widget.onTap?.call('Next Page');
                                  widget.controller?.nextPage();
                                }
                              : null,
                          child: Icon(
                            Icons.keyboard_arrow_right,
                            color: canJumpToNextPage ? _color : _disabledColor,
                            size: 21,
                          ),
                        ),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: VerticalDivider(
                    width: 1.0,
                    // width of vertical divider
                    thickness: 1.0,
                    // thickness of vertical divider
                    indent: 12.0,
                    // top indent of vertical divider
                    endIndent: 12.0,
                    // bottom indent of vertical divider
                    color: _pdfViewerThemeData!.brightness == Brightness.light
                        ? Colors.black.withOpacity(0.24)
                        : Color.fromRGBO(255, 255, 255, 0.26),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Container(
                    key: _zoomPercentageKey,
                    height: 36, // height of zoom percentage menu
                    width: 72, // width of zoom percentage menu
                    child: RawMaterialButton(
                      fillColor: _zoomFillColor,
                      elevation: 0.0,
                      hoverElevation: 0.0,
                      onPressed: widget.controller!.pageNumber != 0
                          ? () {
                              widget.onTap?.call('Zoom Percentage');
                              if (_zoomPercentageOverlay == null) {
                                _showZoomPercentageMenu(context);
                              } else if (_zoomPercentageOverlay != null) {
                                closeZoomPercentageMenu();
                              }
                            }
                          : null,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              widget.controller!.pageNumber == 0
                                  ? '0%'
                                  : '${(_zoomLevel * 100).floorToDouble()}%',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Roboto',
                                fontStyle: FontStyle.normal,
                                color: _textColor,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: widget.controller!.pageNumber != 0
                                  ? _color
                                  : _disabledColor,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      height: 36, // height of zoom out button
                      width: 36, // width of zoom out button
                      child: Tooltip(
                        message: 'Zoom out',
                        child: RawMaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                          onPressed: widget.controller!.pageCount != 0 &&
                                  _zoomLevel > 1
                              ? () {
                                  widget.onTap?.call('Zoom Out');
                                  setState(() {
                                    if (_zoomLevel > 1.0 &&
                                        _zoomLevel <= 1.25) {
                                      _zoomLevel = 1.0;
                                    } else if (_zoomLevel > 1.25 &&
                                        _zoomLevel <= 1.50) {
                                      _zoomLevel = 1.25;
                                    } else if (_zoomLevel > 1.50 &&
                                        _zoomLevel <= 2.0) {
                                      _zoomLevel = 1.50;
                                    } else {
                                      _zoomLevel = 2.0;
                                    }
                                    widget.controller!.zoomLevel = _zoomLevel;
                                  });
                                }
                              : null,
                          child: Icon(
                            Icons.remove_circle_outline,
                            color: widget.controller!.pageCount != 0 &&
                                    _zoomLevel > 1
                                ? _color
                                : _disabledColor,
                            size: 20,
                          ),
                        ),
                      ),
                    )),
                Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      height: 36, // height of zoom in button
                      width: 36, // width of zoom in button
                      child: Tooltip(
                        message: 'Zoom in',
                        child: RawMaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                          onPressed: widget.controller!.pageCount != 0 &&
                                  _zoomLevel < 3
                              ? () {
                                  widget.onTap?.call('Zoom In');
                                  setState(() {
                                    if (_zoomLevel >= 1.0 &&
                                        _zoomLevel < 1.25) {
                                      _zoomLevel = 1.25;
                                    } else if (_zoomLevel >= 1.25 &&
                                        _zoomLevel < 1.50) {
                                      _zoomLevel = 1.50;
                                    } else if (_zoomLevel >= 1.50 &&
                                        _zoomLevel < 2.0) {
                                      _zoomLevel = 2.0;
                                    } else {
                                      _zoomLevel = 3.0;
                                    }

                                    widget.controller!.zoomLevel = _zoomLevel;
                                  });
                                }
                              : null,
                          child: Icon(
                            Icons.add_circle_outline,
                            color: widget.controller!.pageCount != 0 &&
                                    _zoomLevel < 3
                                ? _color
                                : _disabledColor,
                            size: 20,
                          ),
                        ),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: VerticalDivider(
                    width: 1.0,
                    // width of vertical divider
                    thickness: 1.0,
                    // thickness of vertical divider
                    indent: 12.0,
                    // top indent of vertical divider
                    endIndent: 12.0,
                    // bottom indent of vertical divider
                    color: _pdfViewerThemeData!.brightness == Brightness.light
                        ? Colors.black.withOpacity(0.24)
                        : Color.fromRGBO(255, 255, 255, 0.26),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Container(
                    height: 36, // height of pan mode button
                    width: 36, // width of pan mode button
                    child: Tooltip(
                      message: 'Pan mode',
                      child: RawMaterialButton(
                        fillColor: _panFillColor,
                        elevation: 0.0,
                        hoverElevation: 0.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                        onPressed: widget.controller!.pageNumber != 0
                            ? () {
                                setState(() {
                                  if (_panFillColor == Color(0xFFD2D2D2) ||
                                      _panFillColor == Color(0xFF525252)) {
                                    _panFillColor = null;
                                  } else {
                                    _panFillColor = _fillColor;
                                  }
                                });

                                widget.onTap?.call('Pan mode');
                              }
                            : null,
                        child: Icon(
                          Icons.pan_tool_rounded,
                          color: widget.controller!.pageCount != 0
                              ? _color
                              : _disabledColor,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Container(
                    height: 36, // height of bookmark button
                    width: 36, // width of bookmark button
                    child: Tooltip(
                      message: 'Bookmark',
                      child: RawMaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                        onPressed: widget.controller!.pageNumber != 0
                            ? () {
                                widget.onTap?.call('Bookmarks');
                              }
                            : null,
                        child: Icon(
                          Icons.bookmark_border,
                          color: widget.controller!.pageCount != 0
                              ? _color
                              : _disabledColor,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: VerticalDivider(
                    width: 1.0,
                    // width of vertical divider
                    thickness: 1.0,
                    // thickness of vertical divider
                    indent: 12.0,
                    // top indent of vertical divider
                    endIndent: 12.0,
                    // bottom indent of vertical divider
                    color: _pdfViewerThemeData!.brightness == Brightness.light
                        ? Colors.black.withOpacity(0.24)
                        : Color.fromRGBO(255, 255, 255, 0.26),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Container(
                    key: _searchKey,
                    height: 36, // height of search button
                    width: 36, // width of search button
                    child: Tooltip(
                      message: 'Search',
                      child: RawMaterialButton(
                        fillColor: _searchFillColor,
                        elevation: 0.0,
                        hoverElevation: 0.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                        onPressed: widget.controller!.pageNumber != 0
                            ? () {
                                widget.controller!.clearSelection();
                                widget.onTap?.call('Search');
                              }
                            : null,
                        child: Icon(
                          Icons.search,
                          color: widget.controller!.pageCount != 0
                              ? _color
                              : _disabledColor,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  /// Find whether device is mobile or tablet.
  void _findDevice(BuildContext context) {
    /// Standard diagonal offset of tablet.
    const double _kPdfStandardDiagonalOffset = 1100.0;
    final Size size = MediaQuery.of(context).size;
    final double diagonal =
        sqrt((size.width * size.width) + (size.height * size.height));
    _isMobile = diagonal < _kPdfStandardDiagonalOffset;
  }

  /// If true,MobileBrowserView is enabled.Default value is false.
  bool _isMobile = false;

  @override
  Widget build(BuildContext context) {
    final canJumpToPreviousPage = widget.controller!.pageNumber > 1;
    final canJumpToNextPage =
        widget.controller!.pageNumber < widget.controller!.pageCount;
    _findDevice(context);
    if (kIsWeb && !_isMobile) {
      return _getToolbarForWeb(canJumpToPreviousPage, canJumpToNextPage);
    }
    return GestureDetector(
      onTap: () {
        widget.onTap?.call('Toolbar');
      },
      child: Container(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          height: 56, // height of toolbar for mobile platform
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ToolbarItem(
                height: 40, // height of file explorer button
                width: 40, // width of file explorer button
                child: Material(
                    color: Colors.transparent,
                    child: IconButton(
                      icon: Icon(
                        Icons.folder_open,
                        color: _color,
                        size: 24,
                      ),
                      onPressed: () async {
                        widget.onTap?.call('File Explorer');
                        widget.controller!.clearSelection();
                        await Future.delayed(Duration(milliseconds: 50));
                        await Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => FileExplorer(
                                  brightness: _pdfViewerThemeData!.brightness,
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
                    height: 25, // height of pagination fields
                    width: 75, // width of pagination fields
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
                      height: 40, // height of previous page button
                      width: 40, // width of previous page button
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
                      height: 40, // height of next page button
                      width: 40, // width of next page button
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
                  height: 40, // height of bookmark button
                  width: 40, // width of bookmark button
                  child: Material(
                    color: Colors.transparent,
                    child: IconButton(
                      icon: Icon(
                        Icons.bookmark,
                        color: widget.controller!.pageNumber == 0
                            ? Colors.black12
                            : _color,
                        size: 24,
                      ),
                      onPressed: widget.controller!.pageNumber == 0
                          ? null
                          : () {
                              _textEditingController!.selection = TextSelection(
                                  baseOffset: -1, extentOffset: -1);
                              widget.onTap?.call('Bookmarks');
                            },
                      tooltip: widget.showTooltip ? 'Bookmarks' : null,
                    ),
                  )),
              ToolbarItem(
                  height: 40, // height of search button
                  width: 40, // width of search button
                  child: Material(
                    color: Colors.transparent,
                    child: IconButton(
                      icon: Icon(
                        Icons.search,
                        color: widget.controller!.pageNumber == 0
                            ? Colors.black12
                            : _color,
                        size: 24,
                      ),
                      onPressed: widget.controller!.pageNumber == 0
                          ? null
                          : () {
                              widget.controller!.clearSelection();
                              widget.onTap?.call('Search');
                            },
                      tooltip: widget.showTooltip ? 'Search' : null,
                    ),
                  ))
            ],
          )),
    );
  }

  /// Pagination text field widget.
  Widget paginationTextField(BuildContext context) {
    return TextField(
      autofocus: false,
      style: (kIsWeb && !_isMobile)
          ? TextStyle(
              color: _textColor,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              fontFamily: 'Roboto',
              fontSize: 14)
          : TextStyle(color: _color),
      enableInteractiveSelection: false,
      keyboardType: TextInputType.number,
      controller: _textEditingController,
      textAlign: TextAlign.center,
      maxLength: (kIsWeb && !_isMobile) ? 4 : 3,
      focusNode: _focusNode,
      maxLines: 1,
      decoration: InputDecoration(
        counterText: '',
        contentPadding: (kIsWeb && !_isMobile)
            ? EdgeInsets.only(bottom: 22)
            : (kIsWeb)
                ? (EdgeInsets.only(bottom: 20))
                : null,
        border: UnderlineInputBorder(
          borderSide: BorderSide(width: 1.0),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
        ),
      ),
      enabled: widget.controller!.pageCount == 0 ? false : true,
      onTap: widget.controller!.pageCount == 0
          ? null
          : () {
              _textEditingController!.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: _textEditingController!.value.text.length);
              _focusNode?.requestFocus();
              widget.onTap?.call('Jump to the page');
            },
      onSubmitted: (String text) {
        _focusNode?.unfocus();
      },
      onEditingComplete: () {
        final str = _textEditingController!.text;
        if (str != widget.controller!.pageNumber.toString()) {
          try {
            final int index = int.parse(str);
            if (index > 0 && index <= widget.controller!.pageCount) {
              widget.controller?.jumpToPage(index);
              FocusScope.of(context).requestFocus(FocusNode());
              widget.onTap?.call('Navigated');
            } else {
              _textEditingController!.text =
                  widget.controller!.pageNumber.toString();
              if (!kIsWeb || (kIsWeb && _isMobile)) {
                showErrorDialog(
                    context, 'Error', 'Please enter a valid page number.');
              }
            }
          } catch (exception) {
            if (!kIsWeb || (kIsWeb && _isMobile)) {
              return showErrorDialog(
                  context, 'Error', 'Please enter a valid page number.');
            }
          }
        }
        widget.onTap?.call('Navigated');
      },
    );
  }
}

/// Signature for [SearchToolbar.onTap] callback.
typedef SearchTapCallback = void Function(Object item);

/// SearchToolbar widget
class SearchToolbar extends StatefulWidget {
  ///it describe search toolbar constructor
  SearchToolbar({
    this.controller,
    this.onTap,
    this.showTooltip = true,
    this.brightness,
    this.primaryColor,
    Key? key,
  }) : super(key: key);

  /// Indicates whether tooltip for the search toolbar items need to be shown or not.
  final bool showTooltip;

  /// An object that is used to control the [SfPdfViewer].
  final PdfViewerController? controller;

  /// Called when the search toolbar item is selected.
  final SearchTapCallback? onTap;

  /// Brightness theme for text search overlay.
  final Brightness? brightness;

  /// Palette color for text search overlay.
  final Color? primaryColor;

  @override
  SearchToolbarState createState() => SearchToolbarState();
}

/// State for the SearchToolbar widget
class SearchToolbarState extends State<SearchToolbar> {
  int _searchTextLength = 0;
  Color? _color;
  Color? _textColor;

  /// Indicates whether search toolbar items need to be shown or not.
  bool _showItem = false;

  /// Indicates whether search toast need to be shown or not.
  bool _showToast = false;

  ///An object that is used to retrieve the current value of the TextField.
  final TextEditingController _editingController = TextEditingController();

  /// An object that is used to retrieve the text search result.
  PdfTextSearchResult _pdfTextSearchResult = PdfTextSearchResult();

  ///An object that is used to obtain keyboard focus and to handle keyboard events.
  FocusNode? focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    focusNode?.requestFocus();
  }

  @override
  void dispose() {
    focusNode?.dispose();
    super.dispose();
  }

  ///Clear the text search result
  void clearSearch() {
    _pdfTextSearchResult.clear();
  }

  @override
  void didChangeDependencies() {
    _color = widget.brightness == Brightness.light
        ? Color(0x00000000).withOpacity(0.87)
        : Color(0x00ffffff).withOpacity(0.87);
    _textColor = widget.brightness == Brightness.light
        ? Color.fromRGBO(0, 0, 0, 0.54).withOpacity(0.87)
        : Color(0x00ffffff).withOpacity(0.54);
    super.didChangeDependencies();
  }

  /// Display the Alert Dialog to search from the beginning
  void _showSearchAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Search Result',
                style: TextStyle(
                    color: _color,
                    fontFamily: 'Roboto',
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    decoration: TextDecoration.none),
              ),
              Container(
                height: 36, // height of close search menu button
                width: 36, // width of close search menu button
                child: RawMaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.clear,
                    color: widget.brightness == Brightness.light
                        ? Color.fromRGBO(0, 0, 0, 0.54)
                        : Color.fromRGBO(255, 255, 255, 0.65),
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: widget.brightness == Brightness.light
              ? Color(0xFFFFFFFF)
              : Color(0xFF424242),
          content: Container(
              width: 328,
              child: Text(
                'No more occurrences found. Would you like to continue to search from the beginning?',
                style: TextStyle(
                    color: _color,
                    fontFamily: 'Roboto',
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                    decoration: TextDecoration.none),
              )),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _pdfTextSearchResult.clear();
                _editingController.clear();
                _showItem = false;
                focusNode?.requestFocus();
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                primary: Colors.transparent,
              ),
              child: Text(
                'NO',
                style: TextStyle(
                    color: widget.primaryColor,
                    fontFamily: 'Roboto',
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    decoration: TextDecoration.none),
              ),
            ),
            TextButton(
              onPressed: () {
                _pdfTextSearchResult.nextInstance();
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                primary: Colors.transparent,
              ),
              child: Text(
                'YES',
                style: TextStyle(
                    color: widget.primaryColor,
                    fontFamily: 'Roboto',
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    decoration: TextDecoration.none),
              ),
            ),
          ],
          actionsPadding: EdgeInsets.only(bottom: 10),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56, // height of search toolbar
      child: Row(
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: widget.brightness == Brightness.light
                    ? Color(0x00000000).withOpacity(0.54)
                    : Color(0x00ffffff).withOpacity(0.54),
                size: 24,
              ),
              onPressed: () {
                widget.onTap?.call('Cancel Search');
                _editingController.clear();
                _pdfTextSearchResult.clear();
              },
            ),
          ),
          Flexible(
            child: TextFormField(
              style: TextStyle(
                  color: _color,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Roboto',
                  fontStyle: FontStyle.normal,
                  fontSize: 16),
              enableInteractiveSelection: false,
              focusNode: focusNode,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              controller: _editingController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Find...',
                hintStyle: TextStyle(
                    color: widget.brightness == Brightness.light
                        ? Color(0x00000000).withOpacity(0.34)
                        : Color(0x00ffffff).withOpacity(0.54),
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Roboto',
                    fontStyle: FontStyle.normal,
                    fontSize: 16),
              ),
              onChanged: (text) {
                if (_searchTextLength < _editingController.value.text.length) {
                  setState(() {});
                  _searchTextLength = _editingController.value.text.length;
                }
                if (_editingController.value.text.length < _searchTextLength) {
                  setState(() {
                    _showItem = false;
                  });
                }
              },
              onFieldSubmitted: (String value) async {
                _pdfTextSearchResult = await widget.controller!
                    .searchText(_editingController.text);
                if (_pdfTextSearchResult.totalInstanceCount == 0) {
                  widget.onTap?.call('noResultFound');
                } else {
                  _showItem = true;
                }
              },
            ),
          ),
          Visibility(
            visible: _editingController.text.isNotEmpty,
            child: Material(
              color: Colors.transparent,
              child: IconButton(
                icon: Icon(
                  Icons.clear,
                  size: 24,
                  color: widget.brightness == Brightness.light
                      ? Color.fromRGBO(0, 0, 0, 0.54)
                      : Color.fromRGBO(255, 255, 255, 0.65),
                ),
                onPressed: () {
                  setState(() {
                    _editingController.clear();
                    _pdfTextSearchResult.clear();
                    widget.controller!.clearSelection();
                    _showItem = false;
                    focusNode?.requestFocus();
                  });
                  widget.onTap?.call('Clear Text');
                },
                tooltip: widget.showTooltip ? 'Clear Text' : null,
              ),
            ),
          ),
          Visibility(
            visible: _showItem,
            child: Row(
              children: [
                Text(
                  '${_pdfTextSearchResult.currentInstanceIndex}',
                  style: TextStyle(
                      color: _textColor,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Roboto',
                      fontStyle: FontStyle.normal,
                      fontSize: 12),
                ),
                Text(
                  ' of ',
                  style: TextStyle(
                      color: _textColor,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Roboto',
                      fontStyle: FontStyle.normal,
                      fontSize: 12),
                ),
                Text(
                  '${_pdfTextSearchResult.totalInstanceCount}',
                  style: TextStyle(
                      color: _textColor,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Roboto',
                      fontStyle: FontStyle.normal,
                      fontSize: 12),
                ),
                Material(
                  color: Colors.transparent,
                  child: IconButton(
                    icon: Icon(
                      Icons.navigate_before,
                      color: widget.brightness == Brightness.light
                          ? Color.fromRGBO(0, 0, 0, 0.54)
                          : Color.fromRGBO(255, 255, 255, 0.65),
                      size: 24,
                    ),
                    onPressed: () {
                      setState(() {
                        _pdfTextSearchResult.previousInstance();
                      });
                      widget.onTap?.call('Previous Instance');
                    },
                    tooltip: widget.showTooltip ? 'Previous' : null,
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: IconButton(
                    icon: Icon(
                      Icons.navigate_next,
                      size: 24,
                      color: widget.brightness == Brightness.light
                          ? Color.fromRGBO(0, 0, 0, 0.54)
                          : Color.fromRGBO(255, 255, 255, 0.65),
                    ),
                    onPressed: () {
                      setState(() {
                        if (_pdfTextSearchResult.currentInstanceIndex ==
                                _pdfTextSearchResult.totalInstanceCount &&
                            _pdfTextSearchResult.currentInstanceIndex != 0 &&
                            _pdfTextSearchResult.totalInstanceCount != 0) {
                          _showSearchAlertDialog(context);
                        } else {
                          widget.controller!.clearSelection();
                          _pdfTextSearchResult.nextInstance();
                        }
                      });
                      widget.onTap?.call('Next Instance');
                    },
                    tooltip: widget.showTooltip ? 'Next' : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
  final double? height;

  /// Width of the toolbar item
  final double? width;

  /// Child widget of the toolbar item
  final Widget? child;

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
        insetPadding: EdgeInsets.all(0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(error),
            Container(
              height: 36, // height of close search menu button
              width: 36, // width of close search menu button
              child: RawMaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.clear,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        content: Container(width: 328.0, child: Text(description)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: Text('OK'),
          )
        ],
        actionsPadding: EdgeInsets.only(bottom: 10),
      );
    },
  );
}

/// TextSearchOverlay widget for search operation.This is for web platform.
class TextSearchOverlay extends StatefulWidget {
  /// Constructor for TextSearchOverlay.
  TextSearchOverlay(
      {Key? key,
      this.controller,
      this.textSearchOverlayEntry,
      this.onClose,
      this.brightness,
      this.primaryColor})
      : super(key: key);

  /// An object that is used to control the [SfPdfViewer].
  final PdfViewerController? controller;

  /// An object that is used to insert text search overlay.
  final OverlayEntry? textSearchOverlayEntry;

  /// Callback which triggers when closing the search overlay.
  final VoidCallback? onClose;

  /// Brightness theme for text search overlay.
  final Brightness? brightness;

  /// Palette color for text search overlay.
  final Color? primaryColor;

  @override
  _TextSearchOverlayState createState() => _TextSearchOverlayState();
}

/// State class of TextSearchOverlay widget.This is for web platform.
class _TextSearchOverlayState extends State<TextSearchOverlay> {
  Color? _color;

  /// Indicates whether search toolbar items need to be shown or not.
  bool showItem = false;

  /// Indicates whether enter key is pressed or not.
  bool isEnterKeyPressed = false;

  /// An object that is used to retrieve the text search result.
  PdfTextSearchResult _pdfTextSearchResult = PdfTextSearchResult();

  /// An object that is used to retrieve the current value of the TextField.
  final TextEditingController _editingController = TextEditingController();

  ///Indicates whether text search option is match case
  bool? isMatchCaseChecked = false;

  ///Indicates whether text search option is whole word
  bool? isWholeWordChecked = false;

  /// Focus node for search overlay entry.
  final FocusNode? _focusNode = FocusNode();

  @override
  void initState() {
    _focusNode?.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _color = widget.brightness == Brightness.light
        ? Color(0x00000000).withOpacity(0.87)
        : Color(0x00ffffff).withOpacity(0.87);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: 146, // height of search menu
        width: 412, // width of search menu
        decoration: BoxDecoration(
          color: widget.brightness == Brightness.light
              ? Color(0xFFFFFFFF)
              : Color(0xFF424242),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.26),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16, // x position of search word in search menu
                    top: 15, // y position of search word in search menu
                  ),
                  child: Container(
                    height: 23, // height of search word in search menu
                    width: 66, // width of search word in search menu
                    child: Text(
                      'Search',
                      style: TextStyle(
                          color: _color,
                          fontFamily: 'Roboto',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          letterSpacing: -0.2,
                          decoration: TextDecoration.none),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 8, // x position of clear button in search menu
                    top: 8, // y position of clear button in search menu
                  ),
                  child: Container(
                    height: 36, // height of close search menu button
                    width: 36, // width of close search menu button
                    child: RawMaterialButton(
                      onPressed: () {
                        _closeSearchMenu();
                      },
                      child: Icon(
                        Icons.clear,
                        color: widget.brightness == Brightness.light
                            ? Color.fromRGBO(0, 0, 0, 0.54)
                            : Color.fromRGBO(255, 255, 255, 0.65),
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 16, // y position of text field in search menu
                    ),
                    child: TextFormField(
                      focusNode: _focusNode,
                      controller: _editingController,
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Roboto',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal,
                        color: _color,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 20),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(width: 1.0),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: widget.primaryColor!, width: 2.0),
                        ),
                        hintText: 'Find in document',
                        hintStyle: TextStyle(
                            color: widget.brightness == Brightness.light
                                ? Color(0x00000000).withOpacity(0.34)
                                : Color(0xFF949494),
                            fontSize: 15,
                            fontFamily: 'Roboto',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.none),
                        suffixIcon: !showItem
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, right: 8, bottom: 6, top: 15),
                                child: Container(
                                  height:
                                      14.57, // height of search button in search menu
                                  width:
                                      14.57, // width of search button in search menu
                                  child: RawMaterialButton(
                                    onPressed: () {
                                      setState(() {
                                        _handleSearchResult();
                                      });
                                    },
                                    child: Icon(
                                      Icons.search,
                                      color:
                                          widget.brightness == Brightness.light
                                              ? Colors.black.withOpacity(0.54)
                                              : Colors.white.withOpacity(0.65),
                                      size: 18,
                                    ),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, right: 8, bottom: 6, top: 15),
                                child: Container(
                                  height:
                                      14.57, // height of clear search button
                                  width: 14.57, // width of clear search button
                                  child: RawMaterialButton(
                                    onPressed: () {
                                      setState(() {
                                        _pdfTextSearchResult.clear();
                                        _editingController.clear();
                                        _focusNode?.requestFocus();
                                        showItem = false;
                                      });
                                    },
                                    child: Icon(
                                      Icons.clear,
                                      color:
                                          widget.brightness == Brightness.light
                                              ? Colors.black.withOpacity(0.54)
                                              : Colors.white.withOpacity(0.65),
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      onChanged: (String value) {
                        isEnterKeyPressed = false;
                      },
                      onFieldSubmitted: (String value) {
                        setState(() {
                          _handleSearchResult();
                        });
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: showItem,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Text(
                          _pdfTextSearchResult.currentInstanceIndex.toString(),
                          style: TextStyle(
                              color: _color,
                              fontSize: 15,
                              fontFamily: 'Roboto',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.none),
                        ),
                        Text(
                          '/',
                          style: TextStyle(
                              color: _color,
                              fontSize: 15,
                              fontFamily: 'Roboto',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.none),
                        ),
                        Text(
                          _pdfTextSearchResult.totalInstanceCount.toString(),
                          style: TextStyle(
                              color: _color,
                              fontSize: 15,
                              fontFamily: 'Roboto',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.none),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      height: 24, // height of vertical divider
                      child: VerticalDivider(
                        width: 24.0, // width of vertical divider
                        thickness: 1.0, // thickness of vertical divider
                        color: widget.brightness == Brightness.light
                            ? Colors.black.withOpacity(0.24)
                            : Color.fromRGBO(255, 255, 255, 0.26),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    height: 36, // height of previous instance button
                    width: 36, // width of previous instance button
                    child: RawMaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      onPressed: _pdfTextSearchResult.hasResult
                          ? () {
                              setState(() {
                                _pdfTextSearchResult.previousInstance();
                              });
                            }
                          : null,
                      child: Icon(
                        Icons.keyboard_arrow_left,
                        color: widget.brightness == Brightness.light
                            ? _pdfTextSearchResult.hasResult
                                ? Color.fromRGBO(0, 0, 0, 0.54)
                                : Colors.black.withOpacity(0.28)
                            : _pdfTextSearchResult.hasResult
                                ? Color.fromRGBO(255, 255, 255, 0.65)
                                : Colors.white12,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    right: 8,
                  ),
                  child: Container(
                    height: 36, // height of next instance button
                    width: 36, // width of next instance button
                    child: RawMaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      onPressed: _pdfTextSearchResult.hasResult
                          ? () {
                              setState(() {
                                _pdfTextSearchResult.nextInstance();
                              });
                            }
                          : null,
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        color: widget.brightness == Brightness.light
                            ? _pdfTextSearchResult.hasResult
                                ? Color.fromRGBO(0, 0, 0, 0.54)
                                : Colors.black.withOpacity(0.28)
                            : _pdfTextSearchResult.hasResult
                                ? Color.fromRGBO(255, 255, 255, 0.65)
                                : Colors.white12,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
                  child: Container(
                    height: 18, // height of match case checkbox
                    width: 18, // width of match case checkbox
                    child: Theme(
                      data: ThemeData(
                        unselectedWidgetColor:
                            widget.brightness == Brightness.light
                                ? Color.fromRGBO(0, 0, 0, 0.54)
                                : Color.fromRGBO(255, 255, 255, 0.54),
                      ),
                      child: Checkbox(
                        value: isMatchCaseChecked,
                        activeColor: widget.primaryColor,
                        checkColor: Colors.white,
                        onChanged: (value) {
                          setState(() {
                            isEnterKeyPressed = false;
                            isMatchCaseChecked = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 16, bottom: 16),
                  child: Text(
                    'Match case',
                    style: TextStyle(
                        color: _color,
                        fontFamily: 'Roboto',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                        decoration: TextDecoration.none),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
                  child: Container(
                    height: 18, // height of whole word checkbox
                    width: 18, // height of whole word checkbox
                    child: Theme(
                      data: ThemeData(
                        unselectedWidgetColor:
                            widget.brightness == Brightness.light
                                ? Color.fromRGBO(0, 0, 0, 0.54)
                                : Color.fromRGBO(255, 255, 255, 0.54),
                      ),
                      child: Checkbox(
                        activeColor: widget.primaryColor,
                        checkColor: Colors.white,
                        value: isWholeWordChecked,
                        onChanged: (value) {
                          setState(() {
                            isEnterKeyPressed = false;
                            isWholeWordChecked = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 16, bottom: 16),
                  child: Text(
                    'Whole word',
                    style: TextStyle(
                        color: _color,
                        fontFamily: 'Roboto',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                        decoration: TextDecoration.none),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Close search menu for web platform.
  void _closeSearchMenu() {
    setState(() {
      widget.onClose?.call();
      _pdfTextSearchResult.clear();
    });
  }

  ///Handle text search result
  void _handleSearchResult() {
    if (!isEnterKeyPressed) {
      _getSearchResult();
      showItem = true;
    } else {
      _pdfTextSearchResult.nextInstance();
    }
    _focusNode?.requestFocus();
  }

  ///Get the text search result
  void _getSearchResult() async {
    isEnterKeyPressed = true;
    if (isMatchCaseChecked! && isWholeWordChecked!) {
      _pdfTextSearchResult = await widget.controller!.searchText(
          _editingController.text,
          searchOption: TextSearchOption.both);
    } else if (isMatchCaseChecked!) {
      _pdfTextSearchResult = await widget.controller!.searchText(
        _editingController.text,
        searchOption: TextSearchOption.caseSensitive,
      );
    } else if (isWholeWordChecked!) {
      _pdfTextSearchResult = await widget.controller!.searchText(
        _editingController.text,
        searchOption: TextSearchOption.wholeWords,
      );
    } else {
      _pdfTextSearchResult = await widget.controller!.searchText(
        _editingController.text,
      );
    }
  }
}
