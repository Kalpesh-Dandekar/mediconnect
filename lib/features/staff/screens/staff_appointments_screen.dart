import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mediconnect/services/staff/staff_appointment_service.dart';
import 'package:mediconnect/features/staff/screens/staff_reports_screen.dart';

class StaffAppointmentsScreen extends StatefulWidget {
  const StaffAppointmentsScreen({super.key});

  @override
  State<StaffAppointmentsScreen> createState() =>
      _StaffAppointmentsScreenState();
}

class _StaffAppointmentsScreenState extends State<StaffAppointmentsScreen> {

  final StaffAppointmentService _service = StaffAppointmentService();

  String normalizeStatus(String raw) {
    switch (raw.toLowerCase()) {
      case "pending":
      case "waiting":
        return "Waiting";
      case "completed":
        return "Completed";
      case "cancelled":
        return "Cancelled";
      default:
        return "Waiting";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C1B2A),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔥 HEADER ADDED
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Appointments",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Manage and update appointments",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),

            /// LIST
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _service.getAppointments(),
                builder: (context, snapshot) {

                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs;

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 110),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {

                      final data =
                      docs[index].data() as Map<String, dynamic>;

                      final appointment = {
                        "id": docs[index].id,
                        "patientId": (data["patientId"] ?? "").toString(),
                        "name": (data["patientName"] ?? "Unknown").toString(),
                        "doctor": (data["doctorName"] ?? "").toString(),
                        "dept": (data["department"] ?? "").toString(),
                        "time": (data["time"] ?? "--").toString(),
                        "status": normalizeStatus(
                            (data["status"] ?? "Waiting").toString()),
                      };

                      return _AppointmentCard(
                        appointment: appointment,
                        service: _service,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppointmentCard extends StatefulWidget {
  final Map<String, dynamic> appointment;
  final StaffAppointmentService service;

  const _AppointmentCard({
    required this.appointment,
    required this.service,
  });

  @override
  State<_AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<_AppointmentCard> {

  late String status;

  final List<String> flow = ["Waiting", "Completed", "Cancelled"];

  @override
  void initState() {
    super.initState();
    status = widget.appointment["status"];
  }

  void cycleStatus() async {
    int i = flow.indexOf(status);
    String next = flow[(i + 1) % flow.length];

    setState(() => status = next);

    await widget.service.updateStatus(
      appointmentId: widget.appointment["id"],
      status: next,
    );
  }

  Color getColor() {
    switch (status) {
      case "Completed":
        return Colors.greenAccent;
      case "Cancelled":
        return Colors.redAccent;
      default:
        return Colors.orangeAccent;
    }
  }

  @override
  Widget build(BuildContext context) {

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

          /// TIME
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              widget.appointment["time"],
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ),

          const SizedBox(width: 12),

          /// INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  widget.appointment["name"],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  widget.appointment["doctor"],
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          /// ACTIONS
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [

              GestureDetector(
                onTap: cycleStatus,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: getColor().withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: getColor(),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF9F1C), Color(0xFFFFB703)],
                  ),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (_) => StaffReportsScreen(
                          patientId:
                          widget.appointment["patientId"],
                          patientName:
                          widget.appointment["name"],
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "Upload",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}