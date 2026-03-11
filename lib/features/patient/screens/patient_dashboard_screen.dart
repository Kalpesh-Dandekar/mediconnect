import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'patient_profile_screen.dart';
import '../../../dev/seed_database.dart';

class PatientDashboardScreen extends StatefulWidget {
  const PatientDashboardScreen({super.key});

  @override
  State<PatientDashboardScreen> createState() =>
      _PatientDashboardScreenState();
}

class _PatientDashboardScreenState extends State<PatientDashboardScreen> {

  String _userName = "Patient";

  String lastVisitDate = "--";
  String lastVisitDoctor = "";

  String nextVisitDate = "--";
  String nextVisitDept = "";

  int takenDoses = 0;
  int totalDoses = 0;

  String reportStatus = "None";

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final uid = user.uid;

    try {

      /// USER NAME
      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get();

      if (userDoc.exists) {
        _userName = userDoc.data()?["name"] ?? "Patient";
      }

      /// LAST VISIT
      final lastVisitSnap = await FirebaseFirestore.instance
          .collection("appointments")
          .where("patientId", isEqualTo: uid)
          .orderBy("date", descending: true)
          .limit(1)
          .get();

      print("Last visit docs: ${lastVisitSnap.docs.length}");

      if (lastVisitSnap.docs.isNotEmpty) {

        final data = lastVisitSnap.docs.first.data();

        if (data["date"] != null) {

          final Timestamp ts = data["date"];
          final DateTime dt = ts.toDate();

          lastVisitDate = "${dt.day}/${dt.month}/${dt.year}";
        }

        lastVisitDoctor = data["doctorName"] ?? "";
      }

      /// NEXT VISIT
      final nextVisitSnap = await FirebaseFirestore.instance
          .collection("appointments")
          .where("patientId", isEqualTo: uid)
          .where("date", isGreaterThan: Timestamp.now())
          .orderBy("date")
          .limit(1)
          .get();

      print("Next visit docs: ${nextVisitSnap.docs.length}");

      if (nextVisitSnap.docs.isNotEmpty) {

        final data = nextVisitSnap.docs.first.data();

        if (data["date"] != null) {

          final Timestamp ts = data["date"];
          final DateTime dt = ts.toDate();

          nextVisitDate = "${dt.day}/${dt.month}/${dt.year}";
        }

        nextVisitDept = data["department"] ?? "";
      }

      /// MEDICINES
      final meds = await FirebaseFirestore.instance
          .collection("medicines")
          .where("patientId", isEqualTo: uid)
          .get();

      print("Medicines found: ${meds.docs.length}");

      totalDoses = meds.docs.length;

      takenDoses = meds.docs
          .where((d) =>
      (d.data()["status"] ?? "")
          .toString()
          .toLowerCase() == "taken")
          .length;

      /// REPORTS
      final reports = await FirebaseFirestore.instance
          .collection("reports")
          .where("patientId", isEqualTo: uid)
          .get();

      reportStatus =
      reports.docs.isEmpty ? "None" : "${reports.docs.length} Reports";

    } catch (e) {

      print("Dashboard error: $e");
    }

    if (mounted) {

      setState(() {

        _loading = false;

      });
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

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const PatientProfileScreen(),
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

              const SizedBox(height: 12),

              /// TEMPORARY SEED BUTTON
              ElevatedButton(
                onPressed: () async {

                  await SeedDatabase.run();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Database Seeded")),
                  );

                  _loadDashboard();
                },
                child: const Text("Run Seed"),
              ),

              const SizedBox(height: 24),

              /// SUMMARY GRID
              GridView.count(
                shrinkWrap: true,
                physics:
                const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.35,
                children: [

                  _SummaryCard(
                    icon: Icons.local_hospital_outlined,
                    title: "Last Visit",
                    value: lastVisitDate,
                    subtitle: lastVisitDoctor,
                  ),

                  _SummaryCard(
                    icon: Icons.medication_outlined,
                    title: "Medication",
                    value: "$takenDoses / $totalDoses",
                    subtitle: "Doses today",
                  ),

                  _SummaryCard(
                    icon: Icons.event_available_outlined,
                    title: "Next Visit",
                    value: nextVisitDate,
                    subtitle: nextVisitDept,
                  ),

                  _SummaryCard(
                    icon: Icons.receipt_long_outlined,
                    title: "Reports",
                    value: reportStatus,
                    subtitle: "Lab status",
                  ),
                ],
              ),

              const SizedBox(height: 26),

              _sectionTitle("Medication Progress"),
              const SizedBox(height: 12),
              _medicationCard(),

              const SizedBox(height: 28),

              _sectionTitle("Latest Lab Report"),
              const SizedBox(height: 12),
              _reportCard(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        letterSpacing: 1.1,
        color: Colors.white.withOpacity(0.6),
      ),
    );
  }

  Widget _medicationCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF13273B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Text(
        "$takenDoses of $totalDoses doses completed today",
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _reportCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF14283C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Text(
        reportStatus,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {

  final IconData icon;
  final String title;
  final String value;
  final String subtitle;

  const _SummaryCard({
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
        border: Border.all(color: Colors.white.withOpacity(0.05)),
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
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
                fontSize: 11,
                color: Colors.white70),
          ),
          Text(
            subtitle,
            style: const TextStyle(
                fontSize: 10,
                color: Colors.white54),
          ),
        ],
      ),
    );
  }
}