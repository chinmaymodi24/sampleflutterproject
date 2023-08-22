import 'dart:developer';
import 'package:core/api_routes/api_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sampleflutterproject/app/app_repo.dart';
import 'package:sampleflutterproject/module/home/home_ctrl.dart';
import 'package:sampleflutterproject/module/my_loan/my_loan_ctrl.dart';
import 'package:sampleflutterproject/styles/app_assets.dart';
import 'package:sampleflutterproject/styles/app_colors.dart';
import 'package:sampleflutterproject/styles/app_themes.dart';
import 'package:get/get.dart';
import 'package:sampleflutterproject/utils/app_toast.dart';
import 'package:sampleflutterproject/widget/common_container.dart';
import 'package:sampleflutterproject/widget/custom_appbar.dart';
import 'package:sampleflutterproject/widget/custom_filled_textfield.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SelectSponsers extends StatelessWidget {
  //final ctrl = Get.put(SelectSponsersCtrl());
  final ctrl = Get.find<HomeCtrl>();

  RxBool isLoading = false.obs;

  SelectSponsers({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        ctrl.sponsorIds.clear();
        ctrl.isCheck.clear();
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
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Obx(() {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0.0,
                backgroundColor: AppColors.getPrimary,
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              onPressed: () async {
                if (ctrl.isCheck.isEmpty) {
                  AppToast.msg("please_select_sponsor".tr);
                } else {
                  if (isLoading.value == false) {
                    isLoading.value = true;

                    var res = await ctrl.loanRequest(
                      userId: app.userModel.value.id,
                      borrowAmount:
                          ctrl.ctrlBorrowAmount.text.replaceAll("TZS", "").trim(),
                      sponserIds: ctrl.sponsorIds.join(","),
                    );

                    if (res.isValid) {
                      Get.back();
                      ctrl.isCheck.clear();
                      ctrl.ctrlBorrowAmount.clear();

                      final myLoanCtrl = Get.find<MyLoanCtrl>();
                      myLoanCtrl.getAllMyLoan();
                      isLoading.value = false;
                      showDialog(
                        context: Get.context!,
                        builder: (context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                            child: LoanRequestedAlertDialog(
                              subTitle:
                                  "request_loan_to_sponsors".tr,
                            ),
                          );
                        },
                      );
                    } else {

                      if(res.s == 0)
                        {
                          Get.back();
                          ctrl.sponsorIds.clear();
                          ctrl.isCheck.clear();
                          isLoading.value = false;
                        }
                      AppToast.msg(res.m);
                      isLoading.value = false;
                    }

                    ctrl.sponsorIds.clear();
                    isLoading.value = false;
                  }
                }
              },
              child: !isLoading.value
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "request".tr,
                          style: const TextStyle(
                            color: AppColors.homeButtonFontColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(width: 10.0),
                        Image.asset(
                          AppAssets.homeMoney,
                          width: 20.0,
                          height: 20.0,
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
        ),
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 70.0),
          child: CustomAppBarWithBack(
            title: "select_sponsers".tr, actions: [],
            onTap: () {
              Get.back();
              ctrl.sponsorIds.clear();
              ctrl.isCheck.clear();
            } ,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "requested_amount".tr,
                textAlign: TextAlign.center,
                style: themes.light.textTheme.headlineSmall?.copyWith(
                  color: AppColors.homeLabelFontColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 15.0),
              FilledTextField(
                readOnly: true,
                hint: "7,000 TZS",
                controller: ctrl.ctrlBorrowAmount,
                textInputAction: TextInputAction.done,
                //maxLength: 10,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  CustomInputFormatter(),
                ],
                textInputType: TextInputType.number,
                borderRadius: BorderRadius.circular(13.0),
              ),
              const SizedBox(height: 20.0),
              Text(
                "sponsors".tr,
                textAlign: TextAlign.center,
                style: themes.light.textTheme.headlineSmall?.copyWith(
                  color: AppColors.getPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 15.0),
              Expanded(
                child: Obx(() {
                  return ListView.separated(
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      itemCount: ctrl.sponsorList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Obx(() {
                          return InkWell(
                            onTap: () {
                              if (ctrl.isCheck.contains(index)) {
                                ctrl.isCheck.remove(index);
                                ctrl.sponsorIds.remove(ctrl.sponsorList[index].id);
                              } else {
                                ctrl.isCheck.add(index);
                                ctrl.sponsorIds.add(ctrl.sponsorList[index].id);
                              }
                              log("list = ${ctrl.isCheck}");
                              log("list = ${ctrl.sponsorIds}");
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      ClipOval(
                                        child: SizedBox(
                                          height: 36,
                                          width: 36,
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                "${ApiRoutes.baseProfileUrl}${ctrl.sponsorList[index].profileImg}",
                                            height: double.infinity,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                const Center(
                                              child: CupertinoActivityIndicator(
                                                color: AppColors.getPrimary,
                                              ),
                                            ),
                                            errorWidget: (context, url, error) =>
                                                const CircleAvatar(
                                              radius: 36,
                                              child: Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10.0),
                                      Text(
                                        ctrl.sponsorList[index].fullName,
                                        textAlign: TextAlign.center,
                                        style: themes
                                            .light.textTheme.headlineSmall
                                            ?.copyWith(
                                          fontSize: 16.0,
                                          color: AppColors.homeLabelFontColor,
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
                                          ctrl.isCheck.contains(index)
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

class LoanRequestedAlertDialog extends StatelessWidget {
  String subTitle;

  LoanRequestedAlertDialog({
    Key? key,
    required this.subTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonContainer(
      width: 70.0,
      borderRadius: BorderRadius.circular(24.0),
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 4.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                splashRadius: 16.0,
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.cancel_outlined),
              ),
            ],
          ),
          Text(
            "your_loan_request_has_been_submitted".tr,
            textAlign: TextAlign.center,
            style: themes.light.textTheme.headlineMedium?.copyWith(
                fontSize: 20.0,
                fontFamily: "SegoeUI-Bold",
                fontWeight: FontWeight.w500),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: Image.asset(
              AppAssets.loanRequestDone,
              width: 91.0,
              height: 100.0,
            ),
          ),
          SizedBox(
            width: 184,
            child: Text(
              subTitle,
              textAlign: TextAlign.center,
              style: themes.light.textTheme.headlineSmall?.copyWith(
                color: const Color(0xFF828282),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 28.0),
        ],
      ),
    );
  }
}
