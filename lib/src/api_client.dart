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

  Future<DataState > execute(String resourceName, String action, dynamic payload, DataState currentState) async {
    DataState newState = DataState(null);
    
    if (resourceName == EntityNames.Boxes) {
      if (action == EntityActions.List) {
        newState.boxes = await _list<BoxModel, ModelError>(resourceName, BoxModel.fromJsonArray, ModelError.fromJson);
      }

      if (action == EntityActions.Add) {
        final uploadResponse = await _upload(payload.file, currentState.session.idToken);
        final results = json.decode(uploadResponse.body);
        print('@before 1');
        final uploadResult = results[0]['result'].toString(); 
        print('@before 2');
        BoxModel box = BoxModel(
          name: payload.name,
          description: payload.description,
          pictureUrl :  uploadResult
        );
        print('@before 3');

        await _add<BoxModel, ModelError>(resourceName, box, BoxModel.fromJson, ModelError.fromJson);
      }
    }

    if (resourceName == EntityNames.Boxes) {
      if (action == EntityActions.Add) {
        print('The uploaded response');
        BoxModel box = BoxModel.fromJson(payload);
        final uploadResponse = await _upload(box.file, currentState.session.idToken);
        print('The upload:');
        print(uploadResponse);
        print('The body:');
        print(uploadResponse.body);
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

}