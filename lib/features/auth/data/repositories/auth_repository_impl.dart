import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:progress_soft_app/features/auth/data/models/app_user_model.dart';

import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repositories.dart';
import '../data_sources/auth_local_data_source.dart';
import '../data_sources/firebase_auth_data_source.dart';
import '../data_sources/firebase_user_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDatasource authDatasource;
  final FirebaseUserDatasource userDatasource;
  final AuthLocalDataSource authLocalDataSource;

  AuthRepositoryImpl(
      this.authDatasource, this.userDatasource, this.authLocalDataSource);

  @override
  Future<Either<Exception, AppUser>> login(
      {required String email, required String password}) async {
    try {
      final userCredential = await authDatasource.login(email, password);
      if (userCredential != null) {
        final idToken = await authDatasource.getIdToken(userCredential);
        await authLocalDataSource.saveToken(idToken!);
        final userModel = await userDatasource.getUser(userCredential.uid);
        return Right(AppUser(
          userId: userCredential.uid,
          fullName: userModel?.fullName ?? '',
          mobileNumber: userCredential.phoneNumber ?? '',
          gender: userModel?.gender ?? '',
          email: userModel?.email ?? '',
          dateBirth: userModel?.dateBirth,
        ));
      } else {
        return Left(Exception('Login failed'));
      }
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, AppUser>> register(
      {required AppUser appUser, required String password}) async {
    try {
      final userCredential =
          await authDatasource.register(appUser.email!, password);
      if (userCredential != null) {
        final userModel = AppUserModel(
            userId: userCredential.uid,
            fullName: appUser.fullName,
            mobileNumber: appUser.mobileNumber,
            gender: appUser.gender,
            email: appUser.email,
            dateBirth: appUser.dateBirth,
        );
        await userDatasource.saveUser(userModel);
        final idToken = await authDatasource.getIdToken(userCredential);
        await authLocalDataSource.saveToken(idToken!);
        return Right(AppUser(
            userId: userCredential.uid,
            fullName: appUser.fullName,
            mobileNumber: appUser.mobileNumber,
            gender: appUser.gender,
            dateBirth: appUser.dateBirth,
            email: appUser.email,
            ));
      } else {
        return Left(Exception('Registration failed'));
      }
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, AppUser>> getCurrentUser() async {
    try {
      final userCredential = await authDatasource.getCurrentUser();
      if (userCredential == null) return Left(Exception('No user logged in'));

      final userModel = await userDatasource.getUser(userCredential.uid);
      return Right(AppUser(
        userId: userModel?.userId ?? '',
          fullName: userModel?.fullName ?? '',
          mobileNumber: userModel?.mobileNumber ?? '',
          email: userModel?.email ?? '',
          gender: userModel?.gender ?? '',
          dateBirth: userModel?.dateBirth
      ));
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<void> logout() async {
    await authDatasource.logout();
    await authLocalDataSource.deleteToken();
  }

  @override
  Future<String?> getSavedToken() async {
    final token = await authLocalDataSource.getToken();
    return token;
  }

  @override
  Future<Either<Exception, AppUser>> updateUser(AppUser appUser, String userId) async {
    try {
      await userDatasource.updateUser(AppUserModel(
        userId: userId,
        email: appUser.email,
          fullName: appUser.fullName,
          mobileNumber: appUser.mobileNumber,
          gender: appUser.gender,
          dateBirth: appUser.dateBirth),
        userId
      );
      return getCurrentUser();
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<bool?> isEmailRegistered({required String email}) async {
    return await userDatasource.checkEmailRegistired(email);
  }

  @override
  Future<void> sendOtpCode({required phoneNumber}) async {
    await authDatasource.sendOtpCode(phoneNumber: phoneNumber);
  }

  @override
  Future<void> verfiyOtpCode({required String otpCode}) async {
    await authDatasource.verfiyOtpCode(code: otpCode);
  }


}
