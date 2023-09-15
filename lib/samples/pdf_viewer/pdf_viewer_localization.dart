///Package import
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Core theme import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

///PDF Viewer import
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

///Local import
import '../../model/sample_view.dart';
import 'shared/helper.dart';

///Widget of getting started PDF Viewer.
class LocalizationPdfViewer extends LocalizationSampleView {
  /// Creates default getting started PDF Viewer.
  const LocalizationPdfViewer(Key key) : super(key: key);

  @override
  _LocalizationPdfViewerState createState() => _LocalizationPdfViewerState();
}

class _LocalizationPdfViewerState extends LocalizationSampleViewState {
  late bool _canShowPdf;
  late bool _canShowToast;
  OverlayEntry? _overlayEntry;
  late Color _contextMenuColor;
  late Color _copyColor;
  late double _contextMenuWidth;
  late double _contextMenuHeight;
  SfPdfViewerThemeData? _pdfViewerThemeData;
  double _sampleWidth = 0, _sampleHeight = 0;
  late Color _color;
  late bool _isLight;
  late Color _disabledColor;
  final double _kWebContextMenuHeight = 32;
  final double _kMobileContextMenuHeight = 48;
  final double _kContextMenuBottom = 55;
  final PdfViewerController _pdfViewerController = PdfViewerController();
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  bool _isPdfLoaded = false;
  bool _isInitialBookmarkShown = false;

