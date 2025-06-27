import 'package:flutter/material.dart';

import '../helper/helper.dart';

class MobileDialog extends StatelessWidget {
  const MobileDialog({
    super.key,
    required this.dialogType,
    required this.content,
    required this.action,
  });
  final String dialogType;
  final Widget content;
  final Widget action;

  Widget buildDefaultAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          dialogType,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: fontWeight500(),
          ),
        ),
        action,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(IconData(0xe717, fontFamily: stockFontIconFamily)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        shadowColor: const Color(0xff000026),
        surfaceTintColor: Colors.transparent,
        title: buildDefaultAppBar(context),
        backgroundColor: colorScheme.surface,
        elevation: 2.0,
      ),
      body: content,
    );
  }
}
