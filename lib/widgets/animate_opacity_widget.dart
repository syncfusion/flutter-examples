///flutter package import
import 'package:flutter/material.dart';

/// Creates a widget that makes its child partially transparent.
class AnimateOpacityWidget extends StatefulWidget {
  /// Holds custom opacity widget information
  // ignore: tighten_type_of_initializing_formals
  const AnimateOpacityWidget({this.opacity, this.child, this.controller})
    : assert(opacity != null),
      assert(child != null);

  /// The fraction to scale the child's alpha value.
  final double? opacity;

  /// Creates a widget that makes its child partially transparent.
  final Widget? child;

  ///[controller] Controls a scrollable widget.
  final ScrollController? controller;

  @override
  _AnimateOpacityWidgetState createState() => _AnimateOpacityWidgetState();
}

class _AnimateOpacityWidgetState extends State<AnimateOpacityWidget> {
  late double? _opacity;

  @override
  void initState() {
    _opacity = widget.opacity;
    widget.controller!.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    final double opacity = widget.controller!.offset * 0.01;
    if (opacity >= 0 && opacity <= 1) {
      setState(() {
        _opacity = opacity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(opacity: _opacity!, child: widget.child);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller!.removeListener(_onScroll);
  }
}
