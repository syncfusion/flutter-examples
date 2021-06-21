import 'package:flutter/material.dart';

/// Shows toast once after the selected text is copied to the Clipboard.
Widget showToast(bool canShowToast, Alignment alignment, String toastText) {
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
                padding: const EdgeInsets.only(
                    left: 16, top: 6, right: 16, bottom: 6),
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: const BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                ),
                child: Text(
                  toastText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontFamily: 'Roboto', fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ));
}

/// Displays the error message
void showErrorDialog(BuildContext context, String error, String description) {
  showDialog<dynamic>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: const EdgeInsets.all(0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(error),
            Container(
              height: 36, // height of close search menu button
              width: 36, // width of close search menu button
              child: RawMaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.clear,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        content: Container(width: 328.0, child: Text(description)),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: const Text('OK'),
          )
        ],
        actionsPadding: const EdgeInsets.only(bottom: 10),
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
