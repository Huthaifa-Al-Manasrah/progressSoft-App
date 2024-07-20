import 'package:dartz/dartz.dart';

import '../entities/app_user.dart';

abstract class AuthRepository {
  Future<Either<Exception, AppUser>> login(
      {required String email, required String password});

  Future<Either<Exception, AppUser>> register({required AppUser appUser, required String password});

  Future<Either<Exception, AppUser>> getCurrentUser();

  Future<void> logout();

  Future<String?> getSavedToken();

  Future<Either<Exception, AppUser>> updateUser(AppUser appUser, String userId);

  Future<bool?> isEmailRegistered({required String email});

  Future<void> sendOtpCode({required String phoneNumber});

  Future<void> verfiyOtpCode({required String otpCode});
}
