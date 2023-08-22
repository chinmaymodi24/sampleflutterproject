import 'dart:developer';
import 'package:admin/module/chat/admin_chat_ctrl.dart';
import 'package:admin/module/home/home_ctrl.dart';
import 'package:admin/module/user/user_statement/user_statement_ctrl.dart';
import 'package:admin/styles/app_assets.dart';
import 'package:admin/utils/app_toast.dart';
import 'package:admin/widget/common_container.dart';
import 'package:core/api_routes/api_routes.dart';
import 'package:core/backend/firebase/api/chat_service.dart';
import 'package:core/backend/firebase/model/conversation_model.dart';
import 'package:core/styles/app_themes.dart';
import 'package:core/widget/custom_button.dart';
import 'package:core/widget/custom_filled_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:core/styles/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import '../../../app/app_repo.dart';

class UserStatement extends StatelessWidget {
  final ctrl = Get.put(UserStatementCtrl());

  UserStatement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.adminBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.adminUserStatementAppBarBgColor,
        centerTitle: true,
        leadingWidth: 84,
        title: Text(
          "user_statement".tr,
          style: GoogleFonts.poppins(
            fontSize: 18.0,
            color: AppColors.adminUserStatementBackIconBgColor,
            fontWeight: FontWeight.w400,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(
            left: 24.0,
            top: 10,
            bottom: 10.0,
            right: 22.0,
          ),
          child: Material(
            borderRadius: BorderRadius.circular(40.0),
            color: AppColors.darkBlue,
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
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Obx(() {
          return ctrl.isLoading.value
              ? const Center(
                  child: CupertinoActivityIndicator(
                    color: AppColors.getPrimary,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserStatementDetails(ctrl: ctrl),
                    const SizedBox(width: 20.0),
                    Expanded(
                      flex: 6,
                      child: SizedBox(
                        width: double.infinity,
                        height: context.height * 0.86,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: AppColors.adminCardBackgroundColor,
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                UserLoanList(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
        }),
      ),
    );
  }
}

class UserLoanList extends StatelessWidget {
  final ctrl = Get.find<UserStatementCtrl>();

  UserLoanList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height * 0.78,
      child: Obx(() {
        if (ctrl.isGetList.isFalse) {
          if (ctrl.userStatementList.isNotEmpty) {
            return ListView.separated(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                itemCount: ctrl.userStatementList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.getPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 84.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.all(18.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "loan_number".tr,
                                    style: GoogleFonts.inter(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.lightTextColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    "-".toUpperCase(),
                                    style: GoogleFonts.inter(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.lightTextColor,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "date".tr,
                                    style: GoogleFonts.inter(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.lightTextColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    DateFormat('dd-MM-yyyy')
                                        .format(ctrl
                                            .userStatementList[index].createdAt)
                                        .toString(),
                                    style: GoogleFonts.inter(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.lightTextColor,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "total_amount".tr,
                                    style: GoogleFonts.inter(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.lightTextColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    "${ctrl.userStatementList[index].getBorrowAmount} TZS",
                                    style: GoogleFonts.inter(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.lightTextColor,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "tenure_months".tr,
                                    style: GoogleFonts.inter(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.lightTextColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    "${ctrl.userStatementList[index].tenure} ${"months".tr}",
                                    style: GoogleFonts.inter(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.lightTextColor,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "interest".tr,
                                    style: GoogleFonts.inter(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.lightTextColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    ctrl.userStatementList[index].intrestRate ==
                                            0.0
                                        ? "-"
                                        : "${ctrl.userStatementList[index].intrestRate} %",
                                    style: GoogleFonts.inter(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.lightTextColor,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 28.0),
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  "date".tr,
                                  style: GoogleFonts.inter(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.lightTextColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "principal_amount".tr,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.lightTextColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "interest".tr,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.lightTextColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "payment".tr,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.lightTextColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "outstanding_amount".tr,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.lightTextColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "status".tr,
                                  textAlign: TextAlign.end,
                                  style: GoogleFonts.inter(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.lightTextColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.black,
                          ),
                        ),
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: ctrl
                              .userStatementList[index].loanStatement.length,
                          itemBuilder: (BuildContext context, int subIndex) {
                            return SizedBox(
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      DateFormat('dd-MM-yyyy')
                                          .format(ctrl.userStatementList[index]
                                              .loanStatement[subIndex].date)
                                          .toString(),
                                      style: GoogleFonts.inter(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.lightTextColor,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      "${ctrl.userStatementList[index].loanStatement[subIndex].getPrincipleAmt} TZS",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.lightTextColor,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: SizedBox(
                                      width: 170,
                                      child: Wrap(
                                        alignment: WrapAlignment.center,
                                        children: [
                                          Text(
                                            "${ctrl.userStatementList[index].loanStatement[subIndex].getInterest} TZS",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.lightTextColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: SizedBox(
                                      width: 170,
                                      child: Wrap(
                                        alignment: WrapAlignment.center,
                                        children: [
                                          Text(
                                            "${ctrl.userStatementList[index].loanStatement[subIndex].getPayment} TZS",
                                            style: GoogleFonts.inter(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.lightTextColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Wrap(
                                      alignment: WrapAlignment.center,
                                      children: [
                                        Text(
                                          "${ctrl.userStatementList[index].loanStatement[subIndex].getOutstandingAmt} TZS",
                                          style: GoogleFonts.inter(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.lightTextColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: (ctrl
                                                    .userStatementList[index]
                                                    .loanStatement
                                                    .last
                                                    .outstandingAmt >
                                                0)
                                            ? () async {
                                                await showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return Dialog(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      24.0),
                                                        ),
                                                        child: ConfirmPay(
                                                          index: index,
                                                          subIndex: subIndex,
                                                        ),
                                                      );
                                                    });
                                                ctrl.payAmountCTRL.text = '';
                                              }
                                            : null,
                                        // () async {
                                        //     await showDialog(
                                        //         context: context,
                                        //         builder:
                                        //             (BuildContext context) {
                                        //           return Dialog(
                                        //             shape:
                                        //                 RoundedRectangleBorder(
                                        //               borderRadius:
                                        //                   BorderRadius
                                        //                       .circular(
                                        //                           24.0),
                                        //             ),
                                        //             child: ConfirmPay(
                                        //               index: index,
                                        //               subIndex: subIndex,
                                        //             ),
                                        //           );
                                        //         });
                                        //     ctrl.payAmountCTRL.text = '';
                                        //   },
                                        child: Text(
                                          ctrl
                                              .userStatementList[index]
                                              .loanStatement[subIndex]
                                              .statusString,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.inter(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.lightTextColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 6.0, bottom: 16.0),
                              child: Divider(
                                height: 1,
                                color: AppColors.adminDividerColor,
                                thickness: 0.6,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10.0),
                        Container(
                          width: double.infinity,
                          height: 44.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18.0, vertical: 6.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "loan_status".tr,
                                style: GoogleFonts.inter(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.lightTextColor,
                                ),
                              ),
                              Text(
                                ctrl.userStatementList[index].getStatus,
                                style: GoogleFonts.inter(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  color: ctrl
                                      .userStatementList[index].getStatusColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Buttons(ctrl: ctrl, index: index),
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10.0,
                    ),
                  );
                });
          } else {
            return Center(
              child: Text(
                "no_loan_found".tr,
                textAlign: TextAlign.center,
                style: themes.light.textTheme.headlineSmall?.copyWith(
                  color: const Color(0xFF8B8B8B),
                  fontSize: 15.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          }
        } else {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }
      }),
    );
  }
}

class Buttons extends StatelessWidget {
  final int index;

  const Buttons({
    super.key,
    required this.ctrl,
    required this.index,
  });

  final UserStatementCtrl ctrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ctrl.userStatementList[index].loanStatement.isEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (ctrl.userStatementList[index].status == 0) ...[
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: SizedBox(
                            width: 104.0,
                            height: 38.0,
                            child: CustomButton(
                              borderRadius: BorderRadius.circular(30.0),
                              primaryColor: const Color(0xFF5FC54F),
                              text: "Approve".tr,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4.0, vertical: 8.0),
                              fontSize: 13.0,
                              onPressed: () async {
                                ctrl.getAllSponsorById(
                                    loanId: ctrl.userStatementList[index].id);

                                await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(24.0),
                                        ),
                                        child: ApprovalDialog(
                                          loanId:
                                              ctrl.userStatementList[index].id,
                                          index: index,
                                        ),
                                      );
                                    });
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: SizedBox(
                            width: 114.0,
                            height: 38.0,
                            child: CustomButton(
                              borderRadius: BorderRadius.circular(30.0),
                              primaryColor: const Color(0xFFC86060),
                              text: "cancel".tr,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4.0, vertical: 8.0),
                              fontSize: 13.0,
                              onPressed: () async {
                                await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        child: ConfirmRejectLoan(
                                          index: index,
                                        ),
                                      );
                                    });
                              },
                            ),
                          ),
                        ),
                      ],
                    ],
                  )
                : const SizedBox(),
            Obx(
              () => ctrl.userStatementList[index].isSponsored == 1
                  ? Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: SizedBox(
                        width: 134.0,
                        height: 38.0,
                        child: CustomButton(
                          borderRadius: BorderRadius.circular(30.0),
                          primaryColor: const Color(0xFF6A7EC5),
                          text: "sponsor_status".tr,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 8.0),
                          fontSize: 13.0,
                          onPressed: () async {
                            ctrl.getAllSponsorById(
                                loanId: ctrl.userStatementList[index].id);

                            await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24.0),
                                    ),
                                    child: SponsorStatus(
                                      loanId: ctrl.userStatementList[index].id,
                                      status:
                                          ctrl.userStatementList[index].status,
                                      index: index,
                                    ),
                                  );
                                });
                          },
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),
            SizedBox(
              width: 174.0,
              height: 38.0,
              child: Obx(() {
                return CustomButton(
                  borderRadius: BorderRadius.circular(30.0),
                  primaryColor: const Color(0xFF747474),
                  text: "download_statement".tr,
                  isLoading: ctrl.isDownloadLoading.value,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4.0, vertical: 8.0),
                  fontSize: 13.0,
                  onPressed: () {
                    ctrl.exportUserStatementExcel(i: index);
                  },
                );
              }),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ctrl.userStatementList[index].status == 2
                ? Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: SizedBox(
                      width: 110.0,
                      height: 38.0,
                      child: CustomButton(
                        borderRadius: BorderRadius.circular(30.0),
                        primaryColor: const Color(0xFF747474),
                        text: "Reopen",
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 8.0),
                        fontSize: 13.0,
                        onPressed: () async {
                          ctrl.isLoading.value = true;

                          await ctrl.reOpenLoanFromAdmin(
                            loanId: ctrl.userStatementList[index].id,
                          );

                          await ctrl.init();
                        },
                      ),
                    ),
                  )
                : const SizedBox(),
            ctrl.userStatementList[index].status == 2
                ? SizedBox(
                    width: 100.0,
                    height: 38.0,
                    child: CustomButton(
                      borderRadius: BorderRadius.circular(30.0),
                      primaryColor: const Color(0xFF747474),
                      text: ctrl.userStatementList[index].isHide != 1
                          ? "hide".tr
                          : "unhide".tr,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0.0, vertical: 8.0),
                      fontSize: 13.0,
                      onPressed: () async {
                        ctrl.isLoading.value = true;

                        if (ctrl.userStatementList[index].isHide != 1) {
                          await ctrl.hideOrUnHideLoan(
                            loanId: ctrl.userStatementList[index].id,
                            isHide: 1,
                          );
                        } else {
                          await ctrl.hideOrUnHideLoan(
                            loanId: ctrl.userStatementList[index].id,
                            isHide: 0,
                          );
                        }

                        await ctrl.init();
                      },
                    ),
                  )
                : const SizedBox(),
            const SizedBox(width: 10),
            Visibility(
              visible: ctrl.userStatementList[index].status == 2 ||
                  ctrl.userStatementList[index].status == -1,
              child: SizedBox(
                width: 100.0,
                height: 38.0,
                child: CustomButton(
                  borderRadius: BorderRadius.circular(30.0),
                  primaryColor: const Color(0xFF747474),
                  text: "Delete",
                  padding: const EdgeInsets.symmetric(
                      horizontal: 0.0, vertical: 8.0),
                  fontSize: 13.0,
                  onPressed: () async {
                    await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            child: confirmExit(context),
                          );
                        });
                  },
                ),
              ),
            ),
            ctrl.userStatementList[index].status == 1
                ? Padding(
                    padding: const EdgeInsets.only(right: 14.0),
                    child: SizedBox(
                      width: 110.0,
                      height: 38.0,
                      child: CustomButton(
                        borderRadius: BorderRadius.circular(30.0),
                        primaryColor: const Color(0xFF3C7CE8),
                        text: "Close loan",
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 8.0),
                        fontSize: 13.0,
                        onPressed: () async {
                          logger.e(
                              " userStatementList[index].id, = ${ctrl.userStatementList[index].id}");

                          await ctrl.giveLoanStatusFromAdmin(
                            loanId: ctrl.userStatementList[index].id,
                            status: 2,
                            tenure: null,
                            intrestRate: null,
                            approveDate: null,
                          );
                        },
                      ),
                    ),
                  )
                : const SizedBox(),
            ctrl.userStatementList[index].status == 1
                ? Padding(
                    padding: const EdgeInsets.only(right: 14.0),
                    child: SizedBox(
                      width: 140.0,
                      height: 38.0,
                      child: CustomButton(
                        borderRadius: BorderRadius.circular(30.0),
                        primaryColor: const Color(0xFF3C7CE8),
                        text: "send_reminder".tr,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 8.0),
                        fontSize: 13.0,
                        onPressed: () async {
                          await ctrl.sendRemainderNotification(
                              type: 3,
                              typeIdLoanId: ctrl.userStatementList[index].id,
                              uId: ctrl.userId);
                        },
                      ),
                    ),
                  )
                : const SizedBox(),
            ctrl.userStatementList[index].status == 1
                ? SizedBox(
                    width: 104.0,
                    height: 38.0,
                    child: CustomButton(
                      borderRadius: BorderRadius.circular(30.0),
                      primaryColor: Colors.black,
                      text: "edit_loan".tr,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4.0, vertical: 8.0),
                      fontSize: 13.0,
                      onPressed: () async {
                        //AppToast.msg('Under development');
                        await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                                child: ApprovalDialog(
                                  loanId: ctrl.userStatementList[index].id,
                                  index: index,
                                  formEdit: true,
                                ),
                              );
                            });
                      },
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ],
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
                "Delete !".tr,
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
            "Are you sure you want to delete this statement ?".tr,
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
                onPressed: Get.back,
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
                  await ctrl.giveLoanStatusFromAdmin(
                    loanId: ctrl.userStatementList[index].id,
                    status: -3,
                    tenure: null,
                    intrestRate: null,
                    approveDate: null,
                  );
                  Get.back();
                  await ctrl.init();
                  //repo.userModel(UserModel.fromEmpty());
                  // var s = await SharedPreferences.getInstance();
                  // s.clear();
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

class UserStatementDetails extends StatelessWidget {
  const UserStatementDetails({
    super.key,
    required this.ctrl,
  });

  final UserStatementCtrl ctrl;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        width: double.infinity,
        //height: context.height * 0.61,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: AppColors.adminCardBackgroundColor,
          elevation: 0,
          child: Obx(() {
            return Container(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0.0,
                        backgroundColor: AppColors.getPrimary.withOpacity(0.2),
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () async {
                        ctrl.isChatButtonLoading.value = true;

                        // final chatCtrl = Get.find<AdminChatCtrl>();
                        //
                        // logger.i("userId = ${ctrl.userId}");
                        // DocumentSnapshot temp = await SupportChatQuery()
                        //     .supportChat
                        //     .doc(ctrl.userId.toString())
                        //     .get();
                        //
                        // if (temp.exists) {
                        //   logger.i("chat is exists");
                        //   await SupportChatQuery()
                        //       .supportChat
                        //       .doc(ctrl.userId.toString())
                        //       .update({
                        //     "last_msg": "",
                        //     "last_msg_by": ctrl.userId,
                        //     "msg_type": 0,
                        //     "sendAt": Timestamp.now(),
                        //     "unread_count_admin": 0,
                        //     "user_id": ctrl.userId,
                        //   });
                        // } else {
                        //   logger.i("chat is not exists");
                        //   await SupportChatQuery()
                        //       .supportChat
                        //       .doc(ctrl.userId.toString())
                        //       .set({
                        //     "last_msg": "",
                        //     "last_msg_by": ctrl.userId,
                        //     "msg_type": 0,
                        //     "sendAt": Timestamp.now(),
                        //     "unread_count_admin": 0,
                        //     "user_id": ctrl.userId,
                        //   });
                        // }
                        // List<AdminChatListModel> tempList = chatCtrl.userList
                        //     .where((element) =>
                        // int.parse(element.docId) == ctrl.userId)
                        //     .toList();
                        // chatCtrl.adminChatListModel.value = tempList.first;

                        ConversationModel c = ConversationModel(
                          createdAt: DateTime.now(),
                          message: "",
                          chatId: ctrl.userId,
                          fromId: app.user.id,
                          toId: ctrl.userId,
                          type: 1,
                          role: Role.support,
                        );

                        await ChatService().supportSendMsg(
                          c,
                          false,
                        );

                        final chatCtrl = Get.find<AdminChatCtrl>();
                        chatCtrl.chatId.value = ctrl.userId;

                        ctrl.isChatButtonLoading.value = false;

                        final homeCtrl = Get.find<HomeCtrl>();
                        Get.back();
                        homeCtrl.isSelected.value = 2;

                        // //On User details tap
                        // chatCtrl.isChatLoading.value = true;
                        //
                        // UserModel? userModel =
                        // await ctrl.getChatUserDetail(id: ctrl.userId);
                        //
                        // if (userModel != null) {
                        //   chatCtrl.chatUserDetail.value = userModel;
                        // }
                        //
                        // try {
                        //   await SupportChatQuery()
                        //       .supportChat
                        //       .doc("${ctrl.userId}")
                        //       .update({
                        //     "unread_count_admin": 0,
                        //     "updated_at": "",
                        //     "updated_by": 0,
                        //   });
                        // } catch (e) {
                        //   log("e =>>> $e");
                        // }
                        //
                        // uid = ctrl.userId;
                        //
                        // await chatCtrl.getChatList(
                        //   id: ctrl.userId.toString(),
                        // );
                        // chatCtrl.isChatLoading.value = false;
                      },
                      child: ctrl.isChatButtonLoading.value == true
                          ? const CupertinoActivityIndicator(
                              color: AppColors.getPrimary,
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${"chat_with".tr} ${ctrl.userStatementDetailModel.value.userName}",
                                  style: const TextStyle(
                                    color: AppColors.darkBlue,
                                    fontSize: 13.0,
                                    fontFamily: "SegoeUI-Bold",
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(width: 6.0),
                                Image.asset(
                                  AppAssets.drawerChatUnselected,
                                  color: AppColors.darkBlue,
                                  width: 22.0,
                                  height: 22.0,
                                ),
                              ],
                            ),
                    );
                  }),
                  const SizedBox(height: 15.0),
                  Text(
                    "total_taken_loan".tr,
                    style: GoogleFonts.inter(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.userStatementLeftPanelFontColor,
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  Text(
                    "${ctrl.userStatementDetailModel.value.totalLoan}",
                    style: GoogleFonts.inter(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: AppColors.lightTextColor,
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  Text(
                    "closed_loan".tr,
                    style: GoogleFonts.inter(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.userStatementLeftPanelFontColor,
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  Text(
                    "${ctrl.userStatementDetailModel.value.closedLoan}",
                    style: GoogleFonts.inter(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: AppColors.lightTextColor,
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  Text(
                    "eligible_amount".tr,
                    style: GoogleFonts.inter(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.userStatementLeftPanelFontColor,
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  Container(
                    //width: 150.0,
                    height: 44.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: AppColors.adminUserStatementEligibleAmountBgColor,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          //width: 90.0,
                          height: 40.0,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 11.0),
                            child: Text(
                              "${ctrl.userStatementDetailModel.value.getElgAmt} TZS",
                              textAlign: TextAlign.start,
                              style: GoogleFonts.inter(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w700,
                                color: AppColors.lightTextColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Image.asset(
                          AppAssets.userStatementEligibleAmount,
                          width: 16.0,
                          height: 16.0,
                          fit: BoxFit.fitHeight,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  Text(
                    "total_taken_loan_amount".tr,
                    style: GoogleFonts.inter(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.userStatementLeftPanelFontColor,
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  Text(
                    "${ctrl.userStatementDetailModel.value.getTotalLoanAmt} TZS",
                    style: GoogleFonts.inter(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: AppColors.lightTextColor,
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  Text(
                    "paid_amount".tr,
                    style: GoogleFonts.inter(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.userStatementLeftPanelFontColor,
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  Text(
                    "${ctrl.userStatementDetailModel.value.getTotalPaidAmt} TZS",
                    style: GoogleFonts.inter(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: AppColors.lightTextColor,
                    ),
                  ),
                  const SizedBox(height: 15.0),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class ApprovalDialog extends StatelessWidget {
  final ctrl = Get.put(UserStatementCtrl());

  final int loanId;
  final int index;
  final bool formEdit;

  ApprovalDialog(
      {Key? key,
      required this.loanId,
      required this.index,
      this.formEdit = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonContainer(
      width: 533.0,
      borderRadius: BorderRadius.circular(24.0),
      padding: const EdgeInsets.symmetric(
        vertical: 30.0,
        horizontal: 30.0,
      ),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "loan_details".tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontFamily: "SegoeUI-Bold",
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  splashRadius: 16.0,
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.cancel_outlined),
                ),
              ],
            ),
            const SizedBox(height: 23.0),
            Text(
              "tenure".tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20.0,
                fontFamily: "SegoeUI-Bold",
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5.0),
            FilledTextField(
              hint: "3 ${"months".tr}",
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                CustomMonthInputFormatter(),
              ],
              controller: ctrl.tenureCtrl,
              maxLength: 9,
              textInputType: TextInputType.number,
              borderRadius: BorderRadius.circular(10.0),
              filledColor: const Color(0xFFF6F6F6),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 20.0),
            Text(
              "interest_rate".tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20.0,
                fontFamily: "SegoeUI-Bold",
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5.0),
            FilledTextField(
              hint: "10%",
              controller: ctrl.interestRateCtrl,
              textInputAction: TextInputAction.done,
              maxLength: 4,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                CustomInterestInputFormatter(),
              ],
              borderRadius: BorderRadius.circular(10.0),
              textInputType: TextInputType.text,
              filledColor: const Color(0xFFF6F6F6),
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: "approve".tr,
                    primaryColor: const Color(0xFF57A51B),
                    onPressed: () async {
                      if (ctrl.tenureCtrl.text.trim().isEmpty) {
                        AppToast.msg("please_enter_tenure".tr);
                      } else if (int.parse(
                              ctrl.tenureCtrl.text.trim().split(" ").first) <
                          ctrl.userStatementList[index].tenure) {
                        AppToast.msg("loan_tenure_must_be_grater".tr);
                      } else if (ctrl.interestRateCtrl.text.trim().isEmpty) {
                        AppToast.msg("please_enter_interest_rate".tr);
                      } else {
                        int tenure = int.parse(ctrl.tenureCtrl.text
                            .replaceAll(" Months", "")
                            .trim());

                        log("tenure = $tenure");

                        double interestRate = double.parse(ctrl
                            .interestRateCtrl.text
                            .replaceAll(" %", "")
                            .trim()
                            .toString());
                        log("interestRate = $interestRate");
                        Get.back();
                        await ctrl.giveLoanStatusFromAdmin(
                          loanId: loanId,
                          status: 1,
                          tenure: tenure,
                          intrestRate: interestRate,
                          approveDate: DateTime.now(),
                          formEdit: formEdit,
                        );
                      }
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ConfirmPay extends StatelessWidget {
  final ctrl = Get.put(UserStatementCtrl());

  final int index;
  final int subIndex;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ConfirmPay({Key? key, required this.index, required this.subIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonContainer(
      width: 533.0,
      borderRadius: BorderRadius.circular(24.0),
      padding: const EdgeInsets.symmetric(
        vertical: 30.0,
        horizontal: 30.0,
      ),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "payment_amount!".tr,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontFamily: "SegoeUI-Bold",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    splashRadius: 16.0,
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.cancel_outlined),
                  ),
                ],
              ),
              const SizedBox(height: 23.0),
              FilledTextField(
                controller: ctrl.payAmountCTRL,
                textInputType: TextInputType.number,
                hint: 'pay_amount'.tr,
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'enter_amount'.tr;
                  } else if (int.tryParse(v) == null) {
                    return 'enter_valid_amount'.tr;
                  } else if (int.parse(ctrl.payAmountCTRL.text) >
                      ctrl.userStatementList[index].loanStatement[subIndex]
                          .outstandingAmt) {
                    return 'amount_is_not_more_then_outstanding_amount'.tr;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: "paid".tr,
                      primaryColor: AppColors.getPrimary,
                      onPressed: () async {
                        if (formKey.currentState?.validate() ?? false) {
                          Get.back();
                          await ctrl.updateLoanDetail(
                              index: index, subIndex: subIndex);
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    child: CustomButton(
                      text: "cancel".tr,
                      primaryColor: Colors.grey,
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ConfirmRejectLoan extends StatelessWidget {
  final ctrl = Get.put(UserStatementCtrl());

  final int index;

  ConfirmRejectLoan({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonContainer(
      width: 320.0,
      borderRadius: BorderRadius.circular(24.0),
      padding: const EdgeInsets.symmetric(
        vertical: 30.0,
        horizontal: 30.0,
      ),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "reject_loan!".tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontFamily: "SegoeUI-Bold",
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  splashRadius: 16.0,
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.cancel_outlined),
                ),
              ],
            ),
            const SizedBox(height: 23.0),
            Text(
              "alert_reject_msg?".tr,
              textAlign: TextAlign.start,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24.0),
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
                    Get.back();
                    ctrl.isLoading.value = true;
                    ctrl.giveLoanStatusFromAdmin(
                      loanId: ctrl.userStatementList[index].id,
                      status: -1,
                      tenure: null,
                      intrestRate: null,
                      approveDate: null,
                    );
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
      ),
    );
  }
}

class SponsorStatus extends StatelessWidget {
  final ctrl = Get.put(UserStatementCtrl());
  final int loanId;
  final int status;
  final int index;

  SponsorStatus({
    Key? key,
    required this.loanId,
    required this.status,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonContainer(
      width: 533.0,
      borderRadius: BorderRadius.circular(24.0),
      padding: const EdgeInsets.symmetric(
        vertical: 30.0,
        horizontal: 30.0,
      ),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "sponsor_status".tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontFamily: "SegoeUI-Bold",
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  splashRadius: 16.0,
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.cancel_outlined),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Obx(() {
              return ctrl.isSponsorLoading.value
                  ? const Center(
                      child: CupertinoActivityIndicator(
                        color: AppColors.getPrimary,
                      ),
                    )
                  : ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(
                        right: 10.0,
                        top: 20.0,
                        bottom: status == 0 ? 20.0 : 0.0,
                      ),
                      itemCount: ctrl.sponsorList.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
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
                                  style: themes.light.textTheme.headlineSmall
                                      ?.copyWith(
                                    fontSize: 16.0,
                                    color: AppColors.lightTextColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              ctrl.sponsorList[index].getStatus,
                              textAlign: TextAlign.center,
                              style: themes.light.textTheme.headlineSmall
                                  ?.copyWith(
                                fontFamily: "SegoeUI-Bold",
                                fontSize: 16.0,
                                color:
                                    ctrl.sponsorList[index].getIsApprovedColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10.0,
                          ),
                        );
                      });
            }),
            const SizedBox(height: 10.0),
            status == 0
                ? Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: "approve".tr,
                          primaryColor: const Color(0xFF57A51B),
                          onPressed: () async {
                            Get.back();
                            await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24.0),
                                    ),
                                    child: ApprovalDialog(
                                      loanId: loanId,
                                      index: index,
                                    ),
                                  );
                                });
                          },
                        ),
                      ),
                      const SizedBox(width: 15.0),
                      Expanded(
                        child: CustomButton(
                          text: "reject".tr,
                          primaryColor: const Color(0xFFEE6E6E),
                          onPressed: () {
                            Get.back();
                            ctrl.giveLoanStatusFromAdmin(
                              loanId: loanId,
                              status: -1,
                              tenure: null,
                              intrestRate: null,
                              approveDate: null,
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
