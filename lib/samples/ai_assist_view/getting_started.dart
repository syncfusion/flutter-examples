import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:syncfusion_flutter_chat/assist_view.dart';

import '../../model/sample_view.dart';
import '../../widgets/custom_button.dart';
import '../helper/ai_pop_up_api_key.dart';
import 'common.dart';

class AssistViewGettingStartedSample extends SampleView {
  const AssistViewGettingStartedSample(Key key) : super(key: key);

  @override
  SampleViewState createState() => _AssistViewState();
}

class _AssistViewState extends SampleViewState {
  final AssistMessageAuthor _userAuthor = const AssistMessageAuthor(
    id: 'Emile Kraven',
    name: 'Emile Kraven',
  );
  final AssistMessageAuthor _aiAuthor = const AssistMessageAuthor(
    id: 'AI',
    name: 'AI',
  );

  late List<AssistMessage> _messages;
  late List<String> _bubbleAlignmentItem;
  late List<String> _placeholderBehaviorItem;

  double _widthFactor = 0.9;
  String _selectedAlignment = 'Auto';
  String _selectedBehavior = 'Scroll';
  AssistPlaceholderBehavior _placeholderBehavior =
      AssistPlaceholderBehavior.scrollWithMessage;
  AssistMessageAlignment _bubbleAlignment = AssistMessageAlignment.auto;

  bool _showRequestAvatar = true;
  bool _showRequestUserName = false;
  bool _showRequestTimestamp = false;
  bool _showResponseAvatar = true;
  bool _showResponseUserName = false;
  bool _showResponseTimestamp = false;
  bool _lightTheme = true;

