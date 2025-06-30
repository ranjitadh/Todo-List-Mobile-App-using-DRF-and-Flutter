import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/todomodels.dart';

class Service {
  static Future<List<todolistmodel>> getTodos() async {
    final response = await http.get(
      Uri.parse('https://4nqrl07g-8080.inc1.devtunnels.ms/todolist/api/items/'),
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      //log('Raw JSON: $jsonData');
      return jsonData.map((item) => todolistmodel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<void> updateTodoStatus(
    int id,
    String status,
    String? description,
  ) async {
    final response = await http.put(
      Uri.parse(
        'https://4nqrl07g-8080.inc1.devtunnels.ms/todolist/api/items/$id/',
      ),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'status': status, 'description': description}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update status');
    }
  }

  static Future<todolistmodel> createTodo(todolistmodel todo) async {
    final response = await http.post(
      Uri.parse('https://4nqrl07g-8080.inc1.devtunnels.ms/todolist/api/items/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(todo.toJson()..remove('id')),
    );
    if (response.statusCode == 201) {
      final jsonData = json.decode(response.body);
      //log('Created todo: $jsonData');
      return todolistmodel.fromJson(jsonData);
    } else {
      throw Exception('Failed to create todo');
    }
  }

  static Future<void> deleteTodo(int id) async {
    final response = await http.delete(
      Uri.parse(
        'https://4nqrl07g-8080.inc1.devtunnels.ms/todolist/api/items/$id/',
      ),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Failed to delete todo');
    }
  }
}
