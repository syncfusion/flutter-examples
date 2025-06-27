import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_chat/chat.dart';
import 'package:url_launcher/url_launcher.dart';

List<ChatMessage> chatGettingStartedData({bool customTime = false}) {
  return <ChatMessage>[
    ChatMessage(
      text:
          'Hey everyone, I attended a seminar on RenderBox and using '
          'gesture recognizers within it.',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 53))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Cristina',
        name: 'Cristina',
        avatar: AssetImage('images/People_Circle16.png'),
      ),
    ),
    ChatMessage(
      text:
          "I had also signed up for the seminar but couldn't attend "
          'due to health reasons.',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 51))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Travis',
        name: 'Travis',
        avatar: AssetImage('images/People_Circle23.png'),
      ),
    ),
    ChatMessage(
      text: 'Who else attended?',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 49))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Travis',
        name: 'Travis',
        avatar: AssetImage('images/People_Circle23.png'),
      ),
    ),
    ChatMessage(
      text: 'I didn’t even know about the seminar.',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 48))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Carrie',
        name: 'Carrie',
        avatar: AssetImage('images/People_Circle17.png'),
      ),
    ),
    ChatMessage(
      text:
          'Carrie and I attended. The seminar was really informative, '
          'and I now have a solid understanding of RenderBox '
          'and gesture recognizers.',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 47))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Johnson',
        name: 'Johnson',
        avatar: AssetImage('images/People_Circle27.png'),
      ),
    ),
    ChatMessage(
      text:
          'I’m currently working on a custom button using RenderBox, '
          'and I need help implementing a gesture recognizer. '
          'Can you guide me through it?',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 45))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Travis',
        name: 'Travis',
        avatar: AssetImage('images/People_Circle23.png'),
      ),
    ),
    ChatMessage(
      text:
          'It’s pretty simple! Just initialize the recognizer in the '
          'constructor, and then use the handleEvent method to manage the '
          'recognizer interactions.',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 42))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Cristina',
        name: 'Cristina',
        avatar: AssetImage('images/People_Circle16.png'),
      ),
    ),
    ChatMessage(
      text:
          'Cristina, don’t forget the hitTestSelf method to ensure '
          'handleEvent is triggered.',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 40))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Johnson',
        name: 'Johnson',
        avatar: AssetImage('images/People_Circle27.png'),
      ),
    ),
    ChatMessage(
      text: 'Oh, right! I almost missed that. Thanks for the reminder.',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 39))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Cristina',
        name: 'Cristina',
        avatar: AssetImage('images/People_Circle16.png'),
      ),
    ),
    ChatMessage(
      text:
          'I always thought handling recognizers was complicated. Is it '
          'really that easy?',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 36))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Anderson',
        name: 'Anderson',
        avatar: AssetImage('images/People_Circle14.png'),
      ),
    ),
    ChatMessage(
      text:
          'Yes! After the seminar, I realized how straightforward custom '
          'component implementation can be. Flutter is so enjoyable '
          'to code with!',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 35))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Johnson',
        name: 'Johnson',
        avatar: AssetImage('images/People_Circle27.png'),
      ),
    ),
    ChatMessage(
      text:
          'Building custom components with Flutter’s open-source tools '
          'is great. Thanks, Cristina—I’ll give your advice a try!',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 31))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Travis',
        name: 'Travis',
        avatar: AssetImage('images/People_Circle23.png'),
      ),
    ),
    ChatMessage(
      text:
          'I just looked into it, and Flutter seems to have a really '
          'promising future. It’s so efficient for building apps. '
          'I’m thinking of using it for my final year project.',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 29))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Carrie',
        name: 'Carrie',
        avatar: AssetImage('images/People_Circle17.png'),
      ),
    ),
    ChatMessage(
      text:
          ' What do you all think about teaming up to create something '
          'amazing for our final project?',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 28))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Carrie',
        name: 'Carrie',
        avatar: AssetImage('images/People_Circle17.png'),
      ),
    ),
    ChatMessage(
      text: 'Can I join?',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 26))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Cristina',
        name: 'Cristina',
        avatar: AssetImage('images/People_Circle16.png'),
      ),
    ),
    ChatMessage(
      text: "Absolutely, you're always welcome!",
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 24))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Carrie',
        name: 'Carrie',
        avatar: AssetImage('images/People_Circle17.png'),
      ),
    ),
    ChatMessage(
      text: 'Count me in.',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 21))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Travis',
        name: 'Travis',
        avatar: AssetImage('images/People_Circle23.png'),
      ),
    ),
    ChatMessage(
      text: 'Me too.',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 19))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Anderson',
        name: 'Anderson',
        avatar: AssetImage('images/People_Circle14.png'),
      ),
    ),
    ChatMessage(
      text: 'Same here.',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 17))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Johnson',
        name: 'Johnson',
        avatar: AssetImage('images/People_Circle27.png'),
      ),
    ),
    ChatMessage(
      text:
          'I have an idea! We could build a bot app for our college that '
          'provides information about the campus and admission procedures. '
          'If the project turns out well, the college might even buy it!',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 15))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Cristina',
        name: 'Cristina',
        avatar: AssetImage('images/People_Circle16.png'),
      ),
    ),
    ChatMessage(
      text: 'That’s an awesome idea! Let’s work hard to make it happen.',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 13))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Carrie',
        name: 'Carrie',
        avatar: AssetImage('images/People_Circle17.png'),
      ),
    ),
    ChatMessage(
      text:
          'You nailed it, Cristina. I’m excited to start. When do we kick off?',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 11))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Travis',
        name: 'Travis',
        avatar: AssetImage('images/People_Circle23.png'),
      ),
    ),
    ChatMessage(
      text:
          'This is the best idea I’ve heard! If we pull this off, '
          'landing a job at an MNC will be much easier.',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 9))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Anderson',
        name: 'Anderson',
        avatar: AssetImage('images/People_Circle14.png'),
      ),
    ),
    ChatMessage(
      text: 'Cristina, you’ve once again proven you’re the top of our class.',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 8))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Johnson',
        name: 'Johnson',
        avatar: AssetImage('images/People_Circle27.png'),
      ),
    ),
    ChatMessage(
      text:
          'Thanks, everyone! This Flutter app is going to be amazing. '
          'Let’s start working on it tomorrow.',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 8))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Cristina',
        name: 'Cristina',
        avatar: AssetImage('images/People_Circle16.png'),
      ),
    ),
    ChatMessage(
      text: 'We’ll meet at college tomorrow and go over the details.',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 8))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Travis',
        name: 'Travis',
        avatar: AssetImage('images/People_Circle23.png'),
      ),
    ),
    ChatMessage(
      text: ' For sure.',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 8))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Carrie',
        name: 'Carrie',
        avatar: AssetImage('images/People_Circle17.png'),
      ),
    ),
    ChatMessage(
      text:
          'I’ll work on a basic UI design and share it with everyone '
          'tomorrow for feedback.',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 8))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Johnson',
        name: 'Johnson',
        avatar: AssetImage('images/People_Circle27.png'),
      ),
    ),
    ChatMessage(
      text: 'You’re the best, Johnson. See you all tomorrow!',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 8))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Anderson',
        name: 'Anderson',
        avatar: AssetImage('images/People_Circle14.png'),
      ),
    ),
  ];
}

