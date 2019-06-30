import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:packager_common/packager_common.dart';
import 'package:http_parser/http_parser.dart';

class APIClient {
  final String baseUrl;
  final http.Client httpClient;

  APIClient({
    http.Client httpClient,
    this.baseUrl
  }) : this.httpClient = httpClient ?? http.Client();


/*
  Future<List<T>> _list<T extends Model, E extends Model>(String resourceName, Function(List<dynamic>) fromJsonArray, Function(dynamic) fromJsonError) async {
    final Response response = await httpClient
      .get(Uri.parse("${baseUrl}/$resourceName"));

    final results = json.decode(response.body);

    if (response.statusCode == 200) {
      return fromJsonArray(results);
    } else {
      throw fromJsonError(results);
    }
  }
*/


/*
  Future<T> _add<T extends Model, E extends Model>(String resourceName, dynamic payload, Function(dynamic) fromJson, Function(dynamic) fromJsonError) async {
    final body = json.encode(payload.toJson());
    final url = Uri.parse("${baseUrl}/$resourceName");
    final headers =  {'Content-Type': 'application/json'};

    final Response response = await httpClient.post(url, headers: headers, body: body);

    final results = json.decode(response.body);

    if (response.statusCode == 200) {
      return fromJson(results);
    } else {
      throw fromJsonError(results);
    }
  }
  */

  Future<BoxModel> _addBox(dynamic payload, String authToken) async {
    final uploadResponse = await _upload(payload.file, authToken);
    final results = json.decode(uploadResponse.body);
    final uploadResult = results[0]['result'].toString(); 

    BoxModel box = BoxModel(
      name: payload.name,
      description: payload.description,
      pictureUrl :  uploadResult
    );

    final body = json.encode(box);
    final url = Uri.parse("${baseUrl}/boxes");
    final headers =  {'Content-Type': 'application/json'};

    final Response response = await httpClient.post(url, headers: headers, body: body);
    final results = json.decode(response.body);

    if (response.statusCode == 200) {
      return BoxModel.fromJson(results);
    } else {
      throw ModelError.fromJson(results);
    }
  }

  Future<List<BoxModel>> _listBoxes() async {
    final Response response = await httpClient.get(Uri.parse("${baseUrl}/$boxes"));
    final results = json.decode(response.body);

    if (response.statusCode == 200) {
      return BoxModel.fromJsonArray(results);
    } else {
      throw ModelError.fromJsonError(results);
    }
  }


  Future<DataState > execute(String resourceName, String action, dynamic payload, DataState currentState) async {
    DataState newState = DataState(null);
    
    if (resourceName == EntityNames.Boxes) {
      if (action == EntityActions.List) {
        // newState.boxes = await _list<BoxModel, ModelError>(resourceName, BoxModel.fromJsonArray, ModelError.fromJson);
        newState.boxes = await _listBoxes();
      }

      if (action == EntityActions.Add) {
        /*
        final uploadResponse = await _upload(payload.file, currentState.session.idToken);
        final results = json.decode(uploadResponse.body);
        final uploadResult = results[0]['result'].toString(); 
        BoxModel box = BoxModel(
          name: payload.name,
          description: payload.description,
          pictureUrl :  uploadResult
        );
        */
        final addedBox = await _addBox(payload, currentState.session.idToken);
        print('The added Box is:');
        print(addedBox.toString());
        // await _add<BoxModel, ModelError>(resourceName, box, BoxModel.fromJson, ModelError.fromJson);
      }
    }

    if (resourceName == EntityNames.Auth) {
      if (action == EntityActions.Login) {
        newState.session = await _login(payload);
      }
    }

    return newState;
  }

  Future<SessionModel> _login(dynamic payload) async {
    final body = json.encode(payload.toJson());
    final url = Uri.parse("${baseUrl}/auth/login");
    final headers =  {'Content-Type': 'application/json'};

    final Response response = await httpClient.post(url, headers: headers, body: body);

    final results = json.decode(response.body);

    if (response.statusCode == 200) {
      return SessionModel.fromJson(results);
    } else {
      throw ModelError.fromJson(results);
    }
  }

  Future<Response> _upload(UploadFileModel fileInfo, String idToken) async {
    final uri = Uri.parse("${baseUrl}/files");
    var request = new http.MultipartRequest("POST", uri);
    request.headers['authorization-token'] = idToken; 

    var file = await http.MultipartFile.fromPath(
        fileInfo.type,
        fileInfo.file.path,
        contentType: MediaType(fileInfo.type, fileInfo.subtype)
    );

    request.files.add(file);
    var response = await request.send();
    print(response.stream);
    print('_upload Status code ${response.statusCode}');
    return http.Response.fromStream(response);
  }


}