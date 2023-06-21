
import 'package:ev_hour/core/ev_cache.dart';
import 'package:ev_hour/dao/remind_dao_helper.dart';

Future<void> initConfig() async{
  EvSPCache();
  RemindDaoHelper().initializeDatabase();
}