import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'staff_dashboard_screen.dart';
import 'staff_appointments_screen.dart';
import 'staff_reports_screen.dart';
import 'staff_patients_screen.dart';
import 'staff_profile_screen.dart';

class StaffRootScreen extends StatefulWidget {
  const StaffRootScreen({super.key});

  @override
  State<StaffRootScreen> createState() => _StaffRootScreenState();
}

class _StaffRootScreenState extends State<StaffRootScreen> {
  int _currentIndex = 0;

  static const Color _accentColor = Color(0xFF2979FF);

  final List<Widget> _screens = const [
    StaffDashboardScreen(),
    StaffAppointmentsScreen(),
    StaffReportsScreen(),
    StaffPatientsScreen(),
    StaffProfileScreen(),
  ];

  final List<_NavItem> _items = const [
    _NavItem(Icons.dashboard_outlined, Icons.dashboard, "Home"),
    _NavItem(Icons.calendar_month_outlined, Icons.calendar_month, "Appointments"),
    _NavItem(Icons.science_outlined, Icons.science, "Reports"),
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
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFF1E3148),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withOpacity(0.06)),
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
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: selected
                ? _accentColor.withOpacity(0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                selected ? item.activeIcon : item.icon,
                size: 22,
                color: selected ? _accentColor : Colors.white54,
              ),
              const SizedBox(height: 4),
              Text(
                item.label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight:
                  selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected ? _accentColor : Colors.white54,
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