import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:progress_soft_app/features/auth/domain/entities/app_user.dart';

class AppUserModel extends AppUser {
  const AppUserModel(
      {super.userId,
      super.fullName,
      super.email,
      super.mobileNumber,
      super.gender,
      super.dateBirth
      });

  factory AppUserModel.fromJson(Map<String, dynamic> json) =>
      AppUserModel(
        userId: json['userId'],
        gender: json['gender'],
        email: json['email'],
        dateBirth: (json['dateBirth'] as Timestamp).toDate(),
        fullName: json['fullName'],
        mobileNumber: json['mobileNumber'],
      );

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'gender': gender,
    'email': email,
    'dateBirth':dateBirth,
    'fullName':fullName,
    'mobileNumber':mobileNumber,
  };
}
