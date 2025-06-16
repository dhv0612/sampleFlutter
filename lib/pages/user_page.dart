import 'package:flutter/material.dart';
import '../models/user.dart';
import '../controller/user_controller.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    refreshUsers();
  }

  Future refreshUsers() async {
    final data = await UserController.readAllUsers();
    setState(() => users = data);
  }

  Future showUserDialog({User? user}) async {
    final nameController = TextEditingController(text: user?.name ?? '');
    final ageController = TextEditingController(
        text: user != null ? user.age.toString() : '');

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
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
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final age = int.tryParse(ageController.text.trim()) ?? 0;
              if (name.isNotEmpty && age > 0) {
                if (user == null) {
                  UserController.create(User(name: name, age: age));
                } else {
                  UserController.update(
                    user.copyWith(name: name, age: age),
                  );
                }
                Navigator.pop(ctx, true);
              }
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );

    if (result == true) {
      refreshUsers();
    }
  }

  Future deleteUser(int id) async {
    await UserController.delete(id);
    refreshUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách người dùng'),
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            tooltip: 'Quản lý vai trò',
            onPressed: () {
              Navigator.pushNamed(context, '/roles');
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Thêm người dùng',
            onPressed: () => showUserDialog(),
          ),
        ],
      ),
      body: users.isEmpty
          ? const Center(child: Text('Chưa có người dùng nào'))
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (ctx, index) {
                final user = users[index];
                return ListTile(
                  title: Text('${user.name} (${user.age})'),
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
