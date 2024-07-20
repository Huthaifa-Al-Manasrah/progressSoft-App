part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable{
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String? userId;

  AuthAuthenticated(this.userId);
}

class AuthUnauthenticated extends AuthState {}

class AuthUnauthenticatedUserNotFound extends AuthState {}

class AuthUnauthenticatedPasswordIncorrect extends AuthState {}

class AuthUnauthenticatedTooManyAttempts extends AuthState {}

class Logging extends AuthState {}

class Logged extends AuthState {}

class Registering extends AuthState {}

class Registered extends AuthState {}

class LoggingOut extends AuthState {}

class LoggedOut extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

class UpdatingProfile extends AuthState {}

class ProfileUpdated extends AuthState {
  final AppUser appUser;

  ProfileUpdated(this.appUser);
}

class OtpSent extends AuthState {}

class OtpVerified extends AuthState {}

