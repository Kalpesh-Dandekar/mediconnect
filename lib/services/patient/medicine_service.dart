import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MedicineService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// 🔥 GET TODAY MEDICINES
  Stream<QuerySnapshot> getTodayMedicines() {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    final now = DateTime.now();

    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return _firestore
        .collection("medicines")
        .where("patientId", isEqualTo: user.uid)
        .where("date", isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where("date", isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .orderBy("date")
        .snapshots();
  }

  /// 🔥 UPDATE STATUS
  Future<void> updateMedicineStatus({
    required String medicineId,
    required String status,
  }) async {
    final docRef = _firestore.collection("medicines").doc(medicineId);

    final doc = await docRef.get();
    final data = doc.data() as Map<String, dynamic>;

    int missedCount = data["missedCount"] ?? 0;
    bool alertSent = data["alertSent"] ?? false;

    /// 🔁 STATUS LOGIC
    if (status == "taken") {
      missedCount = 0;
      alertSent = false;
    } else if (status == "missed") {
      missedCount += 1;
    }

    await docRef.update({
      "status": status,
      "missedCount": missedCount,
      "alertSent": alertSent,
    });

    print("Missed Count: $missedCount");

    /// 🚨 🔥 TEST MODE: ALERT ON FIRST MISS
    if (missedCount >= 1 && !alertSent) {
      await _notifyRelative(data);
      await docRef.update({"alertSent": true});
    }
  }

  /// 🔥 SEND ALERT + PUSH NOTIFICATION
  Future<void> _notifyRelative(Map<String, dynamic> medicineData) async {
    final patientId = medicineData["patientId"];

    /// 🔍 GET RELATIVE ID
    final userDoc =
    await _firestore.collection("users").doc(patientId).get();

    final relativeId = userDoc.data()?["relativeId"];

    if (relativeId == null) {
      print("❌ No relativeId found");
      return;
    }

    /// 🔍 GET FCM TOKEN
    final relativeDoc =
    await _firestore.collection("users").doc(relativeId).get();

    final fcmToken = relativeDoc.data()?["fcmToken"];

    if (fcmToken == null) {
      print("❌ No FCM token found");
      return;
    }

    /// 🔥 SEND PUSH NOTIFICATION
    const serverKey = "YOUR_SERVER_KEY_HERE"; // 🔴 PUT YOUR KEY

    try {
      final response = await http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "key=$serverKey",
        },
        body: jsonEncode({
          "to": fcmToken,
          "notification": {
            "title": "🚨 Medicine Alert",
            "body":
            "Patient missed ${medicineData["name"]} medication",
          },
          "priority": "high",
        }),
      );

      print("📡 FCM Response: ${response.body}");

    } catch (e) {
      print("❌ FCM ERROR: $e");
    }

    /// 🔥 SAVE IN FIRESTORE (FOR UI)
    await _firestore.collection("notifications").add({
      "toUserId": relativeId,
      "message":
      "🚨 Patient missed medicine (${medicineData["name"]})",
      "type": "medicine_alert",
      "timestamp": FieldValue.serverTimestamp(),
      "patientId": patientId,
    });

    print("🚨 ALERT SENT TO RELATIVE");
  }

  /// 🔥 ADD MEDICINES
  Future<void> addMedicinesFromConsultation({
    required String patientId,
    required List<Map<String, dynamic>> prescriptions,
  }) async {
    final batch = _firestore.batch();
    final now = DateTime.now();

    for (var med in prescriptions) {
      final name = med["medicine"] ?? "";
      final duration = int.tryParse(med["duration"].toString()) ?? 1;
      final timings = List<String>.from(med["timings"] ?? []);

      for (int day = 0; day < duration; day++) {
        final date = now.add(Duration(days: day));

        for (var timing in timings) {
          final docRef = _firestore.collection("medicines").doc();

          batch.set(docRef, {
            "patientId": patientId,
            "name": name,
            "period": timing,
            "time": "Test",
            "status": "pending",
            "missedCount": 0,
            "alertSent": false,
            "date": Timestamp.fromDate(date),
            "createdAt": FieldValue.serverTimestamp(),
          });
        }
      }
    }

    await batch.commit();
  }
}