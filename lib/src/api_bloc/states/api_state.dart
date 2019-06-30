import 'package:packager_common/packager_common.dart';
import 'package:equatable/equatable.dart';

class DataState  { 
  List<BoxModel> boxes = [];
  SessionModel session;

  DataState(DataState state) {
    if (state != null) {
      this.boxes = state.boxes;
      this.session = state.session;
    }
  }
}

class ResourceEmptyState extends DataState {
  ResourceEmptyState(state): super(state);
}

class ResourceLoadState extends DataState {
  ResourceLoadState(state): super(state);
}

class ResourceSuccessState extends DataState {
  BaseEvent event;
  ResourceSuccessState(state, this.event): super(state);
}

// extends Equatable
class ResourceErrorState extends DataState {
  final String error;

  ResourceErrorState(state, this.error): super(state);
}

