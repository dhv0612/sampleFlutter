import 'package:flutter/material.dart';
import '../models/user.dart';
import '../database/user_database.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<User> users = [];

  final nameController = TextEditingController();
  final ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    refreshUsers();
  }

  Future refreshUsers() async {
    final data = await UserDatabase.instance.readAllUsers();
    setState(() => users = data);
  }

  Future addUser() async {
    final name = nameController.text;
    final age = int.tryParse(ageController.text) ?? 0;
    if (name.isEmpty || age <= 0) return;

    await UserDatabase.instance.create(User(name: name, age: age));
    nameController.clear();
    ageController.clear();
    refreshUsers();
  }

  Future updateUser(User user) async {
    final newName = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Update User"),
        content: TextField(
          controller: TextEditingController(text: user.name),
          onSubmitted: (value) => Navigator.pop(ctx, value),
        ),
      ),
    );

    if (newName != null && newName.isNotEmpty) {
      await UserDatabase.instance.update(
        user.copyWith(name: newName),
      );
      refreshUsers();
    }
  }

  Future deleteUser(int id) async {
    await UserDatabase.instance.delete(id);
    refreshUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User CRUD with SQLite')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: ageController,
                    decoration: const InputDecoration(labelText: 'Age'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: addUser,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
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
                        onPressed: () => updateUser(user),
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
          ),
        ],
      ),
    );
  }
}