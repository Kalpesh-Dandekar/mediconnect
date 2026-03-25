import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

class ReminderService {

  static final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  /// 🔥 INIT
  static Future<void> init() async {

    tz.initializeTimeZones();

    const AndroidInitializationSettings androidInit =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
    InitializationSettings(android: androidInit);

    await _notifications.initialize(settings);

    /// 🔥 REQUEST PERMISSION (IMPORTANT FOR ANDROID 13+)
    await _notifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    print("✅ Notification Initialized");
  }

  /// 🔥 DEBUG MODE (INSTANT NOTIFICATION)
  static Future<void> scheduleReminder({
    required String medicineName,
    required String time,
    required int id,
  }) async {

    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'medicine_channel',
      'Medicine Reminders',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details =
    NotificationDetails(android: androidDetails);

    /// 🔥 INSTANT SHOW (FOR TESTING)
    await _notifications.show(
      id,
      "Medicine Reminder (TEST)",
      "Time to take $medicineName",
      details,
    );

    print("🔥 TEST NOTIFICATION TRIGGERED");
  }

  /// 🔁 LATER USE (REAL SCHEDULING)
  static Future<void> scheduleRealReminder({
    required String medicineName,
    required String time,
    required int id,
  }) async {

    final prefs = await SharedPreferences.getInstance();
    final reminderKey = "reminder_$id";

    if (prefs.getBool(reminderKey) == true) return;

    final now = DateTime.now();
    final scheduledTime = now.add(const Duration(minutes: 1)); // test

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
    );

    await prefs.setBool(reminderKey, true);

    print("⏰ Scheduled Reminder Set");
  }
}