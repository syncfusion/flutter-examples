///Package import

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../model/model.dart';
import '../../model/sample_view.dart';
import 'shared/helper.dart';
import 'shared/toolbar_widgets.dart';

/// Signature for [Toolbar.onTap] callback.
typedef TapCallback = void Function(Object item);

///Sample to depict the RTL feature
class RTLModePdfViewer extends DirectionalitySampleView {
  /// Creates default getting started PDF Viewer.
  const RTLModePdfViewer(Key key) : super(key: key);
  @override
  _RTLModePdfViewerState createState() => _RTLModePdfViewerState();
}

class _RTLModePdfViewerState extends DirectionalitySampleViewState {
  bool _canShowPdf = false;
  bool _canShowToolbar = true;
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
  late bool _useMaterial3;
  late bool _isDesktopWeb;
  final double _kSearchOverlayWidth = 412;
  final TextEditingController _textFieldController = TextEditingController();
  TextDirection _textDirection = TextDirection.rtl;

  @override
  void initState() {
    super.initState();
    _documentPath = 'assets/pdf/rtl_document.pdf';
    _isDesktopWeb =
        isDesktop &&
        model.isMobileResolution != null &&
        !model.isMobileResolution;
  }

  @override
  void dispose() {
    super.dispose();
    _closeOverlays();
    _textFieldController.dispose();
    _pdfViewerController.dispose();
    _focusNode.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isLight = model.themeData.colorScheme.brightness == Brightness.light;
    _useMaterial3 = Theme.of(context).useMaterial3;
    if (_needToMaximize != model.needToMaximize) {
      _closeOverlays();
      _needToMaximize = model.needToMaximize;
    }
    _isDesktopWeb =
        isDesktop &&
        model.isMobileResolution != null &&
        !model.isMobileResolution;
  }

  @override
  void closeAllOverlay() {
    if (isDesktop) {
      _closeOverlays();
    }
    _pdfViewerController.clearSelection();
  }

  // Closes all overlay entry.
  void _closeOverlays() {
    _handleChooseFileClose();
    _handleZoomPercentageClose();
    _handleSearchMenuClose();
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
  }

  /// Drop down overlay for choose file and zoom percentage.
  OverlayEntry? _showDropDownOverlay(
    RenderBox toolbarItemRenderBox,
    OverlayEntry? overlayEntry,
    double width,
    BoxConstraints constraints,
    Widget dropDownItems,
  ) {
    if (toolbarItemRenderBox != null) {
      final Offset position = toolbarItemRenderBox.localToGlobal(Offset.zero);
      double left = position.dx;
      if (width != 0) {
        if (model.textDirection == TextDirection.ltr) {
          left = position.dx;
        } else {
          left = position.dx - width;
        }
      }

      final OverlayState overlayState = Overlay.of(context, rootOverlay: true);
      if (overlayState != null) {
        overlayEntry = OverlayEntry(
          builder: (BuildContext context) => Positioned(
            top: position.dy + 40.0, // y position of zoom percentage menu
            left: left,
            child: _dropDownOverlayContainer(constraints, dropDownItems),
          ),
        );

        overlayState.insert(overlayEntry);
      }
    }

    return overlayEntry;
  }

