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
  static List<dynamic> fromJsonArray(List<dynamic> json) {
    final boxes = json 
      .map((dynamic box) => ModelError.fromJson(box as Map<String, dynamic>))
      .toList();

    return boxes;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'message': message
    };
  }
}