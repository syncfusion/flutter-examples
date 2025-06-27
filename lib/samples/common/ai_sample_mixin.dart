import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/sample_view.dart';

mixin AISampleMixin on SampleViewState {
  bool isObscured = true;
  bool suffixIconVisibility = false;
  late TextEditingController assistApiKeyController;
  final ValueNotifier<int> showSuffixIcon = ValueNotifier<int>(0);

  void showPopupDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter stateSetter) {
            return AlertDialog(
              surfaceTintColor: Colors.white,
              content: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: SizedBox(
                  width: 400.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildTitle('About', model.primaryColor),
                      const SizedBox(height: 10.0),
                      _buildAboutText(),
                      _buildApiKeyTextField(stateSetter),
                      const SizedBox(height: 10.0),
                      _buildRichText(
                        text:
                            '\n If you prefer to explore this sample without an API key, you may close this pop-up. You can still access samples featuring AI responses that are stored locally',
                        linkText: '',
                        url: '',
                        trailingText: '.\n',
                      ),
                      _buildTitle('Disclaimer', model.primaryColor),
                      const SizedBox(height: 10.0),
                      const Text(
                        'Please be aware that Syncfusion does not retain your API key, requests, or AI responses. All data will be cleared when you exit this application.',
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [_buildCloseButton(context)],
            );
          },
        );
      },
    );
  }

  Widget _buildTitle(String title, Color color) {
    return Text(
      title,
      style: model.themeData.textTheme.titleMedium!.copyWith(
        color: color,
        fontWeight: FontWeight.bold,
      ),
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
          text: '\n To create an API key, visit ',
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
        style: model.themeData.textTheme.bodyMedium,
        children: [
          TextSpan(text: text),
          TextSpan(
            text: linkText,
            style: model.themeData.textTheme.bodyMedium!.copyWith(
              color: model.primaryColor,
            ),
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
      obscureText: isObscured,
      controller: assistApiKeyController,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        suffixIcon: _buildSuffixIcons(stateSetter),
        hintText: 'Enter API key',
      ),
    );
  }

  Widget _buildSuffixIcons(StateSetter stateSetter) {
    return ValueListenableBuilder(
      valueListenable: showSuffixIcon,
      builder: (BuildContext context, int value, Widget? child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Visibility(
              visible: suffixIconVisibility,
              child: IconButton(
                onPressed: () {
                  isObscured = !isObscured;
                  stateSetter(() {});
                },
                icon: Icon(
                  isObscured ? Icons.visibility : Icons.visibility_off,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: IconButton(
                onPressed: assistApiKeyController.text.isEmpty
                    ? null
                    : () {
                        setState(() {
                          model.assistApiKey = assistApiKeyController.text;
                          assistApiKeyController.clear();
                          Navigator.of(context).pop();
                        });
                      },
                icon: Icon(
                  Icons.send,
                  color: assistApiKeyController.text.isEmpty
                      ? Colors.grey[500]
                      : model.primaryColor,
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
      height: 40.0,
      child: FilledButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Close'),
      ),
    );
  }
}
