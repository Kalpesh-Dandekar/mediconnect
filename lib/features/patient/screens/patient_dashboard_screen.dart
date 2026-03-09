import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'patient_profile_screen.dart';

class PatientDashboardScreen extends StatefulWidget {
  const PatientDashboardScreen({super.key});

  @override
  State<PatientDashboardScreen> createState() =>
      _PatientDashboardScreenState();
}

class _PatientDashboardScreenState extends State<PatientDashboardScreen> {
  String _userName = "Patient";
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get();

        if (doc.exists) {
          setState(() {
            _userName = (doc.data()?["name"] ?? "Patient").toString();
          });
        }
      } catch (_) {}
    }

    if (mounted) {
      setState(() => _loading = false);
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

              /// ================= HEADER =================
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

                  /// Profile Avatar
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

              /// ================= SNAPSHOT GRID =================
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.35,
                children: const [
                  _SummaryCard(
                    icon: Icons.local_hospital_outlined,
                    title: "Last Visit",
                    value: "24 Mar",
                    subtitle: "Dr. Smith",
                  ),
                  _SummaryCard(
                    icon: Icons.medication_outlined,
                    title: "Medication",
                    value: "2 / 3",
                    subtitle: "Doses today",
                  ),
                  _SummaryCard(
                    icon: Icons.event_available_outlined,
                    title: "Next Visit",
                    value: "12 Apr",
                    subtitle: "Gastro Dept",
                  ),
                  _SummaryCard(
                    icon: Icons.receipt_long_outlined,
                    title: "Reports",
                    value: "1 Pending",
                    subtitle: "Lab processing",
                  ),
                ],
              ),

              const SizedBox(height: 26),

              /// ================= MEDICATION PROGRESS =================
              _sectionTitle("Medication Progress"),

              const SizedBox(height: 12),

              _medicationCard(),

              const SizedBox(height: 28),

              /// ================= LAB REPORT =================
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Pantoprazole 40mg",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              _StatusChip(
                label: "Ongoing",
                color: Colors.teal,
              )
            ],
          ),

          const SizedBox(height: 14),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: 0.66,
              minHeight: 6,
              backgroundColor: Colors.white10,
              color: Colors.tealAccent,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            "2 of 3 doses completed • Next at 8:00 PM",
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
        ],
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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Complete Blood Count (CBC)",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              _StatusChip(
                label: "Processing",
                color: Colors.orange,
              )
            ],
          ),

          SizedBox(height: 10),

          Text(
            "Collected: 22 Mar 2025",
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
          SizedBox(height: 4),
          Text(
            "Expected Result: 28 Mar 2025",
            style: TextStyle(fontSize: 12, color: Colors.white60),
          ),
        ],
      ),
    );
  }
}

/// ================= SUMMARY CARD =================
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
            style: const TextStyle(fontSize: 11, color: Colors.white70),
          ),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 10, color: Colors.white54),
          ),
        ],
      ),
    );
  }
}

/// ================= STATUS CHIP =================
class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}