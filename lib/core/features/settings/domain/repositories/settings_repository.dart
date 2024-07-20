
import 'package:dartz/dartz.dart';

import '../../../../error/failures.dart';
import '../entities/validation_config.dart';

abstract class SettingsRepository {
  Future<Either<Failure,List<String>>> loadCountries();
  Future<Either<Failure, Map<String, ValidationConfig>>> loadRegexes();
}