  SelectionArea _buildAIAssistView() {
    return SelectionArea(
      child: SfAIAssistView(
        messages: _messages,
        placeholderBuilder: _buildPlaceholder,
        placeholderBehavior: _placeholderBehavior,
        messageAvatarBuilder: _buildAvatar,
        messageAlignment: _bubbleAlignment,
        requestMessageSettings: AssistMessageSettings(
          widthFactor: model.isWebFullView ? _widthFactor : 1.0,
          showAuthorAvatar: _showRequestAvatar,
          showTimestamp: _showRequestTimestamp,
          showAuthorName: _showRequestUserName,
        ),
        responseMessageSettings: AssistMessageSettings(
          widthFactor: model.isWebFullView ? _widthFactor : 1.0,
          showAuthorAvatar: _showResponseAvatar,
          showTimestamp: _showResponseTimestamp,
          showAuthorName: _showResponseUserName,
        ),
        composer: const AssistComposer(
          decoration: InputDecoration(hintText: 'Type message here...'),
        ),
        actionButton: AssistActionButton(onPressed: _handleActionButtonPressed),
        messageContentBuilder: (context, int index, AssistMessage message) {
          return MarkdownBody(data: message.data);
        },
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox.square(
            dimension: 80.0,
            child: Image.asset(
              _lightTheme
                  ? 'images/ai_avatar_light.png'
                  : 'images/ai_avatar_dark.png',
              color: model.primaryColor,
            ),
          ),
          const SizedBox(height: 10.0),
          const Text(
            'Ask AI Anything!',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 10.0,
              runSpacing: 10.0,
              children: _generateQuickAccessTiles(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _generateQuickAccessTiles() {
    return topics.map((topic) {
      return Column(
        children: [
          InkWell(
            onTapDown: (TapDownDetails details) =>
                _handleQuickAccessTileTap(topic),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2.0,
                  color: model.themeData.colorScheme.outlineVariant,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset(
                    topic['image']! +
                        (_lightTheme ? '_light.png' : '_dark.png'),
                    width: 20.0,
                    height: 20.0,
                  ),
                  const SizedBox(width: 10.0),
                  Text(
                    topic['title']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5.0),
        ],
      );
    }).toList();
  }

  void _handleQuickAccessTileTap(Map<String, String> topic) {
    _addMessageAndRebuild(
      AssistMessage.request(
        data: topic['title']!,
        author: _userAuthor,
        time: DateTime.now(),
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
        author: _aiAuthor,
        time: DateTime.now(),
      ),
    );
  }

  void _addMessageAndRebuild(AssistMessage message) {
    setState(() => _messages.add(message));
  }

  Widget _buildAvatar(BuildContext context, int index, AssistMessage message) {
    return message.isRequested
        ? Image.asset('images/People_Circle7.png')
        : Image.asset(
            _lightTheme
                ? 'images/ai_avatar_light.png'
                : 'images/ai_avatar_dark.png',
            color: model.themeData.colorScheme.primary,
          );
  }

  void _handleActionButtonPressed(String prompt) {
    _addMessageAndRebuild(
      AssistMessage.request(
        data: prompt,
        author: _userAuthor,
        time: DateTime.now(),
      ),
    );
    Future.delayed(const Duration(milliseconds: 500), () {
      if (model.assistApiKey.isEmpty) {
        _addMessageAndRebuild(
          AssistMessage.response(
            data:
                'Please connect to your preferred AI server for real-time queries.',
            author: _aiAuthor,
            time: DateTime.now(),
          ),
        );
      } else {
        _generateResponse(prompt);
      }
    });
  }

  Widget _buildAIConfigurationSetting() {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
          height: 40,
          width: 40,
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

  Widget _buildWidthFactorSetting() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text('Width factor', style: TextStyle(fontSize: 16)),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: CustomDirectionalButtons(
            maxValue: 1.0,
            minValue: 0.8,
            step: 0.05,
            initialValue: _widthFactor,
            onChanged: (double val) => setState(() {
              _widthFactor = val;
            }),
            iconColor: model.textColor,
            style: TextStyle(fontSize: 16.0, color: model.textColor),
          ),
        ),
      ],
    );
  }

  Widget _buildBubbleAlignmentSetting(StateSetter stateSetter) {
    return SizedBox(
      width: 230,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              'Bubble alignment',
              overflow: TextOverflow.clip,
              softWrap: false,
              style: TextStyle(fontSize: 16.0, color: model.textColor),
            ),
          ),
          DropdownButton<String>(
            dropdownColor: model.drawerBackgroundColor,
            focusColor: Colors.transparent,
            underline: Container(color: const Color(0xFFBDBDBD), height: 1.0),
            value: _selectedAlignment,
            items: _bubbleAlignmentItem.map((String value) {
              return DropdownMenuItem<String>(
                value: (value != null) ? value : 'Auto',
                child: Text(
                  value,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: model.textColor),
                ),
              );
            }).toList(),
            onChanged: (String? value) {
              stateSetter(() {
                _handleAlignmentChange(value.toString());
              });
            },
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

  Widget _buildPlaceholderBehaviorSetting(StateSetter stateSetter) {
    return SizedBox(
      width: 230,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              'Placeholder',
              overflow: TextOverflow.clip,
              softWrap: false,
              style: TextStyle(fontSize: 16.0, color: model.textColor),
            ),
          ),
          DropdownButton<String>(
            dropdownColor: model.drawerBackgroundColor,
            focusColor: Colors.transparent,
            underline: Container(color: const Color(0xFFBDBDBD), height: 1.0),
            value: _selectedBehavior,
            items: _placeholderBehaviorItem.map((String value) {
              return DropdownMenuItem<String>(
                value: (value != null) ? value : 'Scroll',
                child: Text(
                  value,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: model.textColor),
                ),
              );
            }).toList(),
            onChanged: (String? value) {
              stateSetter(() {
                _handlePlaceholderBehavior(value.toString());
              });
            },
          ),
        ],
      ),
    );
  }

  void _handlePlaceholderBehavior(String value) {
    setState(() {
      _selectedBehavior = value;
      switch (value) {
        case 'Scroll':
          _placeholderBehavior = AssistPlaceholderBehavior.scrollWithMessage;
          break;
        case 'Hide':
          _placeholderBehavior = AssistPlaceholderBehavior.hideOnMessage;
      }
    });
  }

  Padding _buildBubbleSettingTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 10),
      child: Text(
        title,
        overflow: TextOverflow.clip,
        softWrap: false,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: model.textColor,
        ),
      ),
    );
  }

  Widget _buildRequestShowAvatarSetting(StateSetter stateSetter) {
    return SizedBox(
      width: 200,
      child: CheckboxListTile(
        value: _showRequestAvatar,
        title: const Text('Show avatar', softWrap: false),
        activeColor: model.primaryColor,
        contentPadding: EdgeInsets.zero,
        onChanged: (bool? value) {
          setState(() {
            stateSetter(() {
              _showRequestAvatar = value!;
            });
          });
        },
      ),
    );
  }

  Widget _buildRequestShowTimestampSetting(StateSetter stateSetter) {
    return SizedBox(
      width: 200,
      child: CheckboxListTile(
        value: _showRequestTimestamp,
        title: const Text('Show timestamp', softWrap: false),
        activeColor: model.primaryColor,
        contentPadding: EdgeInsets.zero,
        onChanged: (bool? value) {
          setState(() {
            stateSetter(() {
              _showRequestTimestamp = value!;
            });
          });
        },
      ),
    );
  }

  Widget _buildRequestShowUserNameSetting(StateSetter stateSetter) {
    return SizedBox(
      width: 200,
      child: CheckboxListTile(
        value: _showRequestUserName,
        title: const Text('Show name', softWrap: false),
        activeColor: model.primaryColor,
        contentPadding: EdgeInsets.zero,
        onChanged: (bool? value) {
          setState(() {
            stateSetter(() {
              _showRequestUserName = value!;
            });
          });
        },
      ),
    );
  }

  Widget _buildResponseShowAvatarSetting(StateSetter stateSetter) {
    return SizedBox(
      width: 200,
      child: CheckboxListTile(
        value: _showResponseAvatar,
        title: const Text('Show avatar', softWrap: false),
        activeColor: model.primaryColor,
        contentPadding: EdgeInsets.zero,
        onChanged: (bool? value) {
          setState(() {
            stateSetter(() {
              _showResponseAvatar = value!;
            });
          });
        },
      ),
    );
  }

  Widget _buildResponseShowUserNameSetting(StateSetter stateSetter) {
    return SizedBox(
      width: 200,
      child: CheckboxListTile(
        value: _showResponseUserName,
        title: const Text('Show name', softWrap: false),
        activeColor: model.primaryColor,
        contentPadding: EdgeInsets.zero,
        onChanged: (bool? value) {
          setState(() {
            stateSetter(() {
              _showResponseUserName = value!;
            });
          });
        },
      ),
    );
  }

  Widget _buildResponseShowTimestampSetting(StateSetter stateSetter) {
    return SizedBox(
      width: 200,
      child: CheckboxListTile(
        value: _showResponseTimestamp,
        title: const Text('Show timestamp', softWrap: false),
        activeColor: model.primaryColor,
        contentPadding: EdgeInsets.zero,
        onChanged: (bool? value) {
          setState(() {
            stateSetter(() {
              _showResponseTimestamp = value!;
            });
          });
        },
      ),
    );
  }

  Widget _buildClearChatSetting() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color?>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.pressed)) {
              return model.themeData.colorScheme.onSurface;
            }
            return model.themeData.colorScheme.primary;
          }),
        ),
        onPressed: () {
          if (_messages.isNotEmpty) {
            setState(() {
              _messages.clear();
            });
          }
        },
        child: Text(
          'Clear Chat',
          style: TextStyle(color: model.themeData.colorScheme.onPrimary),
        ),
      ),
    );
  }

  @override
  void initState() {
    _messages = <AssistMessage>[];
    _bubbleAlignmentItem = ['Auto', 'Start', 'End'];
    _placeholderBehaviorItem = ['Scroll', 'Hide'];
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
            const double maxExpectedWidth = 750;
            final bool canCenter = availableWidth > maxExpectedWidth;
            return Padding(
              padding: canCenter
                  ? const EdgeInsets.symmetric(vertical: 10.0)
                  : const EdgeInsets.all(10.0),
              child: Center(
                child: SizedBox(
                  width: canCenter ? maxExpectedWidth : availableWidth,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: _buildAIAssistView(),
                  ),
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
          children: [
            _buildClearChatSetting(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWidthFactorSetting(),
                _buildBubbleAlignmentSetting(stateSetter),
                _buildPlaceholderBehaviorSetting(stateSetter),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildBubbleSettingTitle('Request bubble settings'),
                    _buildRequestShowAvatarSetting(stateSetter),
                    _buildRequestShowUserNameSetting(stateSetter),
                    _buildRequestShowTimestampSetting(stateSetter),
                    _buildBubbleSettingTitle('Response bubble settings'),
                    _buildResponseShowAvatarSetting(stateSetter),
                    _buildResponseShowUserNameSetting(stateSetter),
                    _buildResponseShowTimestampSetting(stateSetter),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _messages.clear();
    _bubbleAlignmentItem.clear();
    _placeholderBehaviorItem.clear();
    super.dispose();
  }
}
