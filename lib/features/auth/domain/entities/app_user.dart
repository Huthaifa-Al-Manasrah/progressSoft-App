import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String? userId;
  final String? fullName;
  final String? email;
  final String? mobileNumber;
  final String? gender;
  final DateTime? dateBirth;

  const AppUser(
      {this.userId,
        this.fullName,
      this.email,
      this.mobileNumber,
      this.gender,
      this.dateBirth
      });

  @override
  List<Object?> get props => [userId, fullName, email, mobileNumber, gender, dateBirth];
}