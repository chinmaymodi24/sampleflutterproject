import 'dart:developer';

import 'package:core/localization/localization_service.dart';
import 'package:core/service/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:sampleflutterproject/module/auth/login/login.dart';
import 'package:sampleflutterproject/module/auth/login_with_phone_number/login_with_phone_number.dart';
import 'package:sampleflutterproject/module/auth/login_with_phone_number/login_with_phone_number_ctrl.dart';
import 'package:sampleflutterproject/styles/app_colors.dart';
import 'package:sampleflutterproject/styles/app_themes.dart';
import 'package:get/get.dart';
import 'package:sampleflutterproject/widget/custom_scaffold.dart';

class SelectLanguage extends StatelessWidget {
  SelectLanguage({Key? key}) : super(key: key);

  var items = [
    'english'.tr,
    'kiswahili'.tr,
  ];

  Rxn<String> dropDownValue = Rxn<String>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "please_select_your_language".tr,
              textAlign: TextAlign.center,
              style: themes.light.textTheme.headlineMedium,
            ),
            const SizedBox(height: 20.0),
            Obx(() {
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.textFieldColor,
                  borderRadius: BorderRadius.circular(6.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: DropdownButton(
                  value: dropDownValue.value,
                  hint: const Text(
                    "",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                      color: AppColors.lightTextColor,
                    ),
                  ),
                  underline: const SizedBox(),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: SizedBox(
                        width: 150.0,
                        child: Row(
                          children: [
                            Text(
                              items,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                                color: AppColors.lightTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    dropDownValue.value = newValue!;

                    log("newValue = $newValue");

                    if(newValue == "English")
                      {
                        var locale =
                        const Locale('en', 'US');
                        Get.updateLocale(locale);
                        LocalizationService.setLocal(
                            countryCode: locale.countryCode,
                            languageCode:
                            locale.languageCode);
                        LocalStorageService.setLanguage(value: "en");
                        LocalStorageService.getLanguage;
                      }
                    else
                      {
                        var locale =
                        const Locale('sw', 'TZ');
                        Get.updateLocale(locale);
                        LocalizationService.setLocal(
                            countryCode: locale.countryCode,
                            languageCode:
                            locale.languageCode);
                        LocalStorageService.setLanguage(value: "sw");
                        LocalStorageService.getLanguage;
                      }
                    //Get.to(()=>Login());
                    Get.to(()=>LoginWithPhoneNumber());
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
