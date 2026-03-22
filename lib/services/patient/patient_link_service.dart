import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientLinkService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔥 Generate random 6-char code
  String _generateCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random();

    return String.fromCharCodes(
      Iterable.generate(
        6,
            (_) => chars.codeUnitAt(rand.nextInt(chars.length)),
      ),
    );
  }

  /// 🔥 Create / Update Link Code
  Future<String> generateAndSaveCode(String patientId) async {
    try {
      final code = _generateCode();

      await _firestore
          .collection('patients')
          .doc(patientId)
          .set({"linkCode": code}, SetOptions(merge: true));

      return code;
    } catch (e) {
      throw Exception("Failed to generate code: $e");
    }
  }

  /// 🔥 Get existing code
  Future<String?> getLinkCode(String patientId) async {
    try {
      final doc = await _firestore
          .collection('patients')
          .doc(patientId)
          .get();

      if (!doc.exists) return null;

      return doc.data()?["linkCode"];
    } catch (e) {
      throw Exception("Failed to fetch code: $e");
    }
  }
}