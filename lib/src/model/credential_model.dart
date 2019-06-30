import './index.dart';

class CredentialModel extends Model {
  CredentialModel(this.email, this.password);

  String email;
  String password;
  String temporaryPassword;

 @override
 static CredentialModel fromJson(dynamic json) {
    return CredentialModel(
      json['email'] as String,
      json['password'] as String,
    );
  }

  @override
  static List<dynamic> fromJsonArray(List<dynamic> json) {
    return null;
  }

  @override
  Map<String, dynamic> toJson()  =>
    {
      "email": email,
      "password": password,
      "temporaryPassword": temporaryPassword
    };
}