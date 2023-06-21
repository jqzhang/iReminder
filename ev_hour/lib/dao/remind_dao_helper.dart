import 'package:ev_hour/business/remind/bean/remind_info.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../ui/date_time_dialog_utils.dart';

const String tableRemind = 'remind';
const String columnId = 'id';
const String title = 'title';
const String content = 'content';
const String remindDateTime = 'remindDateTime';
const String isCompleted = 'isCompleted';
const String remindColor = 'remindColor';
const String remindNotificationId = 'remindNotificationId';
const String completeDateTime = 'completeDateTime';

class RemindDaoHelper {
  static Database? _database;

  static RemindDaoHelper? _daoHelper;

  RemindDaoHelper._createInstance();

  factory RemindDaoHelper() {
    _daoHelper ??= RemindDaoHelper._createInstance();
    return _daoHelper!;
  }

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    var dir = await getDatabasesPath();
    var path = "$dir/remind.db";

    var database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          create table $tableRemind ( 
          $columnId integer primary key autoincrement, 
          $title text not null,
          $content text not null,
          $remindDateTime text not null,
          $completeDateTime text,
          $isCompleted integer,
          $remindNotificationId integer,
          $remindColor integer)
        ''');
      },
    );
    return database;
  }

  Future<int> insertRemind(RemindInfo remindInfo) async {
    var db = await database;
    var result = await db.insert(tableRemind, remindInfo.toMap());
    print('result : $result');

    return result;
  }

  Future<int> updateRemind(RemindInfo remindInfo) async {
    var db = await database;
    var result = await db.rawUpdate(
      'UPDATE $tableRemind '
      'SET '
      '$title = ?, '
      '$content = ?, '
      '$remindDateTime = ?, '
      '$completeDateTime = ?, '
      '$isCompleted = ?, '
      '$remindColor = ?, '
      '$remindNotificationId = ? '
      'WHERE  $columnId = ?',
      [
        remindInfo.title,
        remindInfo.content,
        DateFormat(DefaultDateTimeFormat).format(remindInfo.remindDateTime!),
        null == remindInfo.completeDateTime
            ? ""
            : DateFormat(DefaultDateTimeFormat)
                .format(remindInfo.completeDateTime!),
        remindInfo.isCompleted,
        remindInfo.remindColor,
        remindInfo.remindNotificationId,
        remindInfo.id
      ],
    );
    return result;
  }

  Future<List<RemindInfo>> getReminds(int status) async {
    List<RemindInfo> reminds = [];

    var db = await database;
    var result = await db
        .rawQuery('SELECT * FROM $tableRemind WHERE $isCompleted = ${status}');

    for (var element in result) {
      var alarmInfo = RemindInfo.fromMap(element);
      reminds.add(alarmInfo);
    }

    return reminds;
  }

  Future<RemindInfo?> getRemindById(int id) async {
    List<RemindInfo> reminds = [];

    var db = await database;
    var result =
        await db.rawQuery('SELECT * FROM $tableRemind WHERE $columnId = ${id}');

    for (var element in result) {
      var info = RemindInfo.fromMap(element);
      reminds.add(info);
    }

    if (reminds.isEmpty) {
      return null;
    }
    return reminds[0];
  }
}
