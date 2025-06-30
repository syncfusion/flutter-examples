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
  bool isFirstTime = true;
  final DateTime _todayDate = DateTime.now();
  DateTime _selectedDateTime = DateTime.now();
  final String _appointmentBooked =
      'Your appointment has been successfully booked';
  bool _aiGeneratedResponse = false;
  List<Content> conversationHistory = [];

  List<DateTime> sophiaEndTimes = [];
  List<String> sophiaSubjects = [];
  List<DateTime> johnStartTimes = [];
  List<DateTime> johnEndTimes = [];
  List<String> johnSubjects = [];

  @override
  void initState() {
    _textController = TextEditingController()..addListener(_handleTextChange);
    _messages = <AssistMessage>[];
    _calendarController.view = CalendarView.timelineDay;
    _selectedAppointment = null;

    _events = _EventDataSource(_scheduledAppointments, _resources);
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

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
          final double sidebarWidth = constraints.maxWidth > 600
              ? 360
              : constraints.maxWidth;
          return Stack(
            children: [
              Column(children: [Expanded(child: _buildCalendar(_events))]),
              AnimatedPositioned(
                duration: Duration.zero,
                right: isPressed ? 0 : -sidebarWidth,
                top: 48,
                bottom: 0,
                child: Material(
                  elevation: 4.0,
                  borderRadius: BorderRadius.circular(
                    12.0,
                  ), // Border radius on Material
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
                            color: Colors.black.withValues(
                              alpha: 0.16,
                            ), // Shadow color, with opacity
                            blurRadius: 6.0, // Blur effect
                            offset: const Offset(0, 3), // Vertical shadow
                          ),
                        ],
                      ),
                      child: SelectionArea(
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: model.primaryColor,
                                border: Border.all(
                                  color: model.primaryColor,
                                  width: 0.5,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'AI Assistant',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          model.themeData.brightness ==
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
                                          color:
                                              model.themeData.brightness ==
                                                  Brightness.light
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        onPressed: _refreshView,
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          color:
                                              model.themeData.brightness ==
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
                                builder: (BuildContext context, StateSetter setState) {
                                  return Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: SfAIAssistView(
                                          key: _assistViewKey,
                                          messages: _messages,
                                          onSuggestionItemSelected:
                                              (
                                                bool selected,
                                                int messageIndex,
                                                AssistMessageSuggestion
                                                suggestion,
                                                int suggestionIndex,
                                              ) {
                                                _handleSuggestionSelected(
                                                  suggestion.data!,
                                                  setState,
                                                );
                                                if (suggestion.data!.contains(
                                                      'AM',
                                                    ) ||
                                                    suggestion.data!.contains(
                                                      'PM',
                                                    )) {
                                                  _handleAppointmentTimeSelection(
                                                    suggestion.data!,
                                                    setState,
                                                  );
                                                } else
                                                  _scheduleAppointmentWithDetails(
                                                    suggestion.data!,
                                                    setState,
                                                  );
                                              },
                                          placeholderBuilder:
                                              (BuildContext context) =>
                                                  placeholder(
                                                    context,
                                                    setState,
                                                    constraints,
                                                  ),
                                          responseMessageSettings:
                                              const AssistMessageSettings(
                                                showAuthorAvatar: false,
                                                widthFactor: 0.95,
                                                textStyle: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500,
                                                  height: 20.0 / 14.0,
                                                  letterSpacing: 0.1,
                                                  textBaseline:
                                                      TextBaseline.alphabetic,
                                                  decoration:
                                                      TextDecoration.none,
                                                ),
                                              ),
                                          requestMessageSettings:
                                              AssistMessageSettings(
                                                showAuthorAvatar: false,
                                                widthFactor: 0.95,
                                                backgroundColor:
                                                    model
                                                            .themeData
                                                            .brightness ==
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
                                                  decoration:
                                                      TextDecoration.none,
                                                ),
                                              ),
                                          composer: AssistComposer.builder(
                                            builder: (BuildContext context) {
                                              return _buildComposer(
                                                context,
                                                setState,
                                              );
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
    BuildContext context,
    StateSetter setState,
    BoxConstraints constraints,
  ) {
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
        'Book an appointment with Dr. $doctorName',
        doctorName,
        setState,
      ),
      style: ElevatedButton.styleFrom(
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
      conversationHistory.clear();
      _aiGeneratedResponse = false;
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _showButtons = true;
      _isLoading = false;
      _assistViewKey = UniqueKey();
      isFirstTime = true;
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
    String appointment,
    StateSetter setState,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    _subject = appointment;
    setState(() {
      _messages.add(
        AssistMessage.response(
          data:
              'Your appointment with doctor $_doctorName has been booked. \n\nRefresh for booking the new appointment.',
          time: DateTime.now(),
          author: bot,
        ),
      );
      _confirmAppointmentWithEmployee(setState);
    });
  }

  void _confirmAppointmentWithEmployee(StateSetter setState) {
    _selectedAppointment = null;
    final DateTime now = DateTime.now();
    DateTime dateTime = DateTime.now();

    switch (_appointmentTime) {
      case '9 AM':
      case '9:00 AM':
        dateTime = DateTime(2022, now.month, now.day, 9);
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
      orElse: () => _resources.first,
    );
    setState(() {
      final List<Appointment> appointmentList = <Appointment>[];
      if (_selectedAppointment == null) {
        _subject = _subject.isEmpty ? '(No title)' : _subject;
        final newAppointment = Appointment(
          startTime: _aiGeneratedResponse ? _selectedDateTime : dateTime,
          endTime: dateTime.add(const Duration(minutes: 30)),
          resourceIds: [selectedResource.id],
          color: selectedResource.color,
          subject: _subject,
        );
        appointmentList.add(newAppointment);
        _events.appointments!.add(newAppointment);
        SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
          _events.notifyListeners(
            CalendarDataSourceAction.add,
            appointmentList,
          );
        });
        _selectedAppointment = newAppointment;
      }
    });
  }

  Future<void> _handleAppointmentTimeSelection(
    String time,
    StateSetter setState,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
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
            margin: const EdgeInsets.fromLTRB(0, 15, 8, 8),
            itemPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            orientation: Axis.vertical,
            runSpacing: 10.0,
          ),
        ),
      );
    });
  }

  WidgetStateProperty<Color> resolveItemBackgroundColor() {
    return WidgetStateProperty.resolveWith((Set<WidgetState> state) {
      final surfaceContainer = Theme.of(context).colorScheme.surfaceContainer;

      if (state.contains(WidgetState.hovered) ||
          state.contains(WidgetState.focused)) {
        return surfaceContainer.withValues(alpha: 0.8);
      }
      if (state.contains(WidgetState.pressed) ||
          state.contains(WidgetState.disabled)) {
        return surfaceContainer.withValues(alpha: 0.12);
      }
      return surfaceContainer;
    });
  }

  Future<void> _handleDoctorSelection(
    String message,
    StateSetter setState,
  ) async {
    _handleSuggestionSelected(message, setState);
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
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
            margin: const EdgeInsets.fromLTRB(0, 8, 8, 8),
            itemBackgroundColor: resolveItemBackgroundColor(),
          ),
        ),
      );
    });
  }

  void convertAIResponse(String response, StateSetter setState) {
    {
      // Split the details from the response
      final List<String> lines = response.split('\n');

      // Create a map to store the information
      final Map<String, String> appointmentDetails = {};

      // Iterate over the lines to store them in the map
      for (final String line in lines) {
        if (line.contains('=')) {
          final List<String> parts = line.split(' = ');
          appointmentDetails[parts[0].trim()] = parts[1].trim();
        }
      }
      String startTime;
      String date;
      setState(() {
        _aiGeneratedResponse = true;
        _doctorName = appointmentDetails['DoctorName']!;
        _doctorName = _doctorName.replaceAll(RegExp(r'Dr\.?\s*'), '');
        _appointmentTime = appointmentDetails['Time']!;
        startTime = _appointmentTime.split(' - ')[0].toUpperCase();
        _appointmentTime = startTime;
        date = appointmentDetails['Date']!;
        final DateFormat dateFormat = DateFormat('dd-MM-yyyy h:mm a');
        _selectedDateTime = dateFormat.parse('$date $startTime');
        _subject = appointmentDetails['Subject']!;

        if (_doctorName.isNotEmpty &&
            _appointmentTime.isNotEmpty &&
            _subject.isNotEmpty) {
          _confirmAppointmentWithEmployee(setState);
        }
      });
    }
  }

  Future<void> _generateAIResponse(String prompt, StateSetter setState) async {
    String? responseText;

    try {
      if (model.assistApiKey.isNotEmpty) {
        final aiModel = GenerativeModel(
          model: 'gemini-1.5-flash-latest',
          apiKey: model.assistApiKey,
        );

        if (isFirstTime) {
          prompt = _generatePrompt();
        }

        conversationHistory.add(Content.text('User Input$prompt'));

        final GenerateContentResponse response = await aiModel.generateContent(
          conversationHistory,
        );
        responseText = (response.text ?? '').trim();

        conversationHistory.add(Content.text(responseText));
      } else {
        responseText =
            'API key is missing. Please provide a valid API key to generate a response.';
      }

      if (responseText.contains(_appointmentBooked)) {
        convertAIResponse(responseText, setState);
      }
    } catch (e) {
      responseText =
          'API key is invalid. Please provide a valid API key to generate a response.';
    } finally {
      // Handle finally
    }

    isFirstTime = false;

    if (responseText != null)
      setState(() {
        _messages.add(
          AssistMessage.response(
            data: responseText!,
            time: DateTime.now(),
            author: bot,
          ),
        );
      });
  }

  String _generatePrompt() {
    // ignore: prefer_final_locals
    String aiPrompt =
        """
You are an intelligent appointment booking assistant designed to book doctor appointments step-by-step.  
Focus on the user's inputs, confirm details at each step, and proceed only after validation. Always remember the current step and user preferences until the appointment is finalized.

When responding to the user:
- Do not include any extra information, such as the phrase 'step 1', 'step 2', 'AI response', or any symbols.
- Respond only with the relevant questions or confirmations needed to complete the booking process.
- Ensure that the conversation flows smoothly and logically based on the user's input.

### Steps:
1. **Date Confirmation**: 
    Greet the user with a welcome message: "Welcome to the Appointment Booking Assistant! I’m here to help you book an appointment step-by-step."
   
   - Ask the user for a valid date (dd-mm-yyyy).
   - Compare the user selected date with today's date ($_todayDate).
     - If the selected date is in the past, politely ask the user to select today or a future date.
     - If the selected date is today ($_todayDate) or future date, proceed to the next step.
     - Ensure the date format is correct (dd-mm-yyyy). If the input is invalid or the wrong format is used, ask the user to correct it.

2. **Doctor Selection**:
   Ask for the doctor's name (Dr. Sophia or Dr. John). Validate the input using the following logic:
     - Convert the input to lowercase for comparison.
     - Strip any prefixes (like "Dr."), so "Dr. John" or "john" should all map to "john".
     - If the input does not match either "sophia" or "john" (after converting and stripping), kindly ask the user to select a valid doctor.

3. **Time Slot Generation**:
   Generate 5 evenly spaced 30-minute slots between 9 AM and 6 PM for the selected doctor and list them below. After the user selects a time slot, validate that the selection is one of the generated options. If the input is invalid, kindly prompt the user to choose a valid time slot.

4. **Time Slot Confirmation**:
   After the user selects a time slot, confirm that the selected slot matches one of the generated options. If correct, proceed; if not, ask the user to select a valid time slot.

5. **Subject Selection**:
  Ask the user to choose from predefined subjects:

   - And List these subjects below: 
     • General Check-Up  
     • Vaccinations  
     • Diagnostic Report

   Validate the input using the following logic:
     - Convert the input to lowercase for comparison.
     - Ensure the input matches one of the available subjects, regardless of case.
     - If the input is invalid or unrecognized, kindly ask the user to choose from the listed subjects.

6. **Booking Confirmation**:
   Once all steps have been successfully completed, respond with the booking confirmation:
   - If the inputs are valid:
     Respond with:
     "Your appointment with _doctorName has been booked."
     Provide the details in this format:  
     DoctorName = _doctorName  
     Time = _appointmentTime  
     Date = _date  
     Subject = _subject  

     "Your appointment has been successfully booked! Refresh to book a new appointment."

### General Rules:
- Validate inputs step-by-step before proceeding.
- Do not jump back to previous steps once completed.
- For invalid inputs, respond with polite clarification and ask for the correct input.
- Always ensure that the assistant remembers the current step and doesn't make assumptions.
- After the booking is completed, if the user tries to request anything unrelated, respond with: "Your previous appointment has already been booked successfully. To book a new appointment, please refresh and start the process again."
""";
    return aiPrompt;
  }

  void _hideButtons(String message, String doctor, StateSetter setState) {
    setState(() {
      _showButtons = false;
      _doctorName = doctor;
    });
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
          image: i < _userImages.length
              ? ExactAssetImage(_userImages[i])
              : null,
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
        final DateTime shiftStartTime = DateTime(
          date.year,
          date.month,
          date.day,
          startHour,
        );
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
    conversationHistory.clear();
    super.dispose();
  }
}

class _EventDataSource extends CalendarDataSource {
  _EventDataSource(
    List<Appointment> source,
    List<CalendarResource> resourceColl,
  ) {
    appointments = source;
    resources = resourceColl;
  }
}
