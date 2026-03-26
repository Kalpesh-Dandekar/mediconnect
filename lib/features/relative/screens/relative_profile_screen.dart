import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mediconnect/services/relative/relative_profile_service.dart';

class RelativeProfileScreen extends StatefulWidget {
  const RelativeProfileScreen({super.key});

  @override
  State<RelativeProfileScreen> createState() =>
      _RelativeProfileScreenState();
}

class _RelativeProfileScreenState
    extends State<RelativeProfileScreen> {

  final RelativeProfileService _profileService =
  RelativeProfileService();

  static const Color _accent = Color(0xFF00C2B2);

  bool loading = true;
  bool isEditing = false;

  String patientName = "--";
  String email = "";

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _relationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _loadProfile();
    await _saveFCMToken();
  }

  Future<void> _saveFCMToken() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final token = await FirebaseMessaging.instance.getToken();
      if (token == null) return;

      await FirebaseMessaging.instance.requestPermission();
      await FirebaseMessaging.instance.subscribeToTopic("all");

      await _profileService.saveFCMToken(
        userId: user.uid,
        token: token,
      );

    } catch (e) {
      print("FCM ERROR: $e");
    }
  }

  Future<void> _loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    email = user.email ?? "";

    final data = await _profileService.getProfile(user.uid);

    _nameController.text = data["name"];
    _phoneController.text = data["phone"];
    _relationController.text = data["relationship"];
    patientName = data["patientName"];

    setState(() => loading = false);
  }

  Future<void> _saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await _profileService.updateProfile(
      userId: user.uid,
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      relationship: _relationController.text.trim(),
    );

    setState(() => isEditing = false);
  }

  String get initials {
    final name = _nameController.text;
    if (name.isEmpty) return "--";
    final parts = name.split(" ");
    return parts.length >= 2
        ? parts[0][0] + parts[1][0]
        : parts[0][0];
  }

  @override
  Widget build(BuildContext context) {

    if (loading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0C1B2A),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0C1B2A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isEditing ? Icons.check : Icons.edit,
                      color: _accent,
                    ),
                    onPressed: () async {
                      if (isEditing) {
                        await _saveProfile();
                      } else {
                        setState(() => isEditing = true);
                      }
                    },
                  )
                ],
              ),

              const SizedBox(height: 20),

              /// 🔥 PROFILE CARD
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
                      backgroundColor: _accent.withOpacity(0.2),
                      child: Text(
                        initials,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _accent,
                        ),
                      ),
                    ),

                    const SizedBox(width: 14),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _nameController.text,
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
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(height: 28),

              /// SECTION
              _sectionTitle("Account Information"),

              _editableTile("Name", _nameController),
              _editableTile("Phone", _phoneController),
              _editableTile("Relationship", _relationController),
              _infoTile("Linked Patient", patientName),

              const SizedBox(height: 40),

              /// LOGOUT
              Center(
                child: GestureDetector(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).popUntil((r) => r.isFirst);
                  },
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
        ),
      ),
    );
  }

  /// EDITABLE TILE
  Widget _editableTile(String label, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: TextField(
        controller: controller,
        enabled: isEditing,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white60),
          border: InputBorder.none,
        ),
      ),
    );
  }

  /// INFO TILE
  Widget _infoTile(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
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

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: Colors.white54,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}