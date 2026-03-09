import 'package:flutter/material.dart';

class RelativeMedicationsScreen extends StatelessWidget {
  const RelativeMedicationsScreen({super.key});

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
                "Today's Medications",
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

              /// ================= PROGRESS SUMMARY =================
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF14283C),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "Today's Completion",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 12),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: 0.66,
                        minHeight: 6,
                        backgroundColor: Colors.white10,
                        color: _accent,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "2 of 3 doses taken",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              /// ================= MED LIST =================
              _SectionTitle("Completed / Missed"),

              const SizedBox(height: 14),

              const _MedicationTile(
                name: "Pantoprazole 40mg",
                time: "08:00 AM",
                status: "Taken",
              ),

              const SizedBox(height: 12),

              const _MedicationTile(
                name: "Vitamin D3",
                time: "02:00 PM",
                status: "Missed",
              ),

              const SizedBox(height: 30),

              /// ================= UPCOMING =================
              _SectionTitle("Upcoming"),

              const SizedBox(height: 14),

              const _MedicationTile(
                name: "Calcium Tablet",
                time: "08:00 PM",
                status: "Upcoming",
              ),
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
        letterSpacing: 1.2,
      ),
    );
  }
}

/// ================= MEDICATION TILE =================

class _MedicationTile extends StatelessWidget {
  final String name;
  final String time;
  final String status;

  const _MedicationTile({
    required this.name,
    required this.time,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;

    switch (status) {
      case "Taken":
        statusColor = Colors.green;
        break;
      case "Missed":
        statusColor = Colors.redAccent;
        break;
      default:
        statusColor = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF14283C),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: statusColor.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [

          /// STATUS DOT
          Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),

          /// STATUS TEXT
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    );
  }
}