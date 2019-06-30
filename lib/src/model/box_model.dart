import './index.dart';

class BoxModel extends Model{
  final int id;
  final String name;
  final String description;
  final String pictureUrl;
  final UploadFileModel file;


  BoxModel({this.id, this.name, this.description, this.pictureUrl, this.file});

  @override
  static BoxModel fromJson(dynamic json) {
    return BoxModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      pictureUrl: json['pictureUrl'] as String
    );
  }

  @override
  static List<BoxModel> fromJsonArray(List<dynamic> json) {
    final boxes = json 
      .map((dynamic box) => BoxModel.fromJson(box as Map<String, dynamic>))
      .toList();

    return boxes;
  }

  @override
  Map<String, dynamic> toJson()  =>
    {
      "id": id,
      "name": name,
      "description": description,
      "pictureUrl": pictureUrl
    };
}