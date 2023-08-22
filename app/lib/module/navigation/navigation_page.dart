import 'dart:io';

import 'package:core/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sampleflutterproject/app/app_repo.dart';
import 'package:sampleflutterproject/module/chat_list/chat_list.dart';
import 'package:sampleflutterproject/module/home/home.dart';
import 'package:sampleflutterproject/module/my_loan/my_loan.dart';
import 'package:sampleflutterproject/module/profile/profile.dart';
import 'package:sampleflutterproject/module/sponsored_loans/sponsored_loans.dart';
import 'package:sampleflutterproject/styles/app_assets.dart';
import 'package:sampleflutterproject/styles/app_themes.dart';
import 'navigation_page_ctrl.dart';

class NavigationPage extends StatelessWidget {
  final NavigationPageCtrl c = Get.put(NavigationPageCtrl());

  NavigationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Center(
        child: Obx(() {
          return c.screen[c.selectedScreen()];
        }),
      ),
      bottomNavigationBar: CustomBottomNavigationWidget(),
    );
  }
}

class CustomBottomNavigationWidget extends StatefulWidget {
  CustomBottomNavigationWidget({Key? key}) : super(key: key);

  @override
  State<CustomBottomNavigationWidget> createState() =>
      _CustomBottomNavigationWidgetState();
}

class _CustomBottomNavigationWidgetState
    extends State<CustomBottomNavigationWidget> {
  final NavigationPageCtrl c = Get.find<NavigationPageCtrl>();

  @override
  void initState() {
    c.updateFCM();
    // if (app.userModel.value.isSponsor == 1) {
    //   c.selectedScreen.value = 4;
    // } else {
    //   c.selectedScreen.value = 3;
    // }
    super.initState();
  }

  double get height {
    if (Platform.isIOS) {
      if (app.userModel.value.isSponsor == 1) {
        return 100.0;
      } else {
        return 90.0;
      }
    } else if (Platform.isAndroid) {
      if (app.userModel.value.isSponsor == 1) {
        return 80.0;
      } else {
        return 70.0;
      }
    }
    return 70.0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: app.userModel.value.isSponsor == 1 ? 80 : 70,
      height: height,
      decoration: const BoxDecoration(color: Colors.white),
      child: Obx(() {
        c.selectedScreen.value;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NavigationIconWidget(
              image: AppAssets.bottomHome,
              label: "home".tr,
              isSelected: c.selectedScreen.value == 0,
              onTap: () {
                c.selectedScreen.value = 0;
              },
              //fillImage: AppAssets.homeFill,
            ),
            NavigationIconWidget(
              image: AppAssets.bottomMyLoan,
              label: "my_loan".tr,
              isSelected: c.selectedScreen.value == 1,
              onTap: () {
                c.selectedScreen.value = 1;
              },
              //fillImage: AppAssets.likeFill,
            ),
            if (app.userModel.value.isSponsor == 1) ...[
              NavigationIconWidget(
                image: AppAssets.bottomLoan,
                label: "sponsored_loans".tr,
                isSelected: c.selectedScreen.value == 2,
                onTap: () {
                  c.selectedScreen.value = 2;
                },
                //fillImage: AppAssets.likeFill,
              ),
            ],
            NavigationIconWidget(
              image: AppAssets.bottomChat,
              label: "chat".tr,
              isSelected: app.userModel.value.isSponsor == 1
                  ? c.selectedScreen.value == 3
                  : c.selectedScreen.value == 2,
              onTap: () {
                if (app.userModel.value.isSponsor == 1) {
                  c.selectedScreen.value = 3;
                } else {
                  c.selectedScreen.value = 2;
                }
              },
              //fillImage: AppAssets.chatFill,
            ),
            NavigationIconWidget(
              image: AppAssets.bottomProfile,
              label: "profile".tr,
              isSelected: app.userModel.value.isSponsor == 1
                  ? c.selectedScreen.value == 4
                  : c.selectedScreen.value == 3,
              onTap: () {
                if (app.userModel.value.isSponsor == 1) {
                  c.selectedScreen.value = 4;
                } else {
                  c.selectedScreen.value = 3;
                }
              },
              //fillImage: AppAssets.profileFill,
            ),
          ],
        );
      }),
    );
  }
}

class NavigationIconWidget extends StatelessWidget {
  final String image;
  final String? fillImage;
  final String label;
  final bool isSelected;
  final Function() onTap;

  const NavigationIconWidget({
    Key? key,
    required this.onTap,
    required this.image,
    this.isSelected = false,
    required this.label,
    this.fillImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              image,
              height: 24,
              width: 24,
              color: isSelected ? AppColors.getPrimary : Colors.black,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 7,
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: themes.light.textTheme.headlineSmall?.copyWith(
                color: isSelected ? AppColors.getPrimary : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
