import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:syncfusion_flutter_chat/assist_view.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../model/sample_view.dart';
import '../../helper/ai_pop_up_api_key.dart';

class DocumentSummarizerSample extends SampleView {
  const DocumentSummarizerSample(Key key) : super(key: key);
  @override
  _DocumentSummarizerSampleState createState() =>
      _DocumentSummarizerSampleState();
}

class _DocumentSummarizerSampleState extends SampleViewState
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  late final GenerativeModel _model;
  ChatSession? _chat;

  bool _isDocumentLoaded = false;

  /// Boolean to indicate whether the AI assistant is open or not
  bool _isAIAssitantOpen = false;

  /// To check platform whether it is desktop or not.
  final bool _isDesktop =
      kIsWeb || Platform.isMacOS || Platform.isWindows || Platform.isLinux;

  /// To check whether the theme is material 3 or not.
  late bool _useMaterial3;
  double _aiAssistantWidth = 0;
  final PdfViewerController _pdfViewerController = PdfViewerController();
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  String _extractedText = '';
  late List<AssistMessage> _messages;
  bool _isChatInitialized = false;

  final String _offlineResponse = '''
PDF files are structured with a header for identification, a body containing the document's content organized via a page tree, a cross-reference table indexing the body's objects for quick access, and a trailer to initiate reading.  The trailer points to both the catalog (the document's starting point) and the cross-reference table, allowing efficient navigation and rendering of the document's pages.
      
**Note:** This is an offline response. Please connect to your preferred AI service for real-time queries.''';

  @override
  void initState() {
    super.initState();
    _messages = <AssistMessage>[];
    // Initialize the animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true); // Repeats the animation back and forth

    // Define the animation
    _animation = Tween<double>(
      begin: 0.8,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (model.assistApiKey.isNotEmpty) {
      _initAiServices(model.assistApiKey);
    }

    // Show the dialog when the app starts.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (model.isFirstTime) {
        showDialog(
          context: context,
          builder: (context) => WelcomeDialog(
            primaryColor: model.primaryColor,
            apiKey: model.assistApiKey,
            onApiKeySaved: (newApiKey) {
              setState(() {
                model.assistApiKey = newApiKey;
              });
              _initAiServices(newApiKey);
            },
          ),
        );
        model.isFirstTime = false;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _useMaterial3 = Theme.of(context).useMaterial3;
    _aiAssistantWidth = MediaQuery.sizeOf(context).width / 4;
  }

  @override
  void dispose() {
    _controller.dispose();
    _pdfViewerController.dispose();
    super.dispose();
  }

  /// Initialize the AI services with the provided API key
  void _initAiServices(String apiKey) {
    _model = GenerativeModel(model: 'gemini-1.5-flash-latest', apiKey: apiKey);
    _chat = _model.startChat();

    if (_isDocumentLoaded && _extractedText.isNotEmpty && !_isChatInitialized) {
      _loadPDFDataToAIService();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Function to build the PDF viewer widget.
    Widget pdfViewer() {
      return SfPdfViewer.asset(
        'assets/pdf/pdf_succinctly_template.pdf',
        controller: _pdfViewerController,
        key: _pdfViewerKey,
        onDocumentLoaded: (details) {
          // Export empty fields in the form.
          details.document.form.exportEmptyFields = true;
          _extractPDFData(details.document);
          _loadPDFDataToAIService();
          setState(() => _isDocumentLoaded = true);
        },
      );
    }

    return Stack(
      children: [
        pdfViewer(),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: _addTooltip(_buildAIButton(), 'Launch AI assistant'),
          ),
        ),
        Visibility(
          visible: _isAIAssitantOpen,
          child: Positioned.fill(
            left: _isDesktop && !model.isMobileResolution ? null : 0,
            child: Container(
              width: _aiAssistantWidth,
              decoration: BoxDecoration(
                color: _useMaterial3
                    ? Theme.of(context).colorScheme.surface
                    : Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 5,
                    offset: const Offset(-5, 0),
                  ),
                ],
              ),
              child: _buildAIAssistView(),
            ),
          ),
        ),
      ],
    );
  }

  /// Extracts text from the document.
  void _extractPDFData(PdfDocument document) {
    final List<String> extractedText = <String>[];

    final List<int> annotationBytes = document.exportAnnotation(
      PdfAnnotationDataFormat.json,
    );
    final String annotations = _convertToString(annotationBytes);
    extractedText.add(annotations);

    final List<int> formFieldBytes = document.form.exportData(DataFormat.json);
    final String formFields = _convertToString(formFieldBytes);
    extractedText.add(formFields);

    final PdfTextExtractor textExtractor = PdfTextExtractor(document);

    for (int pageIndex = 0; pageIndex < document.pages.count; pageIndex++) {
      String pageText = '... Page ${pageIndex + 1} ...\n';
      pageText += textExtractor.extractText(startPageIndex: pageIndex);
      extractedText.add(pageText);
    }

    _extractedText = extractedText.join('\n');
  }

  void _loadPDFDataToAIService() {
    if (_chat != null) {
      _chat!.sendMessage(
        Content.text(
          "You are a helpful assistant. Use the provided PDF document and select the most relevant page to answer the user's question. Text extracted from the PDF document: $_extractedText",
        ),
      );
      _isChatInitialized = true;
    }
  }

  String _convertToString(List<int> bytes) {
    const utf8 = Utf8Codec();
    return utf8.decode(bytes);
  }

  Widget _addTooltip(Widget child, String message) {
    return Tooltip(
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
      message: _isDocumentLoaded ? message : '',
      child: child,
    );
  }

  Widget _buildAIButton() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        return Transform.scale(
          scale: _isDocumentLoaded ? _animation.value : 1,
          child: FloatingActionButton(
            heroTag: 'Smart button',
            backgroundColor: _isDocumentLoaded
                ? model.primaryColor
                : Colors.transparent,
            onPressed: _isDocumentLoaded
                ? () {
                    setState(() {
                      _isAIAssitantOpen = !_isAIAssitantOpen;
                    });

                    if (_messages.isEmpty) {
                      _handleActionButtonPressed(
                        'Summarize this document',
                        _offlineResponse,
                      );
                    }
                  }
                : null,
            disabledElevation: 1,
            child: Image.asset(
              'images/ai_assist_view.png',
              height: 30,
              width: 40,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  Widget _buildAIAssistView() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: model.dividerColor),
              bottom: BorderSide(color: model.dividerColor),
            ),
            color: _useMaterial3
                ? Theme.of(context).colorScheme.brightness == Brightness.light
                      ? const Color.fromRGBO(247, 242, 251, 1)
                      : const Color.fromRGBO(37, 35, 42, 1)
                : Theme.of(context).colorScheme.brightness == Brightness.light
                ? const Color(0xFFFAFAFA)
                : const Color(0xFF424242),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'AI Assistant',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _isAIAssitantOpen = false;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SelectionArea(
              child: SfAIAssistView(
                messages: _messages,
                composer: const AssistComposer(
                  decoration: InputDecoration(hintText: 'Type here...'),
                ),
                actionButton: AssistActionButton(
                  onPressed: _handleActionButtonPressed,
                ),
                responseMessageSettings: const AssistMessageSettings(
                  widthFactor: 1.0,
                  showAuthorAvatar: true,
                ),
                requestMessageSettings: const AssistMessageSettings(
                  showAuthorAvatar: false,
                ),
                messageAvatarBuilder:
                    (BuildContext context, int index, AssistMessage message) {
                      return message.isRequested
                          ? const SizedBox.shrink()
                          : Image.asset(
                              model.themeData.brightness == Brightness.light
                                  ? 'images/ai_avatar_light.png'
                                  : 'images/ai_avatar_dark.png',
                              color: model.themeData.colorScheme.primary,
                            );
                    },
                messageContentBuilder:
                    (context, int index, AssistMessage message) {
                      return MarkdownBody(data: message.data);
                    },
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleActionButtonPressed(String prompt, [String localResponse = '']) {
    _addMessageAndRebuild(AssistMessage.request(data: prompt));
    Future.delayed(
      localResponse.isNotEmpty
          ? const Duration(seconds: 2)
          : const Duration(milliseconds: 500),
      () {
        if (model.assistApiKey.isEmpty) {
          if (localResponse.isNotEmpty) {
            _addMessageAndRebuild(
              AssistMessage.response(data: _offlineResponse),
            );
          } else {
            _addMessageAndRebuild(
              const AssistMessage.response(
                data:
                    'Please connect to your preferred AI service for real-time queries.',
              ),
            );
          }
        } else {
          _generateResponse(prompt);
        }
      },
    );
  }

  Future<void> _generateResponse(
    String prompt, [
    String localResponse = '',
  ]) async {
    try {
      final GenerateContentResponse? response = await _chat?.sendMessage(
        Content.text(prompt),
      );
      if (response != null && response.text != null) {
        _addResponseMessage(response.text!);
      }
    } catch (e) {
      _addResponseMessage(
        localResponse.isNotEmpty ? localResponse : 'Error: $e',
      );
    }
  }

  void _addResponseMessage(String response) {
    _addMessageAndRebuild(AssistMessage.response(data: response));
  }

  void _addMessageAndRebuild(AssistMessage message) {
    setState(() => _messages.add(message));
  }
}
