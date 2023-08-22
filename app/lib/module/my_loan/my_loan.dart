import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sampleflutterproject/module/loan_details/loan_details.dart';
import 'package:sampleflutterproject/module/my_loan/my_loan_ctrl.dart';
import 'package:sampleflutterproject/styles/app_assets.dart';
import 'package:sampleflutterproject/styles/app_colors.dart';
import 'package:sampleflutterproject/styles/app_themes.dart';
import 'package:get/get.dart';
import 'package:sampleflutterproject/widget/common_container.dart';
import 'package:sampleflutterproject/widget/custom_button.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';

class MyLoan extends StatelessWidget {
  final ctrl = Get.put(MyLoanCtrl());

  MyLoan({Key? key}) : super(key: key);

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
      appBar: AppBar(
        elevation: 16.0,
        shadowColor: Colors.black.withOpacity(0.2),
        backgroundColor: Colors.white,
        toolbarHeight: 60.0,
        leadingWidth: 60.0,
        centerTitle: true,
        leading: const SizedBox(),
        title: Text(
          "my_loan".tr,
          textAlign: TextAlign.center,
          style: themes.light.textTheme.headlineMedium?.copyWith(
            fontSize: 19.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ctrl.getAllMyLoan();
        },
        child: Obx(() {
          return ctrl.isLoading.value
              ? const Center(
                  child: CupertinoActivityIndicator(
                    color: AppColors.getPrimary,
                  ),
                )
              : ctrl.myLoanList.isNotEmpty
                  ? Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                              physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics(),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 20.0),
                              itemCount: ctrl.myLoanList.length,
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
                                          () => LoanDetails(),
                                          arguments: ctrl.myLoanList[index].id,
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
                                                "sampleflutterproject".tr,
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
                                                "${ctrl.myLoanList[index].getBorrowAmount} TZS",
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
                                                ctrl.myLoanList[index].tenure ==
                                                        0
                                                    ? "--"
                                                    : "${ctrl.myLoanList[index].tenure} ${"months".tr}",
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
                                                ctrl.myLoanList[index]
                                                            .intrestRate ==
                                                        0.0
                                                    ? "--"
                                                    : "${ctrl.myLoanList[index].intrestRate} %",
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
                                                  primaryColor: ctrl
                                                      .myLoanList[index]
                                                      .getStatusColor,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 0.0,
                                                      horizontal: 12),
                                                  text: ctrl.myLoanList[index]
                                                      .getStatus,
                                                  color: Colors.white,
                                                  fontSize: 11.0,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.0),
                                                  onPressed: () {},
                                                ),
                                              ),
                                              /*Text(
                                  "5w372hd73".toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: themes.light.textTheme.headlineSmall
                                      ?.copyWith(
                                    color: const Color(0xFF8B8B8B),
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),*/
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
                        ),
                        const SizedBox(height: 80.0),
                      ],
                    )
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      child: SizedBox(
                        height: context.height * 0.7,
                        child: Center(
                          child: Text(
                            "no_loan_found".tr,
                            textAlign: TextAlign.center,
                            style:
                                themes.light.textTheme.headlineSmall?.copyWith(
                              color: const Color(0xFF8B8B8B),
                              fontSize: 15.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    );
        }),
      ),
    );
  }
}
