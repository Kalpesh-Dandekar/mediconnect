import 'package:flutter/material.dart';
import 'book_appointment_screen.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              /// 1️⃣ BOOK APPOINTMENT
              /// ========================
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      const BookAppointmentScreen(),
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
              /// 2️⃣ UPCOMING APPOINTMENT
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

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF13273B),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: Colors.tealAccent.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Dr. Michael Smith",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        _StatusChip(status: "Confirmed"),
                      ],
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      "Gastroenterologist • 12 yrs exp.",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: const [
                        Icon(Icons.calendar_month,
                            color: Colors.tealAccent, size: 16),
                        SizedBox(width: 8),
                        Text(
                          "12 April 2025 • 10:30 AM",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: const [
                        Icon(Icons.location_on_outlined,
                            color: Colors.white38, size: 16),
                        SizedBox(width: 8),
                        Text(
                          "City Care Hospital",
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      "In 2 days",
                      style: TextStyle(
                        color: Colors.tealAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              /// ========================
              /// 3️⃣ PAST APPOINTMENTS
              /// ========================
              const Text(
                "PAST CONSULTATIONS",
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 1.5,
                  color: Colors.white54,
                ),
              ),
              const SizedBox(height: 14),

              _PastAppointmentCard(
                doctor: "Dr. Michael Smith",
                date: "24 March 2025",
                diagnosis: "Acute Gastritis",
                prescription: "Pantoprazole 40mg",
              ),

              const SizedBox(height: 12),

              _PastAppointmentCard(
                doctor: "Dr. Anita Sharma",
                date: "10 February 2025",
                diagnosis: "Vitamin D Deficiency",
                prescription: "Vitamin D3 60K",
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
/// PAST APPOINTMENT CARD
/// ========================
class _PastAppointmentCard extends StatelessWidget {
  final String doctor;
  final String date;
  final String diagnosis;
  final String prescription;

  const _PastAppointmentCard({
    required this.doctor,
    required this.date,
    required this.diagnosis,
    required this.prescription,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF14283C),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
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
              const _StatusChip(status: "Completed"),
            ],
          ),

          const SizedBox(height: 6),

          Text(
            date,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            "Diagnosis: $diagnosis",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            "Prescription: $prescription",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ],
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

    switch (status) {
      case "Confirmed":
        color = Colors.greenAccent;
        break;
      case "Completed":
        color = Colors.blueAccent;
        break;
      case "Pending":
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
        borderRadius:
        BorderRadius.circular(20),
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