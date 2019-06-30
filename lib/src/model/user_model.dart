import './index.dart';

class UserModel extends Model{
  final int id;
  final String email;
  final String password;

  UserModel({this.id, this.email, this.password});

  @override
  UserModel fromJson(dynamic json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  @override
  List<UserModel> fromJsonArray(List<dynamic> json) {
    final boxes = json 
      .map((dynamic box) => UserModel().fromJson(box as Map<String, dynamic>))
      .toList();

    return boxes;
  }

  @override
  Map<String, dynamic> toJson()  =>
    {
      "id": id,
      "name": email,
      "description": password,
    };
}