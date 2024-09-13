import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_chat/chat.dart';

import '../../model/model.dart';
import '../../model/sample_view.dart';
import 'helper.dart';

class ChatCustomizationSample extends SampleView {
  const ChatCustomizationSample(Key key) : super(key: key);

  @override
  State createState() => ChatCustomizationSampleState();
}

class ChatCustomizationSampleState extends SampleViewState {
  late List<ChatMessageExt> _messages;
  late TextEditingController _textController;
  late int _messageCount;

  Widget _buildBubbleHeader(
      BuildContext context, int index, ChatMessage message) {
    final String? previousAuthor =
        index == 0 ? null : _messages[index - 1].author.id;
    final String currentAuthor = message.author.id;
    if (previousAuthor == null || previousAuthor != currentAuthor) {
      // Space between two message group.
      return const SizedBox(height: 10);
    } else {
      return const SizedBox(width: 0, height: 0);
    }
  }

  Widget _buildBubbleAvatar(
      BuildContext context, int index, ChatMessage message) {
    final SampleModel model = SampleModel.instance;
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        maxRadius: 30,
                        backgroundImage: message.author.avatar,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message.author.name,
                              style: TextStyle(
                                color: model.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: Icon(Icons.chat_outlined, size: 15),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: Icon(Icons.phone_outlined, size: 15),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child:
                                        Icon(Icons.videocam_outlined, size: 15),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Divider(height: 5),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.phone,
                                size: 15, color: model.primaryColor),
                            const Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text('1234567890'),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Row(
                            children: [
                              Icon(Icons.mail,
                                  size: 15, color: model.primaryColor),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  '${message.author.name.toLowerCase()}@gmail.com',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
      child: CircleAvatar(
        backgroundImage: message.author.avatar,
      ),
    );
  }

  BorderRadius _borderRadius(int index, ChatMessage message) {
    const Radius maxRadius = Radius.circular(7.5);
    const Radius minRadius = Radius.zero;

    final bool isFirstMessageFromAuthor =
        _isFirstMessageFromAuthor(index, message);
    final bool isLastMessageFromAuthor =
        !isFirstMessageFromAuthor && _isLastMessageFromAuthor(index, message);
    final bool isSameAuthorMessage =
        !isFirstMessageFromAuthor && !isLastMessageFromAuthor;

    if (_isOutgoingMessage(message)) {
      return BorderRadius.only(
        topLeft: maxRadius,
        bottomLeft: maxRadius,
        topRight: isLastMessageFromAuthor || isSameAuthorMessage
            ? minRadius
            : maxRadius,
        bottomRight: isFirstMessageFromAuthor || isSameAuthorMessage
            ? minRadius
            : maxRadius,
      );
    } else {
      return BorderRadius.only(
        topLeft: isLastMessageFromAuthor || isSameAuthorMessage
            ? minRadius
            : maxRadius,
        bottomLeft: isFirstMessageFromAuthor || isSameAuthorMessage
            ? minRadius
            : maxRadius,
        topRight: maxRadius,
        bottomRight: maxRadius,
      );
    }
  }

  bool _isOutgoingMessage(ChatMessage message) {
    final String currentAuthor = message.author.id;
    return currentAuthor == 'Felipe';
  }

  bool _isFirstMessageFromAuthor(int index, ChatMessage message) {
    final String? previousAuthor =
        index == 0 ? null : _messages[index - 1].author.id;
    final String currentAuthor = message.author.id;
    return previousAuthor == null || previousAuthor != currentAuthor;
  }

  bool _isLastMessageFromAuthor(int index, ChatMessage message) {
    final String currentAuthor = message.author.id;
    final String? nextAuthor =
        index == _messageCount - 1 ? null : _messages[index + 1].author.id;
    return nextAuthor == null || nextAuthor != currentAuthor;
  }

  Widget _buildBubbleContent(
      BuildContext context, int index, ChatMessage message) {
    Color bubbleColor;
    if (model.themeData.useMaterial3) {
      bubbleColor = _isOutgoingMessage(message)
          ? model.themeData.colorScheme.primary
          : model.themeData.colorScheme.secondaryContainer.withOpacity(0.5);
    } else {
      bubbleColor = _isOutgoingMessage(message)
          ? model.themeData.colorScheme.primary
          : model.themeData.colorScheme.primary.withOpacity(0.12);
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: bubbleColor,
        borderRadius: _borderRadius(index, message),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 10),
        child: _buildContentLayout(index, message),
      ),
    );
  }

  Widget _buildContentLayout(int index, ChatMessage message) {
    final bool isOutgoingMessage = _isOutgoingMessage(message);
    final String formattedTime = DateFormat('hh:mm a').format(message.time);
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isOutgoingMessage && _isFirstMessageFromAuthor(index, message))
              Text(
                message.author.name,
                style: TextStyle(
                  color: model.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(child: _buildText(message, isOutgoingMessage)),
                ],
              ),
            ),
          ],
        ),
        Transform.translate(
          offset: const Offset(0, 7),
          child: Text(
            formattedTime,
            style: TextStyle(
              color: isOutgoingMessage
                  ? model.themeData.colorScheme.surface.withOpacity(0.5)
                  : model.themeData.colorScheme.onSurface.withOpacity(0.5),
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildText(ChatMessage message, bool isOutgoingMessage) {
    final ChatMessageExt chatMessage = message as ChatMessageExt;
    final String text = chatMessage.text;
    final TextStyle textStyle = TextStyle(
      color: isOutgoingMessage
          ? model.themeData.colorScheme.surface
          : model.themeData.colorScheme.onSurface,
    );
    Widget result;
    if (chatMessage.link != null) {
      result = Theme(
        data: model.themeData.copyWith(
          textSelectionTheme: TextSelectionThemeData(
            selectionColor: model.themeData.colorScheme.surface,
          ),
        ),
        child: SelectableText.rich(
          TextSpan(
            children: [
              TextSpan(text: text, style: textStyle),
              TextSpan(
                text: chatMessage.link,
                recognizer: TapGestureRecognizer()..onTap = () => launchURL(),
                style: TextStyle(
                  color: model.themeData.useMaterial3
                      ? Colors.blue
                      : Colors.purple,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      result = Theme(
        data: model.themeData.copyWith(
          textSelectionTheme: const TextSelectionThemeData(
            selectionColor: Color.fromRGBO(33, 146, 239, 0.4),
          ),
        ),
        child: SelectableText(text, style: textStyle),
      );
    }

    return result;
  }

  Widget _buildComposer(BuildContext context) {
    Color fillColor;
    if (model.themeData.useMaterial3) {
      fillColor = model.themeData.colorScheme.primaryContainer;
    } else {
      fillColor = model.themeData.colorScheme.primary;
    }

    return TextField(
      maxLines: 5,
      minLines: 1,
      controller: _textController,
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor.withOpacity(0.32),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(32),
        ),
        suffixIcon: _buildSendButton(),
        hintText: 'Type a message',
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
    );
  }

  AnimatedScale _buildSendButton() {
    return AnimatedScale(
      scale: _textController.text.trim().isNotEmpty ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 150),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
          width: 40,
          height: 40,
          child: FloatingActionButton(
            elevation: 0,
            hoverElevation: 0,
            highlightElevation: 0,
            shape: const CircleBorder(),
            backgroundColor: model.primaryColor,
            onPressed: _handleSendButtonClicked,
            child: Icon(
              CupertinoIcons.paperplane,
              color: model.themeData.colorScheme.surface,
            ),
          ),
        ),
      ),
    );
  }

  void _handleSendButtonClicked() {
    setState(() {
      _messages.add(
        ChatMessageExt(
          text: _textController.text,
          time: DateTime.now(),
          author: const ChatAuthor(
            id: 'Felipe',
            name: 'Felipe',
            avatar: AssetImage('images/People_Circle13.png'),
          ),
        ),
      );
      _messageCount = _messages.length;
      _textController.clear();
    });
  }

  void _handleTextChange() {
    setState(() {});
  }

  @override
  void initState() {
    _textController = TextEditingController()..addListener(_handleTextChange);
    _messages = chatCustomizationData(customTime: true);
    _messageCount = _messages.length;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
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
            child: SfChat(
              messages: _messages,
              outgoingUser: 'Felipe',
              incomingBubbleSettings: const ChatBubbleSettings(
                showUserName: false,
                showTimestamp: false,
                headerPadding: EdgeInsets.zero,
                contentPadding: EdgeInsets.zero,
                padding: EdgeInsets.symmetric(vertical: 0.5),
              ),
              outgoingBubbleSettings: const ChatBubbleSettings(
                showUserName: false,
                showTimestamp: false,
                showUserAvatar: false,
                headerPadding: EdgeInsets.zero,
                contentPadding: EdgeInsets.zero,
                padding: EdgeInsets.symmetric(vertical: 0.5),
              ),
              bubbleHeaderBuilder: _buildBubbleHeader,
              bubbleAvatarBuilder: _buildBubbleAvatar,
              bubbleContentBuilder: _buildBubbleContent,
              composer: ChatComposer.builder(builder: _buildComposer),
            ),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _messages.clear();
    _textController
      ..removeListener(_handleTextChange)
      ..dispose();
    super.dispose();
  }
}
