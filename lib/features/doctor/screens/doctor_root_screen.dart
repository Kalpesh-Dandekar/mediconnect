import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'doctor_dashboard_screen.dart';
import 'today_appointments_screen.dart';
import 'patients_screen.dart';
import 'doctor_profile_screen.dart';

class DoctorRootScreen extends StatefulWidget {
  const DoctorRootScreen({super.key});

  @override
  State<DoctorRootScreen> createState() => _DoctorRootScreenState();
}

class _DoctorRootScreenState extends State<DoctorRootScreen> {
  int _currentIndex = 0;

  static const Color _accentColor = Color(0xFF00C2B2);

  final List<Widget> _screens = const [
    DoctorDashboardScreen(),
    TodayAppointmentsScreen(),
    PatientsScreen(),
    DoctorProfileScreen(),
  ];

  final List<_NavItem> _items = const [
    _NavItem(Icons.dashboard_outlined, Icons.dashboard, "Home"),
    _NavItem(Icons.calendar_month_outlined, Icons.calendar_month, "Appointments"),
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
            height: 72, // slightly increased for safety
            decoration: BoxDecoration(
              color: const Color(0xFF1E3148),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: Colors.white.withOpacity(0.06),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.45),
                  blurRadius: 25,
                  offset: const Offset(0, 12),
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

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _currentIndex = index),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: selected
                ? _accentColor.withOpacity(0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                selected ? item.activeIcon : item.icon,
                size: 20, // reduced size to prevent overflow
                color: selected ? _accentColor : Colors.white54,
              ),
              const SizedBox(height: 2), // reduced spacing
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10, // reduced font
                  fontWeight:
                  selected ? FontWeight.w600 : FontWeight.w400,
                  color:
                  selected ? _accentColor : Colors.white54,
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