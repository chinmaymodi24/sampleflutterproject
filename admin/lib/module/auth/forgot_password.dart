import 'package:admin/module/home/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:core/styles/app_colors.dart';
import 'package:core/widget/custom_button.dart';
import 'package:core/widget/custom_filled_textfield.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({Key? key}) : super(key: key);

  final formKey = GlobalKey<FormState>();
  final TextEditingController ctrlEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 40.0,
                      height: 40.0,
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: AppColors.darkBlue,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10.0),
                          onTap: () {
                            Get.back();
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(left: 4.0),
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                     Text(
                      "forgot_password".tr,
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w900,
                        color: AppColors.lightTextColor,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Text(
                      "enter_your_email_to_get_reset_password_link".tr,
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                        color: AppColors.lightTextColor,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    FilledTextField(
                      hint: "email_address".tr,
                      //controller: ctrlEmail,
                      // validator: (value) {
                      //   if (value!.trim().isEmpty) {
                      //     return "Please enter email";
                      //   } else if (!value.isEmail) {
                      //     return "Please enter valid email";
                      //   }
                      //   return null;
                      // },
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.emailAddress,
                      maxLength: 60,
                    ),
                    const SizedBox(height: 20.0),
                    CustomButton(
                      text: "reset".tr,
                      onPressed: () {
                        // if (formKey.currentState!.validate()) {
                        // } else {}

                        Get.to(()=> Home());

                      },
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
