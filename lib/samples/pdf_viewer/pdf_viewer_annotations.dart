import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Core theme import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

/// PDF Viewer import
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../model/model.dart';
import '../../model/sample_view.dart';
import '../pdf/helper/save_file_mobile.dart'
    if (dart.library.html) '../pdf/helper/save_file_web.dart';
import './shared/mobile_helper.dart'
    if (dart.library.html) './shared/web_helper.dart' as helper;
import 'shared/helper.dart';
import 'shared/toolbar_widgets.dart';

/// Signature for [Toolbar.onTap] callback.
typedef TapCallback = void Function(Object item);

/// Widget of [SfPdfViewer] with custom toolbar.
class AnnotationsPdfViewer extends SampleView {
  /// Creates a [SfPdfViewer] with custom toolbar.
  const AnnotationsPdfViewer(Key key) : super(key: key);

  @override
  _AnnotationsPdfViewerState createState() => _AnnotationsPdfViewerState();
}

/// State for [AnnotationsPdfViewer]
class _AnnotationsPdfViewerState extends SampleViewState {
  bool _canShowPdf = false;
  OverlayEntry? _colorPaletteOverlayEntry;
  bool _needToMaximize = false;
  String? _documentPath;
  final GlobalKey<AnnotationToolbarState> _toolbarKey = GlobalKey();
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final PdfViewerController _pdfViewerController = PdfViewerController();
  final UndoHistoryController _undoHistoryController = UndoHistoryController();
  late bool _isLight;
  late bool _isDesktopWeb;
  final double _kColorPaletteWidth = 316.0;
  final double _kColorPaletteHeight = 312.0;
  Annotation? _selectedAnnotation;
  Color? _selectedColor;
  double _opacity = 1;
  late bool _useMaterial3;

  @override
  void initState() {
    super.initState();
    _documentPath = 'assets/pdf/annotations.pdf';
    _isDesktopWeb = isDesktop &&
        model.isMobileResolution != null &&
        !model.isMobileResolution;
    if (_isDesktopWeb) {
      helper.preventDefaultContextMenu();
    }
    _needToMaximize = model.needToMaximize;
  }

