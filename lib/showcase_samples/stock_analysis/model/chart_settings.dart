class ChartSettings {
  ChartSettings({
    this.trackballEnabled = false,
    this.crosshairEnabled = false,
    this.tooltipEnabled = false,
    this.logarithmicYAxis = false,
    this.opposedAxis = true,
    this.invertedAxis = false,
    this.rangeSelectorEnabled = false,
  });

  bool trackballEnabled;
  bool crosshairEnabled;
  bool tooltipEnabled;
  bool logarithmicYAxis;
  bool opposedAxis;
  bool invertedAxis;
  bool rangeSelectorEnabled;

  ChartSettings copyWith({
    bool? trackballEnabled,
    bool? crosshairEnabled,
    bool? tooltipEnabled,
    bool? logarithmicYAxis,
    bool? opposedAxis,
    bool? invertedAxis,
    bool? rangeSelectorEnabled,
  }) {
    return ChartSettings(
      trackballEnabled: trackballEnabled ?? this.trackballEnabled,
      crosshairEnabled: crosshairEnabled ?? this.crosshairEnabled,
      tooltipEnabled: tooltipEnabled ?? this.tooltipEnabled,
      logarithmicYAxis: logarithmicYAxis ?? this.logarithmicYAxis,
      opposedAxis: opposedAxis ?? this.opposedAxis,
      invertedAxis: invertedAxis ?? this.invertedAxis,
      rangeSelectorEnabled: rangeSelectorEnabled ?? this.rangeSelectorEnabled,
    );
  }
}
