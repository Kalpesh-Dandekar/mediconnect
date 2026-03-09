import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StaffProfileScreen extends StatelessWidget {
  const StaffProfileScreen({super.key});

  static const Color _accent = Color(0xFF2979FF);

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C1B2A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// ===== HEADER =====
              const Text(
                "Profile",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

              /// ===== PROFILE CARD =====
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF14283C),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [

                    /// AVATAR
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _accent.withOpacity(0.15),
                      ),
                      child: const Center(
                        child: Text(
                          "ST",
                          style: TextStyle(
                            color: _accent,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    /// INFO
                    Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Anjali Deshmukh",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding:
                          const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4),
                          decoration:
                          BoxDecoration(
                            color:
                            _accent.withOpacity(0.2),
                            borderRadius:
                            BorderRadius
                                .circular(20),
                          ),
                          child: const Text(
                            "Staff Member",
                            style: TextStyle(
                              color: _accent,
                              fontSize: 11,
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Employee ID: ST-2045",
                          style: TextStyle(
                            fontSize: 12,
                            color:
                            Colors.white.withOpacity(
                                0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// ===== WORK INFO =====
              _sectionTitle("Work Information"),

              const SizedBox(height: 16),

              _infoTile("Department",
                  "Front Desk Administration"),

              _infoTile("Hospital",
                  "City Care Hospital"),

              _infoTile("Shift Timing",
                  "9:00 AM - 6:00 PM"),

              _infoTile("Email",
                  "staff@mediconnect.com"),

              const SizedBox(height: 30),

              /// ===== ACCOUNT =====
              _sectionTitle("Account"),

              const SizedBox(height: 16),

              _actionTile(
                icon: Icons.lock_outline,
                label: "Change Password",
                onTap: () {},
              ),

              const SizedBox(height: 10),

              _actionTile(
                icon: Icons.logout,
                label: "Logout",
                color: Colors.redAccent,
                onTap: () => _logout(context),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= SECTION TITLE =================
  Widget _sectionTitle(String text) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 12,
        letterSpacing: 1.2,
        color: Colors.white60,
      ),
    );
  }

  /// ================= INFO TILE =================
  Widget _infoTile(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF14283C),
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
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  /// ================= ACTION TILE =================
  Widget _actionTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF14283C),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios,
                color: Colors.white38, size: 14),
          ],
        ),
      ),
    );
  }
}