import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mediconnect/services/relative/relative_patient_service.dart';
import 'package:mediconnect/services/relative/relative_report_service.dart';

class RelativeReportsScreen extends StatefulWidget {
  const RelativeReportsScreen({super.key});

  @override
  State<RelativeReportsScreen> createState() =>
      _RelativeReportsScreenState();
}

class _RelativeReportsScreenState
    extends State<RelativeReportsScreen> {

  final RelativePatientService _patientService =
  RelativePatientService();

  final RelativeReportService _reportService =
  RelativeReportService();

  String? patientId;
  String patientName = "Loading...";

  bool loading = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final patient =
      await _patientService.getPatient(user.uid);

      if (patient != null) {
        setState(() {
          patientId = patient['id'];
          patientName = patient['name'] ?? "Patient";
        });
      }

    } catch (e) {
      print(e);
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {

    if (loading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0C1B2A),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (patientId == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF0C1B2A),
        body: Center(
          child: Text(
            "No patient connected",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0C1B2A),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: _reportService.getPatientReports(patientId!),
          builder: (context, snapshot) {

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Error: ${snapshot.error}",
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "No reports found",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            final docs = snapshot.data!.docs;

            final pending =
            docs.where((d) => d["status"] == "pending").toList();

            final available =
            docs.where((d) => d["status"] == "available").toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// HEADER
                  const Text(
                    "Reports",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "Monitoring: $patientName",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// SUMMARY
                  Row(
                    children: [
                      Expanded(
                        child: _SummaryCard(
                          label: "Total",
                          value: docs.length.toString(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SummaryCard(
                          label: "Pending",
                          value: pending.length.toString(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SummaryCard(
                          label: "Available",
                          value: available.length.toString(),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  /// PENDING REPORTS
                  const _SectionTitle("PENDING REPORTS"),
                  const SizedBox(height: 16),

                  ...pending.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _PendingReportCard(
                        testName: data["testName"] ?? "",
                        givenOn: data["givenOn"] ?? "",
                        expectedOn: data["expectedOn"] ?? "",
                        labName: data["labName"] ?? "",
                        status: data["status"] ?? "",
                      ),
                    );
                  }),

                  const SizedBox(height: 30),

                  /// AVAILABLE REPORTS
                  const _SectionTitle("AVAILABLE REPORTS"),
                  const SizedBox(height: 16),

                  ...available.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _AvailableReportCard(
                        testName: data["testName"] ?? "",
                        uploadedOn: data["uploadedOn"] ?? "",
                        doctor: data["doctorName"] ?? "",
                        resultStatus: data["resultStatus"] ?? "",
                      ),
                    );
                  }),

                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        letterSpacing: 1.5,
        color: Colors.white54,
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryCard({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF14283C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _PendingReportCard extends StatelessWidget {

  final String testName;
  final String givenOn;
  final String expectedOn;
  final String labName;
  final String status;

  const _PendingReportCard({
    required this.testName,
    required this.givenOn,
    required this.expectedOn,
    required this.labName,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {

    Color chipColor =
    status == "Processing"
        ? Colors.orangeAccent
        : Colors.blueAccent;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF13273B),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [

              Expanded(
                child: Text(
                  testName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: chipColor.withOpacity(0.15),
                  borderRadius:
                  BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: chipColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            "Given On: $givenOn",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            "Expected: $expectedOn",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            "Lab: $labName",
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _AvailableReportCard extends StatelessWidget {

  final String testName;
  final String uploadedOn;
  final String doctor;
  final String resultStatus;

  const _AvailableReportCard({
    required this.testName,
    required this.uploadedOn,
    required this.doctor,
    required this.resultStatus,
  });

  @override
  Widget build(BuildContext context) {

    Color indicatorColor =
    resultStatus == "Normal"
        ? Colors.greenAccent
        : Colors.redAccent;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF14283C),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [

              Expanded(
                child: Text(
                  testName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                  color: indicatorColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            "Uploaded: $uploadedOn",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            "Doctor: $doctor",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            "Result: $resultStatus",
            style: TextStyle(
              color: indicatorColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius:
              BorderRadius.circular(12),
              color: const Color(0xFF1C3A52),
            ),
            child: const Text(
              "View Summary",
              style: TextStyle(
                color: Colors.tealAccent,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          )
        ],
      ),
    );
  }
}