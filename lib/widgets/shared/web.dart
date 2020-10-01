//ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

/// Cursor tracks the movement shows as hand symbol
class HandCursor extends MouseRegion {
  /// holds the mouse events
  const HandCursor({@required Widget child})
      : super(
          child: child,
          onHover: _mouseHover,
          onExit: _mouseExit,
        );
  static final html.Element _appContainer =
      html.window.document.getElementById('app-container');

  static void _mouseHover(PointerEvent event) =>
      _appContainer.style.cursor = 'pointer';

  static void _mouseExit(PointerEvent event) =>
      _appContainer.style.cursor = 'default';
}

/// change the cursor into hand cursor on navigation
void changeCursorStyleOnNavigation() {
  HandCursor._appContainer.style.cursor = 'default';
}
