import 'package:core/api_routes/api_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sampleflutterproject/app/app_repo.dart';
import 'package:sampleflutterproject/module/chat/chat.dart';
import 'package:sampleflutterproject/module/chat_list/select_user/select_user_ctrl.dart';
import 'package:sampleflutterproject/styles/app_colors.dart';
import 'package:sampleflutterproject/styles/app_themes.dart';
import 'package:get/get.dart';
import 'package:sampleflutterproject/widget/custom_appbar.dart';
import 'package:sampleflutterproject/widget/custom_filled_textfield.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SelectUser extends StatelessWidget {
  final ctrl = Get.put(SelectUserCtrl());

  SelectUser({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return true;
      },
      child: ScaffoldGradientBackground(
        extendBody: true,
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Color(0xFFD1E2FF),
          ],
        ),
        bottomNavigationBar: Obx(
          () => ctrl.userModel.value.fullName.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Obx(() {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0.0,
                        backgroundColor: AppColors.getPrimary,
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      onPressed: () async {
                        Get.off(() => Chat(), arguments: {
                          "user[0]": ctrl.userModel.value.id,
                          "user[1]": app.userModel.value.id,
                          "displayName": ctrl.userModel.value.fullName,
                          "userProfileUrl":
                              "${ApiRoutes.baseProfileUrl}${ctrl.userModel.value.profileImg}",
                        });
                      },
                      child: !ctrl.isLoading.value
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "chat_with_user".tr,
                                  style: const TextStyle(
                                    color: AppColors.homeButtonFontColor,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )
                          : const SizedBox(
                              child: CupertinoActivityIndicator(
                                color: Colors.white,
                                radius: 10.0,
                              ),
                            ),
                    );
                  }),
                )
              : const SizedBox(),
        ),
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 70.0),
          child: CustomAppBarWithBack(
            title: "select_user".tr,
            actions: [],
            onTap: () {
              Get.back();
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FilledTextField(
                hint: "search_username".tr,
                controller: ctrl.searchCtrl,
                maxLine: 1,
                maxLength: 50,
                textInputAction: TextInputAction.done,
                validator: (value) {},
                onChanged: (value) {
                  ctrl.searchList(ctrl.searchCtrl.text);
                },
                preFixIcon: const Icon(Icons.search),
                textInputType: TextInputType.text,
                borderRadius: BorderRadius.circular(13.0),
              ),
              const SizedBox(height: 20.0),
              Text(
                "users".tr,
                textAlign: TextAlign.center,
                style: themes.light.textTheme.headlineSmall?.copyWith(
                  color: AppColors.getPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 15.0),
              Expanded(
                child: Obx(() {
                  return ctrl.isLoading.value
                      ? const Center(
                          child: CupertinoActivityIndicator(
                            color: AppColors.getPrimary,
                            radius: 10.0,
                          ),
                        )
                      : ListView.separated(
                          physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          itemCount: ctrl.filterList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Obx(() {
                              return InkWell(
                                onTap: () {
                                  ctrl.userModel.value = ctrl.filterList[index];
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          ClipOval(
                                            child: SizedBox(
                                              height: 36,
                                              width: 36,
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    "${ApiRoutes.baseProfileUrl}${ctrl.filterList[index].profileImg}",
                                                height: double.infinity,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    const Center(
                                                  child:
                                                      CupertinoActivityIndicator(
                                                    color: AppColors.getPrimary,
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const CircleAvatar(
                                                  radius: 36,
                                                  child: Icon(Icons.error),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10.0),
                                          Text(
                                            ctrl.filterList[index].fullName,
                                            textAlign: TextAlign.center,
                                            style: themes
                                                .light.textTheme.headlineSmall
                                                ?.copyWith(
                                              fontSize: 16.0,
                                              color:
                                                  AppColors.homeLabelFontColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 12.0,
                                        child: CircleAvatar(
                                          backgroundColor:
                                              ctrl.filterList[index].id ==
                                                      ctrl.userModel.value.id
                                                  ? AppColors.getPrimary
                                                  : Colors.white,
                                          radius: 6.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox();
                          });
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
