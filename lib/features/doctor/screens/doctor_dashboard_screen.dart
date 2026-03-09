import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorDashboardScreen extends StatefulWidget {
  const DoctorDashboardScreen({super.key});

  @override
  State<DoctorDashboardScreen> createState() =>
      _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  String _doctorName = "Doctor";
  bool _loading = true;

  static const Color _accent = Color(0xFF00C2B2);

  @override
  void initState() {
    super.initState();
    _initDoctor();
  }

  Future<void> _initDoctor() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        setState(() {
          _doctorName = doc.data()?['name'] ?? "Doctor";
          _loading = false;
        });
      } else {
        setState(() => _loading = false);
      }
    }
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  String _todayDate() {
    final now = DateTime.now();
    return "${_weekday(now.weekday)} • ${now.day} ${_month(now.month)} ${now.year}";
  }

  String _weekday(int day) {
    const days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];
    return days[day - 1];
  }

  String _month(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0C1B2A),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// ===== GREETING =====
              Text(
                "${_greeting()}, ${_loading ? "..." : "Dr. $_doctorName"}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                _todayDate(),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 30),

              /// ===== METRICS =====
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.25,
                children: const [
                  _MetricTile(
                    icon: Icons.calendar_month,
                    value: "12",
                    label: "Today's Appointments",
                  ),
                  _MetricTile(
                    icon: Icons.hourglass_bottom,
                    value: "5",
                    label: "Waiting Patients",
                  ),
                  _MetricTile(
                    icon: Icons.check_circle_outline,
                    value: "7",
                    label: "Consultations Done",
                  ),
                  _MetricTile(
                    icon: Icons.warning_amber_outlined,
                    value: "1",
                    label: "Emergency Flags",
                    isAlert: true,
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// ===== PRIMARY ACTION =====
              const Text(
                "Quick Actions",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  letterSpacing: 1.5,
                ),
              ),

              const SizedBox(height: 14),

              _PrimaryActionTile(
                icon: Icons.play_arrow_rounded,
                label: "Start Next Consultation",
              ),

              const SizedBox(height: 12),

              _SecondaryActionTile(
                icon: Icons.description_outlined,
                label: "Review Patient Reports",
              ),

              const SizedBox(height: 30),

              /// ===== NEXT PATIENTS =====
              const Text(
                "Next Patients",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  letterSpacing: 1.5,
                ),
              ),

              const SizedBox(height: 14),

              const _PatientQueueTile(
                token: "12",
                name: "Rahul Sharma",
                age: "34",
                reason: "Gastric Pain",
                time: "10:30 AM",
                status: "Waiting",
              ),

              const _PatientQueueTile(
                token: "13",
                name: "Priya Mehta",
                age: "29",
                reason: "Follow-up Visit",
                time: "10:45 AM",
                status: "Scheduled",
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

/// =========================
/// METRIC TILE
/// =========================

class _MetricTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final bool isAlert;

  const _MetricTile({
    required this.icon,
    required this.value,
    required this.label,
    this.isAlert = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color color =
    isAlert ? Colors.redAccent : const Color(0xFF00C2B2);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
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

/// =========================
/// PRIMARY ACTION
/// =========================

class _PrimaryActionTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const _PrimaryActionTile({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF00C2B2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.play_arrow_rounded,
              color: Colors.black, size: 24),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Icon(Icons.arrow_forward_ios,
              size: 14, color: Colors.black87),
        ],
      ),
    );
  }
}

/// =========================
/// SECONDARY ACTION
/// =========================

class _SecondaryActionTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SecondaryActionTile({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70),
          const SizedBox(width: 14),
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
    );
  }
}

/// =========================
/// PATIENT QUEUE TILE
/// =========================

class _PatientQueueTile extends StatelessWidget {
  final String token;
  final String name;
  final String age;
  final String reason;
  final String time;
  final String status;

  const _PatientQueueTile({
    required this.token,
    required this.name,
    required this.age,
    required this.reason,
    required this.time,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor =
    status == "Waiting" ? Colors.orange : Colors.blueAccent;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [

          /// Token
          Container(
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: statusColor.withOpacity(0.15),
            ),
            child: Text(
              token,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 14),

          /// Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$name ($age)",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  reason,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white60,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$time • $status",
                  style: TextStyle(
                    fontSize: 12,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}