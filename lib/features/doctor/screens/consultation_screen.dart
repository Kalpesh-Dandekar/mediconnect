import 'package:flutter/material.dart';
import '../../../services/doctor/consultation_service.dart';

class ConsultationScreen extends StatefulWidget {
  final String patientId;
  final String patientName;
  final String appointmentId;

  const ConsultationScreen({
    super.key,
    required this.patientId,
    required this.patientName,
    required this.appointmentId,
  });

  @override
  State<ConsultationScreen> createState() =>
      _ConsultationScreenState();
}

class _ConsultationScreenState
    extends State<ConsultationScreen> {

  final TextEditingController diagnosisController = TextEditingController();
  final TextEditingController summaryController = TextEditingController();
  final TextEditingController adviceController = TextEditingController();

  final TextEditingController medicineController = TextEditingController();
  final TextEditingController durationController = TextEditingController();

  int frequency = 1;
  List<String> selectedTimings = [];

  List<Map<String, dynamic>> prescriptions = [];

  bool _loading = false;

  static const Color accent = Color(0xFF00C2B2);
  final List<String> timingOptions = ["Morning", "Afternoon", "Night"];

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

            /// 🔥 DIAGNOSIS
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("Diagnosis"),
                  _inputField(diagnosisController, "Enter diagnosis"),
                ],
              ),
            ),

            const SizedBox(height: 18),

            /// 🔥 SUMMARY
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("Consultation Summary"),
                  _inputField(summaryController, "Short summary"),
                ],
              ),
            ),

            const SizedBox(height: 18),

            /// 🔥 MEDICINES
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  _sectionTitle("Medicines"),

                  _inputField(medicineController, "Medicine Name"),
                  const SizedBox(height: 10),
                  _inputField(durationController, "Duration (days)"),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Text("Frequency:",
                          style: TextStyle(color: Colors.white)),
                      const SizedBox(width: 10),
                      DropdownButton<int>(
                        dropdownColor: const Color(0xFF1E3148),
                        value: frequency,
                        items: [1,2,3].map((e) => DropdownMenuItem(
                          value: e,
                          child: Text("$e/day",
                              style: const TextStyle(color: Colors.white)),
                        )).toList(),
                        onChanged: (val) =>
                            setState(() => frequency = val!),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 10,
                    children: timingOptions.map((t) {
                      final selected = selectedTimings.contains(t);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selected
                                ? selectedTimings.remove(t)
                                : selectedTimings.add(t);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: selected
                                ? accent.withOpacity(0.2)
                                : Colors.white.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            t,
                            style: TextStyle(
                                color: selected ? accent : Colors.white70),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 12),

                  /// 🔥 ADD BUTTON
                  GestureDetector(
                    onTap: _addMedicine,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: accent,
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "Add Medicine",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  ...prescriptions.map((med) => _medicineCard(med)).toList(),
                ],
              ),
            ),

            const SizedBox(height: 18),

            /// 🔥 ADVICE
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("Advice"),
                  _inputField(adviceController, "Enter advice"),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// 🔥 COMPLETE BUTTON
            GestureDetector(
              onTap: _loading ? null : _saveConsultation,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFF9F1C),
                      Color(0xFFFFB703),
                    ],
                  ),
                ),
                alignment: Alignment.center,
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text(
                  "Complete Consultation",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// UI HELPERS

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: child,
    );
  }

  void _addMedicine() {
    if (medicineController.text.isEmpty || durationController.text.isEmpty) return;

    setState(() {
      prescriptions.add({
        "medicine": medicineController.text,
        "duration": durationController.text,
        "frequency": frequency,
        "timings": List<String>.from(selectedTimings),
      });
    });

    medicineController.clear();
    durationController.clear();
    selectedTimings.clear();
    frequency = 1;
  }

  Future<void> _saveConsultation() async {
    setState(() => _loading = true);

    try {
      await ConsultationService().saveConsultation(
        patientId: widget.patientId,
        patientName: widget.patientName,
        diagnosis: diagnosisController.text.trim(),
        summary: summaryController.text.trim(),
        prescriptions: prescriptions,
        tests: [],
        advice: adviceController.text.trim(),
        appointmentId: widget.appointmentId,
      );

      Navigator.pop(context);

    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }

    setState(() => _loading = false);
  }

  Widget _medicineCard(Map<String, dynamic> med) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        "${med["medicine"]} • ${med["duration"]} days",
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _sectionTitle(String title) =>
      Text(title.toUpperCase(),
          style: const TextStyle(color: Colors.white54));

  Widget _inputField(TextEditingController c, String h) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: c,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: h,
          hintStyle: const TextStyle(color: Colors.white38),
          border: InputBorder.none,
        ),
      ),
    );
  }
}