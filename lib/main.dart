import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kathir/screens/login_screen.dart';
import 'package:kathir/screens/my_task_view_screen.dart';
import 'package:kathir/theme/app_colors.dart';

import 'controller/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeController = Get.put(ThemeController());
  runApp(MyApp(themeController: themeController));
}

class MyApp extends StatelessWidget {
  final ThemeController themeController;

  const MyApp({super.key, required this.themeController});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Field To-Do',
        theme: ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white,
          primaryColor: Colors.blue,
          appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.blue,
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          // Black background
          primaryColor: AppColors.darkThemePrimary,
          // Yellow primary in dark mode
          appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: AppColors.darkThemePrimary,
          ),
          iconTheme: const IconThemeData(color: AppColors.darkThemePrimary),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.white),
          ),
        ),
        themeMode: themeController.themeMode,
        home: const LoginScreen(),
      ),
    );
  }
}
