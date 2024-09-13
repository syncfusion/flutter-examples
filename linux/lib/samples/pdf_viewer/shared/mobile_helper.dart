import 'dart:io';

/// Prevents default menu.
void preventDefaultContextMenu() {
  // ignore: avoid_returning_null_for_void
  return null;
}

/// Gets platform type.
String getPlatformType() {
  return Platform.operatingSystem;
}
