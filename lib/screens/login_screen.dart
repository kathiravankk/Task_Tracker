import 'package:flutter/material.dart';
import 'package:kathir/screens/my_task_view_screen.dart';
import 'package:kathir/screens/widgets/login_carousal.dart';

import '../common_widget/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Your role data
  List<Map<String, dynamic>> myAppRoles = [
    {
      "role": "Manager",
      "profile": "https://cdn-icons-png.flaticon.com/128/6024/6024190.png",
      "name": "Balu",
    },
    {
      "role": "Admin",
      "profile": "https://cdn-icons-png.flaticon.com/128/1999/1999625.png",
      "name": "Surya",
    },
    {
      "role": "User",
      "profile": "https://cdn-icons-png.flaticon.com/128/4140/4140037.png",
      "name": "Kathir",
    },
  ];

  Map<String, dynamic>? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          spacing: 20,
          children: [
            // Carousel Slider
            LoginCarousel(
                carouselItems: myAppRoles
            ),
            // CarouselSlider(
            //   options: CarouselOptions(
            //     height: 200,
            //     enlargeCenterPage: true,
            //     autoPlay: true,
            //     aspectRatio: 16 / 9,
            //     autoPlayCurve: Curves.fastOutSlowIn,
            //     enableInfiniteScroll: true,
            //     autoPlayAnimationDuration: const Duration(milliseconds: 800),
            //     viewportFraction: 0.8,
            //   ),
            //   items: myAppRoles.map((roleObj) {
            //     return Column(
            //       children: [
            //         CircleAvatar(
            //           radius: 60,
            //           backgroundImage: NetworkImage(roleObj["profile"]),
            //         ),
            //         const SizedBox(height: 10),
            //         Text(
            //           roleObj["role"],
            //           style: const TextStyle(
            //             fontSize: 18,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //       ],
            //     );
            //   }).toList(),
            // ),

            const SizedBox(height: 30),

            // Dropdown for Role

            DropdownButtonFormField<Map<String, dynamic>>(
              value: selectedRole,
              decoration: const InputDecoration(
                labelText: "Select Role",
                border: OutlineInputBorder(),
              ),
              items: myAppRoles.map((roleObj) {
                return DropdownMenuItem(
                  value: roleObj,
                  child: Text(roleObj["role"]),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedRole = value;
                });
              },
            ),

            const SizedBox(height: 70),

            // Continue Button
            CustomButton(
              width: 200,
              bgColor: Colors.blue,
              buttonFunction: () {
                if (selectedRole != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MyTaskViewScreen(roleObj: selectedRole!,)),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please select a role")),
                  );
                }
              },
              buttonText: "Continue",
            ),
          ],
        ),
      ),
    );
  }
}
