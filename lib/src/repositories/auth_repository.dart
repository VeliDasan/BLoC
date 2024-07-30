import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference collectionKisiler =
  FirebaseFirestore.instance.collection("Kisiler");

  Future<void> signUp(
      {required String email,
        required String password,
        required String name,
        required String surname}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      await addUserToFirestore(
          userCredential.user?.uid, email, password, name, surname);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('This password is too weak');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('The email address is already in use');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      String? uid = userCredential.user?.uid;
      if (uid != null) {
        await updateUserLoginInfo(uid);
      }

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        return false;
      }
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> addUserToFirestore(String? uid, String email, String password,
      String name, String surname) async {
    if (uid == null) return;

    await collectionKisiler.doc(uid).set({
      'email': email,
      'password': password,
      'name': name,
      'surname': surname,
      'createdAt': Timestamp.now(),
      'loginTimes': FieldValue.arrayUnion([Timestamp.now()]),
    });
  }

  Future<void> updateUserLoginInfo(String uid) async {
    Timestamp now = Timestamp.now();
    await collectionKisiler.doc(uid).update({
      'lastLogin': now,
      'loginTimes': FieldValue.arrayUnion([now]),
    });
  }

  Future<void> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>?> getUserLoginInfo(String uid) async {
    DocumentSnapshot documentSnapshot = await collectionKisiler.doc(uid).get();
    if (documentSnapshot.exists) {
      return documentSnapshot.data() as Map<String, dynamic>?;
    }
    return null;
  }
}
