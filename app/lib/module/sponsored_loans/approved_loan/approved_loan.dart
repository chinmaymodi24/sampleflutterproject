import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sampleflutterproject/module/sponsored_loans/approved_loan/approved_loan_ctrl.dart';
import 'package:sampleflutterproject/module/sponsored_loans/sponsored_loan_detail/sponsored_loan_details.dart';
import 'package:sampleflutterproject/styles/app_assets.dart';
import 'package:sampleflutterproject/styles/app_colors.dart';
import 'package:sampleflutterproject/styles/app_themes.dart';
import 'package:get/get.dart';
import 'package:sampleflutterproject/widget/common_container.dart';
import 'package:sampleflutterproject/widget/custom_button.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';

class ApprovedLoan extends StatefulWidget {
  const ApprovedLoan({Key? key}) : super(key: key);

  @override
  State<ApprovedLoan> createState() => _ApprovedLoanState();
}

class _ApprovedLoanState extends State<ApprovedLoan> {
  final ctrl = Get.put(ApprovedLoanCtrl());

  @override
  Widget build(BuildContext context) {
    return ScaffoldGradientBackground(
      //extendBody: true,
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white,
          Color(0xFFD1E2FF),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ctrl.getAllApprovedLoan();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(() {
              return ctrl.isLoading.value
                  ? const Center(
                      child: CupertinoActivityIndicator(
                        color: AppColors.getPrimary,
                      ),
                    )
                  : ctrl.sponsoredLoanList.isEmpty
                      ? Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            child: SizedBox(
                              height: context.height * 0.7,
                              child: Center(
                                child: Text(
                                  "no_loan_found".tr,
                                  textAlign: TextAlign.center,
                                  style: themes.light.textTheme.headlineSmall
                                      ?.copyWith(
                                    color: const Color(0xFF8B8B8B),
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView.separated(
                              physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics(),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 20.0),
                              itemCount: ctrl.sponsoredLoanList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonContainer(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 15.0,
                                        ),
                                      ],
                                      onTap: () {
                                        Get.to(
                                          () => SponsoredLoanDetails(),
                                          arguments:
                                              ctrl.sponsoredLoanList[index].id,
                                        );
                                      },
                                      borderRadius: BorderRadius.circular(14.0),
                                      width: double.infinity,
                                      child: Column(
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
                                                ctrl.sponsoredLoanList[index]
                                                    .fullName,
                                                textAlign: TextAlign.center,
                                                style: themes.light.textTheme
                                                    .headlineSmall
                                                    ?.copyWith(
                                                  color:
                                                      const Color(0xFF8B8B8B),
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              Image.asset(
                                                AppAssets.homeNext,
                                                width: 18.0,
                                                height: 16.0,
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 15.0),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "${ctrl.sponsoredLoanList[index].borrowAmount} TZS",
                                                textAlign: TextAlign.center,
                                                style: themes.light.textTheme
                                                    .headlineSmall
                                                    ?.copyWith(
                                                  fontSize: 17.0,
                                                  color:
                                                      AppColors.lightTextColor,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10.0),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                ctrl.sponsoredLoanList[index]
                                                            .tenure ==
                                                        0
                                                    ? "--"
                                                    : "${ctrl.sponsoredLoanList[index].tenure} ${"months".tr}",
                                                textAlign: TextAlign.center,
                                                style: themes.light.textTheme
                                                    .headlineSmall
                                                    ?.copyWith(
                                                  fontSize: 16.0,
                                                  color: index == 0
                                                      ? Colors.black
                                                      : AppColors.getPrimary,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Text(
                                                "--",
                                                textAlign: TextAlign.center,
                                                style: themes.light.textTheme
                                                    .headlineSmall
                                                    ?.copyWith(
                                                  fontSize: 16.0,
                                                  color: AppColors.getPrimary,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10.0),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                //width: 69.0,
                                                height: 26.0,
                                                child: CustomButton(
                                                  isWidth: false,
                                                  primaryColor:
                                                      const Color(0xFF668BC2),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 0.0,
                                                      horizontal: 12),
                                                  text: "approved".tr,
                                                  // text: ctrl
                                                  //             .sponsoredLoanList[
                                                  //                 index]
                                                  //             .status ==
                                                  //         0
                                                  //     ? "Pending"
                                                  //     : ctrl
                                                  //                 .sponsoredLoanList[
                                                  //                     index]
                                                  //                 .status ==
                                                  //             1
                                                  //         ? "Approved"
                                                  //         : ctrl.sponsoredLoanList[index]
                                                  //                     .status ==
                                                  //                 2
                                                  //             ? "Closed"
                                                  //             : "Rejected",
                                                  color: Colors.white,
                                                  fontSize: 11.0,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.0),
                                                  onPressed: () {},
                                                ),
                                              ),
                                              Text(
                                                "-".toUpperCase(),
                                                textAlign: TextAlign.center,
                                                style: themes.light.textTheme
                                                    .headlineSmall
                                                    ?.copyWith(
                                                  color:
                                                      const Color(0xFF8B8B8B),
                                                  fontSize: 14.5,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 15.0),
                                  ],
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const SizedBox();
                              }),
                        );
            }),
            const SizedBox(height: 80.0),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    ctrl.getAllApprovedLoan();
    super.initState();
  }
}
