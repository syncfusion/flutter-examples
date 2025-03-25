import 'dart:ui';

import 'package:flutter/material.dart';

// A helper widget to display a centered dialog with customizable properties.
class CommonCenterDialog extends StatelessWidget {
  const CommonCenterDialog({
    super.key,
    this.dialogHeader,
    this.content,
    this.actions,
    this.onCloseIconPressed,
    this.contentPadding,
    this.horizontalPadding,
    this.verticalPadding,
  });

  final String? dialogHeader;
  final Widget? content;
  final Function()? onCloseIconPressed;
  final List<Widget>? actions;
  final double? contentPadding;
  final double? horizontalPadding;
  final double? verticalPadding;

  /// Builds a list of box shadows for dialogs.
  List<BoxShadow> _dialogShadows() {
    return const [
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
    ];
  }

  /// Constructs the center dialog with theme and given content.
  AlertDialog _buildDialog(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    const EdgeInsets padding = EdgeInsets.all(24.0);
    return AlertDialog(
      scrollable: true,
      elevation: 0.0,
      titlePadding: padding,
      actionsPadding: padding,
      contentPadding: const EdgeInsets.only(
        left: 24.0,
        right: 24.0,
        bottom: 24.0,
        top: 16.0,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      surfaceTintColor: themeData.colorScheme.primary,
      backgroundColor: themeData.colorScheme.surface,
      title: dialogHeader != null ? _buildDialogHeader(context) : null,
      content: SizedBox(width: 400, child: content),
      actions: actions,
    );
  }

  Row _buildDialogHeader(BuildContext context) {
    return Row(
      spacing: 10.0,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _buildDialogHeaderText(context),
        _buildCloseIconButton(context),
      ],
    );
  }

  IconButton _buildCloseIconButton(BuildContext context) {
    return IconButton(
      onPressed:
          onCloseIconPressed ??
          () {
            Navigator.pop(context);
          },
      icon: Icon(
        Icons.close,
        size: 24,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildDialogHeaderText(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Flexible(
      child: Text(
        dialogHeader ?? '',
        style: themeData.textTheme.headlineSmall!.copyWith(
          color: themeData.colorScheme.onSurface,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: GestureDetector(
            onTap: () {},
            child: DecoratedBox(
              decoration: BoxDecoration(boxShadow: _dialogShadows()),
              child: _buildDialog(context),
            ),
          ),
        ),
      ),
    );
  }
}
