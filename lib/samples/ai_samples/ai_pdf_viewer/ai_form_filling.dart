import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../model/sample_view.dart';
import '../../helper/ai_pop_up_api_key.dart';
import '../../pdf/helper/save_file_mobile.dart'
    if (dart.library.js_interop) '../../pdf/helper/save_file_web.dart';

class SmartFillSample extends SampleView {
  const SmartFillSample(Key key) : super(key: key);
  @override
  _SmartFillSampleState createState() => _SmartFillSampleState();
}

class _SmartFillSampleState extends SampleViewState
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  late final GenerativeModel _model;
  late final ChatSession _chat;
  bool _isExpanded = false;
  final Map<int, bool> _isCopied = {};
  bool _isButtonEnabled = false;
  bool _isWeb = false;

  /// Boolean to indicate whether the AI service work is in progress
  bool _isBusy = false;
  bool _isDocumentLoaded = false;

  /// To check platform whether it is desktop or not.
  bool isDesktop = kIsWeb || Platform.isMacOS || Platform.isWindows;

  /// To check whether the theme is material 3 or not.
  late bool _useMaterial3;

  final List<String> _userDetails = [];
  final PdfViewerController _pdfViewerController = PdfViewerController();
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
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
    _initUserDetail();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _useMaterial3 = Theme.of(context).useMaterial3;
    _isWeb = isDesktop && model != null && !model.isMobileResolution;
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
  }

  /// Enables the Smart fill button if the clipboard has any values
  Future<void> _checkClipboard() async {
    try {
      final bool hasData = await Clipboard.hasStrings();
      final ClipboardData? clipboardData = await Clipboard.getData(
        'text/plain',
      );

      final String? clipboardContent = clipboardData?.text;

      if (model.assistApiKey.isNotEmpty) {
        setState(() {
          _isButtonEnabled = hasData;
        });
      } else if (clipboardContent != null) {
        setState(() {
          _isButtonEnabled = _userDetails.contains(clipboardContent);
        });
      }
    } catch (e) {
      setState(() {
        _isBusy = false;
      });
    }
  }

  void _initUserDetail() {
    _userDetails.add(
      'Hi, this is John. You can contact me at john123@emailid.com. I am male, born on February 20, 2005. I want to subscribe to a newspaper and learn courses, specifically a Machine Learning course. I am from Alaska.',
    );
    _userDetails.add(
      'S David here. You can reach me at David123@emailid.com. I am male, born on March 15, 2003. I would like to subscribe to a newspaper and am interested in taking a Digital Marketing course. I am from New York.',
    );
    _userDetails.add(
      'Hi, this is Alice. You can contact me at alice456@emailid.com. I am female, born on July 15, 1998. I want to unsubscribe from a newspaper and learn courses, specifically a Cloud Computing course. I am from Texas.',
    );
  }

  Future<String?> _sendMessage(String message) async {
    try {
      final GenerateContentResponse response = await _chat.sendMessage(
        Content.text(message),
      );
      return response.text;
    } catch (e) {
      return null;
    }
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  String _getOfflineResponse(String data) {
    String response = '';
    if (data.compareTo(_userDetails[0]) == 0) {
      response = '''
                <?xml version="1.0" encoding="utf-8"?>
                <xfdf xmlns="http://ns.adobe.com/xfdf/" xml:space="preserve">
                  <fields>
                    <field name="name">
                      <value>John</value>
                    </field>
                    <field name="email">
                      <value>john123@emailid.com</value>
                    </field>
                    <field name="gender">
                      <value>Male</value>
                    </field>
                    <field name="dob">
                      <value>Feb/20/2005</value>
                    </field>
                    <field name="state">
                      <value>Alaska</value>
                    </field>
                    <field name="newsletter">
                      <value>On</value>
                    </field>
                    <field name="courses">
                      <value>Machine Learning</value>
                    </field>
                  </fields>
                  <f href=""/>
                </xfdf>
                ''';
    } else if (data.compareTo(_userDetails[1]) == 0) {
      response = '''
                <?xml version="1.0" encoding="utf-8"?>
                <xfdf xmlns="http://ns.adobe.com/xfdf/" xml:space="preserve">
                  <fields>
                    <field name="name">
                      <value>S David</value>
                    </field>
                    <field name="email">
                      <value>David123@emailid.com</value>
                    </field>
                    <field name="gender">
                      <value>Male</value>
                    </field>
                    <field name="dob">
                      <value>Mar/15/2003</value>
                    </field>
                    <field name="state">
                      <value>New York</value>
                    </field>
                    <field name="newsletter">
                      <value>On</value>
                    </field>
                    <field name="courses">
                      <value>Digital Marketing</value>
                    </field>
                  </fields>
                  <f href=""/>
                </xfdf>
                ''';
    } else if (data.compareTo(_userDetails[2]) == 0) {
      response = '''
                <?xml version="1.0" encoding="utf-8"?>
                <xfdf xmlns="http://ns.adobe.com/xfdf/" xml:space="preserve">
                  <fields>
                    <field name="name">
                      <value>Alice</value>
                    </field>
                    <field name="email">
                      <value>alice456@emailid.com</value>
                    </field>
                    <field name="gender">
                      <value>Female</value>
                    </field>
                    <field name="dob">
                      <value>Jul/15/1998</value>
                    </field>
                    <field name="state">
                      <value>Texas</value>
                    </field>
                    <field name="newsletter">
                      <value>Off</value>
                    </field>
                    <field name="courses">
                      <value>Cloud Computing</value>
                    </field>
                  </fields>
                  <f href=""/>
                </xfdf>
                ''';
    }

    return response;
  }

  Future<void> _smartFill() async {
    try {
      final ClipboardData? clipboardData = await Clipboard.getData(
        'text/plain',
      );

      if (clipboardData == null || clipboardData.text == null) {
        return;
      }

      setState(() {
        _isBusy = true;
      });

      final String copiedTextContent = clipboardData.text!;
      String? response = '';
      if (model.assistApiKey.isNotEmpty) {
        final String customValues = _getHintText();
        final String exportedFormData = _getXFDFString();

        final String prompt =
            '''
          Merge the copied text content into the XFDF file content. Hint text: $customValues.
          Ensure the copied text content matches the appropriate field names.
          Here are the details:
          Copied text content: $copiedTextContent,
          XFDF information: $exportedFormData.
          Provide the resultant XFDF directly.
          Please follow these conditions:
          1. The input data is not directly provided as the field name; you need to think and merge appropriately.
          2. When comparing input data and field names, ignore case sensitivity.
          3. First, determine the best match for the field name. If there isn't an exact match, use the input data to find a close match.
          4. Remove the xml code tags if they are present in the first and last lines of the code.''';

        response = await _sendMessage(prompt);

        if (response == null) {
          setState(() {
            _isBusy = false;
          });
          return;
        }
      } else {
        response = _getOfflineResponse(copiedTextContent);
      }
      if (response != null && response.isNotEmpty) {
        _fillPDF(response);
      } else {
        setState(() {
          _isBusy = false;
        });
      }
    } catch (e) {
      setState(() {
        _isBusy = false;
      });
    }
  }

  Future<void> _fillPDF(String xfdfString) async {
    const utf8 = Utf8Codec();
    final List<int> xfdfBytes = utf8.encode(xfdfString);
    _pdfViewerController.importFormData(xfdfBytes, DataFormat.xfdf);
    setState(() {
      _isBusy = false;
    });
  }

  String _getXFDFString() {
    final List<int> xfdfBytes = _pdfViewerController.exportFormData(
      dataFormat: DataFormat.xfdf,
    );
    const utf8 = Utf8Codec();
    final String xfdfString = utf8.decode(xfdfBytes);
    return xfdfString;
  }

  String _getHintText() {
    final List<PdfFormField> fields = _pdfViewerController.getFormFields();

    String hintData = '';
    for (final PdfFormField field in fields) {
      // Check if the form field is a ComboBox
      if (field is PdfComboBoxFormField) {
        // Append ComboBox name and items to the hintData string
        hintData += '\n${field.name} : Collection of Items are : ';
        for (final String item in field.items) {
          hintData += '$item, ';
        }
      }
      // Check if the form field is a RadioButton
      else if (field is PdfRadioFormField) {
        // Append RadioButton name and items to the hintData string
        hintData += '${'\n${field.name}'} : Collection of Items are : ';
        for (final String item in field.items) {
          hintData += '$item, ';
        }
      }
      // Check if the form field is a ListBox
      else if (field is PdfListBoxFormField) {
        // Append ListBox name and items to the hintData string
        hintData += '${'\n${field.name}'} : Collection of Items are : ';
        for (final String item in field.items) {
          hintData += '$item, ';
        }
      }
      // Check if the form field name contains 'Date', 'dob', or 'date'
      else if (field.name.contains('Date') ||
          field.name.contains('dob') ||
          field.name.contains('date')) {
        // Append instructions for date format to the hintData string
        hintData += '${'\n${field.name}'} : Write Date in MMM/dd/YYYY format';
      }
      // Append other form field names to the hintData string
      else {
        hintData += 'Can you please enter :\n${field.name}';
      }
    }
    return hintData;
  }

  /// Save document
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
      final File file = File('$path/$fileName');
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

  /// Alert dialog for save and export
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
          contentPadding: EdgeInsets.only(
            left: 24.0,
            top: _useMaterial3 ? 16.0 : 20.0,
            right: 24.0,
          ),
          actionsPadding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 16.0,
          ),
        );
      },
    );
  }

  Future<void> _saveDocumentHandler() async {
    final List<int> savedBytes = await _pdfViewerController.saveDocument();
    _saveDocument(
      savedBytes,
      'The document was saved at the location ',
      'form.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the device is mobile and in portrait mode or a non-web environment.
    final isMobile =
        !_isWeb && MediaQuery.of(context).orientation != Orientation.landscape;

    // Determine the width of the list panel based on device type and orientation.
    final listWidth =
        model.isMobile &&
            MediaQuery.of(context).orientation == Orientation.landscape
        ? MediaQuery.of(context).size.width / 3
        : MediaQuery.of(context).size.width / 4;

    // Function to build the PDF viewer widget.
    Widget pdfViewer() {
      return Stack(
        children: [
          // Display PDF from the asset using SfPdfViewer.
          SfPdfViewer.asset(
            'assets/pdf/smart-form.pdf',
            controller: _pdfViewerController,
            key: _pdfViewerKey,
            initialScrollOffset: const Offset(0, 110),
            onDocumentLoaded: (details) {
              // Export empty fields in the form.
              details.document.form.exportEmptyFields = true;
              setState(() => _isDocumentLoaded = true);
              _checkClipboard();
            },
          ),
          if (_isBusy)
            // Display loading indicator when busy.
            Container(
              color: Colors.black12,
              child: const Center(child: CircularProgressIndicator()),
            ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: FloatingActionButton(
                heroTag: 'Save',
                onPressed: _saveDocumentHandler,
                child: Icon(
                  Icons.save,
                  color: _useMaterial3
                      ? Theme.of(context).colorScheme.onSurfaceVariant
                      : Theme.of(context).colorScheme.brightness ==
                            Brightness.light
                      ? Colors.black.withValues(alpha: 0.54)
                      : Colors.white.withValues(alpha: 0.65),
                ),
              ),
            ),
          ),
        ],
      );
    }

    // Build individual list item card.
    Widget listItem(int index) {
      return Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.shade300),
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16).copyWith(
          top: index == 0 ? 16 : 8,
          bottom: index == _userDetails.length - 1 ? 16 : 8,
        ),
        elevation: 4,
        child: Padding(
          padding: isMobile
              ? const EdgeInsets.all(16.0)
              : const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  _userDetails[index],
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Padding(
                padding: isMobile
                    ? const EdgeInsets.only(left: 16.0)
                    : const EdgeInsets.only(left: 12.0),
                child: Tooltip(
                  message: 'Copy',
                  child: GestureDetector(
                    onTap: () {
                      // Copy the data to clipboard and update UI.
                      _copyToClipboard(_userDetails[index]);
                      setState(() {
                        _isCopied[index] = true;
                        _isButtonEnabled = true;
                      });
                      Future.delayed(const Duration(seconds: 1), () {
                        setState(() => _isCopied[index] = false);
                      });
                    },
                    child: Icon(
                      // Show check or copy icon based on whether data is copied.
                      _isCopied[index] ?? false ? Icons.check : Icons.copy,
                      key: ValueKey(
                        _isCopied[index] ?? false
                            ? 'check_$index'
                            : 'copy_$index',
                      ),
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Build the list view of items.
    Widget listView() {
      return Visibility(
        visible: _isDocumentLoaded,
        child: ListView.builder(
          itemCount: _userDetails.length,
          itemBuilder: (context, index) => listItem(index),
        ),
      );
    }

    return Scaffold(
      appBar: isMobile
          ? AppBar(
              automaticallyImplyLeading: false,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: _addTooltip(
                    _buildAIButton(),
                    'Click to smart fill the form',
                  ),
                ),
              ],
              elevation: 2.0,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(0),
                child: Container(height: 0.75, color: model.dividerColor),
              ),
            )
          : null,
      body: isMobile
          ? Column(
              children: [
                Expanded(flex: 4, child: pdfViewer()),
                Visibility(
                  visible: _isDocumentLoaded,
                  child: Flexible(
                    flex: _isExpanded ? 8 : 3,
                    child: Column(
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                          onTap: () =>
                              setState(() => _isExpanded = !_isExpanded),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: model.dividerColor),
                                bottom: BorderSide(color: model.dividerColor),
                              ),
                              color: _useMaterial3
                                  ? Theme.of(context).colorScheme.brightness ==
                                            Brightness.light
                                        ? const Color.fromRGBO(247, 242, 251, 1)
                                        : const Color.fromRGBO(37, 35, 42, 1)
                                  : Theme.of(context).colorScheme.brightness ==
                                        Brightness.light
                                  ? const Color(0xFFFAFAFA)
                                  : const Color(0xFF424242),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8.0,
                                    bottom: 4.0,
                                  ),
                                  child: Icon(
                                    _isExpanded
                                        ? Icons.keyboard_arrow_down
                                        : Icons.keyboard_arrow_up,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 4.0,
                                    bottom: 8.0,
                                  ),
                                  child: Text(
                                    'Sample Content to copy',
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(child: listView()),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(child: pdfViewer()),
                Container(
                  // Display the list panel next to PDF viewer on larger screens.
                  width: listWidth,
                  height: MediaQuery.of(context).size.height,
                  color: _useMaterial3
                      ? Theme.of(context).colorScheme.brightness ==
                                Brightness.light
                            ? const Color.fromRGBO(247, 242, 251, 1)
                            : const Color.fromRGBO(37, 35, 42, 1)
                      : Theme.of(context).colorScheme.brightness ==
                            Brightness.light
                      ? const Color(0xFFFAFAFA)
                      : const Color(0xFF424242),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: model.dividerColor,
                              width: 0.75,
                            ),
                          ),
                        ),
                        height: 64.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  'Sample Content to copy',
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: _addTooltip(
                                  _buildAIButton(),
                                  'Click to smart fill the form',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(child: listView()),
                    ],
                  ),
                ),
              ],
            ),
    );
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
      constraints: _useMaterial3 ? const BoxConstraints(maxHeight: 48) : null,
      padding: _useMaterial3
          ? const EdgeInsets.symmetric(horizontal: 16, vertical: 14)
          : null,
      message: _isButtonEnabled ? message : '',
      child: child,
    );
  }

  Widget _buildAIButton() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        return Transform.scale(
          scale: _isButtonEnabled ? _animation.value : 1,
          child: FloatingActionButton(
            heroTag: 'Smart button',
            mini: true,
            backgroundColor: _isButtonEnabled
                ? model.primaryColor
                : Colors.transparent,
            onPressed: _isButtonEnabled ? _smartFill : null,
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
}
