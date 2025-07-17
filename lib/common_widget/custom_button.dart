import 'package:flutter/material.dart';
import 'package:kathir/controller/theme_controller.dart';
import 'package:kathir/theme/app_colors.dart';
import 'package:get/get.dart';


class CustomButton extends StatelessWidget {
  final VoidCallback buttonFunction;
  final Widget? buttonIcon;
  final String buttonText;
  final Color bgColor;
  final double width;
  final double height;
  final bool disable;
  final bool isLoading;

   CustomButton({
    super.key,
    required this.buttonFunction,
    this.buttonIcon,
    required this.buttonText,
    required this.bgColor,
    this.width = double.infinity,
    this.height = 50,
    this.disable = false,
    this.isLoading = false,
  });

  final ThemeController themeController = Get.find<ThemeController>();


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: disable ? null : buttonFunction,
        style: ButtonStyle(
          elevation: WidgetStatePropertyAll(0),
          backgroundColor: WidgetStatePropertyAll(
            disable ? AppColors.disableColor : bgColor,
          ),
          padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 10)),
          maximumSize: WidgetStatePropertyAll(Size(double.infinity, 40)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              // side: BorderSide(
              //   width: 1,
              //   color:
              //   signInWithOtpButton
              //       ? AppThemeManager.signInWithOtpColor
              //       : isFilterButton
              //       ? AppThemeManager.selectedChipTextColor
              //       : isPrimaryButton
              //       ? Colors.transparent
              //       : AppThemeManager.buttonBorderColor,
              // ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
          ),
        ),
        child:
        isLoading
            ? SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            color: AppColors.buttonTextColor,
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buttonIcon ?? Container(),
            SizedBox(width: buttonIcon != null ? 5 : 0),
            Text(
              buttonText,
              style: TextStyle(
                fontSize: 14,
                color: themeController.isDarkMode.value ?Colors.black :Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
