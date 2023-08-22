import 'dart:developer';
import 'package:admin/module/auth/login/login_ctrl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:core/styles/app_colors.dart';
import 'package:core/widget/custom_button.dart';
import 'package:core/widget/custom_filled_textfield.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  final ctrl = Get.put(LoginCtrl());

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      ctrl.ctrlEmail.text = "admin@sampleflutterproject.com";
      ctrl.ctrlPassword.text = "qwerty";
    }

    return Scaffold(
      backgroundColor: AppColors.adminBackgroundColor,
      body: Center(
        child: SizedBox(
          width: 440.0,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            color: AppColors.adminCardBackgroundColor,
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(45.0),
              child: Form(
                key: ctrl.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "log_in".tr,
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w900,
                        color: AppColors.lightTextColor,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Text(
                      "welcome_back_msg_admin".tr,
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                        color: AppColors.lightTextColor,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    FilledTextField(
                      hint: "email_address".tr,
                      controller: ctrl.ctrlEmail,
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return "email_empty_msg".tr;
                        } else if (!value.isEmail) {
                          return "email_invalid_msg".tr;
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.emailAddress,
                      maxLength: 60,
                    ),
                    const SizedBox(height: 20.0),
                    FilledTextField(
                      hint: "password".tr,
                      obscureText: true,
                      controller: ctrl.ctrlPassword,
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return "password_empty_msg".tr;
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.text,
                      maxLength: 10,
                    ),
                    const SizedBox(height: 20.0),
                    Obx(() {
                      return CustomButton(
                        text: "login".tr,
                        isLoading: ctrl.isLoading.value,
                        onPressed: () async {
                          if (ctrl.formKey.currentState!.validate()) {
                            log("valid");
                            ctrl.isLoading.value = true;
                            await ctrl.signIn(
                              email: ctrl.ctrlEmail.text,
                              password: ctrl.ctrlPassword.text,
                            );
                          } else {
                            log("Invalid");
                          }
                        },
                      );
                    }),
                    const SizedBox(height: 20.0),
                     Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "forgot_password?".tr,
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: AppColors.lightTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
