import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'task.dart';
import 'storage_helper.dart';
import 'add_edit_task_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> allTasks = [];
  String filterStatus = 'All'; // 'All', 'Active', 'Completed'

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  // Load tasks from storage
  Future<void> loadTasks() async {
    List<Task> tasks = await StorageHelper.loadTasks();
    setState(() {
      allTasks = tasks;
    });
  }

  // Save tasks to storage
  Future<void> saveTasks() async {
    await StorageHelper.saveTasks(allTasks);
  }

  // Add new task
  void addTask(Task task) {
    setState(() {
      allTasks.add(task);
    });
    saveTasks();
  }

  // Edit task
  void editTask(Task updatedTask) {
    setState(() {
      int index = allTasks.indexWhere((task) => task.id == updatedTask.id);
      if (index != -1) {
        allTasks[index] = updatedTask;
      }
    });
    saveTasks();
  }

  // Delete task
  void deleteTask(String taskId) {
    setState(() {
      allTasks.removeWhere((task) => task.id == taskId);
    });
    saveTasks();
  }

  // Toggle task completion
  void toggleTaskCompletion(String taskId) {
    setState(() {
      int index = allTasks.indexWhere((task) => task.id == taskId);
      if (index != -1) {
        allTasks[index].isCompleted = !allTasks[index].isCompleted;
      }
    });
    saveTasks();
  }

  // Get filtered tasks
  List<Task> get filteredTasks {
    if (filterStatus == 'Active') {
      return allTasks.where((task) => !task.isCompleted).toList();
    } else if (filterStatus == 'Completed') {
      return allTasks.where((task) => task.isCompleted).toList();
    }
    return allTasks;
  }

  // Get counts
  int get totalTasks => allTasks.length;
  int get activeTasks => allTasks.where((task) => !task.isCompleted).length;
  int get completedTasks => allTasks.where((task) => task.isCompleted).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F7FC),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Filter Tabs
            _buildFilterTabs(),

            // Tasks List
            Expanded(
              child: filteredTasks.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        return _buildTaskItem(filteredTasks[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditTaskPage()),
          );
          if (result != null && result is Task) {
            addTask(result);
          }
        },
        backgroundColor: Color(0xFFFF7B6D),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Icon(Icons.menu), Icon(Icons.notifications_outlined)],
          ),
          SizedBox(height: 24),
          Text(
            'My Tasks',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              _buildStatCard('Total', totalTasks, Color(0xFF7C6FDC)),
              SizedBox(width: 12),
              _buildStatCard('Active', activeTasks, Color(0xFFFF7B6D)),
              SizedBox(width: 12),
              _buildStatCard('Done', completedTasks, Color(0xFF4CAF50)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, int count, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _buildFilterTab('All'),
          SizedBox(width: 8),
          _buildFilterTab('Active'),
          SizedBox(width: 8),
          _buildFilterTab('Completed'),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String status) {
    bool isSelected = filterStatus == status;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            filterStatus = status;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFF7C6FDC) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Color(0xFF7C6FDC).withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Text(
            status,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[700],
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskItem(Task task) {
    Color priorityColor = task.priority == 'High'
        ? Colors.red
        : task.priority == 'Medium'
        ? Colors.orange
        : Colors.green;

    return Dismissible(
      key: Key(task.id),
      background: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        child: Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        deleteTask(task.id);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Task deleted')));
      },
      child: GestureDetector(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditTaskPage(task: task),
            ),
          );
          if (result != null && result is Task) {
            editTask(result);
          }
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Checkbox
              GestureDetector(
                onTap: () => toggleTaskCompletion(task.id),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: task.isCompleted ? Color(0xFF7C6FDC) : Colors.grey,
                      width: 2,
                    ),
                    color: task.isCompleted
                        ? Color(0xFF7C6FDC)
                        : Colors.transparent,
                  ),
                  child: task.isCompleted
                      ? Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
              ),
              SizedBox(width: 12),

              // Task Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    if (task.description.isNotEmpty) ...[
                      SizedBox(height: 4),
                      Text(
                        task.description,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    SizedBox(height: 8),
                    Row(
                      children: [
                        // Priority Badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: priorityColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.flag, size: 12, color: priorityColor),
                              SizedBox(width: 4),
                              Text(
                                task.priority,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: priorityColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (task.dueDate != null) ...[
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 12,
                                  color: Colors.blue,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  DateFormat('MMM dd').format(task.dueDate!),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: 80, color: Colors.grey[300]),
          SizedBox(height: 16),
          Text(
            'No tasks yet!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Tap + to add a new task',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
