import 'package:flutter/material.dart';

class ViewReportsScreen extends StatelessWidget {
  const ViewReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C1B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C1B2A),
        elevation: 0,
        title: const Text("Patient Reports"),
      ),
      body: const Center(
        child: Text(
          "Reports Screen",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}