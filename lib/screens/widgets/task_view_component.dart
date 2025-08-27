import 'package:flutter/material.dart';
import 'package:kathir/controller/theme_controller.dart';
import 'package:kathir/theme/app_colors.dart';
import 'package:get/get.dart';

class TaskViewComponent extends StatelessWidget {
  final String taskTitle;
  final String description;
  final bool isCompleted;
  final String role;
  final Function()? onChangedCallback;
  final Function()? onDeleteCallback;
  final Function()? editFunction;

  TaskViewComponent({
    required Key key,
    required this.taskTitle,
    required this.description,
    this.isCompleted = false,
    this.onChangedCallback,
    this.editFunction,
    this.onDeleteCallback, required this.role,
  }) : super(key: key);

  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: isCompleted ? AppColors.completeColor : Colors.orange,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.only(left: 10),
        child: Container(
          decoration: BoxDecoration(
            color: themeController.isDarkMode.value
                ? AppColors.darkCardColor
                : Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: themeController.isDarkMode.value
                    ? Color.fromRGBO(31, 30, 42, 1)
                    : Color.fromRGBO(94, 103, 175, 0.5),
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(1, 4),
              ),
            ],
          ),
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: 10,
                children: [
                  Checkbox(
                    activeColor: Theme.of(context).primaryColor,
                    value: isCompleted,
                    onChanged: (val) => onChangedCallback?.call(),
                  ),
                  SizedBox(
                    width: 200,
                    child: Text(
                      taskTitle,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationColor: AppColors.whiteColor,
                        color: themeController.isDarkMode.value
                            ? Colors.white
                            : Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Visibility(
                    visible: role == "Manager" || role == "Admin",
                    child: GestureDetector(
                      onTap: editFunction!,
                      child: Icon(
                        Icons.edit,
                        color: themeController.isDarkMode.value
                            ? AppColors.darkThemePrimary
                            : Colors.blue,
                        size: 23,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: role == "Admin",
                    child: GestureDetector(
                      onTap: onDeleteCallback!,
                      child: Icon(
                        Icons.delete_forever_outlined,
                        color: AppColors.cancelButtonColor,
                        size: 23,
                      ),
                    ),
                  ),
                ],
              ),
              ExpandableWidget(content: description, maxLinesToShow: 3),
            ],
          ),
        ),
      ),
    );
  }
}

class ExpandableWidget extends StatelessWidget {
  final String? content;
  final int maxLinesToShow;
  final ValueNotifier<bool> expanded = ValueNotifier(false);

  ExpandableWidget({
    super.key,
    required this.content,
    required this.maxLinesToShow,
  });

  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    final TextSpan textSpan = TextSpan(
      text: content ?? "",
      style: TextStyle(
        color: themeController.isDarkMode.value ? Colors.white : Colors.black,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    );

    final TextPainter textPainter = TextPainter(
      text: textSpan,
      maxLines: expanded.value ? null : maxLinesToShow,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: MediaQuery.of(context).size.width);

    final int numberOfLines = textPainter.computeLineMetrics().length;
    return ValueListenableBuilder(
      valueListenable: expanded,
      builder: (context, values, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                if (!expanded.value && numberOfLines >= maxLinesToShow) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        content ?? "",
                        maxLines: maxLinesToShow,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: themeController.isDarkMode.value
                              ? Colors.white
                              : Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      /* See More :: type 1 - See More | 2 - See Less */
                      SeeMoreLessWidget(
                        textData: 'See More',
                        type: 1,
                        onSeeMoreLessTap: () {
                          expanded.value = true;
                        },
                      ) /* See More :: type 1 - See More | 2 - See Less */,
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        content ?? "",
                        style: TextStyle(
                          color: themeController.isDarkMode.value
                              ? Colors.white
                              : Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (expanded.value && numberOfLines >= maxLinesToShow)
                        /* See Less :: type 1 - See More | 2 - See Less */ SeeMoreLessWidget(
                          textData: 'See Less',
                          type: 2,
                          onSeeMoreLessTap: () {
                            expanded.value = false;
                          },
                        ) /* See Less :: type 1 - See More | 2 - See Less */,
                    ],
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class SeeMoreLessWidget extends StatelessWidget {
  final String? textData;
  final int? type;

  /* type 1 - See More | 2 - See Less */
  final Function? onSeeMoreLessTap;

  SeeMoreLessWidget({
    super.key,
    required this.textData,
    required this.type,
    required this.onSeeMoreLessTap,
  });

  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0, right: 20),
        child: InkWell(
          onTap: () {
            if (onSeeMoreLessTap != null) {
              onSeeMoreLessTap!();
            }
          },
          child: Text.rich(
            softWrap: true,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),

            textAlign: TextAlign.start,
            TextSpan(
              text: "",
              children: [
                TextSpan(
                  text: textData,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const WidgetSpan(child: SizedBox(width: 3.0)),
                WidgetSpan(
                  child: Icon(
                    (type == 1)
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    color: Theme.of(context).primaryColor,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
