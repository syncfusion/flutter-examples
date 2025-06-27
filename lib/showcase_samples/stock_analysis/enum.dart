/// Enum representing available stocks.
enum Stock { apple, facebook, google, microsoft, nestle, netflix, tesla }

enum SeriesType {
  area,
  candle,
  hollowCandle,
  column,
  line,
  hilo,
  ohlc,
  rangeColumn,
  stepArea,
  stepLine,
}

/// Overlay Indicators: EMA, TMA, SMA, WMA, Bollinger Bands.
/// This should display on the plot area series.
enum OverlayIndicatorType { bollingerBand, ema, sma, tma, wma }

/// Underlay indicators - AD, ATR, MACD, Momentum, RSI, Stochastic, ROC.
/// This should display below the plot area in the separate panel.
enum UnderlayIndicatorType { ad, atr, macd, momentum, rsi, roc, stochastic }

enum ChartZoomMode { x, y, xy }

enum StockTrendlineType {
  linear,
  exponential,
  logarithmic,
  polynomial,
  power,
  movingAverage,
}

enum DateRange { oneMonth, threeMonth, fiveMonth, oneYear, all, customRange }

enum DeviceType { desktop, mobile }
