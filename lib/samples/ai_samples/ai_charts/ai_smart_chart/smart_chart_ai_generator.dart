import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_chat/assist_view.dart';

import '../../../../model/sample_view.dart';
import 'smart_chart.dart';

String _cleanJsonString(String dirtyJson) {
  final jsonStart = dirtyJson.indexOf('{');
  final jsonEnd = dirtyJson.lastIndexOf('}');
  if (jsonStart != -1 && jsonEnd != -1) {
    return dirtyJson.substring(jsonStart, jsonEnd + 1);
  }
  return '';
}

class ChartData {
  ChartData(this.xValue, this.yValue);

  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData('${json['xvalue']}', json['yvalue'] as int);
  }

  final String xValue;
  int yValue;
}

class ChartSeries {
  ChartSeries({
    required this.seriesType,
    required this.name,
    required this.data,
    this.visibleDataLabel = false,
    this.visibleMarker = false,
  });

  factory ChartSeries.fromJson(Map<String, dynamic> json) {
    final dataSource = json['dataSource'] as List;
    final List<ChartData> data = dataSource
        .map((data) => ChartData.fromJson(data))
        .toList();

    return ChartSeries(
      seriesType: json['type'].toString().toLowerCase(),
      name: json['name'].toString(),
      data: data,
      visibleDataLabel:
          json['visibleDataLabel']?.toString().toLowerCase() == 'true',
      visibleMarker: json['visibleMarker']?.toString().toLowerCase() == 'true',
    );
  }

  final String seriesType;
  final String name;
  final List<ChartData> data;
  final bool visibleDataLabel;
  final bool visibleMarker;
}

class ChartConfig {
  ChartConfig({
    required this.chartType,
    required this.title,
    this.xAxisTitle,
    this.yAxisTitle,
    required this.seriesList,
    this.visibleTooltip = false,
    this.visibleLegend = false,
    this.legendPosition = LegendPosition.top,
  });

  factory ChartConfig.fromJson(Map<String, dynamic> json) {
    final seriesJson = json['series'] as List;
    final List<ChartSeries> seriesList = seriesJson
        .map((series) => ChartSeries.fromJson(series))
        .toList();

    return ChartConfig(
      chartType: json['chartType'],
      title: json['title'],
      xAxisTitle: json['chartType'] == 'cartesian'
          ? json['xAxis']['title']
          : null,
      yAxisTitle: json['chartType'] == 'cartesian'
          ? json['yAxis']['title']
          : null,
      seriesList: seriesList,
      visibleTooltip:
          json['visibleTooltip']?.toString().toLowerCase() == 'true',
      visibleLegend: json['visibleLegend']?.toString().toLowerCase() == 'true',
      legendPosition: _getLegendPosition(json['legendPosition']),
    );
  }

  static LegendPosition _getLegendPosition(dynamic position) {
    switch ('${position ?? ''}'.toLowerCase()) {
      case 'left':
        return LegendPosition.left;
      case 'right':
        return LegendPosition.right;
      case 'bottom':
        return LegendPosition.bottom;
      case 'top':
        return LegendPosition.top;
      default:
        return LegendPosition.top;
    }
  }

  final String chartType;
  final String title;
  final String? xAxisTitle;
  final String? yAxisTitle;
  final List<ChartSeries> seriesList;
  final bool visibleTooltip;
  bool visibleLegend;
  final LegendPosition legendPosition;
}

class ChartFromJson extends SampleView {
  const ChartFromJson({
    Key? key,
    required this.jsonChartConfig,
    required this.onBackPressed,
  }) : super(key: key);

  final String jsonChartConfig;
  final VoidCallback onBackPressed;

  @override
  SampleViewState createState() => _ChartFromJsonState();
}

