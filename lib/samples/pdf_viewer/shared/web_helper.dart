import 'package:web/web.dart' as web;

/// Gets platform type.
String getPlatformType() {
  if (web.window.navigator.platform.toLowerCase().contains('macintel')) {
    return 'macos';
  }
  return web.window.navigator.platform.toLowerCase();
}
