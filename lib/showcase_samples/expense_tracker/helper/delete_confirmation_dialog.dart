import 'package:flutter/material.dart';

import '../constants.dart';

/// Displays a confirmation dialog for delete actions.
void showDeleteConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
  required VoidCallback confirmAction,
}) {
  showDialog<Widget>(
    context: context,
    builder: (BuildContext context) {
      final ColorScheme colorScheme = Theme.of(context).colorScheme;
      final TextTheme textTheme = Theme.of(context).textTheme;
      return DecoratedBox(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurStyle: BlurStyle.outer,
              color: Color(0xff00004D),
              offset: Offset(0, 2),
              blurRadius: 3.0,
            ),
            BoxShadow(
              blurStyle: BlurStyle.outer,
              color: Color(0xff000026),
              offset: Offset(0, 6),
              blurRadius: 10.0,
              spreadRadius: 4.0,
            ),
          ],
        ),
        child: AlertDialog(
          titlePadding: const EdgeInsets.all(24),
          contentPadding: const EdgeInsetsDirectional.only(
            start: 24,
            top: 16,
            end: 24,
            bottom: 16,
          ),
          actionsPadding: const EdgeInsets.all(24),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: IconButton(
                  icon: const Icon(
                    IconData(0xe721, fontFamily: fontIconFamily),
                    size: 24,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
          content: Text(
            content,
            style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
          ),
          actions: _buildActionButtons(context, confirmAction),
        ),
      );
    },
  );
}

List<Widget> _buildActionButtons(
  BuildContext context,
  VoidCallback confirmAction,
) {
  final ColorScheme colorScheme = Theme.of(context).colorScheme;
  final TextTheme textTheme = Theme.of(context).textTheme;
  final ButtonStyle actionButtonStyle = TextButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
  );
  final TextStyle? actionButtonTextStyle = textTheme.labelLarge?.copyWith(
    color: colorScheme.primary,
  );
  return <Widget>[
    TextButton(
      style: actionButtonStyle,
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Text('Cancel', style: actionButtonTextStyle),
    ),
    TextButton(
      style: actionButtonStyle,
      onPressed: () {
        confirmAction();
        Navigator.pop(context);
      },
      child: Text(
        'Delete',
        style: textTheme.labelLarge?.copyWith(color: colorScheme.error),
      ),
    ),
  ];
}
