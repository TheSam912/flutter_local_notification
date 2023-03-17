import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class LocalNotificationService {
  LocalNotificationService();

  final _localNotification = FlutterLocalNotificationsPlugin();
  final BehaviorSubject<String?> onNotificationClick = BehaviorSubject();

  Future<void> init() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@drawable/ic_launcher');

    DarwinInitializationSettings iosInitializeSettings =
        DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
            onDidReceiveLocalNotification: _onDidReceiveLocalNotification);
    final InitializationSettings settings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializeSettings);

    await _localNotification.initialize(
      settings,
    );
  }

  Future<NotificationDetails> notificationDetail() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channelId', 'channelName',
            channelDescription: 'description',
            importance: Importance.max,
            priority: Priority.max,
            playSound: true);
    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails();

    return const NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);
  }

  Future<void> showNotification(
      {required int id, required String title, required String body}) async {
    final details = NotificationDetails();
    _localNotification.show(id, title, body, details);
  }

  Future<void> showSchedoualNotification(
      {required int id,
      required String title,
      required String body,
      required int second}) async {
    final details = NotificationDetails();
    _localNotification.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(
            DateTime.now().add(Duration(seconds: second)), tz.local),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        details);
  }

  Future<void> showNotificationWithPayload(
      {required int id,
      required String title,
      required String body,
      required String payload}) async {
    final details = NotificationDetails();
    _localNotification.show(id, title, body, details, payload: payload);
  }

  void _onDidReceiveLocalNotification(
      int? id, String? title, String? body, String? payload) {
    print("id: $id");
  }

  void _onNotificationClick(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      onNotificationClick.add(payload);
    }
  }
}
