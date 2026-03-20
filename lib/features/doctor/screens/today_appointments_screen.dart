import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../services/doctor/appointment_service.dart';

class TodayAppointmentsScreen extends StatefulWidget {
  const TodayAppointmentsScreen({super.key});

  @override
  State<TodayAppointmentsScreen> createState() =>
      _TodayAppointmentsScreenState();
}

class _TodayAppointmentsScreenState
    extends State<TodayAppointmentsScreen> {

  String selectedFilter = "Waiting";

  final DoctorAppointmentService service =
  DoctorAppointmentService();

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
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Live appointments",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            Divider(
              color: Colors.white.withOpacity(0.05),
              height: 1,
            ),

            const SizedBox(height: 12),

            /// ===== FILTER TABS =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildFilter("Waiting"),
                  _buildFilter("In Consultation"),
                  _buildFilter("Completed"),
                ],
              ),
            ),

            const SizedBox(height: 15),

            /// ===== LIST =====
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: service.getTodayAppointments(),
                builder: (context, snapshot) {

                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final docs = snapshot.data!.docs;

                  final appointments = docs.map((doc) {
                    final data =
                    doc.data() as Map<String, dynamic>;

                    return {
                      "id": doc.id,
                      "token":
                      data["token"]?.toString() ?? "",
                      "name":
                      data["patientName"] ?? "",
                      "age":
                      data["age"]?.toString() ?? "",
                      "time": data["timeSlot"] ?? "--", // ✅ FIXED
                      "reason":
                      data["reason"] ?? "",
                      "status":
                      data["status"] ?? "Waiting",
                    };
                  }).toList();

                  final filteredAppointments =
                  appointments
                      .where((a) =>
                  a["status"] == selectedFilter)
                      .toList();

                  if (filteredAppointments.isEmpty) {
                    return _emptyState();
                  }

                  return ListView.builder(
                    padding:
                    const EdgeInsets.fromLTRB(
                        20, 0, 20, 90),
                    itemCount:
                    filteredAppointments.length,
                    itemBuilder: (context, index) {

                      final item =
                      filteredAppointments[index];

                      return _AppointmentRow(
                        id: item["id"],
                        token: item["token"],
                        name: item["name"],
                        age: item["age"],
                        time: item["time"],
                        reason: item["reason"],
                        status: item["status"],
                      );
                    },
                  );
                },
              ),
            ),

            /// ===== FOOTER =====
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius:
                const BorderRadius.vertical(
                    top: Radius.circular(18)),
              ),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceAround,
                children: [
                  _summaryItem("Waiting", Colors.orange),
                  _summaryItem("In Progress", Colors.blueAccent),
                  _summaryItem("Completed", Colors.green),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// FILTER UI
  Widget _buildFilter(String label) {
    final bool active = selectedFilter == label;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedFilter = label;
          });
        },
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: active
                    ? Colors.white
                    : Colors.white54,
                fontWeight: active
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
            ),
            const SizedBox(height: 6),
            if (active)
              Container(
                height: 2,
                width: 60,
                color: Colors.white,
              ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Text(
        "No patients in $selectedFilter queue.",
        style: const TextStyle(
          color: Colors.white54,
        ),
      ),
    );
  }

  Widget _summaryItem(String label, Color color) {
    return Column(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

/// ===============================
/// APPOINTMENT ROW
/// ===============================

class _AppointmentRow extends StatelessWidget {

  final String id;
  final String token;
  final String name;
  final String age;
  final String time;
  final String reason;
  final String status;

  const _AppointmentRow({
    required this.id,
    required this.token,
    required this.name,
    required this.age,
    required this.time,
    required this.reason,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {

    final DoctorAppointmentService service =
    DoctorAppointmentService();

    Color statusColor;

    switch (status) {
      case "Waiting":
        statusColor = Colors.orange;
        break;
      case "In Consultation":
        statusColor = Colors.blueAccent;
        break;
      default:
        statusColor = Colors.green;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [

          Container(
            width: 4,
            height: 80,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius:
              const BorderRadius.horizontal(
                  left: Radius.circular(16)),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(
                  vertical: 14),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    "$name ($age)",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    reason,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white60,
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
          ),

          Padding(
            padding:
            const EdgeInsets.only(right: 14),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: statusColor,
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {

                if (status == "Waiting") {
                  await service.startConsultation(id);
                } else if (status == "In Consultation") {
                  await service.completeConsultation(id);
                }
              },
              child: Text(
                status == "Completed"
                    ? "Done"
                    : status == "In Consultation"
                    ? "Continue"
                    : "Start",
                style: const TextStyle(
                    color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}