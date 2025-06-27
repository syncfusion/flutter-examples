/// Package imports.
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Calendar import.
import 'package:syncfusion_flutter_calendar/calendar.dart';

/// Local imports.
import '../../model/model.dart';
import 'appointment_editor.dart';

/// The color picker element for the appointment editor with the available
/// color collection, and returns the selection color index.
class CalendarColorPicker extends StatefulWidget {
  const CalendarColorPicker(
    this.colorCollection,
    this.selectedColorIndex,
    this.colorNames,
    this.model, {
    required this.onChanged,
  });

  final List<Color> colorCollection;
  final int selectedColorIndex;
  final List<String> colorNames;
  final SampleModel model;
  final PickerChanged onChanged;

  @override
  State<StatefulWidget> createState() => _CalendarColorPickerState();
}

class _CalendarColorPickerState extends State<CalendarColorPicker> {
  int _selectedColorIndex = -1;

  @override
  void initState() {
    _selectedColorIndex = widget.selectedColorIndex;
    super.initState();
  }

  @override
  void didUpdateWidget(CalendarColorPicker oldWidget) {
    _selectedColorIndex = widget.selectedColorIndex;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: widget.model.themeData,
      child: AlertDialog(
        content: SizedBox(
          width: kIsWeb || widget.model.isWindows || widget.model.isMacOS
              ? 500
              : double.maxFinite,
          height: (widget.colorCollection.length * 50).toDouble(),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: widget.colorCollection.length,
            itemBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 50,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  leading: Icon(
                    index == _selectedColorIndex
                        ? Icons.lens
                        : Icons.trip_origin,
                    color: widget.colorCollection[index],
                  ),
                  title: Text(widget.colorNames[index]),
                  onTap: () {
                    setState(() {
                      _selectedColorIndex = index;
                      widget.onChanged(PickerChangedDetails(index: index));
                    });
                    // ignore: always_specify_types
                    Future.delayed(const Duration(milliseconds: 200), () {
                      // When task is over, close the dialog
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    });
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Picker to display the available resource collection, and returns the
/// selected resource id.
class ResourcePicker extends StatefulWidget {
  const ResourcePicker(
    this.resourceCollection,
    this.model, {
    required this.onChanged,
  });

  final List<CalendarResource> resourceCollection;
  final PickerChanged onChanged;
  final SampleModel model;

  @override
  State<StatefulWidget> createState() => _ResourcePickerState();
}

class _ResourcePickerState extends State<ResourcePicker> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: widget.model.themeData,
      child: AlertDialog(
        content: SizedBox(
          width: kIsWeb ? 500 : double.maxFinite,
          height: (widget.resourceCollection.length * 50).toDouble(),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: widget.resourceCollection.length,
            itemBuilder: (BuildContext context, int index) {
              final CalendarResource resource =
                  widget.resourceCollection[index];
              return SizedBox(
                height: 50,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  leading: CircleAvatar(
                    backgroundColor: widget.model.primaryColor,
                    backgroundImage: resource.image,
                    child: resource.image == null
                        ? Text(resource.displayName[0])
                        : null,
                  ),
                  title: Text(resource.displayName),
                  onTap: () {
                    setState(() {
                      widget.onChanged(
                        PickerChangedDetails(resourceId: resource.id),
                      );
                    });
                    // ignore: always_specify_types
                    Future.delayed(const Duration(milliseconds: 200), () {
                      // When task is over, close the dialog
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    });
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

///  The time zone picker element for the appointment editor with the available
///  time zone collection, and returns the selection time zone index.
class CalendarTimeZonePicker extends StatefulWidget {
  const CalendarTimeZonePicker(
    this.backgroundColor,
    this.timeZoneCollection,
    this.selectedTimeZoneIndex,
    this.model, {
    required this.onChanged,
  });

  final Color backgroundColor;
  final List<String> timeZoneCollection;
  final int selectedTimeZoneIndex;
  final SampleModel model;
  final PickerChanged onChanged;

  @override
  State<StatefulWidget> createState() {
    return _CalendarTimeZonePickerState();
  }
}

class _CalendarTimeZonePickerState extends State<CalendarTimeZonePicker> {
  int _selectedTimeZoneIndex = -1;

  @override
  void initState() {
    _selectedTimeZoneIndex = widget.selectedTimeZoneIndex;
    super.initState();
  }

  @override
  void didUpdateWidget(CalendarTimeZonePicker oldWidget) {
    _selectedTimeZoneIndex = widget.selectedTimeZoneIndex;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: widget.model.themeData,
      child: AlertDialog(
        content: SizedBox(
          width: kIsWeb ? 500 : double.maxFinite,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: widget.timeZoneCollection.length,
            itemBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 50,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  leading: Icon(
                    index == _selectedTimeZoneIndex
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: widget.backgroundColor,
                  ),
                  title: Text(widget.timeZoneCollection[index]),
                  onTap: () {
                    setState(() {
                      _selectedTimeZoneIndex = index;
                      widget.onChanged(PickerChangedDetails(index: index));
                    });
                    // ignore: always_specify_types
                    Future.delayed(const Duration(milliseconds: 200), () {
                      /// When task is over, close the dialog.
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    });
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
