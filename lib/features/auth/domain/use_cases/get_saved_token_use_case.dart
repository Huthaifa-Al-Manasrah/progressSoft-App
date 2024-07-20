import '../repositories/auth_repositories.dart';

class GetSavedTokenUseCase {
  final AuthRepository repository;

  GetSavedTokenUseCase(this.repository);

  Future<String?> call() {
    return repository.getSavedToken();
  }
}