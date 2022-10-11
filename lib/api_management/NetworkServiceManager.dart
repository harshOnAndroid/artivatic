import 'dart:convert';
import 'package:artivatic_exercise/api_management/APIResponse.dart';
import 'package:http/http.dart' as http;

/**
 * This class is created to handle network API calls. This is a common class for the entire project.
 * This class provides methods for each and every type of API requests supported by the system.
 * Often in the projects some guidelines are defined for network API calls -
 * eg. the structure of API response, the status codes and its prefined reaction, etc.
 * Such things can be managed from this class.
 * Every service class will access the instance of this class. And these service classes can then
 * use that instance for making appropriate API calls.
 * **/

class NetworkServiceManager {
  static NetworkServiceManager? _instance;


  NetworkServiceManager._();

  static NetworkServiceManager getInstance() => _instance = _instance ?? NetworkServiceManager._();

  Future<APIResponse> postCall(
    String url, {
    Map<String, String>? headers,
    required body,
  }) async {

    APIResponse networkResponse;
    var jsonBody = json.encode(body);

    var response = await http
        .post(Uri.parse(url),
            headers: {
              "Authorization": "",
              "Content-type": "application/json",
              "Accept": "application/json",
            },
            body: jsonBody,
            encoding: Utf8Codec())
        .catchError((error, stackTrace) async {
      networkResponse = APIResponse(408, "Something went wrong. Please check your inter connection or try again later.", null);
    });

    try {

      var responseBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        networkResponse = APIResponse(response.statusCode, 'success', responseBody);
      } else if (response.statusCode == 500) {
        networkResponse = APIResponse(response.statusCode, "Something went wrong. Please try again later.", null);
      } else {
        networkResponse = APIResponse(response.statusCode, 'failure', responseBody);
      }
    } catch (e) {
      if (response.statusCode == 200)
        networkResponse = APIResponse(200, "Success", null);
      else
        networkResponse = APIResponse(408, "Something went wrong. Please try again later.", null);
    } finally {
      //do something
    }

    return networkResponse;
  }

  Future<APIResponse> putCall(
    String url, {
    Map<String, String>? headers,
    required body,
  }) async {
    APIResponse networkResponse;

    var response = await http
        .put(Uri.parse(url),
            headers: {
              "Authorization": "",
              "Content-type": "application/json",
              "Accept": "application/json",
            },
            body: json.encode(body),
            encoding: Utf8Codec())
        .catchError((error, stackTrace) async {
      networkResponse = APIResponse(408, "Something went wrong. Please check your inter connection or try again later.", null);
    });

    try {
      var responseBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        networkResponse = APIResponse(response.statusCode, 'success', responseBody);
      } else if (response.statusCode == 500) {
        networkResponse = APIResponse(response.statusCode, "Something went wrong. Please try again later.", null);
      } else {
        networkResponse = APIResponse(response.statusCode, 'failure', responseBody);
      }
    } catch (e) {
      if (response.statusCode == 200)
        networkResponse = APIResponse(200, "Success", null);
      else
        networkResponse = APIResponse(408, "Something went wrong. Please try again later.", null);
    }

    return networkResponse;
  }

  Future<APIResponse> getCall(
    String url, {
    Map<String, String>? headers,
  }) async {
    APIResponse networkResponse;


    var response = await http.get(Uri.parse(url), headers: {
      "Authorization": "",
      "Content-type": "application/json",
      "Accept": "application/json",
    }).catchError((error, stackTrace) async {
    });
    var responseBody;
    try {
      responseBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        networkResponse = APIResponse(response.statusCode, 'success', responseBody);
      } else if (response.statusCode == 500) {
        networkResponse = APIResponse(response.statusCode, "Something went wrong. Please try again later.", null);
      } else {
        networkResponse = APIResponse(response.statusCode, 'failure', responseBody);
      }
    } catch (e) {
      networkResponse = APIResponse(408, "Something went wrong. Please try again later.", null);
    }

    return networkResponse;
  }
}