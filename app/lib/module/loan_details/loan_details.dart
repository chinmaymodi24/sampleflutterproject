import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/api_routes/api_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sampleflutterproject/app/app_repo.dart';
import 'package:sampleflutterproject/module/chat/chat.dart';
import 'package:sampleflutterproject/module/loan_details/loan_details_ctrl.dart';
import 'package:sampleflutterproject/module/loan_details/loan_details_statement_details.dart';
import 'package:sampleflutterproject/styles/app_assets.dart';
import 'package:sampleflutterproject/styles/app_colors.dart';
import 'package:sampleflutterproject/styles/app_themes.dart';
import 'package:sampleflutterproject/widget/common_container.dart';
import 'package:sampleflutterproject/widget/custom_appbar.dart';
import 'package:sampleflutterproject/widget/custom_button.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';

class LoanDetails extends StatelessWidget {
  final ctrl = Get.put(LoanDetailsCtrl());

  LoanDetails({Key? key}) : super(key: key);

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
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 18.0, right: 10.0),
              child: IconButton(
                splashRadius: 20.0,
                onPressed: () {
                  //Get.to(() => SupportChat());
                  Get.to(
                    () => Chat(chatType: ChatType.support),
                    arguments: {
                      "docId": app.userModel().id.toString(),
                      "user[0]": app.userModel().id,
                      "user[1]": 0,
                      "displayName": "Customer Care",
                      "userProfileUrl":
                          "https://www.kindpng.com/picc/m/154-1540620_customer-care-customer-support-icon-transparent-hd-png.png",
                    },
                  );
                },
                icon: Image.asset(
                  AppAssets.loanDetailsChat,
                  width: 23.0,
                  height: 23.0,
                ),
              ),
            ),
          ],
        ),
      ),
      /*AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 60.0,
        leadingWidth: 60.0,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            "Loan Details",
            textAlign: TextAlign.center,
            style: themes.light.textTheme.headlineMedium?.copyWith(
              fontSize: 19.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 20.0),
          child: Material(
            borderRadius: BorderRadius.circular(40.0),
            color: AppColors.getPrimary,
            child: InkWell(
              borderRadius: BorderRadius.circular(40.0),
              onTap: () {
                Get.back();
              },
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 6.0),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),*/
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
                            Text(
                              "requested_amount".tr,
                              textAlign: TextAlign.center,
                              style: themes.light.textTheme.headlineSmall
                                  ?.copyWith(
                                color: AppColors.homeLabelFontColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 15.0),
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
                                            ctrl.myLoanDetailModel.value
                                                .getStatus,
                                            textAlign: TextAlign.center,
                                            style: themes
                                                .light.textTheme.headlineSmall
                                                ?.copyWith(
                                              fontFamily: "SegoeUI-Bold",
                                              fontSize: 16.0,
                                              color: ctrl.myLoanDetailModel
                                                  .value.getStatusColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10.0),
                                  if (ctrl.myLoanDetailModel.value.status ==
                                      0) ...[
                                    Obx(() {
                                      return CustomButton(
                                        isLoading: ctrl.isButtonLoading.value,
                                        text: "withdraw_loan".tr,
                                        onPressed: () async {
                                          await ctrl.withDrawLoanFromUser(
                                            loanId:
                                                ctrl.myLoanDetailModel.value.id,
                                            uId: ctrl
                                                .myLoanDetailModel.value.uId,
                                          );
                                        },
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        fontSize: 16.0,
                                        primaryColor: const Color(0xFF7DA8F0),
                                      );
                                    }),
                                  ],
                                  const SizedBox(height: 10.0),
                                  /*CustomButton(
                                    text: "Close Loan",
                                    onPressed: () {},
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    primaryColor: const Color(0xFFF0C8C8),
                                  ),
                                  const SizedBox(height: 10.0),*/
                                  Text(
                                    "sponsors".tr,
                                    textAlign: TextAlign.center,
                                    style: themes.light.textTheme.headlineSmall
                                        ?.copyWith(
                                      fontFamily: "SegoeUI-Bold",
                                      color: AppColors.getPrimary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                  SponsorsList(ctrl: ctrl),
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
                                          "${ctrl.myLoanDetailModel.value.getBorrowAmount} TZS",
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
                                          ctrl.myLoanDetailModel.value
                                                      .intrestRate ==
                                                  0.0
                                              ? "-"
                                              : "${ctrl.myLoanDetailModel.value.intrestRate}%",
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
                            /* ctrl.myLoanDetailModel.value.details.isNotEmpty
                                ? Text(
                                    "Loan Statements",
                                    textAlign: TextAlign.center,
                                    style: themes.light.textTheme.headlineSmall
                                        ?.copyWith(
                                      fontSize: 15.0,
                                      color: AppColors.homeLabelFontColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                : const SizedBox(),*/

                           CustomButton(
                                    text: "view_statement".tr,
                                    onPressed: () {
                                      Get.to(() => const StatementDetails());
                                    },
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16.0),
                                    fontSize: 16.0,
                                    primaryColor: const Color(0xFF1E3E74),
                                  )

                            /*const SizedBox(height: 15.0),
                            ctrl.myLoanDetailModel.value.details.isNotEmpty
                                ? CommonContainer(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 90.0,
                                                child: Text(
                                                  "Date  ",
                                                  style: context
                                                      .textTheme.bodySmall
                                                      ?.copyWith(
                                                    fontSize: 13.0,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors
                                                        .lightTextColor,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "Principal\nAmount+Interest",
                                                style: context
                                                    .textTheme.bodySmall
                                                    ?.copyWith(
                                                  fontSize: 13.0,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      AppColors.lightTextColor,
                                                ),
                                              ),
                                              Text(
                                                "Outstanding\nAmount",
                                                style: context
                                                    .textTheme.bodySmall
                                                    ?.copyWith(
                                                  fontSize: 13.0,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      AppColors.lightTextColor,
                                                ),
                                              ),
                                              Text(
                                                "Paid",
                                                style: context
                                                    .textTheme.bodySmall
                                                    ?.copyWith(
                                                  fontSize: 13.0,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      AppColors.lightTextColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Divider(
                                          height: 1,
                                          color: AppColors.lightTextColor,
                                          thickness: 0.8,
                                        ),
                                        const SizedBox(height: 10.0),
                                        _loanStatement(),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),*/
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

  // ListView _loanStatement() {
  //   return ListView.separated(
  //     shrinkWrap: true,
  //     physics: const NeverScrollableScrollPhysics(),
  //     itemCount: ctrl.myLoanDetailModel.value.details.length,
  //     itemBuilder: (BuildContext context, int index) {
  //       return Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Expanded(
  //             flex: 2,
  //             child: Text(
  //               DateFormat('dd-MM-yyyy')
  //                   .format(ctrl.myLoanDetailModel.value.details[index].date)
  //                   .toString(),
  //               style: context.textTheme.bodySmall?.copyWith(
  //                 fontSize: 14.0,
  //                 fontWeight: FontWeight.w500,
  //                 color: AppColors.lightTextColor,
  //               ),
  //             ),
  //           ),
  //           Expanded(
  //             flex: 2,
  //             child: Text(
  //               "${ctrl.myLoanDetailModel.value.loanStatement[index].getPrincipleAmt} TZS",
  //               textAlign: TextAlign.center,
  //               style: context.textTheme.bodySmall?.copyWith(
  //                 fontSize: 14.0,
  //                 fontWeight: FontWeight.w500,
  //                 color: AppColors.lightTextColor,
  //               ),
  //             ),
  //           ),
  //           Expanded(
  //             flex: 2,
  //             child: Padding(
  //               padding: const EdgeInsets.only(left: 6),
  //               child: Text(
  //                 " TZS",
  //                 // ctrl.myLoanDetailModel.value.details[index].outstandingAmt ==
  //                 //     0
  //                 //     ? "0"
  //                 //     : "${ctrl.myLoanDetailModel.value.details[index]
  //                 //     .outstandingAmt} TZS",
  //                 textAlign: TextAlign.center,
  //                 style: context.textTheme.bodySmall?.copyWith(
  //                   fontSize: 14.0,
  //                   fontWeight: FontWeight.w500,
  //                   color: AppColors.lightTextColor,
  //                 ),
  //               ),
  //             ),
  //           ),
  //           Expanded(
  //             child: Text(
  //               ctrl.myLoanDetailModel.value.details[index].payment != 0
  //                   ? "${ctrl.myLoanDetailModel.value.details[index].payment}"
  //                   : "-",
  //               textAlign: TextAlign.end,
  //               style: context.textTheme.bodySmall?.copyWith(
  //                 fontSize: 14.0,
  //                 fontWeight: FontWeight.w500,
  //                 color: AppColors.lightTextColor,
  //               ),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //     separatorBuilder: (BuildContext context, int index) {
  //       return const Padding(
  //         padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
  //         child: Divider(
  //           height: 1,
  //           color: AppColors.textFieldHintColor,
  //           thickness: 0.6,
  //         ),
  //       );
  //     },
  //   );
  // }
}

class SponsorsList extends StatelessWidget {
  const SponsorsList({
    super.key,
    required this.ctrl,
  });

  final LoanDetailsCtrl ctrl;

  @override
  Widget build(BuildContext context) {
    return ctrl.myLoanDetailModel.value.sponserDetails.isEmpty
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "no_sponsors".tr,
                textAlign: TextAlign.center,
                style: themes.light.textTheme.headlineSmall?.copyWith(
                  color: const Color(0xFF8B8B8B),
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        : ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
            itemCount: ctrl.myLoanDetailModel.value.sponserDetails.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  jsonEncode({
                    "user[0]":
                        ctrl.myLoanDetailModel.value.sponserDetails[index].id,
                    "user[1]": app.userModel.value.id,
                    "displayName": ctrl
                        .myLoanDetailModel.value.sponserDetails[index].fullName,
                    "userProfileUrl":
                        "${ApiRoutes.baseProfileUrl}${ctrl.myLoanDetailModel.value.sponserDetails[index].profileImg}",
                  });

                  Get.to(() => Chat(), arguments: {
                    "user[0]":
                        ctrl.myLoanDetailModel.value.sponserDetails[index].id,
                    "user[1]": app.userModel.value.id,
                    "displayName": ctrl
                        .myLoanDetailModel.value.sponserDetails[index].fullName,
                    "userProfileUrl":
                        "${ApiRoutes.baseProfileUrl}${ctrl.myLoanDetailModel.value.sponserDetails[index].profileImg}",
                  });
                },
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
                                  "${ApiRoutes.baseProfileUrl}${ctrl.myLoanDetailModel.value.sponserDetails[index].profileImg}",
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
                                radius: 36,
                                child: Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Text(
                          ctrl.myLoanDetailModel.value.sponserDetails[index]
                              .fullName,
                          textAlign: TextAlign.center,
                          style: themes.light.textTheme.headlineSmall?.copyWith(
                            fontSize: 16.0,
                            color: AppColors.homeLabelFontColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      ctrl.myLoanDetailModel.value.sponserDetails[index]
                                  .approved ==
                              0
                          ? "pending".tr
                          : ctrl.myLoanDetailModel.value.sponserDetails[index]
                                      .approved ==
                                  1
                              ? "approved".tr
                              : ctrl.myLoanDetailModel.value
                                          .sponserDetails[index].approved ==
                                      2
                                  ? "closed".tr
                                  : "rejected".tr,
                      textAlign: TextAlign.center,
                      style: themes.light.textTheme.headlineSmall?.copyWith(
                        fontFamily: "SegoeUI-Bold",
                        fontSize: 16.0,
                        color: const Color(0xFF68B55B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 6.0,
                ),
              );
            });
  }
}
