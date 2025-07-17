import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kathir/common_widget/custom_button.dart';
import 'package:kathir/common_widget/custom_rext_field.dart';
import 'package:kathir/controller/task_controller.dart';
import 'package:kathir/model/task_details_model.dart';
import 'package:kathir/theme/app_colors.dart';

class TaskEditAddBottomSheet extends StatelessWidget {
  final int? index;
  final TaskDetailsModel? task;

  final TaskController controller = Get.find<TaskController>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  TaskEditAddBottomSheet({super.key, this.index, this.task}) {
    if (task != null) {
      titleController.text = task!.title;
      descController.text = task!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        spacing: 15,
        children: [
          Text(
            task == null ? 'Add Task' : 'Edit Task',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          CommonTextField(
            inputBoxController: titleController,
            labelText: "Title",
            validationLogic: (value){},
            hintText: "Enter title here..",
            onChangedCallback: (value){},
            onSaveFunction: (value){},
          ),
          CommonTextField(
            inputBoxController: descController,
            labelText: "Description",
            validationLogic: (value){},
            hintText: "Enter description here..",
            onChangedCallback: (value){},
            onSaveFunction: (value){},
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomButton(
                height: 40,
                width: 150,
                buttonFunction: () {
                  final title = titleController.text.trim();
                  final desc = descController.text.trim();
                  if (title.isEmpty) return;

                  final newTask = TaskDetailsModel(
                    title: title,
                    description: desc,
                  );

                  if (index == null) {
                    controller.addTask(newTask);
                  } else {
                    newTask.isCompleted = task!.isCompleted;
                    controller.updateTask(index!, newTask);
                  }
                  Get.back(); // close the bottom sheet
                },
                buttonText: task == null ? 'Add' : 'Update',
                bgColor: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
