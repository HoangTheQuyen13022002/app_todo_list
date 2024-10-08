import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'package:todo/models/todo.dart';

class TodoProvider extends ChangeNotifier {
  final _dio = Dio();
  final String _url = "https://66a8fbf1e40d3aa6ff5a2fd3.mockapi.io";

  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  Future<List<Todo>> fetchTodos() async {
    final response = await _dio.get('$_url/todos');

    if (response.statusCode == 200) {
      List<dynamic> data = response.data;

      return data.map((todo) => Todo.fromJson(todo)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }

  Future<void> addTodo(Todo todo) async {
    try {
      final response = await _dio.post('$_url/todos', data: todo.toJson());

      if (response.statusCode == 201) {
        final data = Todo.fromJson(response.data);
        _todos.add(data);
        notifyListeners();
      } else {
        throw Exception('failed to add todo');
      }
    } catch (e) {
      throw Exception('error to add todo , detail : $e');
    }
  }

  Future<void> updateTodo(Todo todo) async {
    try {
      if (todo.id == null) {
        throw Exception('Todo ID is null');
      }

      final response = await _dio.put(
        '$_url/todos/${todo.id}',
        data: todo.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        Todo.fromJson(response.data);
      } else {
        throw Exception('Failed to update todo');
      }

      notifyListeners();
    } catch (e) {
      throw Exception('Error updating todo: $e');
    }
  }

  Future<void> deletedTodo(Todo todo) async {
    try {
      if (todo.id != null) {
        await _dio.delete('$_url/todos/${todo.id}', data: todo.toJson());
        notifyListeners();
      } else {
        print('Id todo null');
      }
    } catch (e) {
      throw Exception('Failed to deleted todo!');
    }
  }

  Future<void> updateCompletedTodo(Todo todo) async {
    try {
      if (todo.id != null) {
        // Sử dụng giá trị mặc định nếu isCompleted là null
        await _dio.put('$_url/todos/${todo.id}',
            data: {
              "isCompleted": !(todo.isCompleted ?? false) // đảo ngược giá trị, mặc định là false nếu null
            });
        notifyListeners();
      } else {
        print('Id todo null');
      }
    } catch (e) {
      throw Exception('Failed to update completed todo!');
    }
  }

}
