import 'index.dart';

class SessionModel extends Model {
  SessionModel(this.accessToken, this.idToken, this.refreshToken);

  String accessToken;
  String idToken;
  dynamic refreshToken;

  @override
  static dynamic fromJson(dynamic json) {
      return SessionModel(
        json['accessToken'] as String,
        json['idToken'] as String,
        json['refreshToken'] as dynamic
      );
  }

  @override
  static List<dynamic> fromJsonArray(List<dynamic> json) {
    return null;
  }

  @override
  Map<String, dynamic> toJson()  =>
    {
      "accessToken": accessToken,
      "idToken": idToken,
      "refreshToken": refreshToken
    };
}