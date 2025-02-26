import 'package:carrier_hive/screens/admin/homepage.dart';
import 'package:carrier_hive/screens/applicationStatus.dart';
import 'package:carrier_hive/screens/recruiter/homepage.dart';
import 'package:carrier_hive/screens/user/applyJob.dart';
import 'package:carrier_hive/screens/user/homepage.dart';
import 'package:carrier_hive/widgets/auth/login.dart';
import 'package:carrier_hive/widgets/wrapper/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:carrier_hive/config/firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Carrier Hive',
      initialRoute: '/',
      routes: {
        '/': (context) => const Wrapper(),
        '/login': (context) => const Login(),
        '/admin/dashboard': (context) => const adminDashboard(),
        '/user/dashboard': (context) => const StudentDashboard(),
        '/recruiter/dashboard': (context) => const RecruiterDashboard(),
        '/user/dashboard/Jobs': (context) => const StudentJobsPage(),
        '/user/dashboard/applications': (context) =>
            const ApplicationStatusPage(),
      },
    );
  }
}
