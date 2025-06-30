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
    if (dart.library.js_interop) '../pdf/helper/save_file_web.dart';
import 'pdf_viewer_custom_toolbar.dart';
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
  OverlayEntry? _stickyNoteIconMenuOverlayEntry;
  Color? _contextMenuColor;
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
  final double _kStickyNoteIconMenuWidth = 185.0;
  final double _kStickyNoteIconMenuHeight = 312.0;
  final double _kStickyNoteIconMenuItemHeight = 40.0;
  Annotation? _selectedAnnotation;
  Color? _selectedColor;
  double _opacity = 1;
  late bool _useMaterial3;

  @override
  void initState() {
    super.initState();
    _documentPath = 'assets/pdf/annotations.pdf';
    _isDesktopWeb =
        isDesktop &&
        model.isMobileResolution != null &&
        !model.isMobileResolution;
    _needToMaximize = model.needToMaximize;
  }

  @override
  void dispose() {
    super.dispose();
    _closeOverlays();
    _pdfViewerController.dispose();
    _undoHistoryController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _useMaterial3 = Theme.of(context).useMaterial3;
    _isLight = model.themeData.colorScheme.brightness == Brightness.light;
    _contextMenuColor = _useMaterial3
        ? _isLight
              ? const Color(0xFFEEE8F4)
              : const Color(0xFF302D38)
        : _isLight
        ? const Color(0xFFFFFFFF)
        : const Color(0xFF424242);
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
  Widget build(BuildContext context) {
    if (isDesktop) {
      final bool? isDrawerOpened = model
          .webOutputContainerState
          .widget
          .webLayoutPageState
          ?.scaffoldKey
          .currentState
          ?.isEndDrawerOpen;
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
                _pdfViewerController.annotationSettings.stickyNote.icon =
                    PdfStickyNoteIcon.comment;
                _handleColorPaletteOverlayClose();
                _handleStickyNoteIconOverlayClose();

                if (_pdfViewerController.annotationMode == toolbarItem) {
                  _pdfViewerController.annotationMode = PdfAnnotationMode.none;
                  _toolbarKey.currentState?._changeToolbarItemVisibility(
                    'Color Palette',
                    false,
                  );
                  _toolbarKey.currentState?._changeToolbarItemVisibility(
                    'Sticky note icons',
                    false,
                  );
                } else {
                  _pdfViewerController.annotationMode =
                      toolbarItem as PdfAnnotationMode;
                  _toolbarKey.currentState?._changeToolbarItemVisibility(
                    'Color Palette',
                    true,
                  );
                  if (toolbarItem == PdfAnnotationMode.stickyNote) {
                    _toolbarKey.currentState?._changeToolbarItemVisibility(
                      'Sticky note icons',
                      true,
                    );
                  }
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

              if (toolbarItem == 'Sticky note icons') {
                if (_stickyNoteIconMenuOverlayEntry == null) {
                  if (_selectedAnnotation == null ||
                      _selectedAnnotation != null &&
                          !_selectedAnnotation!.isLocked &&
                          _selectedAnnotation is StickyNoteAnnotation) {
                    _showStickyNoteAnnotationIconMenu(context);
                  }
                } else {
                  _handleStickyNoteIconOverlayClose();
                }
              } else if (toolbarItem != 'Sticky note icons') {
                _handleStickyNoteIconOverlayClose();
              }

              if (toolbarItem == 'Lock') {
                if (_selectedAnnotation != null) {
                  _selectedAnnotation!.isLocked =
                      !_selectedAnnotation!.isLocked;
                  _toolbarKey.currentState?._setAnnotationLocked(
                    _selectedAnnotation!.isLocked,
                  );
                }
              }
            }

            if (toolbarItem == 'Save') {
              final List<int> savedBytes = await _pdfViewerController
                  .saveDocument();
              _saveDocument(
                savedBytes,
                'The document was saved at the location ',
                'annotations.pdf',
              );
            }

            if (toolbarItem == 'Undo' || toolbarItem == 'Redo') {
              if (_selectedAnnotation != null) {
                _toolbarKey.currentState?._setAnnotationLocked(
                  _selectedAnnotation!.isLocked,
                );
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
        future: Future<dynamic>.delayed(const Duration(milliseconds: 200)).then(
          (dynamic value) {
            _canShowPdf = true;
          },
        ),
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
                        _toolbarKey.currentState?._changeToolbarItemFillColor(
                          'Text Markup',
                          false,
                        );
                        _toolbarKey.currentState?._changeToolbarItemFillColor(
                          'Sticky note icons',
                          false,
                        );
                        _toolbarKey.currentState?._setAnnotationLocked(
                          annotation.isLocked,
                        );
                        _toolbarKey.currentState?._changeToolbarItemVisibility(
                          'Lock',
                          true,
                        );
                        _toolbarKey.currentState?._changeToolbarItemVisibility(
                          'Delete',
                          true,
                        );
                        _toolbarKey.currentState?._changeToolbarItemVisibility(
                          'Color Palette',
                          true,
                        );
                        if (annotation is StickyNoteAnnotation) {
                          _toolbarKey.currentState
                              ?._changeToolbarItemVisibility(
                                'Sticky note icons',
                                true,
                              );
                        }
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
                        _toolbarKey.currentState?._changeToolbarItemVisibility(
                          'Lock',
                          false,
                        );
                        _toolbarKey.currentState?._changeToolbarItemVisibility(
                          'Delete',
                          false,
                        );
                        _toolbarKey.currentState?._changeToolbarItemVisibility(
                          'Color Palette',
                          false,
                        );
                        _toolbarKey.currentState?._changeToolbarItemVisibility(
                          'Sticky note icons',
                          false,
                        );
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
                      showAddTextMarkupToolbar: false,
                      showStickyNoteIcon: true,
                      selectedAnnotation: _selectedAnnotation,
                      onBackButtonPressed: () {
                        if (_selectedAnnotation != null) {
                          _pdfViewerController.deselectAnnotation(
                            _selectedAnnotation!,
                          );
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
              color:
                  SfPdfViewerTheme.of(context)!.backgroundColor ??
                  Theme.of(context).colorScheme.surface.withValues(alpha: 0.08),
            );
          }
        },
      ),
    );
  }

  /// Saves the PDF document.
  Future<void> _saveDocument(
    List<int> dataBytes,
    String message,
    String fileName,
  ) async {
    if (kIsWeb) {
      await FileSaveHelper.saveAndLaunchFile(dataBytes, fileName);
    } else {
      final Directory directory = await getApplicationSupportDirectory();
      final String path = directory.path;
      final File file = File('$path${Platform.pathSeparator}$fileName');
      try {
        await file.writeAsBytes(dataBytes);
        _showDialog(
          'Document saved',
          message + path + Platform.pathSeparator + fileName,
        );
      } on PathAccessException catch (e) {
        _showDialog(
          'Error',
          e.osError?.message ?? 'Error in saving the document',
        );
      } catch (e) {
        _showDialog('Error', 'Error in saving the document');
      }
    }
  }

  /// Alert dialog for save.
  void _showDialog(String title, String message) {
    showDialog<Widget>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SizedBox(
            width: 328.0,
            child: Scrollbar(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                child: Text(message),
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
                        vertical: 10,
                        horizontal: 20,
                      ),
                    )
                  : null,
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  /// Shows the drop down menu overlay.
  OverlayEntry? _showDropDownOverlay(
    RenderBox toolbarItemRenderBox,
    OverlayEntry? overlayEntry,
    BoxConstraints constraints,
    Widget dropDownItems, [
    Offset? positionOverride,
    double? borderRadius,
  ]) {
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
              color: _isLight
                  ? const Color(0xFFFFFFFF)
                  : const Color(0xFF424242),
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
    _toolbarKey.currentState?._changeToolbarItemFillColor(
      'Color Palette',
      true,
    );
    final RenderBox colorPaletteRenderBox =
        (_toolbarKey.currentState?._colorPaletteKey.currentContext
                ?.findRenderObject())!
            as RenderBox;
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
        Offset(-(_kColorPaletteWidth - colorPaletteRenderBox.size.width), 0),
      );
      _colorPaletteOverlayEntry = _showDropDownOverlay(
        colorPaletteRenderBox,
        _colorPaletteOverlayEntry,
        BoxConstraints.tightFor(
          width: _kColorPaletteWidth,
          height: _kColorPaletteHeight,
        ),
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
    _toolbarKey.currentState?._changeToolbarItemFillColor(
      'Color Palette',
      false,
    );
  }

  /// Shows the sticky note icon menu for web platform.
  void _showStickyNoteAnnotationIconMenu(BuildContext context) {
    _toolbarKey.currentState?._changeToolbarItemFillColor(
      'Sticky note icons',
      true,
    );

    final RenderBox? stickyNoteAnnotationMenuRenderBox =
        _toolbarKey.currentState?._stickyNoteKey.currentContext
                ?.findRenderObject()
            as RenderBox?;

    if (stickyNoteAnnotationMenuRenderBox != null) {
      final Widget child = _stickyNoteIconMenuContainer();
      final Offset position = stickyNoteAnnotationMenuRenderBox.localToGlobal(
        Offset(
          -(_kStickyNoteIconMenuWidth -
              stickyNoteAnnotationMenuRenderBox.size.width),
          0,
        ),
      );
      _stickyNoteIconMenuOverlayEntry = _showDropDownOverlay(
        stickyNoteAnnotationMenuRenderBox,
        _stickyNoteIconMenuOverlayEntry,
        BoxConstraints.tightFor(
          width: _kStickyNoteIconMenuWidth,
          height: _kStickyNoteIconMenuHeight,
        ),
        child,
        position,
      );
    }
  }

  /// Sticky note icons menu container.
  Widget _stickyNoteIconMenuContainer() {
    return Container(
      width: _kStickyNoteIconMenuWidth,
      height: _kStickyNoteIconMenuHeight,
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
            _stickyNoteIconMenuItem('Note', PdfStickyNoteIcon.note),
            _stickyNoteIconMenuItem('Insert', PdfStickyNoteIcon.insert),
            _stickyNoteIconMenuItem('Comment', PdfStickyNoteIcon.comment),
            _stickyNoteIconMenuItem('Key', PdfStickyNoteIcon.key),
            _stickyNoteIconMenuItem('Help', PdfStickyNoteIcon.help),
            _stickyNoteIconMenuItem('Paragraph', PdfStickyNoteIcon.paragraph),
            _stickyNoteIconMenuItem(
              'New Paragraph',
              PdfStickyNoteIcon.newParagraph,
            ),
          ],
        ),
      ),
    );
  }

  /// Sticky note icons menu item.
  Widget _stickyNoteIconMenuItem(String name, PdfStickyNoteIcon icon) {
    return StickyNoteIconMenuItem(
      stickyNoteIconName: name,
      icon: icon,
      model: model,
      onPressed: () => _handleStickyNoteIconSelection(icon),
      height: _kStickyNoteIconMenuItemHeight,
      width: _kStickyNoteIconMenuWidth,
    );
  }

  /// Handles sticky note icon selection.
  void _handleStickyNoteIconSelection(PdfStickyNoteIcon icon) {
    if (_selectedAnnotation != null &&
        _selectedAnnotation is StickyNoteAnnotation) {
      final StickyNoteAnnotation stickyNoteAnnotation =
          _selectedAnnotation! as StickyNoteAnnotation;
      stickyNoteAnnotation.icon = icon;
    } else {
      _pdfViewerController.annotationSettings.stickyNote.icon = icon;
    }
    _handleStickyNoteIconOverlayClose();
  }

  /// Close sticky note icon overlay.
  void _handleStickyNoteIconOverlayClose() {
    _toolbarKey.currentState?._changeToolbarItemFillColor(
      'Sticky note icons',
      false,
    );
    if (_stickyNoteIconMenuOverlayEntry != null) {
      _stickyNoteIconMenuOverlayEntry?.remove();
      _stickyNoteIconMenuOverlayEntry = null;
    }
  }

  /// Close all the overlays.
  void _closeOverlays() {
    if (_isDesktopWeb) {
      _handleColorPaletteOverlayClose();
      _handleStickyNoteIconOverlayClose();
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
  Color? _stickyNoteIconFillColor;
  late bool _isLight;
  final GlobalKey _colorPaletteKey = GlobalKey();
  final GlobalKey _stickyNoteKey = GlobalKey();
  bool _isWeb = false;
  bool _canShowColorPaletteIcon = false;
  bool _canshowStickyNoteIconMenu = false;
  bool _canShowDeleteIcon = false;
  bool _canShowLockIcon = false;
  bool _isAnnotationLocked = false;
  late bool _useMaterial3;
  Color? _annotationIconColor;

  @override
  void didChangeDependencies() {
    _isLight = Theme.of(context).brightness == Brightness.light;
    _useMaterial3 = Theme.of(context).useMaterial3;
    _annotationIconColor = _useMaterial3
        ? widget.model?.themeData.colorScheme.onSurfaceVariant
        : (widget.model?.themeData.brightness == Brightness.light)
        ? Colors.black.withValues(alpha: 0.87)
        : Colors.white;
    _color = _useMaterial3
        ? _isLight
              ? const Color.fromRGBO(73, 69, 79, 1)
              : const Color.fromRGBO(202, 196, 208, 1)
        : _isLight
        ? Colors.black.withValues(alpha: 0.54)
        : Colors.white.withValues(alpha: 0.65);
    _disabledColor = _useMaterial3
        ? _isLight
              ? const Color.fromRGBO(28, 27, 31, 1).withValues(alpha: 0.38)
              : const Color.fromRGBO(230, 225, 229, 1).withValues(alpha: 0.38)
        : _isLight
        ? Colors.black12
        : Colors.white12;
    _fillColor = _useMaterial3
        ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08)
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
      } else if (toolbarItem == 'Sticky note icons') {
        _stickyNoteIconFillColor = isFocused ? _fillColor : null;
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
      } else if (toolbarItem == 'Sticky note icons') {
        _canshowStickyNoteIconMenu = isVisible;
      }
    });
  }

  /// Sets the annotation lock status.
  void _setAnnotationLocked(bool isLocked) {
    setState(() {
      _isAnnotationLocked = isLocked;
    });
  }

  /// Get the annotation icon based on the annotation mode.
  ImageIcon _annotationIcon(PdfAnnotationMode mode) {
    String iconPath = '';
    double iconSize = 16;
    switch (mode) {
      case PdfAnnotationMode.highlight:
        iconPath = _isLight
            ? 'images/pdf_viewer/highlight_light.png'
            : 'images/pdf_viewer/highlight_dark.png';
        iconSize = 18;
        break;
      case PdfAnnotationMode.strikethrough:
        iconPath = _isLight
            ? 'images/pdf_viewer/strikethrough_light.png'
            : 'images/pdf_viewer/strikethrough_dark.png';
        iconSize = 18;
        break;
      case PdfAnnotationMode.underline:
        iconPath = _isLight
            ? 'images/pdf_viewer/underline_light.png'
            : 'images/pdf_viewer/underline_dark.png';
        iconSize = 18;
        break;
      case PdfAnnotationMode.squiggly:
        iconPath = _isLight
            ? 'images/pdf_viewer/squiggly_light.png'
            : 'images/pdf_viewer/squiggly_dark.png';
        iconSize = 18;
        break;

      case PdfAnnotationMode.none:
        break;
      case PdfAnnotationMode.stickyNote:
        iconPath = _isLight
            ? 'images/pdf_viewer/note_light.png'
            : 'images/pdf_viewer/note_dark.png';
        iconSize = 18;
        break;
    }

    return ImageIcon(
      AssetImage(iconPath),
      size: iconSize,
      color: _annotationIconColor,
    );
  }

  /// Constructs web toolbar item widget.
  Widget _webToolbarItem(String toolTip, Widget child, {Key? key}) {
    return Padding(
      padding:
          toolTip == 'Lock' ||
              toolTip == 'Unlock' ||
              toolTip == 'Delete' ||
              toolTip == 'Color Palette' ||
              toolTip == 'Sticky note icons'
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
        constraints: _useMaterial3 ? const BoxConstraints(maxHeight: 48) : null,
        child: SizedBox(
          key: key,
          height: 36,
          width: toolTip == 'Options' ? 50 : 36,
          child: child,
        ),
      ),
    );
  }

  /// Constructs the web toolbar button.
  Widget _webToolbarButton({
    required Widget child,
    required void Function()? onPressed,
    Color? fillColor,
    double elevation = 0,
    double focusElevation = 0,
    double hoverElevation = 0,
    double highlightElevation = 0,
    ShapeBorder? shape,
  }) {
    return RawMaterialButton(
      onPressed: onPressed,
      fillColor: fillColor,
      elevation: elevation,
      focusElevation: focusElevation,
      hoverElevation: hoverElevation,
      highlightElevation: highlightElevation,
      shape:
          shape ??
          (_useMaterial3
              ? const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                )
              : const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(2)),
                )),
      child: child,
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
            ? Colors.black.withValues(alpha: 0.24)
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
                _webToolbarButton(
                  onPressed: () async {
                    widget.pdfViewerController.clearSelection();
                    widget.onTap?.call('Save');
                  },
                  child: Icon(Icons.save, color: _color, size: 20),
                ),
              ),
              _groupDivider(true),
              _webToolbarItem(
                'Undo',
                ValueListenableBuilder<UndoHistoryValue>(
                  valueListenable: widget.undoHistoryController!,
                  builder:
                      (
                        BuildContext context,
                        UndoHistoryValue value,
                        Widget? child,
                      ) {
                        return _webToolbarButton(
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
                  builder:
                      (
                        BuildContext context,
                        UndoHistoryValue value,
                        Widget? child,
                      ) {
                        return _webToolbarButton(
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
                _webToolbarButton(
                  onPressed: () {
                    widget.onTap?.call(PdfAnnotationMode.highlight);
                  },
                  fillColor:
                      widget.pdfViewerController.annotationMode ==
                          PdfAnnotationMode.highlight
                      ? _fillColor
                      : null,
                  child: _annotationIcon(PdfAnnotationMode.highlight),
                ),
              ),
              _webToolbarItem(
                'Underline',
                _webToolbarButton(
                  onPressed: () {
                    widget.onTap?.call(PdfAnnotationMode.underline);
                  },
                  fillColor:
                      widget.pdfViewerController.annotationMode ==
                          PdfAnnotationMode.underline
                      ? _fillColor
                      : null,
                  child: _annotationIcon(PdfAnnotationMode.underline),
                ),
              ),
              _webToolbarItem(
                'Strikethrough',
                _webToolbarButton(
                  onPressed: () {
                    widget.onTap?.call(PdfAnnotationMode.strikethrough);
                  },
                  fillColor:
                      widget.pdfViewerController.annotationMode ==
                          PdfAnnotationMode.strikethrough
                      ? _fillColor
                      : null,
                  child: _annotationIcon(PdfAnnotationMode.strikethrough),
                ),
              ),
              _webToolbarItem(
                'Squiggly',
                _webToolbarButton(
                  onPressed: () {
                    widget.onTap?.call(PdfAnnotationMode.squiggly);
                  },
                  fillColor:
                      widget.pdfViewerController.annotationMode ==
                          PdfAnnotationMode.squiggly
                      ? _fillColor
                      : null,
                  child: _annotationIcon(PdfAnnotationMode.squiggly),
                ),
              ),
              _webToolbarItem(
                'Sticky note',
                _webToolbarButton(
                  onPressed: () {
                    widget.onTap?.call(PdfAnnotationMode.stickyNote);
                  },
                  fillColor:
                      widget.pdfViewerController.annotationMode ==
                          PdfAnnotationMode.stickyNote
                      ? _fillColor
                      : null,
                  child: _annotationIcon(PdfAnnotationMode.stickyNote),
                ),
              ),
            ],
          ),
          SizedBox(
            width: 250,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Visibility(
                  visible: _canShowColorPaletteIcon && !_isAnnotationLocked,
                  child: _webToolbarItem(
                    'Color Palette',
                    _webToolbarButton(
                      onPressed: () {
                        widget.onTap?.call('Color Palette');
                      },
                      fillColor: _colorPaletteFillColor,
                      child: ImageIcon(
                        const AssetImage('images/pdf_viewer/color_palette.png'),
                        size: 17,
                        color: _isLight
                            ? Colors.black
                            : const Color(0xFFFFFFFF),
                      ),
                    ),
                    key: _colorPaletteKey,
                  ),
                ),
                Visibility(
                  visible: _canshowStickyNoteIconMenu && !_isAnnotationLocked,
                  child: _webToolbarItem(
                    'Sticky note icons',
                    _webToolbarButton(
                      onPressed: () {
                        widget.onTap?.call('Sticky note icons');
                      },
                      fillColor: _stickyNoteIconFillColor,
                      child: _isLight
                          ? ImageIcon(
                              const AssetImage(
                                'images/pdf_viewer/note_light.png',
                              ),
                              size: 17,
                              color: _annotationIconColor,
                            )
                          : ImageIcon(
                              const AssetImage(
                                'images/pdf_viewer/note_dark.png',
                              ),
                              size: 17,
                              color: _annotationIconColor,
                            ),
                    ),
                    key: _stickyNoteKey,
                  ),
                ),
                Visibility(
                  visible: _canShowDeleteIcon && !_isAnnotationLocked,
                  child: _webToolbarItem(
                    'Delete',
                    _webToolbarButton(
                      onPressed: () {
                        widget.onTap?.call('Delete');
                      },
                      child: ImageIcon(
                        const AssetImage('images/pdf_viewer/delete.png'),
                        size: 17,
                        color: _isLight
                            ? Colors.black
                            : const Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: _canShowLockIcon,
                  child: _webToolbarItem(
                    _isAnnotationLocked ? 'Unlock' : 'Lock',
                    _webToolbarButton(
                      onPressed: () {
                        widget.onTap?.call('Lock');
                      },
                      child: ImageIcon(
                        AssetImage(
                          _isAnnotationLocked
                              ? 'images/pdf_viewer/unlocked.png'
                              : 'images/pdf_viewer/locked.png',
                        ),
                        size: 18,
                        color: _isLight
                            ? Colors.black
                            : const Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
                      builder:
                          (
                            BuildContext context,
                            UndoHistoryValue value,
                            Widget? child,
                          ) {
                            return Material(
                              color: Colors.transparent,
                              child: IconButton(
                                icon: Icon(
                                  Icons.undo,
                                  color: value.canUndo
                                      ? _color
                                      : _disabledColor,
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
                      builder:
                          (
                            BuildContext context,
                            UndoHistoryValue value,
                            Widget? child,
                          ) {
                            return Material(
                              color: Colors.transparent,
                              child: IconButton(
                                icon: Icon(
                                  Icons.redo,
                                  color: value.canRedo
                                      ? _color
                                      : _disabledColor,
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
                        icon: Icon(Icons.save, color: _color, size: 24),
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
