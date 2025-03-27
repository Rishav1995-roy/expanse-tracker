import 'package:hive_flutter/hive_flutter.dart';

class UserStorage {
  static late Box<dynamic> box;

  static const String _boxName = 'user_box';
  static const String _userIdKey = 'user_id';

  static Future<void> init() async {
    await Hive.initFlutter();
    box = await Hive.openBox(_boxName);
  }

  static void saveUserId(String userId) {
    box.put(_userIdKey, userId);
  }

  static String getUserId() {
    return box.get(_userIdKey, defaultValue: '');
  }

  static void clearUserId() {
    box.delete(_userIdKey);
  }
} 