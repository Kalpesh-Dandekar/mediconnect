import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mediconnect/features/auth/screens/login_screen.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() =>
      _PatientProfileScreenState();
}

class _PatientProfileScreenState
    extends State<PatientProfileScreen> {

  static const Color _accent = Color(0xFFFFB703);

  String name = "Loading...";
  String age = "--";
  String gender = "--";
  String bloodGroup = "--";
  String phone = "--";

  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    try {

      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      if (doc.exists) {

        final data = doc.data()!;

        setState(() {

          name = data["name"] ?? "Patient";
          age = data["age"]?.toString() ?? "--";
          gender = data["gender"] ?? "--";
          bloodGroup = data["bloodGroup"] ?? "--";
          phone = data["phone"] ?? "--";

          loading = false;
        });
      }

    } catch (_) {
      loading = false;
    }
  }

  void _logout(BuildContext context) async {

    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF0C1B2A),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              /// HEADER
              const Text(
                "Profile",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

              /// USER CARD
              Container(
                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(18),
                ),

                child: Row(
                  children: [

                    /// Avatar
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: _accent.withOpacity(0.2),

                      child: Text(
                        (name.isNotEmpty ? name[0] : "P")
                            .toUpperCase(),

                        style: const TextStyle(
                          color: _accent,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),

                    const SizedBox(width: 15),

                    /// Email + ID
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          Text(
                            user?.email ??
                                "patient@mediconnect.com",

                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            "Patient ID: ${user?.uid.substring(0,6) ?? "--"}",

                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Icon(Icons.edit,
                        color: Colors.white38),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              /// PERSONAL INFO
              const Text(
                "PERSONAL INFORMATION",
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 1.5,
                  color: Colors.white54,
                ),
              ),

              const SizedBox(height: 12),

              _infoTile("Full Name", name),
              _infoTile("Age", age),
              _infoTile("Gender", gender),
              _infoTile("Blood Group", bloodGroup),
              _infoTile("Phone", phone),

              const SizedBox(height: 28),

              /// MEDICAL SUMMARY
              const Text(
                "MEDICAL SUMMARY",
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 1.5,
                  color: Colors.white54,
                ),
              ),

              const SizedBox(height: 12),

              _infoTile("Ongoing Treatment", "Gastritis"),
              _infoTile("Active Medicines", "2 Prescriptions"),
              _infoTile("Allergies", "None Reported"),

              const SizedBox(height: 28),

              /// RELATIVE
              const Text(
                "LINKED RELATIVE",
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 1.5,
                  color: Colors.white54,
                ),
              ),

              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                ),

                child: const Row(
                  children: [
                    Icon(Icons.family_restroom,
                        color: Color(0xFFFFB703)),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "No relative linked yet",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              /// LOGOUT
              Center(
                child: GestureDetector(
                  onTap: () => _logout(context),

                  child: Container(
                    width: 220,
                    height: 50,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.redAccent.withOpacity(0.15),
                      border: Border.all(
                        color: Colors.redAccent,
                      ),
                    ),

                    alignment: Alignment.center,

                    child: const Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Info Tile
  Widget _infoTile(String title, String value) {

    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      padding:
      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
      ),

      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,

        children: [

          Text(
            title,

            style: const TextStyle(
              color: Colors.white60,
              fontSize: 12,
            ),
          ),

          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,

              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}