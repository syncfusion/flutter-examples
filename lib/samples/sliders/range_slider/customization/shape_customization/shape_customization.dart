///Package imports
import 'package:flutter/material.dart';

///Local imports
import '../../../../../model/sample_view.dart';
import '../../../slider_utils.dart';
import 'divider_customization.dart';
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
  final GlobalKey dividerKey = GlobalKey();
  final GlobalKey thumbKey = GlobalKey();
  final GlobalKey tickKey = GlobalKey();

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
          ThumbCustomizedRangeSlider(thumbKey),
          columnSpacing40,
          title('Divider'),
          DividerCustomizedRangeSlider(dividerKey),
          columnSpacing40,
          title('Ticks'),
          TickCustomizedRangeSlider(tickKey),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Widget rangeSlider = model.isWebFullView
            ? _buildWebLayout()
            : _buildMobileLayout();
        return constraints.maxHeight > 400
            ? rangeSlider
            : SingleChildScrollView(
                child: SizedBox(
                  height: 500,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
                    child: rangeSlider,
                  ),
                ),
              );
      },
    );
  }
}
