///Package import
import 'package:flutter/material.dart';

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
  double _sampleWidth = 0, _sampleHeight = 0;
  late Color _color;
  late bool _isLight;
  late Color _disabledColor;
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  bool _isPdfLoaded = false;
  bool _isInitialBookmarkShown = false;
  late bool _useMaterial3;

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
    _isLight = Theme.of(context).brightness == Brightness.light;
    _useMaterial3 = Theme.of(context).useMaterial3;
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
      Future<dynamic>.delayed(const Duration(milliseconds: 2000)).then((
        dynamic value,
      ) {
        _pdfViewerKey.currentState?.openBookmarkView();
      });
      _isInitialBookmarkShown = true;
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: _useMaterial3
                ? Theme.of(context).colorScheme.brightness == Brightness.light
                      ? const Color.fromRGBO(247, 242, 251, 1)
                      : const Color.fromRGBO(37, 35, 42, 1)
                : Theme.of(context).colorScheme.brightness == Brightness.light
                ? const Color(0xFFFAFAFA)
                : const Color(0xFF424242),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.2),
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ],
          ),
          height: 56,
          child: Align(
            alignment: model.locale == const Locale('ar', 'AE')
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: SizedBox(
              height: 40,
              width: 40,
              child: RawMaterialButton(
                shape: _useMaterial3
                    ? RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      )
                    : RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                onPressed: () {
                  _pdfViewerKey.currentState?.openBookmarkView();
                },
                child: Tooltip(
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
                  constraints: _useMaterial3
                      ? const BoxConstraints(maxHeight: 48)
                      : null,
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
                        ),
                ),
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
                  data: const SfPdfViewerThemeData(),
                  child: SfPdfViewer.asset(
                    'assets/pdf/flutter_succinctly.pdf',
                    key: _pdfViewerKey,
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
            },
          ),
        ),
      ],
    );
  }

  String getBookmarkLocaleString() {
    if (model.locale!.languageCode == 'ar') {
      return 'إشارة مرجعية';
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
