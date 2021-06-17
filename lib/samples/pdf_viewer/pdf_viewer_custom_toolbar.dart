import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/model/sample_view.dart';
import 'package:flutter_examples/samples/pdf_viewer/shared/helper.dart';
import 'package:flutter_examples/samples/pdf_viewer/shared/toolbar_widgets.dart';

/// Core theme import
import 'package:syncfusion_flutter_core/theme.dart';

/// PDF Viewer import
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import './shared/mobile_helper.dart'
    if (dart.library.html) './shared/web_helper.dart' as helper;

/// Signature for [SearchToolbar.onTap] callback.
typedef SearchTapCallback = void Function(Object item);

/// Signature for [FileExplorer.onDocumentTap] callback.
typedef PdfDocumentTapCallback = void Function(Document document);

/// Signature for [Toolbar.onTap] callback.
typedef TapCallback = void Function(Object item);

/// Widget of [SfPdfViewer] with custom toolbar.
class CustomToolbarPdfViewer extends SampleView {
  /// Creates a [SfPdfViewer] with custom toolbar.
  const CustomToolbarPdfViewer(Key key) : super(key: key);

  @override
  _CustomToolbarPdfViewerState createState() => _CustomToolbarPdfViewerState();
}

/// State for the [SfPdfViewer] widget with custom toolbar
class _CustomToolbarPdfViewerState extends SampleViewState {
  bool _canShowPdf = false;
  bool _canShowToast = false;
  bool _canShowToolbar = true;
  bool _canShowScrollHead = true;
  OverlayEntry? _selectionOverlayEntry;
  PdfTextSelectionChangedDetails? _textSelectionDetails;
  Color? _contextMenuColor;
  Color? _copyTextColor;
  OverlayEntry? _textSearchOverlayEntry;
  OverlayEntry? _chooseFileOverlayEntry;
  OverlayEntry? _zoomPercentageOverlay;
  LocalHistoryEntry? _historyEntry;
  bool _needToMaximize = false;
  String? _documentPath;
  PdfInteractionMode _interactionMode = PdfInteractionMode.selection;
  final FocusNode _focusNode = FocusNode()..requestFocus();
  final GlobalKey<ToolbarState> _toolbarKey = GlobalKey();
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final PdfViewerController _pdfViewerController = PdfViewerController();
  final GlobalKey<SearchToolbarState> _textSearchKey = GlobalKey();
  final GlobalKey<TextSearchOverlayState> _textSearchOverlayKey = GlobalKey();
  late bool _isLight;
  late bool _isDesktopWeb;
  final double _kWebContextMenuHeight = 32;
  final double _kMobileContextMenuHeight = 48;
  final double _kContextMenuBottom = 55;
  final double _kContextMenuWidth = 100;
  final double _kSearchOverlayWidth = 412;

  @override
  void initState() {
    super.initState();
    _documentPath = 'assets/pdf/gis_succinctly.pdf';
    _isDesktopWeb =
        kIsWeb && model.isMobileResolution != null && !model.isMobileResolution;
    if (_isDesktopWeb) {
      helper.preventDefaultContextMenu();
    }
  }

  @override
  void dispose() {
    _closeOverlays();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isLight = model.themeData.brightness == Brightness.light;
    _contextMenuColor =
        _isLight ? const Color(0xFFFFFFFF) : const Color(0xFF424242);
    _copyTextColor =
        _isLight ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
    if (_needToMaximize != model.needToMaximize) {
      _closeOverlays();
      _needToMaximize = model.needToMaximize;
    }
    _isDesktopWeb =
        kIsWeb && model.isMobileResolution != null && !model.isMobileResolution;
  }

