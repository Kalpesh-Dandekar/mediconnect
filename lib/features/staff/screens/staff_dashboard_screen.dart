import 'package:flutter/material.dart';

class StaffDashboardScreen extends StatelessWidget {
  const StaffDashboardScreen({super.key});

  static const Color _accent = Color(0xFF2979FF);
  static const Color _danger = Color(0xFFE53935);

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
                "Staff Dashboard",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Hospital Operations Control",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),

              const SizedBox(height: 22),

              /// ===== SYSTEM STATUS STRIP =====
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF13273B), Color(0xFF142F4D)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.circle, size: 10, color: Colors.greenAccent),
                    const SizedBox(width: 8),
                    const Text(
                      "System Operational",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "Last sync: 2 mins ago",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              /// ===== MAIN OPERATIONS CARD =====
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF14283C), Color(0xFF16324F)],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "Today's Operations",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        letterSpacing: 1.2,
                      ),
                    ),

                    const SizedBox(height: 18),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        _BigStat(value: "18", label: "Appointments"),
                        _BigStat(value: "5", label: "Pending Reports"),
                        _BigStat(value: "12", label: "Reports Uploaded"),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              /// ===== EMERGENCY CARD =====
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: _danger.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _danger.withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: _danger, size: 28),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Text(
                        "2 Active Emergency Alerts",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios,
                        color: Colors.white54, size: 14),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              /// ===== QUICK ACTIONS =====
              const Text(
                "Quick Actions",
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 1.3,
                  color: Colors.white54,
                ),
              ),

              const SizedBox(height: 14),

              _QuickAction(
                icon: Icons.add_circle_outline,
                label: "Add New Report",
              ),

              const SizedBox(height: 12),

              _QuickAction(
                icon: Icons.event_note_outlined,
                label: "View Today's Schedule",
              ),

              const SizedBox(height: 12),

              _QuickAction(
                icon: Icons.people_outline,
                label: "Manage Patients",
              ),

              const SizedBox(height: 28),

              /// ===== RECENT ACTIVITY =====
              const Text(
                "Recent Activity",
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 1.3,
                  color: Colors.white54,
                ),
              ),

              const SizedBox(height: 12),

              const _ActivityItem(
                text: "CBC Report uploaded for Rahul Sharma",
                time: "10 min ago",
              ),
              const _ActivityItem(
                text: "Appointment completed - Dr. Mehta",
                time: "30 min ago",
              ),
              const _ActivityItem(
                text: "Emergency triggered (Room 204)",
                time: "1 hr ago",
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

/// ===== BIG STAT =====
class _BigStat extends StatelessWidget {
  final String value;
  final String label;

  const _BigStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}

/// ===== QUICK ACTION =====
class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;

  const _QuickAction({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF14283C),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: StaffDashboardScreen._accent),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Icon(Icons.arrow_forward_ios,
              size: 14, color: Colors.white38),
        ],
      ),
    );
  }
}

/// ===== ACTIVITY ITEM =====
class _ActivityItem extends StatelessWidget {
  final String text;
  final String time;

  const _ActivityItem({
    required this.text,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            height: 8,
            width: 8,
            decoration: const BoxDecoration(
              color: StaffDashboardScreen._accent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}