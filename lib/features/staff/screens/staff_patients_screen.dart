import 'package:flutter/material.dart';

class StaffPatientsScreen extends StatefulWidget {
  const StaffPatientsScreen({super.key});

  @override
  State<StaffPatientsScreen> createState() =>
      _StaffPatientsScreenState();
}

class _StaffPatientsScreenState
    extends State<StaffPatientsScreen> {

  final TextEditingController searchController =
  TextEditingController();

  final List<Map<String, String>> patients = [
    {
      "id": "P-1021",
      "name": "Rahul Sharma",
      "age": "34",
      "phone": "9876543210",
      "dept": "Gastroenterology",
      "status": "Active",
    },
    {
      "id": "P-1044",
      "name": "Priya Mehta",
      "age": "29",
      "phone": "9988776655",
      "dept": "General Medicine",
      "status": "Follow-up",
    },
    {
      "id": "P-1088",
      "name": "Amit Verma",
      "age": "42",
      "phone": "9123456780",
      "dept": "Orthopedics",
      "status": "Inactive",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C1B2A),

      /// Floating Add Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2979FF),
        onPressed: () {},
        child: const Icon(Icons.add),
      ),

      body: SafeArea(
        child: Column(
          children: [

            /// ===== HEADER =====
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Patient Records",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${patients.length} registered patients",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            /// ===== SEARCH =====
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius:
                  BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search,
                        color: Colors.white54),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        style: const TextStyle(
                            color: Colors.white),
                        decoration: const InputDecoration(
                          hintText:
                          "Search by name or ID",
                          hintStyle: TextStyle(
                              color: Colors.white38),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            /// ===== LIST =====
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(
                    20, 0, 20, 100),
                itemCount: patients.length,
                itemBuilder: (context, index) {
                  final patient = patients[index];
                  return _PatientCard(
                    id: patient["id"] ?? "",
                    name: patient["name"] ?? "",
                    age: patient["age"] ?? "",
                    phone: patient["phone"] ?? "",
                    dept: patient["dept"] ?? "",
                    status: patient["status"] ?? "",
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

class _PatientCard extends StatelessWidget {
  final String id;
  final String name;
  final String age;
  final String phone;
  final String dept;
  final String status;

  const _PatientCard({
    required this.id,
    required this.name,
    required this.age,
    required this.phone,
    required this.dept,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    IconData statusIcon;

    switch (status) {
      case "Active":
        statusColor = const Color(0xFF00C2B2);
        statusIcon = Icons.check_circle_outline;
        break;
      case "Follow-up":
        statusColor = Colors.orange;
        statusIcon = Icons.schedule;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.block;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF14283C),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [

            /// TOP ROW
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$name ($age)",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight:
                    FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor
                        .withOpacity(0.15),
                    borderRadius:
                    BorderRadius.circular(
                        20),
                  ),
                  child: Row(
                    children: [
                      Icon(statusIcon,
                          size: 12,
                          color:
                          statusColor),
                      const SizedBox(
                          width: 4),
                      Text(
                        status,
                        style:
                        TextStyle(
                          color:
                          statusColor,
                          fontSize:
                          11,
                          fontWeight:
                          FontWeight
                              .w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              "ID: $id • $phone",
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              dept,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 11,
              ),
            ),

            const SizedBox(height: 14),

            /// ACTION ROW
            Row(
              mainAxisAlignment:
              MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(
                      Icons.edit,
                      size: 18,
                      color:
                      Colors.white54),
                  onPressed: () {},
                ),
                const SizedBox(width: 6),
                Container(
                  padding:
                  const EdgeInsets
                      .symmetric(
                      horizontal:
                      18,
                      vertical:
                      6),
                  decoration:
                  BoxDecoration(
                    color: const Color(
                        0xFF2979FF),
                    borderRadius:
                    BorderRadius
                        .circular(10),
                  ),
                  child:
                  const Text(
                    "Manage",
                    style:
                    TextStyle(
                      fontSize: 12,
                      color: Colors
                          .white,
                      fontWeight:
                      FontWeight
                          .w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}