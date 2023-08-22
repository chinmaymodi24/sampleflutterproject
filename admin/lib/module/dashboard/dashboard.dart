import 'package:admin/module/dashboard/dashboard_ctrl.dart';
import 'package:admin/module/user/user.dart';
import 'package:admin/module/user/user_ctrl.dart';
import 'package:core/widget/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:core/styles/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class Dashboard extends StatelessWidget {
  final ctrl = Get.put(DashboardCtrl());

  Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.adminBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
        child: Obx(() {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ctrl.isLoading.value
                  ? SizedBox(
                      height: context.height * 0.83,
                      child: const Center(
                        child: CupertinoActivityIndicator(
                          color: AppColors.getPrimary,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        color:
                                            AppColors.adminCardBackgroundColor,
                                        elevation: 10,
                                        child: Padding(
                                          padding: const EdgeInsets.all(18.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "total_users".tr,
                                                style: GoogleFonts.manrope(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      AppColors.lightTextColor,
                                                ),
                                              ),
                                              const SizedBox(height: 29.0),
                                              Text(
                                                "${ctrl.qtyCurrencyModel().totalUsers}",
                                                style: GoogleFonts.manrope(
                                                  fontSize: 26.0,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      AppColors.lightTextColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20.0),
                                  Expanded(
                                    flex: 3,
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        color:
                                            AppColors.adminCardBackgroundColor,
                                        elevation: 10,
                                        child: Padding(
                                          padding: const EdgeInsets.all(18.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "total_amount_borrowed".tr,
                                                style: GoogleFonts.manrope(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      AppColors.lightTextColor,
                                                ),
                                              ),
                                              const SizedBox(height: 29.0),
                                              Text(
                                                "${ctrl.qtyCurrencyModel().getTotalAmtBorrowed} TZS",
                                                style: GoogleFonts.manrope(
                                                  fontSize: 26.0,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      AppColors.lightTextColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20.0),
                              SizedBox(
                                width: double.infinity,
                                height: context.height * 0.68,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  color: AppColors.adminCardBackgroundColor,
                                  elevation: 10,
                                  child: Container(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "top_borrower".tr,
                                              style: GoogleFonts.manrope(
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.lightTextColor,
                                              ),
                                            ),
                                            const SizedBox(height: 29.0),
                                            Text(
                                              "view_all_>".tr,
                                              style: GoogleFonts.manrope(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.getPrimary,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20.0),
                                        SizedBox(
                                          width: double.infinity,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "name".tr,
                                                style: GoogleFonts.manrope(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors
                                                      .adminDashboardTopBorrowerGreyColor,
                                                ),
                                              ),
                                              const SizedBox(height: 29.0),
                                              Text(
                                                "phone_number".tr,
                                                style: GoogleFonts.manrope(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors
                                                      .adminDashboardTopBorrowerGreyColor,
                                                ),
                                              ),
                                              const SizedBox(height: 29.0),
                                              Text(
                                                "borrowed_money".tr,
                                                style: GoogleFonts.manrope(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors
                                                      .adminDashboardTopBorrowerGreyColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Divider(
                                          height: 1,
                                          color: AppColors.adminDividerColor,
                                          thickness: 0.8,
                                        ),
                                        const SizedBox(height: 20.0),
                                        Obx(() {
                                          return Expanded(
                                            child: ListView.separated(
                                              shrinkWrap: true,
                                              physics:
                                                  const AlwaysScrollableScrollPhysics(),
                                              itemCount:
                                                  ctrl.topBorrowerList.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return SizedBox(
                                                  width: double.infinity,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Expanded(
                                                        child: Wrap(
                                                          children: [
                                                            Text(
                                                              ctrl
                                                                  .topBorrowerList[
                                                                      index]
                                                                  .fullName,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: GoogleFonts
                                                                  .manrope(
                                                                fontSize: 14.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: AppColors
                                                                    .lightTextColor,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Wrap(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          58.0),
                                                              child: Text(
                                                                "+${ctrl.topBorrowerList[index].cc} ${ctrl.topBorrowerList[index].phno}",
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style:
                                                                    GoogleFonts
                                                                        .manrope(
                                                                  fontSize:
                                                                      14.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: AppColors
                                                                      .lightTextColor,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Wrap(
                                                          alignment:
                                                              WrapAlignment.end,
                                                          children: [
                                                            Text(
                                                              "${ctrl.topBorrowerList[index].getAmt} TZS",
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: GoogleFonts
                                                                  .manrope(
                                                                fontSize: 14.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: AppColors
                                                                    .lightTextColor,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              separatorBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return const Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 6.0, bottom: 16.0),
                                                  child: Divider(
                                                    height: 1,
                                                    color: AppColors
                                                        .adminDividerColor,
                                                    thickness: 0.6,
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        }),
                                        Obx(
                                          () => ctrl.rxStatusTopBorrower.value
                                                  .isLoadingMore
                                              ? const Center(
                                                  child:
                                                      CupertinoActivityIndicator(
                                                  color: AppColors.getPrimary,
                                                ))
                                              : const SizedBox(),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20.0),

                        //Recent user registration
                        Expanded(
                          flex: 2,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            color: AppColors.adminCardBackgroundColor,
                            elevation: 10,
                            child: Container(
                              padding: const EdgeInsets.all(25.0),
                              child: SizedBox(
                                height: context.height * 0.81,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "recent_user_registration".tr,
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.lightTextColor,
                                      ),
                                    ),
                                    const SizedBox(height: 15.0),
                                    Obx(() {
                                      return Expanded(
                                        child: ListView.separated(
                                          physics:
                                              const AlwaysScrollableScrollPhysics(),
                                          itemCount: ctrl.recentUserList.length,
                                          controller: ctrl.scrollCtr,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Container(
                                              width: double.infinity,
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    ctrl.recentUserList[index]
                                                        .fullName,
                                                    style: const TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: AppColors
                                                          .lightTextColor,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5.0),
                                                  Text(
                                                    ctrl.recentUserList[index]
                                                        .email,
                                                    style: const TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: AppColors
                                                          .adminDashboardGreyColor,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5.0),
                                                  Text(
                                                    "+${ctrl.recentUserList[index].cc} ${ctrl.recentUserList[index].phno}",
                                                    style: const TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: AppColors
                                                          .adminDashboardGreyColor,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5.0),
                                                  Obx(() =>
                                                  ctrl.recentUserList[index]
                                                                .accStatus ==
                                                            0
                                                        ? SizedBox(
                                                            width: 100.0,
                                                            child: CustomButton(
                                                              text:
                                                                  "verify_profile".tr,
                                                              onPressed: () async {

                                                                await showDialog(
                                                                    context: context,
                                                                    builder: (BuildContext context) {
                                                                  return Dialog(
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                      BorderRadius.circular(
                                                                          24.0),
                                                                    ),
                                                                    child: UserGiveApprovalDialog(
                                                                      userModel: ctrl.recentUserList[index],
                                                                    ),
                                                                  );
                                                                });

                                                                await ctrl.init();


                                                              },
                                                              fontSize: 10.0,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0),
                                                              padding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          4.0,
                                                                      vertical:
                                                                          6.0),
                                                            ),
                                                          )
                                                        : const SizedBox(),
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                          separatorBuilder:
                                              (BuildContext context,
                                                  int index) {
                                            return const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 15.0));
                                          },
                                        ),
                                      );
                                    }),
                                    Obx(
                                      () => ctrl.rxStatus.value.isLoadingMore
                                          ? const Center(
                                              child: CupertinoActivityIndicator(
                                              color: AppColors.getPrimary,
                                            ))
                                          : const SizedBox(),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          );
        }),
      ),
    );
  }

//Old Sponsor design
/*@override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: AppColors.adminBackgroundColor,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            color: AppColors.adminCardBackgroundColor,
                            elevation: 10,
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Total Users",
                                    style: GoogleFonts.manrope(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.lightTextColor,
                                    ),
                                  ),
                                  const SizedBox(height: 29.0),
                                  Text(
                                    "119",
                                    style: GoogleFonts.manrope(
                                      fontSize: 26.0,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.lightTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        SizedBox(
                          width: double.infinity,
                          height: context.height * 0.68,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            color: AppColors.adminCardBackgroundColor,
                            elevation: 10,
                            child: Container(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Top Borrower  ",
                                        style: GoogleFonts.manrope(
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.lightTextColor,
                                        ),
                                      ),
                                      const SizedBox(height: 29.0),
                                      Text(
                                        "View All >",
                                        style: GoogleFonts.manrope(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.getPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20.0),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Name  ",
                                          style: GoogleFonts.manrope(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors
                                                .adminDashboardTopBorrowerGreyColor,
                                          ),
                                        ),
                                        const SizedBox(height: 29.0),
                                        Text(
                                          "Phone Number",
                                          style: GoogleFonts.manrope(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors
                                                .adminDashboardTopBorrowerGreyColor,
                                          ),
                                        ),
                                        const SizedBox(height: 29.0),
                                        Text(
                                          "Sponsor Money ",
                                          style: GoogleFonts.manrope(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors
                                                .adminDashboardTopBorrowerGreyColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(
                                    height: 1,
                                    color: AppColors.adminDividerColor,
                                    thickness: 0.8,
                                  ),
                                  const SizedBox(height: 20.0),
                                  Expanded(
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      itemCount: 18,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return SizedBox(
                                          width: double.infinity,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 100,
                                                child: Wrap(
                                                  children: [
                                                    Text(
                                                      "Juanita Burke   ",
                                                      style: GoogleFonts.manrope(
                                                        fontSize: 14.0,
                                                        fontWeight: FontWeight.w500,
                                                        color: AppColors
                                                            .lightTextColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 20.0),
                                              SizedBox(
                                                width: 120,
                                                child: Wrap(
                                                  children: [
                                                    Text(
                                                      "+91 98985 48444",
                                                      style: GoogleFonts.manrope(
                                                        fontSize: 14.0,
                                                        fontWeight: FontWeight.w500,
                                                        color: AppColors
                                                            .lightTextColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 65.0),
                                              SizedBox(
                                                width: 90,
                                                child: Wrap(
                                                  alignment: WrapAlignment.end,
                                                  children: [
                                                    Text(
                                                      "4000 TZS",
                                                      textAlign: TextAlign.end,
                                                      style: GoogleFonts.manrope(
                                                        fontSize: 14.0,
                                                        fontWeight: FontWeight.w500,
                                                        color: AppColors
                                                            .lightTextColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return const Padding(
                                          padding: EdgeInsets.only(top : 6.0, bottom: 16.0),
                                          child: Divider(
                                            height: 1,
                                            color: AppColors.adminDividerColor,
                                            thickness: 0.6,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            color: AppColors.adminCardBackgroundColor,
                            elevation: 10,
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Total Amount Borrowed  ",
                                    style: GoogleFonts.manrope(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.lightTextColor,
                                    ),
                                  ),
                                  const SizedBox(height: 29.0),
                                  Text(
                                    "7613 TZS",
                                    style: GoogleFonts.manrope(
                                      fontSize: 26.0,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.lightTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        SizedBox(
                          width: double.infinity,
                          height: context.height * 0.68,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            color: AppColors.adminCardBackgroundColor,
                            elevation: 10,
                            child: Container(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Top  Sponsor  ",
                                        style: GoogleFonts.manrope(
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.lightTextColor,
                                        ),
                                      ),
                                      const SizedBox(height: 29.0),
                                      Text(
                                        "View All >",
                                        style: GoogleFonts.manrope(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.getPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20.0),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Name  ",
                                          style: GoogleFonts.manrope(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors
                                                .adminDashboardTopBorrowerGreyColor,
                                          ),
                                        ),
                                        const SizedBox(height: 29.0),
                                        Text(
                                          "Phone Number",
                                          style: GoogleFonts.manrope(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors
                                                .adminDashboardTopBorrowerGreyColor,
                                          ),
                                        ),
                                        const SizedBox(height: 29.0),
                                        Text(
                                          "Sponsor Money ",
                                          style: GoogleFonts.manrope(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors
                                                .adminDashboardTopBorrowerGreyColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(
                                    height: 1,
                                    color: AppColors.adminDividerColor,
                                    thickness: 0.8,
                                  ),
                                  const SizedBox(height: 20.0),
                                  Expanded(
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      itemCount: 18,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return SizedBox(
                                          width: double.infinity,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 100,
                                                child: Wrap(
                                                  children: [
                                                    Text(
                                                      "Juanita Burke   ",
                                                      style: GoogleFonts.manrope(
                                                        fontSize: 14.0,
                                                        fontWeight: FontWeight.w500,
                                                        color: AppColors
                                                            .lightTextColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 20.0),
                                              SizedBox(
                                                width: 120,
                                                child: Wrap(
                                                  children: [
                                                    Text(
                                                      "+91 98985 48444",
                                                      style: GoogleFonts.manrope(
                                                        fontSize: 14.0,
                                                        fontWeight: FontWeight.w500,
                                                        color: AppColors
                                                            .lightTextColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 65.0),
                                              SizedBox(
                                                width: 90,
                                                child: Wrap(
                                                  alignment: WrapAlignment.end,
                                                  children: [
                                                    Text(
                                                      "4000 TZS",
                                                      textAlign: TextAlign.end,
                                                      style: GoogleFonts.manrope(
                                                        fontSize: 14.0,
                                                        fontWeight: FontWeight.w500,
                                                        color: AppColors
                                                            .lightTextColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return const Padding(
                                          padding: EdgeInsets.only(top : 6.0, bottom: 16.0),
                                          child: Divider(
                                            height: 1,
                                            color: AppColors.adminDividerColor,
                                            thickness: 0.6,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  Expanded(
                    flex: 2,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: AppColors.adminCardBackgroundColor,
                      elevation: 10,
                      child: Container(
                        padding: const EdgeInsets.all(25.0),
                        child: SizedBox(
                          height: context.height * 0.81,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Recent User Registration",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.lightTextColor,
                                ),
                              ),
                              const SizedBox(height: 15.0),
                              Expanded(
                                child: ListView.separated(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  itemCount: 10,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(15.0),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Juanita Burke",
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.lightTextColor,
                                            ),
                                          ),
                                          const SizedBox(height: 5.0),
                                          const Text(
                                            "JuanitaBurke@gmail.com",
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors
                                                  .adminDashboardGreyColor,
                                            ),
                                          ),
                                          const SizedBox(height: 5.0),
                                          const Text(
                                            "+1 66595 44842",
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors
                                                  .adminDashboardGreyColor,
                                            ),
                                          ),
                                          const SizedBox(height: 5.0),
                                          SizedBox(
                                            width: 100.0,
                                            child: CustomButton(
                                              text: "Verify Profile",
                                              onPressed: () {},
                                              fontSize: 10.0,
                                              borderRadius:
                                              BorderRadius.circular(5.0),
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 4.0, vertical: 6.0),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const Padding(
                                        padding:
                                        EdgeInsets.symmetric(vertical: 15.0));
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }*/
}
