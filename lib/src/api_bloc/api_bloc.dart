import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:packager_common/packager_common.dart';

class APIBloc extends Bloc<BaseEvent, DataState> {
  final APIClient client;
  final DataState appState;

  APIBloc({@required this.client, appState}) : this.appState = DataState(null);

  @override
  DataState get initialState => ResourceEmptyState(appState);

  @override
  Stream<DataState> mapEventToState(BaseEvent event) async* {
    if (event is ResourceAction) {
      yield ResourceLoadState(appState);

      try {
        DataState newState = await this.client.execute(event.name, event.action, event.payload, appState);
        // update state
        appState.boxes = List<BoxModel>.from(newState.boxes);
        if (newState.session != null) {
          appState.session = newState.session;
        }

        yield ResourceSuccessState(appState, event);
      } catch (error) {
        print('There are errors:');
        print(error);
        if(error is ModelError) {
          yield ResourceErrorState(appState, error.message);
        } else {
          yield ResourceErrorState(appState, 'something went wrong');
        }
      }
    }
  }
}