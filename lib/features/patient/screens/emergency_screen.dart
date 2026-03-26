import 'package:flutter/material.dart';
import '../../../services/patient/emergency_service.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {

  final EmergencyService emergencyService = EmergencyService();
  bool _loading = false;

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _handleEmergency(String type, String successMsg) async {
    if (_loading) return;

    try {
      setState(() => _loading = true);

      await emergencyService.createEmergency(type);
      _showMessage(successMsg);

    } catch (e) {
      _showMessage("Something went wrong");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      color: const Color(0xFF0C1B2A), // ✅ ONLY CHANGE
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

              /// 🚨 CRITICAL EMERGENCY
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF8B1E1E),
                      Color(0xFF5C1212),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.redAccent.withOpacity(0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Row(
                      children: [
                        Icon(Icons.warning_amber_rounded,
                            color: Colors.white, size: 28),
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
                      onTap: () => _handleEmergency(
                        "ambulance",
                        "Ambulance request sent",
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: _loading
                            ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                            : const Text(
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

              /// 🩺 DOCTOR CONNECT
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: Colors.white.withOpacity(0.05),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.08),
                  ),
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
                      onTap: () => _handleEmergency(
                        "doctor",
                        "Doctor request sent",
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFFF9F1C),
                              Color(0xFFFFB703),
                            ],
                          ),
                        ),
                        child: _loading
                            ? const CircularProgressIndicator(
                          color: Colors.black,
                        )
                            : const Text(
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
                onTap: () => _handleEmergency(
                  "caregiver",
                  "Caregiver alerted",
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white.withOpacity(0.05),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                  child: _loading
                      ? const CircularProgressIndicator()
                      : const Text(
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

/// CONTACT TILE (UNCHANGED)
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: Row(
        children: [

          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.redAccent),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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