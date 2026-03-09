import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mediconnect/features/auth/screens/login_screen.dart';

class PatientProfileScreen extends StatelessWidget {
  const PatientProfileScreen({super.key});

  static const Color _accent = Color(0xFFFFB703);

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

              /// ================= HEADER =================
              const Text(
                "Profile",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

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
                        (user?.email ?? "U")[0].toUpperCase(),
                        style: const TextStyle(
                          color: _accent,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),

                    const SizedBox(width: 15),

                    /// Basic Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.email ?? "patient@mediconnect.com",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Patient ID: PT-2045",
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Icon(Icons.edit, color: Colors.white38)
                  ],
                ),
              ),

              const SizedBox(height: 28),

              /// ================= PERSONAL INFO =================
              const Text(
                "PERSONAL INFORMATION",
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 1.5,
                  color: Colors.white54,
                ),
              ),

              const SizedBox(height: 12),

              _infoTile("Full Name", "ABC Patient"),
              _infoTile("Age", "29 Years"),
              _infoTile("Gender", "Male"),
              _infoTile("Blood Group", "O+"),
              _infoTile("Phone", "+91 9876543210"),

              const SizedBox(height: 28),

              /// ================= MEDICAL SUMMARY =================
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

              /// ================= LINKED RELATIVE =================
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
                child: Row(
                  children: const [
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

              /// ================= LOGOUT =================
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

  /// Reusable Info Tile
  Widget _infoTile(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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