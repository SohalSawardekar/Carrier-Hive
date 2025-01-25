class JobApplications {
  final String id;
  final String jobId;
  final String applicantId;
  final String applicantName;
  final String resumeUrl;
  final String coverLetter;
  final DateTime applicationDate;
  final String status;

  JobApplications({
    required this.id,
    required this.jobId,
    required this.applicantId,
    required this.applicantName,
    required this.resumeUrl,
    required this.coverLetter,
    required this.applicationDate,
    this.status = 'Pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jobId': jobId,
      'applicantId': applicantId,
      'applicantName': applicantName,
      'resumeUrl': resumeUrl,
      'coverLetter': coverLetter,
      'applicationDate': applicationDate.toIso8601String(),
      'status': status,
    };
  }

  factory JobApplications.fromMap(Map<String, dynamic> map, String documentId) {
    return JobApplications(
      id: documentId,
      jobId: map['jobId'] ?? '',
      applicantId: map['applicantId'] ?? '',
      applicantName: map['applicantName'] ?? '',
      resumeUrl: map['resumeUrl'] ?? '',
      coverLetter: map['coverLetter'] ?? '',
      applicationDate: DateTime.parse(map['applicationDate']),
      status: map['status'] ?? 'Pending',
    );
  }

  JobApplications copyWith({
    String? id,
    String? jobId,
    String? applicantId,
    String? applicantName,
    String? resumeUrl,
    String? coverLetter,
    DateTime? applicationDate,
    String? status,
  }) {
    return JobApplications(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      applicantId: applicantId ?? this.applicantId,
      applicantName: applicantName ?? this.applicantName,
      resumeUrl: resumeUrl ?? this.resumeUrl,
      coverLetter: coverLetter ?? this.coverLetter,
      applicationDate: applicationDate ?? this.applicationDate,
      status: status ?? this.status,
    );
  }

  bool isPending() {
    return status == 'Pending';
  }

  bool isAccepted() {
    return status == 'Accepted';
  }

  bool isRejected() {
    return status == 'Rejected';
  }
}
