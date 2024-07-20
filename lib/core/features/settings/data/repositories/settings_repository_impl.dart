import 'package:dartz/dartz.dart';

import '../../../../error/exceptions.dart';
import '../../../../error/failures.dart';
import '../../../../network/network_info.dart';
import '../../domain/repositories/settings_repository.dart';
import '../data_sources/settings_fire_base_rource.dart';
import '../models/validation_config_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsFireBaseSource settingsFireBaseRource;
  final NetworkInfo networkInfo;
  SettingsRepositoryImpl({required this.settingsFireBaseRource, required this.networkInfo});


  @override
  Future<Either<Failure, List<String>>> loadCountries() async {
    if (await networkInfo.isConnected) {
      try {
        final countries = await settingsFireBaseRource.getCountries();
        return Right(countries);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Map<String, ValidationConfigModel>>> loadRegexes() async {
    if (await networkInfo.isConnected) {
      try {
        final regexes = await settingsFireBaseRource.getRegexes();
        return Right(regexes);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}