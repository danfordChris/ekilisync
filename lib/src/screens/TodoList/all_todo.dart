import 'package:ekilisync/models/todo_model.dart';
import 'package:ekilisync/src/Provider/todo_data_provider.dart';
import 'package:ekilisync/src/bases/todo_form_scheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  int _selectedTabIndex = 0; // For Business/Personal tabs

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TodoDataProvider>(context, listen: false).refresh();
    });
  }

  Future<void> _addTodo(BuildContext context) async {
    final newTodo = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TodoFormScreen()),
    );

    if (newTodo != null && context.mounted) {
      final provider = Provider.of<TodoDataProvider>(context, listen: false);
      await provider.save(context, newTodo as TodoModel);
    }
  }

  Future<void> _editTodo(BuildContext context, TodoModel todo) async {
    final updatedTodo = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TodoFormScreen(todo: todo)),
    );

    if (updatedTodo != null && context.mounted) {
      final todoWithId = TodoModel(
        id: todo.id,
        title: updatedTodo.title,
        description: updatedTodo.description,
      );
      final provider = Provider.of<TodoDataProvider>(context, listen: false);
      await provider.updateTodo(context, todoWithId);
    }
  }

  Future<void> _deleteTodo(BuildContext context, TodoModel todo) async {
    if (todo.id == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Todo'),
        content: const Text('Are you sure you want to delete this todo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      final provider = Provider.of<TodoDataProvider>(context, listen: false);
      await provider.deleteTodo(context, todo.id!);
      debugPrint('Todo deleted: ${todo.title}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoDataProvider>(
      builder: (context, provider, child) {
        final todos = provider.data ?? [];
        final isLoading = provider.fetching;

        return Scaffold(
          backgroundColor: const Color(0xFFE8E8FF), // Light purple background
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  const Text(
                    "What's up, Joy!",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Tabs (Business/Personal)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildTab("Business", 0),
                      const SizedBox(width: 24),
                      _buildTab("Personal", 1),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Todo List
                  Expanded(
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : todos.isEmpty
                            ? const Center(child: Text('No Todos Available'))
                            : ListView.builder(
                                itemCount: todos.length,
                                itemBuilder: (context, index) {
                                  final todo = todos[index];
                                  return Card(
                                    elevation: 0,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    margin: const EdgeInsets.symmetric(vertical: 8),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        children: [
                                          // Circular Checkbox
                                          Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.grey,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          // Task Details
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  todo.title ?? 'No Title Available',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 8, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFFFFDADA),
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Text(
                                                    todo.description ?? 'No Description',
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.redAccent,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Edit and Delete Buttons
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.edit, color: Colors.blue),
                                                onPressed: () => _editTodo(context, todo),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.delete, color: Colors.red),
                                                onPressed: () => _deleteTodo(context, todo),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _addTodo(context),
            backgroundColor: const Color(0xFFFF6F91), // Pink color
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _buildTab(String title, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: _selectedTabIndex == index ? FontWeight.bold : FontWeight.normal,
              color: _selectedTabIndex == index ? Colors.black : Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 2,
            width: 60,
            color: _selectedTabIndex == index ? const Color(0xFFFF6F91) : Colors.transparent,
          ),
        ],
      ),
    );
  }
}


class TodoFormScreen extends StatefulWidget {
  final TodoModel? todo;

  const TodoFormScreen({super.key, this.todo});

  @override
  State<TodoFormScreen> createState() => _TodoFormScreenState();
}

class _TodoFormScreenState extends State<TodoFormScreen> {
  late final TodoFormScheme _formSchema;
  late final TodoDataProvider _todoDataProvider;

  @override
  void initState() {
    super.initState();
    _formSchema = TodoFormScheme.create();
    _todoDataProvider = Provider.of<TodoDataProvider>(context, listen: false);

    if (widget.todo != null) {
      _formSchema.titleController.text = widget.todo!.title ?? '';
      _formSchema.descriptionController.text = widget.todo!.description ?? '';
    }
  }

  @override
  void dispose() {
    _formSchema.titleController.dispose();
    _formSchema.descriptionController.dispose();
    super.dispose();
  }

  void _saveTodo() {
    if (_formSchema.formKey.currentState!.validate()) {
      final todo = TodoModel(
        id: widget.todo?.id,
        title: _formSchema.titleController.text,
        description: _formSchema.descriptionController.text,
      );

      if (context.mounted) {
        Navigator.pop(context, todo);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8E8FF), // Light purple background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.todo == null ? 'Add Todo' : 'Edit Todo',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formSchema.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _formSchema.titleController,
                decoration: InputDecoration(
                  labelText: 'Todo Title',
                  labelStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Title cannot be empty' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _formSchema.descriptionController,
                decoration: InputDecoration(
                  labelText: 'Todo Description',
                  labelStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Description cannot be empty' : null,
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTodo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6F91), // Pink color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}