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

              /// 🔥 TOP GLOW
              Positioned(
                top: 60,
                right: -80,
                child: Container(
                  width: 320,
                  height: 320,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Color(0xFFFF9F1C).withOpacity(0.18),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              /// 🔥 BOTTOM GLOW
              Positioned(
                bottom: -80,
                left: -60,
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withOpacity(0.06),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(height: 36),

                    /// 🔷 LOGO
                    const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Medi",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.1,
                              color: Colors.white,
                            ),
                          ),
                          TextSpan(
                            text: "Connect",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.1,
                              color: Color(0xFFFF9F1C),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    /// 🔷 SUB LABEL
                    const Text(
                      "NEXT GENERATION",
                      style: TextStyle(
                        fontSize: 13,
                        letterSpacing: 2.5,
                        color: Colors.white54,
                      ),
                    ),

                    const SizedBox(height: 14),

                    /// 🔥 HERO TEXT
                    const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Digital ",
                            style: TextStyle(
                              fontSize: 44,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              height: 1.1,
                            ),
                          ),
                          TextSpan(
                            text: "Healthcare",
                            style: TextStyle(
                              fontSize: 44,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFFF9F1C),
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// 🔷 DESCRIPTION
                    const Text(
                      "Appointments. Records. Reminders.\nAll unified in one intelligent platform.",
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.7,
                        color: Colors.white70,
                      ),
                    ),

                    const SizedBox(height: 36),

                    /// 🔥 FEATURE CARDS
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

                    /// 🚀 CTA BUTTON
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
                                color: Color(0xFFFF9F1C).withOpacity(0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 10,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            "GET STARTED",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.3,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    /// 🔷 TRUST TEXT
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
                    const SizedBox(height: 24),
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

/// 🔥 FEATURE CARD
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
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
            ),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFFFB703),
            size: 22,
          ),
        ),
        const SizedBox(height: 10),
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