import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mediconnect/services/relative/relative_link_service.dart';
import 'package:mediconnect/services/relative/relative_patient_service.dart';
import 'package:mediconnect/services/relative/relative_dashboard_service.dart';
import 'package:mediconnect/features/relative/screens/relative_notifications_screen.dart';

class RelativeDashboardScreen extends StatefulWidget {
  const RelativeDashboardScreen({super.key});

  @override
  State<RelativeDashboardScreen> createState() =>
      _RelativeDashboardScreenState();
}

class _RelativeDashboardScreenState
    extends State<RelativeDashboardScreen> {

  final RelativeLinkService _linkService = RelativeLinkService();
  final RelativePatientService _patientService =
  RelativePatientService();
  final RelativeDashboardService _dashboardService =
  RelativeDashboardService();

  final TextEditingController _codeController =
  TextEditingController();

  bool isConnecting = false;
  bool isLinked = false;
  bool loading = true;

  String patientName = "Not Connected";
  String? patientId;

  int taken = 0;
  int total = 0;
  String nextDose = "--";
  String nextVisitDate = "--";
  String nextVisitDoctor = "";
  String reportStatus = "--";

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        setState(() => loading = false);
        return;
      }

      final patient =
      await _patientService.getPatient(user.uid);

      if (patient != null) {
        patientId = patient['id'];
        patientName = patient['name'] ?? "Patient";
        isLinked = true;

        await _loadDashboard();
      } else {
        isLinked = false;
      }

    } catch (e) {
      print("Init error: $e");
    }

    setState(() => loading = false);
  }

  Future<void> _loadDashboard() async {
    if (patientId == null) return;

    final data =
    await _dashboardService.getDashboardData(patientId!);

    setState(() {
      taken = data["taken"];
      total = data["total"];
      nextDose = data["nextDose"];
      nextVisitDate = data["nextVisitDate"];
      nextVisitDoctor = data["nextVisitDoctor"];
      reportStatus = data["reportStatus"];
    });
  }

  Future<void> _connectPatient() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final code = _codeController.text.trim();

    if (code.isEmpty) return;

    setState(() => isConnecting = true);

    try {
      await _linkService.connectToPatient(
        code: code,
        relativeId: user.uid,
      );

      await _init();

    } catch (e) {
      print(e);
    }

    setState(() => isConnecting = false);
  }

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;

    if (loading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0C1B2A),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0C1B2A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

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
                isLinked
                    ? "Monitoring: $patientName"
                    : "No patient connected",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),

              const SizedBox(height: 20),

              /// 🔥 UPDATED ALERT CARD
              if (user != null)
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("notifications")
                      .where("toUserId", isEqualTo: user.uid)
                      .snapshots(),
                  builder: (context, snapshot) {

                    final docs =
                    snapshot.hasData ? snapshot.data!.docs : [];

                    final count = docs.length;

                    if (count == 0) return const SizedBox();

                    final hasEmergency = docs.any((d) =>
                    (d["type"] ?? "") == "emergency");

                    final message = hasEmergency
                        ? "🚨 Emergency alert received!"
                        : "You have $count medication alerts";

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                            const RelativeNotificationsScreen(),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: Colors.redAccent.withOpacity(0.4)),
                        ),
                        child: Row(
                          children: [

                            const Icon(Icons.warning,
                                color: Colors.redAccent),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Text(
                                message,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),

                            const Icon(Icons.arrow_forward_ios,
                                color: Colors.white54, size: 16),
                          ],
                        ),
                      ),
                    );
                  },
                ),

              if (!isLinked) _connectCard(),

              if (isLinked) ...[
                const SizedBox(height: 10),

                Text(
                  "Today's Summary",
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 1.2,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),

                const SizedBox(height: 14),

                if (total == 0)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Text(
                        "No health data available",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),

                if (total > 0)
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.25,
                    children: [
                      _DashboardCard(
                        icon: Icons.medication_outlined,
                        title: "Medication",
                        value: "$taken / $total",
                        subtitle: "$taken taken",
                      ),
                      _DashboardCard(
                        icon: Icons.access_time,
                        title: "Next Dose",
                        value: nextDose,
                        subtitle: "",
                      ),
                      _DashboardCard(
                        icon: Icons.event,
                        title: "Next Visit",
                        value: nextVisitDate,
                        subtitle: nextVisitDoctor,
                      ),
                      _DashboardCard(
                        icon: Icons.description_outlined,
                        title: "Reports",
                        value: reportStatus == "pending"
                            ? "Pending"
                            : "Available",
                        subtitle: "",
                      ),
                    ],
                  ),

                const SizedBox(height: 30),

                _careGuidelines(),
              ],

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _connectCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1F3B5C), Color(0xFF14283C)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [

          const Row(
            children: [
              Icon(Icons.link, color: Colors.tealAccent),
              SizedBox(width: 8),
              Text(
                "Connect to Patient",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          TextField(
            controller: _codeController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Enter 6-digit code",
              hintStyle:
              TextStyle(color: Colors.white.withOpacity(0.5)),
              filled: true,
              fillColor: Colors.black.withOpacity(0.3),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isConnecting ? null : _connectPatient,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent,
                foregroundColor: Colors.black,
              ),
              child: isConnecting
                  ? const CircularProgressIndicator()
                  : const Text("Connect"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _careGuidelines() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF14283C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Row(
            children: [
              Icon(Icons.health_and_safety,
                  color: Colors.tealAccent, size: 18),
              SizedBox(width: 8),
              Text(
                "Care Guidelines",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _guideline("Ensure patient takes medicines on time"),
          _guideline("Monitor missed doses regularly"),
          _guideline("Attend scheduled doctor visits"),
          _guideline("Check reports for updates"),
          _guideline("Watch for unusual symptoms"),
        ],
      ),
    );
  }

  Widget _guideline(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ",
              style: TextStyle(color: Colors.tealAccent)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Icon(icon, size: 18, color: Colors.tealAccent),

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