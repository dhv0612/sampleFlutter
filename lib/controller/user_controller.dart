import '../models/user.dart';
import '../database/db.dart';

class UserController {
  static Future<User> create(User user) async {
    final db = await DB.instance.database;
    final id = await db.insert('users', user.toMap());
    return user.copyWith(id: id);
  }

  static Future<List<User>> readAllUsers() async {
    final db = await DB.instance.database;
    final result = await db.query('users');
    return result.map((map) => User.fromMap(map)).toList();
  }

  static Future<int> update(User user) async {
    final db = await DB.instance.database;
    return db.update('users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  static Future<int> delete(int id) async {
    final db = await DB.instance.database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  static Future close() async {
    final db = await DB.instance.database;
    db.close();
  }
}
