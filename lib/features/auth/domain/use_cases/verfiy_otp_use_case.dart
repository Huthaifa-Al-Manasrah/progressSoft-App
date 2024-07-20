import '../repositories/auth_repositories.dart';

class VerfiyOtpUseCase {
  final AuthRepository repository;

  VerfiyOtpUseCase(this.repository);

  Future<bool?> call(String email) async {
    return await repository.isEmailRegistered(email: email);
  }
}