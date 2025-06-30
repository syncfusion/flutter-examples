import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:syncfusion_flutter_chat/assist_view.dart';

import '../../model/sample_view.dart';
import '../helper/ai_pop_up_api_key.dart';
import 'common.dart';

class AssistViewCustomizationSample extends SampleView {
  const AssistViewCustomizationSample(Key key) : super(key: key);

  @override
  AssistViewState createState() => AssistViewState();
}

class AssistViewState extends SampleViewState {
  final AssistMessageAuthor _userAuthor = const AssistMessageAuthor(
    id: 'Emile Kraven',
    name: 'Emile Kraven',
  );
  final AssistMessageAuthor _aiAuthor = const AssistMessageAuthor(
    id: 'AI',
    name: 'AI',
  );

  late List<AssistMessage> _messages;
  late List<String> _bubbleAlignments;
  late List<String> _positiveFeedbacks;
  late List<String> _negativeFeedbacks;
  late List<int> _selectedChipFeedbackIndices;

  late TextEditingController _placeholderTextController;
  late TextEditingController _composerTextController;
  late TextEditingController _feedbackTextController;

  bool _isPositiveFeedback = false;
  bool _enableActionButton = false;
  bool _lightTheme = true;

  int _footerMessageIndex = -1;
  String _feedbackText = '';
  String _placeholderText = '';

  Timer? _copyTimer;
  String _selectedAlignment = 'Start';
  AssistMessageAlignment _bubbleAlignment = AssistMessageAlignment.start;

  void _handleActionButtonVisibility() {
    setState(() {
      if (_composerTextController.text.isNotEmpty) {
        _enableActionButton = true;
      } else {
        _enableActionButton = false;
      }
    });
  }

