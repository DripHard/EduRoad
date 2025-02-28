import 'package:flutter/material.dart';
import 'package:eduroad/features/calendar.dart';
import 'package:googleapis/calendar/v3.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage>  createState() => CalendarPageState();
}


class CalendarPageState extends State<CalendarPage> {
  final _calendarService = CalendarService();
  List<Event> _events = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    try {
      final events = await _calendarService.getEvents();
      if (mounted) {
        setState(() {
          _events = events;
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching events: $e");
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _addEvent() async {
    TextEditingController titleController = TextEditingController();
    TextEditingController dateController = TextEditingController();

    bool? shouldAdd = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Event"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Event Title"),
            ),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(labelText: "Event Date (YYYY-MM-DD HH:MM)"),
              keyboardType: TextInputType.datetime,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              String title = titleController.text.trim();
              String dateText = dateController.text.trim();

              if (title.isEmpty || dateText.isEmpty) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Title and Date cannot be empty")),
                  );
                }
                return;
              }

              DateTime? eventDate = DateTime.tryParse(dateText);
              if (eventDate == null) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Invalid Date Format")),
                  );
                }
                return;
              }

              Navigator.pop(context, true);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );

    if (shouldAdd != true || !mounted) return;

    await _calendarService.addEvent(
      titleController.text.trim(),
      DateTime.parse(dateController.text.trim()),
      DateTime.parse(dateController.text.trim()).add(const Duration(hours: 1)),
    );

    if (mounted) {
      _fetchEvents();
    }
  }

  Future<void> _editOrDeleteEvent(Event event) async {
    TextEditingController titleController = TextEditingController(text: event.summary);
    TextEditingController dateController = TextEditingController(
      text: event.start?.dateTime?.toString().substring(0, 16) ?? '',
    );

    bool? shouldUpdate = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit or Delete Event"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Event Title"),
            ),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(labelText: "Event Date (YYYY-MM-DD HH:MM)"),
              keyboardType: TextInputType.datetime,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await _calendarService.deleteEvent(event.id!);
              if (mounted) {
                _fetchEvents();
              }
              Navigator.pop(context, false);
            },
            child: const Text("Delete", style: TextStyle(color: Color.fromARGB(255, 81, 103, 228))),
          ),
          TextButton(
            onPressed: () async {
              String newTitle = titleController.text.trim();
              String newDateText = dateController.text.trim();

              if (newTitle.isEmpty || newDateText.isEmpty) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Title and Date cannot be empty")),
                  );
                }
                return;
              }

              DateTime? newDate = DateTime.tryParse(newDateText);
              if (newDate == null) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Invalid Date Format")),
                  );
                }
                return;
              }

              await _calendarService.updateEvent(
                event.id!,
                newTitle,
                newDate,
                newDate.add(const Duration(hours: 1)),
              );

              if (mounted) {
                _fetchEvents();
              }

              Navigator.pop(context, true);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );

    if (shouldUpdate == true && mounted) {
      _fetchEvents();
    }
  }

  Future<void> _deleteEvent(String eventId) async {
    try {
      await _calendarService.deleteEvent(eventId);
      if (mounted) {
        _fetchEvents();
      }
    } catch (e) {
      debugPrint("Error deleting event: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Calendar Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addEvent,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _events.isEmpty
              ? const Center(child: Text("No events found."))
              : ListView.builder(
                  itemCount: _events.length,
                  itemBuilder: (context, index) {
                    final event = _events[index];
                    return ListTile(
                      title: Text(event.summary ?? 'No Title'),
                      subtitle: Text(event.start?.dateTime?.toString() ?? 'No Date'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editOrDeleteEvent(event),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Color.fromARGB(255, 17, 14, 158)),
                            onPressed: () => _deleteEvent(event.id!),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

