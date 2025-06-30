import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import './mobile_helper.dart'
    if (dart.library.js_interop) './web_helper.dart'
    as helper;

/// To check platform whether it is desktop or not.
bool isDesktop =
    kIsWeb || Platform.isMacOS || Platform.isWindows || Platform.isLinux;

/// Indicates whether the current environment is running in macOS desktop.
bool kIsMacOS = helper.getPlatformType() == 'macos';

/// Shows toast once after the selected text is copied to the Clipboard.
Widget showToast(
  BuildContext context,
  bool canShowToast,
  Alignment alignment,
  String toastText,
) {
  final bool useMaterial3 = Theme.of(context).useMaterial3;
  return Visibility(
    visible: canShowToast,
    child: Positioned.fill(
      bottom: 25.0,
      child: Align(
        alignment: alignment,
        child: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: useMaterial3
                  ? const EdgeInsets.symmetric(horizontal: 16, vertical: 14)
                  : const EdgeInsets.only(
                      left: 16,
                      top: 6,
                      right: 16,
                      bottom: 6,
                    ),
              decoration: BoxDecoration(
                color: useMaterial3
                    ? Theme.of(context).colorScheme.inverseSurface
                    : Colors.grey[600],
                borderRadius: useMaterial3
                    ? const BorderRadius.all(Radius.circular(4.0))
                    : const BorderRadius.all(Radius.circular(16.0)),
              ),
              child: Text(
                toastText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  color: useMaterial3
                      ? Theme.of(context).colorScheme.onInverseSurface
                      : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Displays the error message.
void showErrorDialog(BuildContext context, String error, String description) {
  final bool useMaterial3 = Theme.of(context).useMaterial3;
  showDialog<dynamic>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: EdgeInsets.zero,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(error),
            SizedBox(
              height: 36, // height of close search menu button
              width: 36, // width of close search menu button
              child: RawMaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                shape: useMaterial3
                    ? const CircleBorder()
                    : const RoundedRectangleBorder(),
                child: const Icon(Icons.clear, size: 20),
              ),
            ),
          ],
        ),
        content: SizedBox(width: 328.0, child: Text(description)),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            style: useMaterial3
                ? TextButton.styleFrom(
                    foregroundColor: Theme.of(context).primaryColor,
                    fixedSize: const Size(71, 40),
                  )
                : null,
            child: const Text('OK'),
          ),
        ],
        actionsPadding: useMaterial3 ? null : const EdgeInsets.only(bottom: 10),
      );
    },
  );
}

/// Represents PDF document.
class Document {
  /// Constructs Document instance.
  Document(this.name, this.path);

  /// Name of the PDF document.
  final String name;

  /// Path of the PDF document.
  final String path;
}