  @override
  void initState() {
    Future<dynamic>.delayed(const Duration(milliseconds: 600), () {
      if (super.mounted) {
        final FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.requestFocus(FocusNode());
        }
      }
    });
    super.initState();
    _canShowPdf = false;
    _canShowToast = false;
    _contextMenuHeight = 48;
    _contextMenuWidth = 100;
  }

  @override
  void didChangeDependencies() {
    _pdfViewerThemeData = SfPdfViewerTheme.of(context);
    _isLight = _pdfViewerThemeData!.brightness == Brightness.light;
    _color = _isLight
        ? Colors.black.withOpacity(0.54)
        : Colors.white.withOpacity(0.65);
    _disabledColor = _isLight ? Colors.black12 : Colors.white12;

    /// Used figma colors for context menu color and copy text color.
    _contextMenuColor =
        model.themeData.colorScheme.brightness == Brightness.light
            ? const Color(0xFFFFFFFF)
            : const Color(0xFF424242);
    _copyColor = model.themeData.colorScheme.brightness == Brightness.light
        ? const Color(0xFF000000)
        : const Color(0xFFFFFFFF);
    super.didChangeDependencies();
  }

  /// Show Context menu for Text Selection.
  void _showContextMenu(
      BuildContext context, PdfTextSelectionChangedDetails details) {
    const List<BoxShadow> boxShadows = <BoxShadow>[
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.14),
        blurRadius: 2,
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
    _contextMenuHeight = (model.isWebFullView && !model.isMobileResolution)
        ? _kWebContextMenuHeight
        : _kMobileContextMenuHeight;
    final RenderBox renderBoxContainer =
        // ignore: avoid_as
        context.findRenderObject()! as RenderBox;
    final Offset containerOffset = renderBoxContainer.localToGlobal(
      renderBoxContainer.paintBounds.topLeft,
    );
    if (containerOffset.dy <
            details.globalSelectedRegion!.topLeft.dy - _kContextMenuBottom ||
        (containerOffset.dy <
                details.globalSelectedRegion!.center.dy -
                    (_contextMenuHeight / 2) &&
            details.globalSelectedRegion!.height > _contextMenuWidth)) {
      double top = 0.0;
      double left = 0.0;
      if ((details.globalSelectedRegion!.top) >
          MediaQuery.of(context).size.height / 2) {
        top = details.globalSelectedRegion!.topLeft.dy - _kContextMenuBottom;
        left = details.globalSelectedRegion!.bottomLeft.dx;
      } else {
        top = details.globalSelectedRegion!.height > _contextMenuWidth
            ? details.globalSelectedRegion!.center.dy - (_contextMenuHeight / 2)
            : details.globalSelectedRegion!.topLeft.dy - _kContextMenuBottom;
        left = details.globalSelectedRegion!.height > _contextMenuWidth
            ? details.globalSelectedRegion!.center.dx - (_contextMenuWidth / 2)
            : details.globalSelectedRegion!.bottomLeft.dx;
      }
      final OverlayState overlayState = Overlay.of(context, rootOverlay: true);
      _overlayEntry = OverlayEntry(
        builder: (BuildContext context) => Positioned(
          top: top,
          left: left,
          child: Container(
            decoration: BoxDecoration(
              color: _contextMenuColor,
              boxShadow: boxShadows,
            ),
            constraints: BoxConstraints.tightFor(
                width: _contextMenuWidth, height: _contextMenuHeight),
            child: TextButton(
              onPressed: () async {
                _checkAndCloseContextMenu();
                _pdfViewerController.clearSelection();
                await Clipboard.setData(
                    ClipboardData(text: details.selectedText!));
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
                style: (model.isWebFullView && !model.isMobileResolution)
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
      overlayState.insert(_overlayEntry!);
    }
  }

  /// Check and close the context menu.
  void _checkAndCloseContextMenu() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  @override
  Widget buildSample(BuildContext context) {
    if (_sampleHeight != MediaQuery.of(context).size.height ||
        _sampleWidth != MediaQuery.of(context).size.width) {
      _sampleWidth = MediaQuery.of(context).size.width;
      _sampleHeight = MediaQuery.of(context).size.height;
      _canShowPdf = false;
    }

    if (isDesktop && _isPdfLoaded && !_isInitialBookmarkShown) {
      Future<dynamic>.delayed(const Duration(milliseconds: 2000))
          .then((dynamic value) {
        _pdfViewerKey.currentState?.openBookmarkView();
      });
      _isInitialBookmarkShown = true;
    }

    return Column(children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
            color: SfPdfViewerTheme.of(context)!
                    .bookmarkViewStyle
                    ?.headerBarColor ??
                ((Theme.of(context).colorScheme.brightness == Brightness.light)
                    ? const Color(0xFFFAFAFA)
                    : const Color(0xFF424242)),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.2),
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ]),
        height: 56,
        child: Align(
          alignment: model.locale == const Locale('ar', 'AE')
              ? Alignment.centerLeft
              : Alignment.centerRight,
          child: SizedBox(
            height: 40,
            width: 40,
            child: RawMaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2.0),
              ),
              onPressed: () {
                _pdfViewerKey.currentState?.openBookmarkView();
              },
              child: Tooltip(
                  message: getBookmarkLocaleString(),
                  child: isDesktop
                      ? Icon(
                          Icons.bookmark_border,
                          color: _isPdfLoaded ? _color : _disabledColor,
                          size: 20,
                          semanticLabel: 'Bookmark',
                        )
                      : Icon(
                          Icons.bookmark,
                          color: _isPdfLoaded ? _color : Colors.black12,
                          size: 24,
                          semanticLabel: 'Bookmark',
                        )),
            ),
          ),
        ),
      ),
      Expanded(
          child: FutureBuilder(
              future: Future<dynamic>.delayed(const Duration(milliseconds: 200))
                  .then((dynamic value) {
                _canShowPdf = true;
              }),
              builder: (BuildContext context, AsyncSnapshot<Object?> snapshot) {
                if (_canShowPdf) {
                  return SfPdfViewerTheme(
                    data: SfPdfViewerThemeData(
                        brightness: model.themeData.colorScheme.brightness),
                    child: Stack(children: <Widget>[
                      SfPdfViewer.asset(
                        'assets/pdf/flutter_succinctly.pdf',
                        key: _pdfViewerKey,
                        controller: _pdfViewerController,
                        canShowScrollHead: false,
                        onTextSelectionChanged:
                            (PdfTextSelectionChangedDetails details) {
                          if (details.selectedText == null &&
                              _overlayEntry != null) {
                            _checkAndCloseContextMenu();
                          } else if (details.selectedText != null &&
                              _overlayEntry == null) {
                            _showContextMenu(context, details);
                          }
                        },
                        onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                          setState(() {
                            _isPdfLoaded = true;
                            _isInitialBookmarkShown = false;
                          });
                        },
                      ),
                      showToast(
                          _canShowToast, Alignment.bottomCenter, 'Copied'),
                    ]),
                  );
                } else {
                  return Container(
                    color: SfPdfViewerTheme.of(context)!.backgroundColor,
                  );
                }
              }))
    ]);
  }

  String getBookmarkLocaleString() {
    if (model.locale!.languageCode == 'ar') {
      return 'المرجعية';
    } else if (model.locale!.languageCode == 'fr') {
      return 'Signet';
    } else if (model.locale!.languageCode == 'es') {
      return 'Marcador';
    } else if (model.locale!.languageCode == 'zh') {
      return '书签';
    }
    return 'Bookmark';
  }
}
