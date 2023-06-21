import 'package:ev_hour/business/remind/edit_remind_page.dart';
import 'package:ev_hour/core/ev_cache.dart';
import 'package:ev_hour/notification/notification_helper.dart';
import 'package:ev_hour/util/log_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../ui/dialog_utils.dart';
import '../mine/mine_page.dart';
import '../remind/remind_page.dart';
import 'package:flutter/rendering.dart';

class MainPage extends StatefulWidget {
  static void goMainPage(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (BuildContext context) => MainPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  State<StatefulWidget> createState() => _MainState();
}

class _MainState extends State<MainPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    // 初始化Notification
    NotificationHelper.getInstance().init();
    NotificationHelper.getInstance()
        .configureDidReceiveLocalNotificationSubject(context);
    NotificationHelper.getInstance()
        .configureSelectNotificationSubject(context);

    // 检查通知权限
    checkNotificationPermission();
  }

  final List<Widget> _pages = [
    const RemindPage(),
    MinePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_selectedIndex],
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 1, // 灰色线高度
              color: Colors.grey[300], // 灰色线颜色
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildTabItem(
                CupertinoIcons.home, AppLocalizations.of(context)!.home, 0),
            _buildTabItem(
                CupertinoIcons.person, AppLocalizations.of(context)!.mine, 1),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 跳转到添加待办页面
          EditRemindPage.router(
            context,
            AppLocalizations.of(context)!.addReminder,
            null,
            isAddReminder: true,
          );
        },
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildTabItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 30,
            color: _selectedIndex == index
                ? Theme.of(context).primaryColor
                : Colors.grey,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: _selectedIndex == index ? Colors.black87 : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  void checkNotificationPermission() async {
    // 首次启动不检查，系统会自动
    bool? hasOpened = await EvSPCache().get<bool>("HasOpened");
    printLog("hasOpened $hasOpened");
    EvSPCache().setBool('HasOpened', true);
    if (null == hasOpened) {
      return;
    }
    if (false == hasOpened) {
      return;
    }

    // 检查权限，未打开情况弹框提醒
    NotificationHelper.getInstance().checkNotificationPermission().then(
          (value) => {
            // 未打开，弹框提醒
            if (false == value)
              {
                showEvDialog(
                  context,
                  AppLocalizations.of(context)!.noNotificationPermissionTip,
                  AppLocalizations.of(context)!.enable,
                  () async {
                    if (await canLaunchUrl(Uri.parse('app-settings:'))) {
                      // 打开通知设置页面
                      await launchUrl(Uri.parse('app-settings:'));
                    } else {
                      printLog('Cannot open app settings.');
                    }
                  },
                )
              }
          },
        );
  }
}
