import 'package:dartz/dartz.dart';
import 'package:progress_soft_app/features/auth/domain/entities/app_user.dart';

import '../repositories/auth_repositories.dart';

class CheckAuthStatusUseCase {
  final AuthRepository repository;

  CheckAuthStatusUseCase(this.repository);

  Future<Either<Exception, AppUser>> call() async {
    final token = await repository.getSavedToken();
    if (token != null) {
      return repository.getCurrentUser();
    }else{
      return Left(Exception('No token found'));
    }
  }
}