import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sampleflutterproject/app/app_repo.dart';
import 'package:sampleflutterproject/module/auth/login_with_phone_number/login_with_phone_number.dart';
import 'package:sampleflutterproject/module/auth/otp/otp.dart';
import 'package:sampleflutterproject/module/auth/signup/signup_ctrl.dart';
import 'package:sampleflutterproject/plugins/image_picker.dart';
import 'package:sampleflutterproject/plugins/widget/phone_country_picker/custom_country_picker.dart';
import 'package:sampleflutterproject/styles/app_assets.dart';
import 'package:sampleflutterproject/styles/app_colors.dart';
import 'package:sampleflutterproject/styles/app_themes.dart';
import 'package:get/get.dart';
import 'package:sampleflutterproject/utils/app_toast.dart';
import 'package:sampleflutterproject/widget/custom_button.dart';
import 'package:sampleflutterproject/widget/custom_filled_textfield.dart';
import 'package:country_picker/country_picker.dart' hide showCountryPicker;
import 'package:sampleflutterproject/widget/show_picture.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SignUp extends StatelessWidget {
  final ctrl = Get.put(SignUpCtrl());

  SignUp({Key? key}) : super(key: key);

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    if(kDebugMode)
      {
        ctrl.ctrlNationalIdNumber.text  = "TestNumber509872342340";
        ctrl.ctrlAddress.text = "TestAddress";
      }


    return ScaffoldGradientBackground(
      extendBody: true,
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white,
          Color(0xFFD1E2FF),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: const SizedBox(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "create_account".tr,
                        textAlign: TextAlign.center,
                        style: themes.light.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        "enter_your_details_to_create_account".tr,
                        textAlign: TextAlign.center,
                        style: themes.light.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 20.0),
                      InkWell(
                        borderRadius: BorderRadius.circular(60.0),
                        onTap: () async {
                          await ctrl.checkStoragePermission();
                          // ignore: use_build_context_synchronously
                          var r = await ImagePick()
                              .getImage(context, isCamera: false);

                          if (r != null) {
                            ctrl.profileImagePath.value = r;
                            ctrl.imageBytes(Uint8List(0));
                            ctrl.profileFirebaseImagePath.value = "";
                            log("ctrl.profileImagePath.value = ${ctrl.profileImagePath.value}");
                          }
                        },
                        child: Obx(() {
                          return ctrl.profileFirebaseImagePath.isNotEmpty
                              ? ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        ctrl.profileFirebaseImagePath.value,
                                    height: 83,
                                    width: 83,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(
                                      child: CupertinoActivityIndicator(
                                        color: AppColors.getPrimary,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const CircleAvatar(
                                      radius: 46,
                                      child: Icon(Icons.error),
                                    ),
                                  ),
                                )
                              : ctrl.profileImagePath.isEmpty
                                  ? CircleAvatar(
                                      radius: 46.0,
                                      backgroundColor: const Color(0xFFD8E5FA),
                                      child: Image.asset(
                                        width: 34.0,
                                        height: 34.0,
                                        AppAssets.signupCamera,
                                        fit: BoxFit.fitHeight,
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 46.0,
                                      backgroundColor: const Color(0xFFD8E5FA),
                                      backgroundImage: FileImage(
                                        File(ctrl.profileImagePath.value),
                                      ));
                        }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15.0),
                Text(
                  "full_name".tr,
                  style: themes.light.textTheme.headlineSmall?.copyWith(
                    fontSize: 12.0,
                    color: AppColors.signUpLabelFontColor,
                  ),
                ),
                const SizedBox(height: 5.0),
                FilledTextField(
                  hint: "full_name_hint".tr,
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.name,
                  controller: ctrl.ctrlFullName,
                  maxLength: 40,
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return "full_name_empty_msg".tr;
                    } else {
                      return null;
                    }
                  },
                  borderRadius: BorderRadius.circular(13.0),
                ),
                const SizedBox(height: 15.0),
                Text(
                  "email".tr,
                  style: themes.light.textTheme.headlineSmall?.copyWith(
                    fontSize: 12.0,
                    color: AppColors.signUpLabelFontColor,
                  ),
                ),
                const SizedBox(height: 5.0),
                FilledTextField(
                  hint: "email_hint".tr,
                  textInputAction: TextInputAction.done,
                  textInputType: TextInputType.emailAddress,
                  controller: ctrl.ctrlEmail,
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return "email_empty_msg".tr;
                    } else if (!value.isEmail) {
                      return "email_invalid_msg".tr;
                    } else {
                      return null;
                    }
                  },
                  borderRadius: BorderRadius.circular(13.0),
                ),
                const SizedBox(height: 15.0),
                Text(
                  "date_of_birth".tr,
                  style: themes.light.textTheme.headlineSmall?.copyWith(
                    fontSize: 12.0,
                    color: AppColors.signUpLabelFontColor,
                  ),
                ),
                const SizedBox(height: 5.0),
                FilledTextField(
                  onTap: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    await ctrl.selectBirthDate(context);
                    //log("lastUsedDate = ${ctrl.lastUsedDate}");
                  },
                  readOnly: true,
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return "please_select_date_of_birth".tr;
                    } else {
                      return null;
                    }
                  },
                  controller: ctrl.ctrlDateOfBirth,
                  hint: "20-07-2000",
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.name,
                  borderRadius: BorderRadius.circular(13.0),
                  suffixIcon: Image.asset(
                    AppAssets.signupCalendar,
                    width: 10.0,
                    height: 10.0,
                  ).paddingAll(6.0).paddingOnly(right: 14.0),
                ),
                const SizedBox(height: 15.0),
                Text(
                  "national_id_number".tr,
                  style: themes.light.textTheme.headlineSmall?.copyWith(
                    fontSize: 12.0,
                    color: AppColors.signUpLabelFontColor,
                  ),
                ),
                const SizedBox(height: 5.0),
                FilledTextField(
                  hint: "F5S55F98SJHDJ4748",
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return "please_enter_national_id_number".tr;
                    } else {
                      return null;
                    }
                  },
                  controller: ctrl.ctrlNationalIdNumber,
                  textInputType: TextInputType.text,
                  borderRadius: BorderRadius.circular(13.0),
                ),
                const SizedBox(height: 15.0),
                Text(
                  "upload_national_id".tr,
                  style: themes.light.textTheme.headlineSmall?.copyWith(
                    fontSize: 12.0,
                    color: AppColors.signUpLabelFontColor,
                  ),
                ),
                const SizedBox(height: 5.0),
                UploadNationalId(ctrl: ctrl),
                const SizedBox(height: 15.0),
                Text(
                  "phone_number".tr,
                  style: themes.light.textTheme.headlineSmall?.copyWith(
                    fontSize: 12.0,
                    color: AppColors.signUpLabelFontColor,
                  ),
                ),
                const SizedBox(height: 5.0),
                FilledTextField(
                  readOnly: false,
                  hint: "945-579-5775",
                  textInputAction: TextInputAction.next,
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
                /*const SizedBox(height: 15.0),
                Text(
                  "Password",
                  style: themes.light.textTheme.headlineSmall?.copyWith(
                    fontSize: 12.0,
                    color: AppColors.signUpLabelFontColor,
                  ),
                ),
                const SizedBox(height: 5.0),
                Obx(() {
                  return FilledTextField(
                    hint: "*******",
                    obscureText: !ctrl.passwordVisible.value ? true : false,
                    borderRadius: BorderRadius.circular(13.0),
                    controller: ctrl.ctrlPassword,
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return "Please enter password";
                      } else if (value.length < 8) {
                        return "Please enter minimum 8 characters";
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.text,
                    maxLength: 10,
                    suffixIcon: InkWell(
                      onTap: () {
                        ctrl.passwordVisible.value =
                            !ctrl.passwordVisible.value;
                      },
                      child: Obx(() {
                        return Image.asset(
                          !ctrl.passwordVisible.value
                              ? AppAssets.signupPassword
                              : AppAssets.signupShowPassword,
                          color: const Color(0xFF3C7CE8),
                          width: !ctrl.passwordVisible.value ? 10.0 : 26.0,
                          height: !ctrl.passwordVisible.value ? 10.0 : 26.0,
                        );
                      }).paddingAll(6.0).paddingOnly(right: 14.0),
                    ),
                  );
                }),*/
                const SizedBox(height: 15.0),
                Text(
                  "address".tr,
                  style: themes.light.textTheme.headlineSmall?.copyWith(
                    fontSize: 12.0,
                    color: AppColors.signUpLabelFontColor,
                  ),
                ),
                const SizedBox(height: 5.0),
                FilledTextField(
                  hint: "address_hint".tr,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return "address_empty_msg".tr;
                    } else {
                      return null;
                    }
                  },
                  controller: ctrl.ctrlAddress,
                  textInputType: TextInputType.name,
                  borderRadius: BorderRadius.circular(13.0),
                ),
                const SizedBox(height: 15.0),
                Text(
                  "local_government_later_optional".tr,
                  style: themes.light.textTheme.headlineSmall?.copyWith(
                    fontSize: 12.0,
                    color: AppColors.signUpLabelFontColor,
                  ),
                ),
                const SizedBox(height: 5.0),
                InkWell(
                  borderRadius: BorderRadius.circular(14.0),
                  onTap: () async {
                    var r = await ImagePick().getImage(context, isCamera: true);

                    if (r != null) {
                      ctrl.governmentLaterImagePath.value = r;
                      log("ctrl.governmentLaterImagePath.value = ${ctrl.governmentLaterImagePath.value}");
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(13.0),
                    ),
                    child: Center(
                      child: Obx(() {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (ctrl
                                    .governmentLaterImagePath.isNotEmpty) ...[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10, right: 20.0),
                                    child: SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        fit: StackFit.expand,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Get.bottomSheet(
                                                ShowPicture(
                                                  imageUrl: "",
                                                  fileUrl: File(ctrl
                                                      .governmentLaterImagePath
                                                      .value),
                                                ),
                                                isScrollControlled: true,
                                              );
                                            },
                                            child: Image.file(
                                              File(ctrl.governmentLaterImagePath
                                                  .value),
                                              width: 30,
                                              height: 40,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned(
                                            right: -40,
                                            top: -22,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: MaterialButton(
                                                height: 10,
                                                onPressed: () {
                                                  ctrl.governmentLaterImagePath
                                                      .value = "";
                                                },
                                                color: Colors.red,
                                                textColor: Colors.white,
                                                padding:
                                                    const EdgeInsets.all(3),
                                                shape: const CircleBorder(),
                                                child: const Icon(
                                                  Icons.close,
                                                  size: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                                if (ctrl.governmentLaterImagePath.isEmpty) ...[
                                  InkWell(
                                    onTap: () async {
                                      var r = await ImagePick()
                                          .getImage(context, isCamera: true);

                                      if (r != null) {
                                        if (ctrl
                                            .governmentLaterImagePath.isEmpty) {
                                          ctrl.governmentLaterImagePath.value =
                                              r;
                                          log("ctrl.governmentLaterImagePath.value"
                                              " = ${ctrl.governmentLaterImagePath.value}");
                                        }
                                      }
                                    },
                                    child: Image.asset(
                                      width: 30.0,
                                      height: 30.0,
                                      AppAssets.signupUpload,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 7.0),
                            if (ctrl.governmentLaterImagePath.isEmpty) ...[
                              InkWell(
                                onTap: () async {
                                  var r = await ImagePick()
                                      .getImage(context, isCamera: true);

                                  if (r != null) {
                                    if (ctrl.governmentLaterImagePath.isEmpty) {
                                      ctrl.governmentLaterImagePath.value = r;
                                      log("ctrl.governmentLaterImagePath.value"
                                          " = ${ctrl.governmentLaterImagePath.value}");
                                    }
                                  }
                                },
                                child: Text(
                                  "upload_image".tr,
                                  style: themes.light.textTheme.headlineSmall
                                      ?.copyWith(
                                    fontSize: 12.0,
                                    color: const Color(0xFF3C7CE8),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        );
                      }),
                    ),
                  ),
                ),
                const SizedBox(height: 15.0),
                Text(
                  "second_phone_number_optional".tr,
                  style: themes.light.textTheme.headlineSmall?.copyWith(
                    fontSize: 12.0,
                    color: AppColors.signUpLabelFontColor,
                  ),
                ),
                const SizedBox(height: 5.0),
                FilledTextField(
                  readOnly: false,
                  hint: "945-579-5775",
                  textInputAction: TextInputAction.done,
                  textInputType: TextInputType.number,
                  borderRadius: BorderRadius.circular(13.0),
                  controller: ctrl.ctrlOptionalPhoneNumber,
                  inputFormatters: [
                    MaskedInputFormatter('###-###-######'),
                  ],
                  preFixIcon: InkWell(
                    /*onTap: () {
                      showCountryPicker(
                        context: context,
                        showPhoneCode: true,
                        // optional. Shows phone code before the country name.
                        onSelect: (Country country) {
                          log('Select country: ${country.displayName}');

                          ctrl.optionalCountryCode.value = country.phoneCode;
                          ctrl.optionalCountryName = country.displayName;
                        },
                      );
                    },*/
                    child: Obx(
                      () => Text(
                        ctrl.optionalCountryCode.value.isEmpty
                            ? "+1"
                            : "+${ctrl.optionalCountryCode.value}",
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
                const SizedBox(height: 27.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Obx(() {
                      return CustomButton(
                        borderRadius: BorderRadius.circular(13.0),
                        text: "get_started".tr,
                        isLoading: ctrl.isLoading.value,
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            if (ctrl.nationalIDFrontImagePath.isEmpty) {
                              AppToast.msg("please_add_national_id".tr);
                            } else if (ctrl.nationalIDBackImagePath.isEmpty) {
                              AppToast.msg("empty_national_id_back_msg".tr);
                            } else if (ctrl.profileFirebaseImagePath.isEmpty &&
                                ctrl.profileImagePath.isEmpty) {
                              AppToast.msg("please_add_profile_picture".tr);
                            } else {
                              log("ctrl.isLoading.value ${ctrl.isLoading.value}");

                              if (ctrl.isLoading.value != true) {
                                ctrl.isLoading.value = true;

                                var res = await ctrl.emailIsExist(
                                  email: ctrl.ctrlEmail.text,
                                  phoneNumber: ctrl.ctrlPhoneNumber.text
                                      .replaceAll("-", ""),
                                );

                                if (res.isValid) {
                                  app.phoneNumber.value = ctrl
                                      .ctrlPhoneNumber.text
                                      .replaceAll("-", "");

                                  if (ctrl.optionalPhoneNumber.isNotEmpty) {
                                    ctrl.optionalPhoneNumber.value = ctrl
                                        .ctrlOptionalPhoneNumber.text
                                        .replaceAll("-", "");
                                  }
                                  ctrl.isLoading.value = false;


                                  if(ctrl.credential != null)
                                    {

                                      log("login true");

                                      Get.to(() => Otp(
                                        isLinkAccount: true,
                                      ));
                                    }
                                  else
                                    {
                                      log("login false");
                                      Get.to(() => Otp(
                                        isLinkAccount: false,
                                      ));
                                    }


                                } else {
                                  AppToast.msg(res.m);
                                  ctrl.isLoading.value = false;
                                }
                              }
                            }
                          } else {
                            log("Invalid");
                          }
                        },
                      );
                    }),
                    const SizedBox(height: 40.0),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "already_have_a_account".tr,
                              style: themes.light.textTheme.headlineSmall!
                                  .copyWith(
                                color: const Color(0xFF6D6D6D),
                              ),
                            ),
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  //Get.off(() => Login());
                                  Get.off(() => LoginWithPhoneNumber());
                                },
                              text: "login_here".tr,
                              style: themes.light.textTheme.headlineSmall
                                  ?.copyWith(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UploadNationalId extends StatelessWidget {
  const UploadNationalId({
    super.key,
    required this.ctrl,
  });

  final SignUpCtrl ctrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13.0),
      ),
      child: Center(
        child: Obx(() {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (ctrl.nationalIDFrontImagePath.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 10, right: 20.0),
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: Stack(
                            clipBehavior: Clip.none,
                            fit: StackFit.expand,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.bottomSheet(
                                    ShowPicture(
                                      imageUrl: "",
                                      fileUrl: File(
                                          ctrl.nationalIDFrontImagePath.value),
                                    ),
                                    isScrollControlled: true,
                                  );
                                },
                                child: Image.file(
                                  File(ctrl.nationalIDFrontImagePath.value),
                                  width: 30,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                right: -40,
                                top: -22,
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: MaterialButton(
                                    height: 10,
                                    onPressed: () {
                                      ctrl.nationalIDFrontImagePath.value = "";
                                    },
                                    color: Colors.red,
                                    textColor: Colors.white,
                                    padding: const EdgeInsets.all(3),
                                    shape: const CircleBorder(),
                                    child: const Icon(
                                      Icons.close,
                                      size: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    if (ctrl.nationalIDBackImagePath.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 10, right: 20.0),
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: Stack(
                            clipBehavior: Clip.none,
                            fit: StackFit.expand,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.bottomSheet(
                                    ShowPicture(
                                      imageUrl: "",
                                      fileUrl: File(
                                          ctrl.nationalIDBackImagePath.value),
                                    ),
                                    isScrollControlled: true,
                                  );
                                },
                                child: Image.file(
                                  File(ctrl.nationalIDBackImagePath.value),
                                  width: 30,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                right: -40,
                                top: -22,
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: MaterialButton(
                                    height: 10,
                                    onPressed: () {
                                      ctrl.nationalIDBackImagePath.value = "";
                                    },
                                    color: Colors.red,
                                    textColor: Colors.white,
                                    padding: const EdgeInsets.all(3),
                                    shape: const CircleBorder(),
                                    child: const Icon(
                                      Icons.close,
                                      size: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    if (ctrl.nationalIDFrontImagePath.isEmpty ||
                        ctrl.nationalIDBackImagePath.isEmpty) ...[
                      InkWell(
                        onTap: () async {
                          var r = await ImagePick()
                              .getImage(context, isCamera: true);

                          if (r != null) {
                            if (ctrl.nationalIDFrontImagePath.isEmpty &&
                                ctrl.nationalIDBackImagePath.isEmpty) {
                              ctrl.nationalIDFrontImagePath.value = r;
                              log("ctrl.nationalIDFrontImagePath.value"
                                  " = ${ctrl.nationalIDFrontImagePath.value}");
                            } else {
                              ctrl.nationalIDBackImagePath.value = r;
                              log("ctrl.nationalIDBackImagePath.value "
                                  "= ${ctrl.nationalIDBackImagePath.value}");
                            }
                          }
                        },
                        child: Image.asset(
                          width: 30.0,
                          height: 30.0,
                          AppAssets.signupUpload,
                        ),
                      ),
                    ],
                  ],
                );
              }),
              const SizedBox(height: 7.0),
              if (ctrl.nationalIDFrontImagePath.isEmpty ||
                  ctrl.nationalIDBackImagePath.isEmpty) ...[
                InkWell(
                  onTap: () async {
                    var r = await ImagePick().getImage(context, isCamera: true);

                    if (r != null) {
                      if (ctrl.nationalIDFrontImagePath.isEmpty ||
                          ctrl.nationalIDBackImagePath.isEmpty) {
                        ctrl.nationalIDFrontImagePath.value = r;
                        log("ctrl.nationalIDFrontImagePath.value"
                            " = ${ctrl.nationalIDFrontImagePath.value}");
                      } else {
                        ctrl.nationalIDBackImagePath.value = r;
                        log("ctrl.nationalIDBackImagePath.value "
                            "= ${ctrl.nationalIDBackImagePath.value}");
                      }
                    }
                  },
                  child: Text(
                    "upload_image".tr,
                    style: themes.light.textTheme.headlineSmall?.copyWith(
                      fontSize: 12.0,
                      color: const Color(0xFF3C7CE8),
                    ),
                  ),
                ),
              ],
            ],
          );
        }),
      ),
    );
  }
}
