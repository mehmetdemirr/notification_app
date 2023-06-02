import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;
// ignore: depend_on_referenced_packages
import 'package:timezone/timezone.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String currentTimeZone = "";
  static late final Location detroit;

  Future<void> initNotification() async {
    currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
    detroit = tz.getLocation(currentTimeZone);
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('ic_launcher');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'channelName',
        importance: Importance.max,
        //playSound: false,
        //sound: RawResourceAndroidNotificationSound("su_sesi"),
      ),
      iOS: DarwinNotificationDetails(
          // presentSound: false,
          //TODO ios bildirim sesi kurulumu yapılmadı!
          //sound: "su_sesi.mp3",
          ),
    );
  }

  Future showNotification({
    required int id,
    String? title,
    String? body,
    String? payLoad,
  }) async {
    return notificationsPlugin.show(
      id,
      title,
      body,
      await notificationDetails(),
    );
  }

  Future showSheduleNotification({
    required int id,
    required String? title,
    required String? body,
    required String? payLoad,
    required DateTime sheduleTime,
  }) async {
    return notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(sheduleTime, tz.local),
      await notificationDetails(),
      payload: payLoad,
      // ignore: deprecated_member_use
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future showSheduleDailyNotification({
    required int id,
    required String? title,
    required String? body,
    required String? payLoad,
    required Time sheduleTime,
    required Time finishTime,
  }) async {
    return notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      await _sheduledDaily(sheduleTime, finishTime),
      await notificationDetails(),
      payload: payLoad,
      // ignore: deprecated_member_use
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<tz.TZDateTime> _sheduledDaily(
    Time time,
    Time finishTime,
  ) async {
    setLocalLocation(detroit);
    final now = tz.TZDateTime.now(tz.local);
    final sheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
      time.second,
    );
    final finish = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      finishTime.hour,
      finishTime.minute,
      finishTime.second,
    );
    final delete = tz.TZDateTime(
      tz.local,
      0,
      1,
      1,
      0,
      0,
      0,
    );
    // print("test now time $now");
    // print("test shedued time $sheduledTime");

    // return sheduledTime.isBefore(now)
    //     ? sheduledTime.add(const Duration(days: 1))
    //     : sheduledTime;

    return sheduledTime.isBefore(finish)
        ? sheduledTime.isBefore(now)
            ? sheduledTime.add(const Duration(days: 1))
            : sheduledTime
        : delete;
  }

  Future showSheduleWeeklyNotification({
    required int id,
    required String? title,
    required String? body,
    required String? payLoad,
    required Time sheduleTime,
    required Time finishTime,
    required List<int> days,
  }) async {
    return notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      await _sheduledWeekly(sheduleTime, finishTime, days),
      await notificationDetails(),
      payload: payLoad,
      // ignore: deprecated_member_use
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  static Future<tz.TZDateTime> _sheduledWeekly(
    Time time,
    Time finish,
    List<int> days,
  ) async {
    //TODO finish time normal time giridim deneme yapıyorum düzelecek
    tz.TZDateTime sheduleDate = await _sheduledDaily(time, finish);

    while (!days.contains(sheduleDate.weekday)) {
      sheduleDate = sheduleDate.add(const Duration(days: 1));
    }

    //print("test shedued time $sheduleDate");

    return sheduleDate;
  }

  //Etkin bildirimleri alma
  Future<List<ActiveNotification>> activeNotifications() async {
    final List<ActiveNotification> activeNotifications =
        await notificationsPlugin.getActiveNotifications();
    return activeNotifications;
  }

  // Bekleyen bildirim istekleri alınıyor
  Future<List<PendingNotificationRequest>> pendingNotifications() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await notificationsPlugin.pendingNotificationRequests();
    return pendingNotificationRequests;
  }

  // Bildirimi iptal etme / silme #
  Future<void> deleteNotification(int id) async {
    // cancel the notification with id value of zero
    await notificationsPlugin.cancel(id);
  }

  // Tüm bildirimi iptal etme / silme #
  Future<void> allDeleteNotification() async {
    await notificationsPlugin.cancelAll();
  }
}
