import 'package:carrier_hive/auth/login.dart';
import 'package:flutter/material.dart';

class adminDashboard extends StatefulWidget {
  const adminDashboard({super.key});

  @override
  State<adminDashboard> createState() => _adminDashboardState();
}

class _adminDashboardState extends State<adminDashboard> {
  void logOut() async {
    final FirestoreAuthService authService = FirestoreAuthService();
    await authService.logout();
    Navigator.pushNamed(context, '/login');
    print("Logged Out");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Text("admin Page"),
          ElevatedButton(onPressed: logOut, child: Text("Log Out"))
        ],
      )),
    );
  }
}
