import 'package:flutter/material.dart';

class TaskManagerPage extends StatefulWidget {
  const TaskManagerPage({super.key});

  @override
  State<TaskManagerPage> createState() => _TaskManagerPageState();
}

class _TaskManagerPageState extends State<TaskManagerPage> {
  List<String> tasks = [
    'Review Clen Architecture',
    'Complete Flutter Assignment',
    'Practice Widget Catalog',
  ];

  Map<String, bool> checkedTasks = {};

  String? _recentlyDeletedTask;
  int? _recentlyDeletedTaskIndex;

  @override
  void initState() {
    super.initState();
    for (var task in tasks) {
      checkedTasks[task] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Manager')),
      body: ReorderableListView.builder(
        itemCount: tasks.length,
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) newIndex -= 1;
            final task = tasks.removeAt(oldIndex);
            tasks.insert(newIndex, task);
          });
        },
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Dismissible(
            key: ValueKey(task),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            confirmDismiss: (direction) async {
              return await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirm Delete'),
                  content: Text('Delete "$task"?'),
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
            },
            onDismissed: (direction) {
              setState(() {
                _recentlyDeletedTask = task;
                _recentlyDeletedTaskIndex = index;
                tasks.removeAt(index);
                checkedTasks.remove(task);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Deleted "$task"'),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      if (_recentlyDeletedTask != null &&
                          _recentlyDeletedTaskIndex != null) {
                        setState(() {
                          tasks.insert(
                            _recentlyDeletedTaskIndex!,
                            _recentlyDeletedTask!,
                          );
                          checkedTasks[_recentlyDeletedTask!] = false;
                        });
                      }
                    },
                  ),
                ),
              );
            },
            child: ListTile(
              key: ValueKey('list_tile_$task'),
              trailing: Checkbox(
                value: checkedTasks[task] ?? false,
                onChanged: (value) {
                  setState(() {
                    checkedTasks[task] = value ?? false;
                  });
                },
              ),
              title: Text(
                task,
                style: TextStyle(
                  decoration: checkedTasks[task]!
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                      
                ),
              ),
              leading: const Icon(Icons.drag_handle),
            ),
          );
        },
      ),
    );
  }
}
