import 'package:equatable/equatable.dart';

abstract class Model extends Equatable {
  Model([List props = const []]) : super(props);

  // to be overriden
  static dynamic fromJson(dynamic json) => null;
  static List<dynamic> fromJsonArray(List<dynamic> json) => null; 

  // not static
  Map<String, dynamic> toJson() => null; 
}