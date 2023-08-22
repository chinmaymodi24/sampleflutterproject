import 'package:flutter/material.dart';
import 'package:sampleflutterproject/app/app_repo.dart';
import 'package:sampleflutterproject/module/navigation/navigation_page.dart';
import 'package:sampleflutterproject/module/profile/edit_profile/edit_profile.dart';
import 'package:sampleflutterproject/styles/app_assets.dart';
import 'package:sampleflutterproject/styles/app_themes.dart';
import 'package:sampleflutterproject/widget/custom_button.dart';
import 'package:sampleflutterproject/widget/custom_scaffold.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

class AccountRejected extends StatelessWidget {
  const AccountRejected({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal : 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "your_account_is_rejected".tr,
                    textAlign: TextAlign.center,
                    style: themes.light.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 5.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      app.userModel.value.rejectReason,
                      textAlign: TextAlign.center,
                      style: themes.light.textTheme.headlineSmall,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 43.0),
            Lottie.asset(
                AppAssets.accountRejected,
                width: 200,
                height: 201,
                fit: BoxFit.fitWidth
            ),
            const SizedBox(height: 45.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal : 30.0),
              child: CustomButton(
                borderRadius: BorderRadius.circular(13.0),
                text: "resubmit_profile".tr,
                onPressed: () async {
                  await Get.to(()=> EditProfile());
                  await Future.delayed(const Duration(milliseconds: 500));
                  app.navigate();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
