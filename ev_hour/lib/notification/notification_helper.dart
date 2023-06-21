import 'dart:async';
import 'dart:io';

import 'package:ev_hour/business/main/main_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ev_hour/business/remind/edit_remind_page.dart';
import 'package:ev_hour/dao/remind_dao_helper.dart';
import 'package:ev_hour/notification/action_cmd.dart';
import 'package:ev_hour/notification/received_notification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart';
import 'package:flutter/services.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final StreamController<ReceivedNotification> didReceiveLocalNotificationStream =
    StreamController<ReceivedNotification>.broadcast();

final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();

const MethodChannel platform =
    MethodChannel('dexterx.dev/flutter_local_notifications_example');

const String portName = 'notification_send_port';

String? selectedNotificationPayload;

/// A notification action which triggers a url launch event
const String urlLaunchActionId = 'id_1';

/// A notification action which triggers a App navigation event
const String navigationActionId = 'id_3';

/// Defines a iOS/MacOS notification category for text input actions.
const String darwinNotificationCategoryText = 'textCategory';

/// Defines a iOS/MacOS notification category for plain actions.
const String darwinNotificationCategoryPlain = 'plainCategory';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

class NotificationHelper {
  static NotificationHelper? _instance;

  NotificationHelper._();

  static NotificationHelper getInstance() {
    _instance ??= NotificationHelper._();

    return _instance!;
  }

  void init() async {
    await _configureLocalTimeZone();

    _requestPermissions();
    final List<DarwinNotificationCategory> darwinNotificationCategories =
        <DarwinNotificationCategory>[
      DarwinNotificationCategory(
        darwinNotificationCategoryText,
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.text(
            'text_1',
            'Action 1',
            buttonTitle: 'Send',
            placeholder: 'Placeholder',
          ),
        ],
      ),
      DarwinNotificationCategory(
        darwinNotificationCategoryPlain,
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.plain('id_1', 'Action 1'),
          DarwinNotificationAction.plain(
            'id_2',
            'Action 2 (destructive)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.destructive,
            },
          ),
          DarwinNotificationAction.plain(
            navigationActionId,
            'Action 3 (foreground)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.foreground,
            },
          ),
          DarwinNotificationAction.plain(
            'id_4',
            'Action 4 (auth required)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.authenticationRequired,
            },
          ),
        ],
        options: <DarwinNotificationCategoryOption>{
          DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
        },
      )
    ];

    /// Note: permissions aren't requested here just to demonstrate that can be
    /// done later
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        didReceiveLocalNotificationStream.add(
          ReceivedNotification(
            id: id,
            title: title,
            body: body,
            payload: payload,
          ),
        );
      },
      notificationCategories: darwinNotificationCategories,
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            selectNotificationStream.add(notificationResponse.payload);
            break;
          case NotificationResponseType.selectedNotificationAction:
            if (notificationResponse.actionId == navigationActionId) {
              selectNotificationStream.add(notificationResponse.payload);
            }
            break;
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  Future<void> _configureLocalTimeZone() async {
    if (kIsWeb || Platform.isLinux) {
      return;
    }
    tz.initializeTimeZones();
    final String? timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName!));
  }

  Future<void> _requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }

  void configureDidReceiveLocalNotificationSubject(BuildContext context) {
    didReceiveLocalNotificationStream.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title!)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body!)
              : null,
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                goNextPage(context, receivedNotification.payload);
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }

  void configureSelectNotificationSubject(BuildContext context) {
    selectNotificationStream.stream.listen(
      (String? payload) async {
        goNextPage(context, payload);
      },
    );
  }

  void goNextPage(BuildContext context, String? cmd) {
    if (null == cmd || cmd.isEmpty) {
      // 跳转到主页
      MainPage.goMainPage(context);
      return;
    }
    if (cmd.startsWith(ActionCmd.ACTION_REMIND_DETAL)) {
      // 解析Id字符串
      String id = cmd.substring(ActionCmd.ACTION_REMIND_DETAL.length);
      int reminderId = int.parse(id);
      // 查找Remind
      RemindDaoHelper helper = RemindDaoHelper();
      helper.initializeDatabase();
      helper.getRemindById(reminderId).then(
            (value) => {
              if (null == value)
                {
                  // 跳转到主页
                  MainPage.goMainPage(context),
                }
              else
                {
                  EditRemindPage.router(
                    context,
                    AppLocalizations.of(context)!.checkReminder,
                    value,
                  )
                }
            },
          );
    } else {
      // 跳转到主页
      MainPage.goMainPage(context);
    }
  }

// 立即展示通知
  Future<void> showNotification(
      int channelId, String title, String body, String payload) async {
    await flutterLocalNotificationsPlugin.show(
      channelId,
      title,
      body,
      null,
      payload: payload,
    );
  }

  // 指定时间展示通知
  Future<void> showAlarmClockNotification(int channelId, String title,
      String body, String payload, TZDateTime tzDateTime) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        channelId,
        title,
        body,
        // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        tzDateTime,
        const NotificationDetails(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload);
  }

  // 取消，如果 id < 0 取消全部
  Future<void> cancelNotification(int id) async {
    if (id < 0) {
      await flutterLocalNotificationsPlugin.cancelAll();
      return;
    }
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<bool> checkNotificationPermission() async {
    IOSFlutterLocalNotificationsPlugin? iosSpecificPlugin =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();

    if (iosSpecificPlugin != null) {
      final bool? result = await iosSpecificPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      if (result != null && result) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
