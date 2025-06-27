///Package import
import 'package:flutter/material.dart';

///Local import
import '../../../../../model/sample_view.dart';
import '../../../slider_utils.dart';
import 'gradient_track.dart';

///Renders range slider with customized color
class ColorCustomizedRangeSliderPage extends SampleView {
  ///Creates range slider with customized color
  const ColorCustomizedRangeSliderPage(Key key) : super(key: key);

  @override
  _ColorCustomizedRangeSliderPageState createState() =>
      _ColorCustomizedRangeSliderPageState();
}

class _ColorCustomizedRangeSliderPageState extends SampleViewState {
  _ColorCustomizedRangeSliderPageState();
  final GlobalKey gradientKey = GlobalKey();

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
          title('Active and inactive track color'),
          const SizedBox(height: 10),
          GradientTrackRangeSlider(gradientKey),
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
                  height: 400,
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
