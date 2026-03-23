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

    /// 🔥 AUTO FILL PATIENT ID
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
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: const Color(0xFF14283C),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C1B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C1B2A),
        elevation: 0,
        title: Text(widget.patientName ?? "Upload Report"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: _patientIdController,
              style: const TextStyle(color: Colors.white),
              decoration: _inputStyle("Patient ID"),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _testController,
              style: const TextStyle(color: Colors.white),
              decoration: _inputStyle("Test Name"),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _labController,
              style: const TextStyle(color: Colors.white),
              decoration: _inputStyle("Lab Name"),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _summaryController,
              style: const TextStyle(color: Colors.white),
              decoration: _inputStyle("Result Summary"),
              maxLines: 3,
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _uploadReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text("Upload Report"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}