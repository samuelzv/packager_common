import './index.dart';

class ModelError extends Model {
  final String message;

  ModelError({this.message});

  @override
  static ModelError fromJson(dynamic json) {
    return ModelError(
      message: json['message'] as String,
    );
  }

  @override
  static List<ModelError> fromJsonArray(List<dynamic> json) {
    final errors = json 
      .map((dynamic e) => ModelError.fromJson(e as Map<String, dynamic>))
      .toList();

    return errors;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'message': message
    };
  }
}