import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progress_soft_app/features/auth/domain/entities/app_user.dart';
import 'package:progress_soft_app/features/auth/domain/use_cases/check_email_exists.dart';
import 'package:progress_soft_app/features/auth/domain/use_cases/send_otp_use_case.dart';
import 'package:progress_soft_app/features/auth/domain/use_cases/update_user_use_case.dart';
import 'package:progress_soft_app/features/auth/domain/use_cases/verfiy_otp_use_case.dart';

import '../../domain/use_cases/check_auth_status_use_case.dart';
import '../../domain/use_cases/get_saved_token_use_case.dart';
import '../../domain/use_cases/login_use_case.dart';
import '../../domain/use_cases/logout_use_case.dart';
import '../../domain/use_cases/register_use_case.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final CheckAuthStatusUseCase checkAuthStatusUseCase;
  final LogoutUseCase logoutUseCase;
  final GetSavedTokenUseCase getSavedTokenUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final CheckEmailExistsUseCase checkEmailExistsUseCase;
  final SendOtpUseCase sendOtpUseCase;
  final VerfiyOtpUseCase verfiyOtpUseCase;

  late AppUser appUser;

  AuthBloc(this.loginUseCase, this.registerUseCase, this.checkAuthStatusUseCase,
      this.logoutUseCase, this.getSavedTokenUseCase, this.updateUserUseCase, this.checkEmailExistsUseCase, this.sendOtpUseCase, this.verfiyOtpUseCase)
      : super(AuthInitial()) {

    on<AuthEvent>((event, emit) async {
      if (event is AppStarted) {
        emit(Logging());
        final token = await getSavedTokenUseCase();
        if (token != null) {
          final failureOrUser = await checkAuthStatusUseCase.call();
          emit(failureOrUser.fold((failure) => AuthError(failure.toString()),
              (user) {
            appUser = user;
            return AuthAuthenticated(user.userId);}));
        } else {
          emit(AuthUnauthenticated());
        }
      }

      if (event is Login) {
        emit(Logging());
        final bool exists = await checkEmailExistsUseCase.call(event.email) ?? false;
        log('in bloc exists?');
        log(exists.toString());
        final failureOrUser =
            await loginUseCase.call(event.email, event.password);
        emit(failureOrUser.fold((failure) {

          if(failure.toString().contains('invalid-credential')){
            if(exists){
              return AuthUnauthenticatedPasswordIncorrect();
            }else{
              return AuthUnauthenticatedUserNotFound();
            }
          }
          else
            if (failure.toString().contains('too-many-requests')) {
            return AuthUnauthenticatedTooManyAttempts();
          }
          else {
            return AuthError(failure.toString());
          }
        }, (user) {
          appUser = user;
          return Logged();
        }));
      }

      if (event is LogOut) {
        emit(LoggingOut());
        try {
          await logoutUseCase();
          emit(LoggedOut());
        } catch (error) {
          emit(AuthError(error.toString()));
        }
      }

      if (event is Register) {
        emit(Registering());
        final failureOrUser = await registerUseCase.call(event.appUser, event.password);
        emit(failureOrUser.fold((failure) => AuthError(failure.toString()),
            (user) {
          appUser = user;
          return Registered();
        }));
      }

      if (event is UpdateProfile) {
        emit(UpdatingProfile());
        final failureOrUser = await updateUserUseCase.call(event.appUser, appUser.userId!);
        emit(failureOrUser.fold((failure) => AuthError(failure.toString()),
                (user) {
          appUser = user;
          return ProfileUpdated(event.appUser);
        }));
      }

      if(event is SendOtp){
        try{
          emit(Registering());
          await sendOtpUseCase.call(event.phoneNumber);
          emit(OtpSent());
        }catch(e){
          emit(AuthError('Failed to send OTP: ${e.toString()}'));
        }
      }

      if(event is VerifyOtp){
        try{
          emit(Registering());
          await sendOtpUseCase.call(event.phoneNumber);
          emit(OtpVerified());
        }catch(e){
          emit(AuthError('Failed to verify OTP: ${e.toString()}'));
        }
      }
    });
  }
}
