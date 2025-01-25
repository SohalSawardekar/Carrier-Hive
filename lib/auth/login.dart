import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirestoreAuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Login Function
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // Query Firestore for the user
      final QuerySnapshot result = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password) // Match hashed password
          .get();

      if (result.docs.isNotEmpty) {
        final user = result.docs.first.data() as Map<String, dynamic>;

        // Save user session locally
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', user['email']);
        await prefs.setString('role', user['role']);
        await prefs.setBool('isLoggedIn', true);

        return {
          'success': true,
          'role': user['role'], 
        };
      } else {
        return {
          'success': false,
          'message': 'Invalid email or password',
        };
      }
    } catch (e) {
      throw Exception('Error during login: $e');
    }
  }

  /// Logout Function
  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all saved session data
  }

  /// Check if User is Logged In
  Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  /// Get Logged-in User Role
  Future<String?> getUserRole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }
}
