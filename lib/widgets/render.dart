import 'dart:math' show min, max;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

//ignore: prefer_generic_function_type_aliases
typedef void RenderCustomListViewCallback(double stuckAmount);

class CustomListViewRenderer extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MultiChildLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MultiChildLayoutParentData> {
  CustomListViewRenderer({
    @required ScrollableState scrollable,
    RenderCustomListViewCallback callback,
    bool overlapHeaders = false,
    RenderBox header,
    RenderBox content,
  })  : assert(scrollable != null),
        _scrollable = scrollable,
        _callback = callback,
        _overlapHeaders = overlapHeaders {
    if (content != null) 
      add(content);
    if (header != null) 
      add(header);
  }

  RenderCustomListViewCallback _callback;
  ScrollableState _scrollable;
  bool _overlapHeaders;

  set scrollable(ScrollableState newValue) {
    assert(newValue != null);
    if (_scrollable == newValue) {
      return;
    }
    final ScrollableState oldValue = _scrollable;
    _scrollable = newValue;
    markNeedsLayout();
    if (attached) {
      oldValue.position?.removeListener(markNeedsLayout);
      newValue.position?.addListener(markNeedsLayout);
    }
  }

  set callback(RenderCustomListViewCallback newValue) {
    if (_callback == newValue) {
      return;
    }
    _callback = newValue;
    markNeedsLayout();
  }

  set overlapHeaders(bool newValue) {
    if (_overlapHeaders == newValue) {
      return;
    }
    _overlapHeaders = newValue;
    markNeedsLayout();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _scrollable.position?.addListener(markNeedsLayout);
  }

  @override
  void detach() {
    _scrollable.position?.removeListener(markNeedsLayout);
    super.detach();
  }

  // short-hand to access the child RenderObjects
  RenderBox get _headerBox => lastChild;

  RenderBox get _contentBox => firstChild;

  @override
  void performLayout() {
    // ensure we have header and content boxes
    assert(childCount == 2);

    // layout both header and content widget
    final BoxConstraints childConstraints = constraints.loosen();
    _headerBox.layout(childConstraints, parentUsesSize: true);
    _contentBox.layout(childConstraints, parentUsesSize: true);

    final num headerHeight = _headerBox.size.height;
    final num contentHeight = _contentBox.size.height;

    // determine size of ourselves based on content widget
    final num width = max(constraints.minWidth, _contentBox.size.width);
    final num height = max(constraints.minHeight,
        _overlapHeaders ? contentHeight : headerHeight + contentHeight);
    size = Size(width, height);
    assert(size.width == constraints.constrainWidth(width));
    assert(size.height == constraints.constrainHeight(height));
    assert(size.isFinite);

    // place content underneath header
    final MultiChildLayoutParentData contentParentData =
        _contentBox.parentData;
    contentParentData.offset =
        Offset(0.0, _overlapHeaders ? 0.0 : headerHeight);

    // determine by how much the header should be stuck to the top
    final double stuckOffset = determineStuckOffset();

    // place header over content relative to scroll offset
    final double maxOffset = height - headerHeight;
    final MultiChildLayoutParentData headerParentData =
        _headerBox.parentData;
    headerParentData.offset =
        Offset(0.0, max(0.0, min(-stuckOffset, maxOffset)));

    // report to widget how much the header is stuck.
    if (_callback != null) {
      final num stuckAmount =
          max(min(headerHeight, stuckOffset), -headerHeight) / headerHeight;
      _callback(stuckAmount);
    }
  }

  double determineStuckOffset() {
    final RenderObject scrollBox = _scrollable.context.findRenderObject();
    if (scrollBox?.attached ?? false) {
      try {
        return localToGlobal(Offset.zero, ancestor: scrollBox).dy;
      } catch (e) {
        // ignore and fall-through and return 0.0
      }
    }
    return 0.0;
  }

  @override
  void setupParentData(RenderObject child) {
    super.setupParentData(child);
    if (child.parentData is! MultiChildLayoutParentData) {
      child.parentData = MultiChildLayoutParentData();
    }
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return _contentBox.getMinIntrinsicWidth(height);
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return _contentBox.getMaxIntrinsicWidth(height);
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return _overlapHeaders
        ? _contentBox.getMinIntrinsicHeight(width)
        : (_headerBox.getMinIntrinsicHeight(width) +
            _contentBox.getMinIntrinsicHeight(width));
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return _overlapHeaders
        ? _contentBox.getMaxIntrinsicHeight(width)
        : (_headerBox.getMaxIntrinsicHeight(width) +
            _contentBox.getMaxIntrinsicHeight(width));
  }

  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) {
    return defaultComputeDistanceToHighestActualBaseline(baseline);
  }

  @override
  bool hitTestChildren(HitTestResult result, {Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }
}
