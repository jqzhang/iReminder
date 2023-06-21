import 'package:ev_hour/business/remind/bean/remind_info.dart';
import 'package:ev_hour/business/remind/event/reload_remind.dart';
import 'package:ev_hour/business/remind/widget/color_radio_button.dart';
import 'package:ev_hour/dao/remind_dao_helper.dart';
import 'package:ev_hour/notification/notification_helper.dart';
import 'package:ev_hour/ui/date_time_dialog_utils.dart';
import 'package:ev_hour/ui/toast_utils.dart';
import 'package:ev_hour/util/event_uils.dart';
import 'package:ev_hour/util/log_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../notification/action_cmd.dart';

class EditRemindPage extends StatefulWidget {
  static router(BuildContext context, String title, RemindInfo? remindInfo,
      {bool isAddReminder = false, bool showEditIcon = false}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditRemindPage(
          title: title,
          remindInfo: remindInfo,
          isAddReminder: isAddReminder,
          showEditIcon: showEditIcon,
        ),
      ),
    );
  }

  final String title;
  RemindInfo? remindInfo;
  bool showEditIcon;
  bool isAddReminder;

  EditRemindPage({
    super.key,
    required this.title,
    this.remindInfo,
    this.isAddReminder = false,
    this.showEditIcon = false,
  });

  @override
  State<StatefulWidget> createState() => _EditRemindState();
}