  /// Show Context menu for Text Selection.
  void _showContextMenu(BuildContext context, Offset? offset) {
    final RenderBox renderBoxContainer =
        context.findRenderObject()! as RenderBox;
    if (renderBoxContainer != null) {
      const List<BoxShadow> boxShadows = <BoxShadow>[
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
      ];
      final double _contextMenuHeight =
          _isDesktopWeb ? _kWebContextMenuHeight : _kMobileContextMenuHeight;
      final PdfTextSelectionChangedDetails? details = _textSelectionDetails;
      final Offset containerOffset = renderBoxContainer.localToGlobal(
        renderBoxContainer.paintBounds.topLeft,
      );
      if (details != null &&
              containerOffset.dy <
                  details.globalSelectedRegion!.topLeft.dy -
                      _kContextMenuBottom ||
          (containerOffset.dy <
                  details!.globalSelectedRegion!.center.dy -
                      (_contextMenuHeight / 2) &&
              details.globalSelectedRegion!.height > _kContextMenuWidth)) {
        double top = 0.0;
        double left = 0.0;
        final Rect globalSelectedRect = details.globalSelectedRegion!;
        if (offset != null) {
          top = offset.dy;
          left = offset.dx;
        } else if ((globalSelectedRect.top) >
            MediaQuery.of(context).size.height / 2) {
          top = globalSelectedRect.topLeft.dy - _kContextMenuBottom;
          left = globalSelectedRect.bottomLeft.dx;
        } else {
          top = globalSelectedRect.height > _kContextMenuWidth
              ? globalSelectedRect.center.dy - (_contextMenuHeight / 2)
              : globalSelectedRect.topLeft.dy - _kContextMenuBottom;
          left = globalSelectedRect.height > _kContextMenuWidth
              ? globalSelectedRect.center.dx - (_kContextMenuWidth / 2)
              : globalSelectedRect.bottomLeft.dx;
        }
        final OverlayState? _overlayState =
            Overlay.of(context, rootOverlay: true);
        _selectionOverlayEntry = OverlayEntry(
          builder: (BuildContext context) => Positioned(
            top: top,
            left: left,
            child: Container(
              decoration: BoxDecoration(
                color: _contextMenuColor,
                boxShadow: boxShadows,
              ),
              constraints: BoxConstraints.tightFor(
                  width: _kContextMenuWidth, height: _contextMenuHeight),
              child: TextButton(
                onPressed: () async {
                  _handleContextMenuClose();
                  _pdfViewerController.clearSelection();
                  if (_textSearchKey.currentState != null &&
                      _textSearchKey
                          .currentState!.pdfTextSearchResult.hasResult) {
                    setState(() {
                      _canShowToolbar = false;
                    });
                  }
                  await Clipboard.setData(
                      ClipboardData(text: details.selectedText));
                  setState(() {
                    _canShowToast = true;
                  });
                  await Future<dynamic>.delayed(const Duration(seconds: 1));
                  setState(() {
                    _canShowToast = false;
                  });
                },
                child: Text(
                  'Copy',
                  style: _isDesktopWeb
                      ? TextStyle(
                          color: _copyTextColor,
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400)
                      : TextStyle(fontSize: 17, color: _copyTextColor),
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
  void _handleContextMenuClose() {
    if (_selectionOverlayEntry != null) {
      _selectionOverlayEntry?.remove();
      _selectionOverlayEntry = null;
    }
  }

  // Closes all overlay entry.
  void _closeOverlays() {
    _handleChooseFileClose();
    _handleZoomPercentageClose();
    _handleSearchMenuClose();
    _handleContextMenuClose();
    _textSearchKey.currentState?.pdfTextSearchResult.clear();
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
    _textSearchKey.currentState?.pdfTextSearchResult.clear();
    _historyEntry = null;
    _canShowScrollHead = true;
  }

  /// Show text search menu for web platform.
  void _showTextSearchMenu() {
    if (_textSearchOverlayEntry == null) {
      _toolbarKey.currentState?._changeToolbarItemFillColor('Search', true);
      final RenderBox searchRenderBox = (_toolbarKey
          .currentState?._searchKey.currentContext
          ?.findRenderObject())! as RenderBox;
      if (searchRenderBox != null) {
        final Offset position = searchRenderBox.localToGlobal(Offset.zero);
        final OverlayState? overlayState =
            Overlay.of(context, rootOverlay: true);
        overlayState?.insert(_textSearchOverlayEntry = OverlayEntry(
          builder: (BuildContext context) {
            return Positioned(
              top: position.dy + 40.0, // y position of search menu
              left: (MediaQuery.of(context).size.width - 8) -
                  _kSearchOverlayWidth, // x position of search menu
              child: TextSearchOverlay(
                key: _textSearchOverlayKey,
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
      _toolbarKey.currentState?._changeToolbarItemFillColor('Search', false);
      _textSearchOverlayKey.currentState?.clearSearchResult();
      _textSearchOverlayEntry?.remove();
      _textSearchOverlayEntry = null;
    }
  }

  /// Get choose file entry to change pdf for web platform.
  Widget _chooseFileEntry(String fileName, String path) {
    return Container(
      height: 32, // height of each file list
      width: 202, // width of each file list
      child: RawMaterialButton(
        onPressed: () {
          _handleChooseFileClose();
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
                  color: _isLight
                      ? const Color(0x00000000).withOpacity(0.87)
                      : const Color(0x00ffffff).withOpacity(0.87),
                  fontSize: 14,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ),
    );
  }

  /// Shows choose file menu for selecting PDF file to be
  /// loaded in SfPdfViewer Widget. This is for web platform.
  void _showChooseFileMenu(BuildContext context) {
    _toolbarKey.currentState?._changeToolbarItemFillColor('ChooseFile', true);
    final RenderBox chooseFileRenderBox = (_toolbarKey
        .currentState?._chooseFileKey.currentContext
        ?.findRenderObject())! as RenderBox;
    if (chooseFileRenderBox != null) {
      final Column child = Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _chooseFileEntry('GIS Succinctly', 'assets/pdf/gis_succinctly.pdf'),
          _chooseFileEntry('HTTP Succinctly', 'assets/pdf/http_succinctly.pdf'),
          _chooseFileEntry(
              'JavaScript Succinctly', 'assets/pdf/javascript_succinctly.pdf'),
          _chooseFileEntry(
              'Single Page Document', 'assets/pdf/single_page_document.pdf'),
          _chooseFileEntry(
              'Corrupted Document', 'assets/pdf/corrupted_document.pdf'),
        ],
      );
      _chooseFileOverlayEntry = _showDropDownOverlay(
          chooseFileRenderBox,
          _chooseFileOverlayEntry,
          const BoxConstraints.tightFor(width: 202, height: 171),
          child);
    }
  }

  /// Close choose file menu for web platform.
  void _handleChooseFileClose() {
    if (_chooseFileOverlayEntry != null) {
      _toolbarKey.currentState
          ?._changeToolbarItemFillColor('ChooseFile', false);
      _chooseFileOverlayEntry?.remove();
      _chooseFileOverlayEntry = null;
    }
  }

  /// Drop down overlay for choose file and zoom percentage.
  OverlayEntry? _showDropDownOverlay(
      RenderBox toolbarItemRenderBox,
      OverlayEntry? overlayEntry,
      BoxConstraints constraints,
      Widget dropDownItems) {
    const List<BoxShadow> boxShadows = <BoxShadow>[
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.26),
        blurRadius: 8,
        offset: Offset(0, 3),
      ),
    ];
    if (toolbarItemRenderBox != null) {
      final Offset position = toolbarItemRenderBox.localToGlobal(Offset.zero);
      final OverlayState? overlayState = Overlay.of(context, rootOverlay: true);
      overlayEntry = OverlayEntry(
        builder: (BuildContext context) => Positioned(
          top: position.dy + 40.0, // y position of zoom percentage menu
          left: position.dx, // x position of zoom percentage menu
          child: Container(
            decoration: BoxDecoration(
              color:
                  _isLight ? const Color(0xFFFFFFFF) : const Color(0xFF424242),
              boxShadow: boxShadows,
            ),
            constraints: constraints,
            child: dropDownItems,
          ),
        ),
      );
      overlayState?.insert(overlayEntry);
      return overlayEntry;
    }
  }

  /// Shows drop down list of zoom levels for web platform.
  void _showZoomPercentageMenu(BuildContext context) {
    _toolbarKey.currentState?._changeToolbarItemFillColor('Zoom', true);
    final RenderBox zoomPercentageRenderBox = (_toolbarKey
        .currentState?._zoomPercentageKey.currentContext
        ?.findRenderObject())! as RenderBox;
    if (zoomPercentageRenderBox != null) {
      final Column child = Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _zoomPercentageDropDownItem('100%', 1),
          _zoomPercentageDropDownItem('125%', 1.25),
          _zoomPercentageDropDownItem('150%', 1.50),
          _zoomPercentageDropDownItem('200%', 2),
          _zoomPercentageDropDownItem('300%', 3),
        ],
      );
      _zoomPercentageOverlay = _showDropDownOverlay(
          zoomPercentageRenderBox,
          _zoomPercentageOverlay,
          const BoxConstraints.tightFor(width: 120, height: 160),
          child);
    }
  }

  /// Close zoom percentage menu for web platform.
  void _handleZoomPercentageClose() {
    if (_zoomPercentageOverlay != null) {
      _toolbarKey.currentState?._changeToolbarItemFillColor('Zoom', false);
      _zoomPercentageOverlay?.remove();
      _zoomPercentageOverlay = null;
    }
  }

  /// Get zoom percentage list for web platform.
  Widget _zoomPercentageDropDownItem(String percentage, double zoomLevel) {
    return Container(
      height: 32, // height of each percentage list
      width: 120, // width of each percentage list
      child: RawMaterialButton(
        onPressed: () {
          _handleZoomPercentageClose();
          setState(() {
            _pdfViewerController.zoomLevel =
                _toolbarKey.currentState!._zoomLevel = zoomLevel;
          });
        },
        child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0),
            child: Text(
              percentage,
              style: TextStyle(
                  color: _toolbarKey.currentState?._textColor,
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

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      final bool? isDrawerOpened = model.webOutputContainerState.widget
          .webLayoutPageState?.scaffoldKey.currentState?.isEndDrawerOpen;
      if (isDrawerOpened != null && isDrawerOpened) {
        _closeOverlays();
      }
    }

    PreferredSizeWidget appBar = AppBar(
      flexibleSpace: RawKeyboardListener(
        focusNode: _focusNode,
        onKey: (RawKeyEvent event) {
          if (event.isControlPressed &&
              event.logicalKey == LogicalKeyboardKey.keyF) {
            _showTextSearchMenu();
          }
        },
        child: Toolbar(
          key: _toolbarKey,
          showTooltip: true,
          controller: _pdfViewerController,
          model: model,
          onTap: (Object toolbarItem) {
            if (_isDesktopWeb) {
              if (toolbarItem == 'Pan mode') {
                setState(() {
                  if (_interactionMode == PdfInteractionMode.selection) {
                    _pdfViewerController.clearSelection();
                    _interactionMode = PdfInteractionMode.pan;
                  } else {
                    _interactionMode = PdfInteractionMode.selection;
                  }
                });
              } else if (toolbarItem == 'Choose file') {
                _handleSearchMenuClose();
                if (_chooseFileOverlayEntry == null) {
                  _showChooseFileMenu(context);
                } else {
                  _handleChooseFileClose();
                }
              } else if (toolbarItem == 'Zoom Percentage') {
                _handleSearchMenuClose();
                if (_zoomPercentageOverlay == null) {
                  _showZoomPercentageMenu(context);
                } else {
                  _handleZoomPercentageClose();
                }
              }
              if (toolbarItem.toString() == 'Bookmarks') {
                _handleSearchMenuClose();
                _pdfViewerKey.currentState?.openBookmarkView();
              }
              if (toolbarItem.toString() != 'Bookmarks' &&
                  _pdfViewerKey.currentState!.isBookmarkViewOpen) {
                Navigator.pop(context);
              }
              if (toolbarItem == 'Search') {
                _showTextSearchMenu();
              }
              if (toolbarItem != 'Choose file') {
                _handleChooseFileClose();
              }
              if (toolbarItem != 'Zoom Percentage') {
                _handleZoomPercentageClose();
              }
            } else {
              if (_pdfViewerKey.currentState!.isBookmarkViewOpen) {
                Navigator.pop(context);
              }
              if (toolbarItem is Document) {
                setState(() {
                  _documentPath = toolbarItem.path;
                });
              }
              if (toolbarItem.toString() == 'Bookmarks') {
                setState(() {
                  _canShowToolbar = false;
                });
                _pdfViewerKey.currentState?.openBookmarkView();
              } else if (toolbarItem.toString() == 'Search') {
                setState(() {
                  _canShowToolbar = false;
                  _canShowScrollHead = false;
                  _ensureHistoryEntry();
                });
              }
            }
            if (toolbarItem.toString() != 'Bookmarks') {
              _handleContextMenuClose();
            }
            if (toolbarItem != 'Jump to the page') {
              final FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                if (!kIsWeb || _isDesktopWeb) {
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
    if (!_isDesktopWeb) {
      appBar = _canShowToolbar
          ? appBar
          : !_pdfViewerKey.currentState!.isBookmarkViewOpen
              ? AppBar(
                  flexibleSpace: SearchToolbar(
                    key: _textSearchKey,
                    canShowTooltip: true,
                    controller: _pdfViewerController,
                    brightness: model.themeData.brightness,
                    primaryColor: model.backgroundColor,
                    onTap: (Object toolbarItem) async {
                      if (toolbarItem.toString() == 'Cancel Search') {
                        setState(() {
                          _canShowToolbar = true;
                          _canShowScrollHead = true;
                          if (Navigator.canPop(context)) {
                            Navigator.of(context).maybePop();
                          }
                        });
                      }
                      if (toolbarItem.toString() == 'Previous Instance') {
                        setState(() {
                          _canShowToolbar = false;
                        });
                      }
                      if (toolbarItem.toString() == 'Next Instance') {
                        setState(() {
                          _canShowToolbar = false;
                        });
                      }
                      if (toolbarItem.toString() == 'Clear Text') {
                        setState(() {
                          _canShowToolbar = false;
                        });
                      }
                      if (toolbarItem.toString() == 'noResultFound') {
                        setState(() {
                          _textSearchKey.currentState?.canShowToast = true;
                        });
                        await Future<dynamic>.delayed(
                            const Duration(seconds: 1));
                        setState(() {
                          _textSearchKey.currentState?.canShowToast = false;
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
      // ignore: always_specify_types
      body: FutureBuilder(
        future: Future<dynamic>.delayed(const Duration(milliseconds: 200))
            .then((dynamic value) {
          _canShowPdf = true;
        }),
        builder: (BuildContext context, AsyncSnapshot<Object?> snapshot) {
          final Widget pdfViewer = SfPdfViewer.asset(
            _documentPath!,
            key: _pdfViewerKey,
            controller: _pdfViewerController,
            interactionMode: _interactionMode,
            canShowScrollHead:
                // ignore: avoid_bool_literals_in_conditional_expressions
                kIsWeb ? false : _canShowScrollHead,
            onTextSelectionChanged:
                (PdfTextSelectionChangedDetails details) async {
              if (details.selectedText == null &&
                  _selectionOverlayEntry != null) {
                _textSelectionDetails = null;
                _handleContextMenuClose();
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
          if (_canShowPdf) {
            if (_isDesktopWeb) {
              return Stack(children: <Widget>[
                Listener(
                  onPointerDown: (PointerDownEvent details) {
                    _handleChooseFileClose();
                    _handleZoomPercentageClose();
                  },
                  child: RawKeyboardListener(
                    focusNode: _focusNode,
                    onKey: (RawKeyEvent event) {
                      if (event.isControlPressed &&
                          event.logicalKey == LogicalKeyboardKey.keyF) {
                        _showTextSearchMenu();
                      }
                    },
                    child: GestureDetector(
                        onSecondaryTapDown: (TapDownDetails details) {
                          if (_textSelectionDetails != null &&
                              _textSelectionDetails!.globalSelectedRegion!
                                  .contains(details.globalPosition)) {
                            if (_selectionOverlayEntry != null) {
                              _handleContextMenuClose();
                              _showContextMenu(context, details.globalPosition);
                            } else if (_selectionOverlayEntry == null) {
                              _showContextMenu(context, details.globalPosition);
                            }
                          }
                        },
                        child: pdfViewer),
                  ),
                ),
                showToast(_canShowToast, Alignment.bottomCenter, 'Copied'),
              ]);
            }
            return SfPdfViewerTheme(
              data:
                  SfPdfViewerThemeData(brightness: model.themeData.brightness),
              child: WillPopScope(
                onWillPop: () async {
                  setState(() {
                    _canShowToolbar = true;
                  });
                  return true;
                },
                child: Stack(children: <Widget>[
                  pdfViewer,
                  showToast(_textSearchKey.currentState?.canShowToast ?? false,
                      Alignment.center, 'No result'),
                  showToast(_canShowToast, Alignment.bottomCenter, 'Copied'),
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

/// Toolbar widget
class Toolbar extends StatefulWidget {
  ///it describe top toolbar constructor
  const Toolbar({
    this.controller,
    this.onTap,
    this.showTooltip = true,
    this.model,
    Key? key,
  }) : super(key: key);

  /// Indicates whether tooltip for the toolbar items need to be shown or not..
  final bool showTooltip;

  /// An object that is used to control the [SfPdfViewer].
  final PdfViewerController? controller;

  /// Called when the toolbar item is selected.
  final TapCallback? onTap;

  /// Sample model of the entire SB.
  final SampleModel? model;

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
  late bool _isLight;
  double _zoomLevel = 1;
  final GlobalKey _searchKey = GlobalKey();
  final GlobalKey _chooseFileKey = GlobalKey();
  final GlobalKey _zoomPercentageKey = GlobalKey();
  final FocusNode _focusNode = FocusNode();
  bool _isWeb = false;

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
    widget.controller?.removeListener(_pageChanged);
    super.dispose();
  }

  /// Called when the page changes and updates the page number text field.
  void _pageChanged({String? property}) {
    if (_isWeb && _zoomLevel != widget.controller!.zoomLevel) {
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
    _isLight = _pdfViewerThemeData!.brightness == Brightness.light;
    _color = _isLight
        ? Colors.black.withOpacity(0.54)
        : Colors.white.withOpacity(0.65);
    _disabledColor = _isLight ? Colors.black12 : Colors.white12;
    _textColor = _isLight
        ? const Color(0x00000000).withOpacity(0.87)
        : const Color(0x00ffffff).withOpacity(0.87);
    _fillColor = _isLight ? const Color(0xFFD2D2D2) : const Color(0xFF525252);
    _isWeb =
        kIsWeb && widget.model != null && !widget.model!.isMobileResolution;
    super.didChangeDependencies();
  }

  /// Changes the drop down fill colors while drop down is opened or closed.
  void _changeToolbarItemFillColor(String toolbarItem, bool isFocused) {
    setState(() {
      if (toolbarItem == 'ChooseFile') {
        _chooseFileFillColor = isFocused ? _fillColor : null;
      } else if (toolbarItem == 'Zoom') {
        _zoomFillColor = isFocused ? _fillColor : null;
      } else if (toolbarItem == 'Search') {
        _searchFillColor = isFocused ? _fillColor : null;
      }
    });
  }

  /// Constructs web toolbar item widget
  Widget _webToolbarItem(String toolTip, Widget child, {Key? key}) {
    return Padding(
        padding: toolTip == 'Bookmark' || toolTip == 'Search'
            ? const EdgeInsets.only(right: 8)
            : const EdgeInsets.only(left: 8),
        child: Tooltip(
            message: toolTip,
            child: Container(
                key: key,
                height: 36,
                width: toolTip == 'Choose file' ? 50 : 36,
                child: child)));
  }

  Widget _groupDivider(bool isPaddingLeft) {
    return Padding(
      padding: isPaddingLeft
          ? const EdgeInsets.only(left: 8)
          : const EdgeInsets.only(right: 8),
      child: VerticalDivider(
        width: 1.0,
        // width of vertical divider
        thickness: 1.0,
        // thickness of vertical divider
        indent: 12.0,
        // top indent of vertical divider
        endIndent: 12.0,
        // bottom indent of vertical divider
        color: _isLight
            ? Colors.black.withOpacity(0.24)
            : const Color.fromRGBO(255, 255, 255, 0.26),
      ),
    );
  }

  /// Get custom toolbar for web platform.
  Widget _webToolbar(bool canJumpToPreviousPage, bool canJumpToNextPage) {
    return Container(
        height: 56, // height of toolbar for web
        width: 1200, // width of toolbar for web
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                // Choose file drop down
                _webToolbarItem(
                    'Choose file',
                    RawMaterialButton(
                      fillColor: _chooseFileFillColor,
                      elevation: 0.0,
                      hoverElevation: 0.0,
                      onPressed: () {
                        widget.onTap?.call('Choose file');
                      },
                      child: Row(
                        children: <Widget>[
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
                    key: _chooseFileKey),
              ],
            ),
            Row(
              children: <Widget>[
                // Text field for page number
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Container(
                    height: 20, // height of text field
                    width: 48, // width of text field
                    child: paginationTextField(context),
                  ),
                ),
                // Total page count
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
                // Previous page button
                _webToolbarItem(
                    'Previous page',
                    RawMaterialButton(
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
                        color: canJumpToPreviousPage ? _color : _disabledColor,
                        size: 20,
                      ),
                    )),
                // Next page button
                _webToolbarItem(
                    'Next page',
                    RawMaterialButton(
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
                    )),
                // Group divider
                _groupDivider(true),
                // Zoom level drop down
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
                            }
                          : null,
                      child: Row(
                        children: <Widget>[
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
                // Zoom out button
                _webToolbarItem(
                    'Zoom out',
                    RawMaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      onPressed: widget.controller!.pageCount != 0 &&
                              _zoomLevel > 1
                          ? () {
                              widget.onTap?.call('Zoom Out');
                              setState(() {
                                if (_zoomLevel > 1.0 && _zoomLevel <= 1.25) {
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
                        color:
                            widget.controller!.pageCount != 0 && _zoomLevel > 1
                                ? _color
                                : _disabledColor,
                        size: 20,
                      ),
                    )),
                // Zoom in button
                _webToolbarItem(
                    'Zoom in',
                    RawMaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      onPressed: widget.controller!.pageCount != 0 &&
                              _zoomLevel < 3
                          ? () {
                              widget.onTap?.call('Zoom In');
                              setState(() {
                                if (_zoomLevel >= 1.0 && _zoomLevel < 1.25) {
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
                        color:
                            widget.controller!.pageCount != 0 && _zoomLevel < 3
                                ? _color
                                : _disabledColor,
                        size: 20,
                      ),
                    )),
                // Group divider
                _groupDivider(true),
                // Pan mode toggle button
                _webToolbarItem(
                    'Pan mode',
                    RawMaterialButton(
                      fillColor: _panFillColor,
                      elevation: 0.0,
                      hoverElevation: 0.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      onPressed: widget.controller!.pageNumber != 0
                          ? () {
                              setState(() {
                                if (_panFillColor == const Color(0xFFD2D2D2) ||
                                    _panFillColor == const Color(0xFF525252)) {
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
                    )),
              ],
            ),
            Row(
              children: <Widget>[
                // Bookmark button
                _webToolbarItem(
                    'Bookmark',
                    RawMaterialButton(
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
                    )),
                // Group divider
                _groupDivider(false),
                // Search button
                _webToolbarItem(
                    'Search',
                    RawMaterialButton(
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
                    key: _searchKey),
              ],
            ),
          ],
        ));
  }

  /// Pagination text field widget.
  Widget paginationTextField(BuildContext context) {
    return TextField(
      autofocus: false,
      style: _isWeb
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
      maxLength: _isWeb ? 4 : 3,
      focusNode: _focusNode,
      maxLines: 1,
      decoration: InputDecoration(
        counterText: '',
        contentPadding: _isWeb
            ? const EdgeInsets.only(bottom: 22)
            : kIsWeb
                ? (const EdgeInsets.only(bottom: 20))
                : null,
        border: const UnderlineInputBorder(
          borderSide: BorderSide(width: 1.0),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
        ),
      ),
      // ignore: avoid_bool_literals_in_conditional_expressions
      enabled: widget.controller!.pageCount == 0 ? false : true,
      onTap: widget.controller!.pageCount == 0
          ? null
          : () {
              _textEditingController!.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: _textEditingController!.value.text.length);
              _focusNode.requestFocus();
              widget.onTap?.call('Jump to the page');
            },
      onSubmitted: (String text) {
        _focusNode.unfocus();
      },
      onEditingComplete: () {
        final String str = _textEditingController!.text;
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
              if (!kIsWeb || _isWeb) {
                showErrorDialog(
                    context, 'Error', 'Please enter a valid page number.');
              }
            }
          } catch (exception) {
            if (!kIsWeb || _isWeb) {
              return showErrorDialog(
                  context, 'Error', 'Please enter a valid page number.');
            }
          }
        }
        widget.onTap?.call('Navigated');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool canJumpToPreviousPage = widget.controller!.pageNumber > 1;
    final bool canJumpToNextPage =
        widget.controller!.pageNumber < widget.controller!.pageCount;
    if (_isWeb) {
      return _webToolbar(canJumpToPreviousPage, canJumpToNextPage);
    } else {
      return GestureDetector(
        onTap: () {
          widget.onTap?.call('Toolbar');
        },
        child: Container(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            height: 56, // height of toolbar for mobile platform
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Choose file button.
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
                          await Future<dynamic>.delayed(
                              const Duration(milliseconds: 50));
                          await Navigator.of(context).push<dynamic>(
                              MaterialPageRoute<dynamic>(
                                  builder: (BuildContext context) =>
                                      FileExplorer(
                                        brightness:
                                            _pdfViewerThemeData!.brightness,
                                        onDocumentTap: (Document document) {
                                          widget.onTap?.call(document);
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop(context);
                                        },
                                      )));
                        },
                        tooltip: widget.showTooltip ? 'Choose file' : null,
                      )),
                ),
                Row(children: <Widget>[
                  // Total page count
                  ToolbarItem(
                      height: 25, // height of pagination fields
                      width: 75, // width of pagination fields
                      child: Row(children: <Widget>[
                        Flexible(
                          child: paginationTextField(context),
                        ),
                        Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: Text(
                              '/',
                              style: TextStyle(color: _color, fontSize: 16),
                            )),
                        Text(
                          _pageCount.toString(),
                          style: TextStyle(color: _color, fontSize: 16),
                        )
                      ])),
                  // Previous page button
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
                  // Next page button
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
                // Bookmark button
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
                                _textEditingController!.selection =
                                    const TextSelection(
                                        baseOffset: -1, extentOffset: -1);
                                widget.onTap?.call('Bookmarks');
                              },
                        tooltip: widget.showTooltip ? 'Bookmarks' : null,
                      ),
                    )),
                // Search button
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
  }
}
