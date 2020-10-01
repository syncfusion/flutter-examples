import 'package:flutter/widgets.dart';

/// Cursor tracks the movement shows as hand symbol
class HandCursor extends MouseRegion {
  /// holds the child widget
  const HandCursor({@required Widget child}) : super(child: child);
}

/// change the cursor into hand cursor on navigation
void changeCursorStyleOnNavigation() {}
