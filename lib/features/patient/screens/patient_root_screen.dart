import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'appointments_screen.dart';
import 'emergency_screen.dart';
import 'medicines_screen.dart';
import 'patient_dashboard_screen.dart';
import 'reports_screen.dart';

class PatientRootScreen extends StatefulWidget {
  const PatientRootScreen({super.key});

  @override
  State<PatientRootScreen> createState() => _PatientRootScreenState();
}

class _PatientRootScreenState extends State<PatientRootScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    PatientDashboardScreen(),
    AppointmentsScreen(),
    EmergencyScreen(),
    MedicinesScreen(),
    ReportsScreen(),
  ];

  final List<_NavItem> _items = const [
    _NavItem(Icons.dashboard_outlined, Icons.dashboard, "Home"),
    _NavItem(Icons.calendar_month_outlined, Icons.calendar_month, "Appointments"),
    _NavItem(Icons.warning_amber_outlined, Icons.warning_amber, "Emergency", isEmergency: true),
    _NavItem(Icons.medication_outlined, Icons.medication, "Medicines"),
    _NavItem(Icons.description_outlined, Icons.description, "Reports"),
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.55),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
              border: Border.all(
                color: Colors.white.withOpacity(0.06),
              ),
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
    final bool selected = index == _currentIndex;

    final Color activeColor =
    item.isEmergency ? const Color(0xFFE53935) : const Color(0xFFFFB703);

    final Color inactiveColor =
    item.isEmergency ? Colors.redAccent.withOpacity(0.7) : Colors.white54;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        alignment: Alignment.center,
        child: Container(
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
              Icon(
                selected ? item.activeIcon : item.icon,
                size: 22,
                color: selected ? activeColor : inactiveColor,
              ),
              const SizedBox(height: 4),
              Text(
                item.label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: selected
                      ? FontWeight.w600
                      : FontWeight.w400,
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
  final bool isEmergency;

  const _NavItem(
      this.icon,
      this.activeIcon,
      this.label, {
        this.isEmergency = false,
      });
}