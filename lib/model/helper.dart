import 'package:flutter/material.dart';
import 'package:flutter_examples/samples/chart/axis_features/axis_crossing/axis_crossing.dart';
import 'package:flutter_examples/samples/chart/axis_features/handling_label_collision/handling_label_collision.dart';
import 'package:flutter_examples/samples/chart/axis_features/multiple_axis_chart/multiple_axis_chart.dart';
import 'package:flutter_examples/samples/chart/axis_features/opposed_axes/opposed_axes.dart';
import 'package:flutter_examples/samples/chart/axis_features/edge_label_placement/edgelabel_placement.dart';
import 'package:flutter_examples/samples/chart/axis_types/category_types/default_category_axis.dart';
import 'package:flutter_examples/samples/chart/axis_types/category_types/indexed_category_axis.dart';
import 'package:flutter_examples/samples/chart/axis_types/category_types/label_placement.dart';
import 'package:flutter_examples/samples/chart/axis_types/date_time_types/date_time_axis_with_label_format.dart';
import 'package:flutter_examples/samples/chart/axis_types/date_time_types/default_date_time_axis.dart';
import 'package:flutter_examples/samples/chart/axis_types/logarithmic_types/default_logarithmic_axis.dart';
import 'package:flutter_examples/samples/chart/axis_types/logarithmic_types/inversed_logarithmic_axis.dart';
import 'package:flutter_examples/samples/chart/axis_types/numeric_types/default_numeric_axis.dart';
import 'package:flutter_examples/samples/chart/axis_types/numeric_types/inversed_numeric_axis.dart';
import 'package:flutter_examples/samples/chart/axis_types/numeric_types/numeric_axis_with_label_format.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/area_series/area_with_emptypoints.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/area_series/area_with_gradient.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/area_series/default_area_chart.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/area_series/vertical_area_chart.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/bar_series/bar_width_and_spacing.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/bar_series/bar_with_rounded_corners.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/bar_series/bar_with_track.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/bar_series/customized_bar_chart.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/bar_series/default_bar_chart.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/bubble_series/bubble_filled_with_gradient.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/bubble_series/bubble_with_multiple_series.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/bubble_series/bubble_with_various_colors.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/bubble_series/default_bubble_chart.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/column_series/back_to_back_column.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/column_series/column_width_and_spacing.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/column_series/column_with_rounded_corners.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/column_series/column_with_track.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/column_series/customized_column_chart.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/column_series/default_column_chart.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/line_series/customized_line_chart.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/line_series/default_line_chart.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/line_series/line_with_dashes.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/line_series/multi_colored_line.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/rangecolumn_series/default_rangecolumn_chart.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/rangecolumn_series/rangecolumn_with_track.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/rangecolumn_series/vertical_rangecolumn_chart.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/scatter_series/default_scatter_chart.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/scatter_series/scatter_with_various_shapes.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/spline_series/customized_spline_chart.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/spline_series/default_spline_chart.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/spline_series/spline_types.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/spline_series/spline_with_dashes.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/spline_series/vertical_spline_chart.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/stacked_series/stacked_area_chart.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/stepLine_series/default_stepline_chart.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/stacked_series/stacked_bar_chart.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/stacked_series/stacked_column_chart.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/stacked_series/stacked_line_chart.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/stepLine_series/stepline_with_dashes.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/stepLine_series/vertical_stepline_chart.dart';
import 'package:flutter_examples/samples/chart/circular_charts/doughnut_series/default_doughnut_chart.dart';
import 'package:flutter_examples/samples/chart/circular_charts/doughnut_series/doughnut_with_center_elevation.dart';
import 'package:flutter_examples/samples/chart/circular_charts/doughnut_series/doughnut_with_color_mapping.dart';
import 'package:flutter_examples/samples/chart/circular_charts/doughnut_series/doughnut_with_rounded_corners.dart';
import 'package:flutter_examples/samples/chart/circular_charts/doughnut_series/semi_doughnut_chart.dart';
import 'package:flutter_examples/samples/chart/circular_charts/pie_series/default_pie_chart.dart';
import 'package:flutter_examples/samples/chart/circular_charts/pie_series/pie_with_grouping.dart';
import 'package:flutter_examples/samples/chart/circular_charts/pie_series/pie_with_smart_labels.dart';
import 'package:flutter_examples/samples/chart/circular_charts/pie_series/pie_with_various_radius.dart';
import 'package:flutter_examples/samples/chart/circular_charts/pie_series/semi_pie_chart.dart';
import 'package:flutter_examples/samples/chart/circular_charts/radialbar_series/customized_radialbar_chart.dart';
import 'package:flutter_examples/samples/chart/circular_charts/radialbar_series/default_radialbar_chart.dart';
import 'package:flutter_examples/samples/chart/circular_charts/radialbar_series/radialbar_with_legend.dart';
import 'package:flutter_examples/samples/chart/dynamic_updates/add_remove_data/add_remove_points.dart';
import 'package:flutter_examples/samples/chart/dynamic_updates/add_remove_data/add_remove_series.dart';
import 'package:flutter_examples/samples/chart/dynamic_updates/live_update/live_update.dart';
import 'package:flutter_examples/samples/chart/dynamic_updates/live_update/vertical_live_chart.dart';
import 'package:flutter_examples/samples/chart/dynamic_updates/update_data_source/update_data_source.dart';
import 'package:flutter_examples/samples/chart/funnel_charts/default_funnel_chart.dart';
import 'package:flutter_examples/samples/chart/funnel_charts/funnel_with_legend.dart';
import 'package:flutter_examples/samples/chart/funnel_charts/funnel_with_smart_labels.dart';
import 'package:flutter_examples/samples/chart/home/axes_features_home.dart';
import 'package:flutter_examples/samples/chart/home/axis_types.dart';
import 'package:flutter_examples/samples/chart/home/cartesian_types.dart';
import 'package:flutter_examples/samples/chart/home/circular_types.dart';
import 'package:flutter_examples/samples/chart/home/dynamic_updates.dart';
import 'package:flutter_examples/samples/chart/home/funnel_chart.dart';
import 'package:flutter_examples/samples/chart/home/legend_home.dart';
import 'package:flutter_examples/samples/chart/home/other_features.dart';
import 'package:flutter_examples/samples/chart/home/pyramid_chart.dart';
import 'package:flutter_examples/samples/chart/home/user_interaction.dart';
import 'package:flutter_examples/samples/chart/legend/chart_with_customized_legend.dart';
import 'package:flutter_examples/samples/chart/legend/chart_with_legend.dart';
import 'package:flutter_examples/samples/chart/legend/legend_with_various_options.dart';
import 'package:flutter_examples/samples/chart/pyramid_charts/default_pyramid_chart.dart';
import 'package:flutter_examples/samples/chart/pyramid_charts/pyramid_with_legend.dart';
import 'package:flutter_examples/samples/chart/pyramid_charts/pyramid_with_smart_labels.dart';
import 'package:flutter_examples/samples/chart/series_features/animation/series_animation.dart';
import 'package:flutter_examples/samples/chart/series_features/animation/dynamic_animation.dart';
import 'package:flutter_examples/samples/chart/series_features/annotation/chart_with_annotation.dart';
import 'package:flutter_examples/samples/chart/series_features/annotation/chart_with_watermark.dart';
import 'package:flutter_examples/samples/chart/series_features/data_label/default_datalabels.dart';
import 'package:flutter_examples/samples/chart/series_features/empty_point/chart_with_empty_points.dart';
import 'package:flutter_examples/samples/chart/series_features/marker/various_marker_shapes.dart';
import 'package:flutter_examples/samples/chart/axis_features/plot_band/Plot_band_recurrence.dart';
import 'package:flutter_examples/samples/chart/axis_features/plot_band/plot_band.dart';
import 'package:flutter_examples/samples/chart/series_features/sorting/sorting_options.dart';
import 'package:flutter_examples/samples/chart/user_interactions/crosshair/chart_with_crosshair.dart';
import 'package:flutter_examples/samples/chart/user_interactions/selection/selection_modes.dart';
import 'package:flutter_examples/samples/chart/user_interactions/tooltip/default_tooltip.dart';
import 'package:flutter_examples/samples/chart/user_interactions/trackball/chart_with_trackball.dart';
import 'package:flutter_examples/samples/chart/user_interactions/zooming_panning/pinch_zooming.dart';
import 'package:flutter_examples/samples/chart/user_interactions/zooming_panning/selection_zooming.dart';
import 'package:flutter_examples/samples/chart/user_interactions/zooming_panning/zooming_with_custom_buttons.dart';
import 'package:flutter_examples/samples/chart/home/radial_gauge.dart';
import 'package:flutter_examples/samples/gauge/axis_feature/default_gauge_view.dart';
import 'package:flutter_examples/samples/gauge/axis_feature/multiple_axis.dart';
import 'package:flutter_examples/samples/gauge/ranges/range_thickness.dart';
import 'package:flutter_examples/samples/gauge/ranges/range_dataLabel.dart';
import 'package:flutter_examples/samples/gauge/pointers/multiple_ranges.dart';
import 'package:flutter_examples/samples/gauge/showcase/gauge_overview.dart';
import 'package:flutter_examples/samples/gauge/showcase/clock_sample.dart';
import 'package:flutter_examples/samples/gauge/showcase/distance_tracker.dart';
import 'package:flutter_examples/samples/gauge/animation/radial_bounceout.dart';
import 'package:flutter_examples/samples/gauge/animation/radial_easeanimation.dart';
import 'package:flutter_examples/samples/gauge/animation/radial_easeincirc.dart';
import 'package:flutter_examples/samples/gauge/animation/radial_linearanimation.dart';
import 'package:flutter_examples/samples/gauge/animation/radial_elasticout.dart';
import 'package:flutter_examples/samples/gauge/animation/radial_slowmiddle.dart';
import 'package:flutter_examples/samples/gauge/animation/radial_easeout.dart';
import 'package:flutter_examples/samples/gauge/ranges/multiple_ranges.dart';
import 'package:flutter_examples/samples/gauge/pointers/multiple_needle.dart';
import 'package:flutter_examples/samples/gauge/pointers/radial_marker.dart';
import 'package:flutter_examples/samples/gauge/pointers/text_pointer.dart';
import 'package:flutter_examples/samples/gauge/annotation/image_annotation.dart';
import 'package:flutter_examples/samples/gauge/annotation/text_annotation.dart';
import 'package:flutter_examples/samples/gauge/annotation/direction_compass.dart';
import 'package:flutter_examples/samples/gauge/axis_feature/radiallabel_customization.dart';
import 'package:flutter_examples/samples/gauge/axis_feature/tick_customization.dart';
import 'package:flutter_examples/samples/gauge/axis_feature/non_linearlabel.dart';
import 'package:flutter_examples/samples/gauge/axis_feature/custom_labels.dart';
import 'package:flutter_examples/samples/gauge/axis_feature/range_colors.dart';
import 'package:flutter_examples/samples/gauge/pointer_interaction/radial_pointerdragging.dart';
import 'model.dart';

