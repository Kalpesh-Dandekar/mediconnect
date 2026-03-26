import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'doctor_dashboard_screen.dart';
import 'today_appointments_screen.dart';
import 'patients_screen.dart';
import 'doctor_profile_screen.dart';
import 'doctor_emergency_screen.dart';

class DoctorRootScreen extends StatefulWidget {
  const DoctorRootScreen({super.key});

  @override
  State<DoctorRootScreen> createState() => _DoctorRootScreenState();
}

class _DoctorRootScreenState extends State<DoctorRootScreen> {
  int _currentIndex = 0;

  static const Color _accentColor = Color(0xFF00C2B2);

  final List<Widget> _screens = [
    const DoctorDashboardScreen(),
    const TodayAppointmentsScreen(),
    const DoctorEmergencyScreen(),
    const PatientsScreen(),
    DoctorProfileScreen(),
  ];

  final List<_NavItem> _items = const [
    _NavItem(Icons.dashboard_outlined, Icons.dashboard, "Home"),
    _NavItem(Icons.calendar_month_outlined, Icons.calendar_month, "Appointments"),
    _NavItem(Icons.warning_amber_outlined, Icons.warning_amber, "Emergency"),
    _NavItem(Icons.people_outline, Icons.people, "Patients"),
    _NavItem(Icons.person_outline, Icons.person, "Profile"),
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Color(0xFF0C1B2A),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0C1B2A),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
          child: Container(
            height: 70, // ✅ MATCHED WITH PATIENT SIDE
            decoration: BoxDecoration(
              color: const Color(0xFF1E3148),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: Colors.white.withOpacity(0.06),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.55),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Row(
              children: List.generate(
                _items.length,
                    (index) => Expanded(
                  child: _buildNavItem(_items[index], index),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(_NavItem item, int index) {
    final selected = index == _currentIndex;
    final isEmergency = item.label == "Emergency";

    final activeColor =
    isEmergency ? const Color(0xFFE53935) : _accentColor;

    final inactiveColor =
    isEmergency ? Colors.redAccent.withOpacity(0.7) : Colors.white54;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _currentIndex = index),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: selected
                ? activeColor.withOpacity(0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// ICON
              Icon(
                selected ? item.activeIcon : item.icon,
                size: 22,
                color: selected ? activeColor : inactiveColor,
              ),

              const SizedBox(height: 4),

              /// LABEL
              Text(
                item.label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight:
                  selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected ? activeColor : inactiveColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem(this.icon, this.activeIcon, this.label);
}