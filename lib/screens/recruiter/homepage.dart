import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecruiterDashboard extends StatefulWidget {
  const RecruiterDashboard({super.key});

  @override
  State<RecruiterDashboard> createState() => _RecruiterDashboardState();
}

class _RecruiterDashboardState extends State<RecruiterDashboard> {
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _jobDescriptionController =
      TextEditingController();
  final TextEditingController _jobRoleController = TextEditingController();
  final TextEditingController _jobTypeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();

  void logOut() async {
    // Example logout function
    Navigator.pushNamed(context, '/login');
    print("Logged Out");
  }

  Future<void> _addJob() async {
    final jobTitle = _jobTitleController.text.trim();
    final jobDescription = _jobDescriptionController.text.trim();
    final jobRole = _jobRoleController.text.trim();
    final jobType = _jobTypeController.text.trim();
    final location = _locationController.text.trim();
    final company = _companyController.text.trim();
    final salary = _salaryController.text.trim();
    final deadline = _deadlineController.text.trim();

    if (jobTitle.isNotEmpty && jobDescription.isNotEmpty) {
      await FirebaseFirestore.instance.collection('jobs').add({
        'title': jobTitle,
        'description': jobDescription,
        'role': jobRole,
        'type': jobType,
        'location': location,
        'company': company,
        'salary': salary,
        'deadline': deadline,
        'createdAt': FieldValue.serverTimestamp(),
      });

      _jobTitleController.clear();
      _jobDescriptionController.clear();
      _jobRoleController.clear();
      _jobTypeController.clear();
      _locationController.clear();
      _companyController.clear();
      _salaryController.clear();
      _deadlineController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Job added successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recruiter Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logOut,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Job Listings",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () => _showAddJobDialog(),
                  child: const Text("Add Job"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('jobs')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No jobs available."));
                  }

                  final jobs = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: jobs.length,
                    itemBuilder: (context, index) {
                      final job = jobs[index];
                      final jobId = job.id;
                      final jobTitle = job['title'];

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(jobTitle),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('jobs')
                                  .doc(jobId)
                                  .delete();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Job deleted successfully!')),
                              );
                            },
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => JobApplicationsPage(
                                    jobId: jobId, jobTitle: jobTitle),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddJobDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Job"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _jobTitleController,
                  decoration: const InputDecoration(labelText: "Job Title"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _jobDescriptionController,
                  decoration:
                      const InputDecoration(labelText: "Job Description"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _jobRoleController,
                  decoration: const InputDecoration(labelText: "Job Role"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _jobTypeController,
                  decoration: const InputDecoration(labelText: "Job Type"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: "Location"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _companyController,
                  decoration: const InputDecoration(labelText: "Company"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _salaryController,
                  decoration: const InputDecoration(labelText: "Salary"),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _deadlineController,
                        decoration: const InputDecoration(
                            labelText: "Application Deadline"),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _deadlineController.text =
                                  pickedDate.toLocal().toString().split(' ')[0];
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                _addJob();
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
}

class JobApplicationsPage extends StatelessWidget {
  final String jobId;
  final String jobTitle;

  const JobApplicationsPage({
    super.key,
    required this.jobId,
    required this.jobTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Applications for $jobTitle"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('applications')
            .where('jobId', isEqualTo: jobId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No applications found."));
          }

          final applications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: applications.length,
            itemBuilder: (context, index) {
              final application = applications[index];
              final applicantName = application['applicantName'];
              final applicantEmail = application['applicantEmail'];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(applicantName),
                  subtitle: Text(applicantEmail),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
