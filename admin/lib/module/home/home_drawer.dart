import 'package:admin/module/auth/login/login.dart';
import 'package:admin/styles/app_assets.dart';
import 'package:core/model/user_model.dart';
import 'package:core/service/local_storage_service.dart';
import 'package:core/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/app_repo.dart';
import 'home_ctrl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeDrawer extends StatelessWidget {
  final ctrl = Get.put(HomeCtrl());

  HomeDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0.0, 28.0, 0.0, 30.0),
      decoration: BoxDecoration(
        color: AppColors.adminCardBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Obx(
                () => Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 30.0),
                      child: Image.asset(
                        AppAssets.logoWithNameImage,
                        height: 90.0,
                        width: 150.0,
                        //color: themes.getPrimary,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    const SizedBox(height: 50.0),
                    MenuTile(
                      onPressed: () {
                        ctrl.isSelected.value = 0;
                      },
                      text: 'dashboard'.tr,
                      selectedImagePath: AppAssets.drawerDashBoardSelected,
                      unselectedImagePath: AppAssets.drawerDashBoardUnselected,
                      selected: ctrl.isSelected.value == 0,
                      //pagePath: Routes.DASHBOARD,
                    ),
                    const SizedBox(height: 10.0),
                    MenuTile(
                      onPressed: () {
                        ctrl.isSelected.value = 1;
                      },
                      text: 'user'.tr,
                      selectedImagePath: AppAssets.drawerUserSelected,
                      unselectedImagePath: AppAssets.drawerUserUnselected,
                      selected: ctrl.isSelected.value == 1,
                      icon: null,
                      //pagePath: Routes.DASHBOARD,
                    ),
                    const SizedBox(height: 10.0),
                    MenuTile(
                      onPressed: () {
                        ctrl.isSelected.value = 2;
                      },
                      text: 'chat'.tr,
                      selectedImagePath: AppAssets.drawerChatSelected,
                      unselectedImagePath: AppAssets.drawerChatUnselected,
                      selected: ctrl.isSelected.value == 2,
                      //pagePath: Routes.DASHBOARD,
                    ),
                    const SizedBox(height: 10.0),
                    MenuTile(
                      onPressed: () {
                        ctrl.isSelected.value = 3;
                      },
                      text: 'notification'.tr,
                      selectedImagePath: AppAssets.drawerNotificationSelected,
                      unselectedImagePath:
                          AppAssets.drawerNotificationUnselected,
                      selected: ctrl.isSelected.value == 3,
                      //pagePath: Routes.DASHBOARD,
                    ),
                    const SizedBox(height: 10.0),
                    // MenuTile(
                    //   onPressed: () {
                    //     ctrl.isSelected.value = 4;
                    //   },
                    //   text: 'App Settings',
                    //   selectedImagePath: AppAssets.drawerNotificationSelected,
                    //   unselectedImagePath:
                    //   AppAssets.drawerAppUnselected,
                    //   selected: ctrl.isSelected.value == 4,
                    //   //pagePath: Routes.DASHBOARD,
                    // ),
                    // const SizedBox(height: 10.0),
                    const SizedBox(height: 10.0),
                    MenuTile(
                      onPressed: () {
                        ctrl.isSelected.value = 4;
                      },
                      text: 'Reports',
                      selectedImagePath: AppAssets.reportSelected,
                      unselectedImagePath: AppAssets.reportUnselected,
                      selected: ctrl.isSelected.value == 4,
                      //pagePath: Routes.DASHBOARD,
                    ),
                    const SizedBox(height: 10.0),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.logout,
                  color: AppColors.getPrimary,
                  size: 18.0,
                ),
                const SizedBox(width: 20.0),
                InkWell(
                  onTap: () async {
                    await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            child: confirmExit(context),
                          );
                        });
                  },
                  child: Text(
                    "Logout".tr,
                    style: const TextStyle(
                      fontSize: 17.0,
                      color: AppColors.adminDrawerUnselectedFontColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget confirmExit(BuildContext context) {
    return Container(
      width: context.width * 0.2,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
      padding: const EdgeInsets.only(
          top: 15.0, bottom: 15.0, left: 20.0, right: 20.0),
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
                  app.userModel(UserModel.fromEmpty());
                  LocalStorageService.removeLogin();
                  Get.offAll(() => Login());
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
}

class MenuTile extends StatelessWidget {
  MenuTile({
    Key? key,
    this.selected = false,
    required this.text,
    this.unselectedImagePath,
    this.selectedImagePath,
    this.icon,
    required this.onPressed,
  }) : super(key: key);
  bool hover = false;
  bool selected = false;
  String text;
  String? unselectedImagePath;
  String? selectedImagePath;
  IconData? icon;
  Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        opaque: false,
        onHover: (s) {},
        onEnter: (e) {
          hover = true;
          setState(() {});
        },
        onExit: (e) {
          hover = false;
          setState(() {});
        },
        child: InkWell(
          onTap: onPressed,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 30.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (unselectedImagePath != null) ...[
                      Image(
                        image: AssetImage(
                          selected
                              ? selectedImagePath!
                              : hover
                                  ? selectedImagePath!
                                  : unselectedImagePath!,
                        ),
                        // color: selected
                        //     ? AppColors.getPrimary
                        //     : AppColors.adminDrawerUnselectedFontColor,
                        width: 30,
                        height: 30,
                      ),
                    ],
                    // if (icon != null) ...[
                    //   const SizedBox(
                    //     width: 4.0,
                    //   ),
                    //   Icon(
                    //     icon,
                    //     color: selected
                    //         ? AppColors.getPrimary
                    //         : hover
                    //             ? AppColors.getPrimary
                    //             : AppColors.adminDrawerUnselectedFontColor,
                    //     size: 24,
                    //   ),
                    // ],
                    const SizedBox(
                      width: 16.0,
                    ),
                    Text(
                      text,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 17.0,
                        color: selected
                            ? AppColors.getPrimary
                            : hover
                                ? AppColors.getPrimary
                                : AppColors.adminDrawerUnselectedFontColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14.0),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20.0),
                child: Divider(
                  height: 1,
                  color: AppColors.adminDividerColor,
                  thickness: 1,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
