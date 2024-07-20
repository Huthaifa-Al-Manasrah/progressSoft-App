part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {

  @override
  List<Object> get props => [];
}
class AppStarted extends AuthEvent {}

class Login extends AuthEvent {
  final String email;
  final String password;

  Login(this.email, this.password);
}

class LogOut extends AuthEvent {}

class Register extends AuthEvent {
  final AppUser appUser;
  final String password;

  Register(
      {required this.appUser, required this.password});
}

class UpdateProfile extends AuthEvent {
  final AppUser appUser;

  UpdateProfile(this.appUser);
}

class SendOtp extends AuthEvent {
  final String phoneNumber;

  SendOtp({required this.phoneNumber});
}

class VerifyOtp extends AuthEvent {
  final String phoneNumber;
  final String otp;

  VerifyOtp({required this.phoneNumber, required this.otp});
}