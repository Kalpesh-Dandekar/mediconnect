import 'package:flutter/material.dart';
import 'package:mediconnect/features/auth/screens/role_details_screen.dart';
import 'package:mediconnect/features/auth/screens/login_screen.dart';
import 'package:mediconnect/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  final String role;

  const RegisterScreen({super.key, required this.role});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  final AuthService _authService = AuthService();
  bool isLoading = false;

  Future<void> _registerUser() async {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        confirmController.text.trim().isEmpty) {
      _showMessage("Please fill all fields", isError: true);
      return;
    }

    if (passwordController.text != confirmController.text) {
      _showMessage("Passwords do not match", isError: true);
      return;
    }

    if (passwordController.text.length < 6) {
      _showMessage("Password must be at least 6 characters",
          isError: true);
      return;
    }

    setState(() => isLoading = true);

    try {
      User? user = await _authService.registerBasicUser(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        name: nameController.text.trim(),
        role: widget.role,
      );

      if (user == null) {
        setState(() => isLoading = false);
        return;
      }

      _showMessage("Account created successfully!");

      Future.delayed(const Duration(milliseconds: 800), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                RoleDetailsScreen(role: widget.role),
          ),
        );
      });
    } on FirebaseAuthException catch (e) {
      _showMessage(e.message ?? "Registration failed",
          isError: true);
    }

    setState(() => isLoading = false);
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor:
        isError ? Colors.redAccent : const Color(0xFFFF9F1C),
        content: Text(
          message,
          style: TextStyle(
            color: isError ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
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
            colors: [Color(0xFF0C1B2A), Color(0xFF16263A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 28, vertical: 30),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white70,
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          "REGISTER",
                          style: TextStyle(
                            fontSize: 13,
                            letterSpacing: 2,
                            color: Colors.white54,
                          ),
                        ),

                        const SizedBox(height: 12),

                        const Text(
                          "Create Account",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          "Register as ${widget.role}",
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white70,
                          ),
                        ),

                        const SizedBox(height: 36),

                        _buildInputField(
                            nameController,
                            "Full Name",
                            Icons.person_outline,
                            false),

                        const SizedBox(height: 20),

                        _buildInputField(
                            emailController,
                            "Email Address",
                            Icons.email_outlined,
                            false),

                        const SizedBox(height: 20),

                        _buildInputField(
                            passwordController,
                            "Password",
                            Icons.lock_outline,
                            true),

                        const SizedBox(height: 20),

                        _buildInputField(
                            confirmController,
                            "Confirm Password",
                            Icons.lock_outline,
                            true),

                        const SizedBox(height: 40),

                        Center(
                          child: GestureDetector(
                            onTap:
                            isLoading ? null : _registerUser,
                            child: Container(
                              width: 260,
                              height: 58,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(28),
                                gradient:
                                const LinearGradient(
                                  colors: [
                                    Color(0xFFFF9F1C),
                                    Color(0xFFFFB703)
                                  ],
                                ),
                              ),
                              alignment: Alignment.center,
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                color: Colors.black,
                                strokeWidth: 2,
                              )
                                  : const Text(
                                "CREATE ACCOUNT",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight:
                                  FontWeight.w700,
                                  letterSpacing: 1.2,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        Center(
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Already have an account?",
                                style: TextStyle(
                                    color: Colors.white70),
                              ),
                              const SizedBox(width: 6),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                      const LoginScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Color(0xFFFFB703),
                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Spacer(), // 🔥 pushes content properly

                        const SizedBox(height: 20),
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