import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../services/doctor/profile_service.dart';
import '../../auth/screens/login_screen.dart';

class DoctorProfileScreen extends StatelessWidget {
  DoctorProfileScreen({super.key});

  final DoctorProfileService service = DoctorProfileService();

  static const Color accent = Color(0xFF00C2B2);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0C1B2A),
      child: SafeArea(
        child: StreamBuilder(
          stream: service.getProfile(),
          builder: (context, snapshot) {

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.data() == null) {
              return const Center(
                child: Text(
                  "No profile data",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            final data =
            snapshot.data!.data() as Map<String, dynamic>;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// TITLE
                  const Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🔥 HEADER (FIXED)
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.white.withOpacity(0.05),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.08),
                      ),
                    ),
                    child: Row(
                      children: [

                        CircleAvatar(
                          radius: 28,
                          backgroundColor: accent.withOpacity(0.2),
                          child: Text(
                            (data["name"] ?? "D")[0],
                            style: const TextStyle(
                              color: accent,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),

                        const SizedBox(width: 14),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data["name"] ?? "Doctor",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              data["specialization"] ?? "",
                              style: const TextStyle(
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  /// PROFESSIONAL
                  _sectionTitle("Professional Information"),

                  _editableTile(context, "Name", data["name"], "name"),
                  _editableTile(context, "Experience", data["experience"], "experience"),
                  _infoTile("Email", data["email"] ?? ""),
                  _infoTile("Department", data["department"] ?? "General"),

                  const SizedBox(height: 28),

                  /// AVAILABILITY
                  _sectionTitle("Availability"),

                  _editableTile(context, "Days", data["days"], "days"),
                  _editableTile(context, "Time", data["time"], "time"),
                  _editableTile(context, "Fee", data["fee"], "fee"),

                  const SizedBox(height: 40),

                  /// 🔥 LOGOUT (FIXED)
                  Center(
                    child: GestureDetector(
                      onTap: () => _logout(context),
                      child: Container(
                        width: 220,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.redAccent),
                          color: Colors.redAccent.withOpacity(0.1),
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

  /// 🔥 EDITABLE TILE (FIXED)
  Widget _editableTile(BuildContext context, String label, dynamic value, String field) {
    return GestureDetector(
      onTap: () => _showEditDialog(context, label, value, field),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white.withOpacity(0.05),
          border: Border.all(
            color: Colors.white.withOpacity(0.06),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white60)),

            Row(
              children: [
                Text(
                  (value == null || value.toString().isEmpty)
                      ? "-"
                      : value.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.edit,
                    size: 16, color: Colors.white38),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 🔒 INFO TILE
  Widget _infoTile(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(
          color: Colors.white.withOpacity(0.06),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white60)),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  /// EDIT DIALOG
  void _showEditDialog(BuildContext context, String label, dynamic value, String field) {

    final controller = TextEditingController(text: value?.toString() ?? "");

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xFF14283C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text("Edit $label", style: const TextStyle(color: Colors.white)),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel",
                  style: TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
              ),
              onPressed: () async {
                await service.updateField(field, controller.text.trim());
                Navigator.pop(context);
              },
              child: const Text("Save",
                  style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
      );
    }
  }

  static Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.white54,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}