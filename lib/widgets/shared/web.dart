import 'dart:html' as html;
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

class HandCursor extends MouseRegion {
  //ignore: prefer_const_constructors_in_immutables
  HandCursor({@required Widget child})
      : super(
          child: child,
          onHover: _mouseHover,
          onExit: _mouseExit,
        );
  static final html.Element appContainer =
      html.window.document.getElementById('app-container');

  static void _mouseHover(PointerEvent event) =>
      appContainer.style.cursor = 'pointer';

  static void _mouseExit(PointerEvent event) =>
      appContainer.style.cursor = 'default';
}

void changeCursorStyleOnNavigation() {
  HandCursor.appContainer.style.cursor = 'default';
}
