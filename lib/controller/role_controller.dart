import '../database/db.dart';
import '../models/role.dart';

class RoleController {
  static Future<Role> create(Role role) async {
    final db = await DB.instance.database;
    final id = await db.insert('roles', role.toMap());
    return Role(id: id, name: role.name);
  }

  static Future<List<Role>> readAllRoles() async {
    final db = await DB.instance.database;
    final result = await db.query('roles');
    return result.map((e) => Role.fromMap(e)).toList();
  }

  static Future<int> update(Role role) async {
    final db = await DB.instance.database;
    return db.update('roles', role.toMap(), where: 'id = ?', whereArgs: [role.id]);
  }

  static Future<int> delete(int id) async {
    final db = await DB.instance.database;
    return db.delete('roles', where: 'id = ?', whereArgs: [id]);
  }
}
