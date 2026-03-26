import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  String? selectedDoctorId;

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
          selectedDoctorId != null &&
          selectedDate != null &&
          selectedSlot != null;

  Future<void> _selectDoctor(String name) async {

    final query = await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: name)
        .where("role", isEqualTo: "Doctor")
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      selectedDoctorId = null;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Doctor not found")),
      );
    } else {
      final doc = query.docs.first;
      selectedDoctorId = doc.id;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Selected: ${doc["name"]}")),
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF0C1B2A),

      /// 🔥 FIXED APPBAR
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C1B2A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Book Appointment",
          style: TextStyle(
            color: Colors.white,
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

              /// 🔥 DEPARTMENT
              const _Label("Department"),
              const SizedBox(height: 12),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: departments.map((dept) {
                  final selected = selectedDepartment == dept;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDepartment = dept;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: selected
                            ? Colors.tealAccent.withOpacity(0.15)
                            : Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: selected
                              ? Colors.tealAccent
                              : Colors.white.withOpacity(0.06),
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

              /// 🔥 DOCTOR INPUT
              const _Label("Doctor"),
              const SizedBox(height: 12),

              TextField(
                controller: doctorController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Enter doctor's name",
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.06),
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search, color: Colors.white38),
                    onPressed: () {
                      _selectDoctor(doctorController.text.trim());
                    },
                  ),
                ),
              ),

              const SizedBox(height: 28),

              /// 🔥 DATE
              const _Label("Date"),
              const SizedBox(height: 12),

              SizedBox(
                height: 80,
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
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 70,
                        decoration: BoxDecoration(
                          color: selected
                              ? Colors.tealAccent.withOpacity(0.15)
                              : Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: selected
                                ? Colors.tealAccent
                                : Colors.white.withOpacity(0.06),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${date.day}",
                              style: TextStyle(
                                color: selected
                                    ? Colors.tealAccent
                                    : Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
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

              /// 🔥 TIME SLOT
              const _Label("Time Slot"),
              const SizedBox(height: 12),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: timeSlots.map((slot) {
                  final selected = selectedSlot == slot;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedSlot = slot;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: selected
                            ? Colors.tealAccent.withOpacity(0.15)
                            : Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selected
                              ? Colors.tealAccent
                              : Colors.white.withOpacity(0.06),
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

              /// 🔥 CONFIRM BUTTON
              GestureDetector(
                onTap: isValid
                    ? () async {

                  await AppointmentService().bookAppointment(
                    doctorName: doctorController.text.trim(),
                    department: selectedDepartment!,
                    date: selectedDate!,
                    timeSlot: selectedSlot!,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Appointment Confirmed"),
                    ),
                  );

                  Navigator.pop(context);
                }
                    : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: isValid
                        ? const LinearGradient(
                      colors: [
                        Color(0xFFFF9F1C),
                        Color(0xFFFFB703),
                      ],
                    )
                        : null,
                    color: !isValid
                        ? Colors.white.withOpacity(0.08)
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Confirm Appointment",
                    style: TextStyle(
                      color: isValid ? Colors.black : Colors.white54,
                      fontWeight: FontWeight.w600,
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