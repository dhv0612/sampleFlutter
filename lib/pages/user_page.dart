import 'package:flutter/material.dart';

import '../controller/role_controller.dart';
import '../controller/user_controller.dart';
import '../models/role.dart';
import '../models/user.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<User> users = [];
  List<Role> roles = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future loadData() async {
    users = await UserController.readAllUsers();
    roles = await RoleController.readAllRoles();
    setState(() {});
  }

  Future showUserDialog({User? user}) async {
    final nameController = TextEditingController(text: user?.name ?? '');
    final ageController = TextEditingController(
      text: user?.age.toString() ?? '',
    );
    Role? selectedRole =
        user != null
            ? roles.firstWhere(
              (r) => r.id == user.roleId,
              orElse: () => roles.isNotEmpty ? roles[0] : Role(name: ''),
            )
            : null;

    final result = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(user == null ? 'Thêm người dùng' : 'Sửa người dùng'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Tên'),
                ),
                TextField(
                  controller: ageController,
                  decoration: const InputDecoration(labelText: 'Tuổi'),
                  keyboardType: TextInputType.number,
                ),
                DropdownButton<Role>(
                  isExpanded: true,
                  value: selectedRole,
                  hint: const Text('Chọn vai trò'),
                  items:
                      roles.map((role) {
                        return DropdownMenuItem(
                          value: role,
                          child: Text(role.name),
                        );
                      }).toList(),
                  onChanged: (role) => setState(() => selectedRole = role),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  final age = int.tryParse(ageController.text.trim()) ?? 0;
                  if (name.isNotEmpty && age > 0 && selectedRole != null) {
                    if (user == null) {
                      UserController.create(
                        User(name: name, age: age, roleId: selectedRole!.id),
                      );
                    } else {
                      UserController.update(
                        user.copyWith(
                          name: name,
                          age: age,
                          roleId: selectedRole!.id,
                        ),
                      );
                    }
                    Navigator.pop(context, true);
                  }
                },
                child: const Text('Lưu'),
              ),
            ],
          ),
    );

    if (result == true) loadData();
  }

  Future deleteUser(int id) async {
    await UserController.delete(id);
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Người dùng'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              await Navigator.pushNamed(context, '/roles');
              await loadData(); // Gọi lại để load roles mới
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => showUserDialog(),
          ),
        ],
      ),
      body:
          users.isEmpty
              ? const Center(child: Text('Chưa có người dùng nào'))
              : ListView.builder(
                itemCount: users.length,
                itemBuilder: (_, index) {
                  final user = users[index];
                  final role = roles.firstWhere(
                    (r) => r.id == user.roleId,
                    orElse: () => Role(name: 'Không rõ'),
                  );
                  return ListTile(
                    title: Text('${user.name} (${user.age})'),
                    subtitle: Text('Vai trò: ${role.name}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => showUserDialog(user: user),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => deleteUser(user.id!),
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
