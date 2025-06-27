///Package import
import 'package:flutter/material.dart';

const Duration _kExpand = Duration(milliseconds: 200);

/// Widget extends from the [ExpansionTile] to customize the expansionTile
class CustomExpansionTile extends StatefulWidget {
  /// holds the title, children, et., of the expansionTile
  const CustomExpansionTile({
    Key? key,
    this.headerBackgroundColor,
    required Widget this.title,
    this.backgroundColor,
    this.onExpansionChanged,
    List<Widget> this.children = const <Widget>[],
    bool this.initiallyExpanded = false,
  }) : assert(initiallyExpanded != null),
       assert(title != null),
       assert(children != null),
       super(key: key);

  /// Holds the header name of expansion tile
  final Widget? title;

  /// Holds information of expand or collapse change
  final ValueChanged<bool>? onExpansionChanged;

  /// Children widget of the [CustomExpansionTile]
  final List<Widget>? children;

  /// [CustomExpansionTile]s background color
  final Color? backgroundColor;

  /// Holds the [CustomExpansionTile] title's background color
  final Color? headerBackgroundColor;

  /// Holds the information of initially expand/collapse
  final bool? initiallyExpanded;

  @override
  _ExpansionTileState createState() => _ExpansionTileState();
}

class _ExpansionTileState extends State<CustomExpansionTile>
    with SingleTickerProviderStateMixin {
  Animatable<double>? _easeOutTween;
  Animatable<double>? _easeInTween;
  Animatable<double>? _halfTween;

  ColorTween? _borderColorTween;
  ColorTween? _iconColorTween;
  ColorTween? _backgroundColorTween;

  late AnimationController _controller;
  Animation<double>? _iconTurns;
  Animation<double>? _heightFactor;
  Animation<Color?>? _borderColor;
  late Color? _headerColor;
  Animation<Color?>? _backgroundColor;
  bool _isExpanded = false;

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    _borderColorTween!.end = Colors.transparent;
    _headerColor = theme.textTheme.titleMedium!.color;
    _iconColorTween!
      ..begin = theme.unselectedWidgetColor
      ..end = theme.colorScheme.secondary;
    _backgroundColorTween!.end = widget.backgroundColor;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _easeOutTween = CurveTween(curve: Curves.easeOut);
    _easeInTween = CurveTween(curve: Curves.easeIn);
    _halfTween = Tween<double>(begin: 0.0, end: 0.5);
    _borderColorTween = ColorTween();
    _iconColorTween = ColorTween();
    _backgroundColorTween = ColorTween();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween!);
    _iconTurns = _controller.drive(_halfTween!.chain(_easeInTween!));
    _borderColor = _controller.drive(_borderColorTween!.chain(_easeOutTween!));
    _backgroundColor = _controller.drive(
      _backgroundColorTween!.chain(_easeOutTween!),
    );

    _isExpanded = PageStorage.of(context).readState(context) == null
        ? widget.initiallyExpanded!
        : false;
    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _easeOutTween = null;
    _easeInTween = null;
    _halfTween = null;
    _borderColorTween = null;
    _iconColorTween = null;
    _backgroundColorTween = null;

    _iconTurns = null;
    _heightFactor = null;
    _borderColor = null;
    _headerColor = null;
    _backgroundColor = null;
    super.dispose();
  }

  void _handleListTileTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) {
            return;
          }
          setState(() {
            // Expansion tile's state 'expand/Collapse' changed.
          });
        });
      }
      PageStorage.of(context).writeState(context, _isExpanded);
    });
    if (widget.onExpansionChanged != null) {
      widget.onExpansionChanged!(_isExpanded);
    }
  }

  Widget _buildChild(BuildContext context, Widget? child) {
    final Color borderSideColor = _borderColor!.value ?? Colors.transparent;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _backgroundColor!.value ?? Colors.transparent,
        border: Border(
          top: BorderSide(color: borderSideColor),
          bottom: BorderSide(color: borderSideColor),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 40,
            child: ListTile(
              onTap: _handleListTileTap,
              dense: true,
              title: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: DefaultTextStyle(
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium!.copyWith(color: _headerColor),
                  child: widget.title!,
                ),
              ),
              trailing: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: RotationTransition(
                  turns: _iconTurns!,
                  child: Icon(Icons.expand_more, color: _headerColor),
                ),
              ),
            ),
          ),
          ClipRect(
            child: Align(heightFactor: _heightFactor!.value, child: child),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;
    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChild,
      child: closed ? null : Column(children: widget.children!),
    );
  }
}
