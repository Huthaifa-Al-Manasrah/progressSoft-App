import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:progress_soft_app/core/error/exceptions.dart';

import '../models/validation_config_model.dart';

abstract class SettingsFireBaseSource {
  Future<List<String>> getCountries();
  Future<Map<String, ValidationConfigModel>> getRegexes();
}

class FirebaseDataSourceImpl implements SettingsFireBaseSource {
  final FirebaseFirestore fireStore;

  FirebaseDataSourceImpl({required this.fireStore});

  String  appConfigCollection = 'app_config';
  String countriesDoc = 'countries';
  String regexDoc = 'regexDoc';

  @override
  Future<List<String>> getCountries() async {
      try {
        DocumentSnapshot snapshot = await fireStore.collection(appConfigCollection).doc(countriesDoc).get();
        if (snapshot.exists) {
          final  map = snapshot.data() as Map<String,dynamic>;
          final countriesCodes = map['codes'] as List<dynamic>;
          final List<String> mappedList = List<String>.from(countriesCodes);
          return mappedList;
        } else {
          throw ServerException();
        }
      } catch (e) {
        throw InternalException();
      }
  }

  @override
  Future<Map<String, ValidationConfigModel>> getRegexes() async {
    try {
      DocumentSnapshot snapshot = await fireStore.collection(appConfigCollection).doc(regexDoc).get();
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final regexes = data['regexes'] as Map<String, dynamic>;
        final Map<String, ValidationConfigModel> configs = {};
        regexes.forEach((key, value) {
          configs[key] = ValidationConfigModel.fromMap(value);
        });
        return configs;
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw InternalException();
    }
  }
}