void onTapControlItem(
    BuildContext context, SampleListModel model, int position) {
  final SampleList sample = model.controlList[position];
  model.selectedIndex = position;
  if (sample.title == 'Cartesian Charts') {
    Navigator.push<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => const CartesianTypes()));
  }
  if (sample.title == 'Axis Types') {
    Navigator.push<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => const AxisTypes()));
  }
  if (sample.title == 'Axis Features') {
    Navigator.push<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => const AxesFeatures()));
  }
  if (sample.title == 'Circular Charts') {
    Navigator.push<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => const CircularTypes()));
  }
  if (sample.title == 'Radial Gauge') {
    Navigator.push<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => const RadialGaugeExamples()));
  }
  if (sample.title == 'Pyramid Chart') {
    Navigator.push<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => const PyramidFeatures()));
  }
  if (sample.title == 'Funnel Chart') {
    Navigator.push<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => const FunnelCharts()));
  }
  if (sample.title == 'Series Features') {
    Navigator.push<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => const SeriesFeatures()));
  }
  if (sample.title == 'Legend') {
    Navigator.push<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => const LegendFeatures()));
  }
  if (sample.title == 'User Interactions') {
    Navigator.push<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => const InteractionTypes()));
  }
  if (sample.title == 'Dynamic Updates') {
    Navigator.push<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => const DynamicUpdates()));
  }
}

