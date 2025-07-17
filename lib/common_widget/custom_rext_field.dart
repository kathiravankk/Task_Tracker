import 'package:flutter/material.dart';
import 'package:kathir/controller/theme_controller.dart';
import 'package:kathir/theme/app_colors.dart';
import 'package:get/get.dart';


//callback for validation
typedef InputBoxCallback = dynamic Function(String value);
typedef SaveFunctionCallback = dynamic Function(String saveValue);
typedef OnChangedCallback = dynamic Function(String value);

class CommonTextField extends StatefulWidget {
  final double? width;
  final String? labelText;
  final String? hintText;
  final SaveFunctionCallback? onSaveFunction;
  final InputBoxCallback? validationLogic;
  final OnChangedCallback? onChangedCallback;
  final TextEditingController? inputBoxController;
  final bool autoValidation;

  const CommonTextField({
    super.key,
    this.width,
    this.labelText = "",
    this.hintText = "",
    this.validationLogic,
    this.onChangedCallback,
    this.onSaveFunction,
    this.inputBoxController, this.autoValidation = true,
  });

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  bool isPasswordVisible = true;

  final ThemeController themeController = Get.find<ThemeController>();


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText!,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: themeController.isDarkMode.value ?AppColors.whiteColor: AppColors.labelTextColor,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          constraints: BoxConstraints(minHeight: 55),
          width: widget.width,
          child: TextFormField(
            onChanged: (value) {
              if (widget.onChangedCallback != null) {
                widget.onChangedCallback!(value);
              }
            },
            onSaved: (saveValue) => widget.onSaveFunction!(saveValue!),
            onFieldSubmitted: widget.validationLogic,
            autovalidateMode: widget.autoValidation
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            validator: (value) {
              return null;
            },
            controller: widget.inputBoxController,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: themeController.isDarkMode.value ?AppColors.whiteColor:AppColors.hintTextFieldColor,
            ),
            cursorColor: AppColors.buttonColor,
            cursorWidth: 1.0,
            decoration: InputDecoration(
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.buttonColor),
                borderRadius: BorderRadius.circular(10.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(10.0),
              ),
              errorStyle: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: Colors.red,
              ),
              hintText: widget.hintText,
              hintStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: themeController.isDarkMode.value ?AppColors.whiteColor:AppColors.hintTextColor,
                overflow: TextOverflow.ellipsis,
              ),
              filled: true,
              fillColor:  Colors.transparent,
              isDense: true,
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color:  AppColors.textFieldBorder,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.textFieldBorder),
                borderRadius: BorderRadius.circular(10.0),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.textFieldBorder),
                borderRadius: BorderRadius.circular(15.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:  BorderSide(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(10.0),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 12.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
