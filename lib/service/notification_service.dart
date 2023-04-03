import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import '../retrive_data/bloc.dart';
import '../retrive_data/view.dart';
import 'get_repository.dart';

class NotificationService {
  final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey(debugLabel: "Main Navigator"); //
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('mipmap/ic_launcher');

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
            (NotificationResponse notificationResponse) async {
              navigatorKey.currentState?.pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => BlocProvider(
                  create: (context) =>
                      RetriveDataBloc(getApi: GetApiRepository()),
                  child: RepositoryProvider(
                    create: (_) => GetApiRepository(),
                    child: GetList(),
                  ),
                )),
                    (Route<dynamic> route) => false,
              );
            },);

  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel_id 1',
          "liritharan",
          channelDescription:
          "This channel is responsible for all the local notifications",
          playSound: true,
          priority: Priority.high,
          importance: Importance.high,
        ));
  }

  final NotificationDetails notificationDetail = const NotificationDetails(
    android: _androidNotificationDetails,
  );
  static const AndroidNotificationDetails _androidNotificationDetails =
      AndroidNotificationDetails(
    'channel_id 1',
    "liritharan",
    channelDescription:
        "This channel is responsible for all the local notifications",
    playSound: true,
    priority: Priority.high,
    importance: Importance.high,
  );

  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(
        id, title, body, await notificationDetails());
  }

  Future<void> scheduleNotification(int id, String title, String body,
      [DateTimeComponents? dateTimeComponents]) async {
    print('notification');
    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 60)),
      notificationDetail,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: dateTimeComponents,
    );
  }
}