  @override
  void dispose() {
    _closeOverlays();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _useMaterial3 = Theme.of(context).useMaterial3;
    _isLight = model.themeData.colorScheme.brightness == Brightness.light;
    if (_needToMaximize != model.needToMaximize) {
      _closeOverlays();
      _needToMaximize = model.needToMaximize;
    }
    _isDesktopWeb = isDesktop &&
        model.isMobileResolution != null &&
        !model.isMobileResolution;
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

    final PreferredSizeWidget appBar = AppBar(
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
        label: 'PdfAnnotation toolbar',
        child: AnnotationToolbar(
          key: _toolbarKey,
          pdfViewerController: _pdfViewerController,
          undoHistoryController: _undoHistoryController,
          model: model,
          onTap: (Object toolbarItem) async {
            if (_isDesktopWeb) {
              if (toolbarItem.runtimeType == PdfAnnotationMode) {
                _handleColorPaletteOverlayClose();
                if (_pdfViewerController.annotationMode == toolbarItem) {
                  _pdfViewerController.annotationMode = PdfAnnotationMode.none;
                  _toolbarKey.currentState
                      ?._changeToolbarItemVisibility('Color Palette', false);
                } else {
                  _pdfViewerController.annotationMode =
                      toolbarItem as PdfAnnotationMode;
                  _toolbarKey.currentState
                      ?._changeToolbarItemVisibility('Color Palette', true);
                }
              }

              if (toolbarItem == 'Delete') {
                if (_selectedAnnotation != null) {
                  _pdfViewerController.removeAnnotation(_selectedAnnotation!);
                }
              }

              if (toolbarItem == 'Color Palette') {
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
            }

            if (toolbarItem == 'Save') {
              final List<int> savedBytes =
                  await _pdfViewerController.saveDocument();
              _saveDocument(savedBytes,
                  'The document was saved at the location ', 'annotations.pdf');
            }

            if (toolbarItem == 'Undo' || toolbarItem == 'Redo') {
              if (_selectedAnnotation != null) {
                _toolbarKey.currentState
                    ?._setAnnotationLocked(_selectedAnnotation!.isLocked);
              }
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
    );

    return Scaffold(
      appBar: appBar,
      body: FutureBuilder(
        future: Future<dynamic>.delayed(const Duration(milliseconds: 200))
            .then((dynamic value) {
          _canShowPdf = true;
        }),
        builder: (BuildContext context, AsyncSnapshot<Object?> snapshot) {
          final Widget pdfViewer = Listener(
            onPointerDown: (PointerDownEvent details) {
              _closeOverlays();
            },
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: !_isDesktopWeb ? 56 : 0,
                  child: SfPdfViewer.asset(
                    _documentPath!,
                    key: _pdfViewerKey,
                    controller: _pdfViewerController,
                    undoController: _undoHistoryController,
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
                          _selectedAnnotation = annotation;
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
                          _selectedAnnotation = null;
                        });
                      }
                    },
                  ),
                ),
                if (!_isDesktopWeb)
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
              return pdfViewer;
            }
            return SfPdfViewerTheme(
              data: const SfPdfViewerThemeData(),
              child: pdfViewer,
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

  /// Saves the PDF document.
  Future<void> _saveDocument(
      List<int> dataBytes, String message, String fileName) async {
    if (kIsWeb) {
      await FileSaveHelper.saveAndLaunchFile(dataBytes, fileName);
    } else {
      final Directory directory = await getApplicationSupportDirectory();
      final String path = directory.path;
      final File file = File('$path/$fileName');
      await file.writeAsBytes(dataBytes);
      _showDialog(message + path + r'\' + fileName);
    }
  }

  /// Alert dialog for save.
  void _showDialog(String text) {
    showDialog<Widget>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Document saved'),
            content: SizedBox(
              width: 328.0,
              child: Scrollbar(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  child: Text(text),
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: _useMaterial3
                    ? TextButton.styleFrom(
                        fixedSize: const Size(double.infinity, 40),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                      )
                    : null,
                child: const Text('Close'),
              )
            ],
          );
        });
  }

  /// Shows the drop down menu overlay.
  OverlayEntry? _showDropDownOverlay(
      RenderBox toolbarItemRenderBox,
      OverlayEntry? overlayEntry,
      BoxConstraints constraints,
      Widget dropDownItems,
      [Offset? positionOverride,
      double? borderRadius]) {
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
          top: position.dy + 40.0,
          left: position.dx,
          child: Container(
            decoration: BoxDecoration(
              color:
                  _isLight ? const Color(0xFFFFFFFF) : const Color(0xFF424242),
              boxShadow: boxShadows,
              borderRadius: _useMaterial3
                  ? BorderRadius.all(Radius.circular(borderRadius ?? 4.0))
                  : null,
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

  /// Shows the color palette menu for web platform.
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
        12,
      );
    }
  }

  /// Close color palette overlay.
  void _handleColorPaletteOverlayClose() {
    if (_colorPaletteOverlayEntry != null) {
      _colorPaletteOverlayEntry?.remove();
      _colorPaletteOverlayEntry = null;
    }
    _toolbarKey.currentState
        ?._changeToolbarItemFillColor('Color Palette', false);
  }

  /// Close all the overlays.
  void _closeOverlays() {
    if (_isDesktopWeb) {
      _handleColorPaletteOverlayClose();
    }
  }
}

/// Toolbar widget
class AnnotationToolbar extends StatefulWidget {
  /// Constructor for [AnnotationToolbar]
  const AnnotationToolbar({
    required this.pdfViewerController,
    this.undoHistoryController,
    this.onTap,
    this.showTooltip = true,
    this.model,
    Key? key,
  }) : super(key: key);

  /// Indicates whether tooltip for the toolbar items need to be shown or not.
  final bool showTooltip;

  /// An object that is used to control the [SfPdfViewer].
  final PdfViewerController pdfViewerController;

  /// An object that is used to control the Undo History of the SfPdfViewer.
  final UndoHistoryController? undoHistoryController;

  /// Called when the toolbar item is selected.
  final TapCallback? onTap;

  /// Sample model of the entire SB.
  final SampleModel? model;

  @override
  AnnotationToolbarState createState() => AnnotationToolbarState();
}

/// State for the Toolbar widget.
class AnnotationToolbarState extends State<AnnotationToolbar> {
  Color? _color;
  Color? _fillColor;
  Color? _disabledColor;
  Color? _colorPaletteFillColor;
  late bool _isLight;
  final GlobalKey _colorPaletteKey = GlobalKey();
  bool _isWeb = false;
  bool _canShowColorPaletteIcon = false;
  bool _canShowDeleteIcon = false;
  bool _canShowLockIcon = false;
  bool _isAnnotationLocked = false;
  late bool _useMaterial3;

  @override
  void didChangeDependencies() {
    _isLight = Theme.of(context).brightness == Brightness.light;
    _useMaterial3 = Theme.of(context).useMaterial3;
    _color = _useMaterial3
        ? _isLight
            ? const Color.fromRGBO(73, 69, 79, 1)
            : const Color.fromRGBO(202, 196, 208, 1)
        : _isLight
            ? Colors.black.withOpacity(0.54)
            : Colors.white.withOpacity(0.65);
    _disabledColor = _useMaterial3
        ? _isLight
            ? const Color.fromRGBO(28, 27, 31, 1).withOpacity(0.38)
            : const Color.fromRGBO(230, 225, 229, 1).withOpacity(0.38)
        : _isLight
            ? Colors.black12
            : Colors.white12;
    _fillColor = _useMaterial3
        ? Theme.of(context).colorScheme.onSurface.withOpacity(0.08)
        : _isLight
            ? const Color(0xFFD2D2D2)
            : const Color(0xFF525252);
    _isWeb =
        isDesktop && widget.model != null && !widget.model!.isMobileResolution;
    super.didChangeDependencies();
  }

  /// Changes the drop down fill colors while drop down is opened or closed.
  void _changeToolbarItemFillColor(String toolbarItem, bool isFocused) {
    setState(() {
      if (toolbarItem == 'Color Palette') {
        _colorPaletteFillColor = isFocused ? _fillColor : null;
      }
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

  /// Sets the annotation lock status.
  void _setAnnotationLocked(bool isLocked) {
    setState(() {
      _isAnnotationLocked = isLocked;
    });
  }

  /// Constructs web toolbar item widget.
  Widget _webToolbarItem(String toolTip, Widget child, {Key? key}) {
    return Padding(
      padding: toolTip == 'Lock' ||
              toolTip == 'Unlock' ||
              toolTip == 'Delete' ||
              toolTip == 'Color Palette'
          ? const EdgeInsets.only(right: 8)
          : const EdgeInsets.only(left: 8),
      child: Tooltip(
        message: toolTip,
        decoration: _useMaterial3
            ? BoxDecoration(
                color: Theme.of(context).colorScheme.inverseSurface,
                borderRadius: BorderRadius.circular(4),
              )
            : null,
        textStyle: _useMaterial3
            ? TextStyle(
                color: Theme.of(context).colorScheme.onInverseSurface,
                fontSize: 14,
              )
            : null,
        padding: _useMaterial3
            ? const EdgeInsets.symmetric(horizontal: 16, vertical: 14)
            : null,
        height: _useMaterial3 ? 48 : null,
        child: SizedBox(
            key: key,
            height: 36,
            width: toolTip == 'Options' ? 50 : 36,
            child: child),
      ),
    );
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
        indent: _useMaterial3 ? 16 : 12.0,
        // top indent of vertical divider
        endIndent: _useMaterial3 ? 16 : 12.0,
        // bottom indent of vertical divider
        color: _useMaterial3
            ? Theme.of(context).colorScheme.outlineVariant
            : _isLight
                ? Colors.black.withOpacity(0.24)
                : const Color.fromRGBO(255, 255, 255, 0.26),
      ),
    );
  }

  /// Constructs web toolbar widget.
  Widget _webToolbar() {
    return SizedBox(
        height: 56, // height of toolbar for web
        width: 1200, // width of toolbar for web
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                _webToolbarItem(
                  'Save',
                  RawMaterialButton(
                    elevation: 0,
                    focusElevation: 0,
                    hoverElevation: 0,
                    highlightElevation: 0,
                    onPressed: () async {
                      widget.pdfViewerController.clearSelection();
                      widget.onTap?.call('Save');
                    },
                    shape: _useMaterial3
                        ? const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)))
                        : const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(2))),
                    child: Icon(
                      Icons.save,
                      color: _color,
                      size: 20,
                    ),
                  ),
                ),
                _groupDivider(true),
                _webToolbarItem(
                  'Undo',
                  ValueListenableBuilder<UndoHistoryValue>(
                    valueListenable: widget.undoHistoryController!,
                    builder: (BuildContext context, UndoHistoryValue value,
                        Widget? child) {
                      return RawMaterialButton(
                        elevation: 0,
                        focusElevation: 0,
                        hoverElevation: 0,
                        highlightElevation: 0,
                        shape: _useMaterial3
                            ? const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)))
                            : const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2))),
                        onPressed: value.canUndo
                            ? () {
                                widget.undoHistoryController!.undo();
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
                        elevation: 0,
                        focusElevation: 0,
                        hoverElevation: 0,
                        highlightElevation: 0,
                        shape: _useMaterial3
                            ? const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)))
                            : const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2))),
                        onPressed: value.canRedo
                            ? () {
                                widget.undoHistoryController!.redo();
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
                _webToolbarItem(
                  'Highlight',
                  RawMaterialButton(
                    elevation: 0,
                    focusElevation: 0,
                    hoverElevation: 0,
                    highlightElevation: 0,
                    fillColor: widget.pdfViewerController.annotationMode ==
                            PdfAnnotationMode.highlight
                        ? _fillColor
                        : null,
                    onPressed: () {
                      widget.onTap?.call(PdfAnnotationMode.highlight);
                    },
                    shape: _useMaterial3
                        ? const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)))
                        : const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(2))),
                    child: ImageIcon(
                      const AssetImage(
                        'images/pdf_viewer/highlight.png',
                      ),
                      size: 16,
                      color: _isLight ? Colors.black : const Color(0xFFFFFFFF),
                    ),
                  ),
                ),
                _webToolbarItem(
                  'Underline',
                  RawMaterialButton(
                    fillColor: widget.pdfViewerController.annotationMode ==
                            PdfAnnotationMode.underline
                        ? _fillColor
                        : null,
                    elevation: 0,
                    focusElevation: 0,
                    hoverElevation: 0,
                    highlightElevation: 0,
                    shape: _useMaterial3
                        ? const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)))
                        : const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(2))),
                    onPressed: () {
                      widget.onTap?.call(PdfAnnotationMode.underline);
                    },
                    child: ImageIcon(
                      const AssetImage(
                        'images/pdf_viewer/underline.png',
                      ),
                      size: 16,
                      color: _isLight ? Colors.black : const Color(0xFFFFFFFF),
                    ),
                  ),
                ),
                _webToolbarItem(
                  'Strikethrough',
                  RawMaterialButton(
                    fillColor: widget.pdfViewerController.annotationMode ==
                            PdfAnnotationMode.strikethrough
                        ? _fillColor
                        : null,
                    elevation: 0,
                    focusElevation: 0,
                    hoverElevation: 0,
                    highlightElevation: 0,
                    shape: _useMaterial3
                        ? const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)))
                        : const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(2))),
                    onPressed: () {
                      widget.onTap?.call(PdfAnnotationMode.strikethrough);
                    },
                    child: ImageIcon(
                      const AssetImage(
                        'images/pdf_viewer/strikethrough.png',
                      ),
                      size: 16,
                      color: _isLight ? Colors.black : const Color(0xFFFFFFFF),
                    ),
                  ),
                ),
                _webToolbarItem(
                  'Squiggly',
                  RawMaterialButton(
                    fillColor: widget.pdfViewerController.annotationMode ==
                            PdfAnnotationMode.squiggly
                        ? _fillColor
                        : null,
                    elevation: 0,
                    focusElevation: 0,
                    hoverElevation: 0,
                    highlightElevation: 0,
                    shape: _useMaterial3
                        ? const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)))
                        : const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(2))),
                    onPressed: () {
                      widget.onTap?.call(PdfAnnotationMode.squiggly);
                    },
                    child: ImageIcon(
                      const AssetImage(
                        'images/pdf_viewer/squiggly.png',
                      ),
                      size: 16,
                      color: _isLight ? Colors.black : const Color(0xFFFFFFFF),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 132,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Visibility(
                    visible: _canShowColorPaletteIcon && !_isAnnotationLocked,
                    child: _webToolbarItem(
                      'Color Palette',
                      RawMaterialButton(
                        elevation: 0,
                        focusElevation: 0,
                        hoverElevation: 0,
                        highlightElevation: 0,
                        shape: _useMaterial3
                            ? const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)))
                            : const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2))),
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
                        elevation: 0,
                        focusElevation: 0,
                        hoverElevation: 0,
                        highlightElevation: 0,
                        shape: _useMaterial3
                            ? const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)))
                            : const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2))),
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
                  Visibility(
                    visible: _canShowLockIcon,
                    child: _webToolbarItem(
                      _isAnnotationLocked ? 'Unlock' : 'Lock',
                      RawMaterialButton(
                        elevation: 0,
                        focusElevation: 0,
                        hoverElevation: 0,
                        highlightElevation: 0,
                        shape: _useMaterial3
                            ? const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)))
                            : const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2))),
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
                ],
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    if (_isWeb) {
      return _webToolbar();
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
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
                              size: 24,
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
                              size: 24,
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
                ],
              ),
              Row(
                children: [
                  ToolbarItem(
                    height: 40,
                    width: 40,
                    child: Material(
                      color: Colors.transparent,
                      child: IconButton(
                        icon: Icon(
                          Icons.save,
                          color: _color,
                          size: 24,
                        ),
                        onPressed: () async {
                          widget.pdfViewerController.clearSelection();
                          widget.onTap?.call('Save');
                        },
                        tooltip: widget.showTooltip ? 'Save' : null,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
}
