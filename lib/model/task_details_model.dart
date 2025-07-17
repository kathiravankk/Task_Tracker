class TaskDetailsModel {
  String title;
  String description;
  bool isCompleted;

  TaskDetailsModel({required this.title, this.description = '', this.isCompleted = false});

  factory TaskDetailsModel.fromJson(Map<String, dynamic> json) => TaskDetailsModel(
    title: json['title'],
    description: json['description'],
    isCompleted: json['isCompleted'],
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'isCompleted': isCompleted,
  };
}
