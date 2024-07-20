import 'package:dartz/dartz.dart';

import '../../../../error/failures.dart';
import '../repositories/settings_repository.dart';

class FetchCountriesUseCase{
  final SettingsRepository repository;

  FetchCountriesUseCase(this.repository);

  Future<Either<Failure, List<String>>> call() async {
    return await repository.loadCountries();
  }
}