  /// Builds overlay container for choose file and zoom percentage.
  Widget _dropDownOverlayContainer(
    BoxConstraints constraints,
    Widget dropDownItems,
  ) {
    const List<BoxShadow> boxShadows = <BoxShadow>[
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.26),
        blurRadius: 8,
        offset: Offset(0, 3),
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: _useMaterial3
            ? _isLight
                  ? const Color.fromRGBO(238, 232, 244, 1)
                  : const Color.fromRGBO(48, 45, 56, 1)
            : _isLight
            ? const Color(0xFFFFFFFF)
            : const Color(0xFF424242),
        boxShadow: boxShadows,
        borderRadius: _useMaterial3
            ? const BorderRadius.all(Radius.circular(4.0))
            : null,
      ),
      constraints: constraints,
      child: dropDownItems,
    );
  }

  /// Show text search menu for web platform.
  void _showTextSearchMenu() {
    if (_textSearchOverlayEntry == null) {
      final RenderBox searchRenderBox =
          (_toolbarKey.currentState?._searchKey.currentContext
                  ?.findRenderObject())!
              as RenderBox;
      if (searchRenderBox != null) {
        final Offset position = searchRenderBox.localToGlobal(Offset.zero);
        final OverlayState overlayState = Overlay.of(
          context,
          rootOverlay: true,
        );
        final double left = model.textDirection == TextDirection.rtl
            ? position.dx
            : ((MediaQuery.of(context).size.width - 8) - _kSearchOverlayWidth);
        overlayState.insert(
          _textSearchOverlayEntry = OverlayEntry(
            builder: (BuildContext context) {
              return Positioned(
                top: position.dy + 40.0, // y position of search menu
                left: left, // x position of search menu
                child: TextSearchOverlay(
                  key: _textSearchOverlayKey,
                  controller: _pdfViewerController,
                  textSearchOverlayEntry: _textSearchOverlayEntry,
                  onClose: _handleSearchMenuClose,
                  brightness: model.themeData.colorScheme.brightness,
                  primaryColor: model.primaryColor,
                  textDirection: model.textDirection,
                  languageCode: model.locale!.languageCode,
                ),
              );
            },
          ),
        );
      }
    }
  }

  /// Close search menu for web platform.
  void _handleSearchMenuClose() {
    if (_textSearchOverlayEntry != null) {
      _textSearchOverlayKey.currentState?.clearSearchResult();
      _textSearchOverlayEntry?.remove();
      _textSearchOverlayEntry = null;
    }
  }

  /// Shows choose file menu for selecting PDF file to be
  /// loaded in SfPdfViewer Widget. This is for web platform.
  void _showChooseFileMenu(BuildContext context) {
    final RenderBox chooseFileRenderBox =
        (_toolbarKey.currentState?._chooseFileKey.currentContext
                ?.findRenderObject())!
            as RenderBox;
    if (chooseFileRenderBox != null) {
      final Column child = Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _chooseFileEntry('RTL Document', 'assets/pdf/rtl_document.pdf'),
          _chooseFileEntry('GIS Succinctly', 'assets/pdf/gis_succinctly.pdf'),
          _chooseFileEntry('HTTP Succinctly', 'assets/pdf/http_succinctly.pdf'),
          _chooseFileEntry(
            'JavaScript Succinctly',
            'assets/pdf/javascript_succinctly.pdf',
          ),
        ],
      );
      _chooseFileOverlayEntry = _showDropDownOverlay(
        chooseFileRenderBox,
        _chooseFileOverlayEntry,
        162,
        _useMaterial3
            ? BoxConstraints.tightFor(
                width: 205,
                height: child.children.length * 40.0,
              )
            : BoxConstraints.tightFor(
                width: 202,
                height: child.children.length * 35.0,
              ),
        child,
      );
    }
  }

  /// Close choose file menu for web platform.
  void _handleChooseFileClose() {
    if (_chooseFileOverlayEntry != null) {
      _chooseFileOverlayEntry?.remove();
      _chooseFileOverlayEntry = null;
    }
  }

  /// Get choose file entry to change pdf for web platform.
  Widget _chooseFileEntry(String fileName, String path) {
    return SizedBox(
      height: _useMaterial3 ? 40 : 32, // height of each file list
      width: _useMaterial3 ? 205 : 202, // width of each file list
      child: RawMaterialButton(
        onPressed: () {
          _handleChooseFileClose();
          setState(() {
            _documentPath = path;
          });
        },
        shape: _useMaterial3
            ? const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
              )
            : const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(2)),
              ),
        hoverColor: _useMaterial3
            ? model.themeData.colorScheme.onSurface.withValues(alpha: 0.08)
            : null,
        child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.01),
            child: Text(
              fileName,
              style: _useMaterial3
                  ? Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )
                  : TextStyle(
                      color: _isLight
                          ? const Color(0x00000000).withValues(alpha: 0.87)
                          : const Color(0x00ffffff).withValues(alpha: 0.87),
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  /// Shows drop down list of zoom levels for web platform.
  void _showZoomPercentageMenu(BuildContext context) {
    final RenderBox zoomPercentageRenderBox =
        (_toolbarKey.currentState?._zoomPercentageKey.currentContext
                ?.findRenderObject())!
            as RenderBox;
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
        0,
        _useMaterial3
            ? const BoxConstraints.tightFor(width: 85, height: 216)
            : const BoxConstraints.tightFor(width: 120, height: 160),
        child,
      );
    }
  }

  /// Close zoom percentage menu for web platform.
  void _handleZoomPercentageClose() {
    if (_zoomPercentageOverlay != null) {
      _zoomPercentageOverlay?.remove();
      _zoomPercentageOverlay = null;
    }
  }

  /// Get zoom percentage list for web platform.
  Widget _zoomPercentageDropDownItem(String percentage, double zoomLevel) {
    return SizedBox(
      height: _useMaterial3 ? 40 : 32, // height of each percentage list
      width: _useMaterial3 ? 85 : 120, // width of each percentage list
      child: RawMaterialButton(
        onPressed: () {
          _handleZoomPercentageClose();
          setState(() {
            _pdfViewerController.zoomLevel =
                _toolbarKey.currentState!._zoomLevel = zoomLevel;
          });
        },
        shape: _useMaterial3
            ? const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
              )
            : const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(2)),
              ),
        hoverColor: _useMaterial3
            ? model.themeData.colorScheme.onSurface.withValues(alpha: 0.08)
            : null,
        child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: _useMaterial3
                ? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0)
                : const EdgeInsets.only(left: 16.0, top: 8.0),
            child: Text(
              percentage,
              style: _useMaterial3
                  ? Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )
                  : TextStyle(
                      color: _toolbarKey.currentState?._textColor,
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildSample(BuildContext context) {
    if (isDesktop) {
      final bool? isDrawerOpened = model
          .webOutputContainerState
          .widget
          .webLayoutPageState
          ?.scaffoldKey
          .currentState
          ?.isDrawerOpen;
      if (isDrawerOpened != null && isDrawerOpened) {
        _closeOverlays();
      }

      if (_textDirection != model.textDirection) {
        _closeOverlays();
        _textDirection = model.textDirection;
      }
    }

    PreferredSizeWidget appBar = AppBar(
      bottom: _useMaterial3
          ? PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: Container(
                color: Theme.of(context).colorScheme.outlineVariant,
                height: 1,
              ),
            )
          : null,
      flexibleSpace: Semantics(
        label: 'Custom toolbar',
        child: KeyboardListener(
          focusNode: _focusNode,
          onKeyEvent: (KeyEvent event) {
            final bool isPrimaryKeyPressed = kIsMacOS
                ? HardwareKeyboard.instance.isMetaPressed
                : HardwareKeyboard.instance.isControlPressed;
            if (isPrimaryKeyPressed &&
                event.logicalKey == LogicalKeyboardKey.keyF) {
              _showTextSearchMenu();
            }
          },
          child: Toolbar(
            key: _toolbarKey,
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
                  setState(() {
                    _textFieldController.clear();
                  });
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
                    _textFieldController.clear();
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
                    _ensureHistoryEntry();
                  });
                }
              }
              if (toolbarItem != 'Jump to the page') {
                final FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.requestFocus(FocusNode());
                }
              }
            },
          ),
        ),
      ),
      automaticallyImplyLeading: false,
      backgroundColor: _useMaterial3
          ? Theme.of(context).colorScheme.brightness == Brightness.light
                ? const Color.fromRGBO(247, 242, 251, 1)
                : const Color.fromRGBO(37, 35, 42, 1)
          : Theme.of(context).colorScheme.brightness == Brightness.light
          ? const Color(0xFFFAFAFA)
          : const Color(0xFF424242),
    );
    if (!_isDesktopWeb) {
      appBar = _canShowToolbar
          ? appBar
          : !_pdfViewerKey.currentState!.isBookmarkViewOpen
          ? AppBar(
              flexibleSpace: Directionality(
                textDirection: model.textDirection,
                child: SearchToolbar(
                  key: _textSearchKey,
                  controller: _pdfViewerController,
                  brightness: model.themeData.colorScheme.brightness,
                  primaryColor: model.primaryColor,
                  textDirection: model.textDirection,
                  languageCode: model.locale!.languageCode,
                  onTap: (Object toolbarItem) async {
                    if (toolbarItem.toString() == 'Cancel Search') {
                      setState(() {
                        _canShowToolbar = true;
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
                      await Future<dynamic>.delayed(const Duration(seconds: 1));
                      setState(() {
                        _textSearchKey.currentState?.canShowToast = false;
                      });
                    }
                  },
                ),
              ),
              automaticallyImplyLeading: false,
              backgroundColor: _useMaterial3
                  ? Theme.of(context).colorScheme.brightness == Brightness.light
                        ? const Color.fromRGBO(247, 242, 251, 1)
                        : const Color.fromRGBO(37, 35, 42, 1)
                  : Theme.of(context).colorScheme.brightness == Brightness.light
                  ? const Color(0xFFFAFAFA)
                  : const Color(0xFF424242),
            )
          : PreferredSize(preferredSize: Size.zero, child: Container());
    }
    return Scaffold(
      appBar: appBar,
      // ignore: always_specify_types
      body: FutureBuilder(
        future: Future<dynamic>.delayed(const Duration(milliseconds: 200)).then(
          (dynamic value) {
            _canShowPdf = true;
          },
        ),
        builder: (BuildContext context, AsyncSnapshot<Object?> snapshot) {
          final Widget pdfViewer = Listener(
            onPointerDown: (PointerDownEvent details) {
              if (_isDesktopWeb) {
                _handleChooseFileClose();
                _handleZoomPercentageClose();
              }
              _textSearchKey.currentState?.focusNode!.unfocus();
              _focusNode.unfocus();
            },
            child: SfPdfViewer.asset(
              _documentPath!,
              key: _pdfViewerKey,
              controller: _pdfViewerController,
              interactionMode: _interactionMode,
              canShowPasswordDialog: false,
              canShowScrollHead: false,
            ),
          );
          if (_canShowPdf) {
            if (_isDesktopWeb) {
              return KeyboardListener(
                focusNode: _focusNode,
                onKeyEvent: (KeyEvent event) {
                  final bool isPrimaryKeyPressed = kIsMacOS
                      ? HardwareKeyboard.instance.isMetaPressed
                      : HardwareKeyboard.instance.isControlPressed;
                  if (isPrimaryKeyPressed &&
                      event.logicalKey == LogicalKeyboardKey.keyF) {
                    _showTextSearchMenu();
                  }
                },
                child: pdfViewer,
              );
            }
            return SfPdfViewerTheme(
              data: const SfPdfViewerThemeData(),
              child: PopScope(
                onPopInvokedWithResult: (bool value, Object? result) async {
                  setState(() {
                    _canShowToolbar = true;
                  });
                },
                child: Stack(
                  children: <Widget>[
                    pdfViewer,
                    showToast(
                      context,
                      _textSearchKey.currentState?.canShowToast ?? false,
                      Alignment.center,
                      model.locale!.languageCode == 'ar'
                          ? 'لا نتيجة'
                          : 'No result',
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Container(
              color:
                  SfPdfViewerTheme.of(context)!.backgroundColor ??
                  Theme.of(context).colorScheme.surface.withValues(alpha: 0.08),
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
  Color? _color;
  Color? _disabledColor;
  Color? _textColor;
  Color? _fillColor;
  Color? _panFillColor;
  int _pageCount = 0;
  late bool _isLight;
  double _zoomLevel = 1;
  final GlobalKey _searchKey = GlobalKey();
  final GlobalKey _chooseFileKey = GlobalKey();
  final GlobalKey _zoomPercentageKey = GlobalKey();
  final FocusNode _focusNode = FocusNode();
  bool _isWeb = false;
  late bool _useMaterial3;

  /// An object that is used to control the Text Field.
  TextEditingController? _textEditingController;

  @override
  void initState() {
    widget.controller?.addListener(_pageChanged);
    _textEditingController = TextEditingController(
      text: widget.controller!.pageNumber.toString(),
    );
    _pageCount = widget.controller!.pageCount;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller?.removeListener(_pageChanged);
    _textEditingController!.dispose();
    _focusNode.dispose();
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
      Future<dynamic>.delayed(Duration.zero, () {
        _textEditingController!.text = widget.controller!.pageNumber.toString();
        setState(() {});
      });
    }
  }

  @override
  void didChangeDependencies() {
    _isLight = Theme.of(context).brightness == Brightness.light;
    _useMaterial3 = Theme.of(context).useMaterial3;
    _color = _useMaterial3
        ? Theme.of(context).brightness == Brightness.light
              ? const Color.fromRGBO(73, 69, 79, 1)
              : const Color.fromRGBO(202, 196, 208, 1)
        : Theme.of(context).brightness == Brightness.light
        ? Colors.black.withValues(alpha: 0.54)
        : Colors.white.withValues(alpha: 0.65);
    _disabledColor = _useMaterial3
        ? Theme.of(context).brightness == Brightness.light
              ? const Color.fromRGBO(28, 27, 31, 1).withValues(alpha: 0.38)
              : const Color.fromRGBO(230, 225, 229, 1).withValues(alpha: 0.38)
        : Theme.of(context).brightness == Brightness.light
        ? Colors.black12
        : Colors.white12;
    _textColor = _isLight
        ? const Color(0x00000000).withValues(alpha: 0.87)
        : const Color(0x00ffffff).withValues(alpha: 0.87);
    _fillColor = _useMaterial3
        ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08)
        : _isLight
        ? const Color(0xFFD2D2D2)
        : const Color(0xFF525252);
    _isWeb =
        isDesktop && widget.model != null && !widget.model!.isMobileResolution;
    super.didChangeDependencies();
  }

  /// Constructs web toolbar item widget
  Widget _webToolbarItem(String toolTip, Widget child, {Key? key}) {
    return Padding(
      padding:
          toolTip == 'Bookmark' ||
              toolTip == 'Search' ||
              toolTip == 'المرجعية' ||
              toolTip == 'بحث'
          ? const EdgeInsets.only(right: 8)
          : const EdgeInsets.only(left: 8),
      child: Tooltip(
        message: toolTip,
        child: SizedBox(
          key: key,
          height: 36,
          width: toolTip == 'Choose file' || toolTip == 'اختر ملفًا'
              ? (_useMaterial3 ? 56 : 50)
              : 40,
          child: child,
        ),
      ),
    );
  }

  /// Constructs the web toolbar button.
  Widget _webToolbarButton({
    required Widget child,
    required void Function()? onPressed,
    ShapeBorder? shape,
    Color? fillColor,
    Color? hoverColor,
  }) {
    return RawMaterialButton(
      onPressed: onPressed,
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      hoverColor:
          hoverColor ??
          (_useMaterial3
              ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08)
              : null),
      shape:
          shape ??
          (_useMaterial3
              ? const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                )
              : const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(2)),
                )),
      fillColor: fillColor,
      child: child,
    );
  }

  /// Constructs the web toolbar divider.
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
            ? Colors.black.withValues(alpha: 0.24)
            : const Color.fromRGBO(255, 255, 255, 0.26),
      ),
    );
  }

  /// Get custom toolbar for web platform.
  Widget _webToolbar(bool canJumpToPreviousPage, bool canJumpToNextPage) {
    return SizedBox(
      height: 56, // height of toolbar for web
      width: 1200, // width of toolbar for web
      child: Directionality(
        textDirection: widget.model!.textDirection,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                // Choose file drop down
                _webToolbarItem(
                  widget.model?.locale!.languageCode == 'ar'
                      ? 'اختر ملفًا'
                      : 'Choose file',
                  _webToolbarButton(
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding:
                              widget.model!.textDirection == TextDirection.rtl
                              ? const EdgeInsets.only(right: 4.0)
                              : const EdgeInsets.only(left: 4.0),
                          child: Icon(
                            Icons.folder_open,
                            color: _color,
                            size: _useMaterial3 ? 24 : 20,
                          ),
                        ),
                        Padding(
                          padding:
                              widget.model!.textDirection == TextDirection.rtl
                              ? const EdgeInsets.only(right: 8.0)
                              : const EdgeInsets.only(left: 8.0),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: _color,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      widget.onTap?.call('Choose file');
                    },
                  ),
                  key: _chooseFileKey,
                ),
              ],
            ),
            Row(
              children: <Widget>[
                // Text field for page number
                Padding(
                  padding: _useMaterial3
                      ? const EdgeInsets.only(top: 4, left: 5)
                      : const EdgeInsets.only(top: 4.0),
                  child: SizedBox(
                    height: _useMaterial3 ? 40 : 20, // height of text field
                    width: _useMaterial3 ? 54 : 48, // / width of text field
                    child: paginationTextField(context),
                  ),
                ),
                Text(
                  _useMaterial3 ? '/' : 'of',
                  style: TextStyle(
                    color: _textColor,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontFamily: 'Roboto',
                    fontSize: _useMaterial3 ? 16 : 14,
                  ),
                ),
                // Total page count
                Padding(
                  padding: widget.model!.textDirection == TextDirection.rtl
                      ? const EdgeInsets.only(right: 5)
                      : const EdgeInsets.only(left: 5),
                  child: Text(
                    ' ${widget.controller!.pageCount}',
                    style: TextStyle(
                      color: _textColor,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Roboto',
                      fontSize: _useMaterial3 ? 16 : 14,
                    ),
                  ),
                ),
                // Previous page button
                Padding(
                  padding: const EdgeInsets.only(right: 3),
                  child: _webToolbarItem(
                    widget.model?.locale!.languageCode == 'ar'
                        ? 'الصفحة السابقة'
                        : 'Previous page',
                    _webToolbarButton(
                      child: Icon(
                        _useMaterial3
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_left,
                        color: canJumpToPreviousPage ? _color : _disabledColor,
                        size: _useMaterial3 ? 24 : 20,
                      ),
                      onPressed: canJumpToPreviousPage
                          ? () {
                              widget.onTap?.call('Previous Page');
                              widget.controller?.previousPage();
                            }
                          : null,
                    ),
                  ),
                ),
                // Next page button
                _webToolbarItem(
                  widget.model?.locale!.languageCode == 'ar'
                      ? 'الصفحة التالية'
                      : 'Next page',
                  _webToolbarButton(
                    child: Icon(
                      _useMaterial3
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_right,
                      color: canJumpToNextPage ? _color : _disabledColor,
                      size: _useMaterial3 ? 24 : 20,
                    ),
                    onPressed: canJumpToNextPage
                        ? () {
                            widget.onTap?.call('Next Page');
                            widget.controller?.nextPage();
                          }
                        : null,
                  ),
                ),
                // Group divider
                _groupDivider(true),
                // Zoom level drop down
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SizedBox(
                    key: _zoomPercentageKey,
                    height: 36, // height of zoom percentage menu
                    width: 72, // width of zoom percentage menu
                    child: _webToolbarButton(
                      onPressed: widget.controller!.pageNumber != 0
                          ? () {
                              widget.onTap?.call('Zoom Percentage');
                            }
                          : null,
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 7.0),
                            child: Text(
                              widget.controller!.pageNumber == 0
                                  ? '0%'
                                  : '${(_zoomLevel * 100).floor()}%',
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
                  widget.model?.locale!.languageCode == 'ar'
                      ? 'تصغير'
                      : 'Zoom out',
                  _webToolbarButton(
                    onPressed:
                        widget.controller!.pageCount != 0 && _zoomLevel > 1
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
                      _useMaterial3
                          ? Icons.zoom_out
                          : Icons.remove_circle_outline,
                      color: widget.controller!.pageCount != 0 && _zoomLevel > 1
                          ? _color
                          : _disabledColor,
                      size: _useMaterial3 ? 24 : 20,
                    ),
                  ),
                ),
                // Zoom in button
                _webToolbarItem(
                  widget.model?.locale!.languageCode == 'ar'
                      ? 'تكبير'
                      : 'Zoom in',
                  _webToolbarButton(
                    onPressed:
                        widget.controller!.pageCount != 0 && _zoomLevel < 3
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
                      _useMaterial3 ? Icons.zoom_in : Icons.add_circle_outline,
                      color: widget.controller!.pageCount != 0 && _zoomLevel < 3
                          ? _color
                          : _disabledColor,
                      size: _useMaterial3 ? 24 : 20,
                    ),
                  ),
                ),
                // Group divider
                _groupDivider(true),
                // Pan mode toggle button
                _webToolbarItem(
                  widget.model?.locale!.languageCode == 'ar'
                      ? 'وضع عموم'
                      : 'Pan mode',
                  _webToolbarButton(
                    onPressed: widget.controller!.pageNumber != 0
                        ? () {
                            setState(() {
                              if (_panFillColor == const Color(0xFFD2D2D2) ||
                                  _panFillColor == const Color(0xFF525252) ||
                                  _panFillColor ==
                                      Theme.of(context).colorScheme.onSurface
                                          .withValues(alpha: 0.08)) {
                                _panFillColor = null;
                              } else {
                                _panFillColor = _fillColor;
                              }
                            });
                            widget.onTap?.call('Pan mode');
                          }
                        : null,
                    fillColor: _panFillColor,
                    child: Icon(
                      Icons.pan_tool_rounded,
                      color: widget.controller!.pageCount != 0
                          ? _color
                          : _disabledColor,
                      size: _useMaterial3 ? 24 : 20,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                _webToolbarItem(
                  widget.model?.locale!.languageCode == 'ar'
                      ? 'إشارة مرجعية'
                      : 'Bookmark',
                  _webToolbarButton(
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
                      size: _useMaterial3 ? 24 : 20,
                    ),
                  ),
                ),
                // Group divider
                _groupDivider(false),
                // Search button
                _webToolbarItem(
                  widget.model?.locale!.languageCode == 'ar' ? 'بحث' : 'Search',
                  _webToolbarButton(
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
                      size: _useMaterial3 ? 24 : 20,
                    ),
                  ),
                  key: _searchKey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Pagination text field widget.
  Widget paginationTextField(BuildContext context) {
    return TextField(
      style: _isWeb
          ? TextStyle(
              color: _textColor,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              fontFamily: 'Roboto',
              fontSize: _useMaterial3 ? 16 : 14,
            )
          : TextStyle(color: _color),
      enableInteractiveSelection: false,
      keyboardType: TextInputType.number,
      controller: _textEditingController,
      textAlign: TextAlign.center,
      maxLength: _isWeb ? 4 : 3,
      focusNode: _focusNode,
      decoration: InputDecoration(
        counterText: '',
        contentPadding: _isWeb
            ? const EdgeInsets.only(bottom: 22)
            : isDesktop
            ? (const EdgeInsets.only(bottom: 20))
            : _useMaterial3
            ? EdgeInsets.zero
            : null,
        border: _paginationTextFieldInputBorder(context),
        enabledBorder: _paginationTextFieldEnableBorder(context),
        focusedBorder: _paginationTextFieldFocusedBorder(context),
      ),
      enabled: widget.controller!.pageCount > 0,
      onTap: _onPaginationTextFieldTap,
      onSubmitted: (String text) => _focusNode.unfocus(),
      onEditingComplete: () => _onPaginationTextFieldEditingComplete(context),
    );
  }

  /// Pagination text field input border.
  InputBorder _paginationTextFieldInputBorder(BuildContext context) {
    return _useMaterial3
        ? OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.38),
            ),
          )
        : const UnderlineInputBorder();
  }

  /// Pagination text field enable border.
  InputBorder? _paginationTextFieldEnableBorder(BuildContext context) {
    return _useMaterial3
        ? OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.38),
            ),
          )
        : null;
  }

  /// Pagination text field focused border.
  InputBorder _paginationTextFieldFocusedBorder(BuildContext context) {
    return _useMaterial3
        ? OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.38),
            ),
          )
        : UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2.0,
            ),
          );
  }

  /// Pagination text field on tap function.
  void _onPaginationTextFieldTap() {
    if (widget.controller!.pageCount > 0) {
      _textEditingController!.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _textEditingController!.value.text.length,
      );
      _focusNode.requestFocus();
      widget.onTap?.call('Jump to the page');
    }
  }

  /// Pagination text field on editing complete function.
  void _onPaginationTextFieldEditingComplete(BuildContext context) {
    final String str = _textEditingController!.text;
    if (str != widget.controller!.pageNumber.toString()) {
      try {
        final int index = int.parse(str);
        if (index > 0 && index <= widget.controller!.pageCount) {
          widget.controller?.jumpToPage(index);
          FocusScope.of(context).requestFocus(FocusNode());
          widget.onTap?.call('Navigated');
        } else {
          _textEditingController!.text = widget.controller!.pageNumber
              .toString();
          _showErrorDialog(context, widget.model);
        }
      } catch (exception) {
        _showErrorDialog(context, widget.model);
      }
    }
    widget.onTap?.call('Navigated');
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
          child: Directionality(
            textDirection: widget.model!.textDirection,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Choose file button.
                ToolbarItem(
                  height: 40, // height of file explorer button
                  width: 40, // width of file explorer button
                  child: Material(
                    color: Colors.transparent,
                    child: Tooltip(
                      message: widget.showTooltip
                          ? widget.model?.locale!.languageCode == 'ar'
                                ? 'اختر ملفًا'
                                : 'Choose file'
                          : null,
                      child: RawMaterialButton(
                        shape: _useMaterial3
                            ? const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4),
                                ),
                              )
                            : const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(2),
                                ),
                              ),
                        onPressed: () async {
                          widget.onTap?.call('File Explorer');
                          widget.controller!.clearSelection();
                          await Future<dynamic>.delayed(
                            const Duration(milliseconds: 50),
                          );
                          if (!mounted || !context.mounted) {
                            return;
                          }
                          await Navigator.of(context).push<dynamic>(
                            MaterialPageRoute<dynamic>(
                              builder: (BuildContext context) => FileExplorer(
                                brightness: Theme.of(context).brightness,
                                isRtlTab: true,
                                onDocumentTap: (Document document) {
                                  widget.onTap?.call(document);
                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).pop(context);
                                },
                              ),
                            ),
                          );
                        },
                        child: Icon(Icons.folder_open, color: _color, size: 24),
                      ),
                    ),
                  ),
                ),
                ToolbarItem(
                  height: 25, // height of pagination fields
                  width: 75, // width of pagination fields
                  child: Row(
                    children: <Widget>[
                      Flexible(child: paginationTextField(context)),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Text(
                          '/',
                          style: TextStyle(color: _color, fontSize: 16),
                          semanticsLabel: '',
                        ),
                      ),
                      Text(
                        _pageCount.toString(),
                        style: TextStyle(color: _color, fontSize: 16),
                        semanticsLabel: '',
                      ),
                    ],
                  ),
                ),
                // Previous page button
                Visibility(
                  visible: MediaQuery.of(context).size.width > 360.0,
                  child: ToolbarItem(
                    height: 40, // height of previous page button
                    width: 40, // width of previous page button
                    child: Material(
                      color: Colors.transparent,
                      child: Tooltip(
                        message: widget.showTooltip
                            ? widget.model?.locale!.languageCode == 'ar'
                                  ? 'الصفحة السابقة'
                                  : 'Previous page'
                            : null,
                        child: RawMaterialButton(
                          shape: _useMaterial3
                              ? const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                )
                              : const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(2),
                                  ),
                                ),
                          onPressed: canJumpToPreviousPage
                              ? () {
                                  widget.onTap?.call('Previous page');
                                  widget.controller?.previousPage();
                                }
                              : null,
                          child: Icon(
                            Icons.keyboard_arrow_up,
                            color: canJumpToPreviousPage
                                ? _color
                                : _disabledColor,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Next page button
                Visibility(
                  visible: MediaQuery.of(context).size.width > 360.0,
                  child: ToolbarItem(
                    height: 40, // height of next page button
                    width: 40, // width of next page button
                    child: Material(
                      color: Colors.transparent,
                      child: Tooltip(
                        message: widget.showTooltip
                            ? widget.model?.locale!.languageCode == 'ar'
                                  ? 'الصفحة التالية'
                                  : 'Next page'
                            : null,
                        child: RawMaterialButton(
                          shape: _useMaterial3
                              ? const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                )
                              : const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(2),
                                  ),
                                ),
                          onPressed: canJumpToNextPage
                              ? () {
                                  widget.onTap?.call('Next page');
                                  widget.controller?.nextPage();
                                }
                              : null,
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: canJumpToNextPage ? _color : _disabledColor,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Bookmark button
                ToolbarItem(
                  height: 40, // height of bookmark button
                  width: 40, // width of bookmark button
                  child: Material(
                    color: Colors.transparent,
                    child: Tooltip(
                      message: widget.showTooltip
                          ? widget.model?.locale!.languageCode == 'ar'
                                ? 'إشارة مرجعية'
                                : 'Bookmarks'
                          : null,
                      child: RawMaterialButton(
                        shape: _useMaterial3
                            ? const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4),
                                ),
                              )
                            : const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(2),
                                ),
                              ),
                        onPressed: widget.controller!.pageNumber == 0
                            ? null
                            : () {
                                _textEditingController!.selection =
                                    const TextSelection(
                                      baseOffset: -1,
                                      extentOffset: -1,
                                    );
                                widget.onTap?.call('Bookmarks');
                              },
                        child: Icon(
                          Icons.bookmark,
                          color: widget.controller!.pageNumber == 0
                              ? Colors.black12
                              : _color,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
                // Search button
                ToolbarItem(
                  height: 40, // height of search button
                  width: 40, // width of search button
                  child: Material(
                    color: Colors.transparent,
                    child: Tooltip(
                      message: widget.showTooltip
                          ? widget.model?.locale!.languageCode == 'ar'
                                ? 'بحث'
                                : 'Search'
                          : null,
                      child: RawMaterialButton(
                        shape: _useMaterial3
                            ? const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4),
                                ),
                              )
                            : const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(2),
                                ),
                              ),
                        onPressed: widget.controller!.pageNumber == 0
                            ? null
                            : () {
                                widget.controller!.clearSelection();
                                widget.onTap?.call('Search');
                              },
                        child: Icon(
                          Icons.search,
                          color: widget.controller!.pageNumber == 0
                              ? Colors.black12
                              : _color,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}

/// Displays the error message.
void _showErrorDialog(BuildContext context, SampleModel? model) {
  final String error = model?.locale?.languageCode == 'ar' ? 'خطأ' : 'Error';
  final String description = model?.locale?.languageCode == 'ar'
      ? 'الرجاء إدخال رقم صفحة صحيح.'
      : 'Please enter a valid page number.';
  final String okLabel = model?.locale?.languageCode == 'ar' ? 'حسنًا' : 'OK';
  final bool useMaterial3 = Theme.of(context).useMaterial3;

  showDialog<dynamic>(
    context: context,
    builder: (BuildContext context) {
      return Directionality(
        textDirection: model!.textDirection,
        child: AlertDialog(
          insetPadding: EdgeInsets.zero,
          title: _errorDialogTitle(context, error, useMaterial3),
          content: SizedBox(width: 328.0, child: Text(description)),
          actions: <Widget>[_errorDialogButton(context, okLabel, useMaterial3)],
          actionsPadding: useMaterial3
              ? null
              : const EdgeInsets.only(bottom: 10),
        ),
      );
    },
  );
}

/// Displays the error message for the error dialog.
Row _errorDialogTitle(BuildContext context, String error, bool useMaterial3) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text(error),
      SizedBox(
        height: 36, // height of close search menu button
        width: 36, // width of close search menu button
        child: RawMaterialButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          shape: useMaterial3
              ? const CircleBorder()
              : const RoundedRectangleBorder(),
          child: const Icon(Icons.clear, size: 20),
        ),
      ),
    ],
  );
}

/// Actions for the error dialog.
TextButton _errorDialogButton(
  BuildContext context,
  String okLabel,
  bool useMaterial3,
) {
  return TextButton(
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop();
    },
    style: useMaterial3
        ? TextButton.styleFrom(
            fixedSize: const Size(double.infinity, 40),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          )
        : null,
    child: Text(okLabel),
  );
}
