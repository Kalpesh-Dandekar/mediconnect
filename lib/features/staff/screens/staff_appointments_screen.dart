import 'package:flutter/material.dart';

class StaffAppointmentsScreen extends StatefulWidget {
  const StaffAppointmentsScreen({super.key});

  @override
  State<StaffAppointmentsScreen> createState() =>
      _StaffAppointmentsScreenState();
}

class _StaffAppointmentsScreenState
    extends State<StaffAppointmentsScreen> {

  String selectedFilter = "All";

  final List<Map<String, String>> appointments = [
    {
      "time": "09:30 AM",
      "name": "Rahul Sharma",
      "age": "34",
      "doctor": "Dr. Michael Smith",
      "dept": "Gastroenterology",
      "status": "Waiting",
    },
    {
      "time": "10:00 AM",
      "name": "Priya Mehta",
      "age": "29",
      "doctor": "Dr. Anita Sharma",
      "dept": "General Medicine",
      "status": "Completed",
    },
    {
      "time": "10:30 AM",
      "name": "Amit Verma",
      "age": "42",
      "doctor": "Dr. Michael Smith",
      "dept": "Gastroenterology",
      "status": "Cancelled",
    },
  ];

  List<Map<String, String>> get filteredAppointments {
    if (selectedFilter == "All") return appointments;
    return appointments
        .where((a) => a["status"] == selectedFilter)
        .toList();
  }

  int get waitingCount =>
      appointments.where((a) => a["status"] == "Waiting").length;

  int get completedCount =>
      appointments.where((a) => a["status"] == "Completed").length;

  int get cancelledCount =>
      appointments.where((a) => a["status"] == "Cancelled").length;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0C1B2A),
      child: SafeArea(
        child: Column(
          children: [

            /// ===== HEADER =====
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Today's Appointments",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${appointments.length} scheduled today",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            /// ===== SUMMARY STRIP =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _SummaryChip("Waiting", waitingCount, Colors.orange),
                  const SizedBox(width: 10),
                  _SummaryChip("Completed", completedCount, Colors.green),
                  const SizedBox(width: 10),
                  _SummaryChip("Cancelled", cancelledCount, Colors.red),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// ===== FILTER TABS =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildFilter("All"),
                  const SizedBox(width: 8),
                  _buildFilter("Waiting"),
                  const SizedBox(width: 8),
                  _buildFilter("Completed"),
                  const SizedBox(width: 8),
                  _buildFilter("Cancelled"),
                ],
              ),
            ),

            const SizedBox(height: 18),

            /// ===== LIST =====
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 90),
                itemCount: filteredAppointments.length,
                itemBuilder: (context, index) {
                  final appointment = filteredAppointments[index];
                  return _AppointmentCard(appointment: appointment);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilter(String label) {
    final active = selectedFilter == label;

    return GestureDetector(
      onTap: () => setState(() => selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active
              ? const Color(0xFF2979FF)
              : Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// ================= SUMMARY CHIP =================

class _SummaryChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _SummaryChip(this.label, this.count, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "$count $label",
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// ================= APPOINTMENT CARD =================

class _AppointmentCard extends StatelessWidget {
  final Map<String, String> appointment;

  const _AppointmentCard({required this.appointment});

  @override
  Widget build(BuildContext context) {
    final status = appointment["status"] ?? "Waiting";

    Color statusColor;
    bool isWaiting = false;

    switch (status) {
      case "Completed":
        statusColor = Colors.green;
        break;
      case "Cancelled":
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.orange;
        isWaiting = true;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isWaiting
            ? Colors.orange.withOpacity(0.07)
            : const Color(0xFF14283C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isWaiting
              ? Colors.orange.withOpacity(0.4)
              : Colors.white.withOpacity(0.05),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [

            /// TIME
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                appointment["time"] ?? "",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                ),
              ),
            ),

            const SizedBox(width: 14),

            /// DETAILS
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${appointment["name"]} (${appointment["age"]})",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    appointment["doctor"] ?? "",
                    style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70),
                  ),
                  Text(
                    appointment["dept"] ?? "",
                    style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white54),
                  ),
                ],
              ),
            ),

            /// STATUS + BUTTON
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
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
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2979FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "Open",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}