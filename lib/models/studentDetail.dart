// ignore_for_file: non_constant_identifier_names, file_names

class StudentDetail {
  final String studentId;
  final String studentName;
  final String studentCollegeEmail;
  final String studentPersonalEmail;
  final int studentPhoneNumber;
  final Gender studentGender;
  final String department;
  final DateTime dateOfBirth;
  final String rollNo;
  final String studentAddress;
  final String studentCollegeName;
  final DateTime admission;

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
      studentName: map['studentName'] as String,
      studentCollegeEmail: map['studentCollegeEmail'] as String,
      studentPersonalEmail: map['studentPersonalEmail'] as String,
      studentPhoneNumber: map['studentPhoneNumber'] as int,
      studentGender: Gender.values.firstWhere(
          (e) => e.toString() == 'Gender.${map['studentGender'] as String}'),
      department: map['department'] as String,
      dateOfBirth: DateTime.parse(map['dateOfBirth'] as String),
      rollNo: map['rollNo'] as String,
      studentAddress: map['studentAddress'] as String,
      studentCollegeName: map['studentCollegeName'] as String,
      admission: DateTime.parse(map['admission'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'studentCollegeEmail': studentCollegeEmail,
      'studentPersonalEmail': studentPersonalEmail,
      'studentPhoneNumber': studentPhoneNumber,
      'studentGender': studentGender.toString().split('.').last,
      'department': department,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'rollNo': rollNo,
      'studentAddress': studentAddress,
      'studentCollegeName': studentCollegeName,
      'admission': admission.toIso8601String(),
      'age': (DateTime.now().year - dateOfBirth.year) -
          ((DateTime.now().month < dateOfBirth.month ||
                  (DateTime.now().month == dateOfBirth.month &&
                      DateTime.now().day < dateOfBirth.day))
              ? 1
              : 0),
    };
  }
}

enum Gender { male, female, other }
