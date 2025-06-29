import 'dart:developer';
import 'package:flutter/material.dart';
import '../Model/todomodels.dart'; // Fixed import path
import '../Service/Service.dart'; // Adjust path if needed

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: FutureBuilder<List<todolistmodel>>(
        future: Service.getTodos(), // Call the correct method
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final todoList = snapshot.data!;
            return ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                final todo = todoList[index];
                return ListTile(
                  title: Text(todo.name ?? 'No name'),
                  subtitle: Text(todo.description ?? 'No description'),
                );
              },
            );
          } else {
            return const Center(child: Text('No todos found'));
          }
        },
      ),
    );
  }
}
