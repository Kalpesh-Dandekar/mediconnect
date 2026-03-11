import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmergencyService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createEmergency(String type) async {

    final uid = _auth.currentUser!.uid;

    await _firestore.collection("emergencies").add({
      "patientId": uid,
      "type": type,
      "status": "pending",
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

}