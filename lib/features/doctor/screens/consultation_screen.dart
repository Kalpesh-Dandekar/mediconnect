import 'package:flutter/material.dart';

class ConsultationScreen extends StatefulWidget {
  final String patientId;
  final String patientName;

  const ConsultationScreen({
    super.key,
    required this.patientId,
    required this.patientName,
  });

  @override
  State<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  final TextEditingController diagnosisController = TextEditingController();
  final TextEditingController adviceController = TextEditingController();

  List<Map<String, String>> prescriptions = [];
  List<String> recommendedTests = [];

  final TextEditingController medicineController = TextEditingController();
  final TextEditingController dosageController = TextEditingController();
  final TextEditingController durationController = TextEditingController();

  DateTime? followUpDate;

  static const Color accent = Color(0xFF00C2B2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C1B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C1B2A),
        elevation: 0,
        title: Text(
          widget.patientName,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ===== DIAGNOSIS =====
            _sectionTitle("Diagnosis"),
            _inputField(diagnosisController, "Enter diagnosis"),

            const SizedBox(height: 24),

            /// ===== PRESCRIPTION =====
            _sectionTitle("Prescription"),

            _inputField(medicineController, "Medicine Name"),
            const SizedBox(height: 10),
            _inputField(dosageController, "Dosage (e.g., 1-0-1)"),
            const SizedBox(height: 10),
            _inputField(durationController, "Duration (e.g., 5 days)"),

            const SizedBox(height: 12),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
              ),
              onPressed: _addPrescription,
              child: const Text(
                "Add Medicine",
                style: TextStyle(color: Colors.black),
              ),
            ),

            const SizedBox(height: 16),

            ...prescriptions.map((med) => _prescriptionCard(med)),

            const SizedBox(height: 24),

            /// ===== TESTS =====
            _sectionTitle("Recommended Tests"),

            _testChip("Blood Test"),
            _testChip("X-Ray"),
            _testChip("MRI"),
            _testChip("CT Scan"),

            const SizedBox(height: 24),

            /// ===== ADVICE =====
            _sectionTitle("Advice"),

            _inputField(adviceController, "Enter advice for patient"),

            const SizedBox(height: 24),

            /// ===== FOLLOW UP =====
            _sectionTitle("Follow-up Date"),

            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  followUpDate == null
                      ? "Select follow-up date"
                      : "${followUpDate!.day}-${followUpDate!.month}-${followUpDate!.year}",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 40),

            /// ===== SAVE BUTTON =====
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Consultation Saved (Dummy)"),
                    ),
                  );
                },
                child: const Text(
                  "Complete Consultation",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ==========================
  /// HELPERS
  /// ==========================

  Widget _sectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        color: Colors.white54,
        letterSpacing: 1.2,
        fontSize: 13,
      ),
    );
  }

  Widget _inputField(TextEditingController controller, String hint) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white38),
          border: InputBorder.none,
        ),
      ),
    );
  }

  void _addPrescription() {
    if (medicineController.text.isEmpty) return;

    setState(() {
      prescriptions.add({
        "medicine": medicineController.text,
        "dosage": dosageController.text,
        "duration": durationController.text,
      });
    });

    medicineController.clear();
    dosageController.clear();
    durationController.clear();
  }

  Widget _prescriptionCard(Map<String, String> med) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            med["medicine"] ?? "",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Dosage: ${med["dosage"]}",
            style: const TextStyle(color: Colors.white60),
          ),
          Text(
            "Duration: ${med["duration"]}",
            style: const TextStyle(color: Colors.white60),
          ),
        ],
      ),
    );
  }

  Widget _testChip(String test) {
    bool selected = recommendedTests.contains(test);

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (selected) {
              recommendedTests.remove(test);
            } else {
              recommendedTests.add(test);
            }
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: selected
                ? accent.withOpacity(0.15)
                : Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            test,
            style: TextStyle(
              color: selected ? accent : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      setState(() {
        followUpDate = picked;
      });
    }
  }
}