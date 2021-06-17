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
  })  : assert(initiallyExpanded != null),
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
  static final Animatable<double> _easeOutTween =
      CurveTween(curve: Curves.easeOut);
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);

  final ColorTween _borderColorTween = ColorTween();
  final ColorTween _headerColorTween = ColorTween();
  final ColorTween _iconColorTween = ColorTween();
  final ColorTween _backgroundColorTween = ColorTween();

  late AnimationController _controller;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;
  late Animation<Color?> _borderColor;
  late Animation<Color?> _headerColor;
  late Animation<Color?> _iconColor;
  late Animation<Color?> _backgroundColor;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    _borderColor = _controller.drive(_borderColorTween.chain(_easeOutTween));
    _headerColor = _controller.drive(_headerColorTween.chain(_easeInTween));
    _iconColor = _controller.drive(_iconColorTween.chain(_easeInTween));
    _backgroundColor =
        _controller.drive(_backgroundColorTween.chain(_easeOutTween));

    _isExpanded = PageStorage.of(context)?.readState(context) == null
        ? widget.initiallyExpanded!
        : false;
    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
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
            /// Expansion tile's state 'expand/Collapse' changed
          });
        });
      }
      PageStorage.of(context)?.writeState(context, _isExpanded);
    });
    if (widget.onExpansionChanged != null) {
      widget.onExpansionChanged!(_isExpanded);
    }
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    final Color borderSideColor = _borderColor.value ?? Colors.transparent;
    final Color titleColor = _headerColor.value!;

    return Container(
      decoration: BoxDecoration(
          color: _backgroundColor.value ?? Colors.transparent,
          border: Border(
            top: BorderSide(color: borderSideColor),
            bottom: BorderSide(color: borderSideColor),
          )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconTheme.merge(
            data: IconThemeData(color: _iconColor.value),
            child: Container(
              height: 40,
              color: widget.headerBackgroundColor ?? Colors.black,
              child: ListTile(
                onTap: _handleTap,
                dense: true,
                title: Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 5),
                  child: DefaultTextStyle(
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(color: titleColor),
                    child: widget.title!,
                  ),
                ),
                trailing: Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 5),
                  child: RotationTransition(
                    turns: _iconTurns,
                    child: const Icon(
                      Icons.expand_more,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
          ClipRect(
            child: Align(
              heightFactor: _heightFactor.value,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    _borderColorTween.end = Colors.transparent;
    _headerColorTween
      ..begin = theme.textTheme.subtitle1!.color
      ..end = theme.accentColor;
    _iconColorTween
      ..begin = theme.unselectedWidgetColor
      ..end = theme.accentColor;
    _backgroundColorTween.end = widget.backgroundColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;
    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: closed ? null : Column(children: widget.children!),
    );
  }
}
