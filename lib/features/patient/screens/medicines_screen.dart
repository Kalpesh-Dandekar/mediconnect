import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../services/patient/medicine_service.dart';
import '../../../services/patient/reminder_service.dart';
import '../../../services/patient/treatment_service.dart';

enum DoseStatus { pending, taken, missed }

class MedicinesScreen extends StatefulWidget {
  const MedicinesScreen({super.key});

  @override
  State<MedicinesScreen> createState() => _MedicinesScreenState();
}

class _MedicinesScreenState extends State<MedicinesScreen> {

  final MedicineService _medicineService = MedicineService();
  final TreatmentService _treatmentService = TreatmentService();

  Map<String, List<Dose>> _groupedDoses = {};
  final Set<String> _scheduledReminders = {};

  void scheduleReminder(String medicine, String time, String docId) {
    if (_scheduledReminders.contains(docId)) return;
    if (time.isEmpty) return;

    _scheduledReminders.add(docId);

    ReminderService.scheduleReminder(
      medicineName: medicine,
      time: time,
      id: docId.hashCode,
    );
  }

  @override
  void initState() {
    super.initState();

    _medicineService.getTodayMedicines().listen((snapshot) {

      Map<String, List<Dose>> grouped = {};

      for (var doc in snapshot.docs) {

        final data = doc.data() as Map<String, dynamic>;

        final period = (data["period"] ?? "Morning").toString();
        final name = (data["name"] ?? "").toString();
        final time = (data["time"] ?? "").toString();
        final status = (data["status"] ?? "pending").toString();

        scheduleReminder(name, time, doc.id);

        DoseStatus doseStatus = DoseStatus.pending;

        if (status == "taken") doseStatus = DoseStatus.taken;
        if (status == "missed") doseStatus = DoseStatus.missed;

        final dose = Dose(
          id: doc.id,
          name: name,
          time: time,
          status: doseStatus,
        );

        grouped.putIfAbsent(period, () => []);
        grouped[period]!.add(dose);
      }

      if (!mounted) return;

      setState(() {
        _groupedDoses = grouped;
      });

    });
  }

  int get _totalDoses =>
      _groupedDoses.values.expand((e) => e).length;

  int get _takenDoses =>
      _groupedDoses.values.expand((e) => e)
          .where((d) => d.status == DoseStatus.taken).length;

  double get _adherence =>
      _totalDoses == 0 ? 0 : _takenDoses / _totalDoses;

  String get _nextDose {
    for (var group in _groupedDoses.values) {
      for (final Dose dose in group) {
        if (dose.status == DoseStatus.pending) {
          return dose.time.isEmpty ? "--" : dose.time;
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

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF14283C),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Adherence Today",
                            style: TextStyle(color: Colors.white)),
                        Text("${(_adherence * 100).toInt()}%",
                            style: const TextStyle(color: Colors.tealAccent)),
                      ],
                    ),

                    const SizedBox(height: 10),

                    LinearProgressIndicator(
                      value: _adherence,
                      minHeight: 6,
                      backgroundColor: Colors.white10,
                      color: Colors.tealAccent,
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "$_takenDoses of $_totalDoses doses completed • Next: $_nextDose",
                      style: const TextStyle(color: Colors.white60),
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
        Text(period.toUpperCase(),
            style: const TextStyle(color: Colors.white54)),
      );

      widgets.add(const SizedBox(height: 10));

      for (final Dose dose in doses) {

        widgets.add(
          GestureDetector(
            onTap: () async {

              setState(() {
                dose.toggle();
              });

              await _medicineService.updateMedicineStatus(
                medicineId: dose.id,
                status: dose.status.name,
              );

              if (dose.status == DoseStatus.missed) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("⚠️ Missed dose recorded"),
                  ),
                );
              }
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF14283C),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: dose.borderColor),
              ),
              child: Row(
                children: [

                  Icon(dose.icon, color: dose.iconColor),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(dose.name,
                            style: const TextStyle(color: Colors.white)),
                        Text(
                          dose.time.isEmpty ? "--" : dose.time,
                          style: const TextStyle(color: Colors.white60),
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

/// MODEL
class Dose {

  final String id;
  final String name;
  final String time;
  DoseStatus status;

  Dose({
    required this.id,
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
        style: TextStyle(color: bg, fontSize: 11),
      ),
    );
  }
}