class PyramidType {
}

void onTapSampleItem(BuildContext context, SubItemList sample) {
  //......................Cartesian Charts...............................//
  if (sample.category == 'Line') {
    if (sample.title == 'Default line chart') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => LineDefault(sample)));
    } else if (sample.title == 'Line with dashes') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => LineDashed(sample)));
    } else if (sample.title == 'Customized line chart') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => CustomizedLine(sample)));
    } else if (sample.title == 'Multi-colored line') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => LineMultiColor(sample)));
    }
  } else if (sample.category == 'Column') {
    if (sample.title == 'Default column chart') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => ColumnDefault(sample)));
    } else if (sample.title == 'Column with rounded corners') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => ColumnRounded(sample)));
    } else if (sample.title == 'Back to back column') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => ColumnBack(sample)));
    } else if (sample.title == 'Column with track') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => ColumnTracker(sample)));
    } else if (sample.title == 'Column width and spacing') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => ColumnSpacing(sample)));
    } else if (sample.title == 'Customized column chart') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => ColumnVertical(sample)));
    }
  } else if (sample.category == 'Spline') {
    if (sample.title == 'Default spline chart') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => SplineDefault(sample)));
    } else if (sample.title == 'Spline with dashes') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => SplineDashed(sample)));
    } else if (sample.title == 'Spline types') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => SplineTypes(sample)));
    } else if (sample.title == 'Vertical spline chart') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => SplineVertical(sample)));
    } else if (sample.title == 'Customized spline chart') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => SplineCustomization(sample)));
    }
  } else if (sample.category == 'Area') {
    if (sample.title == 'Default area chart') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => AreaDefault(sample)));
    } else if (sample.title == 'Area with gradient') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => AreaGradient(sample)));
    } else if (sample.title == 'Area with empty points') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => AreaEmpty(sample)));
    } else if (sample.title == 'Vertical area chart') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => AreaVertical(sample)));
    }
  } else if (sample.category == 'Bar') {
    if (sample.title == 'Default bar chart') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => BarDefault(sample)));
    } else if (sample.title == 'Bar with rounded corners') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => BarRounded(sample)));
    } else if (sample.title == 'Bar width and spacing') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => BarSpacing(sample)));
    } else if (sample.title == 'Bar with track') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => BarTracker(sample)));
    } else if (sample.title == 'Customized bar chart') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => BarCustomization(sample)));
    }
  } else if (sample.category == 'Bubble') {
    if (sample.title == 'Default bubble chart') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => BubbleDefault(sample)));
    } else if (sample.title == 'Bubble with various colors') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => BubblePointColor(sample)));
    } else if (sample.title == 'Bubble filled with gradient') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => BubbleGradient(sample)));
    } else if (sample.title == 'Bubble with multiple series') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => BubbleMultiSeries(sample)));
    }
  } else if (sample.category == 'Scatter') {
    if (sample.title == 'Default scatter chart') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => ScatterDefault(sample)));
    } else if (sample.title == 'Scatter with various shapes') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => ScatterShapes(sample)));
    }
  } else if (sample.category == 'Step Line') {
    if (sample.title == 'Default step line chart') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => StepLineDefault(sample)));
    } else if (sample.title == 'Step line with dashes') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => StepLineDashed(sample)));
    } else if (sample.title == 'Vertical step line chart') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => StepLineVertical(sample)));
    }
  } else if (sample.category == 'Range Column') {
    if (sample.title == 'Default range column chart') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => RangeColumnDefault(sample)));
    } else if (sample.title == 'Transposed range column') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => RangeBarChart(sample)));
    } else if (sample.title == 'Range column with track') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => RangeColumnWithTrack(sample)));
    }
  }
  else if (sample.category == 'Stacked Charts') {
    if (sample.title == 'Stacked bar chart') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => StackedBarChart(sample)));
    } else if (sample.title == 'Stacked column chart') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => StackedColumnChart(sample)));
    }
    else if (sample.title == 'Stacked area chart') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => StackedAreaChart(sample)));
    } else if (sample.title == 'Stacked line chart') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => StackedLineChart(sample)));
    }
  }
  //......................Cartesian Charts End...............................//

  //......................Axis Types...............................//

  else if (sample.category == 'Numeric') {
    if (sample.title == 'Default numeric axis') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => NumericDefault(sample)));
    } else if (sample.title == 'Numeric axis with label format') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => NumericLabel(sample)));
    } else if (sample.title == 'Inversed numeric axis') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => NumericInverse(sample)));
    }
  } else if (sample.category == 'Category') {
    if (sample.title == 'Default category axis') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => CategoryDefault(sample)));
    } else if (sample.title == 'Arranged by index') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => CategoryIndexed(sample)));
    } else if (sample.title == 'Label placement') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => CategoryTicks(sample)));
    }
  } else if (sample.category == 'Date time') {
    if (sample.title == 'Default Date time axis') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => DateTimeDefault(sample)));
    } else if (sample.title == 'Date time axis with label format') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => DateTimeLabel(sample)));
    }
  } else if (sample.category == 'Logarithmic') {
    if (sample.title == 'Default logarithmic axis') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) =>
                  LogarithmicAxisDefault(sample)));
    }
    else if (sample.title == 'Inversed logarithmic axis') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) =>
                  LogarithmicAxisInversed(sample)));
    }
  } else if (sample.category == 'Axis Features') {
    if (sample.title == 'Opposed axes') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => NumericOpposed(sample)));
    } else if (sample.title == 'Multiple axis chart') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => MultipleAxis(sample)));
    } else if (sample.title == 'Handling labels collision') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => LabelAction(sample)));
    } else if (sample.title == 'Edge label placement') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => EdgeLabel(sample)));
    } else if (sample.title == 'Axis crossing') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => AxisCrossing(sample)));
    }
  }

  //......................End Axis Types...............................//

  //......................Circular Types...............................//

  else if (sample.category == 'Pie') {
    if (sample.title == 'Default pie chart') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => PieDefault(sample)));
    } else if (sample.title == 'Pie with various radius') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => PieRadius(sample)));
    } else if (sample.title == 'Semi-pie chart') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => PieSemi(sample)));
    } else if (sample.title == 'Pie with grouping') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => PieGrouping(sample)));
    } else if (sample.title == 'Pie with smart labels') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => PieSmartLabels(sample)));
    }
  } else if (sample.category == 'Doughnut') {
    if (sample.title == 'Default doughnut chart') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => DoughnutDefault(sample)));
    } else if (sample.title == 'Semi-doughnut chart') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => DoughnutSemi(sample)));
    } else if (sample.title == 'Doughnut with rounded corners') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => DoughnutRounded(sample)));
    } else if (sample.title == 'Doughnut with color mapping') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) =>
                  DoughnutCustomization(sample)));
    } else if (sample.title == 'Doughnut with center elevation') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => DoughnutElevation(sample)));
    }
  } else if (sample.category == 'Radial Bar') {
    if (sample.title == 'Default radial bar chart') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => RadialBarDefault(sample)));
    } else if (sample.title == 'Radial bar with legend') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => RadialBarAngle(sample)));
    } else if (sample.title == 'Customized radial bar chart') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => RadialBarCustomized(sample)));
    }
  }

  //......................End Circular Types...............................//

  //......................Triangular Types...............................//
  else if (sample.category == 'Pyramid') {
    if (sample.title == 'Default pyramid chart') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => PyramidDefault(sample)));
    } else if (sample.title == 'Pyramid with smart labels') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => PyramidSmartLabels(sample)));
    } else if (sample.title == 'Pyramid with legend') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => PyramidLegend(sample)));
    }
  } else if (sample.category == 'Funnel') {
    if (sample.title == 'Default funnel chart') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => FunnelDefault(sample)));
    } else if (sample.title == 'Funnel with smart labels') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => FunnelSmartLabels(sample)));
    } else if (sample.title == 'Funnel with legend') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => FunnelLegend(sample)));
    }
  }

  //......................End Triangular Types..................................//

  //......................Dynamic Updates..................................//

  else if (sample.category == 'Live Update') {
    if (sample.title == 'Live update') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => LiveUpdate(sample)));
    } else if (sample.title == 'Vertical live chart') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) =>
                  VerticalLineLiveUpdate(sample)));
    }
  } else if (sample.category == 'Add/Remove Data') {
    if (sample.title == 'Add/remove points') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => AddDataPoints(sample)));
    } else if (sample.title == 'Add/remove series') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => AddSeries(sample)));
    }
  }
  if (sample.category == 'Update Data Source') {
    if (sample.title == 'Update data source') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => UpdateDataSource(sample)));
    }
  }

  //......................End Dynamic Updates................................//

  //......................Series Features......................................//

  else if (sample.category == 'Legend') {
    if (sample.title == 'Chart with legend') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => LegendDefault(sample)));
    } else if (sample.title == 'Chart with customized legend') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => LegendCustomized(sample)));
    } else if (sample.title == 'Legend with various options') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => LegendOptions(sample)));
    }
  } else if (sample.category == 'Marker') {
    if (sample.title == 'Various marker shapes') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => MarkerDefault(sample)));
    }
  } else if (sample.category == 'Data Label') {
    if (sample.title == 'Default data labels') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => DataLabelDefault(sample)));
    }
  } else if (sample.category == 'Empty Points') {
    if (sample.title == 'Chart with empty points') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => EmptyPoints(sample)));
    }
  } else if (sample.category == 'Annotation') {
    if (sample.title == 'Chart with annotation') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => AnnotationWatermark(sample)));
    }
    if (sample.title == 'Chart with watermark') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => AnnotationDefault(sample)));
    }
  } else if (sample.category == 'Sorting') {
    if (sample.title == 'Sorting options') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => SortingDefault(sample)));
    }
  } else if (sample.category == 'Axis Features') {
    if (sample.title == 'Plot band') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => PlotBandDefault(sample)));
    } else if (sample.title == 'Plot band recurrence') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => PlotBandRecurrence(sample)));
    }
  } else if (sample.category == 'Animation') {
    if (sample.title == 'Series animation') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => AnimationDefault(sample)));
    }
    if (sample.title == 'Dynamic update') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) =>
                  CartesianDynamicAnimation(sample)));
    }
  }

  //......................End Series Features......................................//

  //......................User Interactions......................................//

  else if (sample.category == 'Tooltip') {
    if (sample.title == 'Default tooltip') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => DefaultTooltip(sample)));
    }
  } else if (sample.category == 'Zooming and Panning') {
    if (sample.title == 'Pinch zooming') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => DefaultPanning(sample)));
    } else if (sample.title == 'Selection zooming') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => DefaultZooming(sample)));
    } else if (sample.title == 'Zooming with custom buttons') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => ButtonZooming(sample)));
    }
  } else if (sample.category == 'Crosshair') {
    if (sample.title == 'Chart with crosshair') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => DefaultCrossHair(sample)));
    }
  } else if (sample.category == 'Trackball') {
    if (sample.title == 'Chart with trackball') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => DefaultTrackball(sample)));
    }
  } else if (sample.category == 'Selection') {
    if (sample.title == 'Selection modes') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => DefaultSelection(sample)));
    }
  }


