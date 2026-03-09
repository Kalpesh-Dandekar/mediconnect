import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mediconnect/services/auth_service.dart';

class RoleDetailsScreen extends StatefulWidget {
  final String role;

  const RoleDetailsScreen({super.key, required this.role});

  @override
  State<RoleDetailsScreen> createState() => _RoleDetailsScreenState();
}

class _RoleDetailsScreenState extends State<RoleDetailsScreen> {
  final AuthService _authService = AuthService();
  final User? user = FirebaseAuth.instance.currentUser;

  bool isLoading = false;

  String? gender;
  String? bloodGroup;
  String? relationType;
  String? designation;

  final TextEditingController ageController = TextEditingController();
  final TextEditingController emergencyController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  final TextEditingController specializationController =
  TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController licenseController = TextEditingController();
  final TextEditingController doctorPhoneController = TextEditingController();

  final TextEditingController relativeNameController =
  TextEditingController();
  final TextEditingController relativePhoneController =
  TextEditingController();

  final TextEditingController departmentController =
  TextEditingController();
  final TextEditingController staffIdController = TextEditingController();
  final TextEditingController staffPhoneController =
  TextEditingController();

  Future<void> _finishRegistration() async {
    if (user == null) return;

    setState(() => isLoading = true);

    Map<String, dynamic> profileData = _collectProfileData();

    try {
      await _authService.saveRoleDetails(
        uid: user!.uid,
        profileData: profileData,
      );

      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFFFF9F1C),
          content: Text(
            "Profile completed successfully!",
            style: TextStyle(color: Colors.black),
          ),
        ),
      );

      Future.delayed(const Duration(milliseconds: 1200), () {
        Navigator.popUntil(context, (route) => route.isFirst);
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Map<String, dynamic> _collectProfileData() {
    switch (widget.role) {
      case "Patient":
        return {
          "age": ageController.text,
          "gender": gender,
          "bloodGroup": bloodGroup,
          "emergencyContact": emergencyController.text,
          "city": cityController.text,
        };
      case "Doctor":
        return {
          "specialization": specializationController.text,
          "experience": experienceController.text,
          "licenseNumber": licenseController.text,
          "contactNumber": doctorPhoneController.text,
        };
      case "Relative":
        return {
          "relationType": relationType,
          "patientName": relativeNameController.text,
          "patientContact": relativePhoneController.text,
        };
      case "Staff":
        return {
          "designation": designation,
          "department": departmentController.text,
          "staffId": staffIdController.text,
          "contactNumber": staffPhoneController.text,
        };
      default:
        return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0C1B2A), Color(0xFF16263A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new,
                      color: Colors.white70),
                ),
                const SizedBox(height: 20),
                const Text(
                  "PROFILE DETAILS",
                  style: TextStyle(
                    fontSize: 13,
                    letterSpacing: 2,
                    color: Colors.white54,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Complete Your ${widget.role} Profile",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: SingleChildScrollView(
                    child: _buildRoleFields(),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: isLoading ? null : _finishRegistration,
                    child: Container(
                      width: 260,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF9F1C), Color(0xFFFFB703)],
                        ),
                      ),
                      alignment: Alignment.center,
                      child: isLoading
                          ? const CircularProgressIndicator(
                          color: Colors.black, strokeWidth: 2)
                          : const Text(
                        "FINISH REGISTRATION",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleFields() {
    switch (widget.role) {
      case "Patient":
        return Column(
          children: [
            _input(ageController, "Age", Icons.cake_outlined),
            const SizedBox(height: 20),
            _dropdown(
              value: gender,
              hint: "Gender",
              items: ["Male", "Female", "Other"],
              onChanged: (val) => setState(() => gender = val),
            ),
            const SizedBox(height: 20),
            _dropdown(
              value: bloodGroup,
              hint: "Blood Group",
              items: ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"],
              onChanged: (val) => setState(() => bloodGroup = val),
            ),
            const SizedBox(height: 20),
            _input(emergencyController, "Emergency Contact",
                Icons.phone_outlined),
            const SizedBox(height: 20),
            _input(cityController, "City", Icons.location_on_outlined),
          ],
        );

      case "Doctor":
        return Column(
          children: [
            _input(specializationController, "Specialization",
                Icons.medical_services_outlined),
            const SizedBox(height: 20),
            _input(experienceController, "Experience (Years)",
                Icons.timelapse_outlined),
            const SizedBox(height: 20),
            _input(licenseController, "License Number",
                Icons.badge_outlined),
            const SizedBox(height: 20),
            _input(doctorPhoneController, "Contact Number",
                Icons.phone_outlined),
          ],
        );

      case "Relative":
        return Column(
          children: [
            _dropdown(
              value: relationType,
              hint: "Relation Type",
              items: [
                "Father",
                "Mother",
                "Brother",
                "Sister",
                "Spouse",
                "Guardian"
              ],
              onChanged: (val) => setState(() => relationType = val),
            ),
            const SizedBox(height: 20),
            _input(relativeNameController, "Patient Name",
                Icons.person_outline),
            const SizedBox(height: 20),
            _input(relativePhoneController, "Patient Contact",
                Icons.phone_outlined),
          ],
        );

      case "Staff":
        return Column(
          children: [
            _dropdown(
              value: designation,
              hint: "Designation",
              items: [
                "Nurse",
                "Receptionist",
                "Technician",
                "Admin",
                "Pharmacist"
              ],
              onChanged: (val) => setState(() => designation = val),
            ),
            const SizedBox(height: 20),
            _input(departmentController, "Department",
                Icons.apartment_outlined),
            const SizedBox(height: 20),
            _input(staffIdController, "Staff ID", Icons.badge_outlined),
            const SizedBox(height: 20),
            _input(staffPhoneController, "Contact Number",
                Icons.phone_outlined),
          ],
        );

      default:
        return const SizedBox();
    }
  }

  Widget _input(
      TextEditingController controller, String hint, IconData icon) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white60, size: 20),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: Colors.white.withOpacity(0.06),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _dropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white.withOpacity(0.06),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: const Color(0xFF16263A),
          value: value,
          hint: Text(
            hint,
            style: const TextStyle(color: Colors.white38),
          ),
          iconEnabledColor: Colors.white70,
          style: const TextStyle(color: Colors.white),
          isExpanded: true,
          items: items
              .map(
                (e) => DropdownMenuItem<String>(
              value: e,
              child: Text(e),
            ),
          )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}