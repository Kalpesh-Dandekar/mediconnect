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
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// HEADER
                  _profileHeader(data),

                  const SizedBox(height: 28),

                  /// PROFESSIONAL INFO
                  _sectionTitle("Professional Information"),

                  _editableTile(context, "Name", data["name"], "name"),
                  _editableTile(context, "Experience", data["experience"], "experience"),
                  _infoTile("Email", data["email"] ?? ""),
                  _infoTile("Department", data["department"] ?? "General"),

                  const SizedBox(height: 30),

                  /// AVAILABILITY
                  _sectionTitle("Availability"),

                  _editableTile(context, "Days", data["days"], "days"),
                  _editableTile(context, "Time", data["time"], "time"),
                  _editableTile(context, "Fee", data["fee"], "fee"),

                  const SizedBox(height: 30),

                  /// ACCOUNT
                  _sectionTitle("Account"),

                  _actionTile(
                    icon: Icons.logout,
                    title: "Logout",
                    isDanger: true,
                    onTap: () => _logout(context),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// 🔥 HEADER
  Widget _profileHeader(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: accent,
            child: Text("DR", style: TextStyle(color: Colors.black)),
          ),
          const SizedBox(width: 15),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data["name"] ?? "Doctor",
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                data["specialization"] ?? "",
                style: const TextStyle(color: Colors.white54),
              ),
            ],
          )
        ],
      ),
    );
  }

  /// 🔥 EDITABLE TILE
  Widget _editableTile(BuildContext context, String label, dynamic value, String field) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
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
              IconButton(
                icon: const Icon(Icons.edit, color: accent, size: 18),
                onPressed: () {
                  _showEditDialog(context, label, value, field);
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  /// 🔒 NON EDITABLE
  Widget _infoTile(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
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

  /// ✏️ EDIT DIALOG
  void _showEditDialog(BuildContext context, String label, dynamic value, String field) {

    final controller = TextEditingController(text: value?.toString() ?? "");

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xFF16263A),
          title: Text("Edit $label", style: const TextStyle(color: Colors.white)),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: "Enter value",
              hintStyle: TextStyle(color: Colors.white38),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final newValue = controller.text.trim();

                if (newValue.isEmpty) return;

                await service.updateField(field, newValue);

                Navigator.pop(context);
              },
              child: const Text("Save", style: TextStyle(color: accent)),
            ),
          ],
        );
      },
    );
  }

  /// LOGOUT
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
    return Text(
      title.toUpperCase(),
      style: const TextStyle(color: Colors.white54),
    );
  }

  static Widget _actionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: isDanger ? Colors.redAccent : accent),
            const SizedBox(width: 12),
            Text(title,
                style: TextStyle(
                    color: isDanger ? Colors.redAccent : Colors.white)),
          ],
        ),
      ),
    );
  }
}