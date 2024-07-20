import 'package:dartz/dartz.dart';

import '../entities/app_user.dart';
import '../repositories/auth_repositories.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Exception, AppUser>> call(AppUser appUser, String password) {
    return repository.register(appUser: appUser, password: password);
  }
}