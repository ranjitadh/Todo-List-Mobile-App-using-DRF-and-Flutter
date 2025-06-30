import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Model/todomodels.dart';
import '../Service/Service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Controller for text fields in the add todo dialog
  final _nameController = TextEditingController();
  String? _selectedStatus = 'Pending'; // Default status for new todo
  TimeOfDay? _selectedTime; // Store selected time

  // Show dialog to add a new todo with glassmorphism effect
  void _showAddTodoDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Add New Todo',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _nameController,
                      style: GoogleFonts.poppins(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: GoogleFonts.poppins(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedTime == null
                              ? 'No time selected'
                              : 'Time: ${_selectedTime!.format(context)}',
                          style: GoogleFonts.poppins(color: Colors.white70),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.blue, Colors.purple],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.4),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                                builder: (context, child) {
                                  return Theme(
                                    data: ThemeData.dark().copyWith(
                                      colorScheme: const ColorScheme.dark(
                                        primary: Colors.blue,
                                        onPrimary: Colors.white,
                                        surface: Colors.black87,
                                        onSurface: Colors.white,
                                      ),
                                      dialogBackgroundColor: Colors.black
                                          .withOpacity(0.8),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (time != null) {
                                setState(() {
                                  _selectedTime = time;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Select Time',
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DropdownButton<String>(
                      value: _selectedStatus,
                      items: const [
                        DropdownMenuItem(
                          value: 'Pending',
                          child: Text(
                            'Pending',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Completed',
                          child: Text(
                            'Completed',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedStatus = value;
                        });
                      },
                      style: GoogleFonts.poppins(color: Colors.white),
                      dropdownColor: Colors.black.withOpacity(0.8),
                      icon: Icon(Icons.arrow_drop_down, color: Colors.white70),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.poppins(color: Colors.white70),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.blue, Colors.purple],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.4),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              final name = _nameController.text.trim();
                              if (name.isNotEmpty && _selectedTime != null) {
                                try {
                                  final description =
                                      '${_selectedTime!.format(context)}';
                                  final newStatus =
                                      _selectedStatus == 'Completed'
                                          ? 'proccessed'
                                          : 'pending';
                                  final newTodo = todolistmodel(
                                    name: name,
                                    description: description,
                                    status: newStatus,
                                  );
                                  final createdTodo = await Service.createTodo(
                                    newTodo,
                                  );
                                  setState(
                                    () {},
                                  ); // Trigger FutureBuilder to refresh
                                  _nameController.clear();
                                  _selectedTime = null;
                                  _selectedStatus = 'Pending';
                                  Navigator.pop(context);
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Failed to add todo: $e'),
                                    ),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please enter a name and select a time',
                                    ),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Add',
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Todo List',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.withOpacity(0.3),
                Colors.purple.withOpacity(0.3),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(colors: [Colors.blue, Colors.purple]),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.5),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: _showAddTodoDialog,
          backgroundColor: Colors.transparent,
          child: const Icon(Icons.add, color: Colors.white, size: 30),
          tooltip: 'Add Todo',
        ),
      ),
      body: FutureBuilder<List<todolistmodel>>(
        future: Service.getTodos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: GoogleFonts.poppins(color: Colors.white70),
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final todoList = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                final todo = todoList[index];
                log('Todo status: ${todo.status}');
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            todo.name ?? 'No name',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            todo.description ?? 'No description',
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              DropdownButton<String>(
                                value:
                                    todo.isProcessed ? 'Completed' : 'Pending',
                                items: [
                                  DropdownMenuItem(
                                    value: 'Pending',
                                    child: Text(
                                      'Pending',
                                      style: GoogleFonts.poppins(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Completed',
                                    child: Text(
                                      'Completed',
                                      style: GoogleFonts.poppins(
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ],
                                onChanged: (String? newValue) async {
                                  if (newValue != null && todo.id != null) {
                                    try {
                                      final newStatus =
                                          newValue == 'Completed'
                                              ? 'proccessed'
                                              : 'pending';
                                      await Service.updateTodoStatus(
                                        todo.id!,
                                        newStatus,
                                        todo.description,
                                      );
                                      setState(() {
                                        todoList[index] = todolistmodel(
                                          id: todo.id,
                                          name: todo.name,
                                          description: todo.description,
                                          status: newStatus,
                                        );
                                      });
                                    } catch (e) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Failed to update status: $e',
                                            style: GoogleFonts.poppins(),
                                          ),
                                          backgroundColor: Colors.red
                                              .withOpacity(0.8),
                                        ),
                                      );
                                    }
                                  }
                                },
                                style: GoogleFonts.poppins(
                                  color:
                                      todo.isProcessed
                                          ? Colors.green
                                          : Colors.red,
                                ),
                                dropdownColor: Colors.black.withOpacity(0.8),
                                icon: Icon(
                                  todo.isProcessed
                                      ? Icons.check_circle
                                      : Icons.pending,
                                  color:
                                      todo.isProcessed
                                          ? Colors.green
                                          : Colors.red,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.4),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    if (todo.id != null) {
                                      try {
                                        await Service.deleteTodo(todo.id!);
                                        setState(
                                          () {},
                                        ); // Trigger FutureBuilder to refresh
                                      } catch (e) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Failed to delete todo: $e',
                                              style: GoogleFonts.poppins(),
                                            ),
                                            backgroundColor: Colors.black
                                                .withOpacity(0.1),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  tooltip: 'Delete Todo',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text(
                'No todos found',
                style: GoogleFonts.poppins(color: Colors.white70),
              ),
            );
          }
        },
      ),
    );
  }
}
