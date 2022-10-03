///Package import
import 'package:flutter/material.dart';

/// Renders a given fixed size widget
Widget get columnSpacing40 {
  return const SizedBox(height: 40);
}

/// Renders a given fixed size widget
Widget get columnSpacing10 {
  return const SizedBox(height: 10);
}

/// Renders a given fixed size widget
Widget get columnSpacing30 {
  return const SizedBox(height: 30);
}

/// Renders a text widget with left alignment and padding
Widget title(String text) {
  return Align(
    alignment: AlignmentDirectional.centerStart,
    child: Padding(
      padding: const EdgeInsetsDirectional.only(start: 25),
      child: Text(text),
    ),
  );
}
