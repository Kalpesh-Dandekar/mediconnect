import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SeedDatabase {

  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static Future<void> run() async {

    final user = _auth.currentUser;

    if (user == null) {
      print("User not logged in. Cannot seed.");
      return;
    }

    final uid = user.uid;

    print("Seeding database for UID: $uid");

    /// ---------- USERS (Doctors) ----------

    await _firestore.collection("users").doc("doctor_1").set({
      "name": "Dr. Michael Smith",
      "email": "smith@mediconnect.com",
      "role": "doctor",
      "department": "Gastroenterology",
      "experience": "12 years"
    });

    await _firestore.collection("users").doc("doctor_2").set({
      "name": "Dr. Anita Sharma",
      "email": "anita@mediconnect.com",
      "role": "doctor",
      "department": "Dermatology",
      "experience": "8 years"
    });

    /// ---------- APPOINTMENTS ----------

    await _firestore.collection("appointments").add({
      "patientId": uid,
      "doctorId": "doctor_1",
      "doctorName": "Dr. Michael Smith",
      "department": "Gastroenterology",
      "date": "12 Apr",
      "timeSlot": "10:30 AM",
      "status": "confirmed",
      "createdAt": FieldValue.serverTimestamp()
    });

    await _firestore.collection("appointments").add({
      "patientId": uid,
      "doctorId": "doctor_2",
      "doctorName": "Dr. Anita Sharma",
      "department": "Dermatology",
      "date": "15 Apr",
      "timeSlot": "11:00 AM",
      "status": "pending",
      "createdAt": FieldValue.serverTimestamp()
    });

    await _firestore.collection("appointments").add({
      "patientId": uid,
      "doctorId": "doctor_1",
      "doctorName": "Dr. Michael Smith",
      "department": "Gastroenterology",
      "date": "24 Mar",
      "timeSlot": "09:00 AM",
      "status": "completed",
      "createdAt": FieldValue.serverTimestamp()
    });

    /// ---------- MEDICINES ----------

    await _firestore.collection("medicines").add({
      "patientId": uid,
      "name": "Pantoprazole 40mg",
      "time": "05:45 AM",
      "period": "Morning",
      "status": "taken"
    });

    await _firestore.collection("medicines").add({
      "patientId": uid,
      "name": "Vitamin D3",
      "time": "05:45 PM",
      "period": "Afternoon",
      "status": "pending"
    });

    await _firestore.collection("medicines").add({
      "patientId": uid,
      "name": "Pantoprazole 40mg",
      "time": "05:45 PM",
      "period": "Evening",
      "status": "pending"
    });

    /// ---------- REPORTS ----------

    await _firestore.collection("reports").add({
      "patientId": uid,
      "testName": "Complete Blood Count",
      "status": "pending",
      "givenOn": "20 Mar",
      "expectedOn": "23 Mar",
      "labName": "City Diagnostics Lab"
    });

    await _firestore.collection("reports").add({
      "patientId": uid,
      "testName": "Liver Function Test",
      "doctorName": "Dr. Michael Smith",
      "uploadedOn": "15 Mar",
      "resultStatus": "Normal",
      "status": "available"
    });

    /// ---------- EMERGENCY ----------

    await _firestore.collection("emergencies").add({
      "patientId": uid,
      "type": "doctor",
      "status": "pending",
      "createdAt": FieldValue.serverTimestamp()
    });

    print("Seed completed successfully.");
  }
}