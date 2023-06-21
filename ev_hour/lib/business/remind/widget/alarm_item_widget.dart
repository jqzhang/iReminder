import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../dao/remind_dao_helper.dart';
import '../../../util/event_uils.dart';
import '../bean/remind_info.dart';
import '../event/reload_remind.dart';

class AlarmItemWidget extends StatefulWidget {
  final VoidCallback onTap;
  RemindInfo remindInfo;

  AlarmItemWidget({
    super.key,
    required this.remindInfo,
    required this.onTap,
  });

  @override
  State<StatefulWidget> createState() => AlarmItemState();
}

class AlarmItemState extends State<AlarmItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Color(widget.remindInfo!.remindColor!),
          width: 1.2,
        ),
      ),
      child: InkWell(
        highlightColor: Color(widget.remindInfo!.remindColor!).withAlpha(15),
        borderRadius: BorderRadius.circular(10.0),
        onTap: widget.onTap,
        child: Container(
          padding:
              const EdgeInsets.only(left: 16, top: 10, right: 16, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.remindInfo.title!,
                      style: const TextStyle(
                        fontSize: 16,
                        // color: Colors.black87,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      DateFormat("yyyy-MM-dd HH:mm:ss")
                          .format(widget.remindInfo.remindDateTime!),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      widget.remindInfo.content!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black38,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Checkbox(
                value: RemindStatus.Completed == widget.remindInfo.isCompleted,
                side: BorderSide(color: Color(widget.remindInfo.remindColor!)),
                shape: CircleBorder(),
                activeColor: Color(widget.remindInfo.remindColor!),
                onChanged: (value) {
                  if (RemindStatus.Completed == widget.remindInfo.isCompleted) {
                    return;
                  }
                  setState(
                    () {
                      widget.remindInfo.isCompleted =
                          RemindStatus.Pending == widget.remindInfo.isCompleted
                              ? RemindStatus.Completed
                              : RemindStatus.Pending;
                    },
                  );
                  finishRemind();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void finishRemind() {
    RemindDaoHelper daoHelper = RemindDaoHelper();
    widget.remindInfo.isCompleted = RemindStatus.Completed;
    daoHelper.updateRemind(widget.remindInfo);
    EventUtils.getInstance().getEventBus().fire(ReloadRemind());
  }
}
