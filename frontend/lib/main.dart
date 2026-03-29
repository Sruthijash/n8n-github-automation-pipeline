import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FlodoTaskApp(),
  ));
}

class FlodoTaskApp extends StatefulWidget {
  const FlodoTaskApp({super.key});

  @override
  State<FlodoTaskApp> createState() => _FlodoTaskAppState();
}

class _FlodoTaskAppState extends State<FlodoTaskApp> {
  List tasks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getTasksFromBackend();
  }

  // API CALL: Fetches tasks from your FastAPI Python Backend
  Future<void> getTasksFromBackend() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/tasks'));
      if (response.statusCode == 200) {
        setState(() {
          tasks = json.decode(response.body);
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Connection Error: $e");
    }
  }

  // BUSINESS LOGIC: Handles the "Blocked By" requirement
  void handleTaskCompletion(dynamic task) {
    if (task['status'] == 'done') return;

    if (task['blockedBy'] != null) {
      // Find the task that is blocking this one
      var blocker = tasks.firstWhere(
        (t) => t['id'] == task['blockedBy'],
        orElse: () => null,
      );

      if (blocker != null && blocker['status'] != 'done') {
        // Show a polished warning if the prerequisite isn't finished
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.deepOrangeAccent,
            behavior: SnackBarBehavior.floating,
            content: Text("⚠️ Please complete '${blocker['title']}' first!"),
          ),
        );
        return;
      }
    }

    // Success: Update state and show confirmation
    setState(() {
      task['status'] = 'done';
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text("✅ Task updated successfully!"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Flodo Task Manager"),
        elevation: 2,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: getTasksFromBackend,
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  bool isDone = task['status'] == 'done';

                  return Card(
                    elevation: isDone ? 0 : 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: IconButton(
                        icon: Icon(
                          isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                          color: isDone ? Colors.green : Colors.grey,
                          size: 30,
                        ),
                        onPressed: () => handleTaskCompletion(task),
                      ),
                      title: Text(
                        task['title'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          decoration: isDone ? TextDecoration.lineThrough : null,
                          color: isDone ? Colors.grey : Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        isDone ? "✅ Completed" : "⏳ Pending Action",
                        style: TextStyle(
                          color: isDone ? Colors.green : Colors.orange[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}