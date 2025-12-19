import 'meta_tag.dart';

/// This class is used when the sample is not running in a web browser; meta
/// tag updates are only for web.
class WebMetaTagUpdate implements MetaTagUpdate {
  @override
  void update(String sampleTitle, String widgetTitle) {}

  @override
  void setDefault() {}
}
