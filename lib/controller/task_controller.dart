import 'dart:convert';
import 'package:get/get.dart';
import 'package:kathir/model/task_details_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskController extends GetxController {
  RxList<TaskDetailsModel> tasks = <TaskDetailsModel>[].obs;

  @override
  void onInit() {
    loadTasks();
    super.onInit();
  }

  void addTask(TaskDetailsModel task) {
    tasks.add(task);
    saveTasks();
  }

  void updateTask(int index, TaskDetailsModel task) {
    tasks[index] = task;
    saveTasks();
  }

  void deleteTask(int index) {
    tasks.removeAt(index);
    saveTasks();
  }

  void toggleTask(int index) {
    tasks[index].isCompleted = !tasks[index].isCompleted;
    tasks.refresh();
    saveTasks();
  }

  void reorderTask(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;
    final task = tasks.removeAt(oldIndex);
    tasks.insert(newIndex, task);
    saveTasks();
  }

  void saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(tasks.map((t) => t.toJson()).toList());
    prefs.setString('tasks', jsonString);
  }

  void loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('tasks');
    if (data != null) {
      final List<dynamic> jsonList = jsonDecode(data);
      tasks.value = jsonList.map((e) => TaskDetailsModel.fromJson(e)).toList();
    }
  }
}
