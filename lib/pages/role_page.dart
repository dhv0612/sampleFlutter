import 'package:flutter/material.dart';
import '../models/user.dart';
import '../controller/user_controller.dart';

class RolePage extends StatefulWidget {
  const RolePage({super.key});

  @override
  State<RolePage> createState() => _RolePageState();
}

class _RolePageState extends State<RolePage> {
  List<User> users = [];
  final List<String> roles = ['Admin', 'Member', 'Viewer'];

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future loadUsers() async {
    users = await UserController.readAllUsers();
    setState(() {});
  }

  Future updateRole(User user, String newRole) async {
    final updated = user.copyWith(role: newRole);
    await UserController.update(updated);
    loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phân quyền người dùng')),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (_, index) {
          final user = users[index];
          return ListTile(
            title: Text(user.name),
            subtitle: Text('Role hiện tại: ${user.role}'),
            trailing: DropdownButton<String>(
              value: user.role,
              onChanged: (value) {
                if (value != null) updateRole(user, value);
              },
              items: roles.map((role) {
                return DropdownMenuItem(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
