class Jobs {
  final String id;
  final String jobTitle;
  final String jobDescription;
  final String jobRole;
  final String jobType;
  final String location;
  final String company;
  final int salary;
  final bool isAvailable;
  final DateTime deadline;

  Jobs({
    required this.id,
    required this.jobTitle,
    required this.jobDescription,
    required this.jobRole,
    required this.jobType,
    required this.location,
    required this.company,
    required this.salary,
    required this.deadline,
    this.isAvailable = true,
  }) {
    if (salary < 0) {
      throw ArgumentError('Salary cannot be negative');
    }
    if (deadline.isBefore(DateTime.now())) {
      throw ArgumentError('Deadline cannot be in the past');
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jobTitle': jobTitle,
      'jobDescription': jobDescription,
      'jobRole': jobRole,
      'jobType': jobType,
      'location': location,
      'company': company,
      'salary': salary,
      'isAvailable': isAvailable,
      'deadline': deadline.toIso8601String(),
    };
  }

  factory Jobs.fromMap(Map<String, dynamic> map) {
    return Jobs(
      id: map['id'],
      jobTitle: map['jobTitle'],
      jobDescription: map['jobDescription'],
      jobRole: map['jobRole'],
      jobType: map['jobType'],
      location: map['location'],
      company: map['company'],
      salary: map['salary'],
      isAvailable: map['isAvailable'] ?? true,
      deadline: DateTime.parse(map['deadline']),
    );
  }
}
