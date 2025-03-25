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
  List<ChatMessage> _messages = [];

  @override
  void initState() {
    _messages = chatGettingStartedData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ChatWidgetPage(messages: _messages));
  }
}

class ChatWidgetPage extends StatefulWidget {
  const ChatWidgetPage({super.key, required this.messages});

  final List<ChatMessage> messages;

  @override
  State<ChatWidgetPage> createState() => _ChatWidgetPageState();
}

class _ChatWidgetPageState extends State<ChatWidgetPage> {
  late List<ChatMessage> _messages;
  late int _messagesCount;
  late Timer _timer;

  void _updateMessage(Timer timer) {
    if (timer.tick == _messagesCount || widget.messages.isEmpty) {
      timer.cancel();
      return;
    }
    setState(() {
      _messages.add(widget.messages.removeAt(0));
    });
  }

  @override
  void initState() {
    _messagesCount = widget.messages.length;
    _messages = <ChatMessage>[];
    _timer = Timer.periodic(const Duration(milliseconds: 1500), _updateMessage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double availableWidth = MediaQuery.of(context).size.width;
    const double maxExpectedWidth = 750;
    final bool canCenter = availableWidth > maxExpectedWidth;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          width: canCenter ? maxExpectedWidth : availableWidth,
          child: SfChat(
            messages: _messages,
            outgoingUser: 'Cristina',
            outgoingMessageSettings: const ChatMessageSettings(
              showAuthorAvatar: false,
              showAuthorName: false,
            ),
            composer: const ChatComposer(
              decoration: InputDecoration(hintText: 'Type a message'),
            ),
            actionButton: ChatActionButton(
              onPressed: (String newMessage) {
                setState(() {
                  _messages.add(
                    ChatMessage(
                      text: newMessage,
                      time: DateTime.now(),
                      author: const ChatAuthor(
                        id: 'Cristina',
                        name: 'Cristina',
                      ),
                    ),
                  );
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _messages.clear();
    super.dispose();
  }
}
