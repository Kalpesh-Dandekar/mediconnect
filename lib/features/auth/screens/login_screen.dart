import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mediconnect/services/auth_service.dart';
import 'package:mediconnect/features/auth/screens/register_screen.dart';
import 'package:mediconnect/features/auth/screens/role_details_screen.dart';

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
  final TextEditingController emailController =
  TextEditingController();
  final TextEditingController passwordController =
  TextEditingController();

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

      String? role =
      await _authService.getUserRole(user.uid);
      bool isCompleted =
      await _authService.isProfileCompleted(user.uid);

      if (!mounted) return;

      switch (role) {

      /// ================= PATIENT =================
        case "Patient":
          if (!isCompleted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    RoleDetailsScreen(role: role!),
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

      /// ================= DOCTOR =================
        case "Doctor":
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
              const DoctorRootScreen(),
            ),
          );
          break;

      /// ================= STAFF =================
        case "Staff":
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
              const StaffRootScreen(),
            ),
          );
          break;

      /// ================= RELATIVE =================
        case "Relative":
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
              const RelativeRootScreen(),
            ),
          );
          break;

      /// ================= UNKNOWN =================
        default:
          _showError("Unknown role detected.");
      }

    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? "Login failed");
    } catch (e) {
      _showError("Unexpected error occurred");
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        behavior: SnackBarBehavior.floating,
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
      resizeToAvoidBottomInset: true,
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight:
                      constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 30),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [

                          const SizedBox(height: 30),

                          /// LOGO
                          Center(
                            child: Container(
                              padding:
                              const EdgeInsets.all(
                                  16),
                              decoration:
                              BoxDecoration(
                                shape: BoxShape
                                    .circle,
                                color: Colors.white
                                    .withOpacity(
                                    0.08),
                              ),
                              child:
                              const Icon(
                                Icons
                                    .local_hospital_outlined,
                                color: Color(
                                    0xFFFFB703),
                                size: 34,
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          const Text(
                            "WELCOME BACK",
                            style: TextStyle(
                              fontSize: 13,
                              letterSpacing: 2,
                              color:
                              Colors.white54,
                            ),
                          ),

                          const SizedBox(height: 12),

                          const Text(
                            "Login to Continue",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight:
                              FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 50),

                          _buildInputField(
                            emailController,
                            "Email Address",
                            Icons.email_outlined,
                            false,
                          ),

                          const SizedBox(height: 20),

                          _buildInputField(
                            passwordController,
                            "Password",
                            Icons.lock_outline,
                            true,
                          ),

                          const Spacer(),

                          /// LOGIN BUTTON
                          Center(
                            child: GestureDetector(
                              onTap: isLoading
                                  ? null
                                  : _loginUser,
                              child: Container(
                                width: 260,
                                height: 58,
                                decoration:
                                BoxDecoration(
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                      28),
                                  gradient:
                                  const LinearGradient(
                                    colors: [
                                      Color(
                                          0xFFFF9F1C),
                                      Color(
                                          0xFFFFB703),
                                    ],
                                  ),
                                ),
                                alignment:
                                Alignment
                                    .center,
                                child: isLoading
                                    ? const CircularProgressIndicator(
                                  color: Colors
                                      .black,
                                  strokeWidth:
                                  2,
                                )
                                    : const Text(
                                  "LOGIN",
                                  style:
                                  TextStyle(
                                    fontSize:
                                    15,
                                    fontWeight:
                                    FontWeight
                                        .w700,
                                    letterSpacing:
                                    1.2,
                                    color: Colors
                                        .black,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 25),

                          /// REGISTER
                          Center(
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                              children: [
                                const Text(
                                  "Don't have an account?",
                                  style: TextStyle(
                                      color: Colors
                                          .white70),
                                ),
                                const SizedBox(
                                    width: 6),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                        const RegisterScreen(
                                            role:
                                            "Patient"),
                                      ),
                                    );
                                  },
                                  child:
                                  const Text(
                                    "Register",
                                    style:
                                    TextStyle(
                                      color: Color(
                                          0xFFFFB703),
                                      fontWeight:
                                      FontWeight
                                          .bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
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
      style:
      const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon,
            color: Colors.white60,
            size: 20),
        hintText: hint,
        hintStyle: const TextStyle(
            color: Colors.white38),
        filled: true,
        fillColor:
        Colors.white.withOpacity(0.06),
        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}