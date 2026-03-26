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
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 6),

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

            /// 🔥 SEARCH (FIXED STYLE)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.08),
                  ),
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

            const SizedBox(height: 14),

            /// 🔥 FILTER PILLS
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

            const SizedBox(height: 14),

            /// LIST
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: patientService.getPatients(),
                builder: (context, snapshot) {

                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final allPatients = snapshot.data!;

                  final searched = allPatients.where((p) {
                    final name = (p["name"] ?? "").toLowerCase();
                    final query = searchController.text.toLowerCase();
                    return name.contains(query);
                  }).toList();

                  final filtered = selectedFilter == "All"
                      ? searched
                      : searched
                      .where((p) => p["status"] == selectedFilter)
                      .toList();

                  if (filtered.isEmpty) {
                    return const Center(
                      child: Text(
                        "No patients found",
                        style: TextStyle(color: Colors.white54),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {

                      final p = filtered[index];

                      return _PatientCard(
                        id: p["id"] ?? "",
                        name: p["name"] ?? "",
                        age: p["age"].toString(),
                        lastVisit: p["lastVisit"] ?? "",
                        diagnosis: p["diagnosis"] ?? "",
                        status: p["status"] ?? "",
                        visitedToday: p["visitedToday"] ?? false,
                        appointmentId: p["appointmentId"] ?? "",
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

  /// FILTER
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
          alignment: Alignment.center,
          child: Text(
            label,
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
}

/// ================= CARD =================

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

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// HEADER
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFF00C2B2).withOpacity(0.2),
                child: Text(
                  name.isNotEmpty ? name[0] : "?",
                  style: const TextStyle(
                    color: Color(0xFF00C2B2),
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

              _chip(status),
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

          /// 🔥 BUTTON (MATCHED)
          GestureDetector(
            onTap: () {

              if (appointmentId.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("No appointment linked")),
                );
                return;
              }

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
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFF9F1C),
                    Color(0xFFFFB703),
                  ],
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                visitedToday
                    ? "Continue Consultation"
                    : "Start Consultation",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF00C2B2).withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF00C2B2),
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}