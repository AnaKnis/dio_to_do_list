import 'dart:convert';
import 'package:dio_to_do_list/models/list_model.dart';
import 'package:http/http.dart' as http;

class ListRepository {
  final String baseUrl = "https://parseapi.back4app.com/classes/toDo";

  final Map<String, String> headers = {
    "X-Parse-Application-Id": "ffvUBYAFmJeijpXkrNuo0sdf79s2FJuBqX404zET",
    "X-Parse-REST-API-Key": "qrtF7GVk9QEpL9xZFnfYWuNP4OAgXvPi7zLJilzd",
  };

  Future<http.Response> _get(String url) async {
    final response = await http.get(Uri.parse(url), headers: headers);
    _handleErrors(response);
    return response;
  }

  Future<http.Response> _post(String url, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        ...headers,
      },
      body: jsonEncode(body),
    );
    _handleErrors(response);
    return response;
  }

  Future<http.Response> _delete(String url) async {
    final response = await http.delete(Uri.parse(url), headers: headers);
    _handleErrors(response);
    return response;
  }

  Future<http.Response> _edit(String url, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        ...headers,
      },
      body: jsonEncode(body),
    );
    _handleErrors(response);
    return response;
  }

  void _handleErrors(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('HTTP Error: ${response.statusCode} - ${response.body}');
    }
  }

  Future<List<ListModel>> getToDoList() async {
    final response = await _get(baseUrl);
    final List<dynamic> data = json.decode(response.body)['results'];
    return data.map((json) => ListModel.fromJson(json)).toList();
  }

  Future<void> postList(ListModel toDo) async {
    await _post(baseUrl, toDo.toJson());
  }

  Future<void> editList(ListModel toDo) async {
    final url = "$baseUrl/${toDo.objectId}";
    await _edit(url, toDo.toJson());
  }

  Future<void> deleteList(String objectId) async {
    final url = "$baseUrl/$objectId";
    await _delete(url);
  }
}
