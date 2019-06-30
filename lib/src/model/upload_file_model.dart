import 'dart:io';

class UploadFileModel {
  final File file;
  final String type;
  final String subtype;

  UploadFileModel(this.file, this.type, this.subtype);
}