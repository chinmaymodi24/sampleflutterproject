import 'dart:developer';
import 'package:core/styles/app_themes.dart' hide themes;
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sampleflutterproject/app/app_repo.dart';
import 'package:sampleflutterproject/module/auth/login_with_phone_number/login_with_phone_number_ctrl.dart';
import 'package:sampleflutterproject/module/auth/otp/otp.dart';
import 'package:sampleflutterproject/module/auth/signup/signup.dart';
import 'package:sampleflutterproject/styles/app_assets.dart';
import 'package:sampleflutterproject/styles/app_colors.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:sampleflutterproject/styles/app_themes.dart';
import 'package:sampleflutterproject/utils/app_toast.dart';
import 'package:sampleflutterproject/widget/custom_button.dart';
import 'package:sampleflutterproject/widget/custom_filled_textfield.dart';
import 'package:sampleflutterproject/widget/custom_scaffold.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginWithPhoneNumber extends StatelessWidget {
  LoginWithPhoneNumber({Key? key}) : super(key: key);
  final ctrl = Get.put(LoginWithPhoneNumberCtrl());

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Form(
                  key: ctrl.formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "welcome_back".tr,
                        textAlign: TextAlign.center,
                        style: themes.light.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        "enter_your_phone_number".tr,
                        textAlign: TextAlign.center,
                        style: themes.light.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 20.0),
                      FilledTextField(
                        readOnly: false,
                        hint: "945-579-5775",
                        textInputAction: TextInputAction.done,
                        textInputType: TextInputType.number,
                        borderRadius: BorderRadius.circular(13.0),
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return "phone_number_empty_msg".tr;
                          } else {
                            return null;
                          }
                        },
                        controller: ctrl.ctrlPhoneNumber,
                        inputFormatters: [
                          MaskedInputFormatter('###-###-######'),
                        ],
                        preFixIcon: InkWell(
                          /*onTap: () {
                            showCountryPicker(
                              context: context,
                              showPhoneCode: true,
                              onSelect: (Country country) {
                                log('Select country: ${country.displayName}');

                                app.countryCode.value = country.phoneCode;
                                ctrl.countryName = country.displayName;

                                log("app.countryCode.value = ${app.countryCode.value}");
                                log("ctrl.countryName = ${ctrl.countryName}");
                              },
                            );
                          },*/
                          child: Obx(
                            () => Text(
                              app.countryCode.value.isEmpty
                                  ? "+1"
                                  : "+${app.countryCode.value}",
                              style: const TextStyle(
                                color: AppColors.textFieldHintColor,
                                fontSize: 16.0,
                              ),
                            ).paddingAll(6.0).paddingOnly(
                                  left: 14.0,
                                  top: 7.0,
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      Obx(() {
                        return CustomButton(
                          borderRadius: BorderRadius.circular(13.0),
                          text: "log_in".tr,
                          isLoading: ctrl.isLoading.value,
                          onPressed: () async {
                            if (ctrl.formKey.currentState!.validate()) {
                              var res = await ctrl.numberIsExist(
                                phoneNumber: ctrl.ctrlPhoneNumber.text
                                    .replaceAll("-", ""),
                              );

                              logger.i(res.m);

                              if (res.isValid && res.m == "you can sign-up") {
                                AppToast.msg("phone_number_is_not_exist".tr);
                              } else if (res.s == 0 &&
                                  res.m == "phno is already exist") {
                                app.phoneNumber.value = ctrl
                                    .ctrlPhoneNumber.text
                                    .replaceAll("-", "");

                                logger.i(
                                    "countryCode = ${app.countryCode.value}");
                                logger.i(
                                    "Phone Number = ${app.phoneNumber.value}");

                                ctrl.isLoading.value = true;
                                await Get.to(
                                  () => Otp(
                                    isLinkAccount: false,
                                  ),
                                );
                                ctrl.isLoading.value = false;
                              }
                            } else {
                              log("Invalid");
                            }
                          },
                        );
                      }),
                      const SizedBox(height: 15.0),
                      Text(
                        "or".tr,
                        textAlign: TextAlign.center,
                        style: themes.light.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            constraints: const BoxConstraints(
                              minWidth: 50.0,
                              minHeight: 50.0,
                            ),
                            onPressed: () async {
                              await Get.showOverlay(
                                loadingWidget: Center(
                                  child: Container(
                                    height: 70.0,
                                    width: 70.0,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    child: const Center(
                                      child: CupertinoActivityIndicator(
                                        color: AppColors.getPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                                asyncFunction: () async {
                                  return await ctrl.onGoogleSignIn();
                                },
                              );
                            },
                            icon: CircleAvatar(
                              radius: 22.0,
                              backgroundColor: Colors.white,
                              child: Image.asset(
                                width: 20.0,
                                height: 20.0,
                                AppAssets.logoGoogle,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          IconButton(
                            constraints: const BoxConstraints(
                              minWidth: 50.0,
                              minHeight: 50.0,
                            ),
                            onPressed: () async {
                              // await FirebaseAuth.instance.signOut();
                              // ctrl.onLinkedinInSignIn(context: context);
                              //ctrl.signInWithLinkedIn(context: context);
                              AppToast.msg("Under development");
                            },
                            icon: CircleAvatar(
                              radius: 22.0,
                              backgroundColor: Colors.white,
                              child: Image.asset(
                                width: 20.0,
                                height: 20.0,
                                AppAssets.logoIn,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          IconButton(
                            constraints: const BoxConstraints(
                              minWidth: 50.0,
                              minHeight: 50.0,
                            ),
                            onPressed: () async {
                              if (Platform.isIOS) {
                                try {
                                  await FirebaseAuth.instance.signOut();
                                  ctrl.onFacebookSignIn();
                                } on Exception catch (e, t) {
                                  logger.e("catch e $e\n$t");
                                }
                                //AppToast.msg("Under development");
                              } else if (Platform.isAndroid) {
                                await FirebaseAuth.instance.signOut();
                                ctrl.onFacebookSignIn();
                              }
                            },
                            icon: CircleAvatar(
                              radius: 22.0,
                              backgroundColor: Colors.white,
                              child: Image.asset(
                                width: 20.0,
                                height: 20.0,
                                AppAssets.logoFb,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          Platform.isIOS
                              ? IconButton(
                                  constraints: const BoxConstraints(
                                    minWidth: 50.0,
                                    minHeight: 50.0,
                                  ),
                                  onPressed: () async {

                                    await Get.showOverlay(
                                      loadingWidget: Center(
                                        child: Container(
                                          height: 70.0,
                                          width: 70.0,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(color: Colors.white),
                                            borderRadius: BorderRadius.circular(6.0),
                                          ),
                                          child: const Center(
                                            child: CupertinoActivityIndicator(
                                              color: AppColors.getPrimary,
                                            ),
                                          ),
                                        ),
                                      ),
                                      asyncFunction: () async {
                                        return await ctrl.onAppleSignIn();
                                      },
                                    );

                                    //AppToast.msg("Under development");

                                  },
                                  icon: CircleAvatar(
                                    radius: 22.0,
                                    backgroundColor: Colors.white,
                                    child: Image.asset(
                                      width: 20.0,
                                      height: 20.0,
                                      AppAssets.logoApple,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "don't_have_a_account".tr,
                        style: themes.light.textTheme.headlineSmall!.copyWith(
                          color: const Color(0xFF6D6D6D),
                        ),
                      ),
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.off(() => SignUp());
                          },
                        text: "create_now".tr,
                        style: themes.light.textTheme.headlineSmall?.copyWith(
                          color: const Color(0xFF1F1F1F),
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
