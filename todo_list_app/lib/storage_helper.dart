//helps in storing data in local storage

import 'dart:convert';
import 'task.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static const String TASKS_KEY = 'tasks';

  //save tasks to local storage
  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> tasksJson = tasks
        .map((task) => json.encode(task.toJson()))
        .toList();
    await prefs.setStringList(TASKS_KEY, tasksJson);
  }

  //load tasks from local storage

  static Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? tasksJson = prefs.getStringList(TASKS_KEY);

    if (tasksJson == null) {
      return [];
    }
    return tasksJson.map((taskStr) {
      return Task.formJson(json.decode(taskStr));
    }).toList();
  }

  //clear all tasks
  static Future<void> clearTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(TASKS_KEY);
  }
}
