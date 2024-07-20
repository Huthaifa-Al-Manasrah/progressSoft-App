import '../repositories/auth_repositories.dart';

class SendOtpUseCase {
  final AuthRepository repository;

  SendOtpUseCase(this.repository);

  Future<void> call(String phone) async {
    return await repository.sendOtpCode(phoneNumber: phone);
  }
}