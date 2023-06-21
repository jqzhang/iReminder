

import 'package:flutter/material.dart';

import '../notification/notification_helper.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationTestPage extends StatefulWidget {

  static router(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationTestPage(),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => NotificationState();
}

class NotificationState extends State<NotificationTestPage>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await NotificationHelper.getInstance().showNotification(0, "title", "body", '立即发送通知');
              },
              child: Text('立即发送通知'),
            ),
            ElevatedButton(
              onPressed: () async {
                await NotificationHelper.getInstance().showAlarmClockNotification(0, "title", "body", '延时发送通知', tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)));
              },
              child: Text('延时发送通知'),
            ),
            ElevatedButton(
              onPressed: () async {
                await NotificationHelper.getInstance().showAlarmClockNotification(0, "title", "body",'定时发送通知',tz.TZDateTime.from(DateTime.now(), tz.local).add(const Duration(seconds: 5)));
              },
              child: Text('定时发送通知'),
            ),
          ],
        ),
      ),
    );
  }

}