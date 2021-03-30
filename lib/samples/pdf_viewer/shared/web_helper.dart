// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

/// Prevent default menu.
void preventDefaultMenu() {
  html.window.document.onKeyDown.listen((e) => _preventSpecificDefaultMenu(e));
  html.window.document.onContextMenu.listen((e) => e.preventDefault());
}

/// Prevent specific default search menu.
void _preventSpecificDefaultMenu(e) {
  if (e.keyCode == 114 || (e.ctrlKey && e.keyCode == 70)) {
    e.preventDefault();
  }
}