//......................Radial Gauge...............................//
  else if (sample.category == 'Showcase') {
    if (sample.title == 'Clock') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => ClockExample(sample)));
    } else if (sample.title == 'Temperature Monitor') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => GaugeOverviewExample(sample)));
    } else if (sample.title == 'Distance Tracker') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) =>
                  DistanceTrackerExample(sample)));
    }
  } else if (sample.category == 'Axis') {
    if (sample.title == 'Default view') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => RadialGaugeDefault(sample)));
    } else if (sample.title == 'Multiple axis') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => MultipleAxisExample(sample)));
    } else if (sample.title == 'Label Customization') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) =>
                  RadialLabelCustomization(sample)));
    } else if (sample.title == 'Tick Customization') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) =>
                  RadialTickCustomization(sample)));
    } else if (sample.title == 'Custom Scale') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => RadialNonLinearLabel(sample)));
    } else if (sample.title == 'Custom Labels') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => GaugeCustomLabels(sample)));
    } else if (sample.title == 'Range colors for axis') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => RangeColorForLabels(sample)));
    }
  } else if (sample.category == 'Pointers') {
    if (sample.title == 'Range Pointer') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) =>
                  MultipleRangePointerExample(sample)));
    } else if (sample.title == 'Multiple Needle') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) =>
                  MultipleNeedleExample(sample)));
    } else if (sample.title == 'Marker Pointer') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => RadialMarkerExample(sample)));
    } else if (sample.title == 'Text Pointer') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => RadialTextPointer(sample)));
    }
  } else if (sample.category == 'Range') {
    if (sample.title == 'Multiple Ranges') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) =>
                  MultipleRangesExample(sample)));
    } else if (sample.title == 'Range Label') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) =>
                  RangeDataLabelExample(sample)));
    } else if (sample.title == 'Range Thickness') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) =>
                  RangeThicknessExample(sample)));
    }
  } else if (sample.category == 'Gauge Annotation') {
    if (sample.title == 'Temperature Tracker') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) =>
                  RadialImageAnnotation(sample)));
    } else if (sample.title == 'Direction Compass') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => RadialCompass(sample)));
    } else if (sample.title == 'Text Annotation') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => RadialTextAnnotation(sample)));
    }
  } else if (sample.category == 'Pointer Interaction') {
    if (sample.title == 'Pointer Dragging') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) =>
                  RadialPointerDragging(sample)));
    }
  } else if (sample.category == 'Pointer Animation') {
    if (sample.title == 'Bounce Out') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) =>
                  RadialBounceOutExample(sample)));
    } else if (sample.title == 'Ease') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => RadialEaseExample(sample)));
    } else if (sample.title == 'EaseInCirc') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) =>
                  RadialEaseInCircExample(sample)));
    } else if (sample.title == 'Linear') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) =>
                  RadialLinearAnimation(sample)));
    } else if (sample.title == 'ElasticOut') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) =>
                  RadialElasticOutAnimation(sample)));
    } else if (sample.title == 'SlowMiddle') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) =>
                  RadialSlowMiddleAnimation(sample)));
    } else if (sample.title == 'EaseOutBack') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) =>
                  RadialEaseOutAnimation(sample)));
    }
  }
}

