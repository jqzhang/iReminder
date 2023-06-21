import 'dart:async';

import 'package:ev_hour/business/remind/edit_remind_page.dart';
import 'package:ev_hour/business/remind/event/reload_remind.dart';
import 'package:ev_hour/business/remind/bean/remind_info.dart';
import 'package:ev_hour/business/remind/widget/alarm_item_widget.dart';
import 'package:ev_hour/business/remind/widget/current_date_time.dart';
import 'package:ev_hour/business/remind/widget/remind_data_error.dart';
import 'package:ev_hour/dao/remind_dao_helper.dart';
import 'package:ev_hour/theme/color_schemes.g.dart';
import 'package:ev_hour/util/event_uils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RemindPage extends StatefulWidget {
  static const String routeName = '/';

  const RemindPage({super.key});

  @override
  State<StatefulWidget> createState() => _RemindState();
}

class _RemindState extends State<RemindPage> {
  StreamSubscription<ReloadRemind>? eventListener;
  RemindDaoHelper daoHelper = RemindDaoHelper();
  Future<List<RemindInfo>> remindInfoList = Future<List<RemindInfo>>.value([]);

  @override
  void initState() {
    initializeRemindInfo();
    super.initState();

    eventListener = EventUtils.getInstance()
        .getEventBus()
        .on<ReloadRemind>()
        .listen((event) {
      loadRemindInfo();
    });
  }

  @override
  void dispose() {
    super.dispose();
    eventListener?.cancel();
  }

  Future<void> initializeRemindInfo() async {
    await daoHelper.initializeDatabase();
    loadRemindInfo();
  }

  void loadRemindInfo() {
    remindInfoList = daoHelper.getReminds(RemindStatus.Pending);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          AppLocalizations.of(context)!.today,
          style: const TextStyle(
            fontSize: 35,
          ),
        ),
        centerTitle: false,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            CurrentDateTime(),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: FutureBuilder<List<RemindInfo>>(
                future: remindInfoList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // 数据加载中
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    // 数据获取错误
                    return loadRemindError(
                        context, snapshot.error.toString(), loadRemindInfo);
                  } else if (false == snapshot.hasData) {
                    return _getNoDateView();
                  } else {
                    final listData = snapshot.data!;
                    if (listData.isEmpty) {
                      return _getNoDateView();
                    }

                    return ListView.builder(
                      itemCount: listData.length,
                      itemBuilder: (context, index) {
                        RemindInfo remindInfo = listData[index];
                        print(remindInfo.toMap());
                        return AlarmItemWidget(
                          remindInfo: remindInfo,
                          onTap: () {
                            EditRemindPage.router(
                              context,
                              AppLocalizations.of(context)!.editReminder,
                              remindInfo,
                              showEditIcon: true,
                            );
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getNoDateView() {
    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 80,
          ),
          noData(
            context,
            AppLocalizations.of(context)!.noPendingReminders,
            () {
              // 跳转到添加待办页面
              EditRemindPage.router(
                  context, AppLocalizations.of(context)!.addReminder, null,
                  isAddReminder: true);
            },
          )
        ],
      ),
    );
  }
}
