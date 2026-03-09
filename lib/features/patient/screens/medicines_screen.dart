import 'package:flutter/material.dart';

class MedicinesScreen extends StatefulWidget {
  const MedicinesScreen({super.key});

  @override
  State<MedicinesScreen> createState() => _MedicinesScreenState();
}

class _MedicinesScreenState extends State<MedicinesScreen> {

  /// Dummy grouped data
  final Map<String, List<Dose>> _groupedDoses = {
    "Morning": [
      Dose(name: "Pantoprazole 40mg", time: "08:00 AM"),
    ],
    "Afternoon": [
      Dose(name: "Vitamin D3", time: "02:00 PM"),
    ],
    "Evening": [
      Dose(name: "Pantoprazole 40mg", time: "08:00 PM"),
    ],
  };

  bool escalationEnabled = true;

  int get _totalDoses =>
      _groupedDoses.values.expand((e) => e).length;

  int get _takenDoses =>
      _groupedDoses.values.expand((e) => e).where((d) => d.status == DoseStatus.taken).length;

  double get _adherence =>
      _totalDoses == 0 ? 0 : _takenDoses / _totalDoses;

  String get _nextDose {
    for (var group in _groupedDoses.values) {
      for (var dose in group) {
        if (dose.status == DoseStatus.pending) {
          return "${dose.time}";
        }
      }
    }
    return "All completed";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0C1B2A),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// ===== HEADER =====
              const Text(
                "Medication",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Daily treatment & compliance overview",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),

              const SizedBox(height: 26),

              /// ===== TODAY SECTION =====
              const Text(
                "TODAY",
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 1.5,
                  color: Colors.white54,
                ),
              ),
              const SizedBox(height: 14),

              ..._buildGroupedDoses(),

              const SizedBox(height: 28),

              /// ===== ADHERENCE CARD =====
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF14283C),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Adherence Today",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "${(_adherence * 100).toInt()}%",
                          style: const TextStyle(
                            color: Colors.tealAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: _adherence,
                        minHeight: 6,
                        backgroundColor: Colors.white10,
                        color: Colors.tealAccent,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "$_takenDoses of $_totalDoses doses completed • Next: $_nextDose",
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      "🔥 3 day medication streak",
                      style: TextStyle(
                        color: Colors.orangeAccent,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              /// ===== ACTIVE TREATMENT =====
              const Text(
                "ACTIVE TREATMENT",
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 1.5,
                  color: Colors.white54,
                ),
              ),
              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF13273B),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "Pantoprazole 40mg",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      "14 Day Course • 8 Days Completed",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 8),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: 8 / 14,
                        minHeight: 6,
                        backgroundColor: Colors.white10,
                        color: Colors.tealAccent,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Escalation Alert",
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 12,
                          ),
                        ),
                        Switch(
                          value: escalationEnabled,
                          activeColor: Colors.tealAccent,
                          onChanged: (value) {
                            setState(() {
                              escalationEnabled = value;
                            });
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildGroupedDoses() {
    List<Widget> widgets = [];

    _groupedDoses.forEach((period, doses) {

      widgets.add(
        Text(
          period.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            letterSpacing: 1.2,
            color: Colors.white54,
          ),
        ),
      );

      widgets.add(const SizedBox(height: 10));

      for (var dose in doses) {
        widgets.add(
          GestureDetector(
            onTap: () {
              setState(() {
                dose.toggle();
              });
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF14283C),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: dose.borderColor,
                ),
              ),
              child: Row(
                children: [

                  Icon(
                    dose.icon,
                    color: dose.iconColor,
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dose.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dose.time,
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  _StatusChip(status: dose.status),
                ],
              ),
            ),
          ),
        );
      }
    });

    return widgets;
  }
}

/// ===== Dose Model =====
enum DoseStatus { pending, taken, missed }

class Dose {
  final String name;
  final String time;
  DoseStatus status;

  Dose({
    required this.name,
    required this.time,
    this.status = DoseStatus.pending,
  });

  void toggle() {
    if (status == DoseStatus.pending) {
      status = DoseStatus.taken;
    } else if (status == DoseStatus.taken) {
      status = DoseStatus.missed;
    } else {
      status = DoseStatus.pending;
    }
  }

  IconData get icon {
    switch (status) {
      case DoseStatus.taken:
        return Icons.check_circle;
      case DoseStatus.missed:
        return Icons.cancel;
      default:
        return Icons.radio_button_unchecked;
    }
  }

  Color get iconColor {
    switch (status) {
      case DoseStatus.taken:
        return Colors.greenAccent;
      case DoseStatus.missed:
        return Colors.redAccent;
      default:
        return Colors.white38;
    }
  }

  Color get borderColor {
    switch (status) {
      case DoseStatus.taken:
        return Colors.greenAccent.withOpacity(0.4);
      case DoseStatus.missed:
        return Colors.redAccent.withOpacity(0.4);
      default:
        return Colors.white.withOpacity(0.05);
    }
  }
}

/// ===== STATUS CHIP =====
class _StatusChip extends StatelessWidget {
  final DoseStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {

    String text;
    Color bg;

    switch (status) {
      case DoseStatus.taken:
        text = "Taken";
        bg = Colors.greenAccent;
        break;
      case DoseStatus.missed:
        text = "Missed";
        bg = Colors.redAccent;
        break;
      default:
        text = "Pending";
        bg = Colors.orangeAccent;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: bg,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}