import 'package:flutter/material.dart';
import 'package:flutter_examples/samples/chart/axis_features/handling_label_collision/handling_label_collision.dart';
import 'package:flutter_examples/samples/chart/axis_features/multiple_axis_chart/multiple_axis_chart.dart';
import 'package:flutter_examples/samples/chart/axis_features/opposed_axes/opposed_axes.dart';
import 'package:flutter_examples/samples/chart/axis_features/edge_label_placement/edgelabel_placement.dart';
import 'package:flutter_examples/samples/chart/axis_types/category_types/default_category_axis.dart';
import 'package:flutter_examples/samples/chart/axis_types/category_types/indexed_category_axis.dart';
import 'package:flutter_examples/samples/chart/axis_types/category_types/label_placement.dart';
import 'package:flutter_examples/samples/chart/axis_types/date_time_types/date_time_axis_with_label_format.dart';
import 'package:flutter_examples/samples/chart/axis_types/date_time_types/default_date_time_axis.dart';
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
import 'package:flutter_examples/samples/chart/cartesian_charts/scatter_series/default_scatter_chart.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/scatter_series/scatter_with_various_shapes.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/spline_series/customized_spline_chart.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/spline_series/default_spline_chart.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/spline_series/spline_types.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/spline_series/spline_with_dashes.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/spline_series/vertical_spline_chart.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/stepLine_series/default_stepline_chart.dart';
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
import 'package:flutter_examples/samples/chart/home/axes_features_home.dart';
import 'package:flutter_examples/samples/chart/home/axis_types.dart';
import 'package:flutter_examples/samples/chart/home/cartesian_types.dart';
import 'package:flutter_examples/samples/chart/home/circular_types.dart';
import 'package:flutter_examples/samples/chart/home/dynamic_updates.dart';
import 'package:flutter_examples/samples/chart/home/legend_home.dart';
import 'package:flutter_examples/samples/chart/home/other_features.dart';
import 'package:flutter_examples/samples/chart/home/user_interaction.dart';
import 'package:flutter_examples/samples/chart/legend/chart_with_customized_legend.dart';
import 'package:flutter_examples/samples/chart/legend/chart_with_legend.dart';
import 'package:flutter_examples/samples/chart/legend/legend_with_various_options.dart';
import 'package:flutter_examples/samples/chart/series_features/animation/series_animation.dart';
import 'package:flutter_examples/samples/chart/series_features/annotation/chart_with_annotation.dart';
import 'package:flutter_examples/samples/chart/series_features/annotation/chart_with_watermark.dart';
import 'package:flutter_examples/samples/chart/series_features/data_label/default_datalabels.dart';
import 'package:flutter_examples/samples/chart/series_features/empty_point/chart_with_empty_points.dart';
import 'package:flutter_examples/samples/chart/series_features/marker/various_marker_shapes.dart';
import 'package:flutter_examples/samples/chart/series_features/sorting/sorting_options.dart';
import 'package:flutter_examples/samples/chart/user_interactions/crosshair/chart_with_crosshair.dart';
import 'package:flutter_examples/samples/chart/user_interactions/selection/selection_modes.dart';
import 'package:flutter_examples/samples/chart/user_interactions/tooltip/default_tooltip.dart';
import 'package:flutter_examples/samples/chart/user_interactions/trackball/chart_with_trackball.dart';
import 'package:flutter_examples/samples/chart/user_interactions/zooming_panning/pinch_zooming.dart';
import 'package:flutter_examples/samples/chart/user_interactions/zooming_panning/selection_zooming.dart';
import 'package:flutter_examples/samples/chart/user_interactions/zooming_panning/zooming_with_custom_buttons.dart';
import 'model.dart';

void onTapControlItem(
    BuildContext context, SampleListModel model, int position) {
  var sample = model.controlList[position];
  model.selectedIndex = position;
  if (sample.title == 'Cartesian Charts') {
    Navigator.push<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => CartesianTypes()));
  }
  if (sample.title == 'Axis Types') {
    Navigator.push<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => AxisTypes()));
  }
  if (sample.title == 'Axis Features') {
    Navigator.push<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => AxesFeatures()));
  }
  if (sample.title == 'Circular Charts') {
    Navigator.push<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => CircularTypes()));
  }
  if (sample.title == 'Series Features') {
    Navigator.push<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => SeriesFeatures()));
  }
  if (sample.title == 'Legend') {
    Navigator.push<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => LegendFeatures()));
  }
  if (sample.title == 'User Interactions') {
    Navigator.push<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => InteractionTypes()));
  }
  if (sample.title == 'Dynamic Updates') {
    Navigator.push<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => DynamicUpdates()));
  }
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
  } else if (sample.category == 'Animation') {
    if (sample.title == 'Series animation') {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => AnimationDefault(sample)));
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
}
//......................End User Interactions......................................//
