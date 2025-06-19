import 'package:flutter/material.dart';
import '../models/role.dart';
import '../controller/role_controller.dart';

class RolePage extends StatefulWidget {
  const RolePage({super.key});

  @override
  State<RolePage> createState() => _RolePageState();
}

class _RolePageState extends State<RolePage> {
  List<Role> roles = [];
  final nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadRoles();
  }

  Future loadRoles() async {
    roles = await RoleController.readAllRoles();
    setState(() {});
  }

  Future addRole() async {
    final name = nameController.text.trim();
    if (name.isNotEmpty) {
      await RoleController.create(Role(name: name));
      nameController.clear();
      loadRoles();
    }
  }

  Future deleteRole(int id) async {
    await RoleController.delete(id);
    loadRoles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý vai trò')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Tên vai trò')),
                ),
                IconButton(onPressed: addRole, icon: const Icon(Icons.add)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: roles.length,
              itemBuilder: (_, index) {
                final role = roles[index];
                return ListTile(
                  title: Text(role.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => deleteRole(role.id!),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
