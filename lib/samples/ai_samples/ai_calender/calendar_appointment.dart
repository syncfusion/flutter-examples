import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_chat/assist_view.dart';

import '../../../../../model/sample_view.dart';
import '../../helper/ai_pop_up_api_key.dart';

class AICalendar extends SampleView {
  const AICalendar(Key key) : super(key: key);
  @override
  _AiCalendarState createState() => _AiCalendarState();
}

class _AiCalendarState extends SampleViewState
    with SingleTickerProviderStateMixin {
  _AiCalendarState();
  final List<String> _subjects = <String>[];
  final List<Color> _colors = <Color>[];
  final List<Appointment> _scheduledAppointments = <Appointment>[];
  final List<CalendarResource> _resources = <CalendarResource>[];
  final List<String> _names = <String>[];
  final List<String> _userImages = <String>[];
  final CalendarController _calendarController = CalendarController();
  final AssistMessageAuthor user = const AssistMessageAuthor(
    id: '8ob3-b720-g9s6-25s8',
    name: 'Farah',
  );
  final AssistMessageAuthor bot = const AssistMessageAuthor(
    id: '8ob3-b720-g9s6-25s0',
    name: 'Bot',
  );
  late _EventDataSource _events;
  late AnimationController _controller;
  late Animation<double> _animation;
  late List<AssistMessage> _messages;
  late TextEditingController _textController;
  Key _assistViewKey = UniqueKey();
  Appointment? _selectedAppointment;
  bool _isLoading = false;
  bool isPressed = false;
  String _doctorName = '';
  String _appointmentTime = '';
  String _subject = '';
  bool _showButtons = true;
  List<DateTime> _sophiaStartTimes = [];
  List<DateTime> sophiaEndTimes = [];
  List<String> sophiaSubjects = [];
  List<DateTime> johnStartTimes = [];
  List<DateTime> johnEndTimes = [];
  List<String> johnSubjects = [];
  final List<String> _times = [
    '9 AM',
    '10 AM',
    '11 AM',
    '12 PM',
    '1 PM',
    '2 PM',
    '3 PM',
    '4 PM',
    '5 PM',
    '9:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '1:00 PM',
    '2:00 PM',
    '3:00 PM',
    '4:00 PM',
    '5:00 PM',
    '9:30 AM',
    '10:30 AM',
    '11:30 AM',
    '12:30 PM',
    '1:30 PM',
    '2:30 PM',
    '3:30 PM',
    '4:30 PM',
    '9.30 AM',
    '10.30 AM',
    '11.30 AM',
    '12.30 PM',
    '1.30 PM',
    '2.30 PM',
    '3.30 PM',
    '4.30 PM',
  ];

  @override
  void initState() {
    _textController = TextEditingController()..addListener(_handleTextChange);
    _messages = <AssistMessage>[];
    _calendarController.view = CalendarView.timelineDay;
    _selectedAppointment = null;

    _events = _EventDataSource(
      _scheduledAppointments,
      _resources,
    );
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _addResourceDetails();
    _addResources();
    _addAppointmentDetails();
    _addAppointments();
    super.initState();

    // Show the dialog when the app starts.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (model.isFirstTime) {
        showDialog(
          context: context,
          builder: (context) => WelcomeDialog(
            primaryColor: model.primaryColor,
            apiKey: model.assistApiKey,
            onApiKeySaved: (newApiKey) {
              setState(() {
                model.assistApiKey = newApiKey;
              });
            },
          ),
        );
        model.isFirstTime = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double sidebarWidth =
              constraints.maxWidth > 600 ? 360 : constraints.maxWidth;
          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: _buildCalendar(
                      _events,
                    ),
                  ),
                ],
              ),
              AnimatedPositioned(
                duration: Duration.zero,
                right: isPressed ? 0 : -sidebarWidth,
                top: 48,
                bottom: 0,
                child: Material(
                  elevation: 4.0,
                  borderRadius:
                      BorderRadius.circular(12.0), // Border radius on Material
                  child: ClipRRect(
                    // Clip the child to ensure rounded corners
                    borderRadius: BorderRadius.circular(12.0),
                    child: Container(
                      width: sidebarWidth,
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? const Color(0xFFFFFBFE) // Light theme color
                            : const Color(0xFF1C1B1F), // Dark theme color
                        border: Border.all(color: Colors.grey, width: 0.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                                0.16), // Shadow color, with opacity
                            blurRadius: 6.0, // Blur effect
                            offset: const Offset(0, 3), // Vertical shadow
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: model.primaryColor,
                              border: Border.all(
                                  color: model.primaryColor, width: 0.5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'AI Assistant',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: model.themeData.brightness ==
                                            Brightness.light
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.autorenew,
                                        color: model.themeData.brightness ==
                                                Brightness.light
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                      onPressed: _refreshView,
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.close,
                                        color: model.themeData.brightness ==
                                                Brightness.light
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                      onPressed: _toggleSidebar,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: StatefulBuilder(
                              builder:
                                  (BuildContext context, StateSetter setState) {
                                return Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: SfAIAssistView(
                                        key: _assistViewKey,
                                        messages: _messages,
                                        onSuggestionItemSelected: (bool
                                                selected,
                                            int messageIndex,
                                            AssistMessageSuggestion suggestion,
                                            int suggestionIndex) {
                                          _handleSuggestionSelected(
                                              suggestion.data!, setState);
                                          if (suggestion.data!.contains('AM') ||
                                              suggestion.data!.contains('PM')) {
                                            _handleAppointmentTimeSelection(
                                                suggestion.data!, setState);
                                          } else
                                            _scheduleAppointmentWithDetails(
                                                suggestion.data!, setState);
                                        },
                                        placeholderBuilder:
                                            (BuildContext context) =>
                                                placeholder(context, setState,
                                                    constraints),
                                        responseBubbleSettings:
                                            const AssistBubbleSettings(
                                          showUserAvatar: false,
                                          widthFactor: 0.95,
                                          textStyle: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500,
                                            height: 20.0 / 14.0,
                                            letterSpacing: 0.1,
                                            textBaseline:
                                                TextBaseline.alphabetic,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                        requestBubbleSettings:
                                            AssistBubbleSettings(
                                          showUserAvatar: false,
                                          widthFactor: 0.95,
                                          contentBackgroundColor:
                                              model.themeData.brightness ==
                                                      Brightness.light
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .surfaceContainer
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .surfaceContainer,
                                          textStyle: const TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500,
                                            height: 20.0 / 14.0,
                                            letterSpacing: 0.1,
                                            textBaseline:
                                                TextBaseline.alphabetic,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                        composer: AssistComposer.builder(
                                          builder: (BuildContext context) {
                                            return _buildComposer(
                                                context, setState);
                                          },
                                        ),
                                      ),
                                    ),
                                    if (_isLoading)
                                      const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 2.0,
                right: 1.0,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (BuildContext context, Widget? child) {
                    return Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                      child: Transform.scale(
                        scale: isPressed ? 1.0 : _animation.value,
                        child: FloatingActionButton(
                          backgroundColor: model.primaryColor,
                          mini: true,
                          onPressed: _toggleSidebar,
                          child: Image.asset(
                            'images/ai_assist_view.png',
                            height: 30,
                            width: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget placeholder(
      BuildContext context, StateSetter setState, BoxConstraints constraints) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_showButtons)
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              'How can I assist with your healthcare needs?',
              style: TextStyle(
                fontSize: 16.0,
                color: model.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_showButtons)
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                  child: _buildDoctorButton(
                    context,
                    setState,
                    _names[0],
                    _userImages[0],
                    constraints,
                  ),
                ),
              ),
            if (_showButtons)
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
                  child: _buildDoctorButton(
                    context,
                    setState,
                    _names[1],
                    _userImages[1],
                    constraints,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildComposer(BuildContext context, StateSetter setState) {
    return TextField(
      maxLines: 5,
      minLines: 1,
      controller: _textController,
      decoration: InputDecoration(
        fillColor: Theme.of(context).colorScheme.surfaceContainer,
        filled: true,
        hintText: 'Type here...',
        border: const UnderlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            Icons.send,
            color: _textController.text.isNotEmpty
                ? Theme.of(context).colorScheme.primary
                : const Color(0xFF9E9E9E),
          ),
          onPressed: _textController.text.isNotEmpty
              ? () {
                  setState(() {
                    _messages.add(
                      AssistMessage.request(
                        time: DateTime.now(),
                        author: user,
                        data: _textController.text,
                      ),
                    );
                    _showButtons = false;
                    _generateAIResponse(_textController.text, setState);
                    _textController.clear();
                  });
                }
              : null,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
    );
  }

  void _handleTextChange() {
    setState(() {});
  }

  ElevatedButton _buildDoctorButton(
    BuildContext context,
    StateSetter setState,
    String doctorName,
    String imagePath,
    BoxConstraints constraints,
  ) {
    return ElevatedButton(
      onPressed: () => _hideButtons(
          'Book an appointment with Dr. $doctorName', doctorName, setState),
      style: ElevatedButton.styleFrom(
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.zero,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: AssetImage(imagePath),
                ),
                Icon(
                  Icons.arrow_outward_sharp,
                  color: model.themeData.brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                ),
              ],
            ),
          ),
          SizedBox(height: constraints.maxWidth > 600 ? 10 : 20),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Text(
              constraints.maxWidth > 600
                  ? 'Book an \n appointment with \n Dr. $doctorName'
                  : 'Book an appointment \n with Dr. $doctorName',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: model.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshView() async {
    setState(() {
      _messages.clear();
      _showButtons = false;
      _isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _showButtons = true;
      _isLoading = false;
      _assistViewKey = UniqueKey();
    });
  }

  void _handleSuggestionSelected(String suggestionText, StateSetter setState) {
    setState(() {
      _messages.add(
        AssistMessage.request(
          data: suggestionText,
          time: DateTime.now(),
          author: user,
        ),
      );
    });
  }

  Future<void> _scheduleAppointmentWithDetails(
      String appointment, StateSetter setState) async {
    await Future.delayed(const Duration(seconds: 1));
    _subject = appointment;
    setState(
      () {
        _messages.add(
          AssistMessage.response(
            data:
                'Your appointment with doctor $_doctorName has been booked. \n\nRefresh for booking the new appointment.',
            time: DateTime.now(),
            author: bot,
          ),
        );
        _confirmAppointmentWithEmployee(setState);
      },
    );
  }

  void _confirmAppointmentWithEmployee(StateSetter setState) {
    _selectedAppointment = null;
    final DateTime now = DateTime.now();
    DateTime dateTime = DateTime.now();

    switch (_appointmentTime) {
      case '9 AM':
      case '9:00 AM':
        dateTime = DateTime(now.year, now.month, now.day, 9);
        break;
      case '9:30 AM':
        dateTime = DateTime(now.year, now.month, now.day, 9, 30);
        break;
      case '10 AM':
      case '10:00 AM':
        dateTime = DateTime(now.year, now.month, now.day, 10);
        break;
      case '10:30 AM':
      case '10.30 AM':
        dateTime = DateTime(now.year, now.month, now.day, 10, 30);
        break;
      case '11 AM':
      case '11:00 AM':
        dateTime = DateTime(now.year, now.month, now.day, 11);
        break;
      case '11:30 AM':
      case '11.30 AM':
        dateTime = DateTime(now.year, now.month, now.day, 11, 30);
      case '12 PM':
      case '12:00 PM':
        dateTime = DateTime(now.year, now.month, now.day, 12);
        break;
      case '12:30 PM':
      case '12.30 PM':
        dateTime = DateTime(now.year, now.month, now.day, 12, 30);
        break;
      case '1 PM':
      case '1:00 PM':
        dateTime = DateTime(now.year, now.month, now.day, 13);
        break;
      case '1:30 PM':
      case '1.30 PM':
        dateTime = DateTime(now.year, now.month, now.day, 13, 30);
        break;
      case '2 PM':
      case '2:00 PM':
        dateTime = DateTime(now.year, now.month, now.day, 14);
        break;
      case '2:30 PM':
      case '2.30 PM':
        dateTime = DateTime(now.year, now.month, now.day, 14, 30);
        break;
      case '3 PM':
      case '3:00 PM':
        dateTime = DateTime(now.year, now.month, now.day, 15);
        break;
      case '3:30 PM':
      case '3.30 PM':
        dateTime = DateTime(now.year, now.month, now.day, 15, 30);
        break;
      case '4 PM':
      case '4:00 PM':
        dateTime = DateTime(now.year, now.month, now.day, 16);
        break;
      case '4:30 PM':
      case '4.30 PM':
        dateTime = DateTime(now.year, now.month, now.day, 16, 30);
        break;
      case '5 PM':
      case '5:00 PM':
        dateTime = DateTime(now.year, now.month, now.day, 17);
        break;
    }

    final selectedResource = _resources.firstWhere(
        (resource) => resource.displayName == _doctorName,
        orElse: () => _resources.first);
    setState(
      () {
        final List<Appointment> appointmentList = <Appointment>[];
        if (_selectedAppointment == null) {
          _subject = _subject.isEmpty ? '(No title)' : _subject;
          final newAppointment = Appointment(
            startTime: dateTime,
            endTime: dateTime.add(const Duration(minutes: 30)),
            resourceIds: [selectedResource.id],
            color: selectedResource.color,
            subject: _subject,
          );
          appointmentList.add(newAppointment);
          _events.appointments!.add(newAppointment);
          SchedulerBinding.instance.addPostFrameCallback(
            (Duration duration) {
              _events.notifyListeners(
                  CalendarDataSourceAction.add, appointmentList);
            },
          );
          _selectedAppointment = newAppointment;
        }
      },
    );
  }

  Future<void> _handleAppointmentTimeSelection(
      String time, StateSetter setState) async {
    await Future.delayed(const Duration(seconds: 1));
    setState(
      () {
        _appointmentTime = time;
        _messages.add(
          AssistMessage.response(
            data: 'What is the purpose of your appointment?',
            time: DateTime.now(),
            author: bot,
            suggestions: const [
              AssistMessageSuggestion(data: 'General Check-Up'),
              AssistMessageSuggestion(data: 'Vaccinations'),
              AssistMessageSuggestion(data: 'Diagnostic report'),
              AssistMessageSuggestion(data: 'Diabetes'),
            ],
            suggestionSettings: AssistSuggestionSettings(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              itemBackgroundColor: resolveItemBackgroundColor(),
              padding: const EdgeInsets.fromLTRB(0, 15, 8, 8),
              itemPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              orientation: Axis.vertical,
              runSpacing: 10.0,
            ),
          ),
        );
      },
    );
  }

  WidgetStateProperty<Color> resolveItemBackgroundColor() {
    return WidgetStateProperty.resolveWith(
      (Set<WidgetState> state) {
        final surfaceContainer = Theme.of(context).colorScheme.surfaceContainer;

        if (state.contains(WidgetState.hovered) ||
            state.contains(WidgetState.focused)) {
          return surfaceContainer.withOpacity(0.8);
        }
        if (state.contains(WidgetState.pressed) ||
            state.contains(WidgetState.disabled)) {
          return surfaceContainer.withOpacity(0.12);
        }
        return surfaceContainer;
      },
    );
  }

  Future<void> _handleDoctorSelection(
      String message, StateSetter setState) async {
    _handleSuggestionSelected(message, setState);
    await Future.delayed(const Duration(seconds: 1));
    setState(
      () {
        _messages.add(
          AssistMessage.response(
            data: 'Please select an appointment time',
            time: DateTime.now(),
            author: bot,
            suggestions: const [
              AssistMessageSuggestion(data: '9 AM'),
              AssistMessageSuggestion(data: '11 AM'),
              AssistMessageSuggestion(data: '2 PM'),
              AssistMessageSuggestion(data: '4 PM'),
            ],
            suggestionSettings: AssistSuggestionSettings(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
              itemBackgroundColor: resolveItemBackgroundColor(),
            ),
          ),
        );
      },
    );
  }

  bool _isValidTime(String time) {
    for (int i = 0; i < _times.length; i++) {
      if (_times[i] == time) {
        return true;
      }
    }
    return false;
  }

  Future<void> _generateAIResponse(String prompt, StateSetter setState) async {
    String? responseText;
    if (model.assistApiKey.isNotEmpty) {
      final aiModel = GenerativeModel(
        model: 'gemini-1.5-flash-latest',
        apiKey: model.assistApiKey,
      );
      try {
        if (_isValidTime(prompt)) {
          _handleAppointmentTimeSelection(prompt, setState);
        } else if (_subjects.contains(prompt)) {
          _scheduleAppointmentWithDetails(prompt, setState);
        } else {
          _doctorName =
              prompt.toLowerCase().contains('sophia') ? 'Sophia' : 'John';
          final DateTime todayDate = DateTime.now();

          if (prompt.toLowerCase() == 'sophia' ||
              prompt.toLowerCase() == 'john') {
            prompt += 'Book an appointment with Dr. $prompt';
          }

          final String aiPrompt =
              "Given data: $prompt. Based on the given data, provide 5 appointment time details for Doctor1 and Doctor2 on $todayDate.Availability time is 9AM to 6PM.In 10 appointments, split the time details as 5 for Doctor1 and 5 for Doctor2.Provide complete appointment time details for both Doctor1 and Doctor2 without missing any fields.It should be 30 minutes appointment duration.Doctor1 time details should not collide with Doctor2.Provide ResourceID for Doctor1 as 1000 and for Doctor2 as 1001.Subjects should be ${_subjects}Do not repeat the same time. Generate the following fields: StartDate, EndDate, Subject, Location, and ResourceID.The return format should be the following list format: Doctor1[StartDate, EndDate, Subject, Location, ResourceID], Doctor2[StartDate, EndDate, Subject, Location, ResourceID].Condition: provide details without any explanation. Don't include any special characters like ```";

          final List<Content> content = [Content.text(aiPrompt)];
          final GenerateContentResponse response =
              await aiModel.generateContent(content);
          responseText = (response.text ?? '').trim();

          // ignore: strict_raw_type
          final Map<String, Map<String, List>> doctorAppointments =
              // ignore: strict_raw_type
              <String, Map<String, List>>{
            'Doctor1': _initializeAppointmentLists(),
            'Doctor2': _initializeAppointmentLists()
          };

          final RegExp regex = RegExp(r'(Doctor\d)\[([^\]]+)\]');
          final Iterable<RegExpMatch> matches = regex.allMatches(responseText);

          for (final RegExpMatch match in matches) {
            final String doctorKey = match.group(1)!;
            final String data = match.group(2)!;
            final List<String> details =
                data.split(',').map((e) => e.trim()).toList();

            if (details.length == 5) {
              if (doctorAppointments.containsKey(doctorKey)) {
                doctorAppointments[doctorKey]!['startTimes']
                    ?.add(DateTime.parse(details[0]));
                doctorAppointments[doctorKey]!['endTimes']
                    ?.add(DateTime.parse(details[1]));
                doctorAppointments[doctorKey]!['subjects']?.add(details[2]);
              }
            }
          }
          _assignDataToLists(doctorAppointments);
          _filterAppointments(_sophiaStartTimes, 'Sophia');
          _filterAppointments(johnStartTimes, 'John');

          responseText = _generateFinalTimeSlots(
              prompt,
              _generateTimeSlots(_sophiaStartTimes),
              _generateTimeSlots(johnStartTimes));
        }
      } catch (err) {
        responseText = 'The given $err';
      }
    } else {
      await Future.delayed(const Duration(milliseconds: 300));
      responseText =
          'You are offline, Please connect to the internet and give API key.';
    }
    if (responseText != null)
      setState(
        () {
          _messages.add(
            AssistMessage.response(
              data: responseText!,
              time: DateTime.now(),
              author: bot,
            ),
          );
        },
      );
  }

  Map<String, List<dynamic>> _initializeAppointmentLists() {
    return {
      'startTimes': [],
      'endTimes': [],
      'subjects': [],
    };
  }

  void _assignDataToLists(
      Map<String, Map<String, List<dynamic>>> appointments) {
    _sophiaStartTimes =
        List<DateTime>.from(appointments['Doctor1']!['startTimes']!);
    sophiaEndTimes = List<DateTime>.from(appointments['Doctor1']!['endTimes']!);
    sophiaSubjects = List<String>.from(appointments['Doctor1']!['subjects']!);

    johnStartTimes =
        List<DateTime>.from(appointments['Doctor2']!['startTimes']!);
    johnEndTimes = List<DateTime>.from(appointments['Doctor2']!['endTimes']!);
    johnSubjects = List<String>.from(appointments['Doctor2']!['subjects']!);
  }

  void _filterAppointments(List<DateTime> times, String doctorName) {
    final List<DateTime> appointments = [];
    times.removeWhere((time) => appointments.contains(time));
  }

  List<String> _generateTimeSlots(List<DateTime> timeCollection) {
    return timeCollection
        .map((time) => DateFormat('hh:mm a').format(time))
        .toList();
  }

  String _generateFinalTimeSlots(
      String userInput, List<String> sophiaSlots, List<String> johnSlots) {
    final String sophiaAvailedTimeSlots = sophiaSlots.join(', ');
    final String johnAvailedTimeSlots = johnSlots.join(', ');

    if (userInput.toLowerCase().contains('sophia')) {
      return "Doctor Sophia's available slots:\n $sophiaAvailedTimeSlots \n \n Please select a time.";
    } else if (userInput.toLowerCase().contains('john')) {
      return "Doctor John's available slots:\n $johnAvailedTimeSlots \n \n Please select a time.";
    } else {
      return "Doctor Sophia's available slots:\n $sophiaAvailedTimeSlots \n"
          "Doctor John's available slots:\n $johnAvailedTimeSlots\n \n Please select a time.";
    }
  }

  void _hideButtons(String message, String doctor, StateSetter setState) {
    setState(
      () {
        _showButtons = false;
        _doctorName = doctor;
      },
    );
    _handleDoctorSelection(message, setState);
  }

  void _toggleSidebar() {
    setState(() {
      isPressed = !isPressed;
    });
  }

  void _addResourceDetails() {
    _names.add('Sophia');
    _names.add('John');
    _userImages.add('images/People_Circle25.png');
    _userImages.add('images/People_Circle8.png');
    _colors.add(const Color(0xFF0F8644));
    _colors.add(const Color(0xFF8B1FA9));
  }

  void _addAppointmentDetails() {
    _subjects.add('Vaccinations');
    _subjects.add('General Check-Up');
    _subjects.add('Diagnostic report');
    _subjects.add('Diabetes');
  }

  void _addResources() {
    for (int i = 0; i < _names.length; i++) {
      _resources.add(
        CalendarResource(
          displayName: _names[i],
          id: '000$i',
          color: _colors[i],
          image:
              i < _userImages.length ? ExactAssetImage(_userImages[i]) : null,
        ),
      );
    }
  }

  void _addAppointments() {
    const List<int> appointmentTime = [10, 15, 9, 16];
    final DateTime date = DateTime.now();
    for (int i = 0; i < _resources.length; i++) {
      final List<Object> employeeId = <Object>[_resources[i].id];
      for (int j = 0; j < 2; j++) {
        final int index = i == 0 ? j : j + 2;
        final int startHour = appointmentTime[index];
        final DateTime shiftStartTime =
            DateTime(date.year, date.month, date.day, startHour);
        _scheduledAppointments.add(
          Appointment(
            startTime: shiftStartTime,
            endTime: shiftStartTime.add(const Duration(minutes: 30)),
            subject: _subjects[index],
            color: _colors[i],
            resourceIds: employeeId,
          ),
        );
      }
    }
  }

  SfCalendar _buildCalendar(CalendarDataSource calendarDataSource) {
    return SfCalendar(
      view: CalendarView.timelineDay,
      timeSlotViewSettings: const TimeSlotViewSettings(
        timeInterval: Duration(minutes: 30),
        timeIntervalHeight: 50,
        timeIntervalWidth: 100,
        timeRulerSize: 25,
        timeFormat: 'h:mm',
        startHour: 9,
        endHour: 18,
        dayFormat: 'EEEE',
        dateFormat: 'dd',
        numberOfDaysInView: 1,
      ),
      dataSource: calendarDataSource,
    );
  }

  @override
  void dispose() {
    _messages.clear();
    _controller.dispose();
    _textController.dispose();
    _events.appointments!.clear();
    _scheduledAppointments.clear();
    _resources.clear();
    _names.clear();
    _userImages.clear();
    _subjects.clear();
    _colors.clear();
    _selectedAppointment = null;
    super.dispose();
  }
}

class _EventDataSource extends CalendarDataSource {
  _EventDataSource(
      List<Appointment> source, List<CalendarResource> resourceColl) {
    appointments = source;
    resources = resourceColl;
  }
}
