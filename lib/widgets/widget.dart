import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import './render.dart';

typedef Widget StickyHeaderWidgetBuilder(
    BuildContext context, double stuckAmount);

class CustomListView extends MultiChildRenderObjectWidget {
  /// Constructs a new [CustomListView] widget.
  CustomListView({
    Key key,
    @required this.header,
    @required this.content,
    this.overlapHeaders: false,
    this.callback,
  }) : super(
          key: key,
          children: [content, header],
        );

  /// Header to be shown at the top of the parent [Scrollable] content.
  final Widget header;

  /// Content to be shown below the header.
  final Widget content;

  /// If true, the header will overlap the Content.
  final bool overlapHeaders;

  /// Optional callback with stickyness value. If you think you need this, then you might want to
  /// consider using [CustomListViewBuilder] instead.
  final RenderCustomListViewCallback callback;

  @override
  CustomListViewRenderer createRenderObject(BuildContext context) {
    var scrollable = Scrollable.of(context);
    assert(scrollable != null);
    return new CustomListViewRenderer(
      scrollable: scrollable,
      callback: this.callback,
      overlapHeaders: this.overlapHeaders,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, CustomListViewRenderer renderObject) {
    renderObject
      ..scrollable = Scrollable.of(context)
      ..callback = this.callback
      ..overlapHeaders = this.overlapHeaders;
  }
}

/// Sticky Header Builder Widget.
///
/// The same as [CustomListView] but instead of supplying a Header view, you supply a [builder] that
/// constructs the header with the appropriate stickyness.
///
/// Place this widget inside a [ListView], [GridView], [CustomScrollView], [SingleChildScrollView] or similar.
///
class CustomListViewBuilder extends StatefulWidget {
  /// Constructs a new [CustomListViewBuilder] widget.
  const CustomListViewBuilder({
    Key key,
    @required this.builder,
    this.content,
    this.overlapHeaders: false,
  }) : super(key: key);

  /// Called when the sticky amount changes for the header.
  /// This builder must not return null.
  final StickyHeaderWidgetBuilder builder;

  /// Content to be shown below the header.
  final Widget content;

  /// If true, the header will overlap the Content.
  final bool overlapHeaders;

  @override
  _CustomListViewBuilderState createState() =>
      new _CustomListViewBuilderState();
}

class _CustomListViewBuilderState extends State<CustomListViewBuilder> {
  double _stuckAmount;

  @override
  Widget build(BuildContext context) {
    return new CustomListView(
      overlapHeaders: widget.overlapHeaders,
      header: new LayoutBuilder(
        builder: (context, _) => widget.builder(context, _stuckAmount ?? 0.0),
      ),
      content: widget.content,
      callback: (double stuckAmount) {
        if (_stuckAmount != stuckAmount) {
          _stuckAmount = stuckAmount;
          WidgetsBinding.instance.endOfFrame.then((_) {
            if (mounted) {
              setState(() {});
            }
          });
        }
      },
    );
  }
}
