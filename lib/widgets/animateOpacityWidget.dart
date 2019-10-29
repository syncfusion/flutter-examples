import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AnimateOpacityWidget extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  AnimateOpacityWidget(
      {@required this.opacity, @required this.child, this.controller});

  final double opacity;
  final Widget child;
  final ScrollController controller;

  @override
  AnimateOpacityWidgetState createState() => AnimateOpacityWidgetState();
}

class AnimateOpacityWidgetState extends State<AnimateOpacityWidget> {
  double _opacity;

  @override
  void initState() {
    _opacity = widget.opacity;
    widget.controller.addListener(onScroll);
    super.initState();
  }

  void onScroll() {
    final num opacity = widget.controller.offset * 0.01;
    if (opacity >= 0 && opacity <= 1) {
      setState(() {
        _opacity = opacity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Opacity(opacity: _opacity, child: widget.child),
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(onScroll);
  }
}
