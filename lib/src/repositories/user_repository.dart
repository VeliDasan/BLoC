import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference collectionKisiler =
  FirebaseFirestore.instance.collection("Kisiler");

  Future<DocumentSnapshot> getUserInfo(String uid) async {
    try {
      return await collectionKisiler.doc(uid).get();
    } catch (e) {
      throw Exception('Error fetching user info: $e');
    }
  }
}
