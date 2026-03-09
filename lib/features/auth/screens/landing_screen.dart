import 'package:flutter/material.dart';
import 'package:mediconnect/features/auth/screens/role_selection_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  void _navigateToRole(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const RoleSelectionScreen(),
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
          child: Stack(
            children: [

              Positioned(
                top: 100,
                right: -100,
                child: Container(
                  width: 380,
                  height: 380,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFFF9F1C).withOpacity(0.10),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              Positioned(
                bottom: -50,
                left: -80,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withOpacity(0.05),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(height: 40),

                    const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Medi",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                              color: Colors.white,
                            ),
                          ),
                          TextSpan(
                            text: "Connect",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                              color: Color(0xFFFF9F1C),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    const Text(
                      "NEXT GENERATION",
                      style: TextStyle(
                        fontSize: 14,
                        letterSpacing: 2,
                        color: Colors.white54,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Digital ",
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              height: 1.1,
                            ),
                          ),
                          TextSpan(
                            text: "Healthcare",
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFFF9F1C),
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    const SizedBox(
                      width: 320,
                      child: Text(
                        "Appointments. Records. Reminders.\nAll unified in one intelligent platform.",
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: Colors.white70,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _FeatureItem(
                          icon: Icons.calendar_today_outlined,
                          label: "Appointments",
                        ),
                        _FeatureItem(
                          icon: Icons.lock_outline,
                          label: "Secure Records",
                        ),
                        _FeatureItem(
                          icon: Icons.notifications_none_outlined,
                          label: "Reminders",
                        ),
                      ],
                    ),

                    const SizedBox(height: 60),

                    Center(
                      child: GestureDetector(
                        onTap: () => _navigateToRole(context),
                        child: Container(
                          width: 260,
                          height: 58,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFFF9F1C),
                                Color(0xFFFFB703),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              )
                            ],
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            "GET STARTED",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Center(
                      child: Text(
                        "Trusted by 250+ Hospitals",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white60,
                        ),
                      ),
                    ),

                    const Spacer(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFFFB703),
            size: 22,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.white70,
          ),
        )
      ],
    );
  }
}