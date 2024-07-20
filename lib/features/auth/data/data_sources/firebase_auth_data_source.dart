import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthDatasource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  Future<User?> login(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      log('login issues');
      log(e.code.toString());
      log(e.code);
      throw Exception('Login failed: ${e.code}');
    }
  }

  Future<String?> getIdToken(User user) async {
    try {
      return await user.getIdToken();
    } catch (e) {
      throw Exception('Failed to get ID token: $e');
    }
  }

  Future<User?> register(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception('Registration failed: ${e.message}');
    }
  }

  Future<User?> getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }

  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception("Logout failed: $e");
    }
  }

  Future<void> sendOtpCode({required phoneNumber}) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {},
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> verfiyOtpCode({required String code}) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: 'verificationId', // Retrieve this from storage
      smsCode: code,
    );

    await _firebaseAuth.signInWithCredential(credential);
  }
}