class _EditRemindState extends State<EditRemindPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? selectedDateTime;
  bool canEdit = false;
  int selectedColorIndex = 0;
  RemindDaoHelper daoHelper = RemindDaoHelper();

  @override
  void initState() {
    super.initState();

    canEdit = widget.isAddReminder;
    if (null != widget.remindInfo) {
      _titleController.text = widget.remindInfo!.title!;
      _descriptionController.text = widget.remindInfo!.content!;
      selectedDateTime = widget.remindInfo!.remindDateTime;

      for (int i = 0; i < remindBorderColorList.length; i++) {
        if (remindBorderColorList[i].value == widget.remindInfo!.remindColor) {
          selectedColorIndex = i;
          break;
        }
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (widget.showEditIcon)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  canEdit = true;
                  widget.showEditIcon = false;
                });
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Title
              TextField(
                enabled: canEdit,
                controller: _titleController,
                style: const TextStyle(
                  fontSize: 16,
                ),
                maxLength: 20,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: AppLocalizations.of(context)!.title,
                  labelStyle: const TextStyle(
                    fontSize: 14,
                  ),
                  hintText: AppLocalizations.of(context)!.enterTitle,
                  hintStyle: const TextStyle(
                    fontSize: 14,
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.surfaceVariant),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              // Details
              TextFormField(
                enabled: canEdit,
                controller: _descriptionController,
                maxLength: 100,
                minLines: 1,
                maxLines: 50,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.details,
                  labelStyle: const TextStyle(
                    fontSize: 14,
                  ),
                  hintText: AppLocalizations.of(context)!.enterDetails,
                  hintStyle: const TextStyle(
                    fontSize: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.surfaceVariant),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              // Choose datetime
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1,
                    color: canEdit
                        ? Theme.of(context).colorScheme.outline
                        : Theme.of(context).colorScheme.surfaceVariant,
                  ),
                ),
                child: InkWell(
                  highlightColor: Theme.of(context).primaryColor.withAlpha(20),
                  enableFeedback: canEdit,
                  borderRadius: BorderRadius.circular(10.0),
                  onTap: canEdit
                      ? () {
                          DateTime now = DateTime.now();
                          DateTime? minimumDate = null == selectedDateTime
                              ? now
                              : now.isAfter(selectedDateTime!)
                                  ? selectedDateTime
                                  : now;

                          showBottomDateTimePicker(
                            context,
                            selectedDateTime,
                            minimumDate,
                          ).then(
                            (value) => {
                              setState(
                                () {
                                  if (value != null) {
                                    selectedDateTime = value;
                                  }
                                },
                              )
                            },
                          );
                        }
                      : null,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          null == selectedDateTime
                              ? AppLocalizations.of(context)!.selectReminderTime
                              : '${DateFormat("yyyy-MM-dd HH:mm:ss").format(selectedDateTime!)}(${AppLocalizations.of(context)!.reminderTime})',
                          style: TextStyle(
                            fontSize: 14,
                            color: canEdit
                                ? Colors.black87
                                : Theme.of(context).disabledColor,
                          ),
                        ),
                        Icon(
                          CupertinoIcons.right_chevron,
                          color: canEdit
                              ? IconTheme.of(context).color
                              : Theme.of(context).disabledColor,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              // choose color
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1,
                    color: canEdit
                        ? Theme.of(context).colorScheme.outline
                        : Theme.of(context).colorScheme.surfaceVariant,
                  ),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.chooseColor,
                          style: TextStyle(
                            fontSize: 16,
                            color: canEdit
                                ? Colors.black87
                                : Theme.of(context).disabledColor,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ColorRadioButton(
                          buttonColors: remindBorderColorList,
                          onSelected: (index, color) {
                            selectedColorIndex = index;
                          },
                          defaultSelectedIndex: selectedColorIndex,
                          canSelect: canEdit,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30.0),
              // button confirm
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: canEdit ? addRemind : null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 12.0),
                        child: Text(AppLocalizations.of(context)!.confirm),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addRemind() {
    // 查看提醒详情，且详情未完成时，可以修改内容
    if (widget.remindInfo != null) {
      // 更新内容
      if (RemindStatus.Pending == widget.remindInfo!.isCompleted) {
        widget.remindInfo!.title = _titleController.text;
        widget.remindInfo!.content = _descriptionController.text;
        widget.remindInfo!.remindDateTime = selectedDateTime;
        widget.remindInfo!.remindColor =
            remindBorderColorList[selectedColorIndex].value;
        widget.remindInfo!.isCompleted = RemindStatus.Pending;

        daoHelper.updateRemind(widget.remindInfo!).then(
              (value) => {
                updateRemindAndBack(widget.remindInfo!, true),
              },
            );
        // 取消通知，更新通知时间
      }
    } else {
      bool canInsert = checkRemindParams();
      if (false == canInsert) {
        return;
      }
      // 插入内容
      RemindInfo remindInfo = RemindInfo(
        title: _titleController.text.trim(),
        content: _descriptionController.text.trim(),
        remindDateTime: selectedDateTime,
        remindColor: remindBorderColorList[selectedColorIndex].value,
        isCompleted: 0,
      );

      daoHelper.insertRemind(remindInfo).then(
            (value) => {
              if (0 == value)
                {
                  showToast(AppLocalizations.of(context)!.addReminderFailed),
                }
              else
                {
                  // 新增通知时间
                  remindInfo.id = value,
                  remindInfo.remindNotificationId = value,
                  updateRemindAndBack(remindInfo, false),
                }
            },
          );
    }
  }

  void updateRemindAndBack(RemindInfo remindInfo, bool needCancelNotification) {
    daoHelper.updateRemind(remindInfo).then(
          (value) => {
            if (needCancelNotification)
              {
                printLog("updateRemindAndBack:${remindInfo.toMap()}"),
                NotificationHelper.getInstance()
                    .cancelNotification(remindInfo.remindNotificationId!)
                    .then(
                      (value) => {
                        printLog("updateRemindAndBack addNotification"),
                        addNotification(remindInfo),
                      },
                    ),
              }
            else
              {
                addNotification(remindInfo),
              },
            EventUtils.getInstance().getEventBus().fire(ReloadRemind()),
          },
        );

    Navigator.of(context).pop(this);
  }

  bool checkRemindParams() {
    if (_titleController.text.trim().isEmpty) {
      showToast(AppLocalizations.of(context)!.enterTitle);
      return false;
    }

    if (_descriptionController.text.trim().isEmpty) {
      showToast(AppLocalizations.of(context)!.enterDetails);
      return false;
    }

    if (null == selectedDateTime) {
      showToast(AppLocalizations.of(context)!.selectReminderTime);
      return false;
    }

    return true;
  }

  void addNotification(RemindInfo remindInfo) {
    DateTime now = DateTime.now();
    if (remindInfo.remindDateTime!
        .isBefore(now.add(const Duration(seconds: 2)))) {
      // 立即展示通知
      NotificationHelper.getInstance().showNotification(
        remindInfo!.remindNotificationId!,
        remindInfo!.title!,
        remindInfo!.content!,
        ActionCmd.ACTION_REMIND_DETAL + remindInfo!.id!.toString(),
      );
      return;
    }
    NotificationHelper.getInstance().showAlarmClockNotification(
      remindInfo!.remindNotificationId!,
      remindInfo!.title!,
      remindInfo!.content!,
      ActionCmd.ACTION_REMIND_DETAL + remindInfo!.id!.toString(),
      tz.TZDateTime.from(remindInfo.remindDateTime!, tz.local),
    );
  }
}
