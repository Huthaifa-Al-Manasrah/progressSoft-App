import 'package:dartz/dartz.dart';

import '../entities/app_user.dart';
import '../repositories/auth_repositories.dart';
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Exception, AppUser>> call(String email, String password) {
    return repository.login(email: email, password: password);
  }
}