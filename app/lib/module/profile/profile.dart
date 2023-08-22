import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/api_routes/api_routes.dart';
import 'package:core/localization/localization_service.dart';
import 'package:core/model/user_model.dart';
import 'package:core/service/local_storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sampleflutterproject/app/app_repo.dart';
import 'package:sampleflutterproject/module/auth/login_with_phone_number/login_with_phone_number.dart';
import 'package:sampleflutterproject/module/notification/notification.dart';
import 'package:sampleflutterproject/module/profile/edit_profile/edit_profile.dart';
import 'package:sampleflutterproject/module/profile/edit_profile/edit_profile_ctrl.dart';
import 'package:sampleflutterproject/module/profile/profile_ctrl.dart';
import 'package:sampleflutterproject/styles/app_assets.dart';
import 'package:sampleflutterproject/styles/app_colors.dart';
import 'package:sampleflutterproject/styles/app_themes.dart';
import 'package:sampleflutterproject/utils/app_toast.dart';
import 'package:sampleflutterproject/widget/common_container.dart';
import 'package:sampleflutterproject/widget/custom_webview.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ctrl = Get.put(ProfileCtrl());

  final editProfile = Get.put(EditProfileCtrl());

  var menuItems = [
    'english'.tr,
    'kiswahili'.tr,
  ];

  @override
  Widget build(BuildContext context) {
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
        toolbarHeight: 60.0,
        leadingWidth: 60.0,
        centerTitle: true,
        leading: const SizedBox(),
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            "my_profile".tr,
            textAlign: TextAlign.center,
            style: themes.light.textTheme.headlineMedium?.copyWith(
              fontSize: 19.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 20.0,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Obx(() {
            return ctrl.isLoading.value
                ? SizedBox(
                    height: context.height * 0.7,
                    child: const Center(
                      child: CupertinoActivityIndicator(
                        color: AppColors.getPrimary,
                      ),
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Obx(() {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(40.0),
                                child: SizedBox(
                                  height: 74,
                                  width: 74,
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "${ApiRoutes.baseProfileUrl}${app.userModel.value.profileImg}",
                                    height: double.infinity,
                                    width: double.infinity,
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
                                ),
                              );
                            }),
                            const SizedBox(height: 16.0),
                            Obx(() {
                              return Text(
                                app.userModel.value.fullName,
                                textAlign: TextAlign.center,
                                style: themes.light.textTheme.headlineSmall
                                    ?.copyWith(
                                  fontSize: 18.0,
                                  fontFamily: "SegoeUI-Bold",
                                  color: const Color(0xFF1E3E74),
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            }),
                            const SizedBox(height: 7.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "accNumber:".tr,
                                  textAlign: TextAlign.center,
                                  style: themes.light.textTheme.titleSmall
                                      ?.copyWith(
                                    fontSize: 13.0,
                                    fontFamily: "SegoeUI-Bold",
                                    color: AppColors.textFieldHintColor,
                                  ),
                                ),
                                Obx(() {
                                  return Text(
                                    app.userModel.value.accNumber.toString(),
                                    textAlign: TextAlign.center,
                                    style: themes.light.textTheme.titleSmall
                                        ?.copyWith(
                                      fontSize: 13.0,
                                      fontFamily: "SegoeUI-Bold",
                                      color: AppColors.textFieldHintColor,
                                    ),
                                  );
                                }),
                              ],
                            ),
                            const SizedBox(height: 26.0),
                          ],
                        ),
                      ),
                      ProfileItem(
                        onTap: () {
                          Get.to(() => EditProfile());
                        },
                        label: "my_profile".tr,
                        imagePath: AppAssets.profileUser,
                      ),
                      const SizedBox(height: 15.0),
                      CommonContainer(
                        //onTap: () {},
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        padding: const EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 20.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "language".tr,
                                  textAlign: TextAlign.center,
                                  style: themes.light.textTheme.headlineSmall
                                      ?.copyWith(
                                    fontSize: 16.0,
                                    color: AppColors.lightTextColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            PopupMenuButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2.0),
                              ),
                              color: Colors.white,
                              constraints: const BoxConstraints(
                                maxWidth: 94.0,
                              ),
                              padding: EdgeInsets.zero,
                              onSelected: (onSelected) {
                                log("onSelected = $onSelected");
                                ctrl.language.value = onSelected as String;
                              },
                              itemBuilder: (BuildContext context) {
                                return menuItems
                                    .asMap()
                                    .entries
                                    .map(
                                      (selectedOption) => PopupMenuItem(
                                        height: 22.0,
                                        onTap: () {
                                          if (selectedOption.key != 0) {
                                            var locale =
                                                const Locale('sw', 'TZ');
                                            Get.updateLocale(locale);
                                            LocalizationService.setLocal(
                                                countryCode: locale.countryCode,
                                                languageCode:
                                                    locale.languageCode);

                                            LocalStorageService.setLanguage(
                                                value: "sw");
                                            LocalStorageService.getLanguage;

                                            log("${Get.locale}");
                                            setState(() {});
                                          } else {
                                            var locale =
                                                const Locale('en', 'US');
                                            Get.updateLocale(locale);
                                            LocalizationService.setLocal(
                                                countryCode: locale.countryCode,
                                                languageCode:
                                                    locale.languageCode);

                                            LocalStorageService.setLanguage(
                                                value: "en");
                                            LocalStorageService.getLanguage;

                                            log("${Get.locale}");
                                            setState(() {});
                                          }
                                        },
                                        value: selectedOption.value,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: Text(
                                                selectedOption.value,
                                                style: const TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            selectedOption.key == 0
                                                ? const Divider(
                                                    color: Colors.grey,
                                                    height: 1,
                                                  )
                                                : const SizedBox(),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList();
                              },
                              child: Row(
                                children: [
                                  Text(
                                    key: UniqueKey(),
                                    Get.locale.toString() == "EN_US" ||
                                            Get.locale.toString() == "en_US"
                                        ? "english".tr
                                        : "kiswahili".tr,
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 7.0),
                                  const Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 20.0,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      ProfileItem(
                        onTap: () {
                          Get.to(() => NotificationScreen());
                        },
                        label: "notification".tr,
                        imagePath: AppAssets.profileNotification,
                      ),
                      const SizedBox(height: 15.0),
                      ProfileItem(
                        onTap: () {
                          Get.to(
                            () => CustomWebView(
                              titleName: 'privacy_policy'.tr,
                              url: 'https://admin.sampleflutterproject.com/privacy-policy/',
                            ),
                          );
                        },
                        label: 'privacy_policy'.tr,
                        icon: Icons.arrow_forward_ios_rounded,
                      ),
                      const SizedBox(height: 15.0),
                      ProfileItem(
                        onTap: () {
                          Get.to(
                            () => CustomWebView(
                              titleName: 'terms_and_condition'.tr,
                              url: 'https://admin.sampleflutterproject.com/terms-condition/',
                            ),
                          );
                        },
                        label: 'terms_and_condition'.tr,
                        icon: Icons.arrow_forward_ios_rounded,
                      ),
                      const SizedBox(height: 15.0),
                      ProfileItem(
                        onTap: () {
                          Get.to(
                            () => CustomWebView(
                              titleName: 'FAQ'.tr,
                              url: 'https://admin.sampleflutterproject.com/FAQ/',
                            ),
                          );
                        },
                        label: 'FAQ'.tr,
                        icon: Icons.arrow_forward_ios_rounded,
                      ),
                      const SizedBox(height: 15.0),
                      ProfileItem(
                        onTap: () {},
                        label: "rate_us".tr,
                        icon: Icons.arrow_forward_ios_rounded,
                      ),
                      const SizedBox(height: 15.0),
                      ProfileItem(
                        onTap: () async {
                          await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  child: _confirmExit(context),
                                );
                              });
                        },
                        label: "log_out".tr,
                        imagePath: AppAssets.profileLogout,
                      ),
                      const SizedBox(height: 15.0),
                      ProfileItem(
                        onTap: () async {
                          await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  child: _confirmDeleteAccount(context, ctrl),
                                );
                              });

                        },
                        label: "delete_account_title".tr,
                        icon: Icons.delete_outline,
                      ),
                      const SizedBox(height: 15.0),
                      const SizedBox(height: 90.0),
                    ],
                  );
          }),
        ),
      ),
    );
  }
}

