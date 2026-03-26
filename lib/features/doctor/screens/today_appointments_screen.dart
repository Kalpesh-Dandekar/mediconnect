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

            /// HEADER
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
                    "Live patient queue",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// 🔥 FILTER PILLS
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

            /// LIST
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
                      "token": data["token"]?.toString() ?? "",
                      "name": data["patientName"] ?? "",
                      "age": data["age"]?.toString() ?? "",
                      "time": data["timeSlot"] ?? "--",
                      "reason": data["reason"] ?? "",
                      "status": data["status"] ?? "Waiting",
                    };
                  }).toList();

                  final filtered = appointments
                      .where((a) =>
                  a["status"] == selectedFilter)
                      .toList();

                  if (filtered.isEmpty) return _emptyState();

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                        20, 0, 20, 90),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {

                      final item = filtered[index];

                      return _AppointmentCard(
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

            /// FOOTER
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: const BorderRadius.vertical(
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

  /// 🔥 FILTER PILL
  Widget _buildFilter(String label) {
    final active = selectedFilter == label;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedFilter = label),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active
                ? Colors.white.withOpacity(0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: active ? Colors.white : Colors.white54,
              fontWeight:
              active ? FontWeight.w600 : FontWeight.w400,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Text(
        "No patients in $selectedFilter queue.",
        style: const TextStyle(color: Colors.white54),
      ),
    );
  }

  Widget _summaryItem(String label, Color color) {
    return Column(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration:
          BoxDecoration(color: color, shape: BoxShape.circle),
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

/// 🔥 NEW CARD
class _AppointmentCard extends StatelessWidget {

  final String id;
  final String token;
  final String name;
  final String age;
  final String time;
  final String reason;
  final String status;

  const _AppointmentCard({
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

    final service = DoctorAppointmentService();

    Color color;

    switch (status) {
      case "Waiting":
        color = Colors.orange;
        break;
      case "In Consultation":
        color = Colors.blueAccent;
        break;
      default:
        color = Colors.green;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: Row(
        children: [

          /// TOKEN
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withOpacity(0.2),
            child: Text(
              token,
              style: TextStyle(color: color),
            ),
          ),

          const SizedBox(width: 14),

          /// DETAILS
          Expanded(
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
                    fontSize: 11,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),

          /// BUTTON
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
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
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}