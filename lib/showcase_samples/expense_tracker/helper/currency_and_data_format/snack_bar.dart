import 'package:flutter/material.dart';

import '../common_helper.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> buildSnackBar(
  BuildContext context,
  String content,
) {
  final double snackBarTextWidth = measureTextWidth(
    content,
    Theme.of(context).textTheme.labelLarge!.copyWith(
      color: Theme.of(context).colorScheme.onInverseSurface,
    ),
  );

  final double snackBarWidth = snackBarTextWidth + 32.0 + 18.0 + 30.0;

  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      elevation: 2.0,
      behavior: SnackBarBehavior.floating,
      width: snackBarWidth,
      padding: const EdgeInsets.only(
        top: 14.0,
        bottom: 14.0,
        left: 16.0,
        right: 8.0,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
      // margin: EdgeInsets.zero,
      backgroundColor: Theme.of(context).colorScheme.inverseSurface,
      showCloseIcon: true,
      closeIconColor: Theme.of(context).colorScheme.onInverseSurface,
      content: Text(
        content,
        style: Theme.of(context).textTheme.labelLarge!.copyWith(
          color: Theme.of(context).colorScheme.onInverseSurface,
        ),
      ),
    ),
  );
}
