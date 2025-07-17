import 'package:flutter/material.dart';
import 'package:kathir/common_widget/custom_button.dart';
import 'package:kathir/controller/task_controller.dart';
import 'package:get/get.dart';
import 'package:kathir/controller/theme_controller.dart';
import 'package:kathir/model/task_details_model.dart';
import 'package:kathir/screens/task_edit_add_screen.dart';
import 'package:kathir/screens/widgets/custom_tab_widget.dart';
import 'package:kathir/screens/widgets/task_view_component.dart';
import 'package:kathir/theme/app_colors.dart';
import 'package:kathir/theme/icon_images.dart';

class MyTaskViewScreen extends StatefulWidget {
  const MyTaskViewScreen({super.key});

  @override
  State<MyTaskViewScreen> createState() => _MyTaskViewScreenState();
}

class _MyTaskViewScreenState extends State<MyTaskViewScreen>
    with TickerProviderStateMixin {
  final TaskController controller = Get.put(TaskController());
  final ThemeController themeController = Get.find<ThemeController>();

  late TabController _tabController;
  final RxInt selectedIndex = 0.obs;

  final tabNames = ['All', 'Completed', 'In-Complete'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      selectedIndex.value = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<TaskDetailsModel> filteredTasks(int tabIndex) {
    if (tabIndex == 1) {
      return controller.tasks.where((t) => t.isCompleted).toList();
    }
    if (tabIndex == 2) {
      return controller.tasks.where((t) => !t.isCompleted).toList();
    }
    return controller.tasks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Row(
          spacing: 10,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(IconImages.todoLogoImg),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayGreeting(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                Text(
                  "Task Tracker User!",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => themeController.toggleTheme(),
            icon: Obx(
              () => Icon(
                themeController.isDarkMode.value
                    ? Icons.light_mode
                    : Icons.dark_mode_outlined,
                size: 25,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: CustomTabWidget(
          tabController: _tabController,
          activeBoxColor: Theme.of(context).primaryColor,
          activeTextColor: themeController.isDarkMode.value
              ? Colors.black
              : Colors.white,
          tabNames: tabNames,
          tabPages: tabNames.map((element) => buildTaskWidget()).toList(),
        ),
      ),
      floatingActionButton: CustomButton(
        width: 150,
        buttonFunction: () {
          showModalBottomSheet(
            backgroundColor: themeController.isDarkMode.value
                ? AppColors.darkCardColor
                : Colors.white,
            useSafeArea: true,
            isDismissible: true,
            showDragHandle: true,
            context: context,
            builder: (_) => TaskEditAddBottomSheet(),
          );
        },
        buttonText: 'Add Task',
        bgColor: Theme.of(context).primaryColor,
        buttonIcon: Icon(
          Icons.add,
          size: 15,
          color: themeController.isDarkMode.value ? Colors.black : Colors.white,
        ),
      ),
    );
  }

  Widget buildTaskWidget() {
    return Obx(() {
      return ReorderableListView.builder(
        itemCount: filteredTasks(selectedIndex.value).length,
        onReorder: (oldIndex, newIndex) {
          controller.reorderTask(oldIndex, newIndex);
        },
        itemBuilder: (context, index) {
          final task = filteredTasks(selectedIndex.value)[index];
          return TaskViewComponent(
            key: ValueKey(task.title),
            taskTitle: task.title,
            description: task.description,
            isCompleted: task.isCompleted,
            onChangedCallback: () => controller.toggleTask(index),
            onDeleteCallback: () => onDeleteCallback(index),
            editFunction: () {
              showModalBottomSheet(
                backgroundColor: themeController.isDarkMode.value
                    ? AppColors.darkCardColor
                    : Colors.white,
                useSafeArea: true,
                isDismissible: true,
                showDragHandle: true,
                context: context,
                builder: (_) =>
                    TaskEditAddBottomSheet(index: index, task: task),
              );
            },
          );
        },
      );
    });
  }

  onDeleteCallback(int taskIndex) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          "Delete Task",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        content: Text(
          "Are you sure you want to delete this task?",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Cancel",
              style: TextStyle(
                decoration: TextDecoration.underline,
                decorationColor: Theme.of(context).primaryColor,
                fontSize: 16,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          CustomButton(
            width: 100,
            height: 40,
            buttonFunction: () {
              Get.back();

              final removedTask = controller.tasks[taskIndex];
              controller.deleteTask(taskIndex);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Task '${removedTask.title}' deleted"),
                  action: SnackBarAction(
                    label: "Undo",
                    onPressed: () {
                      controller.tasks.insert(taskIndex, removedTask);
                      controller.saveTasks(); // persist
                    },
                  ),
                ),
              );
            },
            buttonText: "Delete",
            bgColor: AppColors.cancelButtonColor,
          ),
        ],
      ),
    );
  }

  static String displayGreeting() {
    var timeNow = DateTime.now().hour;

    if (timeNow < 12) {
      return "Good Morning!";
    } else if ((timeNow >= 12) && (timeNow <= 16)) {
      return "Good Afternoon!";
    } else if ((timeNow > 16) && (timeNow < 20)) {
      return "Good Evening!";
    } else {
      return "Good Afternoon!";
    }
  }
}
