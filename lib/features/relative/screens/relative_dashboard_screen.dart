import 'package:flutter/material.dart';

class RelativeDashboardScreen extends StatelessWidget {
  const RelativeDashboardScreen({super.key});

  static const Color _accent = Color(0xFF8E44AD);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C1B2A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// ================= HEADER =================
              const Text(
                "Care Overview",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                "Monitoring: Rahul Sharma",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),

              const SizedBox(height: 26),

              /// ================= GRID =================
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.25,
                children: const [
                  _DashboardCard(
                    icon: Icons.medication_outlined,
                    title: "Medication",
                    value: "2 / 3",
                    subtitle: "Taken Today",
                  ),
                  _DashboardCard(
                    icon: Icons.access_time,
                    title: "Next Dose",
                    value: "8:00 PM",
                    subtitle: "Pantoprazole",
                  ),
                  _DashboardCard(
                    icon: Icons.event,
                    title: "Next Visit",
                    value: "12 Apr",
                    subtitle: "Dr. Smith",
                  ),
                  _DashboardCard(
                    icon: Icons.description_outlined,
                    title: "Reports",
                    value: "1 Pending",
                    subtitle: "Lab Processing",
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// ================= ALERT SECTION =================
              Text(
                "Alerts",
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 1.2,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),

              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.orange.withOpacity(0.3),
                  ),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        color: Colors.orange),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "1 dose was missed yesterday.\nPlease check medication adherence.",
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 13,
                        ),
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 25),

              /// ================= ADHERENCE PROGRESS =================
              Text(
                "Weekly Adherence",
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 1.2,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),

              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF14283C),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "Adherence Rate",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 12),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: 0.75,
                        minHeight: 6,
                        backgroundColor: Colors.white10,
                        color: _accent,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "75% adherence this week",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ================= DASHBOARD CARD =================

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF14283C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Icon(icon,
              size: 18,
              color: const Color(0xFF8E44AD)),

          const Spacer(),

          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),

          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}