import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

/// Renders a given fixed size widget
bool get isWebOrDesktop {
  return defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux ||
      defaultTargetPlatform == TargetPlatform.macOS ||
      kIsWeb;
}

/// Renders the width of the screen.
double getScreenWidth(BuildContext context, bool orientation) {
  return isWebOrDesktop
      ? MediaQuery.of(context).size.width >= 1000
            ? orientation
                  ? MediaQuery.of(context).size.width / 3
                  : MediaQuery.of(context).size.width
            : 440
      : MediaQuery.of(context).size.width;
}
