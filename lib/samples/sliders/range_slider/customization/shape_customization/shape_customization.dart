import 'package:flutter/foundation.dart';

///Package imports
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

///Local imports
import '../../../../../model/sample_view.dart';
import '../../../slider_utils.dart';

import 'divisor_customization.dart';
import 'thumb_customization.dart';
import 'tick_customization.dart';

/// Renders range slider with customized shapes
class ShapeCustomizedRangeSliderPage extends SampleView {
  /// Creates range slider with customized shapes
  const ShapeCustomizedRangeSliderPage(Key key) : super(key: key);

  @override
  _ShapeCustomizedRangeSliderPageState createState() =>
      _ShapeCustomizedRangeSliderPageState();
}

class _ShapeCustomizedRangeSliderPageState extends SampleViewState {
  _ShapeCustomizedRangeSliderPageState();

  late Widget rangeSlider;

  @override
  void initState() {
    super.initState();
    rangeSlider = _ShapeCustomizedRangeSlider();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return constraints.maxHeight > 400
          ? rangeSlider
          : SingleChildScrollView(
              child: SizedBox(
                  height: 500,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
                    child: rangeSlider,
                  )));
    });
  }
}

class _ShapeCustomizedRangeSlider extends SampleView {
  @override
  _ShapeCustomizedRangeSliderState createState() =>
      _ShapeCustomizedRangeSliderState();
}

class _ShapeCustomizedRangeSliderState extends SampleViewState {
  late bool _isDesktop;

  Widget _buildWebLayout() {
    return Container(
      alignment: Alignment.center,
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width >= 1000 ? 550 : 440,
        child: _buildMobileLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    final double padding = MediaQuery.of(context).size.width / 20.0;
    return Container(
        padding: EdgeInsets.fromLTRB(padding, 0, padding, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ThumbCustomizedRangeSlider(),
            columnSpacing40,
            title('Divisor'),
            DivisorCustomizedRangeSlider(),
            columnSpacing40,
            title('Ticks'),
            TickCustomizedRangeSlider()
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    _isDesktop = kIsWeb ||
        themeData.platform == TargetPlatform.macOS ||
        themeData.platform == TargetPlatform.windows ||
        themeData.platform == TargetPlatform.linux;
    return _isDesktop ? _buildWebLayout() : _buildMobileLayout();
  }
}
