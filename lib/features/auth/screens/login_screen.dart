import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:mediconnect/services/auth_service.dart';
import 'package:mediconnect/features/auth/screens/register_screen.dart';
import 'package:mediconnect/features/auth/screens/role_details_screen.dart';
import 'package:mediconnect/features/auth/screens/role_selection_screen.dart';

import 'package:mediconnect/features/patient/screens/patient_root_screen.dart';
import 'package:mediconnect/features/doctor/screens/doctor_root_screen.dart';
import 'package:mediconnect/features/staff/screens/staff_root_screen.dart';
import 'package:mediconnect/features/relative/screens/relative_root_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService _authService = AuthService();
  bool isLoading = false;

  Future<void> _loginUser() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      _showError("Please fill all fields");
      return;
    }

    setState(() => isLoading = true);

    try {
      User? user = await _authService.loginUser(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (user == null) {
        _showError("Login failed");
        return;
      }

      await _handleNavigation(user);
    } catch (e) {
      _showError("Login failed");
    }

    if (mounted) setState(() => isLoading = false);
  }

  Future<void> _googleLogin() async {
    try {
      setState(() => isLoading = true);

      final user = await _authService.signInWithGoogle();

      if (user == null) {
        setState(() => isLoading = false);
        return;
      }

      await _authService.createUserIfNotExists(user);
      await _handleNavigation(user);
    } catch (e) {
      _showError("Google sign-in failed");
    }

    if (mounted) setState(() => isLoading = false);
  }

  Future<void> _handleNavigation(User user) async {
    String? role = await _authService.getUserRole(user.uid);
    bool isCompleted =
    await _authService.isProfileCompleted(user.uid);

    if (!mounted) return;

    if (role == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const RoleSelectionScreen(),
        ),
      );
      return;
    }

    switch (role) {
      case "Patient":
        if (!isCompleted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  RoleDetailsScreen(role: role),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
              const PatientRootScreen(),
            ),
          );
        }
        break;

      case "Doctor":
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
            const DoctorRootScreen(),
          ),
        );
        break;

      case "Staff":
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
            const StaffRootScreen(),
          ),
        );
        break;

      case "Relative":
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
            const RelativeRootScreen(),
          ),
        );
        break;

      default:
        _showError("Unknown role detected.");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(message),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // 🔥 IMPORTANT
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0C1B2A),
              Color(0xFF16263A),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 28, vertical: 28),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        IconButton(
                          onPressed: () =>
                              Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white70,
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          "WELCOME BACK",
                          style: TextStyle(
                            fontSize: 13,
                            letterSpacing: 2.5,
                            color: Colors.white54,
                          ),
                        ),

                        const SizedBox(height: 12),

                        const Text(
                          "Login to Continue",
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 36),

                        _buildInputField(
                            emailController,
                            "Email Address",
                            Icons.email_outlined,
                            false),

                        const SizedBox(height: 18),

                        _buildInputField(
                            passwordController,
                            "Password",
                            Icons.lock_outline,
                            true),

                        const SizedBox(height: 36),

                        Center(
                          child: GestureDetector(
                            onTap: isLoading
                                ? null
                                : _loginUser,
                            child: Container(
                              width: 260,
                              height: 58,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(
                                    30),
                                gradient:
                                const LinearGradient(
                                  colors: [
                                    Color(0xFFFF9F1C),
                                    Color(0xFFFFB703),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                        0xFFFF9F1C)
                                        .withOpacity(0.35),
                                    blurRadius: 18,
                                    offset:
                                    const Offset(0, 8),
                                  ),
                                ],
                              ),
                              alignment:
                              Alignment.center,
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                color:
                                Colors.black,
                                strokeWidth: 2,
                              )
                                  : const Text(
                                "LOGIN",
                                style:
                                TextStyle(
                                  fontWeight:
                                  FontWeight
                                      .w700,
                                  letterSpacing:
                                  1.2,
                                  color:
                                  Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        const Center(
                          child: Text(
                            "OR",
                            style: TextStyle(
                                color: Colors.white54),
                          ),
                        ),

                        const SizedBox(height: 20),

                        GestureDetector(
                          onTap: isLoading
                              ? null
                              : _googleLogin,
                          child: Container(
                            height: 54,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(
                                  18),
                              color: Colors.white
                                  .withOpacity(0.08),
                              border: Border.all(
                                color: Colors.white
                                    .withOpacity(0.1),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                              children: [
                                Icon(
                                    Icons.g_mobiledata,
                                    color:
                                    Colors.white),
                                SizedBox(width: 10),
                                Text(
                                  "Continue with Google",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight:
                                    FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 26),

                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator
                                  .pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                  const RegisterScreen(
                                      role:
                                      "Patient"),
                                ),
                              );
                            },
                            child: const Text(
                              "Don't have an account? Register",
                              style: TextStyle(
                                color:
                                Color(0xFFFFB703),
                                fontWeight:
                                FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const Spacer(), // 🔥 KEY FIX
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
      TextEditingController controller,
      String hint,
      IconData icon,
      bool obscure,
      ) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon:
        Icon(icon, color: Colors.white60, size: 20),
        hintText: hint,
        hintStyle:
        const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: Colors.white.withOpacity(0.06),
        contentPadding:
        const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.08),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Color(0xFFFF9F1C),
            width: 1.2,
          ),
        ),
      ),
    );
  }
}