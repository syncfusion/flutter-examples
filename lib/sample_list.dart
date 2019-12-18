import 'samples/calendar/agenda_view/agenda_view.dart';
import 'samples/calendar/appointment_editor/appointment_editor.dart';
import 'samples/calendar/getting_started/getting_started.dart';
import 'samples/calendar/recurrence/recurrence.dart';
import 'samples/chart/axis_features/axis_crossing/axis_crossing.dart';
import 'samples/chart/axis_features/edge_label_placement/edgelabel_placement.dart';
import 'samples/chart/axis_features/handling_label_collision/handling_label_collision.dart';
import 'samples/chart/axis_features/multiple_axis_chart/multiple_axis_chart.dart';
import 'samples/chart/axis_features/opposed_axes/opposed_axes.dart';
import 'samples/chart/axis_features/plot_band/Plot_band_recurrence.dart';
import 'samples/chart/axis_features/plot_band/plot_band.dart';
import 'samples/chart/axis_types/category_types/default_category_axis.dart';
import 'samples/chart/axis_types/category_types/indexed_category_axis.dart';
import 'samples/chart/axis_types/category_types/label_placement.dart';
import 'samples/chart/axis_types/date_time_types/date_time_axis_with_label_format.dart';
import 'samples/chart/axis_types/date_time_types/default_date_time_axis.dart';
import 'samples/chart/axis_types/logarithmic_types/default_logarithmic_axis.dart';
import 'samples/chart/axis_types/logarithmic_types/inversed_logarithmic_axis.dart';
import 'samples/chart/axis_types/numeric_types/default_numeric_axis.dart';
import 'samples/chart/axis_types/numeric_types/inversed_numeric_axis.dart';
import 'samples/chart/axis_types/numeric_types/numeric_axis_with_label_format.dart';
import 'samples/chart/cartesian_charts/area_series/area_with_emptypoints.dart';
import 'samples/chart/cartesian_charts/area_series/area_with_gradient.dart';
import 'samples/chart/cartesian_charts/area_series/default_area_chart.dart';
import 'samples/chart/cartesian_charts/area_series/range_area.dart';
import 'samples/chart/cartesian_charts/area_series/spline_area.dart';
import 'samples/chart/cartesian_charts/area_series/step_area.dart';
import 'samples/chart/cartesian_charts/area_series/vertical_area_chart.dart';
import 'samples/chart/cartesian_charts/bar_series/bar_width_and_spacing.dart';
import 'samples/chart/cartesian_charts/bar_series/bar_with_rounded_corners.dart';
import 'samples/chart/cartesian_charts/bar_series/bar_with_track.dart';
import 'samples/chart/cartesian_charts/bar_series/customized_bar_chart.dart';
import 'samples/chart/cartesian_charts/bar_series/default_bar_chart.dart';
import 'samples/chart/cartesian_charts/bubble_series/bubble_filled_with_gradient.dart';
import 'samples/chart/cartesian_charts/bubble_series/bubble_with_multiple_series.dart';
import 'samples/chart/cartesian_charts/bubble_series/bubble_with_various_colors.dart';
import 'samples/chart/cartesian_charts/bubble_series/default_bubble_chart.dart';
import 'samples/chart/cartesian_charts/column_series/back_to_back_column.dart';
import 'samples/chart/cartesian_charts/column_series/column_width_and_spacing.dart';
import 'samples/chart/cartesian_charts/column_series/column_with_rounded_corners.dart';
import 'samples/chart/cartesian_charts/column_series/column_with_track.dart';
import 'samples/chart/cartesian_charts/column_series/customized_column_chart.dart';
import 'samples/chart/cartesian_charts/column_series/default_column_chart.dart';
import 'samples/chart/cartesian_charts/line_series/customized_line_chart.dart';
import 'samples/chart/cartesian_charts/line_series/default_line_chart.dart';
import 'samples/chart/cartesian_charts/line_series/line_with_dashes.dart';
import 'samples/chart/cartesian_charts/line_series/multi_colored_line.dart';
import 'samples/chart/cartesian_charts/rangecolumn_series/default_rangecolumn_chart.dart';
import 'samples/chart/cartesian_charts/rangecolumn_series/rangecolumn_with_track.dart';
import 'samples/chart/cartesian_charts/rangecolumn_series/vertical_rangecolumn_chart.dart';
import 'samples/chart/cartesian_charts/scatter_series/default_scatter_chart.dart';
import 'samples/chart/cartesian_charts/scatter_series/scatter_with_various_shapes.dart';
import 'samples/chart/cartesian_charts/spline_series/customized_spline_chart.dart';
import 'samples/chart/cartesian_charts/spline_series/default_spline_chart.dart';
import 'samples/chart/cartesian_charts/spline_series/spline_types.dart';
import 'samples/chart/cartesian_charts/spline_series/spline_with_dashes.dart';
import 'samples/chart/cartesian_charts/spline_series/vertical_spline_chart.dart';
import 'samples/chart/cartesian_charts/stacked_series/stacked_area_chart.dart';
import 'samples/chart/cartesian_charts/stacked_series/stacked_bar_chart.dart';
import 'samples/chart/cartesian_charts/stacked_series/stacked_column_chart.dart';
import 'samples/chart/cartesian_charts/stacked_series/stacked_line_chart.dart';
import 'samples/chart/cartesian_charts/stacked_series_100/stacked_area_100_chart.dart';
import 'samples/chart/cartesian_charts/stacked_series_100/stacked_bar_100_chart.dart';
import 'samples/chart/cartesian_charts/stacked_series_100/stacked_column_100_chart.dart';
import 'samples/chart/cartesian_charts/stacked_series_100/stacked_line_100_chart.dart';
import 'samples/chart/cartesian_charts/stepLine_series/default_stepline_chart.dart';
import 'samples/chart/cartesian_charts/stepLine_series/stepline_with_dashes.dart';
import 'samples/chart/cartesian_charts/stepLine_series/vertical_stepline_chart.dart';
import 'samples/chart/circular_charts/doughnut_series/default_doughnut_chart.dart';
import 'samples/chart/circular_charts/doughnut_series/doughnut_with_center_elevation.dart';
import 'samples/chart/circular_charts/doughnut_series/doughnut_with_color_mapping.dart';
import 'samples/chart/circular_charts/doughnut_series/doughnut_with_rounded_corners.dart';
import 'samples/chart/circular_charts/doughnut_series/semi_doughnut_chart.dart';
import 'samples/chart/circular_charts/pie_series/default_pie_chart.dart';
import 'samples/chart/circular_charts/pie_series/pie_with_grouping.dart';
import 'samples/chart/circular_charts/pie_series/pie_with_smart_labels.dart';
import 'samples/chart/circular_charts/pie_series/pie_with_various_radius.dart';
import 'samples/chart/circular_charts/pie_series/semi_pie_chart.dart';
import 'samples/chart/circular_charts/radialbar_series/customized_radialbar_chart.dart';
import 'samples/chart/circular_charts/radialbar_series/default_radialbar_chart.dart';
import 'samples/chart/circular_charts/radialbar_series/radialbar_with_legend.dart';
import 'samples/chart/circular_charts/user_interactions/selection/circular_selection.dart';
import 'samples/chart/circular_charts/user_interactions/tooltip/pie_tooltip_position.dart';
import 'samples/chart/dynamic_updates/add_remove_data/add_remove_points.dart';
import 'samples/chart/dynamic_updates/add_remove_data/add_remove_series.dart';
import 'samples/chart/dynamic_updates/live_update/real_time_line_chart.dart';
import 'samples/chart/dynamic_updates/live_update/real_time_spline_chart.dart';
import 'samples/chart/dynamic_updates/live_update/vertical_live_chart.dart';
import 'samples/chart/dynamic_updates/update_data_source/update_data_source.dart';
import 'samples/chart/funnel_charts/default_funnel_chart.dart';
import 'samples/chart/funnel_charts/funnel_with_legend.dart';
import 'samples/chart/funnel_charts/funnel_with_smart_labels.dart';
import 'samples/chart/legend/cartesian_legend_various_options.dart';
import 'samples/chart/legend/chart_with_customized_legend.dart';
import 'samples/chart/legend/chart_with_legend.dart';
import 'samples/chart/legend/legend_with_various_options.dart';
import 'samples/chart/pyramid_charts/default_pyramid_chart.dart';
import 'samples/chart/pyramid_charts/pyramid_with_legend.dart';
import 'samples/chart/pyramid_charts/pyramid_with_smart_labels.dart';
import 'samples/chart/series_features/animation/dynamic_animation.dart';
import 'samples/chart/series_features/animation/series_animation.dart';
import 'samples/chart/series_features/annotation/chart_with_annotation.dart';
import 'samples/chart/series_features/annotation/chart_with_watermark.dart';
import 'samples/chart/series_features/data_label/default_datalabels.dart';
import 'samples/chart/series_features/empty_point/chart_with_empty_points.dart';
import 'samples/chart/series_features/marker/various_marker_shapes.dart';
import 'samples/chart/series_features/sorting/sorting_options.dart';
import 'samples/chart/user_interactions/crosshair/chart_with_crosshair.dart';
import 'samples/chart/user_interactions/selection/selection_modes.dart';
import 'samples/chart/user_interactions/tooltip/default_tooltip.dart';
import 'samples/chart/user_interactions/tooltip/tooltip_position.dart';
import 'samples/chart/user_interactions/trackball/chart_with_trackball.dart';
import 'samples/chart/user_interactions/zooming_panning/pinch_zooming/pinch_zooming.dart';
import 'samples/chart/user_interactions/zooming_panning/selection_zooming/selection_zooming.dart';
import 'samples/chart/user_interactions/zooming_panning/zooming_with_custom_button/zooming_with_custom_buttons.dart';
import 'samples/gauge/animation/radial_bounce.dart';
import 'samples/gauge/animation/radial_easeanimation.dart';
import 'samples/gauge/animation/radial_easeincric.dart';
import 'samples/gauge/animation/radial_easeout.dart';
import 'samples/gauge/animation/radial_elasticout.dart';
import 'samples/gauge/animation/radial_linearanimation.dart';
import 'samples/gauge/animation/radial_slowmiddle.dart';
import 'samples/gauge/annotation/direct_compass.dart';
import 'samples/gauge/annotation/image_annotation.dart';
import 'samples/gauge/annotation/text_annotation.dart';
import 'samples/gauge/axis_feature/custom_labels.dart';
import 'samples/gauge/axis_feature/default_gauge_view.dart';
import 'samples/gauge/axis_feature/multiple_axis.dart';
import 'samples/gauge/axis_feature/non_linearable.dart';
import 'samples/gauge/axis_feature/radiallabel_customization.dart';
import 'samples/gauge/axis_feature/range_colors.dart';
import 'samples/gauge/axis_feature/tick_customization.dart';
import 'samples/gauge/pointer_interaction/radial_pointerdragging.dart';
import 'samples/gauge/pointer_interaction/radial_slider.dart';
import 'samples/gauge/pointers/multiple_needle.dart';
import 'samples/gauge/pointers/multiple_ranges.dart';
import 'samples/gauge/pointers/radial_marker.dart';
import 'samples/gauge/pointers/text_pointer.dart';
import 'samples/gauge/ranges/multiple_ranges.dart';
import 'samples/gauge/ranges/range_datalabels.dart';
import 'samples/gauge/ranges/range_thickness.dart';
import 'samples/gauge/showcase/clock_sample.dart';
import 'samples/gauge/showcase/distance_tracker.dart';
import 'samples/gauge/showcase/gauge_compass.dart';
import 'samples/gauge/showcase/gauge_overview.dart';

