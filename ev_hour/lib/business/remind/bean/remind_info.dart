// const String tableRemind = 'remind';
// const String columnId = 'id';
// const String title = 'title';
// const String content = 'content';
// const String remindDateTime = 'remindDateTime';
// const String isCompleted = 'isCompleted';
// const String remindColor = 'remindColor';
// const String completeDateTime = 'completeDateTime';

import 'package:intl/intl.dart';

import '../../../ui/date_time_dialog_utils.dart';

class RemindStatus {
  static const int Pending = 0;
  static const int Completed = 1;
}

class RemindInfo {
  int? id;
  String? title;
  String? content;
  DateTime? remindDateTime;
  DateTime? completeDateTime;
  int isCompleted = RemindStatus.Pending;
  int? remindNotificationId;
  int? remindColor;

  RemindInfo(
      {this.id,
      this.title,
      this.content,
      this.remindDateTime,
      this.completeDateTime,
      this.remindNotificationId,
      required this.isCompleted,
      this.remindColor});

  factory RemindInfo.fromMap(Map<String, dynamic> json) => RemindInfo(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        remindDateTime: DateTime.parse(json["remindDateTime"]),
        completeDateTime:
            null == json["completeDateTime"] || json["completeDateTime"].isEmpty
                ? null
                : DateTime.parse(json["completeDateTime"]),
        isCompleted: json["isCompleted"],
        remindColor: json["remindColor"],
        remindNotificationId: json["remindNotificationId"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "content": content,
        "remindDateTime":
            DateFormat(DefaultDateTimeFormat).format(remindDateTime!),
        "completeDateTime": null == completeDateTime
            ? ""
            : DateFormat(DefaultDateTimeFormat).format(completeDateTime!),
        "isCompleted": isCompleted,
        "remindNotificationId": remindNotificationId,
        "remindColor": remindColor,
      };
}
