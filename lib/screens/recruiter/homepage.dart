import 'package:carrier_hive/auth/login.dart';
import 'package:flutter/material.dart';

class recruiterDashboard extends StatefulWidget {
  const recruiterDashboard({super.key});

  @override
  State<recruiterDashboard> createState() => recruiterDashboardState();
}

class recruiterDashboardState extends State<recruiterDashboard> {
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
          Text("Recruiter area"),
          ElevatedButton(onPressed: logOut, child: Text("Log Out"))
        ],
      )),
    );
  }
}
