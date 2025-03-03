import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

class CalendarService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [CalendarApi.calendarScope], // Request calendar access
  );

  /// Authenticate & Get Calendar API Client
  Future<CalendarApi?> _getCalendarApi() async {

    try { //User authentication

        //check if user is already signed in
        GoogleSignInAccount? googleUser = _googleSignIn.currentUser;

        //If not signed in, prompt sign-in
      googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        log("User not signed in", name: "CalendarService", level: 900);
        return null;
      }

      final authHeaders = await googleUser.authHeaders;
      final httpClient = GoogleHttpClient(authHeaders);
      return CalendarApi(httpClient);
    } catch (e) {
      log("Error signing in: $e", name: "CalendarService", level: 1000);
      return null;
    }
  }

  /// Fetch all events from Google Calendar
  Future<List<Event>> getEvents(String calendarType) async {
    final calendarApi = await _getCalendarApi();
    if (calendarApi == null) return [];

    try {
      final events = await calendarApi.events.list(calendarType);
      log("Fetched ${events.items?.length ?? 0} events", name: "CalendarService");
      return events.items ?? [];
    } catch (e) {
      log("Error fetching events: $e", name: "CalendarService", level: 1000);
      return [];
    }
  }

  /// Add a new even
  Future<Event?> addEvent(String summary, DateTime start, DateTime end) async {
    final calendarApi = await _getCalendarApi();
    if (calendarApi == null) return null;

    try {
      final event = Event()
        ..summary = summary
        ..start = EventDateTime(dateTime: start, timeZone: "GMT+08:00")
        ..end = EventDateTime(dateTime: end, timeZone: "GMT+08:00");

      final createdEvent = await calendarApi.events.insert(event, "primary");
      log("Event created: ${createdEvent.id}", name: "CalendarService");
      return createdEvent;
    } catch (e) {
      log("Error adding event: $e", name: "CalendarService", level: 1000);
      return null;
    }
  }

  /// Update an existing event
  Future<Event?> updateEvent(String eventId, String newSummary, DateTime newStart, DateTime newEnd) async {
    final calendarApi = await _getCalendarApi();
    if (calendarApi == null) return null;

    try {
      final updatedEvent = Event()
        ..summary = newSummary
        ..start = EventDateTime(dateTime: newStart, timeZone: "GMT+08:00")
        ..end = EventDateTime(dateTime: newEnd, timeZone: "GMT+08:00");

      final result = await calendarApi.events.update(updatedEvent, "primary", eventId);
      log("Event updated: $eventId", name: "CalendarService");
      return result;
    } catch (e) {
      log("Error updating event: $e", name: "CalendarService", level: 1000);
      return null;
    }
  }

  /// Delete an event
  Future<bool> deleteEvent(String eventId) async {
    final calendarApi = await _getCalendarApi();
    if (calendarApi == null) return false;

    try {
      await calendarApi.events.delete("primary", eventId);
      log("Event deleted: $eventId", name: "CalendarService");
      return true;
    } catch (e) {
      log("Error deleting event: $e", name: "CalendarService", level: 1000);
      return false;
    }
  }

    //Create new Calendar
    Future<Calendar?> createCalendar(String calendarName, String timeZone) async {
        final calendarApi = await _getCalendarApi();
        if (calendarApi == null) return null;

        try {
            final calendar = Calendar()
            ..summary = calendarName
            ..timeZone = timeZone;

            final createdCalendar = await calendarApi.calendars.insert(calendar);
            log("Calendar created: ${createdCalendar.id}", name: "CalendarService");
            return createdCalendar;
        } catch (e) {
            log("Error creating calendar: $e", name: "CalendarService", level: 1000);
            return null;
        }
    }
    //Delete Calendar
    Future<bool> deleteCalendar(String calendarId) async {
        final calendarApi = await _getCalendarApi();
        if (calendarApi == null) return false;

        try {
            await calendarApi.calendars.delete(calendarId);
            log("Calendar deleted: $calendarId", name: "CalendarService");
            return true;
        } catch (e) {
            log("Error deleting calendar: $e", name: "CalendarService", level: 1000);
            return false;
        }
    }

    //List all calendars
    Future<List<CalendarListEntry>> listCalendars() async {
        final calendarApi = await _getCalendarApi();
        if (calendarApi == null) return [];

        try {
            final calendarList = await calendarApi.calendarList.list();
            log("Fetched ${calendarList.items?.length ?? 0} calendars", name: "CalendarService");
            return calendarList.items ?? [];
        } catch (e) {
            log("Error fetching calendars: $e", name: "CalendarService", level: 1000);
            return [];
        }
    }

    //Share Calendar
    Future<bool> shareCalendar(String calendarId, String userEmail, String role) async {
        final calendarApi = await _getCalendarApi();
        if (calendarApi == null) return false;

        try {
            final aclRule = AclRule()
            ..scope = (AclRuleScope()..type = "user"..value = userEmail)
            ..role = role; // e.g., "reader", "writer", "owner"

            await calendarApi.acl.insert(aclRule, calendarId);
            log("Calendar shared with $userEmail as $role", name: "CalendarService");
            return true;
        } catch (e) {
            log("Error sharing calendar: $e", name: "CalendarService", level: 1000);
            return false;
        }
    }

    //Set Event Reminders
    Future<bool> setEventReminder(String calendarId, String eventId, int minutesBefore) async {
        final calendarApi = await _getCalendarApi();
        if (calendarApi == null) return false;

        try {
            final event = await calendarApi.events.get(calendarId, eventId);
            event.reminders = EventReminders(
                useDefault: false,
                overrides: [EventReminder(method: "popup", minutes: minutesBefore)],
            );

            await calendarApi.events.update(event, calendarId, eventId);
            log("Reminder set for event $eventId: $minutesBefore minutes before", name: "CalendarService");
            return true;
        } catch (e) {
            log("Error setting reminder: $e", name: "CalendarService", level: 1000);
            return false;
        }
    }

    //Update Calendar Settings
    Future<bool> updateCalendarSettings(String calendarId, String newName, String newTimeZone) async {
        final calendarApi = await _getCalendarApi();
        if (calendarApi == null) return false;

        try {
            final calendar = await calendarApi.calendars.get(calendarId);
            calendar.summary = newName;
            calendar.timeZone = newTimeZone;

            await calendarApi.calendars.update(calendar, calendarId);
            log("Calendar updated: $calendarId", name: "CalendarService");
            return true;
        } catch (e) {
            log("Error updating calendar: $e", name: "CalendarService", level: 1000);
            return false;
        }
    }

}

/// Custom HTTP client for Google API authentication
class GoogleHttpClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  GoogleHttpClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _client.send(request);
  }
}

