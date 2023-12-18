import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Core theme import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

/// PDF Viewer import
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../model/model.dart';
import '../../model/sample_view.dart';
import './shared/mobile_helper.dart'
    if (dart.library.html) './shared/web_helper.dart' as helper;
import 'shared/helper.dart';
import 'shared/toolbar_widgets.dart';

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
  bool _canShowToolbar = true;
  bool _canShowBottomToolbar = false;
  bool _canShowScrollHead = true;
  OverlayEntry? _selectionOverlayEntry;
  Color? _contextMenuColor;
  OverlayEntry? _textSearchOverlayEntry;
  OverlayEntry? _chooseFileOverlayEntry;
  OverlayEntry? _zoomPercentageOverlay;
  OverlayEntry? _settingsOverlayEntry;
  OverlayEntry? _textMarkupOverlayEntry;
  OverlayEntry? _colorPaletteOverlayEntry;
  LocalHistoryEntry? _historyEntry;
  bool _needToMaximize = false;
  bool _isVerticalModeSelected = true;
  bool _isContinuousModeClicked = true;
  String? _documentPath;
  PdfInteractionMode _interactionMode = PdfInteractionMode.selection;
  PdfPageLayoutMode _pageLayoutMode = PdfPageLayoutMode.continuous;
  PdfScrollDirection _scrollDirection = PdfScrollDirection.vertical;
  final FocusNode _focusNode = FocusNode()..requestFocus();
  final GlobalKey<ToolbarState> _toolbarKey = GlobalKey();
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final PdfViewerController _pdfViewerController = PdfViewerController();
  final GlobalKey<SearchToolbarState> _textSearchKey = GlobalKey();
  final GlobalKey<TextSearchOverlayState> _textSearchOverlayKey = GlobalKey();
  late bool _isLight;
  late bool _isDesktopWeb;
  final double _kSearchOverlayWidth = 412;
  final double _kTextMarkupMenuWidth = 161.0;
  final double _kTextMarkupMenuHeight = 176.0;
  final double _kTextMarkupMenuItemHeight = 40.0;
  final double _kColorPaletteWidth = 316.0;
  final double _kColorPaletteHeight = 312.0;

  Color? _fillColor;
  Orientation? _deviceOrientation;
  final TextEditingController _textFieldController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _passwordDialogFocusNode = FocusNode();
  bool _passwordVisible = true;
  String? password;
  bool _hasPasswordDialog = false;
  String _errorText = '';

  final UndoHistoryController _undoHistoryController = UndoHistoryController();
  Annotation? _selectedAnnotation;
  Color? _selectedColor;
  double _opacity = 1;

  @override
  void initState() {
    super.initState();
    _documentPath = 'assets/pdf/gis_succinctly.pdf';
    _isDesktopWeb = isDesktop &&
        model.isMobileResolution != null &&
        !model.isMobileResolution;
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
    _isLight = model.themeData.colorScheme.brightness == Brightness.light;
    _contextMenuColor =
        _isLight ? const Color(0xFFFFFFFF) : const Color(0xFF424242);
    if (_needToMaximize != model.needToMaximize) {
      _closeOverlays();
      _needToMaximize = model.needToMaximize;
    }
    _isDesktopWeb = isDesktop &&
        model.isMobileResolution != null &&
        !model.isMobileResolution;
    _fillColor = _isLight ? const Color(0xFFE5E5E5) : const Color(0xFF525252);
  }

  /// Show the customized password dialog for mobile
  Future<void> _showPasswordDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        final Orientation orientation = model.isMobile
            ? MediaQuery.of(context).orientation
            : Orientation.portrait;
        return AlertDialog(
          scrollable: true,
          insetPadding: EdgeInsets.zero,
          contentPadding: orientation == Orientation.portrait
              ? const EdgeInsets.all(24)
              : const EdgeInsets.only(right: 24, left: 24),
          buttonPadding: orientation == Orientation.portrait
              ? const EdgeInsets.all(8)
              : const EdgeInsets.all(4),
          backgroundColor:
              Theme.of(context).colorScheme.brightness == Brightness.light
                  ? Colors.white
                  : const Color(0xFF424242),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Password required',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.87),
                ),
              ),
              SizedBox(
                height: 36,
                width: 36,
                child: RawMaterialButton(
                  onPressed: () {
                    Navigator.pop(context, 'Cancel');
                    _hasPasswordDialog = false;
                    _passwordDialogFocusNode.unfocus();
                    _textFieldController.clear();
                  },
                  child: Icon(
                    Icons.clear,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0))),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: SizedBox(
                width: 328,
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                        child: Text(
                          'The document is password protected.Please enter a password',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.6),
                          ),
                        ),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        obscureText: _passwordVisible,
                        obscuringCharacter: '*',
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: model.backgroundColor,
                          )),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: model.backgroundColor,
                          )),
                          hintText: 'Password: syncfusion',
                          hintStyle: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.6),
                          ),
                          labelText: 'Enter password',
                          labelStyle: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.87),
                          ),
                          errorStyle: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          suffixIcon: IconButton(
                              icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.6)),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              }),
                        ),
                        enableInteractiveSelection: false,
                        controller: _textFieldController,
                        autofocus: true,
                        focusNode: _passwordDialogFocusNode,
                        onFieldSubmitted: (String value) {
                          _handlePasswordValidation(value);
                        },
                        // ignore: missing_return
                        validator: (String? value) {
                          if (_errorText.isNotEmpty) {
                            return _errorText;
                          }
                          return null;
                        },
                        onChanged: (String value) {
                          _formKey.currentState?.validate();
                          _errorText = '';
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'Cancel');
                _hasPasswordDialog = false;
                _passwordDialogFocusNode.unfocus();
                _textFieldController.clear();
              },
              child: Text(
                'CANCEL',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: model.backgroundColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
              child: TextButton(
                onPressed: () {
                  _handlePasswordValidation(_textFieldController.text);
                },
                child: Text(
                  'OPEN',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: model.backgroundColor,
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  /// Validates the password entered in text field.
  void _handlePasswordValidation(String value) {
    setState(() {
      password = value;
      _passwordDialogFocusNode.requestFocus();
    });
  }

  /// Show the customized password dialog box for web.
  Widget _showWebPasswordDialogue() {
    return Visibility(
      visible: _hasPasswordDialog,
      child: Center(
        child: Container(
          height: 200,
          width: 500,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color:
                  (Theme.of(context).colorScheme.brightness == Brightness.light)
                      ? Colors.white
                      : const Color(0xFF424242)),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 17, 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Password required',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.87),
                      ),
                    ),
                    SizedBox(
                      height: 36,
                      width: 36,
                      child: RawMaterialButton(
                        onPressed: () {
                          setState(() {
                            _hasPasswordDialog = false;
                            _passwordDialogFocusNode.unfocus();
                            _textFieldController.clear();
                          });
                        },
                        child: Icon(
                          Icons.clear,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: Text(
                  'The document is password protected.Please enter a password',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
                ),
              ),
              SizedBox(
                width: 460,
                height: 65,
                child: TextFormField(
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.87),
                  ),
                  obscureText: _passwordVisible,
                  obscuringCharacter: '*',
                  decoration: InputDecoration(
                    isDense: true,
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(
                      color: model.backgroundColor,
                    )),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                      color: model.backgroundColor,
                    )),
                    contentPadding: const EdgeInsets.fromLTRB(0, 18, 0, 0),
                    hintText: 'Password: syncfusion',
                    errorText: _errorText.isNotEmpty ? _errorText : null,
                    hintStyle: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                    ),
                    errorStyle: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                          size: 24,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        }),
                  ),
                  enableInteractiveSelection: false,
                  controller: _textFieldController,
                  autofocus: true,
                  focusNode: _passwordDialogFocusNode,
                  textInputAction: TextInputAction.none,
                  onFieldSubmitted: (String value) {
                    _handlePasswordValidation(value);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 18, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _hasPasswordDialog = false;
                          _passwordDialogFocusNode.unfocus();
                          _textFieldController.clear();
                        });
                      },
                      child: Text(
                        'CANCEL',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: model.backgroundColor,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _handlePasswordValidation(_textFieldController.text);
                      },
                      child: Text(
                        'OPEN',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: model.backgroundColor,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
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
    _handleSettingsMenuClose();
    _handleTextMarkupOverlayClose();
    _handleColorPaletteOverlayClose();
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

  /// Drop down overlay for choose file and zoom percentage.
  OverlayEntry? _showDropDownOverlay(
      RenderBox toolbarItemRenderBox,
      OverlayEntry? overlayEntry,
      BoxConstraints constraints,
      Widget dropDownItems,
      [Offset? positionOverride]) {
    OverlayState? overlayState;
    const List<BoxShadow> boxShadows = <BoxShadow>[
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.26),
        blurRadius: 8,
        offset: Offset(0, 3),
      ),
    ];
    if (toolbarItemRenderBox != null) {
      final Offset position =
          positionOverride ?? toolbarItemRenderBox.localToGlobal(Offset.zero);
      overlayState = Overlay.of(context, rootOverlay: true);
      overlayEntry = OverlayEntry(
        builder: (BuildContext context) => Positioned(
          top: position.dy + 40.0, // y position of zoom percentage menu
          left: _settingsOverlayEntry != null
              ? position.dx - 151.0
              : position.dx, // x position of zoom percentage menu
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
    }
    overlayState?.insert(overlayEntry!);
    return overlayEntry;
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
        final OverlayState overlayState =
            Overlay.of(context, rootOverlay: true);
        overlayState.insert(_textSearchOverlayEntry = OverlayEntry(
          builder: (BuildContext context) {
            return Positioned(
              top: position.dy + 40.0, // y position of search menu
              left: (MediaQuery.of(context).size.width - 8) -
                  _kSearchOverlayWidth, // x position of search menu
              child: TextSearchOverlay(
                key: _textSearchOverlayKey,
                controller: _pdfViewerController,
                textSearchOverlayEntry: _textSearchOverlayEntry,
                onClose: _handleSearchMenuClose,
                brightness: model.themeData.colorScheme.brightness,
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
              'Rotated Document', 'assets/pdf/rotated_document.pdf'),
          _chooseFileEntry(
              'Single Page Document', 'assets/pdf/single_page_document.pdf'),
          _chooseFileEntry(
              'Encrypted Document', 'assets/pdf/encrypted_document.pdf'),
          _chooseFileEntry(
              'Corrupted Document', 'assets/pdf/corrupted_document.pdf'),
        ],
      );
      _chooseFileOverlayEntry = _showDropDownOverlay(
          chooseFileRenderBox,
          _chooseFileOverlayEntry,
          BoxConstraints.tightFor(
              width: 202, height: child.children.length * 35.0),
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

  /// Get choose file entry to change pdf for web platform.
  Widget _chooseFileEntry(String fileName, String path) {
    return SizedBox(
      height: 32, // height of each file list
      width: 202, // width of each file list
      child: RawMaterialButton(
        onPressed: () {
          _handleChooseFileClose();
          setState(() {
            _documentPath = path;
            _passwordVisible = true;
            password = null;
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
    return SizedBox(
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

  /// Shows the page layout mode and scroll direction options
  void _showSettingsMenu(BuildContext context) {
    _toolbarKey.currentState?._changeToolbarItemFillColor('Settings', true);
    final RenderBox settingsRenderBox = (_toolbarKey
        .currentState?._settingsKey.currentContext
        ?.findRenderObject())! as RenderBox;
    double landscapeHeight = 180.0;
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      final Offset position = settingsRenderBox.localToGlobal(Offset.zero);
      landscapeHeight =
          MediaQuery.of(context).size.height - (position.dy + 40.0);
      if (landscapeHeight > 191.0) {
        landscapeHeight = 191.0;
      }
    }
    final double totalHeight =
        MediaQuery.of(context).orientation == Orientation.landscape
            ? landscapeHeight
            : 191.0;
    if (settingsRenderBox != null) {
      _settingsOverlayEntry = _showDropDownOverlay(
          settingsRenderBox,
          _settingsOverlayEntry,
          BoxConstraints.tightFor(width: 191.0, height: totalHeight),
          SingleChildScrollView(
            child: SizedBox(
              height: 191.0,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: _settingsDropDownItem(
                        'images/pdf_viewer/continuous_page.png',
                        'Continuous Page',
                        _isContinuousModeClicked, () {
                      setState(() {
                        _isContinuousModeClicked = true;
                        if (_pageLayoutMode != PdfPageLayoutMode.continuous) {
                          _pageLayoutMode = PdfPageLayoutMode.continuous;
                          _scrollDirection = PdfScrollDirection.vertical;
                          _isVerticalModeSelected = true;
                        }
                      });
                      _handleSettingsMenuClose();
                    }),
                  ),
                  _settingsDropDownItem('images/pdf_viewer/page_by_page.png',
                      'Page by page', !_isContinuousModeClicked, () {
                    setState(() {
                      _isContinuousModeClicked = false;
                      if (_pageLayoutMode != PdfPageLayoutMode.single) {
                        _pageLayoutMode = PdfPageLayoutMode.single;
                        _scrollDirection = PdfScrollDirection.horizontal;
                        _isVerticalModeSelected = false;
                      }
                    });
                    _handleSettingsMenuClose();
                  }),
                  Divider(
                    color: _isLight
                        ? Colors.black.withOpacity(0.24)
                        : const Color.fromRGBO(255, 255, 255, 0.26),
                  ),
                  Column(
                    children: <Widget>[
                      _settingsDropDownItem(
                          'images/pdf_viewer/vertical_scrolling.png',
                          'Vertical scrolling',
                          _isVerticalModeSelected, () {
                        setState(() {
                          _isVerticalModeSelected = true;
                          _scrollDirection = PdfScrollDirection.vertical;
                        });
                        _handleSettingsMenuClose();
                      }),
                      _settingsDropDownItem(
                          'images/pdf_viewer/horizontal_scrolling.png',
                          'Horizontal scrolling',
                          !_isVerticalModeSelected, () {
                        setState(() {
                          _isVerticalModeSelected = false;
                          _scrollDirection = PdfScrollDirection.horizontal;
                        });
                        _handleSettingsMenuClose();
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ));
    }
  }

  /// Close settings overlay
  void _handleSettingsMenuClose() {
    _toolbarKey.currentState?._changeToolbarItemFillColor('Settings', false);
    if (_settingsOverlayEntry != null) {
      _settingsOverlayEntry?.remove();
      _settingsOverlayEntry = null;
    }
  }

  /// Settings drop down items for both mobile and desktop.
  Widget _settingsDropDownItem(String imagePath, String mode,
      bool canShowFillColor, Function() onPressed) {
    return SizedBox(
      height: 40.0, // height of each Option
      width: 191.0, // width of each Option
      child: RawMaterialButton(
        elevation: 0.0,
        hoverElevation: 0.0,
        highlightElevation: 0.0,
        onPressed: onPressed,
        fillColor: canShowFillColor ? _fillColor : null,
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 19),
              child: ImageIcon(
                AssetImage(
                  imagePath,
                ),
                size: 24,
                color: _isLight ? Colors.black : const Color(0xFFFFFFFF),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                mode,
                style: TextStyle(
                    color: _isLight
                        ? const Color(0x00000000).withOpacity(0.87)
                        : const Color(0x00ffffff).withOpacity(0.87),
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Shows drop down list of text markup types for desktop.
  void _showTextMarkupMenu(BuildContext context) {
    _toolbarKey.currentState?._changeToolbarItemFillColor('Text markup', true);
    final RenderBox textMarkupRenderBox = (_toolbarKey
        .currentState?._textMarkupKey.currentContext
        ?.findRenderObject())! as RenderBox;
    if (textMarkupRenderBox != null) {
      final Widget child = Container(
        width: _kTextMarkupMenuWidth,
        height: _kTextMarkupMenuHeight,
        decoration: ShapeDecoration(
          color: _contextMenuColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextMarkupMenuItem(
                mode: 'Highlight',
                height: _kTextMarkupMenuItemHeight,
                width: _kTextMarkupMenuWidth,
                model: model,
                onPressed: () {
                  _pdfViewerController.annotationMode =
                      PdfAnnotationMode.highlight;
                  _toolbarKey.currentState
                      ?._changeToolbarItemVisibility('Color Palette', true);
                  _handleTextMarkupOverlayClose();
                },
              ),
              TextMarkupMenuItem(
                mode: 'Underline',
                height: _kTextMarkupMenuItemHeight,
                width: _kTextMarkupMenuWidth,
                model: model,
                onPressed: () {
                  _pdfViewerController.annotationMode =
                      PdfAnnotationMode.underline;
                  _toolbarKey.currentState
                      ?._changeToolbarItemVisibility('Color Palette', true);
                  _handleTextMarkupOverlayClose();
                },
              ),
              TextMarkupMenuItem(
                mode: 'Strikethrough',
                height: _kTextMarkupMenuItemHeight,
                width: _kTextMarkupMenuWidth,
                model: model,
                onPressed: () {
                  _pdfViewerController.annotationMode =
                      PdfAnnotationMode.strikethrough;
                  _toolbarKey.currentState
                      ?._changeToolbarItemVisibility('Color Palette', true);
                  _handleTextMarkupOverlayClose();
                },
              ),
              TextMarkupMenuItem(
                mode: 'Squiggly',
                height: _kTextMarkupMenuItemHeight,
                width: _kTextMarkupMenuWidth,
                model: model,
                onPressed: () {
                  _pdfViewerController.annotationMode =
                      PdfAnnotationMode.squiggly;
                  _toolbarKey.currentState
                      ?._changeToolbarItemVisibility('Color Palette', true);
                  _handleTextMarkupOverlayClose();
                },
              ),
            ],
          ),
        ),
      );
      _textMarkupOverlayEntry = _showDropDownOverlay(
          textMarkupRenderBox,
          _textMarkupOverlayEntry,
          BoxConstraints.tightFor(
              width: _kTextMarkupMenuWidth, height: _kTextMarkupMenuHeight),
          child);
    }
  }

  /// Close text markup menu for web platform.
  void _handleTextMarkupOverlayClose() {
    if (_textMarkupOverlayEntry != null) {
      _textMarkupOverlayEntry?.remove();
      _textMarkupOverlayEntry = null;
    }
    _toolbarKey.currentState?._changeToolbarItemFillColor('Text markup',
        _pdfViewerController.annotationMode != PdfAnnotationMode.none);
  }

  /// Shows color palette in desktop platform.
  void _showColorPaletteMenu(BuildContext context) {
    _toolbarKey.currentState
        ?._changeToolbarItemFillColor('Color Palette', true);
    final RenderBox colorPaletteRenderBox = (_toolbarKey
        .currentState?._colorPaletteKey.currentContext
        ?.findRenderObject())! as RenderBox;
    if (colorPaletteRenderBox != null) {
      final Widget child = ColorPalette(
        pdfViewerController: _pdfViewerController,
        model: model,
        selectedAnnotation: _selectedAnnotation,
        selectedColor: _selectedColor,
        selectedOpacity: _opacity,
        onColorChanged: (Color color) {
          _selectedColor = color;
        },
      );
      final Offset position = colorPaletteRenderBox.localToGlobal(
          Offset(-(_kColorPaletteWidth - colorPaletteRenderBox.size.width), 0));
      _colorPaletteOverlayEntry = _showDropDownOverlay(
        colorPaletteRenderBox,
        _colorPaletteOverlayEntry,
        BoxConstraints.tightFor(
            width: _kColorPaletteWidth, height: _kColorPaletteHeight),
        child,
        position,
      );
    }
  }

  /// Close color palette menu for web platform.
  void _handleColorPaletteOverlayClose() {
    if (_colorPaletteOverlayEntry != null) {
      _colorPaletteOverlayEntry?.remove();
      _colorPaletteOverlayEntry = null;
    }
    _toolbarKey.currentState
        ?._changeToolbarItemFillColor('Color Palette', false);
  }

  @override
  Widget build(BuildContext context) {
    if (isDesktop) {
      final bool? isDrawerOpened = model.webOutputContainerState.widget
          .webLayoutPageState?.scaffoldKey.currentState?.isEndDrawerOpen;
      if (isDrawerOpened != null && isDrawerOpened) {
        _closeOverlays();
      }
    }
    if (model.isMobile) {
      if (_deviceOrientation != MediaQuery.of(context).orientation) {
        if (_settingsOverlayEntry != null) {
          _handleSettingsMenuClose();
          Future<dynamic>.delayed(Duration.zero, () async {
            _showSettingsMenu(context);
          });
        }
        _deviceOrientation = MediaQuery.of(context).orientation;
      }
    }
    PreferredSizeWidget appBar = AppBar(
      flexibleSpace: Semantics(
        label: 'Custom toolbar',
        child: RawKeyboardListener(
          focusNode: _focusNode,
          onKey: (RawKeyEvent event) {
            final bool isPrimaryKeyPressed =
                kIsMacOS ? event.isMetaPressed : event.isControlPressed;
            if (isPrimaryKeyPressed &&
                event.logicalKey == LogicalKeyboardKey.keyF) {
              _pdfViewerController.clearSelection();
              _showTextSearchMenu();
            }
          },
          child: Toolbar(
            key: _toolbarKey,
            controller: _pdfViewerController,
            undoHistoryController: _undoHistoryController,
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
                    _hasPasswordDialog = false;
                    _passwordVisible = true;
                    password = null;
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

                if (toolbarItem == 'Undo') {
                  _undoHistoryController.undo();
                  if (_selectedAnnotation != null) {
                    _toolbarKey.currentState
                        ?._setAnnotationLocked(_selectedAnnotation!.isLocked);
                  }
                } else if (toolbarItem == 'Redo') {
                  _undoHistoryController.redo();
                  if (_selectedAnnotation != null) {
                    _toolbarKey.currentState
                        ?._setAnnotationLocked(_selectedAnnotation!.isLocked);
                  }
                }

                if (toolbarItem == 'Text markup') {
                  _handleSearchMenuClose();
                  if (_textMarkupOverlayEntry == null) {
                    _showTextMarkupMenu(context);
                  } else {
                    _handleTextMarkupOverlayClose();
                  }
                } else if (toolbarItem != 'Text markup') {
                  _handleTextMarkupOverlayClose();
                }

                if (toolbarItem == 'None') {
                  _pdfViewerController.annotationMode = PdfAnnotationMode.none;
                  _toolbarKey.currentState
                      ?._changeToolbarItemVisibility('Color Palette', false);
                  _handleTextMarkupOverlayClose();
                }

                if (toolbarItem == 'Delete') {
                  if (_selectedAnnotation != null) {
                    _pdfViewerController.removeAnnotation(_selectedAnnotation!);
                  }
                }

                if (toolbarItem == 'Color Palette') {
                  _handleSearchMenuClose();
                  if (_colorPaletteOverlayEntry == null) {
                    if (_selectedAnnotation == null ||
                        _selectedAnnotation != null &&
                            !_selectedAnnotation!.isLocked) {
                      _showColorPaletteMenu(context);
                    }
                  } else {
                    _handleColorPaletteOverlayClose();
                  }
                } else if (toolbarItem != 'Color Palette') {
                  _handleColorPaletteOverlayClose();
                }

                if (toolbarItem == 'Lock') {
                  if (_selectedAnnotation != null) {
                    _selectedAnnotation!.isLocked =
                        !_selectedAnnotation!.isLocked;
                    _toolbarKey.currentState
                        ?._setAnnotationLocked(_selectedAnnotation!.isLocked);
                  }
                }
              } else {
                if (_pdfViewerKey.currentState!.isBookmarkViewOpen) {
                  Navigator.pop(context);
                }
                if (toolbarItem is Document) {
                  setState(() {
                    _documentPath = toolbarItem.path;
                    _hasPasswordDialog = false;
                    _passwordVisible = true;
                    _textFieldController.clear();
                    password = null;
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
                if (toolbarItem == 'Text markup') {
                  setState(() {
                    _canShowBottomToolbar = !_canShowBottomToolbar;
                  });
                  _toolbarKey.currentState?._changeToolbarItemFillColor(
                      'Text markup', _canShowBottomToolbar);

                  if (_pdfViewerController.annotationMode !=
                      PdfAnnotationMode.none) {
                    _pdfViewerController.annotationMode =
                        PdfAnnotationMode.none;
                    _toolbarKey.currentState
                        ?._changeToolbarItemVisibility('Color Palette', false);
                    _handleTextMarkupOverlayClose();
                  }
                }
              }
              if (toolbarItem.toString() == 'View settings') {
                if (_settingsOverlayEntry == null) {
                  _showSettingsMenu(context);
                } else {
                  _handleSettingsMenuClose();
                }
              }
              if (toolbarItem.toString() != 'View settings') {
                _handleSettingsMenuClose();
              }
              if (toolbarItem.toString() != 'Bookmarks') {
                _handleContextMenuClose();
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
      backgroundColor:
          SfPdfViewerTheme.of(context)!.bookmarkViewStyle?.headerBarColor ??
              ((Theme.of(context).colorScheme.brightness == Brightness.light)
                  ? const Color(0xFFFAFAFA)
                  : const Color(0xFF424242)),
    );
    if (!_isDesktopWeb) {
      appBar = _canShowToolbar
          ? appBar
          : !_pdfViewerKey.currentState!.isBookmarkViewOpen
              ? AppBar(
                  flexibleSpace: Column(
                    children: [
                      Expanded(
                        child: SearchToolbar(
                          key: _textSearchKey,
                          controller: _pdfViewerController,
                          brightness: model.themeData.colorScheme.brightness,
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
                            if (toolbarItem.toString() == 'Search Completed') {
                              setState(() {});
                            }
                            if (toolbarItem.toString() == 'noResultFound') {
                              setState(() {
                                _textSearchKey.currentState?.canShowToast =
                                    true;
                              });
                              await Future<dynamic>.delayed(
                                  const Duration(seconds: 1));
                              setState(() {
                                _textSearchKey.currentState?.canShowToast =
                                    false;
                              });
                            }
                          },
                        ),
                      ),
                      // Progress bar to indicate whether search process is completed or not.
                      Visibility(
                        visible: _textSearchKey.currentState != null &&
                            !_textSearchKey.currentState!.pdfTextSearchResult
                                .isSearchCompleted &&
                            _textSearchKey.currentState!.isSearchInitiated,
                        child: LinearProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                  automaticallyImplyLeading: false,
                  backgroundColor: SfPdfViewerTheme.of(context)!
                          .bookmarkViewStyle
                          ?.headerBarColor ??
                      ((Theme.of(context).colorScheme.brightness ==
                              Brightness.light)
                          ? const Color(0xFFFAFAFA)
                          : const Color(0xFF424242)),
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
          final Widget pdfViewer = Listener(
            onPointerDown: (PointerDownEvent details) {
              if (_isDesktopWeb) {
                _handleChooseFileClose();
                _handleZoomPercentageClose();
                _handleTextMarkupOverlayClose();
                _handleColorPaletteOverlayClose();
              }
              _handleSettingsMenuClose();
              _textSearchKey.currentState?.focusNode!.unfocus();
              _focusNode.unfocus();
            },
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: !_isDesktopWeb && _canShowBottomToolbar ? 56 : 0,
                  child: SfPdfViewer.asset(
                    _documentPath!,
                    key: _pdfViewerKey,
                    controller: _pdfViewerController,
                    undoController: _undoHistoryController,
                    interactionMode: _interactionMode,
                    scrollDirection: _scrollDirection,
                    pageLayoutMode: _pageLayoutMode,
                    password: password,
                    canShowPasswordDialog: false,
                    canShowScrollHead:
                        // ignore: avoid_bool_literals_in_conditional_expressions
                        isDesktop ? false : _canShowScrollHead,
                    onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                      if (_hasPasswordDialog) {
                        if (model.isMobile) {
                          Navigator.pop(context);
                        }
                        _hasPasswordDialog = false;
                        _passwordDialogFocusNode.unfocus();
                        _textFieldController.clear();
                      }
                    },
                    onDocumentLoadFailed:
                        (PdfDocumentLoadFailedDetails details) {
                      if (details.description.contains('password')) {
                        if (details.description.contains('password') &&
                            _hasPasswordDialog) {
                          _errorText = 'Invalid password';
                          _formKey.currentState?.validate();
                          _textFieldController.clear();
                          _passwordDialogFocusNode.requestFocus();
                        } else {
                          _errorText = '';
                          if (model.isMobile) {
                            _showPasswordDialog();
                            _passwordDialogFocusNode.requestFocus();
                            _hasPasswordDialog = true;
                          } else {
                            setState(() {
                              _hasPasswordDialog = true;
                              if (!_passwordDialogFocusNode.hasFocus) {
                                _passwordDialogFocusNode.requestFocus();
                              }
                            });
                          }
                        }
                      } else {
                        showErrorDialog(
                            context, details.error, details.description);
                      }
                    },
                    onAnnotationEdited: (Annotation annotation) {
                      _selectedColor = annotation.color;
                      _opacity = annotation.opacity;
                    },
                    onAnnotationSelected: (Annotation annotation) {
                      _selectedAnnotation = annotation;
                      _selectedColor = annotation.color;
                      _opacity = annotation.opacity;
                      _pdfViewerController.annotationMode =
                          PdfAnnotationMode.none;
                      if (_isDesktopWeb) {
                        _toolbarKey.currentState
                            ?._changeToolbarItemFillColor('Text Markup', false);
                        _toolbarKey.currentState
                            ?._setAnnotationLocked(annotation.isLocked);
                        _toolbarKey.currentState
                            ?._changeToolbarItemVisibility('Lock', true);
                        _toolbarKey.currentState
                            ?._changeToolbarItemVisibility('Delete', true);
                        _toolbarKey.currentState?._changeToolbarItemVisibility(
                            'Color Palette', true);
                      } else {
                        setState(() {
                          _canShowBottomToolbar = true;
                        });
                      }
                    },
                    onAnnotationDeselected: (Annotation annotation) {
                      _selectedAnnotation = null;
                      _selectedColor = null;
                      if (_isDesktopWeb) {
                        _toolbarKey.currentState
                            ?._changeToolbarItemVisibility('Lock', false);
                        _toolbarKey.currentState
                            ?._changeToolbarItemVisibility('Delete', false);
                        _toolbarKey.currentState?._changeToolbarItemVisibility(
                            'Color Palette', false);
                      } else {
                        setState(() {
                          _canShowBottomToolbar = false;
                        });
                      }
                    },
                  ),
                ),
                if (!_isDesktopWeb && _canShowBottomToolbar)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: BottomToolbar(
                      pdfViewerController: _pdfViewerController,
                      undoController: _undoHistoryController,
                      model: model,
                      selectedAnnotation: _selectedAnnotation,
                      onBackButtonPressed: () {
                        if (_selectedAnnotation != null) {
                          _pdfViewerController
                              .deselectAnnotation(_selectedAnnotation!);
                        }
                      },
                    ),
                  ),
              ],
            ),
          );
          if (_canShowPdf) {
            if (_isDesktopWeb) {
              return Stack(children: <Widget>[
                RawKeyboardListener(
                  focusNode: _focusNode,
                  onKey: (RawKeyEvent event) {
                    final bool isPrimaryKeyPressed =
                        kIsMacOS ? event.isMetaPressed : event.isControlPressed;
                    if (isPrimaryKeyPressed &&
                        event.logicalKey == LogicalKeyboardKey.keyF) {
                      _showTextSearchMenu();
                    }
                  },
                  child: pdfViewer,
                ),
                _showWebPasswordDialogue(),
              ]);
            }
            return SfPdfViewerTheme(
              data: SfPdfViewerThemeData(
                  brightness: model.themeData.colorScheme.brightness),
              child: PopScope(
                onPopInvoked: (bool value) {
                  setState(() {
                    _canShowToolbar = true;
                  });
                },
                child: Stack(children: <Widget>[
                  pdfViewer,
                  showToast(_textSearchKey.currentState?.canShowToast ?? false,
                      Alignment.center, 'No result'),
                ]),
              ),
            );
          } else {
            return Container(
              color: SfPdfViewerTheme.of(context)!.backgroundColor ??
                  Theme.of(context).colorScheme.surface.withOpacity(0.08),
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
    this.undoHistoryController,
    this.onTap,
    this.showTooltip = true,
    this.model,
    Key? key,
  }) : super(key: key);

  /// Indicates whether tooltip for the toolbar items need to be shown or not..
  final bool showTooltip;

  /// An object that is used to control the [SfPdfViewer].
  final PdfViewerController? controller;

  /// An object that is used to control the Undo History of the SfPdfViewer.
  final UndoHistoryController? undoHistoryController;

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
  Color? _settingsFillColor;
  Color _textMarkupFillColor = Colors.transparent;
  Color? _colorPaletteFillColor;
  int _pageCount = 0;
  late bool _isLight;
  double _zoomLevel = 1;
  final GlobalKey _searchKey = GlobalKey();
  final GlobalKey _chooseFileKey = GlobalKey();
  final GlobalKey _zoomPercentageKey = GlobalKey();
  final GlobalKey _settingsKey = GlobalKey();
  final GlobalKey _textMarkupKey = GlobalKey();
  final GlobalKey _colorPaletteKey = GlobalKey();
  final FocusNode _focusNode = FocusNode();
  bool _isWeb = false;

  bool _canShowColorPaletteIcon = false;
  bool _canShowDeleteIcon = false;
  bool _canShowLockIcon = false;
  bool _isAnnotationLocked = false;

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
    if (super.mounted) {
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
          _textEditingController!.text =
              widget.controller!.pageNumber.toString();
          setState(() {});
        });
      }
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
        isDesktop && widget.model != null && !widget.model!.isMobileResolution;
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
      } else if (toolbarItem == 'Settings') {
        _settingsFillColor = isFocused ? _fillColor : null;
      } else if (toolbarItem == 'Text markup') {
        _textMarkupFillColor = isFocused ? _fillColor! : Colors.transparent;
      } else if (toolbarItem == 'Color Palette') {
        _colorPaletteFillColor = isFocused ? _fillColor : null;
      }
    });
  }

  /// Sets the locked status of the selected annotation.
  void _setAnnotationLocked(bool isLocked) {
    setState(() {
      _isAnnotationLocked = isLocked;
    });
  }

  /// Changes the visibility of the toolbar items.
  void _changeToolbarItemVisibility(String toolbarItem, bool isVisible) {
    setState(() {
      if (toolbarItem == 'Color Palette') {
        _canShowColorPaletteIcon = isVisible;
      } else if (toolbarItem == 'Delete') {
        _canShowDeleteIcon = isVisible;
      } else if (toolbarItem == 'Lock') {
        _canShowLockIcon = isVisible;
      }
    });
  }

  /// Constructs web toolbar item widget
  Widget _webToolbarItem(String toolTip, Widget child, {Key? key}) {
    return Padding(
        padding: toolTip == 'Bookmark' ||
                toolTip == 'Search' ||
                toolTip == 'View settings' ||
                toolTip == 'Lock' ||
                toolTip == 'Unlock'
            ? const EdgeInsets.only(right: 8)
            : const EdgeInsets.only(left: 8),
        child: Tooltip(
            message: toolTip,
            child: SizedBox(
                key: key,
                height: 36,
                width: toolTip == 'Choose file' || toolTip == 'Text markup'
                    ? 50
                    : 36,
                child: child)));
  }

  /// Constructs the toolbar divider
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
    return SizedBox(
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
                _groupDivider(true),
                _webToolbarItem(
                  'Undo',
                  ValueListenableBuilder<UndoHistoryValue>(
                    valueListenable: widget.undoHistoryController!,
                    builder: (BuildContext context, UndoHistoryValue value,
                        Widget? child) {
                      return RawMaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                        onPressed: value.canUndo
                            ? () {
                                widget.onTap?.call('Undo');
                              }
                            : null,
                        child: Icon(
                          Icons.undo,
                          color: value.canUndo ? _color : _disabledColor,
                          size: 20,
                        ),
                      );
                    },
                  ),
                ),
                _webToolbarItem(
                  'Redo',
                  ValueListenableBuilder<UndoHistoryValue>(
                    valueListenable: widget.undoHistoryController!,
                    builder: (BuildContext context, UndoHistoryValue value,
                        Widget? child) {
                      return RawMaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                        onPressed: value.canRedo
                            ? () {
                                widget.onTap?.call('Redo');
                              }
                            : null,
                        child: Icon(
                          Icons.redo,
                          color: value.canRedo ? _color : _disabledColor,
                          size: 20,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                // Text field for page number
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: SizedBox(
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
                  child: SizedBox(
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
                            padding: const EdgeInsets.only(left: 7.0),
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
                _webToolbarItem(
                  'Text markup',
                  RawMaterialButton(
                    fillColor: _textMarkupFillColor,
                    elevation: 0.0,
                    hoverElevation: 0.0,
                    focusElevation: 0.0,
                    highlightElevation: 0.0,
                    onPressed: () {
                      widget.onTap?.call('Text markup');
                    },
                    child: SplitButton(
                      height: 36,
                      width: 56,
                      onPrimaryButtonPressed: () {
                        if (widget.controller!.annotationMode !=
                            PdfAnnotationMode.none) {
                          widget.onTap?.call('None');
                        } else {
                          widget.onTap?.call('Text markup');
                        }
                      },
                      onSecondaryButtonPressed: () {
                        widget.onTap?.call('Text markup');
                      },
                      child:
                          _getAnnotationIcon(widget.controller!.annotationMode),
                    ),
                  ),
                  key: _textMarkupKey,
                ),
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
                Visibility(
                  visible: _canShowColorPaletteIcon && !_isAnnotationLocked,
                  child: _groupDivider(true),
                ),
                Visibility(
                  visible: _canShowColorPaletteIcon && !_isAnnotationLocked,
                  child: _webToolbarItem(
                    'Color Palette',
                    RawMaterialButton(
                      elevation: 0.0,
                      hoverElevation: 0.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      fillColor: _colorPaletteFillColor,
                      onPressed: () {
                        widget.onTap?.call('Color Palette');
                      },
                      child: ImageIcon(
                        const AssetImage(
                          'images/pdf_viewer/color_palette.png',
                        ),
                        size: 17,
                        color:
                            _isLight ? Colors.black : const Color(0xFFFFFFFF),
                      ),
                    ),
                    key: _colorPaletteKey,
                  ),
                ),
                Visibility(
                  visible: _canShowDeleteIcon && !_isAnnotationLocked,
                  child: _webToolbarItem(
                    'Delete',
                    RawMaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      onPressed: () {
                        widget.onTap?.call('Delete');
                      },
                      child: ImageIcon(
                        const AssetImage(
                          'images/pdf_viewer/delete.png',
                        ),
                        size: 17,
                        color:
                            _isLight ? Colors.black : const Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Visibility(
                  visible: _canShowLockIcon,
                  child: _webToolbarItem(
                    _isAnnotationLocked ? 'Unlock' : 'Lock',
                    RawMaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      onPressed: () {
                        widget.onTap?.call('Lock');
                      },
                      child: ImageIcon(
                        AssetImage(_isAnnotationLocked
                            ? 'images/pdf_viewer/unlocked.png'
                            : 'images/pdf_viewer/locked.png'),
                        size: 18,
                        color:
                            _isLight ? Colors.black : const Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                ),
                // View settings button
                _webToolbarItem(
                    'View settings',
                    RawMaterialButton(
                      fillColor: _settingsFillColor,
                      elevation: 0.0,
                      hoverElevation: 0.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      onPressed: widget.controller!.pageNumber != 0
                          ? () {
                              widget.controller!.clearSelection();
                              widget.onTap?.call('View settings');
                            }
                          : null,
                      child: Icon(
                        Icons.settings,
                        color: widget.controller!.pageCount != 0
                            ? _color
                            : _disabledColor,
                        size: 20,
                      ),
                    ),
                    key: _settingsKey),
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

  /// Get the annotation icon based on the annotation mode.
  ImageIcon _getAnnotationIcon(PdfAnnotationMode mode) {
    String iconPath = '';
    double iconSize = 16;
    switch (mode) {
      case PdfAnnotationMode.none:
        iconPath = 'images/pdf_viewer/text_markup.png';
        iconSize = 14;
        break;
      case PdfAnnotationMode.highlight:
        iconPath = 'images/pdf_viewer/highlight.png';
        iconSize = 18;
        break;
      case PdfAnnotationMode.strikethrough:
        iconPath = 'images/pdf_viewer/strikethrough.png';
        iconSize = 18;
        break;
      case PdfAnnotationMode.underline:
        iconPath = 'images/pdf_viewer/underline.png';
        iconSize = 14;
        break;
      case PdfAnnotationMode.squiggly:
        iconPath = 'images/pdf_viewer/squiggly.png';
        iconSize = 18;
        break;
    }

    return ImageIcon(
      AssetImage(iconPath),
      size: iconSize,
      color: _isLight ? Colors.black : const Color(0xFFFFFFFF),
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
              fontSize: 14)
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
                : null,
        border: const UnderlineInputBorder(),
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
                        if (!mounted) {
                          return;
                        }
                        await Navigator.of(context)
                            .push<dynamic>(MaterialPageRoute<dynamic>(
                                builder: (BuildContext context) => FileExplorer(
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

              ToolbarItem(
                width: 40,
                height: 40,
                child: ValueListenableBuilder<UndoHistoryValue>(
                  valueListenable: widget.undoHistoryController!,
                  builder: (BuildContext context, UndoHistoryValue value,
                      Widget? child) {
                    return Material(
                      color: Colors.transparent,
                      child: IconButton(
                        icon: Icon(
                          Icons.undo,
                          color: value.canUndo ? _color : _disabledColor,
                          size: 20,
                        ),
                        onPressed: value.canUndo
                            ? widget.undoHistoryController!.undo
                            : null,
                        tooltip: widget.showTooltip ? 'Undo' : null,
                      ),
                    );
                  },
                ),
              ),
              ToolbarItem(
                width: 40,
                height: 40,
                child: ValueListenableBuilder<UndoHistoryValue>(
                  valueListenable: widget.undoHistoryController!,
                  builder: (BuildContext context, UndoHistoryValue value,
                      Widget? child) {
                    return Material(
                      color: Colors.transparent,
                      child: IconButton(
                        icon: Icon(
                          Icons.redo,
                          color: value.canRedo ? _color : _disabledColor,
                          size: 20,
                        ),
                        onPressed: value.canRedo
                            ? widget.undoHistoryController!.redo
                            : null,
                        tooltip: widget.showTooltip ? 'Redo' : null,
                      ),
                    );
                  },
                ),
              ),

              // Text markup button
              ToolbarItem(
                height: 40,
                width: 40,
                child: Material(
                  color: _textMarkupFillColor,
                  borderRadius: BorderRadius.circular(4.0),
                  child: IconButton(
                    icon: const ImageIcon(
                      AssetImage('images/pdf_viewer/text_markup.png'),
                      size: 16,
                    ),
                    onPressed: () {
                      widget.onTap?.call('Text markup');
                    },
                    tooltip: widget.showTooltip ? 'Text markup' : null,
                  ),
                ),
              ),
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
                  )),
              // View settings button
              ToolbarItem(
                height: 40, // height of View settings button
                width: 40,
                key: _settingsKey, // width of View settings button
                child: Material(
                  color: Colors.transparent,
                  child: IconButton(
                    icon: Icon(
                      Icons.settings,
                      color: widget.controller!.pageNumber == 0
                          ? Colors.black12
                          : _color,
                      size: 24,
                    ),
                    onPressed: widget.controller!.pageNumber == 0
                        ? null
                        : () {
                            widget.controller!.clearSelection();
                            widget.onTap?.call('View settings');
                          },
                    tooltip: widget.showTooltip ? 'View settings' : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

/// Text Selection menu item widget
class TextMarkupMenuItem extends StatefulWidget {
  /// Constructor for text selection menu item widget
  const TextMarkupMenuItem(
      {required this.mode,
      this.model,
      required this.onPressed,
      required this.height,
      required this.width,
      super.key});

  /// Indicates the text markup annotation mode.
  final String mode;

  /// Called when the menu item is selected.
  final VoidCallback onPressed;

  /// Height of the menu item.
  final double height;

  /// Width of the menu item.
  final double width;

  /// Sample model of the entire SB.
  final SampleModel? model;

  @override
  State<TextMarkupMenuItem> createState() => _TextMarkupMenuItemState();
}

class _TextMarkupMenuItemState extends State<TextMarkupMenuItem> {
  Color? _textColor;
  bool _isHovering = false;

  @override
  void didChangeDependencies() {
    _textColor = (widget.model?.themeData.brightness == Brightness.light)
        ? Colors.black.withOpacity(0.87)
        : Colors.white;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onPressed();
      },
      child: MouseRegion(
        onEnter: (PointerEnterEvent event) {
          setState(() {
            _isHovering = true;
          });
        },
        onExit: (PointerExitEvent event) {
          setState(() {
            _isHovering = false;
          });
        },
        child: Container(
          height: widget.height,
          width: widget.width,
          padding: const EdgeInsets.only(left: 16.0, top: 10.0, bottom: 10.0),
          decoration: BoxDecoration(
            color: _isHovering
                ? (widget.model?.themeData.colorScheme.brightness ==
                        Brightness.light)
                    ? Colors.grey.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.5)
                : Colors.transparent,
          ),
          child: Row(
            children: <Widget>[
              Image(
                image: AssetImage(
                    'images/pdf_viewer/${widget.mode.toLowerCase()}.png'),
                width: 16,
                height: 16,
                color: _textColor,
              ),
              const Divider(
                indent: 12,
              ),
              Text(
                widget.mode,
                style: TextStyle(
                  color: (widget.model?.themeData.colorScheme.brightness ==
                          Brightness.light)
                      ? Colors.black.withOpacity(0.87)
                      : Colors.white,
                  fontSize: 14,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.25,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