Map<String, List<dynamic>> getSampleWidget() {
  return <String, List<dynamic>>{
    //cartesian charts
    'default_line_chart':<dynamic>[getDefaultLineChart(true), LineDefault()],
    'line_with_dashes':<dynamic>[getDashedLineChart(true),LineDashed()],
    'multi_colored_line':<dynamic>[getMultiColorLineChart(true),LineMultiColor()],
    'customized_line_chart':<dynamic>[getCustomizedLineChart(true),CustomizedLine()],
    'default_column_chart':<dynamic>[getDefaultColumnChart(true),ColumnDefault()],
    'column_with_rounded_corners':<dynamic>[getRoundedColumnChart(true),ColumnRounded()],
    'back_to_back_column': <dynamic>[getBackColumnChart(true),ColumnBack()],
    'column_with_track':<dynamic>[getTrackerColumnChart(true), ColumnTracker()],
    'column_width_and_spacing':<dynamic>[getSpacingColumnChart(true),ColumnSpacing()],
    'customized_column_chart':<dynamic>[getCustomizedColumnChart(true),ColumnVertical()],
    'default_spline_chart':<dynamic>[getDefaultSplineChart(true),SplineDefault()],
    'spline_with_dashes':<dynamic>[getDashedSplineChart(true),SplineDashed()],
    'spline_types':<dynamic>[getTypesSplineChart(true),SplineTypes()],
    'vertical_spline_chart':<dynamic>[getVerticalSplineChart(true),SplineVertical()],
    'customized_spline_chart':<dynamic>[getCustomizedSplineChart(true),SplineCustomization()],
    'default_area_chart': <dynamic>[getDefaultAreaChart(true),AreaDefault()],
    'area_with_gradient':<dynamic>[getGradientAreaChart(true),AreaGradient()],
    'area_with_emptypoints':<dynamic>[getEmptyPointAreaChart(true),AreaEmpty()],
    'vertical_area_chart':<dynamic>[getVerticalAreaChart(true),AreaVertical()],
    'range_area':<dynamic>[getRangeAreaChart(true),RangeArea()],
    'step_area':<dynamic>[getStepAreaChart(true),StepArea()],
    'spline_area':<dynamic>[getSplineAreaChart(true),SplineArea()],
    'default_bar_chart':<dynamic>[getDefaultBarChart(true),BarDefault()],
    'bar_with_rounded_corners':<dynamic>[getRoundedBarChart(true),BarRounded()],
    'bar_width_and_spacing':<dynamic>[getSpacingBarChart(true),BarSpacing()],
    'bar_with_track':<dynamic>[getTrackerBarChart(true), BarTracker()],
    'customized_bar_chart': <dynamic>[getCustomizedBarChart(true),BarCustomization()],
    'default_bubble_chart':<dynamic>[getDefaultBubbleChart(true),BubbleDefault()],
    'bubble_with_various_colors':<dynamic>[getPointColorBubbleChart(true),BubblePointColor()],
    'bubble_filled_with_gradient':<dynamic>[getGradientBubbleChart(true),BubbleGradient()],
    'bubble_with_multiple_series':<dynamic>[getMultipleSeriesBubbleChart(true),BubbleMultiSeries()],
    'default_scatter_chart':<dynamic>[getDefaultScatterChart(true),ScatterDefault()],
    'scatter_with_various_shapes':<dynamic>[getShapesScatterChart(true),ScatterShapes()],
    'default_stepline_chart':<dynamic>[getDefaultStepLineChart(true),StepLineDefault()],
    'stepline_with_dashes':<dynamic>[getDashedStepLineChart(true),StepLineDashed()],
    'vertical_stepline_chart':<dynamic>[getVerticalStepLineChart(true),StepLineVertical()],
    'default_rangecolumn_chart':<dynamic>[getDefaultRangeColumnChart(true),RangeColumnDefault()],
    'vertical_rangecolumn_chart':<dynamic>[getRangeBarChart(true),RangeBarChart()],
    'rangecolumn_with_track':<dynamic>[getRangeColumnwithTrack(true),RangeColumnWithTrack()],
    'stacked_line_chart':<dynamic>[getStackedLineChart(true),StackedLineChart()],
    'stacked_area_chart':<dynamic>[getStackedAreaChart(true),StackedAreaChart()],
    'stacked_column_chart':<dynamic>[getStackedColumnChart(true),StackedColumnChart()],
    'stacked_bar_chart':<dynamic>[getStackedBarChart(true), StackedBarChart()],
    'stacked_area_100_chart':<dynamic>[getStackedArea100Chart(true), StackedArea100Chart()],
    'stacked_bar_100_chart':<dynamic>[getStackedBar100Chart(true), StackedBar100Chart()],
    'stacked_column_100_chart':<dynamic>[getStackedColumn100Chart(true), StackedColumn100Chart()],
    'stacked_line_100_chart':<dynamic>[getStackedLine100Chart(true), StackedLine100Chart()],
    'default_numeric_axis':<dynamic>[getDefaultNumericAxisChart(true),NumericDefault()],
    'numeric_axis_with_label_format':<dynamic>[getLabelNumericAxisChart(true),NumericLabel()],
    'inversed_numeric_axis':<dynamic>[getInversedNumericAxisChart(true),NumericInverse()],
    'default_category_axis':<dynamic>[getDefaultCategoryAxisChart(true),CategoryDefault()],
    'category_arranged_by_index':<dynamic>[getIndexedCategoryAxisChart(true),CategoryIndexed()],
    'category_label_placement':<dynamic>[getTicksCategoryAxisChart(true),CategoryTicks()],
    'default_datetime_axis':<dynamic>[getDefaultDateTimeAxisChart(true),DateTimeDefault()],
    'datetime_axis_with_label_format':<dynamic>[getLabelDateTimeAxisChart(true),DateTimeLabel()],
    'default_logarithmic_axis':<dynamic>[getDefaultLogarithmicAxisChart(true),LogarithmicAxisDefault()],
    'inversed_logarithmic_axis':<dynamic>[getInversedLogarithmicAxisChart(true),LogarithmicAxisInversed()], 
    //Axis Features
    'axis_crossing':<dynamic>[getAxisCrossingSample(true),AxisCrossing()],
    'edgelabel_placement':<dynamic>[getEdgeLabelPlacementChart(true),EdgeLabel()],
    'handling_label_collision':<dynamic>[getLabelIntersectActionChart(true),LabelAction()],
    'multiple_axis_chart':<dynamic>[getMultipleAxisLineChart(true),MultipleAxis()],
    'opposed_axes':<dynamic>[getOpposedNumericAxisChart(true),NumericOpposed()],
    'plot_band_recurrence':<dynamic>[getPlotBandRecurrenceChart(true),PlotBandRecurrence()],
    'plot_band':<dynamic>[getPlotBandChart(true),PlotBandDefault()],
    
    //Series Features
    'dynamic_animation':<dynamic>[getDynamicAnimationChart(true),CartesianDynamicAnimation()],
    'series_animation':<dynamic>[getDefaultAnimationChart(true),AnimationDefault()],
    'chart_with_annotation':<dynamic>[getWatermarkAnnotationChart(true),AnnotationWatermark()],
    'chart_with_watermark':<dynamic>[getDefaultAnnotationChart(true),AnnotationDefault()],
    'default_datalabels':<dynamic>[getDataLabelDefaultChart(true),DataLabelDefault()],
    'chart_with_empty_points':<dynamic>[getEmptyPointChart(true),EmptyPoints()],
    'various_marker_shapes':<dynamic>[getMarkerDefaultChart(true),MarkerDefault()],
    'sorting_options':<dynamic>[getDefaultSortingChart(true),SortingDefault()],
    
    //Legend
    'chart_with_customized_legend':<dynamic>[getLegendCustomizedChart(true),LegendCustomized()],
    'chart_with_legend':<dynamic>[getLegendDefaultChart(true),LegendDefault()],
    'legend_with_various_options':<dynamic>[getLegendOptionsChart(true),LegendOptions()],
    'cartesian_legend_various_options':<dynamic>[getCartesianLegendOptionsChart(true),CartesianLegendOptions()],
    
    //User Interaction
    'chart_with_crosshair':<dynamic>[getDefaultCrossHairChart(true),DefaultCrossHair()],
    'selection_modes':<dynamic>[getDefaultSelectionChart(true),DefaultSelection()],
    'default_tooltip':<dynamic>[getDefaultTooltipChart(true),DefaultTooltip()],
    'chart_with_trackball':<dynamic>[getDefaultTrackballChart(true),DefaultTrackball()],
    'pinch_zooming':<dynamic>[getDefaultPanningChart(true),DefaultPanning()],
    'selection_zooming':<dynamic>[getDefaultZoomingChart(true),DefaultZooming()],
    'zooming_with_custom_buttons':<dynamic>[getButtonZoomingChart(true),ButtonZooming()],
    'tooltip_position':<dynamic>[getCartesianTooltipPositionChart(true),CartesianTooltipPosition()],
    'circular_selection':<dynamic>[getCircularSelectionChart(true),CircularSelection()],
    'pie_tooltip_position':<dynamic>[getPieTooltipPositionChart(true),PieTooltipPosition()],

    //Dynamic updates
    'add_remove_points':<dynamic>[getAddRemovePointsChart(true),AddDataPoints()],
    'add_remove_series':<dynamic>[getAddRemoveSeriesChart(true),AddSeries()],
    'real_time_spline_chart':<dynamic>[getLiveUpdateChart(true),LiveUpdate()],
    'vertical_live_chart':<dynamic>[getVerticalLineUpdateChart(true),VerticalLineLiveUpdate()],
    'update_data_source':<dynamic>[getUpdateDataSourceChart(true),UpdateDataSource()],
    'real_time_line_chart':<dynamic>[getLiveLineChart(true),LiveLineChart()],

    //Pie
    'default_pie_chart':<dynamic>[getDefaultPieChart(true),PieDefault()],
    'pie_with_grouping':<dynamic>[getGroupingPieChart(true),PieGrouping()],
    'pie_with_smart_labels':<dynamic>[getSmartLabelPieChart(true),PieSmartLabels()],
    'pie_with_various_radius':<dynamic>[getRadiusPieChart(true),PieRadius()],
    'semi_pie_chart':<dynamic>[getSemiPieChart(true),PieSemi()],

    //Doughnut
    'default_doughnut_chart':<dynamic>[getDefaultDoughnutChart(true),DoughnutDefault()],
    'doughnut_with_center_elevation':<dynamic>[getElevationDoughnutChart(true),DoughnutElevation()],
    'doughnut_with_color_mapping':<dynamic>[getDoughnutCustomizationChart(true),DoughnutCustomization()],
    'doughnut_with_rounded_corners':<dynamic>[getRoundedDoughnutChart(true),DoughnutRounded()],
    'semi_doughnut_chart':<dynamic>[getSemiDoughnutChart(true),DoughnutSemi()],

    //Radialbar
    'customized_radialbar_chart':<dynamic>[getCustomizedRadialBarChart(true),RadialBarCustomized()],
    'default_radialbar_chart':<dynamic>[getDefaultRadialBarChart(true),RadialBarDefault()],
    'radialbar_with_legend':<dynamic>[getAngleRadialBarChart(true),RadialBarAngle()],

    //Funnel
    'default_funnel_chart':<dynamic>[getDefaultFunnelChart(true),FunnelDefault()],
    'funnel_with_legend':<dynamic>[getLegendFunnelChart(true),FunnelLegend()],
    'funnel_with_smart_labels':<dynamic>[getFunnelSmartLabelChart(true),FunnelSmartLabels()],

    //Pyramid
    'default_pyramid_chart':<dynamic>[getDefaultPyramidChart(true),PyramidDefault()],
    'pyramid_with_legend':<dynamic>[getLegendPyramidChart(true),PyramidLegend()],
    'pyramid_with_smart_labels':<dynamic>[getPyramidSmartLabelChart(true),PyramidSmartLabels()],
    

    // Calendar Samples
    'getting_started_calendar':<dynamic>[getGettingStartedCalendar(), GettingStartedCalendar()],
    'recurrence_calendar':<dynamic>[getRecurrenceCalendar(), RecurrenceCalendar()],
    'agenda_view_calendar':<dynamic>[getAgendaViewCalendar(), AgendaViewCalendar()],
    'appointment_editor_calendar':<dynamic>[getAppointmentEditorCalendar(), CalendarAppointmentEditor()],

    //Gauge
    'radial_bounce':<dynamic>[getRadialBounceOutExample(true), RadialBounceOutExample()],
    'radial_easeanimation':<dynamic>[getRadialEaseExample(true), RadialEaseExample()],
    'radial_easeincric':<dynamic>[getRadialEaseInCircExample(true), RadialEaseInCircExample()],
    'radial_easeout':<dynamic>[getRadialEaseOutAnimation(true), RadialEaseOutAnimation()],
    'radial_elasticout':<dynamic>[getRadialElasticOutAnimation(true), RadialElasticOutAnimation()],
    'radial_linearanimation':<dynamic>[getRadialLinearAnimation(true), RadialLinearAnimation()],
    'radial_slowmiddle':<dynamic>[getRadialSlowMiddleAnimation(true), RadialSlowMiddleAnimation()],
    'direct_compass':<dynamic>[getRadialCompass(true), RadialCompass()],
    'image_annotation':<dynamic>[getRadialImageAnnotation(true), RadialImageAnnotation()],
    'text_annotation':<dynamic>[getRadialTextAnnotation(true), RadialTextAnnotation()],
    'custom_labels':<dynamic>[getGaugeCustomLabels(true), GaugeCustomLabels()],
    'default_gauge_view':<dynamic>[getDefaultRadialGauge(true), RadialGaugeDefault()],
    'multiple_axis':<dynamic>[getMultipleAxisGauge(true), MultipleAxisExample()],
    'non_linearable':<dynamic>[getRadialNonLinearLabel(true), RadialNonLinearLabel()],
    'radiallabel_customization':<dynamic>[getRadialLabelCustomization(true), RadialLabelCustomization()],
    'range_colors':<dynamic>[getRangeColorForLabels(true), RangeColorForLabels()],
    'tick_customization':<dynamic>[getRadialTickCustomization(true), RadialTickCustomization()],
    'radial_pointerdragging':<dynamic>[getRadialPointerDragging(true), RadialPointerDragging()],
    'radial_slider':<dynamic>[getRadialSlider(true),  RadialSlider()],
    'multiple_needle':<dynamic>[getMultipleNeedleExample(true), MultipleNeedleExample()],
    'range_pointer':<dynamic>[getMultipleRangePointerExampleGauge(true), MultipleRangePointerExample()],
    'radial_marker':<dynamic>[getRadialMarkerExample(true), RadialMarkerExample()],
    'text_pointer':<dynamic>[getRadialTextPointer(true), RadialTextPointer()],
    'multiple_ranges':<dynamic>[getMultipleRangesExampleGauge(true), MultipleRangesExample()],
    'range_datalabels':<dynamic>[getRangeDataLabelExample(true), RangeDataLabelExample()],
    'range_thickness':<dynamic>[getRangeThicknessExampleGauge(true), RangeThicknessExample()],
    'clock_sample':<dynamic>[getClockExample(true), ClockExample()],
    'distance_tracker':<dynamic>[getDistanceTrackerExample(true), DistanceTrackerExample()],
    'gauge_overview':<dynamic>[getGaugeOverviewExample(true), GaugeOverviewExample()],
    'gauge_compass':<dynamic>[getGaugeCompassExample(true), GaugeCompassExample()]
   };
}
