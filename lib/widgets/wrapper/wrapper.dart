import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  Future<String?> _getUserType() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? currentUser = auth.currentUser;

    if (currentUser != null) {
      // Firebase user is logged in
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users') // Replace with your collection name
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists) {
        return userDoc['role']; // 'admin' or 'recruiter'
      }
    } else {
      // Check SharedPreferences for student login
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final bool isStudentLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      if (isStudentLoggedIn) {
        return 'student';
      }
    }

    return null; // No user is logged in
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getUserType(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          final String? userType = snapshot.data;

          if (userType == 'admin') {
            return AdminHomePage();
          } else if (userType == 'recruiter') {
            return RecruiterHomePage();
          } else if (userType == 'student') {
            return StudentHomePage();
          } else {
            return LoginPage(); 
          }
        } else {
          return LoginPage(); 
        }
      },
    );
  }
}

class AdminHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Home')),
      body: Center(child: const Text('Welcome Admin')),
    );
  }
}

class RecruiterHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recruiter Home')),
      body: Center(child: const Text('Welcome Recruiter')),
    );
  }
}

class StudentHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Home')),
      body: Center(child: const Text('Welcome Student')),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Page')),
      body: Center(child: const Text('Login Screen')),
    );
  }
}
