import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  Future<String?> _getUserType() async {
    try {
      // Check SharedPreferences for login status
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

      if (!isLoggedIn) {
        return null; // User is not logged in
      }

      // Get stored user ID from SharedPreferences
      final String? userId = prefs.getString('userId');
      if (userId == null) {
        return null;
      }

      // Fetch user role from Firestore
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users') // Replace with your Firestore collection name
          .doc(userId)
          .get();

      if (userDoc.exists) {
        return userDoc['role'] as String?; // 'admin', 'recruiter', or 'student'
      } else {
        return null; // No user document found
      }
    } catch (e) {
      debugPrint('Error fetching user role: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getUserType(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          final String? userType = snapshot.data;

          // Navigate based on user role
          if (userType == 'admin') {
            Future.microtask(() =>
                Navigator.pushReplacementNamed(context, '/admin/dashboard'));
          } else if (userType == 'recruiter') {
            Future.microtask(() => Navigator.pushReplacementNamed(
                context, '/recruiter/dashboard'));
          } else if (userType == 'student') {
            Future.microtask(() =>
                Navigator.pushReplacementNamed(context, '/user/dashboard'));
          } else {
            Future.microtask(
                () => Navigator.pushReplacementNamed(context, '/login'));
          }
          return const SizedBox.shrink(); // Empty widget while navigating
        } else {
          Future.microtask(
              () => Navigator.pushReplacementNamed(context, '/login'));
          return const SizedBox.shrink();
        }
      },
    );
  }
}
