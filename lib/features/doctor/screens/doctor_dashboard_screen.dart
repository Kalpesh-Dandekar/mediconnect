import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../services/doctor/dashboard_service.dart';
import '../../doctor/screens/consultation_screen.dart';
import '../../doctor/screens/view_reports_screen.dart';

class DoctorDashboardScreen extends StatefulWidget {
  const DoctorDashboardScreen({super.key});

  @override
  State<DoctorDashboardScreen> createState() =>
      _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState
    extends State<DoctorDashboardScreen> {

  String _doctorName = "Doctor";
  bool _loading = true;

  final DoctorDashboardService dashboardService =
  DoctorDashboardService();

  int totalAppointments = 0;
  int waitingPatients = 0;
  int consultationsDone = 0;
  int emergencyCount = 0;

  Map<String, dynamic>? nextPatient;
  String? nextAppointmentId;

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
        _doctorName = doc.data()?['name'] ?? "Doctor";
      }

      await _loadDashboard();
    }

    if (mounted) {
      setState(() => _loading = false);
    }
  }

  Future<void> _loadDashboard() async {
    try {
      final data = await dashboardService.getDashboardData();

      if (!mounted) return;

      setState(() {
        totalAppointments = data["total"] ?? 0;
        waitingPatients = data["waiting"] ?? 0;
        consultationsDone = data["done"] ?? 0;
        emergencyCount = data["emergency"] ?? 0;
      });

    } catch (e) {
      print("Dashboard error: $e");
    }
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF0C1B2A),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadDashboard,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// HEADER
                Text(
                  "${_greeting()}, ${_loading ? "..." : "Dr. $_doctorName"}",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 25),

                /// METRICS
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.25,
                  children: [
                    _MetricTile(
                      icon: Icons.calendar_month,
                      value: "$totalAppointments",
                      label: "Today's Appointments",
                    ),
                    _MetricTile(
                      icon: Icons.hourglass_bottom,
                      value: "$waitingPatients",
                      label: "Waiting Patients",
                    ),
                    _MetricTile(
                      icon: Icons.check_circle_outline,
                      value: "$consultationsDone",
                      label: "Consultations Done",
                    ),
                    _MetricTile(
                      icon: Icons.warning_amber_outlined,
                      value: "$emergencyCount",
                      label: "Emergency Flags",
                      isAlert: true,
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                /// QUICK ACTIONS
                const Text(
                  "Quick Actions",
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 12),

                GestureDetector(
                  onTap: () {
                    if (nextPatient == null ||
                        nextAppointmentId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("No patient available")),
                      );
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ConsultationScreen(
                          patientId:
                          nextPatient!["patientId"] ?? "",
                          patientName:
                          nextPatient!["patientName"] ??
                              "Patient",
                          appointmentId: nextAppointmentId!,
                        ),
                      ),
                    );
                  },
                  child: const _PrimaryActionTile(
                    icon: Icons.play_arrow,
                    label: "Start Consultation",
                  ),
                ),

                const SizedBox(height: 10),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const ViewReportsScreen(),
                      ),
                    );
                  },
                  child: const _SecondaryActionTile(
                    icon: Icons.description,
                    label: "Review Reports",
                  ),
                ),

                const SizedBox(height: 30),

                /// NEXT PATIENTS
                const Text(
                  "Next Patients",
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 12),

                StreamBuilder<QuerySnapshot>(
                  stream: dashboardService.getNextPatients(),
                  builder: (context, snapshot) {

                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return const Text(
                        "No upcoming patients",
                        style: TextStyle(color: Colors.white54),
                      );
                    }

                    final docs = snapshot.data!.docs;

                    nextPatient =
                    docs.first.data() as Map<String, dynamic>;
                    nextAppointmentId = docs.first.id;

                    return Column(
                      children: docs.map<Widget>((doc) {

                        final data =
                        doc.data() as Map<String, dynamic>;

                        final ts = data["date"] as Timestamp?;
                        final dt = ts?.toDate();

                        return _PatientQueueTile(
                          token: (data["token"] ?? "").toString(),
                          name: data["patientName"] ?? "",
                          age: (data["age"] ?? "").toString(),
                          reason: data["department"] ?? "",
                          time: dt != null
                              ? "${dt.hour}:${dt.minute.toString().padLeft(2, '0')}"
                              : "--",
                          status: data["status"] ?? "",
                        );

                      }).toList(),
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

/// ================= WIDGETS =================

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

    final color =
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
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF00C2B2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

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

    final color =
    status.toLowerCase() == "waiting"
        ? Colors.orange
        : Colors.blueAccent;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            child: Text(
              token,
              style: TextStyle(color: color),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(name,
                    style:
                    const TextStyle(color: Colors.white)),
                Text(reason,
                    style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12)),
                Text("$time • $status",
                    style: TextStyle(
                        color: color, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}