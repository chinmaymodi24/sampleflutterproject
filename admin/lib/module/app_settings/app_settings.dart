import 'dart:developer';
import 'package:admin/module/app_settings/app_settings_ctrl.dart';
import 'package:admin/widget/common_container.dart';
import 'package:core/localization/localization_service.dart';
import 'package:core/service/local_storage_service.dart';
import 'package:core/styles/app_colors.dart';
import 'package:core/styles/app_themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSettings extends StatefulWidget {
  const AppSettings({Key? key}) : super(key: key);

  @override
  State<AppSettings> createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  final ctrl = Get.put(AppSettingsCtrl());

  var menuItems = [
    'english'.tr,
    'kiswahili'.tr,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        decoration: const BoxDecoration(
          color: AppColors.adminBackgroundColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 50.0),
            const Text(
              "Language",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: AppColors.lightTextColor,
              ),
            ),
            const SizedBox(height: 20.0),
            CommonContainer(
              //onTap: () {},
              width: context.width * 0.5,
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
                        style: themes.light.textTheme.headlineSmall?.copyWith(
                          fontSize: 16.0,
                          color: AppColors.lightTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: context.width * 0.25,
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
                                  var locale = const Locale('sw', 'TZ');
                                  Get.updateLocale(locale);
                                  LocalizationService.setLocal(
                                      countryCode: locale.countryCode,
                                      languageCode: locale.languageCode);

                                  LocalStorageService.setLanguage(value: "sw");
                                  LocalStorageService.getLanguage;

                                  log("${Get.locale}");
                                  setState(() {});
                                } else {
                                  var locale = const Locale('en', 'US');
                                  Get.updateLocale(locale);
                                  LocalizationService.setLocal(
                                      countryCode: locale.countryCode,
                                      languageCode: locale.languageCode);

                                  LocalStorageService.setLanguage(value: "en");
                                  LocalStorageService.getLanguage;

                                  log("${Get.locale}");
                                  setState(() {});
                                }
                              },
                              value: selectedOption.value,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
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
          ],
        ),
      ),
    );
  }
}
