import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationServiceProvider = Provider((ref) => NotificationService());

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    // デフォルトのタイムゾーンをデバイスに合わせる (簡易的にAsia/Tokyo固定にする等でも可。ここではAsia/Tokyo)
    tz.setLocalLocation(tz.getLocation('Asia/Tokyo'));

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _plugin.initialize(initializationSettings);
  }

  /// 通知の権限リクエスト
  Future<void> requestPermissions() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  /// タスクの期限に合わせて通知をスケジュールする
  /// idはタスクIDのハッシュ値など一意な整数を使用
  Future<void> scheduleTaskNotification({
    required int id,
    required String title,
    required DateTime dueDate,
  }) async {
    // 期限の日の朝9時に通知（すでに過ぎている場合はスケジュールしない）
    var scheduleDate = DateTime(dueDate.year, dueDate.month, dueDate.day, 9, 0);
    if (scheduleDate.isBefore(DateTime.now())) {
      return;
    }

    final scheduledTzDate = tz.TZDateTime.from(scheduleDate, tz.local);

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'task_reminder_channel',
      'タスクリマインダー',
      channelDescription: '期限が近づいているタスクをお知らせします',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelDetails = NotificationDetails(
      android: androidDetails,
    );

    await _plugin.zonedSchedule(
      id,
      '⏳ 期限が迫っています！',
      '「$title」は今日が期限です',
      scheduledTzDate,
      platformChannelDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// 通知のキャンセル
  Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
  }
}
