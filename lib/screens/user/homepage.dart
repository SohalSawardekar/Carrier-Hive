// ignore_for_file: library_private_types_in_public_api

import 'package:carrier_hive/screens/profileMangement.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  final String currentStudentId = '9LMIb4MVYySx16sRaW90';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<DashboardCard> _dashboardCards = [
      DashboardCard(
        title: 'Jobs',
        icon: Icons.work,
        color: Colors.blue.shade400,
        onTap: (context, _) {
          Navigator.pushNamed(context, '/user/dashboard/Jobs');
        },
      ),
      DashboardCard(
        title: 'Placements',
        icon: Icons.work,
        color: Colors.green.shade400,
        onTap: (context, _) {
          // Navigate to Placements page
        },
      ),
      DashboardCard(
        title: 'applications',
        icon: Icons.document_scanner,
        color: Colors.purple.shade400,
        onTap: (context, _) {
          Navigator.pushNamed(context, '/user/dashboard/applications');
        },
      ),
      DashboardCard(
        title: 'Profile',
        icon: Icons.account_circle,
        color: Colors.orange.shade400,
        onTap: (context, currentStudentId) {
          print(currentStudentId);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileManagementPage(
                StudentId: currentStudentId ?? '9LMIb4MVYySx16sRaW90',
              ),
            ),
          );
        },
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Animated Background
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.lerp(Colors.deepPurple.shade900, Colors.black,
                          _animationController.value)!,
                      Color.lerp(Colors.black, Colors.deepPurple.shade900,
                          _animationController.value)!,
                    ],
                  ),
                ),
              );
            },
          ),

          // Main Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Bar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome, Student',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          Text(
                            'Campus Connect Dashboard',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications,
                            color: Colors.white),
                        onPressed: () {
                          // Navigate to Notifications
                        },
                      ),
                    ],
                  ),
                ),

                // Quick Stats
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GlassmorphicContainer(
                    width: double.infinity,
                    height: 120,
                    borderRadius: 20,
                    blur: 20,
                    alignment: Alignment.center,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildQuickStat('GPA', '8.5'),
                        _buildQuickStat('Attendance', '92%'),
                        _buildQuickStat('Credits', '45/120'),
                      ],
                    ),
                  ),
                ),

                // Dashboard Cards
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: _dashboardCards.length,
                      itemBuilder: (context, index) {
                        return _dashboardCards[index];
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(String label, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final void Function(BuildContext, String? currentStudentId) onTap;

  const DashboardCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          onTap(context, null), // Pass null if currentStudentId is not used
      child: GlassmorphicContainer(
        width: double.infinity,
        height: double.infinity,
        borderRadius: 20,
        blur: 20,
        alignment: Alignment.center,
        border: 2,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.3),
            color.withOpacity(0.1),
          ],
        ),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.5),
            color.withOpacity(0.1),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
