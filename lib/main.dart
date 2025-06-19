import 'package:flutter/material.dart';
import 'pages/user_page.dart';
import 'pages/role_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Role Manager',
      debugShowCheckedModeBanner: false,
      home: const UserPage(),
      routes: {
        '/roles': (_) => const RolePage(),
      },
    );
  }
}
