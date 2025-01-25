// ignore_for_file: library_private_types_in_public_api, file_names

import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:timeline_tile/timeline_tile.dart';

enum ApplicationStage { applied, screening, interview, offer, rejected }

class ApplicationStatusPage extends StatefulWidget {
  const ApplicationStatusPage({super.key});

  @override
  _ApplicationStatusPageState createState() => _ApplicationStatusPageState();
}

class _ApplicationStatusPageState extends State<ApplicationStatusPage> {
  final List<ApplicationStatus> _applications = [
    ApplicationStatus(
      company: 'Google',
      position: 'Software Engineer',
      currentStage: ApplicationStage.interview,
      stages: [
        ApplicationStageDetail(
          stage: ApplicationStage.applied,
          date: DateTime(2024, 1, 15),
          status: 'Application Submitted',
        ),
        ApplicationStageDetail(
          stage: ApplicationStage.screening,
          date: DateTime(2024, 1, 22),
          status: 'Initial Screening Passed',
        ),
        ApplicationStageDetail(
          stage: ApplicationStage.interview,
          date: DateTime(2024, 2, 5),
          status: 'Technical Interview Scheduled',
        ),
      ],
    ),
    ApplicationStatus(
      company: 'Microsoft',
      position: 'Cloud Architect',
      currentStage: ApplicationStage.screening,
      stages: [
        ApplicationStageDetail(
          stage: ApplicationStage.applied,
          date: DateTime(2024, 2, 10),
          status: 'Application Submitted',
        ),
        ApplicationStageDetail(
          stage: ApplicationStage.screening,
          date: DateTime(2024, 2, 18),
          status: 'Resume Under Review',
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Status'),
        backgroundColor: Colors.deepPurple.shade900,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.shade900,
              Colors.black,
            ],
          ),
        ),
        child: ListView.builder(
          itemCount: _applications.length,
          itemBuilder: (context, index) {
            var application = _applications[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GlassmorphicContainer(
                width: double.infinity,
                height: 300,
                borderRadius: 20,
                blur: 20,
                alignment: Alignment.bottomCenter,
                border: 2,
                linearGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
                borderGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.5),
                    Colors.white.withOpacity(0.1),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        application.company,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        application.position,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Column(
                        children: application.stages.map((stage) {
                          return TimelineTile(
                            alignment: TimelineAlign.start,
                            indicatorStyle: IndicatorStyle(
                              width: 20,
                              color: _getStageColor(stage.stage),
                            ),
                            beforeLineStyle: LineStyle(
                              color: _getStageColor(stage.stage),
                            ),
                            endChild: Container(
                              padding: const EdgeInsets.all(8.0),
                              margin: const EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    stage.status,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    stage.date.toString().split(' ')[0],
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Color _getStageColor(ApplicationStage stage) {
    switch (stage) {
      case ApplicationStage.applied:
        return Colors.blue;
      case ApplicationStage.screening:
        return Colors.yellow;
      case ApplicationStage.interview:
        return Colors.orange;
      case ApplicationStage.offer:
        return Colors.green;
      case ApplicationStage.rejected:
        return Colors.red;
    }
  }
}

class ApplicationStatus {
  final String company;
  final String position;
  final ApplicationStage currentStage;
  final List<ApplicationStageDetail> stages;

  ApplicationStatus({
    required this.company,
    required this.position,
    required this.currentStage,
    required this.stages,
  });
}

class ApplicationStageDetail {
  final ApplicationStage stage;
  final DateTime date;
  final String status;

  ApplicationStageDetail({
    required this.stage,
    required this.date,
    required this.status,
  });
}
