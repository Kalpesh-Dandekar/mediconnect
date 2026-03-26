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
  final RelativePatientService _patientService = RelativePatientService();
  final RelativeDashboardService _dashboardService = RelativeDashboardService();

  final TextEditingController _codeController = TextEditingController();

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

      final patient = await _patientService.getPatient(user.uid);

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

    final data = await _dashboardService.getDashboardData(patientId!);

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

              /// ALERT
              if (user != null)
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("notifications")
                      .where("toUserId", isEqualTo: user.uid)
                      .snapshots(),
                  builder: (context, snapshot) {

                    final docs =
                    snapshot.hasData ? snapshot.data!.docs : [];

                    if (docs.isEmpty) return const SizedBox();

                    final hasEmergency = docs.any(
                            (d) => (d["type"] ?? "") == "emergency");

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
                            color: Colors.redAccent.withOpacity(0.4),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.warning,
                                color: Colors.redAccent),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                hasEmergency
                                    ? "🚨 Emergency alert received!"
                                    : "You have ${docs.length} alerts",
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

                const Text(
                  "TODAY",
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 1.4,
                    color: Colors.white54,
                  ),
                ),

                const SizedBox(height: 14),

                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 1.2,
                  children: [
                    _DashboardCard(Icons.medication, "Medication", "$taken / $total"),
                    _DashboardCard(Icons.access_time, "Next Dose", nextDose),
                    _DashboardCard(Icons.event, "Next Visit", nextVisitDate),
                    _DashboardCard(Icons.description, "Reports", reportStatus),
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        children: [

          const Row(
            children: [
              Icon(Icons.link, color: Color(0xFFFFB703)),
              SizedBox(width: 8),
              Text(
                "Connect to Patient",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _inputField(_codeController, "Enter 6-digit code"),

          const SizedBox(height: 14),

          GestureDetector(
            onTap: _connectPatient,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF9F1C), Color(0xFFFFB703)],
                ),
              ),
              alignment: Alignment.center,
              child: isConnecting
                  ? const CircularProgressIndicator(color: Colors.black)
                  : const Text(
                "Connect",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputField(TextEditingController c, String h) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: c,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: h,
          hintStyle: const TextStyle(color: Colors.white38),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _careGuidelines() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("CARE GUIDELINES",
              style: TextStyle(color: Colors.white54)),
          SizedBox(height: 10),
          Text("• Ensure patient takes medicines on time",
              style: TextStyle(color: Colors.white70)),
          Text("• Monitor missed doses regularly",
              style: TextStyle(color: Colors.white70)),
          Text("• Attend scheduled doctor visits",
              style: TextStyle(color: Colors.white70)),
          Text("• Check reports regularly",
              style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}

/// 🔥 UPDATED CARD
class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _DashboardCard(this.icon, this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.tealAccent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.tealAccent, size: 20),
          ),

          const Spacer(),

          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}