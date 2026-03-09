import 'package:flutter/material.dart';

class StaffReportsScreen extends StatelessWidget {
  const StaffReportsScreen({super.key});

  static const Color _accent = Color(0xFF2979FF);
  static const Color _pending = Colors.orange;
  static const Color _uploaded = Colors.green;

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
                "Report Management",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Manage lab report processing",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                ),
              ),

              const SizedBox(height: 24),

              /// ===== SUMMARY =====
              Row(
                children: const [
                  _ModernSummaryCard(
                      label: "Pending",
                      count: "5",
                      color: _pending,
                      icon: Icons.hourglass_empty),
                  SizedBox(width: 14),
                  _ModernSummaryCard(
                      label: "Uploaded",
                      count: "12",
                      color: _uploaded,
                      icon: Icons.check_circle_outline),
                ],
              ),

              const SizedBox(height: 30),

              /// ===== PENDING =====
              _SectionTitle("Pending Reports"),

              const SizedBox(height: 16),

              const _ModernReportCard(
                patient: "Rahul Sharma",
                reportType: "Complete Blood Count (CBC)",
                collectedDate: "22 Mar 2025",
                status: "Pending",
              ),

              const SizedBox(height: 14),

              const _ModernReportCard(
                patient: "Amit Verma",
                reportType: "Liver Function Test",
                collectedDate: "23 Mar 2025",
                status: "Pending",
              ),

              const SizedBox(height: 30),

              /// ===== UPLOADED =====
              _SectionTitle("Uploaded Reports"),

              const SizedBox(height: 16),

              const _ModernReportCard(
                patient: "Priya Mehta",
                reportType: "Vitamin D Test",
                collectedDate: "18 Mar 2025",
                status: "Uploaded",
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

/// ================= SECTION TITLE =================

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        color: Colors.white.withOpacity(0.6),
        fontSize: 12,
        letterSpacing: 1.3,
      ),
    );
  }
}

/// ================= SUMMARY CARD =================

class _ModernSummaryCard extends StatelessWidget {
  final String label;
  final String count;
  final Color color;
  final IconData icon;

  const _ModernSummaryCard({
    required this.label,
    required this.count,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF14283C),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: 18),
            Text(
              count,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ================= MODERN REPORT CARD =================

class _ModernReportCard extends StatelessWidget {
  final String patient;
  final String reportType;
  final String collectedDate;
  final String status;

  const _ModernReportCard({
    required this.patient,
    required this.reportType,
    required this.collectedDate,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPending = status == "Pending";
    final Color statusColor =
    isPending ? Colors.orange : Colors.green;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF14283C),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [

          /// LEFT STATUS STRIP
          Container(
            width: 5,
            height: 140,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(18),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// HEADER ROW
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        patient,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.15),
                          borderRadius:
                          BorderRadius.circular(20),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(Icons.science,
                          size: 16, color: Colors.white54),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          reportType,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Collected: $collectedDate",
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: isPending
                            ? statusColor.withOpacity(0.2)
                            : const Color(0xFF2979FF)
                            .withOpacity(0.15),
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                      child: Text(
                        isPending
                            ? "Upload Result"
                            : "View Details",
                        style: TextStyle(
                          color: isPending
                              ? statusColor
                              : const Color(0xFF2979FF),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}