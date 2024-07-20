import 'package:equatable/equatable.dart';

class ValidationConfig extends Equatable{
  final String pattern;
  final String errorMessage;

  const ValidationConfig({required this.pattern, required this.errorMessage});

  @override
  List<Object?> get props => [pattern, errorMessage];
}
