export 'meta_tag_default.dart' if (dart.library.js_interop) 'meta_tag_web.dart';

/// This is the base structure for changing the sample title and meta tags.
abstract class MetaTagUpdate {
  /// This method changes the meta tag title based on the
  /// selected sample and widget title.
  void update(String sampleTitle, String widgetTitle);

  /// This method resets meta tag title to a default value.
  void setDefault();
}
