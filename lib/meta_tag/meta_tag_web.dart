import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

import 'meta_tag.dart';

/// This class is used when the sample runs in a web browser.
/// Implements meta tag updates for samples running in web browsers.
class WebMetaTagUpdate implements MetaTagUpdate {
  static const String _defaultMetaTitle =
      'Demos & Examples of Syncfusion Flutter Widgets';

  /// This method updates the meta tag using the sample and widget names.
  @override
  void update(String sampleTitle, String widgetTitle) {
    final String formattedTitle = '$sampleTitle - $widgetTitle';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateMetaTags(formattedTitle);
    });
  }

  /// Resets meta tags to the default value.
  @override
  void setDefault() {
    _updateMetaTags(_defaultMetaTitle);
  }

  /// Updates the meta tags if the title is valid and not already set.
  void _updateMetaTags(String title) {
    if (title.isEmpty || web.document.title == title) {
      return;
    }
    web.document.title = title;
    _setMeta('og:title', title);
  }

  /// This method finds the meta tag by name or property and updates it.
  /// If the tag does not exist, it creates a new one and adds it to the page.
  void _setMeta(String name, String content) {
    if (name.isEmpty || content.isEmpty) {
      return;
    }

    web.HTMLMetaElement? metaTag =
        web.document.head?.querySelector(
              'meta[property="$name"], meta[name="$name"]',
            )
            as web.HTMLMetaElement?;

    if (metaTag == null) {
      metaTag = web.document.createElement('meta') as web.HTMLMetaElement;
      metaTag.setAttribute('property', name);
      web.document.head?.append(metaTag);
    }
    metaTag.content = content;
  }
}
