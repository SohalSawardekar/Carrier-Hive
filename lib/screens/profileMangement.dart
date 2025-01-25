// ignore_for_file: non_constant_identifier_names, library_private_types_in_public_api

import 'package:carrier_hive/models/studentDetail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileManagementPage extends StatefulWidget {
  final String StudentId;
  const ProfileManagementPage({super.key, required this.StudentId});

  @override
  _ProfileManagementPageState createState() => _ProfileManagementPageState();
}

class _ProfileManagementPageState extends State<ProfileManagementPage> {
  late Future<StudentDetail?> _studentFuture;

  @override
  void initState() {
    super.initState();
    print(widget.StudentId);
    _studentFuture = _fetchStudentDetail(widget.StudentId);
  }

  Future<StudentDetail?> _fetchStudentDetail(String studentId) async {
    try {
      // Fetch student details from Firestore
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('studentDetails')
              .where('studentId', isEqualTo: studentId)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        print('Fetched student: ${doc.data()}');
        return StudentDetail.fromMap(doc.data(), doc.id);
      } else {
        print('No document found for studentId: $studentId');
        return null;
      }
    } catch (e) {
      print('Error fetching student details: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Management'),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<StudentDetail?>(
        future: _studentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data found for this student.'));
          } else {
            final student = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  _buildProfileField('Full Name', student.studentName),
                  _buildProfileField(
                      'College Email', student.studentCollegeEmail),
                  _buildProfileField(
                      'Personal Email', student.studentPersonalEmail),
                  _buildProfileField(
                      'Phone Number', student.studentPhoneNumber.toString()),
                  _buildProfileField('Gender', student.studentGender),
                  _buildProfileField('Department', student.department),
                  _buildProfileField(
                      'Date of Birth',
                      '${student.dateOfBirth.toDate().toLocal()}'
                          .split(' ')[0]),
                  _buildProfileField('Roll Number', student.rollNo),
                  _buildProfileField('Address', student.studentAddress),
                  _buildProfileField(
                      'College Name', student.studentCollegeName),
                  _buildProfileField('Admission Date',
                      '${student.admission.toDate().toLocal()}'.split(' ')[0]),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/user/dashboard');
                    },
                    child: const Text('Dashboard'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildProfileField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
