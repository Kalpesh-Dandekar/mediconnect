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
      body: StreamBuilder<QuerySnapshot>(
        stream: _service.getAppointments(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: docs.length,
            itemBuilder: (context, index) {

              final data = docs[index].data() as Map<String, dynamic>;

              final appointment = {
                "id": docs[index].id,
                "patientId": (data["patientId"] ?? "").toString(),
                "name": (data["patientName"] ?? "Unknown").toString(),
                "doctor": (data["doctorName"] ?? "").toString(),
                "dept": (data["department"] ?? "").toString(),
                "time": (data["time"] ?? "--").toString(),
                "status": normalizeStatus((data["status"] ?? "Waiting").toString()),
              };

              return _AppointmentCard(
                appointment: appointment,
                service: _service,
              );
            },
          );
        },
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
        return Colors.green;
      case "Cancelled":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF14283C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [

          Text(
            widget.appointment["time"],
            style: const TextStyle(color: Colors.white70),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.appointment["name"],
                    style: const TextStyle(color: Colors.white)),
                Text(widget.appointment["doctor"],
                    style: const TextStyle(color: Colors.white54)),
              ],
            ),
          ),

          Column(
            children: [

              GestureDetector(
                onTap: cycleStatus,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: getColor().withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(color: getColor()),
                  ),
                ),
              ),

              const SizedBox(height: 6),

              ElevatedButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                      builder: (_) => StaffReportsScreen(
                        patientId: widget.appointment["patientId"],
                        patientName: widget.appointment["name"],
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                ),
                child: const Text("Upload", style: TextStyle(fontSize: 11)),
              ),
            ],
          )
        ],
      ),
    );
  }
}