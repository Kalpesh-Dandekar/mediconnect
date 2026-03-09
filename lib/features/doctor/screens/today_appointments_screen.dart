import 'package:flutter/material.dart';

class TodayAppointmentsScreen extends StatefulWidget {
  const TodayAppointmentsScreen({super.key});

  @override
  State<TodayAppointmentsScreen> createState() =>
      _TodayAppointmentsScreenState();
}

class _TodayAppointmentsScreenState
    extends State<TodayAppointmentsScreen> {
  String selectedFilter = "Waiting";

  final List<Map<String, dynamic>> appointments = [
    {
      "token": "12",
      "name": "Rahul Sharma",
      "age": "34",
      "time": "10:30 AM",
      "reason": "Gastric Pain",
      "status": "Waiting"
    },
    {
      "token": "13",
      "name": "Priya Mehta",
      "age": "29",
      "time": "10:45 AM",
      "reason": "Follow-up Visit",
      "status": "Completed"
    },
  ];

  List<Map<String, dynamic>> get filteredAppointments {
    return appointments
        .where((a) => a["status"] == selectedFilter)
        .toList();
  }

  int countByStatus(String status) {
    return appointments
        .where((a) => a["status"] == status)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0C1B2A),
      child: SafeArea(
        child: Column(
          children: [

            /// ===== HEADER =====
            Padding(
              padding:
              const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Today's Appointments",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight:
                      FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${filteredAppointments.length} ${selectedFilter == "Waiting" && filteredAppointments.length == 1 ? "Waiting Patient" : "$selectedFilter Patients"}",
                    style: TextStyle(
                      color:
                      Colors.white.withOpacity(0.6),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            /// subtle divider
            Divider(
              color: Colors.white.withOpacity(0.05),
              height: 1,
            ),

            const SizedBox(height: 12),

            /// ===== FILTER TABS =====
            Padding(
              padding:
              const EdgeInsets.symmetric(
                  horizontal: 20),
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
              child: filteredAppointments.isEmpty
                  ? _emptyState()
                  : ListView.builder(
                padding:
                const EdgeInsets
                    .fromLTRB(20, 0, 20, 90),
                itemCount:
                filteredAppointments.length,
                itemBuilder:
                    (context, index) {
                  final item =
                  filteredAppointments[
                  index];

                  return _AppointmentRow(
                    token: item["token"],
                    name: item["name"],
                    age: item["age"],
                    time: item["time"],
                    reason: item["reason"],
                    status: item["status"],
                  );
                },
              ),
            ),

            /// ===== SUMMARY FOOTER =====
            Container(
              padding:
              const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color:
                Colors.white.withOpacity(0.04),
                borderRadius:
                const BorderRadius.vertical(
                    top: Radius.circular(18)),
              ),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceAround,
                children: [
                  _summaryItem(
                      "Waiting",
                      countByStatus("Waiting"),
                      Colors.orange),
                  _summaryItem(
                      "In Progress",
                      countByStatus(
                          "In Consultation"),
                      Colors.blueAccent),
                  _summaryItem(
                      "Completed",
                      countByStatus("Completed"),
                      Colors.green),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilter(String label) {
    final bool active =
        selectedFilter == label;
    final int count = countByStatus(label);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedFilter = label;
          });
        },
        child: Column(
          children: [
            Row(
              mainAxisAlignment:
              MainAxisAlignment.center,
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
                const SizedBox(width: 6),
                Container(
                  padding:
                  const EdgeInsets
                      .symmetric(
                      horizontal: 6,
                      vertical: 2),
                  decoration: BoxDecoration(
                    color: active
                        ? Colors.white
                        .withOpacity(0.1)
                        : Colors.white
                        .withOpacity(0.05),
                    borderRadius:
                    BorderRadius.circular(10),
                  ),
                  child: Text(
                    count.toString(),
                    style:
                    const TextStyle(
                      fontSize: 11,
                      color:
                      Colors.white70,
                    ),
                  ),
                ),
              ],
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

  Widget _summaryItem(
      String label, int count, Color color) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            color: color,
            fontWeight:
            FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style:
          const TextStyle(
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
  final String token;
  final String name;
  final String age;
  final String time;
  final String reason;
  final String status;

  const _AppointmentRow({
    required this.token,
    required this.name,
    required this.age,
    required this.time,
    required this.reason,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
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
      margin:
      const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color:
        Colors.white.withOpacity(0.05),
        borderRadius:
        BorderRadius.circular(16),
      ),
      child: Row(
        children: [

          /// Vertical status strip
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
                    style:
                    const TextStyle(
                      color:
                      Colors.white,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    reason,
                    style:
                    const TextStyle(
                      fontSize: 12,
                      color:
                      Colors.white60,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style:
                    const TextStyle(
                      fontSize: 12,
                      color:
                      Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding:
            const EdgeInsets.only(
                right: 14),
            child: ElevatedButton(
              style:
              ElevatedButton.styleFrom(
                backgroundColor:
                statusColor,
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius
                      .circular(12),
                ),
              ),
              onPressed: () {},
              child: Text(
                status ==
                    "Completed"
                    ? "View"
                    : status ==
                    "In Consultation"
                    ? "Continue"
                    : "Start",
                style:
                const TextStyle(
                    color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}