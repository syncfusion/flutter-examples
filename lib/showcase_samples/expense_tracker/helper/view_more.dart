import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

Widget buildViewMoreButton(BuildContext context, void Function()? onTap) {
  return RichText(
    text: TextSpan(
      text: 'View More',
      recognizer: TapGestureRecognizer()..onTap = onTap,
      style: Theme.of(context).textTheme.labelLarge!.copyWith(
        color: Theme.of(context).colorScheme.primary,
        shadows: <Shadow>[
          Shadow(
            color: Theme.of(context).colorScheme.shadow,
            blurRadius: 0.05,
            offset: const Offset(0, 0.05),
          ),
        ],
      ),
    ),
  );
}
