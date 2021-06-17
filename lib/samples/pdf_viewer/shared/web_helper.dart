// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

/// Prevent default menu.
void preventDefaultContextMenu() {
  html.window.document.onKeyDown
      .listen((html.KeyboardEvent e) => _preventDefaultSearchMenu(e));
  html.window.document.onContextMenu
      .listen((html.MouseEvent e) => e.preventDefault());
}

/// Prevent specific default search menu.
void _preventDefaultSearchMenu(html.KeyboardEvent e) {
  if (e.keyCode == 114 || (e.ctrlKey && e.keyCode == 70)) {
    e.preventDefault();
  }
}
