import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mediconnect/services/staff/staff_profile_service.dart';

class StaffProfileScreen extends StatefulWidget {
  const StaffProfileScreen({super.key});

  @override
  State<StaffProfileScreen> createState() =>
      _StaffProfileScreenState();
}

class _StaffProfileScreenState extends State<StaffProfileScreen> {

  final StaffProfileService _service = StaffProfileService();

  static const Color _accent = Color(0xFF00C2B2);

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  /// 🔥 EDIT POPUP (UPDATED)
  void _editField({
    required String title,
    required String field,
    required String currentValue,
    bool isTopLevel = false,
  }) {
    final controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF14283C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text("Edit $title",
            style: const TextStyle(color: Colors.white)),
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
              backgroundColor: _accent,
            ),
            onPressed: () async {
              if (controller.text.trim().isEmpty) return;

              if (isTopLevel) {
                await _service.updateTopLevelField(
                    field, controller.text.trim());
              } else {
                await _service.updateField(
                    field, controller.text.trim());
              }

              Navigator.pop(context);
            },
            child: const Text("Save",
                style: TextStyle(color: Colors.black)),
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
              return const Center(
                  child: CircularProgressIndicator());
            }

            final data =
                snapshot.data!.data() as Map<String, dynamic>? ?? {};

            final profile = data["profile"] ?? {};

            final name = data["name"] ?? "Staff";
            final email = data["email"] ?? user?.email ?? "--";

            final department = profile["department"] ?? "--";
            final designation = profile["designation"] ?? "--";
            final contact = profile["contactNumber"] ?? "--";

            return SingleChildScrollView(
              padding:
              const EdgeInsets.fromLTRB(20, 20, 20, 110),
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

                  /// 🔥 HEADER CARD (FIXED)
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
                          radius: 30,
                          backgroundColor:
                          _accent.withOpacity(0.2),
                          child: Text(
                            name.isNotEmpty
                                ? name[0].toUpperCase()
                                : "S",
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
                                name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                email,
                                style: const TextStyle(
                                  color: Colors.white54,
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
                    "WORK INFORMATION",
                    style: TextStyle(
                      color: Colors.white54,
                      letterSpacing: 1.2,
                    ),
                  ),

                  const SizedBox(height: 12),

                  _tile("Department", department, "department"),
                  _tile("Designation", designation, "designation"),
                  _tile("Contact", contact, "contactNumber"),

                  const SizedBox(height: 40),

                  /// LOGOUT
                  Center(
                    child: GestureDetector(
                      onTap: () => _logout(context),
                      child: Container(
                        width: 220,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(30),
                          border: Border.all(color: Colors.redAccent),
                          color:
                          Colors.redAccent.withOpacity(0.1),
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

  /// 🔥 TILE (FIXED)
  Widget _tile(String title, String value, String field) {
    return GestureDetector(
      onTap: () => _editField(
        title: title,
        field: field,
        currentValue: value,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white.withOpacity(0.05),
          border: Border.all(
            color: Colors.white.withOpacity(0.06),
          ),
        ),
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: const TextStyle(
                    color: Colors.white60)),
            Row(
              children: [
                Text(value,
                    style:
                    const TextStyle(color: Colors.white)),
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