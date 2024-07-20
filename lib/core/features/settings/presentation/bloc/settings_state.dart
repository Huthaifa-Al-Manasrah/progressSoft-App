part of 'settings_bloc.dart';

@immutable
abstract class SettingsState extends Equatable{
  final Map<String, ValidationConfig> regexPatterns;
  final List<String> countries;

  const SettingsState({
    required this.regexPatterns,
    required this.countries,
  });

  @override
  List<Object?> get props => [regexPatterns, countries];
}

class SettingsInitial extends SettingsState {
  SettingsInitial() : super(regexPatterns: {}, countries: []);
}

class SettingsLoading extends SettingsState {
  SettingsLoading() : super(regexPatterns: {}, countries: []);
}

class SettingsLoaded extends SettingsState {
  const SettingsLoaded({
    required super.regexPatterns,
    required super.countries,
  });
}

class SettingsError extends SettingsState {
  final String message;
  SettingsError(this.message) : super(regexPatterns: {}, countries: []);
}
