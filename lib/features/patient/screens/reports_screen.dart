import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0C1B2A),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// ===== HEADER =====
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

              /// ================= SUMMARY SECTION =================
              Row(
                children: const [
                  Expanded(
                    child: _SummaryCard(
                      label: "Total",
                      value: "8",
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _SummaryCard(
                      label: "Pending",
                      value: "2",
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _SummaryCard(
                      label: "Available",
                      value: "6",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// ================= PENDING REPORTS =================
              const _SectionTitle("PENDING REPORTS"),
              const SizedBox(height: 16),

              const _PendingReportCard(
                testName: "Complete Blood Count (CBC)",
                givenOn: "20 Mar 2025",
                expectedOn: "23 Mar 2025",
                labName: "City Diagnostics Lab",
                status: "Processing",
              ),

              const SizedBox(height: 14),

              const _PendingReportCard(
                testName: "Vitamin D Level",
                givenOn: "18 Mar 2025",
                expectedOn: "22 Mar 2025",
                labName: "HealthPlus Lab",
                status: "Ready Soon",
              ),

              const SizedBox(height: 30),

              /// ================= AVAILABLE REPORTS =================
              const _SectionTitle("AVAILABLE REPORTS"),
              const SizedBox(height: 16),

              const _AvailableReportCard(
                testName: "Liver Function Test",
                uploadedOn: "15 Mar 2025",
                doctor: "Dr. Michael Smith",
                resultStatus: "Normal",
              ),

              const SizedBox(height: 14),

              const _AvailableReportCard(
                testName: "Thyroid Profile",
                uploadedOn: "02 Mar 2025",
                doctor: "Dr. Anita Sharma",
                resultStatus: "Attention Required",
              ),

              const SizedBox(height: 40),
            ],
          ),
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

/// ================= SUMMARY CARD =================
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
          vertical: 18, horizontal: 12),
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

/// ================= PENDING REPORT CARD =================
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
                    vertical: 4),
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
              )
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

/// ================= AVAILABLE REPORT CARD =================
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
              )
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
                vertical: 8),
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