import '../../domain/entities/validation_config.dart';

class ValidationConfigModel extends ValidationConfig {
  const ValidationConfigModel({required super.pattern, required super.errorMessage});

  factory ValidationConfigModel.fromMap(Map<String, dynamic> map) {
    return ValidationConfigModel(
      pattern: map['pattern'],
      errorMessage: map['errorMessage'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pattern': pattern,
      'errorMessage': errorMessage,
    };
  }
}