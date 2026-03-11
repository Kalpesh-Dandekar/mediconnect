import 'package:flutter/material.dart';
import '../../../services/patient/appointment_service.dart';

class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({super.key});

  @override
  State<BookAppointmentScreen> createState() =>
      _BookAppointmentScreenState();
}

class _BookAppointmentScreenState
    extends State<BookAppointmentScreen> {

  final TextEditingController doctorController = TextEditingController();

  String? selectedDepartment;
  DateTime? selectedDate;
  String? selectedSlot;

  final List<String> departments = [
    "Cardiology",
    "Dermatology",
    "Gastroenterology",
    "Orthopedics",
  ];

  final List<String> timeSlots = [
    "09:00 AM",
    "10:00 AM",
    "11:30 AM",
    "02:00 PM",
    "04:30 PM",
  ];

  List<DateTime> get next7Days =>
      List.generate(7, (i) => DateTime.now().add(Duration(days: i)));

  bool get isValid =>
      selectedDepartment != null &&
          doctorController.text.isNotEmpty &&
          selectedDate != null &&
          selectedSlot != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C1B2A),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0C1B2A),
        elevation: 0,
        title: const Text(
          "Book Appointment",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// ================= DEPARTMENT =================
              const _Label("Department"),
              const SizedBox(height: 12),

              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: departments.map((dept) {
                  final selected =
                      selectedDepartment == dept;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDepartment = dept;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF14283C),
                        borderRadius:
                        BorderRadius.circular(14),
                        border: Border.all(
                          color: selected
                              ? Colors.tealAccent
                              : Colors.white
                              .withOpacity(0.05),
                        ),
                      ),
                      child: Text(
                        dept,
                        style: TextStyle(
                          color: selected
                              ? Colors.tealAccent
                              : Colors.white70,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 28),

              /// ================= DOCTOR INPUT =================
              const _Label("Doctor"),
              const SizedBox(height: 12),

              TextField(
                controller: doctorController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Enter doctor's name",
                  hintStyle:
                  const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: const Color(0xFF14283C),
                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: const Icon(
                    Icons.search,
                    color: Colors.white38,
                  ),
                ),
                onChanged: (_) {
                  setState(() {});
                },
              ),

              const SizedBox(height: 28),

              /// ================= DATE =================
              const _Label("Date"),
              const SizedBox(height: 12),

              SizedBox(
                height: 70,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: next7Days.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final date = next7Days[index];
                    final selected =
                        selectedDate?.day == date.day;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDate = date;
                        });
                      },
                      child: Container(
                        width: 65,
                        decoration: BoxDecoration(
                          color:
                          const Color(0xFF14283C),
                          borderRadius:
                          BorderRadius.circular(14),
                          border: Border.all(
                            color: selected
                                ? Colors.tealAccent
                                : Colors.white
                                .withOpacity(0.05),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Text(
                              "${date.day}",
                              style: TextStyle(
                                color: selected
                                    ? Colors.tealAccent
                                    : Colors.white,
                                fontWeight:
                                FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _month(date.month),
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 28),

              /// ================= TIME =================
              const _Label("Time Slot"),
              const SizedBox(height: 12),

              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: timeSlots.map((slot) {
                  final selected =
                      selectedSlot == slot;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedSlot = slot;
                      });
                    },
                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF14283C),
                        borderRadius:
                        BorderRadius.circular(12),
                        border: Border.all(
                          color: selected
                              ? Colors.tealAccent
                              : Colors.white
                              .withOpacity(0.05),
                        ),
                      ),
                      child: Text(
                        slot,
                        style: TextStyle(
                          color: selected
                              ? Colors.tealAccent
                              : Colors.white70,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 40),

              /// ================= CONFIRM =================
              GestureDetector(
                onTap: isValid
                    ? () async {
                  try {

                    await AppointmentService().bookAppointment(
                      doctorName: doctorController.text.trim(),
                      department: selectedDepartment!,
                      date: selectedDate!,
                      timeSlot: selectedSlot!,
                    );

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content:
                        Text("Appointment Confirmed"),
                      ),
                    );

                    Navigator.pop(context);

                  } catch (e) {

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                      ),
                    );

                  }
                }
                    : null,
                child: Container(
                  width: double.infinity,
                  padding:
                  const EdgeInsets.symmetric(
                      vertical: 16),
                  decoration: BoxDecoration(
                    color: isValid
                        ? Colors.tealAccent
                        : Colors.tealAccent
                        .withOpacity(0.3),
                    borderRadius:
                    BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text(
                      "Confirm Appointment",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _month(int m) {
    const months = [
      "Jan","Feb","Mar","Apr","May","Jun",
      "Jul","Aug","Sep","Oct","Nov","Dec"
    ];
    return months[m - 1];
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        color: Colors.white54,
        fontSize: 12,
        letterSpacing: 1.3,
      ),
    );
  }
}