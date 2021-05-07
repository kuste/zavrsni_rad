import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;
import 'package:rxdart/rxdart.dart';
import 'event.dart';

class LocalNotificationManager {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  var initSetting;
  BehaviorSubject<ReceiveNotification> get didReceiveLocalNotificationSubject => BehaviorSubject<ReceiveNotification>();

  LocalNotificationManager.init() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      requestIOSPermission();
    }
    initializePlatform();
  }

  void requestIOSPermission() {
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>().requestPermissions(
          alert: false,
          badge: false,
          sound: false,
        );
  }

  void initializePlatform() {
    var initSettingAndroid = AndroidInitializationSettings("@mipmap/ic_launcher");
    var initSettiongIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: (
        id,
        title,
        body,
        payload,
      ) async {
        ReceiveNotification notification = ReceiveNotification(id: id, title: title, body: body, payload: payload);
        didReceiveLocalNotificationSubject.add(notification);
      },
    );
    initSetting = InitializationSettings(android: initSettingAndroid, iOS: initSettiongIOS);
  }

  setOnNotificationReceive(Function onNotificationReceive) {
    didReceiveLocalNotificationSubject.listen((notification) {
      onNotificationReceive(notification);
    });
  }

  setOnNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin.initialize(
      initSetting,
      onSelectNotification: (payload) async {
        onNotificationClick(payload);
      },
    );
  }

  Future<void> showNOtification(Event event) async {
    var androidChannel = AndroidNotificationDetails(
      'channelId',
      'channelName',
      'channelDescription',
      importance: Importance.max,
      priority: Priority.high,
      playSound: false,
    );

    var iosChannel = IOSNotificationDetails();
    var platformChannel = NotificationDetails(android: androidChannel, iOS: iosChannel);
    await flutterLocalNotificationsPlugin.show(
      0,
      'New game date',
      event.dateTime.toIso8601String(),
      platformChannel,
      payload: 'payload',
    );
  }
}

LocalNotificationManager localNotificationManager = LocalNotificationManager.init();

class ReceiveNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceiveNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}
