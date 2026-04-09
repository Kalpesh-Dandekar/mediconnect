import 'package:cloud_firestore/cloud_firestore.dart';

class ClearDbService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> clearAllData() async {
    print("🧹 START CLEARING DATABASE...");

    try {
      final collections = [
        "appointments",
        "consultations",
        "emergencies",
        "medicines",
        "notifications",
        "patients",
        "reports",
        "treatments",
      ];

      for (String col in collections) {
        final snapshot = await _db.collection(col).get();

        for (var doc in snapshot.docs) {
          await doc.reference.delete();
        }

        print("✅ Cleared: $col");
      }

      print("🎉 DATABASE CLEARED");
    } catch (e) {
      print("❌ ERROR: $e");
    }
  }
}