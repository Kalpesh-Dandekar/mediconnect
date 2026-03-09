import 'package:flutter/material.dart';
import 'relative_dashboard_screen.dart';
import 'relative_medications_screen.dart';
import 'relative_reports_screen.dart';
import 'relative_profile_screen.dart';

class RelativeRootScreen extends StatefulWidget {
  const RelativeRootScreen({super.key});

  @override
  State<RelativeRootScreen> createState() =>
      _RelativeRootScreenState();
}

class _RelativeRootScreenState
    extends State<RelativeRootScreen> {

  int _currentIndex = 0;

  static const Color _accent = Color(0xFF8E44AD);

  final List<Widget> _screens = const [
    RelativeDashboardScreen(),
    RelativeMedicationsScreen(),
    RelativeReportsScreen(),
    RelativeProfileScreen(),
  ];

  final List<_NavItem> _items = const [
    _NavItem(Icons.home_outlined, Icons.home, "Home"),
    _NavItem(Icons.medication_outlined, Icons.medication, "Medications"),
    _NavItem(Icons.description_outlined, Icons.description, "Reports"),
    _NavItem(Icons.person_outline, Icons.person, "Profile"),
  ];

  @override
  Widget build(BuildContext context) {
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
            ),
            child: Row(
              children: List.generate(
                _items.length,
                    (index) => Expanded(
                  child: GestureDetector(
                    onTap: () => setState(
                            () => _currentIndex = index),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Icon(
                          index == _currentIndex
                              ? _items[index].activeIcon
                              : _items[index].icon,
                          size: 22,
                          color: index == _currentIndex
                              ? _accent
                              : Colors.white54,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _items[index].label,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight:
                            index == _currentIndex
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: index ==
                                _currentIndex
                                ? _accent
                                : Colors.white54,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
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

  const _NavItem(
      this.icon, this.activeIcon, this.label);
}