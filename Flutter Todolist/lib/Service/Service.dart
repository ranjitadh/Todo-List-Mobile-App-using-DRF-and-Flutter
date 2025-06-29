import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/todomodels.dart';

class Service {
  static Future<List<todolistmodel>> getTodos() async {
    final response = await http.get(
      Uri.parse('https://4nqrl07g-8000.inc1.devtunnels.ms/todolist/api/items/'),
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => todolistmodel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
