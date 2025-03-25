import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../enum.dart';
import '../helper/responsive_layout.dart';

class CustomGridCardView extends MultiChildRenderObjectWidget {
  const CustomGridCardView({
    required super.children,
    required this.cardType,
    super.key,
    this.tabs,
  });

  final CardType cardType;
  final List<Widget>? tabs;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return CardViewRenderBox(context, cardType, tabs: tabs);
  }
}

class CardViewParentData extends ContainerBoxParentData<RenderBox> {}

class CardViewRenderBox extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, CardViewParentData> {
  CardViewRenderBox(this.buildContext, this.cardType, {this.tabs});

  final BuildContext buildContext;
  final CardType cardType;
  final List<Widget>? tabs;

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! CardViewParentData) {
      child.parentData = CardViewParentData();
    }

    super.setupParentData(child);
  }

  @override
  bool hitTestSelf(Offset position) {
    return true;
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    bool isHit = false;

    // Iterate over children and check hit testing in reverse paint order
    visitChildren((RenderObject child) {
      final RenderBox renderBoxChild = child as RenderBox;
      final CardViewParentData parentData =
          child.parentData! as CardViewParentData;

      // Transform the position into the child's coordinate system
      final Offset childPosition = position - parentData.offset;

      // Perform hit testing for this child
      if (renderBoxChild.hitTest(result, position: childPosition)) {
        isHit = true;
      }
    });

    return isHit;
  }

  @override
  void performLayout() {
    final Size availableSize = constraints.biggest;
    final Size cardSize = _calculateCardSize(
      availableSize.width,
      availableSize.height,
    );
    final cardCountInARow = _calculateCardRowInARow();
    final int totalCardsHeight = (childCount / cardCountInARow).ceil();

    if (childCount > 0) {
      RenderBox? child = firstChild;
      int childIndex = 0;
      while (child != null) {
        final CardViewParentData currentChildData =
            child.parentData! as CardViewParentData;
        child.layout(BoxConstraints.tight(cardSize), parentUsesSize: true);
        currentChildData.offset = _calculateCurrentCardOffset(
          childIndex,
          cardSize,
          cardCountInARow,
        );
        childIndex++;
        child = currentChildData.nextSibling;
      }
    }
    size = Size(constraints.maxWidth, cardSize.height * totalCardsHeight);
  }

  Size _calculateCardSize(double screenWidth, double screenHeight) {
    switch (cardType) {
      case CardType.gridCard:
        return Size(
          screenWidth *
              (isMobile(buildContext)
                  ? 1
                  : isTablet(buildContext)
                  ? 0.5
                  : 0.33333),
          (MediaQuery.of(buildContext).size.height -
                  (36.0 +
                      TabBar(tabs: tabs ?? []).preferredSize.height +
                      AppBar().preferredSize.height)) /
              2,
        );
      case CardType.insightCard:
        return Size(
          screenWidth *
              (isMobile(buildContext) || isTablet(buildContext)
                  ? 0.5
                  : 0.33333),
          96,
        );
    }
  }

  int _calculateCardRowInARow() {
    switch (cardType) {
      case CardType.gridCard:
        return isMobile(buildContext)
            ? 1
            : isTablet(buildContext)
            ? 2
            : 3;
      case CardType.insightCard:
        return isMobile(buildContext) || isTablet(buildContext) ? 2 : 3;
    }
  }

  Offset _calculateCurrentCardOffset(
    int childIndex,
    Size cardSize,
    int cardCountInARow,
  ) {
    final int heightFactor = (childIndex / cardCountInARow).floor();
    final int widthFactor = childIndex % cardCountInARow;
    final Offset offset = Offset(
      cardSize.width * widthFactor,
      cardSize.height * heightFactor,
    );
    return offset;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (childCount > 0) {
      RenderBox? child = firstChild;
      while (child != null) {
        final CardViewParentData currentChildData =
            child.parentData! as CardViewParentData;
        context.paintChild(child, offset + currentChildData.offset);
        child = currentChildData.nextSibling;
      }
    }
  }
}
