import 'package:flutter/material.dart';
import 'package:mediconnect/services/staff/staff_dashboard_service.dart';

// 🔥 IMPORT TARGET SCREENS
import 'staff_appointments_screen.dart';
import 'staff_reports_screen.dart';
import 'staff_emergency_screen.dart';

class StaffDashboardScreen extends StatefulWidget {
  const StaffDashboardScreen({super.key});

  @override
  State<StaffDashboardScreen> createState() =>
      _StaffDashboardScreenState();
}

class _StaffDashboardScreenState extends State<StaffDashboardScreen> {

  final StaffDashboardService _service =
  StaffDashboardService();

  Map<String, int>? data;

  static const Color _accent = Color(0xFF2979FF);
  static const Color _danger = Color(0xFFE53935);

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    final result = await _service.getDashboardData();
    setState(() => data = result);
  }

  @override
  Widget build(BuildContext context) {

    if (data == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF0C1B2A),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      color: const Color(0xFF0C1B2A),
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => loadData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Text(
                  "Staff Dashboard",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 22),

                /// ===== MAIN STATS =====
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF14283C), Color(0xFF16324F)],
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      _BigStat(
                        value: data!["appointments"].toString(),
                        label: "Appointments",
                      ),
                      _BigStat(
                        value: data!["pendingReports"].toString(),
                        label: "Pending",
                      ),
                      _BigStat(
                        value: data!["completedReports"].toString(),
                        label: "Completed",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                /// ===== EMERGENCY =====
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: _danger.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _danger.withOpacity(0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded,
                          color: _danger, size: 28),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          "${data!["emergencies"]} Active Emergency Alerts",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                /// ===== QUICK ACTIONS =====
                const Text(
                  "Quick Actions",
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 1.3,
                    color: Colors.white54,
                  ),
                ),

                const SizedBox(height: 14),

                /// 🔥 ADD REPORT
                _QuickAction(
                  icon: Icons.add_circle_outline,
                  label: "Add New Report",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const StaffReportsScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                /// 🔥 APPOINTMENTS
                _QuickAction(
                  icon: Icons.event_note_outlined,
                  label: "View Appointments",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const StaffAppointmentsScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                /// 🔥 EMERGENCY
                _QuickAction(
                  icon: Icons.warning_amber,
                  label: "Emergency Panel",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const StaffEmergencyScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ===== BIG STAT =====
class _BigStat extends StatelessWidget {
  final String value;
  final String label;

  const _BigStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}

/// ===== QUICK ACTION =====
class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // 🔥 NAVIGATION
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF14283C),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF2979FF)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                size: 14, color: Colors.white38),
          ],
        ),
      ),
    );
  }
}