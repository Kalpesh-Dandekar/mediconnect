import 'package:flutter/material.dart';

class RelativeReportsScreen extends StatelessWidget {
  const RelativeReportsScreen({super.key});

  static const Color _accent = Color(0xFF8E44AD);

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

              /// ================= HEADER =================
              const Text(
                "Reports",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                "Monitoring: Rahul Sharma",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),

              const SizedBox(height: 26),

              /// ================= SUMMARY CARDS =================
              Row(
                children: const [
                  Expanded(
                    child: _ReportSummaryCard(
                      title: "Total",
                      value: "6",
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: _ReportSummaryCard(
                      title: "Pending",
                      value: "2",
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: _ReportSummaryCard(
                      title: "Available",
                      value: "4",
                      color: Colors.green,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// ================= PENDING =================
              _SectionTitle("Pending Reports"),

              const SizedBox(height: 14),

              const _ReportTile(
                title: "Liver Function Test",
                date: "Collected: 22 Mar 2025",
                status: "Pending",
              ),

              const SizedBox(height: 30),

              /// ================= AVAILABLE =================
              _SectionTitle("Available Reports"),

              const SizedBox(height: 14),

              const _ReportTile(
                title: "Complete Blood Count (CBC)",
                date: "Uploaded: 18 Mar 2025",
                status: "Uploaded",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ================= SUMMARY CARD =================

class _ReportSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _ReportSummaryCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF14283C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ],
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
        letterSpacing: 1.2,
      ),
    );
  }
}

/// ================= REPORT TILE =================

class _ReportTile extends StatelessWidget {
  final String title;
  final String date;
  final String status;

  const _ReportTile({
    required this.title,
    required this.date,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor =
    status == "Uploaded" ? Colors.green : Colors.orange;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF14283C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: statusColor.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [

          /// LEFT SIDE
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),

          /// RIGHT SIDE
          if (status == "Uploaded")
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: statusColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {},
              child: const Text(
                "View",
                style: TextStyle(color: Colors.black),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
        ],
      ),
    );
  }
}