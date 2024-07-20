import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user_model.dart';

class FirebaseUserDatasource {
  final FirebaseFirestore _firebaseFireStore = FirebaseFirestore.instance;

  Future<void> saveUser(AppUserModel user) async {
    try {
      await _firebaseFireStore.collection('users').doc(user.userId).set(user.toJson());
    } catch (e) {
      throw Exception('Failed to save user: $e');
    }
  }

  Future<AppUserModel?> getUser(String userId) async {
    try {
      final doc = await _firebaseFireStore.collection('users').doc(userId).get();
      if (doc.exists) {
        return AppUserModel.fromJson(doc.data()!);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  Future<AppUserModel?> updateUser(AppUserModel appUser, String userId) async {
    try {
      await _firebaseFireStore.collection('users').doc(userId).update(appUser.toJson());
      return await getUser(userId);
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  Future<bool?> checkEmailRegistired(String email) async {
    try {
      final querySnapshot = await _firebaseFireStore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking email: $e');
      return false;
    }
  }
}