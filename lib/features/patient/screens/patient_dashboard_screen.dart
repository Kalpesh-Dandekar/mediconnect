import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'patient_profile_screen.dart';
import 'package:mediconnect/services/patient/patient_link_service.dart';

class PatientDashboardScreen extends StatefulWidget {
  const PatientDashboardScreen({super.key});

  @override
  State<PatientDashboardScreen> createState() =>
      _PatientDashboardScreenState();
}

class _PatientDashboardScreenState extends State<PatientDashboardScreen> {

  final PatientLinkService _linkService = PatientLinkService();

  String _userName = "Patient";

  String lastVisitDate = "--";
  String lastVisitDoctor = "";

  String nextVisitDate = "--";
  String nextVisitDept = "";

  int takenDoses = 0;
  int totalDoses = 0;

  String latestReportName = "--";
  String latestReportDate = "--";
  String latestReportStatus = "--";

  bool _loading = true;

  String linkCode = "";

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _generateLinkCode() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final code = await _linkService.generateAndSaveCode(user.uid);

    setState(() {
      linkCode = code;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Link code generated")),
    );
  }

  Future<void> _loadDashboard() async {

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final uid = user.uid;

    try {

      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get();

      final existingCode = await _linkService.getLinkCode(uid);

      final lastVisitSnap = await FirebaseFirestore.instance
          .collection("appointments")
          .where("patientId", isEqualTo: uid)
          .orderBy("date", descending: true)
          .limit(1)
          .get();

      final nextVisitSnap = await FirebaseFirestore.instance
          .collection("appointments")
          .where("patientId", isEqualTo: uid)
          .where("date", isGreaterThan: Timestamp.now())
          .orderBy("date")
          .limit(1)
          .get();

      final meds = await FirebaseFirestore.instance
          .collection("medicines")
          .where("patientId", isEqualTo: uid)
          .get();

      final reports = await FirebaseFirestore.instance
          .collection("reports")
          .where("patientId", isEqualTo: uid)
          .orderBy("createdAt", descending: true)
          .limit(1)
          .get();

      setState(() {

        _userName = userDoc.data()?["name"] ?? "Patient";
        linkCode = existingCode ?? "";

        if (lastVisitSnap.docs.isNotEmpty) {
          final d = lastVisitSnap.docs.first.data();
          final dt = (d["date"] as Timestamp?)?.toDate();
          lastVisitDate =
          dt != null ? "${dt.day}/${dt.month}/${dt.year}" : "--";
          lastVisitDoctor = d["doctorName"] ?? "";
        }

        if (nextVisitSnap.docs.isNotEmpty) {
          final d = nextVisitSnap.docs.first.data();
          final dt = (d["date"] as Timestamp?)?.toDate();
          nextVisitDate =
          dt != null ? "${dt.day}/${dt.month}/${dt.year}" : "--";
          nextVisitDept = d["department"] ?? "";
        }

        totalDoses = meds.docs.length;
        takenDoses = meds.docs.where((d) =>
        (d.data()["status"] ?? "").toString().toLowerCase() == "taken").length;

        if (reports.docs.isNotEmpty) {
          final d = reports.docs.first.data();
          latestReportName = d["testName"] ?? "--";
          latestReportDate = d["uploadedOn"] ?? "--";
          latestReportStatus = d["resultStatus"] ?? "--";
        }

        _loading = false;
      });

    } catch (e) {}
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return "Good Morning";
    if (h < 17) return "Good Afternoon";
    return "Good Evening";
  }

  @override
  Widget build(BuildContext context) {

    final initials =
    _userName.isNotEmpty ? _userName[0].toUpperCase() : "P";

    return Container(
      color: const Color(0xFF0C1B2A),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${_greeting()}, ${_loading ? "..." : _userName}",
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Patient Dashboard",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// ✅ FIXED PROFILE NAVIGATION
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PatientProfileScreen(),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor:
                      const Color(0xFFFFB703).withOpacity(0.2),
                      child: Text(
                        initials,
                        style: const TextStyle(
                          color: Color(0xFFFFB703),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// LINK CARD
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withOpacity(0.05),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.08)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Row(
                      children: [
                        Icon(Icons.link,
                            color: Color(0xFFFFB703)),
                        SizedBox(width: 8),
                        Text(
                          "Connect a Relative",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Text(
                      linkCode.isEmpty
                          ? "Generate a secure code"
                          : "Share this code:",
                      style: const TextStyle(
                        color: Colors.white60,
                      ),
                    ),

                    const SizedBox(height: 12),

                    if (linkCode.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          linkCode,
                          style: const TextStyle(
                            color: Color(0xFFFFB703),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ),

                    const SizedBox(height: 14),

                    GestureDetector(
                      onTap: _generateLinkCode,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFFF9F1C),
                              Color(0xFFFFB703),
                            ],
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "Generate Code",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// GRID
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.15,
                children: [
                  _SummaryCard(Icons.local_hospital_outlined, "Last Visit", lastVisitDate, lastVisitDoctor),
                  _SummaryCard(Icons.medication_outlined, "Medication", "$takenDoses / $totalDoses", "$takenDoses taken"),
                  _SummaryCard(Icons.event_available_outlined, "Next Visit", nextVisitDate, nextVisitDept),
                  _SummaryCard(Icons.receipt_long_outlined, "Reports", latestReportStatus, latestReportName),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

/// CARD
class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;

  const _SummaryCard(this.icon, this.title, this.value, this.subtitle);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white.withOpacity(0.04),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
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
            child: Icon(icon, size: 16, color: Colors.tealAccent),
          ),

          const Spacer(),

          Text(value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),

          Text(title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, color: Colors.white70)),

          Text(subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10, color: Colors.white54)),
        ],
      ),
    );
  }
}