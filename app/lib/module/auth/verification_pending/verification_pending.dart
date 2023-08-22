import 'package:flutter/material.dart';
import 'package:sampleflutterproject/app/app_repo.dart';
import 'package:sampleflutterproject/styles/app_assets.dart';
import 'package:sampleflutterproject/styles/app_themes.dart';
import 'package:sampleflutterproject/widget/custom_button.dart';
import 'package:sampleflutterproject/widget/custom_scaffold.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class VerificationPending extends StatelessWidget {
  RxBool isLoading = false.obs;

  VerificationPending({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "verification_pending".tr,
                    textAlign: TextAlign.center,
                    style: themes.light.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 5.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "pending_subtitle".tr,
                      textAlign: TextAlign.center,
                      style: themes.light.textTheme.headlineSmall,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 43.0),
            Lottie.asset(AppAssets.verificationPending,
                width: double.infinity, height: 201, fit: BoxFit.fitWidth),
            const SizedBox(height: 45.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Obx(() {
                return CustomButton(
                  isLoading: isLoading.value,
                  borderRadius: BorderRadius.circular(13.0),
                  text: "refresh".tr,
                  onPressed: () {
                    isLoading.value = true;
                    app.navigate();
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
