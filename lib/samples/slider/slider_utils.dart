import 'package:flutter/material.dart';

Widget get columnSpacing40 {
  return const SizedBox(height: 40);
}

Widget get columnSpacing10 {
  return const SizedBox(height: 10);
}

Widget get columnSpacing30 {
  return const SizedBox(height: 30);
}

Widget title(String text) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Padding(
      child: Text(text),
      padding: const EdgeInsets.only(left: 25),
    ),
  );
}
