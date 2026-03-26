import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../services/patient/report_service.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final ReportService reportService = ReportService();

    return Container(
      color: const Color(0xFF0C1B2A),
      child: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: reportService.getPatientReports(),
          builder: (context, snapshot) {

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
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
                  style: TextStyle(color: Colors.white60),
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
                    "Clinical records & lab results overview",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// 🔥 SUMMARY (UPGRADED)
                  Row(
                    children: [
                      Expanded(child: _SummaryCard("Total", docs.length.toString())),
                      const SizedBox(width: 12),
                      Expanded(child: _SummaryCard("Pending", pending.length.toString())),
                      const SizedBox(width: 12),
                      Expanded(child: _SummaryCard("Available", available.length.toString())),
                    ],
                  ),

                  const SizedBox(height: 30),

                  /// PENDING
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

                  /// AVAILABLE
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

/// 🔥 SUMMARY CARD UPGRADED
class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryCard(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
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

/// 🔥 PENDING CARD UPGRADED
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
    status == "Processing" ? Colors.orangeAccent : Colors.blueAccent;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              _Chip(text: status, color: chipColor),
            ],
          ),

          const SizedBox(height: 10),

          Text("Given On: $givenOn",
              style: const TextStyle(color: Colors.white70, fontSize: 12)),

          Text("Expected: $expectedOn",
              style: const TextStyle(color: Colors.white70, fontSize: 12)),

          Text("Lab: $labName",
              style: const TextStyle(color: Colors.white54, fontSize: 12)),
        ],
      ),
    );
  }
}

/// 🔥 AVAILABLE CARD UPGRADED
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
    resultStatus == "Normal" ? Colors.greenAccent : Colors.redAccent;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

          Text("Uploaded: $uploadedOn",
              style: const TextStyle(color: Colors.white70, fontSize: 12)),

          Text("Doctor: $doctor",
              style: const TextStyle(color: Colors.white70, fontSize: 12)),

          const SizedBox(height: 6),

          Text(
            "Result: $resultStatus",
            style: TextStyle(
              color: indicatorColor,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          /// 🔥 CTA BUTTON
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFF9F1C),
                  Color(0xFFFFB703),
                ],
              ),
            ),
            child: const Text(
              "View Summary",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// CHIP
class _Chip extends StatelessWidget {
  final String text;
  final Color color;

  const _Chip({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}