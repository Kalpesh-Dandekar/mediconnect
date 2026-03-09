import 'package:flutter/material.dart';
import 'package:mediconnect/features/auth/screens/register_screen.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? selectedRole;

  void selectRole(String role) {
    setState(() {
      selectedRole = role;
    });
  }

  void _continue() {
    if (selectedRole == null) return;

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) =>
            RegisterScreen(role: selectedRole!),
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0C1B2A),
              Color(0xFF16263A),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 20),

                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white70,
                    size: 20,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "SELECT ROLE",
                  style: TextStyle(
                    fontSize: 13,
                    letterSpacing: 2,
                    color: Colors.white54,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  "How will you use\nMediConnect?",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  "Choose your role to personalize your experience.",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white70,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 40),

                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 1.1,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _RoleCard(
                        title: "Patient",
                        icon: Icons.person_outline,
                        selected: selectedRole == "Patient",
                        onTap: () => selectRole("Patient"),
                      ),
                      _RoleCard(
                        title: "Doctor",
                        icon: Icons.medical_services_outlined,
                        selected: selectedRole == "Doctor",
                        onTap: () => selectRole("Doctor"),
                      ),
                      _RoleCard(
                        title: "Relative",
                        icon: Icons.family_restroom_outlined,
                        selected: selectedRole == "Relative",
                        onTap: () => selectRole("Relative"),
                      ),
                      _RoleCard(
                        title: "Staff",
                        icon: Icons.badge_outlined,
                        selected: selectedRole == "Staff",
                        onTap: () => selectRole("Staff"),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                Center(
                  child: GestureDetector(
                    onTap: _continue,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 260,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        gradient: selectedRole != null
                            ? const LinearGradient(
                          colors: [
                            Color(0xFFFF9F1C),
                            Color(0xFFFFB703),
                          ],
                        )
                            : null,
                        color: selectedRole == null
                            ? Colors.white.withOpacity(0.08)
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "CONTINUE",
                        style: TextStyle(
                          color: selectedRole != null
                              ? Colors.black
                              : Colors.white54,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(0.04),
          border: Border.all(
            color: selected
                ? const Color(0xFFFF9F1C)
                : Colors.white.withOpacity(0.08),
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? [
            BoxShadow(
              color: const Color(0xFFFF9F1C).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 6),
            )
          ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: selected
                  ? const Color(0xFFFF9F1C)
                  : Colors.white70,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: selected
                    ? const Color(0xFFFF9F1C)
                    : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}