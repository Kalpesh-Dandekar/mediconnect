import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../services/patient/appointment_service.dart';
import 'book_appointment_screen.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final appointmentService = AppointmentService();

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
                "Appointments",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Consultation history & scheduling",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),

              const SizedBox(height: 28),

              /// ========================
              /// BOOK APPOINTMENT
              /// ========================
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const BookAppointmentScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF1C3A52),
                        Color(0xFF14283C),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.tealAccent.withOpacity(0.4),
                    ),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.add_circle_outline,
                          color: Colors.tealAccent),
                      SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          "Book New Appointment",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios,
                          color: Colors.white38, size: 16),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              /// ========================
              /// UPCOMING APPOINTMENTS
              /// ========================
              const Text(
                "UPCOMING",
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 1.5,
                  color: Colors.white54,
                ),
              ),

              const SizedBox(height: 14),

              StreamBuilder<QuerySnapshot>(
                stream: appointmentService.getPatientAppointments(),
                builder: (context, snapshot) {

                  /// Loading state
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  /// No data
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text(
                      "No appointments yet",
                      style: TextStyle(color: Colors.white60),
                    );
                  }

                  final appointments = snapshot.data!.docs;

                  return Column(
                    children: appointments.map((doc) {

                      final data = doc.data() as Map<String, dynamic>;

                      final doctor = data["doctorName"] ?? "";
                      final department = data["department"] ?? "";
                      final time = data["timeSlot"] ?? "";
                      final status = (data["status"] ?? "pending").toString();

                      /// Convert Firestore Timestamp → Date
                      final Timestamp timestamp = data["date"];
                      final DateTime dateTime = timestamp.toDate();
                      final date =
                          "${dateTime.day}/${dateTime.month}/${dateTime.year}";

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFF13273B),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.tealAccent.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  doctor,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                _StatusChip(status: status),
                              ],
                            ),

                            const SizedBox(height: 6),

                            Text(
                              "$department Specialist",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),

                            const SizedBox(height: 12),

                            Row(
                              children: [
                                const Icon(Icons.calendar_month,
                                    color: Colors.tealAccent, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  "$date • $time",
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

/// ========================
/// STATUS CHIP
/// ========================
class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {

    Color color;

    switch (status.toLowerCase()) {
      case "confirmed":
        color = Colors.greenAccent;
        break;
      case "completed":
        color = Colors.blueAccent;
        break;
      case "pending":
        color = Colors.orangeAccent;
        break;
      default:
        color = Colors.redAccent;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}