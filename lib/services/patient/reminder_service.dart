import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

class ReminderService {

  static final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  /// Initialize notifications
  static Future<void> init() async {

    tz.initializeTimeZones();

    const AndroidInitializationSettings androidInit =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
    InitializationSettings(android: androidInit);

    await _notifications.initialize(settings);
  }

  /// Convert 12-hour time string to DateTime
  static DateTime _parseTime(String time) {

    final parts = time.split(" ");
    final hm = parts[0].split(":");

    int hour = int.parse(hm[0]);
    int minute = int.parse(hm[1]);

    final period = parts[1];

    if (period == "PM" && hour != 12) hour += 12;
    if (period == "AM" && hour == 12) hour = 0;

    final now = DateTime.now();

    return DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
  }

  /// Schedule daily medicine reminder (with duplicate prevention)
  static Future<void> scheduleReminder({
    required String medicineName,
    required String time,
    required int id,
  }) async {

    final prefs = await SharedPreferences.getInstance();

    final reminderKey = "reminder_$id";

    /// Prevent duplicate scheduling
    if (prefs.getBool(reminderKey) == true) {
      return;
    }

    final scheduledTime = _parseTime(time);

    final tzTime = tz.TZDateTime.from(scheduledTime, tz.local);

    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'medicine_channel',
      'Medicine Reminders',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details =
    NotificationDetails(android: androidDetails);

    await _notifications.zonedSchedule(
      id,
      "Medicine Reminder",
      "Time to take $medicineName",
      tzTime,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    /// Save reminder as scheduled
    await prefs.setBool(reminderKey, true);
  }

  /// Cancel reminder (if medicine removed)
  static Future<void> cancelReminder(int id) async {

    final prefs = await SharedPreferences.getInstance();

    final reminderKey = "reminder_$id";

    await _notifications.cancel(id);

    await prefs.remove(reminderKey);
  }

  /// Clear all reminders (useful for testing)
  static Future<void> clearAllReminders() async {

    final prefs = await SharedPreferences.getInstance();

    await _notifications.cancelAll();

    await prefs.clear();
  }
}