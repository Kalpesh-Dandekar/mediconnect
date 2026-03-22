import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mediconnect/services/relative/relative_medicine_service.dart';
import 'package:mediconnect/services/relative/relative_patient_service.dart';

enum DoseStatus { pending, taken, missed }

class RelativeMedicationsScreen extends StatefulWidget {
  const RelativeMedicationsScreen({super.key});

  @override
  State<RelativeMedicationsScreen> createState() =>
      _RelativeMedicationsScreenState();
}

class _RelativeMedicationsScreenState
    extends State<RelativeMedicationsScreen> {

  final RelativeMedicineService _medicineService =
  RelativeMedicineService();

  final RelativePatientService _patientService =
  RelativePatientService();

  Map<String, List<Dose>> _groupedDoses = {};

  String patientName = "Loading...";
  String? patientId;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final patient =
    await _patientService.getPatient(user.uid);

    if (patient == null) {
      setState(() => loading = false);
      return;
    }

    patientId = patient['id'];
    patientName = patient['name'] ?? "Patient";

    _listenMedicines();
  }

  void _listenMedicines() {
    if (patientId == null) return;

    _medicineService
        .getTodayMedicines(patientId!)
        .listen((snapshot) {

      Map<String, List<Dose>> grouped = {};

      for (var doc in snapshot.docs) {

        final data = doc.data() as Map<String, dynamic>;

        final period = (data["period"] ?? "Morning").toString();
        final name = (data["name"] ?? "").toString();
        final time = (data["time"] ?? "").toString();
        final status = (data["status"] ?? "pending").toString();

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
        loading = false;
      });
    });
  }

  int get _totalDoses =>
      _groupedDoses.values.expand((e) => e).length;

  int get _takenDoses =>
      _groupedDoses.values.expand((e) => e)
          .where((d) => d.status == DoseStatus.taken)
          .length;

  double get _adherence =>
      _totalDoses == 0 ? 0 : _takenDoses / _totalDoses;

  String get _nextDose {
    for (var group in _groupedDoses.values) {
      for (final dose in group) {
        if (dose.status == DoseStatus.pending) {
          return dose.time.isEmpty ? "--" : dose.time;
        }
      }
    }
    return "All completed";
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF0C1B2A),
      body: SafeArea(
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// HEADER
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
                "Monitoring: $patientName",
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

              /// ADHERENCE
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
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Adherence Today",
                            style: TextStyle(color: Colors.white)),
                        Text(
                          "${(_adherence * 100).toInt()}%",
                          style: const TextStyle(
                              color: Colors.tealAccent),
                        ),
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

      for (final dose in doses) {
        widgets.add(
          Container(
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
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(dose.name,
                          style: const TextStyle(
                              color: Colors.white)),
                      Text(
                        dose.time.isEmpty ? "--" : dose.time,
                        style: const TextStyle(
                            color: Colors.white60),
                      ),
                    ],
                  ),
                ),

                _StatusChip(status: dose.status),
              ],
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

/// STATUS CHIP
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
      padding: const EdgeInsets.symmetric(
          horizontal: 10, vertical: 4),
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