String getStatus(List<SubItemList> model) {
  int newCount = 0;
  int updateCount = 0;
  for (int i = 0; i < model.length; i++) {
    if (model.isNotEmpty && model[i].status != null) {
      if (model[i].status == 'New') {
        newCount++;
      } else if (model[i].status == 'Updated') {
        updateCount++;
      }
    }
  }
  return (newCount == model.length)
      ? 'N'
      : (newCount != 0 || updateCount != 0) ? 'U' : '';
}

List<Widget> getTabs(SampleListModel model) {
  final List<Widget> tabs = <Widget>[];
  for (int i = 0;
      i < model.controlList[model.selectedIndex].subItemList.length;
      i++) {
    if (model.controlList[model.selectedIndex].subItemList[i].isNotEmpty) {
      final String str =
          getStatus(model.controlList[model.selectedIndex].subItemList[i]);
      tabs.add(Tab(
          child: Row(
        children: <Widget>[
          Text(model
                  .controlList[model.selectedIndex].subItemList[i][0]?.category
                  .toString() +
              (str != '' ? '  ' : '')),
          Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              color: str == 'N'
                 ? const Color.fromRGBO(101, 193, 0, 1)
                  : str == 'U'
                     ? const Color.fromRGBO(245, 166, 35, 1)
                      : Colors.transparent,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              str,
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      )));
    }
  }
  return tabs;
}

List<Widget> getCardViewChildren(SampleListModel model) {
  final List<Widget> tabChildren = <Widget>[];
  for (int i = 0;
      i < model.controlList[model.selectedIndex].subItemList.length;
      i++) {
    tabChildren.add(ListView.builder(
        cacheExtent: model
            .controlList[model.selectedIndex].subItemList[i].length
            .toDouble(),
        addAutomaticKeepAlives: true,
        itemCount: model.controlList[model.selectedIndex].subItemList[i].length,
        itemBuilder: (BuildContext context, int position) {
          return Container(
            color: model.slidingPanelColor,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Card(
                          elevation: 2,
                          color: model.cardThemeColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          child: Column(
                            children: <Widget>[
                              InkWell(
                                splashColor: Colors.grey.withOpacity(0.4),
                                onTap: () {
                                  Feedback.forLongPress(context);
                                  onTapSampleItem(
                                      context,
                                      model.controlList[model.selectedIndex]
                                          .subItemList[i][position]);
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          '${model.controlList[model.selectedIndex].subItemList[i][position].title}',
                                          textAlign: TextAlign.left,
                                          softWrap: true,
                                          textScaleFactor: 1,
                                          overflow: TextOverflow.fade,
                                          style: TextStyle(
                                              fontFamily: 'MontserratMedium',
                                              fontSize: 16.0,
                                              color: model.textColor,
                                              letterSpacing: 0.2),
                                        ),
                                        Container(
                                            child: Row(
                                          children: <Widget>[
                                            Container(
                                                decoration: BoxDecoration(
                                                    color: model.controlList[model.selectedIndex].subItemList[i][position].status != null
                                                        ? (model.controlList[model.selectedIndex].subItemList[i][position].status == 'New'
                                                           ? const Color.fromRGBO(
                                                                101, 193, 0, 1)
                                                            : const Color.fromRGBO(
                                                                245, 166, 35, 1))
                                                        : Colors.transparent,
                                                    shape: BoxShape.rectangle,
                                                    borderRadius: const BorderRadius.all(
                                                        Radius.circular(10.0))),
                                                padding: const EdgeInsets.fromLTRB(
                                                    6, 3, 6, 3),
                                                child: Text(
                                                    model.controlList[model.selectedIndex].subItemList[i][position].status != null
                                                        ? model.controlList[model.selectedIndex].subItemList[i][position].status
                                                        : '',
                                                    style: TextStyle(color: Colors.white))),
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(left: 15),
                                            ),
                                            Container(
                                              height: 24,
                                              width: 24,
                                              color: Colors.transparent,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        5, 0, 5, 5),
                                                child: Image.asset(
                                                    'images/fullscreen.png',
                                                    fit: BoxFit.contain,
                                                    height: 20,
                                                    width: 20,
                                                    color: model.listIconColor),
                                              ),
                                            ),
                                          ],
                                        )),
                                      ]),
                                ),
                              ),
                              InkWell(
                                onTap: () {},
                                splashColor: Colors.grey.withOpacity(0.4),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 230,
                                    child: model
                                        .controlList[model.selectedIndex]
                                        .subItemList[i][position]
                                        .previewWidget,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }));
  }
  return tabChildren;
}

