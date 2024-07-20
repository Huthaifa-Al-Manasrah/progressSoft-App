import 'package:dartz/dartz.dart';

import '../entities/app_user.dart';
import '../repositories/auth_repositories.dart';

class UpdateUserUseCase {
  final AuthRepository repository;

  UpdateUserUseCase(this.repository);

  Future<Either<Exception, AppUser>> call(AppUser appUser, String userId) {
    return repository.updateUser(appUser, userId);
  }
}