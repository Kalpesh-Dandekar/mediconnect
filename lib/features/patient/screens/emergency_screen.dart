import 'package:flutter/material.dart';
import '../../../services/patient/emergency_service.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  void _simulateAction(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {

    final EmergencyService emergencyService = EmergencyService();

    return Container(
      color: const Color(0xFF0C1B2A),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// HEADER
              const Text(
                "Emergency Assistance",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Immediate help & urgent medical support",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white54,
                ),
              ),

              const SizedBox(height: 30),

              /// CRITICAL EMERGENCY
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: const Color(0xFF7A1F1F),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Row(
                      children: [
                        Icon(Icons.warning_amber_rounded,
                            color: Colors.redAccent, size: 28),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Critical Emergency",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    const Text(
                      "For severe symptoms, accidents, chest pain or breathing difficulty, contact emergency services immediately.",
                      style: TextStyle(
                        color: Colors.white70,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 18),

                    GestureDetector(
                      onTap: () async {

                        await emergencyService.createEmergency("ambulance");

                        _simulateAction(
                            context, "Ambulance request sent.");
                      },
                      child: Container(
                        width: double.infinity,
                        padding:
                        const EdgeInsets.symmetric(vertical: 16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius:
                          BorderRadius.circular(16),
                        ),
                        child: const Text(
                          "CALL AMBULANCE (108)",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// CONNECT DOCTOR
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF14283C),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Row(
                      children: [
                        Icon(Icons.support_agent,
                            color: Colors.tealAccent, size: 26),
                        SizedBox(width: 10),
                        Text(
                          "Connect to Available Doctor",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      "Doctors Online: 3 • Avg wait time: 2 mins",
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 16),

                    GestureDetector(
                      onTap: () async {

                        await emergencyService.createEmergency("doctor");

                        _simulateAction(
                            context, "Doctor request sent.");
                      },
                      child: Container(
                        width: double.infinity,
                        padding:
                        const EdgeInsets.symmetric(vertical: 14),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.tealAccent,
                          borderRadius:
                          BorderRadius.circular(14),
                        ),
                        child: const Text(
                          "CONNECT NOW",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// CONTACTS
              const Text(
                "Emergency Contacts",
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 1.4,
                  color: Colors.white54,
                ),
              ),

              const SizedBox(height: 16),

              const _ContactTile(
                icon: Icons.local_hospital,
                title: "City Care Hospital",
                subtitle: "2.3 km away",
              ),

              const SizedBox(height: 14),

              const _ContactTile(
                icon: Icons.person,
                title: "Primary Doctor",
                subtitle: "Dr. Michael Smith",
              ),

              const SizedBox(height: 14),

              const _ContactTile(
                icon: Icons.family_restroom,
                title: "Emergency Contact",
                subtitle: "John Doe (Relative)",
              ),

              const SizedBox(height: 30),

              /// ALERT CAREGIVER
              GestureDetector(
                onTap: () async {

                  await emergencyService.createEmergency("caregiver");

                  _simulateAction(
                      context, "Caregiver alert sent.");
                },
                child: Container(
                  width: double.infinity,
                  padding:
                  const EdgeInsets.symmetric(vertical: 14),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF14283C),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    "Alert Caregiver",
                    style: TextStyle(
                      color: Colors.tealAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _ContactTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF14283C),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [

          Icon(icon, color: Colors.redAccent),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.call,
            color: Colors.tealAccent,
          ),
        ],
      ),
    );
  }
}