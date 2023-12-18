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
  SfPdfViewerThemeData? _pdfViewerThemeData;
  double _sampleWidth = 0, _sampleHeight = 0;
  late Color _color;
  late bool _isLight;
  late Color _disabledColor;
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
  }

  @override
  void didChangeDependencies() {
    _pdfViewerThemeData = SfPdfViewerTheme.of(context);
    _isLight = _pdfViewerThemeData!.brightness == Brightness.light;
    _color = _isLight
        ? Colors.black.withOpacity(0.54)
        : Colors.white.withOpacity(0.65);
    _disabledColor = _isLight ? Colors.black12 : Colors.white12;
    super.didChangeDependencies();
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
                    child: SfPdfViewer.asset(
                      'assets/pdf/flutter_succinctly.pdf',
                      key: _pdfViewerKey,
                      controller: _pdfViewerController,
                      canShowScrollHead: false,
                      onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                        setState(() {
                          _isPdfLoaded = true;
                          _isInitialBookmarkShown = false;
                        });
                      },
                    ),
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
