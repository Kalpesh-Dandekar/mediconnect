import 'package:flutter/material.dart';
import 'package:mediconnect/services/staff/staff_report_service.dart';

class StaffReportsScreen extends StatefulWidget {
  final String? patientId;
  final String? patientName;

  const StaffReportsScreen({
    super.key,
    this.patientId,
    this.patientName,
  });

  @override
  State<StaffReportsScreen> createState() =>
      _StaffReportsScreenState();
}

class _StaffReportsScreenState extends State<StaffReportsScreen> {

  final StaffReportService _service = StaffReportService();

  final TextEditingController _patientIdController =
  TextEditingController();
  final TextEditingController _testController =
  TextEditingController();
  final TextEditingController _labController =
  TextEditingController();
  final TextEditingController _summaryController =
  TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.patientId != null) {
      _patientIdController.text = widget.patientId!;
    }
  }

  void _uploadReport() async {
    if (_patientIdController.text.isEmpty ||
        _testController.text.isEmpty ||
        _summaryController.text.isEmpty) return;

    await _service.uploadReport(
      patientId: _patientIdController.text.trim(),
      testName: _testController.text.trim(),
      collectedDate: DateTime.now().toString(),
      labName: _labController.text.trim(),
      resultSummary: _summaryController.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Report Uploaded")),
    );

    Navigator.pop(context);
  }

  InputDecoration _inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white60),
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
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

              /// 🔥 HEADER WITH BACK BUTTON
              Row(
                children: [

                  /// BACK
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// TITLE
                  Expanded(
                    child: Text(
                      widget.patientName ?? "Upload Report",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              const Text(
                "Enter report details",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white54,
                ),
              ),

              const SizedBox(height: 24),

              /// INPUTS
              _inputField(_patientIdController, "Patient ID"),
              const SizedBox(height: 12),

              _inputField(_testController, "Test Name"),
              const SizedBox(height: 12),

              _inputField(_labController, "Lab Name"),
              const SizedBox(height: 12),

              _inputField(_summaryController, "Result Summary",
                  maxLines: 3),

              const SizedBox(height: 24),

              /// BUTTON
              GestureDetector(
                onTap: _uploadReport,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF9F1C), Color(0xFFFFB703)],
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "Upload Report",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
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

  Widget _inputField(TextEditingController controller, String label,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: _inputStyle(label),
    );
  }
}