  Widget _buildComposer(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.blue, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32.0),
      ),
      padding: const EdgeInsets.all(3.0),
      child: TextField(
        maxLines: 5,
        minLines: 1,
        controller: _composerTextController,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: model.themeData.colorScheme.surface,
          hoverColor: model.themeData.colorScheme.surface,
          focusColor: model.themeData.colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide.none,
          ),
          hintText: 'Ask AI here..',
          hintStyle: TextStyle(color: model.textColor),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 16.0,
          ),
        ),
      ),
    );
  }

  AssistActionButton _buildActionButton() {
    final Color actionButtonStateColor = _enableActionButton
        ? const Color.fromARGB(255, 140, 34, 159)
        : Colors.transparent;
    return AssistActionButton(
      foregroundColor: !_enableActionButton ? Colors.grey[400] : Colors.white,
      backgroundColor: actionButtonStateColor,
      hoverColor: actionButtonStateColor,
      splashColor: actionButtonStateColor,
      focusColor: actionButtonStateColor,
      onPressed: _enableActionButton
          ? (String prompt) {
              if (_composerTextController.text.isNotEmpty) {
                _handleSendButtonPressed(_composerTextController.text);
                _composerTextController.clear();
              }
            }
          : null,
    );
  }

  void _handleSendButtonPressed(String prompt) {
    _addMessageAndRebuild(AssistMessage.request(data: prompt));

    if (model.assistApiKey.isEmpty) {
      Timer.periodic(const Duration(milliseconds: 500), (Timer timer) {
        setState(() {
          _addMessageAndRebuild(
            AssistMessage.response(
              data:
                  'Please connect to your preferred AI server for real-time queries.',
              author: _aiAuthor,
              toolbarItems: _buildToolbarItems(),
            ),
          );
          timer.cancel();
        });
      });
    } else {
      _generateResponse(prompt);
    }
  }

  List<AssistMessageToolbarItem> _buildToolbarItems() {
    return <AssistMessageToolbarItem>[
      AssistMessageToolbarItem(
        content: _toolbarItem(Icons.thumb_up_off_alt),
        tooltip: 'Good Response',
      ),
      AssistMessageToolbarItem(
        content: _toolbarItem(Icons.thumb_down_off_alt),
        tooltip: 'Bad Response',
      ),
      AssistMessageToolbarItem(
        content: _toolbarItem(Icons.copy),
        tooltip: 'Copy',
      ),
      AssistMessageToolbarItem(
        content: _toolbarItem(Icons.restart_alt),
        tooltip: 'Regenerate',
      ),
    ];
  }

  Widget _toolbarItem(IconData data) {
    return Icon(data, size: 20);
  }

  SelectionArea _buildAIAssistView(
    AssistComposer? composer,
    AssistActionButton? actionButton,
  ) {
    return SelectionArea(
      child: SfAIAssistView(
        messages: _messages,
        composer: composer,
        actionButton: actionButton,
        placeholderBuilder: _buildPlaceholder,
        messageAvatarBuilder: _buildAvatar,
        messageContentBuilder: _bubbleContent,
        responseLoadingBuilder: _buildResponseLoader,
        messageFooterBuilder: _buildFeedbackContainer,
        onToolbarItemSelected: _handleToolbarItemSelected,
        placeholderBehavior: AssistPlaceholderBehavior.hideOnMessage,
        messageAlignment: _bubbleAlignment,
        responseMessageSettings: AssistMessageSettings(
          widthFactor: model.isWebFullView ? 0.9 : 1.0,
          showAuthorAvatar: true,
        ),
        requestMessageSettings: AssistMessageSettings(
          widthFactor: model.isWebFullView ? 0.9 : 1.0,
          showAuthorAvatar: true,
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const _GradientText(
              'Ask AI Anything!',
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            const SizedBox(height: 10.0),
            _GradientBorder(
              gradient: const LinearGradient(
                colors: [Colors.blue, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              width: 2.0,
              borderRadius: const Radius.circular(15.0),
              child: _buildPlaceholderTextField(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Wrap(
                runAlignment: WrapAlignment.center,
                alignment: WrapAlignment.center,
                spacing: 10.0,
                runSpacing: 20.0,
                children: _generateQuickAccessTiles(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderTextField() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextField(
          maxLines: 5,
          minLines: 1,
          controller: _placeholderTextController,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
              borderSide: BorderSide.none,
            ),
            hoverColor: model.themeData.colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
              borderSide: BorderSide.none,
            ),
            hintText: 'Ask here..',
            contentPadding: const EdgeInsets.only(
              left: 20.0,
              top: 16,
              right: 20,
            ),
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.attach_file),
                    tooltip: 'Attach files is not supported now',
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton.filled(
                    onPressed: _placeholderTextController.text.isEmpty
                        ? null
                        : () {
                            _handleSendButtonPressed(
                              _placeholderTextController.text,
                            );
                            _placeholderTextController.clear();
                          },
                    icon: const Icon(Icons.arrow_upward_rounded),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _generateQuickAccessTiles() {
    return topics.map((topic) {
      return Column(
        children: <Widget>[
          InkWell(
            borderRadius: BorderRadius.circular(10.0),
            onTap: () => _handleQuickAccessTileTap(topic),
            child: _GradientBorder(
              gradient: const LinearGradient(
                colors: <Color>[Colors.blue, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              width: 2.0,
              borderRadius: const Radius.circular(10.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.arrow_outward,
                      color: model.textColor,
                      size: 20.0,
                    ),
                    Text(topic['title'].toString()),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 5.0),
        ],
      );
    }).toList();
  }

  void _handleQuickAccessTileTap(Map<String, String> topic) {
    _placeholderTextController.clear();
    _addMessageAndRebuild(
      AssistMessage.request(
        data: topic['title']!,
        time: DateTime.now(),
        author: _userAuthor,
      ),
    );
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _generateResponse(
          topic['title'].toString(),
          topic['description'].toString(),
        );
      });
    });
  }

  Future<void> _generateResponse(
    String prompt, [
    String localResponse = '',
  ]) async {
    final GenerativeModel aiModel = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: model.assistApiKey,
    );

    try {
      final GenerateContentResponse response = await aiModel.generateContent([
        Content.text(prompt),
      ]);
      _addResponseMessage(response.text!);
    } catch (err) {
      if (localResponse.isNotEmpty) {
        _addResponseMessage(localResponse);
      } else {
        _addResponseMessage('The given $err');
      }
    }
  }

  void _addResponseMessage(String response) {
    _addMessageAndRebuild(
      AssistMessage.response(
        data: response,
        time: DateTime.now(),
        author: _aiAuthor,
        toolbarItems: _buildToolbarItems(),
      ),
    );
  }

  void _addMessageAndRebuild(AssistMessage message) {
    setState(() {
      _clearFeedbackCache();
      _messages.add(message);
    });
  }

  Widget _buildAvatar(BuildContext context, int index, AssistMessage message) {
    return message.isRequested
        ? const CircleAvatar(child: Text('EK', style: TextStyle(fontSize: 12)))
        : Image.asset(
            _lightTheme
                ? 'images/ai_avatar_light.png'
                : 'images/ai_avatar_dark.png',
            color: model.themeData.colorScheme.primary,
          );
  }

  Widget _bubbleContent(
    BuildContext context,
    int index,
    AssistMessage message,
  ) {
    return message.isRequested
        ? _buildRequestContent(message)
        : _buildResponseContent(message);
  }

  Widget _buildRequestContent(AssistMessage message) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: model.themeData.colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(10.0),
          topRight: const Radius.circular(10.0),
          bottomLeft: _bubbleAlignment == AssistMessageAlignment.start
              ? Radius.zero
              : const Radius.circular(10.0),
          bottomRight: _bubbleAlignment != AssistMessageAlignment.start
              ? Radius.zero
              : const Radius.circular(10.0),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: _lightTheme
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.white.withValues(alpha: 0.2),
            offset: const Offset(2.0, 2.0),
            blurRadius: 5,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: MarkdownBody(
          data: message.data,
          styleSheet: MarkdownStyleSheet(p: TextStyle(color: model.textColor)),
        ),
      ),
    );
  }

  MarkdownBody _buildResponseContent(AssistMessage message) {
    return MarkdownBody(
      data: message.data,
      styleSheet: MarkdownStyleSheet(
        p: TextStyle(color: model.textColor),
        codeblockDecoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8.0),
        ),
        code: TextStyle(backgroundColor: Colors.grey[100]),
      ),
    );
  }

  Widget _buildResponseLoader(
    BuildContext context,
    int index,
    AssistMessage message,
  ) {
    return TypingIndicator(
      dotColor: model.themeData.colorScheme.onSurfaceVariant,
    );
  }

  Widget _buildFeedbackContainer(
    BuildContext context,
    int index,
    AssistMessage message,
  ) {
    final TextTheme textThemeData = Theme.of(context).textTheme;
    if (_footerMessageIndex == index) {
      final List<String> feedbacks = _isPositiveFeedback
          ? _positiveFeedbacks
          : _negativeFeedbacks;
      return ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: ColoredBox(
          color: model.themeData.colorScheme.surfaceContainerLow.withValues(
            alpha: 0.54,
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFeedbackBuilderHeader(textThemeData),
                _buildPredefinedFeedbackTiles(feedbacks),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextField(
                    controller: _feedbackTextController,
                    decoration: InputDecoration(
                      hintText: 'Share your feedback here..',
                      hintStyle: textThemeData.bodyMedium,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 16.0,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: FilledButton(
                    onPressed:
                        _selectedChipFeedbackIndices.isNotEmpty ||
                            _feedbackTextController.text.isNotEmpty
                        ? () {
                            setState(() {
                              _footerMessageIndex = -1;
                              _selectedChipFeedbackIndices.clear();
                            });
                          }
                        : null,
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildFeedbackBuilderHeader(TextTheme textThemeData) {
    return Row(
      children: <Widget>[
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'What prompted you to select this rating?',
                  style: textThemeData.titleMedium,
                ),
                TextSpan(
                  text: ' (Optional)',
                  style: textThemeData.titleSmall!.copyWith(
                    color: model.themeData.colorScheme.onSurface.withValues(
                      alpha: 0.54,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _footerMessageIndex = -1;
            });
          },
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _buildPredefinedFeedbackTiles(List<String> feedbacks) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: List.generate(feedbacks.length, (int index) {
          return ChoiceChip(
            label: Text(feedbacks[index]),
            selected: _selectedChipFeedbackIndices.contains(index),
            onSelected: (bool selected) {
              setState(() {
                if (selected) {
                  _selectedChipFeedbackIndices.add(index);
                } else {
                  _selectedChipFeedbackIndices.remove(index);
                }
              });
            },
          );
        }),
      ),
    );
  }

  void _clearFeedbackCache() {
    _footerMessageIndex = -1;
    _selectedChipFeedbackIndices.clear();
    _feedbackTextController.clear();
  }

  void _handleToolbarItemSelected(
    bool selected,
    int messageIndex,
    AssistMessageToolbarItem toolbarItem,
    int toolbarItemIndex,
  ) {
    if (toolbarItemIndex == 0) {
      _handleThumbUpClicked(
        selected,
        messageIndex,
        toolbarItem,
        toolbarItemIndex,
      );
    } else if (toolbarItemIndex == 1) {
      _handleThumbDownClicked(
        selected,
        messageIndex,
        toolbarItem,
        toolbarItemIndex,
      );
    } else if (toolbarItemIndex == 2) {
      _handleCopyClicked(selected, messageIndex, toolbarItem, toolbarItemIndex);
    } else if (toolbarItemIndex == 3) {
      _handleRegenerateItemClicked(
        selected,
        messageIndex,
        toolbarItem,
        toolbarItemIndex,
      );
    }
  }

  void _handleThumbUpClicked(
    bool selected,
    int messageIndex,
    AssistMessageToolbarItem toolbarItem,
    int toolbarItemIndex,
  ) {
    setState(() {
      _resetThumbDownIcon(messageIndex, toolbarItemIndex);
      _messages[messageIndex].toolbarItems![toolbarItemIndex] = toolbarItem
          .copyWith(
            content: _toolbarItem(Icons.thumb_up_alt),
            isSelected: true,
          );
      _clearFeedbackCache();
      _isPositiveFeedback = true;
      _footerMessageIndex = messageIndex;
    });
  }

  void _resetThumbDownIcon(int messageIndex, int thumbUpItemIndex) {
    final List<AssistMessageToolbarItem> toolbarItems =
        _messages[messageIndex].toolbarItems!;
    if (toolbarItems.isNotEmpty) {
      final int thumbDownItemIndex = thumbUpItemIndex + 1;
      final AssistMessageToolbarItem thumbDownItem =
          toolbarItems[thumbDownItemIndex];
      if (thumbDownItem.isSelected) {
        toolbarItems[thumbDownItemIndex] = thumbDownItem.copyWith(
          content: _toolbarItem(Icons.thumb_down_off_alt),
          isSelected: false,
        );
      }
    }
  }

  void _handleThumbDownClicked(
    bool selected,
    int messageIndex,
    AssistMessageToolbarItem toolbarItem,
    int toolbarItemIndex,
  ) {
    setState(() {
      _resetThumbUpIcon(messageIndex, toolbarItemIndex);
      _messages[messageIndex].toolbarItems![toolbarItemIndex] = toolbarItem
          .copyWith(
            content: _toolbarItem(Icons.thumb_down_alt),
            isSelected: true,
          );
      _clearFeedbackCache();
      _isPositiveFeedback = false;
      _footerMessageIndex = messageIndex;
    });
  }

  void _resetThumbUpIcon(int messageIndex, int thumbDownItemIndex) {
    final List<AssistMessageToolbarItem> toolbarItems =
        _messages[messageIndex].toolbarItems!;
    if (toolbarItems.isNotEmpty) {
      final int thumbUpItemIndex = thumbDownItemIndex - 1;
      final AssistMessageToolbarItem thumbUpItem =
          toolbarItems[thumbUpItemIndex];
      if (thumbUpItem.isSelected) {
        toolbarItems[thumbUpItemIndex] = thumbUpItem.copyWith(
          content: _toolbarItem(Icons.thumb_up_off_alt),
          isSelected: false,
        );
      }
    }
  }

  void _handleCopyClicked(
    bool selected,
    int messageIndex,
    AssistMessageToolbarItem toolbarItem,
    int toolbarItemIndex,
  ) {
    if (_copyTimer == null) {
      Clipboard.setData(ClipboardData(text: _messages[messageIndex].data));
      // Change the icon to done for a second.
      setState(() {
        _messages[messageIndex].toolbarItems![toolbarItemIndex] = toolbarItem
            .copyWith(content: _toolbarItem(Icons.done));
      });
      // Reset the icon to copy after a second.
      _copyTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        setState(() {
          _messages[messageIndex].toolbarItems![toolbarItemIndex] = toolbarItem
              .copyWith(content: _toolbarItem(Icons.copy));
        });
        timer.cancel();
        _copyTimer = null;
      });
    }
  }

  void _handleRegenerateItemClicked(
    bool selected,
    int messageIndex,
    AssistMessageToolbarItem toolbarItem,
    int toolbarItemIndex,
  ) {
    final String prompt = _messages[messageIndex - 1].data;
    _addMessageAndRebuild(AssistMessage.request(data: prompt));

    for (final Map<String, String> element in topics) {
      if (element['title'] == prompt) {
        _generateResponse(prompt, element['description'].toString());
        return;
      }
    }

    _generateResponse(prompt);
  }

  Widget _buildAIConfigurationSetting() {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
          width: 40,
          height: 40,
          child: IconButton(
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all<Color>(
                model.themeData.colorScheme.primary,
              ),
            ),
            tooltip: 'Configure AI',
            icon: const Icon(Icons.settings),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => WelcomeDialog(
                  primaryColor: model.primaryColor,
                  apiKey: model.assistApiKey,
                  onApiKeySaved: (newApiKey) {
                    setState(() {
                      model.assistApiKey = newApiKey;
                    });
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsOptionItem(
    String optionText,
    String value,
    List<String> dropDownItems,
    void Function(String?)? onChanged,
  ) {
    return SizedBox(
      width: 230.0,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              optionText,
              overflow: TextOverflow.clip,
              softWrap: false,
              style: TextStyle(fontSize: 16.0, color: model.textColor),
            ),
          ),
          DropdownButton<String>(
            dropdownColor: model.drawerBackgroundColor,
            focusColor: Colors.transparent,
            underline: Container(color: const Color(0xFFBDBDBD), height: 1),
            value: value,
            items: List<DropdownMenuItem<String>>.generate(
              dropDownItems.length,
              (int index) {
                return DropdownMenuItem<String>(
                  value: dropDownItems[index],
                  child: Text(
                    dropDownItems[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(color: model.textColor),
                  ),
                );
              },
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  void _handleAlignmentChange(String value) {
    setState(() {
      _selectedAlignment = value;
      switch (value) {
        case 'Start':
          _bubbleAlignment = AssistMessageAlignment.start;
          break;
        case 'End':
          _bubbleAlignment = AssistMessageAlignment.end;
          break;
        case 'Auto':
          _bubbleAlignment = AssistMessageAlignment.auto;
          break;
      }
    });
  }

  Widget _buildClearChat(StateSetter stateSetter) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.pressed)) {
              return model.themeData.colorScheme.onSurface;
            }
            return model.themeData.colorScheme.primary; // Default color
          }),
        ),
        onPressed: () {
          if (_messages.isNotEmpty) {
            setState(() {
              _messages.clear();
            });
            stateSetter(() {});
          }
        },
        child: Text(
          'Clear Chat',
          style: TextStyle(color: model.themeData.colorScheme.onPrimary),
        ),
      ),
    );
  }

  void _handleSubmitButtonVisibility() {
    if (_feedbackText.isEmpty && _feedbackTextController.text.isNotEmpty) {
      setState(() {
        _feedbackText = _feedbackTextController.text;
      });
    }

    if (_feedbackText.isNotEmpty && _feedbackTextController.text.isEmpty) {
      setState(() {
        _feedbackText = '';
      });
    }
  }

  void _handlePlaceholderSendButtonVisibility() {
    if (_placeholderText.isEmpty &&
        _placeholderTextController.text.isNotEmpty) {
      setState(() {
        _placeholderText = _placeholderTextController.text;
      });
    }

    if (_placeholderText.isNotEmpty &&
        _placeholderTextController.text.isEmpty) {
      setState(() {
        _placeholderText = '';
      });
    }
  }

  @override
  void initState() {
    _messages = <AssistMessage>[];
    _bubbleAlignments = ['Auto', 'Start', 'End'];
    _positiveFeedbacks = ['Correct', 'Relevant', 'Other'];
    _negativeFeedbacks = ['Incorrect', 'Irrelevant', 'Too Formal', 'Other'];
    _selectedChipFeedbackIndices = <int>[];

    _placeholderTextController = TextEditingController();
    _composerTextController = TextEditingController();
    _feedbackTextController = TextEditingController();

    _composerTextController.addListener(_handleActionButtonVisibility);
    _feedbackTextController.addListener(_handleSubmitButtonVisibility);
    _placeholderTextController.addListener(
      _handlePlaceholderSendButtonVisibility,
    );
    super.initState();

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
            },
          ),
        );
        model.isFirstTime = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _lightTheme = model.themeData.brightness == Brightness.light;
    return Stack(
      children: [
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double availableWidth = constraints.maxWidth;
            const double maxExpectedWidth = 750.0;
            final bool canCenter = availableWidth > maxExpectedWidth;
            final EdgeInsets padding = canCenter
                ? const EdgeInsets.symmetric(vertical: 10.0)
                : const EdgeInsets.all(10.0);
            final AssistComposer? composer = _messages.isNotEmpty
                ? AssistComposer.builder(builder: _buildComposer)
                : null;
            final AssistActionButton? actionButton = _messages.isNotEmpty
                ? _buildActionButton()
                : null;

            return Padding(
              padding: padding,
              child: Center(
                child: SizedBox(
                  width: canCenter ? maxExpectedWidth : availableWidth,
                  child: _buildAIAssistView(composer, actionButton),
                ),
              ),
            );
          },
        ),
        Positioned(
          top: -45,
          right: -45,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: Container(
              color: model.themeData.colorScheme.surface,
              height: 100,
              width: 100,
            ),
          ),
        ),
        _buildAIConfigurationSetting(),
      ],
    );
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            _buildSettingsOptionItem(
              'Bubble alignment',
              _selectedAlignment,
              _bubbleAlignments,
              (String? value) {
                _handleAlignmentChange(value.toString());
                stateSetter(() {});
              },
            ),
            _buildClearChat(stateSetter),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _messages.clear();
    _bubbleAlignments.clear();
    _positiveFeedbacks.clear();
    _negativeFeedbacks.clear();

    _composerTextController.removeListener(_handleActionButtonVisibility);
    _feedbackTextController.removeListener(_handleSubmitButtonVisibility);

    _placeholderTextController.dispose();
    _composerTextController.dispose();
    _feedbackTextController.dispose();
    super.dispose();
  }
}

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key, required this.dotColor});

  final Color dotColor;

  @override
  TypingIndicatorState createState() => TypingIndicatorState();
}

class TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List<Widget>.generate(3, (int index) {
          return Padding(
            padding: index == 0
                ? const EdgeInsetsDirectional.only(start: 48.0, end: 4.0)
                : const EdgeInsets.symmetric(horizontal: 4.0),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget? child) {
                return Opacity(
                  opacity: Tween<double>(begin: 0.2, end: 1.0)
                      .animate(
                        CurvedAnimation(
                          parent: _controller,
                          curve: Interval(
                            index * 0.2,
                            0.1 + index * 0.2,
                            curve: Curves.easeInOut,
                          ),
                        ),
                      )
                      .value,
                  child: Container(
                    width: 7.0,
                    height: 7.0,
                    decoration: BoxDecoration(
                      color: widget.dotColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _GradientText extends StatelessWidget {
  const _GradientText(
    this.text, {
    required this.gradient,
    this.style = const TextStyle(),
  });

  final String text;
  final TextStyle style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) => gradient.createShader(
        Rect.fromLTWH(0.0, 0.0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style.copyWith(color: Colors.white)),
    );
  }
}

class _GradientBorder extends SingleChildRenderObjectWidget {
  const _GradientBorder({
    required this.gradient,
    required this.width,
    required this.borderRadius,
    required super.child,
  });

  final Gradient gradient;
  final double width;
  final Radius borderRadius;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderGradientBorder(
      gradient: gradient,
      width: width,
      borderRadius: borderRadius,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderGradientBorder renderObject,
  ) {
    renderObject
      ..gradient = gradient
      ..width = width
      ..borderRadius = borderRadius;
  }
}

class _RenderGradientBorder extends RenderProxyBox {
  _RenderGradientBorder({
    required Gradient gradient,
    required double width,
    required Radius borderRadius,
  }) : _gradient = gradient,
       _width = width,
       _borderRadius = borderRadius;

  Gradient? get gradient => _gradient;
  Gradient? _gradient;
  set gradient(Gradient? value) {
    if (_gradient != value) {
      _gradient = value;
      markNeedsPaint();
    }
  }

  double get width => _width;
  double _width = 1.0;
  set width(double value) {
    if (_width != value) {
      _width = value;
      markNeedsPaint();
    }
  }

  Radius get borderRadius => _borderRadius;
  Radius _borderRadius = Radius.zero;
  set borderRadius(Radius value) {
    if (_borderRadius != value) {
      markNeedsPaint();
      _borderRadius = value;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      context.paintChild(child!, offset);

      final Rect rect = offset & size;
      final Paint paint = Paint()
        ..shader = gradient!.createShader(rect)
        ..strokeWidth = width
        ..style = PaintingStyle.stroke;
      final RRect rrect = RRect.fromRectAndRadius(rect, borderRadius);
      context.canvas.drawRRect(rrect, paint);
    }
  }
}
