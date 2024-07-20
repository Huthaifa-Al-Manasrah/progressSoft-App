import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/validation_config.dart';
import '../../domain/use_cases/fetch_countries_use_case.dart';
import '../../domain/use_cases/fetch_regexes_use_case.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final FetchRegexesUseCase fetchRegexesUseCase;
  final FetchCountriesUseCase fetchCountriesUseCase;

  SettingsBloc(
      {required this.fetchCountriesUseCase, required this.fetchRegexesUseCase})
      : super(SettingsInitial()) {
    on<SettingsEvent>((event, emit) async {
      if (event is LoadSettings) {
        emit(SettingsLoading());
        final failureOrCountries = await fetchCountriesUseCase.call();
        final failureOrRegexes = await fetchRegexesUseCase.call();
        late List<String> countries;
        late Map<String, ValidationConfig> regexes;

        failureOrCountries.fold((failure) {
          emit(SettingsError("Failed to load Countries"));
        }, (data) {
          countries = data;
        });

        failureOrRegexes.fold((failure) {
          emit(SettingsError("Failed to load Regexes"));
        }, (data) {
          regexes = data;
        });

        emit(SettingsLoaded(countries: countries, regexPatterns: regexes));
      }
    });
  }
}
