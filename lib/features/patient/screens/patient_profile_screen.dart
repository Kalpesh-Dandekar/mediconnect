import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mediconnect/features/auth/screens/login_screen.dart';
import '../../../services/patient/patient_profile_service.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() =>
      _PatientProfileScreenState();
}

class _PatientProfileScreenState
    extends State<PatientProfileScreen> {

  static const Color _accent = Color(0xFFFFB703);

  final PatientProfileService _service = PatientProfileService();

  void _logout(BuildContext context) async {

    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
    );
  }

  /// 🔥 EDIT FIELD
  void _editField(String title, String field, String currentValue) {

    final controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Edit $title"),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              await _service.updateField(field, controller.text.trim());
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF0C1B2A),

      body: SafeArea(
        child: StreamBuilder(
          stream: _service.getProfile(),
          builder: (context, snapshot) {

            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};

            final name = data["name"] ?? "Patient";
            final age = data["age"]?.toString() ?? "--";
            final gender = data["gender"] ?? "--";
            final bloodGroup = data["bloodGroup"] ?? "--";
            final phone = data["phone"] ?? "--";

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// HEADER CARD
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [

                        CircleAvatar(
                          radius: 30,
                          backgroundColor: _accent.withOpacity(0.2),
                          child: Text(
                            name.isNotEmpty ? name[0].toUpperCase() : "P",
                            style: const TextStyle(
                              color: _accent,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.email ?? "",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "Patient ID: ${user?.uid.substring(0,6)}",
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    "PERSONAL INFORMATION",
                    style: TextStyle(color: Colors.white54),
                  ),

                  const SizedBox(height: 12),

                  _editableTile("Full Name", name, "name"),
                  _editableTile("Age", age, "age"),
                  _editableTile("Gender", gender, "gender"),
                  _editableTile("Blood Group", bloodGroup, "bloodGroup"),
                  _editableTile("Phone", phone, "phone"),

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
                          border: Border.all(color: Colors.redAccent),
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
            );
          },
        ),
      ),
    );
  }

  /// 🔥 EDITABLE TILE
  Widget _editableTile(String title, String value, String field) {

    return GestureDetector(
      onTap: () => _editField(title, field, value),

      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: const TextStyle(color: Colors.white60)),
            Row(
              children: [
                Text(value,
                    style: const TextStyle(color: Colors.white)),
                const SizedBox(width: 6),
                const Icon(Icons.edit,
                    size: 16, color: Colors.white38),
              ],
            ),
          ],
        ),
      ),
    );
  }
}