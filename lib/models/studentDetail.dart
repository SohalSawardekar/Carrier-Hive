// ignore_for_file: non_constant_identifier_names, file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class StudentDetail {
  final String studentId;
  final String studentName;
  final String studentCollegeEmail;
  final String studentPersonalEmail;
  final int studentPhoneNumber;
  final String studentGender;
  final String department;
  final Timestamp dateOfBirth;
  final String rollNo;
  final String studentAddress;
  final String studentCollegeName;
  final Timestamp admission;

  StudentDetail({
    required this.studentId,
    required this.studentName,
    required this.studentCollegeEmail,
    required this.studentPersonalEmail,
    required this.studentPhoneNumber,
    required this.studentGender,
    required this.department,
    required this.dateOfBirth,
    required this.rollNo,
    required this.studentAddress,
    required this.studentCollegeName,
    required this.admission,
  });

  factory StudentDetail.fromMap(Map<String, dynamic> map, String documentId) {
    return StudentDetail(
      studentId: documentId,
      studentName: map['studentName'] ?? '',
      studentCollegeEmail: map['studentCollegeEmail'] ?? '',
      studentPersonalEmail: map['studentPersonalEmail'] ?? '',
      studentPhoneNumber: map['studentPhoneNumber'] ?? 0,
      studentGender: map['studentGender'] ?? '',
      department: map['department'] ?? '',
      dateOfBirth: map['dateOfBirth'] ?? Timestamp.now(),
      rollNo: map['rollNo'] ?? '',
      studentAddress: map['studentAddress'] ?? '',
      studentCollegeName: map['studentCollegeName'] ?? '',
      admission: map['admission'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'studentCollegeEmail': studentCollegeEmail,
      'studentPersonalEmail': studentPersonalEmail,
      'studentPhoneNumber': studentPhoneNumber,
      'studentGender': studentGender,
      'department': department,
      'dateOfBirth': dateOfBirth,
      'rollNo': rollNo,
      'studentAddress': studentAddress,
      'studentCollegeName': studentCollegeName,
      'admission': admission,
      'age': _calculateAge(dateOfBirth.toDate()),
    };
  }

  static int _calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}

enum Gender { male, female, other }