class _ChartFromJsonState extends SampleViewState
    with SingleTickerProviderStateMixin {
  Key _assistViewKey = UniqueKey();
  bool isPressed = false;
  bool _isLoading = false;
  bool _showButtons = true;
  bool _enableActionButton = false;
  bool isFirstTime = true;
  List<Content> conversationHistory = [];
  late List<AssistMessage> _messages;
  late TextEditingController _textController;
  late ChartConfig chartConfig;
  late String jsonChartConfig;
  String cleanJsonConfig = '';
  double chartTitlePadding = 20;

  @override
  void initState() {
    _textController = TextEditingController()..addListener(_handleTextChange);
    _messages = <AssistMessage>[];

    jsonChartConfig = (widget as ChartFromJson).jsonChartConfig;

    cleanJsonConfig = _cleanJsonString(jsonChartConfig);
    chartConfig = ChartConfig.fromJson(jsonDecode(cleanJsonConfig));
    super.initState();
  }

  void _updateChartConfig(String newJsonConfig) {
    final cleanJsonConfig = _cleanJsonString(newJsonConfig);
    setState(() {
      chartConfig = ChartConfig.fromJson(jsonDecode(cleanJsonConfig));
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWideScreen = constraints.maxWidth > 600;
        const double sidebarWidth = 340;

        return Stack(
          children: [
            Padding(
              padding: isWideScreen
                  ? const EdgeInsets.fromLTRB(30, 20, 50, 20)
                  : const EdgeInsets.fromLTRB(10, 50, 10, 10),
              child: _buildSmartAIChart(chartConfig),
            ),
            _buildBackButton(),
            _buildAIAssistantButton(),
            _buildAIAssistView(
              sidebarWidth,
              context,
              constraints,
              isWideScreen,
            ),
          ],
        );
      },
    );
  }

  Widget _buildAIAssistantButton() {
    return Positioned(
      top: 15.0,
      right: 15.0,
      child: SizedBox(
        height: 38,
        width: 38,
        child: GradientBorder(
          gradient: const LinearGradient(
            colors: <Color>[Colors.blue, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          width: 3.0,
          borderRadius: const Radius.circular(10.0),
          child: FloatingActionButton(
            mini: true,
            tooltip: 'AI Assistant',
            onPressed: _toggleSidebar,
            child: Image.asset(
              'images/ai_assist_view.png',
              height: 25,
              width: 25,
              color: model.themeData.brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Positioned(
      top: 15,
      left: 15,
      child: SizedBox(
        width: 35,
        height: 35,
        child: FloatingActionButton(
          mini: true,
          tooltip: 'Back',
          backgroundColor: model.sampleOutputCardColor,
          elevation: 0,
          onPressed: (widget as ChartFromJson).onBackPressed,
          child: Icon(
            Icons.arrow_back,
            size: 20,
            color: model.themeData.brightness == Brightness.light
                ? Colors.black
                : Colors.white,
          ),
        ),
      ),
    );
  }

  AnimatedPositioned _buildAIAssistView(
    double sidebarWidth,
    BuildContext context,
    BoxConstraints constraints,
    bool isWideScreen,
  ) {
    final double centerOffset = (constraints.maxWidth - sidebarWidth) / 2;
    final double rightOffset = isWideScreen ? 15 : centerOffset;
    return AnimatedPositioned(
      top: 60,
      bottom: 10,
      duration: Duration.zero,
      right: isPressed ? rightOffset : -sidebarWidth,
      child: Material(
        elevation: 4.0,
        borderRadius: BorderRadius.circular(12.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Container(
            width: sidebarWidth,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 0.5),
              color: Theme.of(context).brightness == Brightness.light
                  ? const Color(0xFFFFFBFE)
                  : const Color(0xFF1C1B1F),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.16 * 255),
                  blurRadius: 6.0,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: SelectionArea(
              child: Column(
                children: [
                  _buildAIAssistViewAppBar(),
                  _buildAIAssistViewMessages(constraints),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container _buildAIAssistViewAppBar() {
    final Color color = model.themeData.brightness == Brightness.light
        ? Colors.white
        : Colors.black;
    return Container(
      height: 50,
      padding: const EdgeInsets.fromLTRB(20, 5, 5, 5),
      decoration: BoxDecoration(
        color: model.primaryColor,
        border: Border.all(color: model.primaryColor, width: 0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'AI Assistant',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.autorenew, color: color),
                tooltip: 'Refresh View',
                onPressed: _refreshMessages,
              ),
              IconButton(
                icon: Icon(Icons.close, color: color),
                tooltip: 'Close',
                onPressed: _toggleSidebar,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Expanded _buildAIAssistViewMessages(BoxConstraints constraints) {
    return Expanded(
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: SfAIAssistView(
                  key: _assistViewKey,
                  messages: _messages,
                  actionButton: _buildActionButton(),
                  placeholderBuilder: (BuildContext context) =>
                      _assistViewPlaceholder(context, setState, constraints),
                  responseMessageSettings: const AssistMessageSettings(
                    widthFactor: 0.95,
                    showAuthorAvatar: false,
                    textStyle: TextStyle(
                      fontSize: 14.0,
                      letterSpacing: 0.1,
                      height: 20.0 / 14.0,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.none,
                      textBaseline: TextBaseline.alphabetic,
                    ),
                  ),
                  requestMessageSettings: AssistMessageSettings(
                    widthFactor: 0.95,
                    showAuthorAvatar: false,
                    textStyle: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      height: 20.0 / 14.0,
                      letterSpacing: 0.1,
                      textBaseline: TextBaseline.alphabetic,
                      decoration: TextDecoration.none,
                    ),
                    backgroundColor:
                        model.themeData.brightness == Brightness.light
                        ? Theme.of(context).colorScheme.surfaceContainer
                        : Theme.of(context).colorScheme.surfaceContainer,
                  ),
                  composer: AssistComposer.builder(
                    builder: (BuildContext context) {
                      return _buildComposer(context, setState);
                    },
                  ),
                ),
              ),
              if (_isLoading) const Center(child: CircularProgressIndicator()),
            ],
          );
        },
      ),
    );
  }

  Future<void> _refreshMessages() async {
    setState(() {
      _messages.clear();
      _showButtons = false;
      _isLoading = true;
      conversationHistory.clear();
      _textController.clear();
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _showButtons = true;
      _isLoading = false;
      _assistViewKey = UniqueKey();
      isFirstTime = true;
    });
  }

  void _toggleSidebar() {
    setState(() {
      isPressed = !isPressed;
    });
  }

  void _handleTextChange() {
    setState(() {
      if (_textController.text.isNotEmpty) {
        _enableActionButton = true;
      } else {
        _enableActionButton = false;
      }
    });
  }

  Widget _assistViewPlaceholder(
    BuildContext context,
    StateSetter setState,
    BoxConstraints constraints,
  ) {
    final Color textColor = model.themeData.brightness == Brightness.light
        ? Colors.black
        : Colors.white;
    return Column(
      spacing: 5,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_showButtons)
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              'How can I assist with customizing the chart?',
              style: TextStyle(
                fontSize: 16.0,
                color: textColor,
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        _defaultMessages(context, setState, textColor),
      ],
    );
  }

  Widget _defaultMessages(
    BuildContext context,
    StateSetter setState,
    Color textColor,
  ) {
    final String legendText = chartConfig.visibleLegend
        ? 'Remove legends'
        : 'Add legends';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 15,
        children: [
          if (_showButtons)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _showButtons = false;
                    _handleButtonPressed(legendText);
                    _messages.add(AssistMessage.request(data: legendText));
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  child: Text(legendText, style: TextStyle(color: textColor)),
                ),
              ),
            ),
          if (_showButtons)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _showButtons = false;
                    _handleButtonPressed('Update chart with new data source');

                    _messages.add(
                      const AssistMessage.request(data: 'Update chart data'),
                    );
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  child: Text(
                    'Update chart data',
                    style: TextStyle(color: textColor),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _handleButtonPressed(String prompt) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (model.assistApiKey.isNotEmpty) {
      await _generateResponse(prompt);
      _updateChartConfig(jsonChartConfig);
    } else {
      final promptLower = prompt.toLowerCase();
      if (promptLower.contains('legend')) {
        if (_showLegendKeywords().any(
          (keyword) => promptLower.contains(keyword),
        )) {
          setState(() {
            chartConfig.visibleLegend = true;
            _messages.add(
              const AssistMessage.response(data: 'Legend was enabled.'),
            );
          });
        } else if (_hideLegendKeywords().any(
          (keyword) => promptLower.contains(keyword),
        )) {
          setState(() {
            chartConfig.visibleLegend = false;
            _messages.add(
              const AssistMessage.response(data: 'Legend was disabled.'),
            );
          });
        } else {
          _defaultMessage();
        }
      } else if (promptLower.contains('datasource') ||
          promptLower.contains('data source')) {
        if (_updateDataKeywords().any(
          (keyword) => promptLower.contains(keyword),
        )) {
          setState(() {
            updateDataSource();
            _messages.add(
              const AssistMessage.response(
                data: 'Data source has been updated.',
              ),
            );
          });
        } else {
          _defaultMessage();
        }
      } else {
        _defaultMessage();
      }
    }
  }

  Future<void> _generateResponse(String prompt) async {
    final GenerativeModel aiModel = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: model.assistApiKey,
    );
    final List<String> supportedChartTypes = [
      'line',
      'column',
      'area',
      'bar',
      'scatter',
      'bubble',
      'spline',
      'pie',
      'doughnut',
      'radialBar',
    ];
    final chat = aiModel.startChat();
    final String updatedPrompt =
        '''
    You are a strict JSON chart configuration editor.

    Your task is to modify the provided JSON configuration (`$jsonChartConfig`) based on the instruction: "$prompt".

    You must **strictly adhere to the following rules**:

    1. The chart may support multiple series — modify existing ones or add to them **only if** the structure already allows it.
    2. The chart series type only supported from the supported list: ${supportedChartTypes.join(", ")}.
    2. **Do not add** any new properties, keys, or elements to the JSON. If the instruction requires a property that does not already exist (e.g., "color"), **do not make any changes**.
    3. You may **only modify the values of existing keys**.
    4. **Do not change these values** of the 'xAxis' and 'yAxis' 'type', even if the instruction requests it.
    5. **Do not** remove, rename, or reorder any fields. The structure must remain **exactly the same**.
    6. Output must be a **valid JSON object** — no comments, no extra text, and no formatting outside of standard JSON.

    If the instruction requests an unsupported change (e.g., adding a new field), return the **original JSON unchanged**.
    ''';

    try {
      final GenerateContentResponse response = await chat.sendMessage(
        Content.text(updatedPrompt),
      );
      if (response.text != null && response.text!.isNotEmpty) {
        final String updatedJson = response.text!;
        final String summaryPrompt =
            """
        You are ChartAI — a friendly and helpful assistant for chart customization.

        Your task is to compare the original chart configuration (`$jsonChartConfig`) with the updated configuration (`$updatedJson`) and respond to the user's instruction: "$prompt".

        Respond with exactly **one clear and concise sentence** that best matches the user's intent.

        Follow these rules **in order**, and only apply the **first rule that matches**:

        1. If the user's instruction is not related to chart customization (e.g., greetings, thank you, general conversation), respond in a warm, friendly tone — as a helpful chart assistant.
        2. If a valid change was made to the chart configuration, summarize it clearly.
        3. If no change was made because the requested setting is unsupported by the current JSON structure, respond with: "I couldn’t apply the requested change because that setting isn't supported."

        Do not combine responses. Only apply the **first matching rule**, and output exactly **one sentence**.
        """;
        final GenerateContentResponse summaryResponse = await chat.sendMessage(
          Content.text(summaryPrompt),
        );
        const String supportedFeature =
            'This chart supports the following customizations:\n'
            '• Chart and axis titles (X and Y)\n'
            '• Legend visibility and position\n'
            '• Tooltip visibility\n'
            '• Series type\n'
            '• Custom data source (X and Y values)\n'
            '• Data label and marker visibility\n\n';

        setState(() {
          jsonChartConfig = updatedJson;

          String message =
              summaryResponse.text ??
              'The chart has been successfully updated.';

          if (summaryResponse.text!.contains(
            "I couldn’t apply the requested change because that setting isn't supported",
          )) {
            message += '\n' + supportedFeature;
          }

          _messages.add(AssistMessage.response(data: message));
        });
      }
    } catch (err) {
      _handleError(err.toString());
    }
  }

  void _handleError(String errorMessage) {
    setState(() {
      _messages.add(
        AssistMessage.response(data: 'An error occurred: $errorMessage'),
      );
    });
  }

  void _defaultMessage() {
    setState(() {
      _messages.add(
        const AssistMessage.response(
          data:
              'API key is missing. Please provide a valid API key to generate a response.',
        ),
      );
    });
  }

  List<String> _showLegendKeywords() {
    return ['show', 'display', 'add', 'enable'];
  }

  List<String> _hideLegendKeywords() {
    return ['hide', 'remove', 'disable'];
  }

  List<String> _updateDataKeywords() {
    return ['change', 'update', 'replace'];
  }

  void updateDataSource() {
    final Random random = Random.secure();
    for (final series in chartConfig.seriesList) {
      for (final data in series.data) {
        data.yValue = random.nextInt(100) + 50;
      }
    }
  }

  Widget _buildComposer(BuildContext context, StateSetter setState) {
    return TextField(
      maxLines: 4,
      minLines: 1,
      controller: _textController,
      decoration: InputDecoration(
        fillColor: Theme.of(context).colorScheme.surfaceContainer,
        filled: true,
        hintText: 'Customize the sample here...',
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
      ),
      onSubmitted: (String text) {
        if (text.isNotEmpty) {
          setState(() {
            _messages.add(AssistMessage.request(data: text));
            _showButtons = false;
            _handleButtonPressed(text);
            _textController.clear();
          });
        }
      },
    );
  }

  AssistActionButton _buildActionButton() {
    final Color actionButtonStateColor = _enableActionButton
        ? Theme.of(context).colorScheme.primary
        : const Color(0xFF9E9E9E);
    final Color activeColor = model.themeData.brightness == Brightness.light
        ? Colors.white
        : Colors.black;
    return AssistActionButton(
      foregroundColor: !_enableActionButton ? Colors.grey[400] : activeColor,
      backgroundColor: actionButtonStateColor,
      hoverColor: actionButtonStateColor,
      splashColor: actionButtonStateColor,
      focusColor: actionButtonStateColor,
      margin: _enableActionButton
          ? const EdgeInsetsDirectional.only(start: 5.0)
          : EdgeInsetsGeometry.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      // size: const Size.square(45),
      onPressed: _enableActionButton
          ? (String prompt) {
              setState(() {
                _showButtons = false;
                _handleButtonPressed(_textController.text);
                _messages.add(
                  AssistMessage.request(data: _textController.text),
                );
                _textController.clear();
              });
            }
          : null,
    );
  }

  Widget _buildSmartAIChart(chartConfig) {
    switch (chartConfig.chartType) {
      case 'cartesian':
        return _buildCartesianChart(chartConfig);
      case 'circular':
        return _buildCircularChart(chartConfig);
      default:
        return Container();
    }
  }

  Widget _buildCartesianChart(ChartConfig config) {
    return SfCartesianChart(
      title: ChartTitle(text: config.title),
      primaryXAxis: CategoryAxis(
        title: config.xAxisTitle != null
            ? AxisTitle(text: config.xAxisTitle)
            : nullAxisTitle(),
      ),
      primaryYAxis: NumericAxis(
        title: config.yAxisTitle != null
            ? AxisTitle(text: config.yAxisTitle)
            : nullAxisTitle(),
      ),
      series: _createCartesianSeries(config),
      tooltipBehavior: TooltipBehavior(enable: config.visibleTooltip),
      legend: Legend(
        isVisible: config.visibleLegend,
        position: config.legendPosition,
      ),
    );
  }

  AxisTitle nullAxisTitle() {
    return const AxisTitle(text: '');
  }

  List<CartesianSeries<ChartData, String>> _createCartesianSeries(
    ChartConfig config,
  ) {
    return config.seriesList.map((series) {
      switch (series.seriesType) {
        case 'line':
          return LineSeries<ChartData, String>(
            dataSource: series.data,
            xValueMapper: (ChartData data, _) => data.xValue,
            yValueMapper: (ChartData data, _) => data.yValue,
            name: series.name,
            dataLabelSettings: DataLabelSettings(
              isVisible: series.visibleDataLabel,
            ),
            markerSettings: MarkerSettings(isVisible: series.visibleMarker),
          );
        case 'column':
          return ColumnSeries<ChartData, String>(
            dataSource: series.data,
            xValueMapper: (ChartData data, _) => data.xValue,
            yValueMapper: (ChartData data, _) => data.yValue,
            name: series.name,
            dataLabelSettings: DataLabelSettings(
              isVisible: series.visibleDataLabel,
            ),
            markerSettings: MarkerSettings(isVisible: series.visibleMarker),
          );
        case 'area':
          return AreaSeries<ChartData, String>(
            dataSource: series.data,
            xValueMapper: (ChartData data, _) => data.xValue,
            yValueMapper: (ChartData data, _) => data.yValue,
            name: series.name,
            dataLabelSettings: DataLabelSettings(
              isVisible: series.visibleDataLabel,
            ),
            markerSettings: MarkerSettings(isVisible: series.visibleMarker),
          );
        case 'bar':
          return BarSeries<ChartData, String>(
            dataSource: series.data,
            xValueMapper: (ChartData data, _) => data.xValue,
            yValueMapper: (ChartData data, _) => data.yValue,
            name: series.name,
            dataLabelSettings: DataLabelSettings(
              isVisible: series.visibleDataLabel,
            ),
            markerSettings: MarkerSettings(isVisible: series.visibleMarker),
          );
        case 'spline':
          return SplineSeries<ChartData, String>(
            dataSource: series.data,
            xValueMapper: (ChartData data, _) => data.xValue,
            yValueMapper: (ChartData data, _) => data.yValue,
            name: series.name,
            dataLabelSettings: DataLabelSettings(
              isVisible: series.visibleDataLabel,
            ),
            markerSettings: MarkerSettings(isVisible: series.visibleMarker),
          );
        case 'scatter':
          return ScatterSeries<ChartData, String>(
            dataSource: series.data,
            xValueMapper: (ChartData data, _) => data.xValue,
            yValueMapper: (ChartData data, _) => data.yValue,
            name: series.name,
            dataLabelSettings: DataLabelSettings(
              isVisible: series.visibleDataLabel,
            ),
            markerSettings: MarkerSettings(isVisible: series.visibleMarker),
          );
        case 'bubble':
          return BubbleSeries<ChartData, String>(
            dataSource: series.data,
            xValueMapper: (ChartData data, _) => data.xValue,
            yValueMapper: (ChartData data, _) => data.yValue,
            name: series.name,
            dataLabelSettings: DataLabelSettings(
              isVisible: series.visibleDataLabel,
            ),
            markerSettings: MarkerSettings(isVisible: series.visibleMarker),
          );
        default:
          throw UnsupportedError(
            'Unsupported series type: ${series.seriesType} check info for more details',
          );
      }
    }).toList();
  }

  Widget _buildCircularChart(ChartConfig config) {
    return SfCircularChart(
      title: ChartTitle(text: config.title),
      legend: Legend(
        isVisible: config.visibleLegend,
        position: config.legendPosition,
      ),
      series: _createCircularSeries(config),
      tooltipBehavior: TooltipBehavior(enable: config.visibleTooltip),
    );
  }

  List<CircularSeries<ChartData, String>> _createCircularSeries(
    ChartConfig config,
  ) {
    return config.seriesList.map((series) {
      switch (series.seriesType) {
        case 'pie':
          return PieSeries<ChartData, String>(
            dataSource: series.data,
            xValueMapper: (ChartData data, _) => data.xValue,
            yValueMapper: (ChartData data, _) => data.yValue,
            name: series.name,
            dataLabelSettings: DataLabelSettings(
              isVisible: series.visibleDataLabel,
            ),
          );
        case 'doughnut':
          return DoughnutSeries<ChartData, String>(
            dataSource: series.data,
            xValueMapper: (ChartData data, _) => data.xValue,
            yValueMapper: (ChartData data, _) => data.yValue,
            name: series.name,
            dataLabelSettings: DataLabelSettings(
              isVisible: series.visibleDataLabel,
            ),
          );
        case 'radialbar':
          return RadialBarSeries<ChartData, String>(
            dataSource: series.data,
            xValueMapper: (ChartData data, _) => data.xValue,
            yValueMapper: (ChartData data, _) => data.yValue,
            name: series.name,
            dataLabelSettings: DataLabelSettings(
              isVisible: series.visibleDataLabel,
            ),
          );
        default:
          throw UnsupportedError(
            'Unsupported series type: ${series.seriesType}',
          );
      }
    }).toList();
  }

  @override
  void dispose() {
    _assistViewKey = UniqueKey();
    isPressed = false;
    _isLoading = false;
    _showButtons = true;
    isFirstTime = true;
    conversationHistory = [];
    _messages.clear();
    _textController.dispose();
    conversationHistory.clear();
    super.dispose();
  }
}