List<ChatMessageExt> chatCustomizationData({bool customTime = false}) {
  return <ChatMessageExt>[
    ChatMessageExt(
      text:
          'Hey Felipe, I watched a video about Flutter, and it made '
          'understanding Flutter widgets super easy, just like you said.',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 53))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Jonathan',
        name: 'Jonathan',
        avatar: AssetImage('images/People_Circle23.png'),
      ),
    ),
    ChatMessageExt(
      text:
          'I’ve decided to start learning Flutter. Can you guide me '
          'through the installation process?',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 53))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Jonathan',
        name: 'Jonathan',
        avatar: AssetImage('images/People_Circle23.png'),
      ),
    ),
    ChatMessageExt(
      text:
          'Hi Jonathan, I’d be happy to help. First, download the Dart '
          'and Flutter SDK for Windows.',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 51))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Felipe',
        name: 'Felipe',
        avatar: AssetImage('images/People_Circle14.png'),
      ),
    ),
    ChatMessageExt(
      text: "Here's the link to download Flutter: ",
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 51))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Felipe',
        name: 'Felipe',
        avatar: AssetImage('images/People_Circle14.png'),
      ),
      link: 'https://docs.flutter.dev/get-started/install/windows',
    ),
    ChatMessageExt(
      text: "I'll download it and ask you for more details once it’s done.",
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 49))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Jonathan',
        name: 'Jonathan',
        avatar: AssetImage('images/People_Circle23.png'),
      ),
    ),
    ChatMessageExt(
      text: 'Do you have Visual Studio Code installed?',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 48))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Felipe',
        name: 'Felipe',
        avatar: AssetImage('images/People_Circle14.png'),
      ),
    ),
    ChatMessageExt(
      text: 'No, I don’t have any development tools yet.',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 47))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Jonathan',
        name: 'Jonathan',
        avatar: AssetImage('images/People_Circle23.png'),
      ),
    ),
    ChatMessageExt(
      text:
          'In that case, download Visual Studio Code 2024 first, '
          'then proceed with the Flutter installation',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 45))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Felipe',
        name: 'Felipe',
        avatar: AssetImage('images/People_Circle14.png'),
      ),
    ),
    ChatMessageExt(
      text:
          "I've downloaded both Visual Studio Code and Flutter. "
          'What’s the next step?',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 42))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Jonathan',
        name: 'Jonathan',
        avatar: AssetImage('images/People_Circle23.png'),
      ),
    ),
    ChatMessageExt(
      text:
          'Great! Now you need to install extensions in Visual Studio Code. '
          'Download both the Flutter and Dart extensions.',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 40))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Felipe',
        name: 'Felipe',
        avatar: AssetImage('images/People_Circle14.png'),
      ),
    ),
    ChatMessageExt(
      text: 'I’ve installed the extensions.',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 39))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Jonathan',
        name: 'Jonathan',
        avatar: AssetImage('images/People_Circle23.png'),
      ),
    ),
    ChatMessageExt(
      text: 'Perfect! Now, add the Flutter SDK path in Visual Studio Code.',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 36))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Felipe',
        name: 'Felipe',
        avatar: AssetImage('images/People_Circle14.png'),
      ),
    ),
    ChatMessageExt(
      text:
          'Then follow this sequence: go to View -> Command Palette -> '
          'choose Flutter: New Project',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 36))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Felipe',
        name: 'Felipe',
        avatar: AssetImage('images/People_Circle14.png'),
      ),
    ),
    ChatMessageExt(
      text: 'This step is to create flutter project in VS code.',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 36))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Felipe',
        name: 'Felipe',
        avatar: AssetImage('images/People_Circle14.png'),
      ),
    ),
    ChatMessageExt(
      text: 'I’ve followed the steps and created a Flutter project',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 35))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Jonathan',
        name: 'Jonathan',
        avatar: AssetImage('images/People_Circle23.png'),
      ),
    ),
    ChatMessageExt(
      text:
          'Awesome! You can run the sample project by entering the flutter '
          'run command in the terminal, or you can click the build/run '
          'icon on the top bar to run it in debug mode.',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 31))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Felipe',
        name: 'Felipe',
        avatar: AssetImage('images/People_Circle14.png'),
      ),
    ),
    ChatMessageExt(
      text:
          'Wow, the UI looks amazing, and the code is really '
          'easy to understand.',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 29))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Jonathan',
        name: 'Jonathan',
        avatar: AssetImage('images/People_Circle23.png'),
      ),
    ),
    ChatMessageExt(
      text:
          'That’s the beauty of Flutter. It’s user-friendly and delivers '
          'excellent performance for mobile apps.',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 28))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Felipe',
        name: 'Felipe',
        avatar: AssetImage('images/People_Circle14.png'),
      ),
    ),
    ChatMessageExt(
      text:
          'I’m really enjoying building apps with Flutter. Everything '
          'being in widget form makes it so fun to work with!',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 26))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Jonathan',
        name: 'Jonathan',
        avatar: AssetImage('images/People_Circle23.png'),
      ),
    ),
    ChatMessageExt(
      text:
          'Exactly! With Flutter, you’ll be building apps like a '
          'pro in no time.',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 24))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Felipe',
        name: 'Felipe',
        avatar: AssetImage('images/People_Circle14.png'),
      ),
    ),
    ChatMessageExt(
      text: 'Thanks a lot for your help, Felipe.',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 21))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Jonathan',
        name: 'Jonathan',
        avatar: AssetImage('images/People_Circle23.png'),
      ),
    ),
    ChatMessageExt(
      text:
          'No problem at all, I’m always here to help! By the way, '
          'when are we celebrating your birthday?',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 19))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Felipe',
        name: 'Felipe',
        avatar: AssetImage('images/People_Circle14.png'),
      ),
    ),
    ChatMessageExt(
      text: 'Haha, you didn’t forget! I’ll treat you tomorrow',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 17))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Jonathan',
        name: 'Jonathan',
        avatar: AssetImage('images/People_Circle23.png'),
      ),
    ),
    ChatMessageExt(
      text: 'Nice! Let’s meet at Olive Restaurant tomorrow.',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 15))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Felipe',
        name: 'Felipe',
        avatar: AssetImage('images/People_Circle14.png'),
      ),
    ),
    ChatMessageExt(
      text:
          ' Sounds good, and you can teach me more about '
          'using Flutter efficiently',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 13))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Jonathan',
        name: 'Jonathan',
        avatar: AssetImage('images/People_Circle23.png'),
      ),
    ),
    ChatMessageExt(
      text: 'Definitely! See you tomorrow!',
      time: customTime
          ? DateTime.now().subtract(const Duration(minutes: 11))
          : DateTime.now(),
      author: const ChatAuthor(
        id: 'Felipe',
        name: 'Felipe',
        avatar: AssetImage('images/People_Circle14.png'),
      ),
    ),
  ];
}

Future<void> launchURL() {
  final Uri uri = Uri(
    scheme: 'https',
    host: 'docs.flutter.dev',
    path: 'get-started/install/windows',
  );
  return launchUrl(uri);
}

class ChatMessageExt extends ChatMessage {
  ChatMessageExt({
    required super.text,
    required super.time,
    required super.author,
    this.link,
  });

  final String? link;
}
