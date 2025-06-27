import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WelcomeDialog extends StatefulWidget {
  const WelcomeDialog({
    Key? key,
    required this.primaryColor,
    required this.apiKey,
    required this.onApiKeySaved,
  }) : super(key: key);

  final Color primaryColor;
  final String apiKey;
  final Function(String) onApiKeySaved;

  @override
  _WelcomeDialogState createState() => _WelcomeDialogState();
}

class _WelcomeDialogState extends State<WelcomeDialog> {
  final ValueNotifier<int> _show = ValueNotifier<int>(0);
  late TextEditingController _apiKeyController;
  bool _isVisible = false;
  bool _isObscured = true;

  @override
  void initState() {
    super.initState();
    _apiKeyController = TextEditingController(text: widget.apiKey);
    _apiKeyController.addListener(_obscuredText);
  }

  void _obscuredText() {
    setState(() {
      if (_apiKeyController.text.isNotEmpty) {
        _show.value++;
        _isVisible = true;
      } else {
        _isVisible = false;
        _show.value++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return AlertDialog(
          surfaceTintColor: Colors.white,
          content: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: SizedBox(
              width: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTitle('About', widget.primaryColor),
                  const SizedBox(height: 10),
                  _buildAboutText(),
                  _buildApiKeyTextField(stateSetter),
                  const SizedBox(height: 10),
                  _buildRichText(
                    text:
                        '\nIf you prefer to explore this sample without an API key, you may close this pop-up. You can still access samples featuring AI responses that are stored locally',
                    linkText: '',
                    url: '',
                    trailingText: '.\n',
                  ),
                  _buildTitle('Disclaimer', widget.primaryColor),
                  const SizedBox(height: 10),
                  const Text(
                    'The API key you provide is not stored in Syncfusion; instead, it is sent to Google to obtain a response for your request. Both the API key and the request and response messages are deleted once your session ends.',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          actions: [_buildCloseButton(context)],
        );
      },
    );
  }

  Widget _buildTitle(String title, Color color) {
    return Text(
      title,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
    );
  }

  Widget _buildAboutText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRichText(
          text:
              'This is a prototype sample that demonstrates user requests and AI responses in a conversational format with enhanced visualization. The ',
          linkText: 'google_generative_ai',
          url: 'https://pub.dev/packages/google_generative_ai',
          trailingText:
              ' package is utilized to interact with Google AI and obtain responses for the requests.',
        ),
        _buildRichText(
          text: '\nTo create an API key, visit ',
          linkText: 'here',
          url: 'https://ai.google.dev/tutorials/setup',
          trailingText: ' and share it below. \n',
        ),
      ],
    );
  }

  Widget _buildRichText({
    required String text,
    required String linkText,
    required String url,
    String? trailingText,
  }) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black
              : Colors.white,
          fontSize: 14,
          height: 1.5,
        ),
        children: [
          TextSpan(text: text),
          TextSpan(
            text: linkText,
            style: TextStyle(color: widget.primaryColor),
            recognizer: TapGestureRecognizer()..onTap = () => _launchURL(url),
          ),
          if (trailingText != null) TextSpan(text: trailingText),
        ],
      ),
    );
  }

  void _launchURL(String url) {
    launchUrl(Uri.parse(url));
  }

  Widget _buildApiKeyTextField(StateSetter stateSetter) {
    return TextField(
      minLines: 1,
      obscureText: _isObscured,
      controller: _apiKeyController,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        suffixIcon: _buildSuffixIcons(stateSetter),
        hintText: 'Enter API key',
      ),
    );
  }

  Widget _buildSuffixIcons(StateSetter stateSetter) {
    return ValueListenableBuilder(
      valueListenable: _show,
      builder: (context, value, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible: _isVisible,
              child: IconButton(
                onPressed: () {
                  _isObscured = !_isObscured;
                  stateSetter(() {});
                },
                icon: Icon(
                  _isObscured ? Icons.visibility : Icons.visibility_off,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: IconButton(
                onPressed: _apiKeyController.text.isEmpty
                    ? null
                    : () {
                        setState(() {
                          widget.onApiKeySaved(_apiKeyController.text);
                          Navigator.of(context).pop();
                        });
                      },
                icon: Icon(
                  Icons.send,
                  color: _apiKeyController.text.isEmpty
                      ? Colors.grey[500]
                      : widget.primaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Close', style: TextStyle(fontSize: 16)),
      ),
    );
  }

  @override
  void dispose() {
    _apiKeyController.removeListener(_obscuredText);
    _apiKeyController.dispose();
    _show.dispose();
    super.dispose();
  }
}
