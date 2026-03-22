import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  static const Color _accent = Color(0xFF8E44AD);

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
    _loadProfile();
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

              /// HEADER + EDIT BUTTON
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
                      color: Colors.tealAccent,
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

              const SizedBox(height: 30),

              /// AVATAR
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 42,
                      backgroundColor: _accent.withOpacity(0.2),
                      child: Text(
                        initials,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: _accent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _nameController.text,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      email,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              /// DETAILS
              _sectionTitle("Account Information"),

              const SizedBox(height: 14),

              _editableTile("Name", _nameController),
              _editableTile("Phone", _phoneController),
              _editableTile("Relationship", _relationController),
              _infoTile("Linked Patient", patientName),

              const SizedBox(height: 40),

              /// LOGOUT
              GestureDetector(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFB00020), Color(0xFFD32F2F)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _editableTile(String label, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF14283C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        enabled: isEditing,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF14283C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        color: Colors.white.withOpacity(0.6),
        fontSize: 12,
      ),
    );
  }
}