///Below methods for calendar control - (to show the samples in tabview instead of tileview)
List<Widget> getSecondaryTabBar(SampleListModel model) {
 final List<Widget> tabs = <Widget>[];
  for (int i = 0;
      i < model.controlList[model.selectedIndex].subItemList.length;
      i++) {
    if (model.controlList[model.selectedIndex].subItemList[i].isNotEmpty) {
      tabs.add(Container(
        alignment: Alignment.center,
        child: DefaultTabController(
            length:
                model.controlList[model.selectedIndex].subItemList[i].length,
            child: Scaffold(
                appBar: PreferredSize(
                  child: AppBar(
                    backgroundColor: model.backgroundColor,
                    bottom: TabBar(
                      indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(
                            width: 3.0, color: const Color.fromRGBO(252, 220, 0, 1)),
                      ),
                      isScrollable: true,
                      tabs: getSecondaryTabs(model, i),
                    ),
                  ),
                  preferredSize: Size.fromHeight(48.0),
                ),
                body: TabBarView(children: getTabViewChildren(model, i)))),
      ));
    }
  }
  return tabs;
}

List<Widget> getSecondaryTabs(SampleListModel model, int i) {
  final List<Widget> tabs = <Widget>[];
  for (int j = 0;
      j < model.controlList[model.selectedIndex].subItemList[i].length;
      j++) {
    final String str =
        getStatus(model.controlList[model.selectedIndex].subItemList[i]);
    tabs.add(Tab(
        child: Row(
      children: <Widget>[
        Text(
          model.controlList[model.selectedIndex].subItemList[i][j].title +
              (str != '' ? '  ' : ''),
        ),
        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            color: str == 'N'
                ? const Color.fromRGBO(101, 193, 0, 1)
                : str == 'U'
                   ? const Color.fromRGBO(245, 166, 35, 1)
                    : Colors.transparent,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            str,
            style: TextStyle(fontSize: 12),
          ),
        ),
      ],
    )));
  }
  return tabs;
}

List<Widget> getTabViewChildren(SampleListModel model, int i) {
  final List<Widget> tabs = <Widget>[];
  for (int j = 0;
      j < model.controlList[model.selectedIndex].subItemList[i].length;
      j++) {
    tabs.add(Container(
        child: model
            .controlList[model.selectedIndex].subItemList[i][j].previewWidget));
  }
  return tabs;
}