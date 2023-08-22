import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/api_routes/api_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sampleflutterproject/module/sponsored_loans/sponsored_loan_detail/sponsored_loan_details_ctrl.dart';
import 'package:sampleflutterproject/styles/app_colors.dart';
import 'package:sampleflutterproject/styles/app_themes.dart';
import 'package:sampleflutterproject/widget/common_container.dart';
import 'package:sampleflutterproject/widget/custom_appbar.dart';
import 'package:sampleflutterproject/widget/custom_button.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';

class SponsoredLoanDetails extends StatelessWidget {
  final ctrl = Get.put(SponsoredLoanDetailsCtrl());

  SponsoredLoanDetails({Key? key}) : super(key: key);

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
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 70.0),
        child: CustomAppBarWithBack(
          title: "loan_details".tr,
          actions: [],
        ),
      ),
      body: Obx(() {
        return ctrl.isLoading.value
            ? const Center(
                child: CupertinoActivityIndicator(
                  color: AppColors.getPrimary,
                ),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  ctrl.getMyLoanDetails(loanId: Get.arguments);
                },
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            CommonContainer(
                              color: Colors.white,
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "loan_number".tr,
                                            textAlign: TextAlign.center,
                                            style: themes
                                                .light.textTheme.headlineSmall
                                                ?.copyWith(
                                              fontFamily: "SegoeUI-Bold",
                                              color: AppColors.getPrimary,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 7.0),
                                          Text(
                                            "-",
                                            textAlign: TextAlign.center,
                                            style: themes
                                                .light.textTheme.headlineSmall
                                                ?.copyWith(
                                              fontFamily: "SegoeUI-Bold",
                                              fontSize: 16.0,
                                              color: AppColors.lightTextColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "status".tr,
                                            textAlign: TextAlign.center,
                                            style: themes
                                                .light.textTheme.headlineSmall
                                                ?.copyWith(
                                              fontFamily: "SegoeUI-Bold",
                                              color: AppColors.getPrimary,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 7.0),
                                          Text(
                                            ctrl.myLoanListModel.value.status ==
                                                    0
                                                ? "pending".tr
                                                : ctrl.myLoanListModel.value
                                                            .status ==
                                                        1
                                                    ? "approved".tr
                                                    : ctrl.myLoanListModel.value
                                                                .status ==
                                                            2
                                                        ? "closed".tr
                                                        : "rejected".tr,
                                            textAlign: TextAlign.center,
                                            style: themes
                                                .light.textTheme.headlineSmall
                                                ?.copyWith(
                                              fontFamily: "SegoeUI-Bold",
                                              fontSize: 16.0,
                                              color: ctrl.myLoanListModel.value
                                                          .status ==
                                                      0
                                                  ? const Color(0xFFC29D66)
                                                  : ctrl.myLoanListModel.value
                                                              .status ==
                                                          1
                                                      ? const Color(0xFF668BC2)
                                                      : ctrl.myLoanListModel.value
                                                                  .status ==
                                                              2
                                                          ? const Color(
                                                              0xFF00A5D9)
                                                          : Colors.red,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    "borrower".tr,
                                    textAlign: TextAlign.center,
                                    style: themes.light.textTheme.headlineSmall
                                        ?.copyWith(
                                      fontFamily: "SegoeUI-Bold",
                                      color: AppColors.getPrimary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Row(
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
                                                    "${ApiRoutes.baseProfileUrl}${ctrl.myLoanListModel.value.profileImg}",
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
                                            ctrl.myLoanListModel.value.fullName,
                                            textAlign: TextAlign.center,
                                            style: themes
                                                .light.textTheme.headlineSmall
                                                ?.copyWith(
                                              fontSize: 16.0,
                                              color: AppColors.lightTextColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      ctrl.myLoanListModel.value.approved == 1
                                          ? Text(
                                              "approved".tr,
                                              textAlign: TextAlign.center,
                                              style: themes
                                                  .light.textTheme.headlineSmall
                                                  ?.copyWith(
                                                fontFamily: "SegoeUI-Bold",
                                                fontSize: 16.0,
                                                color: const Color(0xFF668BC2),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                  const SizedBox(height: 10.0),
                                  ctrl.myLoanListModel.value.approved != 1
                                      ? Row(
                                          children: [
                                            Expanded(
                                              child: CustomButton(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                                text: "approve".tr,
                                                primaryColor:
                                                    const Color(0xFF5FC54F),
                                                onPressed: () async {
                                                  await ctrl
                                                      .giveLoanStatusFromSponsor(
                                                    loanId: ctrl.myLoanListModel
                                                        .value.id,
                                                    isApproved: 1,
                                                  );
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 5.0),
                                            Expanded(
                                              child: CustomButton(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                                text: "reject".tr,
                                                primaryColor:
                                                    const Color(0xFFC86060),
                                                onPressed: () async {
                                                  await ctrl
                                                      .giveLoanStatusFromSponsor(
                                                    loanId: ctrl.myLoanListModel
                                                        .value.id,
                                                    isApproved: -1,
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        )
                                      : const SizedBox()
                                ],
                              ),
                            ),
                            const SizedBox(height: 15.0),
                            Row(
                              children: [
                                Expanded(
                                  child: CommonContainer(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "loan_amount".tr,
                                          textAlign: TextAlign.center,
                                          style: themes
                                              .light.textTheme.headlineSmall
                                              ?.copyWith(
                                            fontFamily: "SegoeUI-Bold",
                                            color: AppColors.getPrimary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 10.0),
                                        Text(
                                          "${ctrl.myLoanListModel.value.borrowAmount} TZS",
                                          textAlign: TextAlign.center,
                                          style: themes
                                              .light.textTheme.headlineSmall
                                              ?.copyWith(
                                            fontFamily: "SegoeUI-Bold",
                                            fontSize: 16.0,
                                            color: AppColors.lightTextColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                Expanded(
                                  child: CommonContainer(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${"interest".tr} ",
                                          textAlign: TextAlign.center,
                                          style: themes
                                              .light.textTheme.headlineSmall
                                              ?.copyWith(
                                            fontFamily: "SegoeUI-Bold",
                                            color: AppColors.getPrimary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 10.0),
                                        Text(
                                          ctrl.myLoanListModel.value
                                                      .intrestRate ==
                                                  0.0
                                              ? "-"
                                              : "${ctrl.myLoanListModel.value.intrestRate}%",
                                          textAlign: TextAlign.center,
                                          style: themes
                                              .light.textTheme.headlineSmall
                                              ?.copyWith(
                                            fontFamily: "SegoeUI-Bold",
                                            fontSize: 16.0,
                                            color: AppColors.lightTextColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15.0),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
      }),
    );
  }
}
