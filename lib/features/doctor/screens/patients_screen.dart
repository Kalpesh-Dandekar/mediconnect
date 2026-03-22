import 'package:flutter/material.dart';
import '../../../services/doctor/patient_service.dart';
import 'consultation_screen.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  final TextEditingController searchController = TextEditingController();
  String selectedFilter = "All";

  final PatientService patientService = PatientService();

  static const Color accent = Color(0xFF00C2B2);

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
                    "Patients",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),

                  /// LIVE COUNT
                  StreamBuilder<List<Map<String, dynamic>>>(
                    stream: patientService.getPatients(),
                    builder: (context, snapshot) {
                      final count = snapshot.data?.length ?? 0;

                      return Text(
                        "$count registered patients",
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            /// SEARCH
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.white54),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: "Search patient...",
                          hintStyle: TextStyle(color: Colors.white38),
                          border: InputBorder.none,
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// FILTER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildFilter("All"),
                  _buildFilter("Active"),
                  _buildFilter("Follow-up"),
                ],
              ),
            ),

            const SizedBox(height: 15),

            /// PATIENT LIST
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: patientService.getPatients(),
                builder: (context, snapshot) {

                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final allPatients = snapshot.data!;

                  /// SEARCH
                  final searchedPatients = allPatients.where((p) {
                    final name = (p["name"] ?? "").toLowerCase();
                    final query = searchController.text.toLowerCase();
                    return name.contains(query);
                  }).toList();

                  /// FILTER
                  final filteredPatients = selectedFilter == "All"
                      ? searchedPatients
                      : searchedPatients
                      .where((p) => p["status"] == selectedFilter)
                      .toList();

                  if (filteredPatients.isEmpty) {
                    return const Center(
                      child: Text(
                        "No patients found",
                        style: TextStyle(color: Colors.white54),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    itemCount: filteredPatients.length,
                    itemBuilder: (context, index) {

                      final patient = filteredPatients[index];

                      return _PatientCard(
                        id: patient["id"] ?? "",
                        name: patient["name"] ?? "",
                        age: patient["age"].toString(),
                        lastVisit: patient["lastVisit"] ?? "",
                        diagnosis: patient["diagnosis"] ?? "",
                        status: patient["status"] ?? "",
                        visitedToday: patient["visitedToday"] ?? false,
                        appointmentId: patient["appointmentId"] ?? "",
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

  Widget _buildFilter(String label) {
    final bool active = selectedFilter == label;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedFilter = label),
        child: Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: active ? accent.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: active ? accent : Colors.white54,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

/// ================= PATIENT CARD =================

class _PatientCard extends StatelessWidget {
  final String id;
  final String name;
  final String age;
  final String lastVisit;
  final String diagnosis;
  final String status;
  final bool visitedToday;
  final String appointmentId;

  const _PatientCard({
    required this.id,
    required this.name,
    required this.age,
    required this.lastVisit,
    required this.diagnosis,
    required this.status,
    required this.visitedToday,
    required this.appointmentId,
  });

  static const Color accent = Color(0xFF00C2B2);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              CircleAvatar(
                backgroundColor: accent.withOpacity(0.2),
                child: Text(
                  name.isNotEmpty ? name[0] : "?",
                  style: const TextStyle(
                    color: accent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(color: Colors.white)),
                    Text(
                      "$id • Age: ${age.isEmpty ? "-" : age}",
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                    color: accent,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            "Diagnosis: $diagnosis",
            style: const TextStyle(color: Colors.white70),
          ),

          const SizedBox(height: 4),

          Text(
            "Last Visit: $lastVisit",
            style: const TextStyle(color: Colors.white54),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
              ),
              onPressed: () {

                if (appointmentId.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("No appointment linked")),
                  );
                  return;
                }

                /// 🔥 DEBUG (CHECK IN CONSOLE)
                print("Opening Consultation with ID: $appointmentId");

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ConsultationScreen(
                      patientId: id,
                      patientName: name,
                      appointmentId: appointmentId,
                    ),
                  ),
                );
              },
              child: Text(
                visitedToday
                    ? "Continue Consultation"
                    : "Start Consultation",
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}