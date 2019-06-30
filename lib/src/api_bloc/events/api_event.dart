import 'package:equatable/equatable.dart';

abstract class BaseEvent extends Equatable {
  final String name;
  final String action;
  final dynamic payload;
  BaseEvent(this.name, this.action, [this.payload = null]) : super([name, action, payload]);
}

class ResourceAction extends BaseEvent {
  ResourceAction(name, action, [payload = null]): super(name, action, payload);
}