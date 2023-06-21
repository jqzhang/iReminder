import 'dart:async';

import 'package:ev_hour/business/remind/edit_remind_page.dart';
import 'package:ev_hour/business/remind/bean/remind_info.dart';
import 'package:ev_hour/business/remind/widget/alarm_item_widget.dart';
import 'package:ev_hour/business/remind/widget/remind_data_error.dart';
import 'package:ev_hour/dao/remind_dao_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RemindHistoryPage extends StatefulWidget {
  static router(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RemindHistoryPage(),
      ),
    );
  }

  const RemindHistoryPage({super.key});

  @override
  State<StatefulWidget> createState() => _RemindHistoryState();
}

class _RemindHistoryState extends State<RemindHistoryPage> {
  RemindDaoHelper daoHelper = RemindDaoHelper();
  Future<List<RemindInfo>> remindInfoList = Future<List<RemindInfo>>.value([]);

  @override
  void initState() {
    super.initState();
    loadRemindInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void loadRemindInfo() {
    remindInfoList = daoHelper.getReminds(RemindStatus.Completed);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.historyReminders,
        ),
      ),
      body: Container(
        padding:
            const EdgeInsets.only(left: 10, top: 20, right: 10, bottom: 10),
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
                  return AlarmItemWidget(
                    remindInfo: remindInfo,
                    onTap: () {
                      EditRemindPage.router(
                        context,
                        AppLocalizations.of(context)!.checkReminder,
                        remindInfo,
                      );
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _getNoDateView() {
    return Column(
      children: [
        SizedBox(
          height: 150,
        ),
        noData(context, AppLocalizations.of(context)!.noDataFound, null),
      ],
    );
  }
}