Widget _deleteAccountAlertMsg(BuildContext context) {
  return Container(
    width: context.width * 0.15,
    decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
    padding:
        const EdgeInsets.only(top: 15.0, bottom: 5.0, left: 20.0, right: 10.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 18.0),
        Text(
          "suggestion_delete_account".tr,
          textAlign: TextAlign.start,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 14.0),
        Center(
          child: TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              "okay".tr,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                //color: Colors.red.shade300,
                color: AppColors.getPrimary,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _confirmExit(BuildContext context) {
  return Container(
    width: context.width * 0.15,
    decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
    padding:
        const EdgeInsets.only(top: 15.0, bottom: 5.0, left: 20.0, right: 10.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "log_out!".tr,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.3,
        ),
        const SizedBox(height: 18.0),
        Text(
          "alert_sign_out?".tr,
          textAlign: TextAlign.start,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 14.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                "no".tr,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  //color: Colors.red.shade300,
                  color: AppColors.getPrimary,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                if (Platform.isIOS) {
                  try {
                    FirebaseAuth.instance.signOut();
                  } catch (e) {
                    log("message e = $e");
                  }
                }

                LocalStorageService.removeLogin();
                app.userModel.value = UserModel.fromEmpty();
                //app.signOut();
                GoogleSignIn googleSignIn = GoogleSignIn();
                await googleSignIn.signOut();
                Get.offAll(() => LoginWithPhoneNumber());
                await ProfileCtrl().updateFCM();
                await GoogleSignIn().disconnect();
              },
              child: Text(
                "yes".tr,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  //color: Colors.red.shade300,
                  color: AppColors.getPrimary,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _confirmDeleteAccount(BuildContext context, ProfileCtrl ctrl) {
  return Container(
    width: context.width * 0.15,
    decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
    padding:
        const EdgeInsets.only(top: 15.0, bottom: 5.0, left: 20.0, right: 10.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "delete_account!".tr,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.3,
        ),
        /*const SizedBox(height: 18.0),
        Center(
          child: const Icon(
            Icons.delete_forever_rounded,
            color: Color(0xFFDF5B5B),
            size: 40.0,
          ),
        ),*/
        const SizedBox(height: 18.0),
        Text(
          "confirm_delete_account".tr,
          textAlign: TextAlign.start,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 14.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                "no".tr,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  //color: Colors.red.shade300,
                  color: AppColors.getPrimary,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Get.back();
                //app.signOut();
                GoogleSignIn googleSignIn = GoogleSignIn();
                await googleSignIn.signOut();
                LocalStorageService.removeLogin();
                app.deleteAccount = true;
                //AppToast.msg("suggestion_delete_account".tr);
                await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: _deleteAccountAlertMsg(context),
                      );
                    });
                Get.offAll(() => LoginWithPhoneNumber());
                app.userModel.value = UserModel.fromEmpty();
              },
              child: Text(
                "yes".tr,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  //color: Colors.red.shade300,
                  color: AppColors.getPrimary,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class ProfileItem extends StatelessWidget {
  final String? imagePath;
  final IconData? icon;
  final String label;
  final Function()? onTap;

  const ProfileItem({
    Key? key,
    this.imagePath,
    this.icon,
    required this.label,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonContainer(
      onTap: onTap!,
      color: Colors.white,
      borderRadius: BorderRadius.circular(15.0),
      padding: const EdgeInsets.symmetric(
        vertical: 15.0,
        horizontal: 20.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: themes.light.textTheme.headlineSmall?.copyWith(
              fontSize: 16.0,
              color: AppColors.lightTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (imagePath != null) ...[
            Image.asset(
              imagePath!,
              width: 20.0,
              height: 20.0,
            ),
          ],
          if (icon != null) ...[
            Icon(
              icon!,
              size: icon == Icons.delete_outline ? 23.0 : 18.0,
              color: icon == Icons.delete_outline
                  ? const Color(0xFFDF5B5B)
                  : Colors.black,
            ),
          ],
        ],
      ),
    );
  }
}
