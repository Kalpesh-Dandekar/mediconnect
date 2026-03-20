import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../services/doctor/emergency_service.dart'; // ✅ UPDATED

class DoctorEmergencyScreen extends StatelessWidget {
  const DoctorEmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DoctorEmergencyService emergencyService = DoctorEmergencyService(); // ✅ UPDATED

    return Container(
      color: const Color(0xFF0C1B2A),
      child: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: emergencyService.getActiveEmergencies(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final docs = snapshot.data!.docs;

            if (docs.isEmpty) {
              return const Center(
                child: Text(
                  "No active emergencies",
                  style: TextStyle(color: Colors.white70),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final doc = docs[index];
                final data = doc.data() as Map<String, dynamic>;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _EmergencyCard(
                    id: doc.id,
                    type: data["type"] ?? "",
                    status: data["status"] ?? "",
                    patientName: data["patientName"] ?? "Unknown",
                    createdAt: data["createdAt"],
                    assignedTo: data["assignedTo"] ?? "",
                    onAccept: () async {
                      await emergencyService.acceptEmergency(doc.id);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Emergency Accepted")),
                      );
                    },
                    onComplete: () async {
                      await emergencyService.completeEmergency(doc.id);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Marked Completed")),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _EmergencyCard extends StatelessWidget {
  final String id;
  final String type;
  final String status;
  final String patientName;
  final Timestamp? createdAt;
  final String assignedTo;
  final VoidCallback onAccept;
  final VoidCallback onComplete;

  const _EmergencyCard({
    required this.id,
    required this.type,
    required this.status,
    required this.patientName,
    required this.createdAt,
    required this.assignedTo,
    required this.onAccept,
    required this.onComplete,
  });

  Color _getColor() {
    switch (type) {
      case "ambulance":
        return Colors.redAccent;
      case "doctor":
        return Colors.tealAccent;
      case "caregiver":
        return Colors.orangeAccent;
      default:
        return Colors.grey;
    }
  }

  String _getTitle() {
    switch (type) {
      case "ambulance":
        return "Ambulance Request";
      case "doctor":
        return "Doctor Assistance";
      case "caregiver":
        return "Caregiver Alert";
      default:
        return "Emergency";
    }
  }

  String _formatTime() {
    if (createdAt == null) return "--";
    final dt = createdAt!.toDate();
    return "${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();

    final bool isAccepted = status == "accepted";
    final bool isCompleted = status == "completed";

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF14283C),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _getTitle(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  type.toUpperCase(),
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            "Patient: $patientName",
            style: const TextStyle(color: Colors.white),
          ),

          const SizedBox(height: 6),

          Text(
            "Time: ${_formatTime()}",
            style: const TextStyle(color: Colors.white60, fontSize: 12),
          ),

          const SizedBox(height: 6),

          Text(
            "Status: $status",
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),

          const SizedBox(height: 14),

          /// BUTTONS
          if (!isAccepted && !isCompleted)
            GestureDetector(
              onTap: onAccept,
              child: _button(color, "ACCEPT"),
            ),

          if (isAccepted && !isCompleted)
            GestureDetector(
              onTap: onComplete,
              child: _button(Colors.greenAccent, "COMPLETE"),
            ),

          if (isCompleted)
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: const Text(
                "COMPLETED",
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _button(Color color, String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}