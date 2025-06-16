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
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const UserPage(),
        '/roles': (context) => const RolePage(),
      },
    );
  }
}
