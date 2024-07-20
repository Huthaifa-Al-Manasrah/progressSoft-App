import 'package:dartz/dartz.dart';

import '../../../../error/failures.dart';
import '../entities/validation_config.dart';
import '../repositories/settings_repository.dart';

class FetchRegexesUseCase{
  final SettingsRepository repository;

  FetchRegexesUseCase(this.repository);

  Future<Either<Failure, Map<String, ValidationConfig>>> call() async {
    return await repository.loadRegexes();
  }
}