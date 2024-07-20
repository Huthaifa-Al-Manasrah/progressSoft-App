import '../repositories/auth_repositories.dart';

class CheckEmailExistsUseCase {
  final AuthRepository repository;

  CheckEmailExistsUseCase(this.repository);

  Future<bool?> call(String email) async {
    return await repository.isEmailRegistered(email: email);
  }
}