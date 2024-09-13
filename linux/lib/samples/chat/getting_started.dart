import 'dart:async';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_chat/chat.dart';

import '../../model/sample_view.dart';
import 'helper.dart';

class ChatGettingStartedSample extends SampleView {
  const ChatGettingStartedSample(Key key) : super(key: key);

  @override
  SampleViewState createState() => _ChatViewState();
}

class _ChatViewState extends SampleViewState {
  late List<ChatMessage> _conversations;
  late List<ChatMessage> _messages;
  late int _messagesCount;
  late Timer _timer;

  void _updateMessage(Timer timer) {
    if (timer.tick == _messagesCount || _conversations.isEmpty) {
      timer.cancel();
      return;
    }
    setState(() {
      _messages.add(_conversations.removeAt(0));
    });
  }

  @override
  void initState() {
    _conversations = chatGettingStartedData();
    _messagesCount = _conversations.length;
    _messages = <ChatMessage>[];
    _timer = Timer.periodic(const Duration(milliseconds: 1500), _updateMessage);
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
              outgoingUser: 'Cristina',
              outgoingBubbleSettings: const ChatBubbleSettings(
                showUserAvatar: false,
                showUserName: false,
              ),
              composer: const ChatComposer(
                decoration: InputDecoration(hintText: 'Type a message'),
              ),
              actionButton: ChatActionButton(
                onPressed: (String newMessage) {
                  setState(() {
                    _messages.add(ChatMessage(
                      text: newMessage,
                      time: DateTime.now(),
                      author:
                          const ChatAuthor(id: 'Cristina', name: 'Cristina'),
                    ));
                  });
                },
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _conversations.clear();
    _messages.clear();
    super.dispose();
  }
}
