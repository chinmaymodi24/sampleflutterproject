import 'package:core/api_routes/api_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sampleflutterproject/app/app_repo.dart';
import 'package:sampleflutterproject/module/home/home_ctrl.dart';
import 'package:sampleflutterproject/module/loan_details/loan_details.dart';
import 'package:sampleflutterproject/module/my_loan/my_loan_ctrl.dart';
import 'package:sampleflutterproject/module/navigation/navigation_page_ctrl.dart';
import 'package:sampleflutterproject/module/notification/notification.dart';
import 'package:sampleflutterproject/module/select_sponsers/select_sponsers.dart';
import 'package:sampleflutterproject/styles/app_assets.dart';
import 'package:sampleflutterproject/styles/app_colors.dart';
import 'package:sampleflutterproject/styles/app_themes.dart';
import 'package:get/get.dart';
import 'package:sampleflutterproject/utils/app_toast.dart';
import 'package:sampleflutterproject/widget/common_container.dart';
import 'package:sampleflutterproject/widget/custom_button.dart';
import 'package:sampleflutterproject/widget/custom_filled_textfield.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);
  final homeCtrl = Get.put(HomeCtrl());
  RxBool isLoading = false.obs;

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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 70.0,
        leadingWidth: 70.0,
        leading: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 20.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(30.0),
            onTap: () {
              final NavigationPageCtrl navigationCtrl =
                  Get.find<NavigationPageCtrl>();
              if (app.userModel.value.isSponsor == 1) {
                navigationCtrl.selectedScreen.value = 4;
              } else {
                navigationCtrl.selectedScreen.value = 3;
              }
            },
            child: ClipOval(
              child: SizedBox(
                height: 35,
                width: 35,
                child: CachedNetworkImage(
                  imageUrl:
                      "${ApiRoutes.baseProfileUrl}${app.userModel.value.profileImg}",
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CupertinoActivityIndicator(
                      color: AppColors.getPrimary,
                    ),
                  ),
                  errorWidget: (context, url, error) => const CircleAvatar(
                    radius: 36,
                    child: Icon(Icons.error),
                  ),
                ),
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0, right: 18.0),
            child: IconButton(
              splashRadius: 20.0,
              onPressed: () {
                Get.to(() => NotificationScreen());
              },
              icon: Image.asset(
                AppAssets.homeNotification,
                width: 24.0,
                height: 26.0,
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          homeCtrl.isLoading.value = true;
          //await app.navigate();
          await homeCtrl.homeNavigate();
          await homeCtrl.init();
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Obx(() {
            return homeCtrl.isLoading.value
                ? Center(
                    child: SizedBox(
                      height: context.height * 0.75,
                      child: const CupertinoActivityIndicator(),
                    ),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "hello".tr,
                              textAlign: TextAlign.center,
                              style: themes.light.textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              app.userModel.value.fullName,
                              textAlign: TextAlign.center,
                              style: themes.light.textTheme.headlineSmall
                                  ?.copyWith(
                                fontSize: 17.0,
                                fontFamily: "SegoeUI-Bold",
                                color: const Color(0xFF1E3E74),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 15.0),
                            CommonContainer(
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "eligible_amount_to_be_borrowed_without_sponsor".tr,
                                    textAlign: TextAlign.start,
                                    style: themes.light.textTheme.headlineSmall
                                        ?.copyWith(
                                      fontSize: 14.0,
                                      color: AppColors.homeLabelGreyFontColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    "${homeCtrl.homeDetailModel.value.getElgAmt} TZS",
                                    textAlign: TextAlign.center,
                                    style: themes.light.textTheme.headlineSmall
                                        ?.copyWith(
                                      fontSize: 16.0,
                                      color: const Color(0xFFBFAC48),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15.0),
                            CommonContainer(
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "total_taken_loan_amount".tr,
                                      textAlign: TextAlign.center,
                                      style: themes
                                          .light.textTheme.headlineSmall
                                          ?.copyWith(
                                        fontSize: 14.0,
                                        color: AppColors.homeLabelGreyFontColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 5.0),
                                    Text(
                                      "${homeCtrl.homeDetailModel.value.getTakenLoanAmt} TZS",
                                      textAlign: TextAlign.center,
                                      style: themes
                                          .light.textTheme.headlineSmall
                                          ?.copyWith(
                                        fontSize: 16.0,
                                        color: const Color(0xFF62BA7A),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                )),
                            const SizedBox(height: 15.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: CommonContainer(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "total_taken_loan".tr,
                                        textAlign: TextAlign.start,
                                        style: themes
                                            .light.textTheme.headlineSmall
                                            ?.copyWith(
                                          fontSize: 14.0,
                                          color:
                                              AppColors.homeLabelGreyFontColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 5.0),
                                      Text(
                                        "${homeCtrl.homeDetailModel.value.takenLoanCount}",
                                        textAlign: TextAlign.start,
                                        style: themes
                                            .light.textTheme.headlineSmall
                                            ?.copyWith(
                                          fontSize: 16.0,
                                          color: const Color(0xFFC84848),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  )),
                                ),
                                const SizedBox(width: 15.0),
                                Expanded(
                                  child: CommonContainer(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "closed_loan".tr,
                                        textAlign: TextAlign.start,
                                        style: themes
                                            .light.textTheme.headlineSmall
                                            ?.copyWith(
                                          fontSize: 14.0,
                                          color:
                                              AppColors.homeLabelGreyFontColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 5.0),
                                      Text(
                                        "${homeCtrl.homeDetailModel.value.closedLoanCount}",
                                        textAlign: TextAlign.start,
                                        style: themes
                                            .light.textTheme.headlineSmall
                                            ?.copyWith(
                                          fontSize: 16.0,
                                          color: AppColors.getPrimary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  )),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15.0),
                            Text(
                              "borrow_amount".tr,
                              textAlign: TextAlign.center,
                              style: themes.light.textTheme.headlineSmall
                                  ?.copyWith(
                                color: AppColors.homeLabelFontColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 15.0),
                            FilledTextField(
                              hint: "7,000 TZS",
                              controller: homeCtrl.ctrlBorrowAmount,
                              textInputAction: TextInputAction.done,
                              //maxLength: 10,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                                CustomInputFormatter(),
                              ],
                              textInputType: TextInputType.number,
                              borderRadius: BorderRadius.circular(13.0),
                            ),
                            const SizedBox(height: 15.0),
                            ElevatedButton(
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
                                if (homeCtrl.ctrlBorrowAmount.text
                                    .trim()
                                    .isEmpty) {
                                  AppToast.msg("please_enter_borrow_amount".tr);
                                } else {
                                  isLoading.value = true;

                                  var res = await homeCtrl.loanRequest(
                                    userId: app.userModel.value.id,
                                    borrowAmount: homeCtrl.ctrlBorrowAmount.text
                                        .replaceAll("TZS", "")
                                        .trim(),
                                    sponserIds: homeCtrl.sponsorIds.join(","),
                                  );

                                  if (res.isValid) {
                                    isLoading.value = false;
                                    homeCtrl.ctrlBorrowAmount.clear();

                                    final ctrl = Get.find<MyLoanCtrl>();

                                    ctrl.getAllMyLoan();

                                    showDialog(
                                      context: Get.context!,
                                      builder: (context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(24.0),
                                          ),
                                          child: LoanRequestedAlertDialog(
                                            subTitle:
                                                "request_loan_to_admin".tr,
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    if (res.m == "Required :sponser_ids") {
                                      isLoading.value = false;
                                      Get.to(
                                        () => SelectSponsers(),
                                      );
                                    } else {
                                      if (res.s == 0) {
                                        homeCtrl.ctrlBorrowAmount.clear();
                                        homeCtrl.sponsorIds.clear();
                                        isLoading.value = false;
                                      }
                                      isLoading.value = false;
                                      AppToast.msg(res.m);
                                    }
                                  }

                                  homeCtrl.sponsorIds.clear();

                                  isLoading.value = false;
                                }
                              },
                              child: Obx(() {
                                return !isLoading.value
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            "borrow_money".tr,
                                            style: const TextStyle(
                                              color:
                                                  AppColors.homeButtonFontColor,
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
                                    : const Center(
                                        child: SizedBox(
                                          child: CupertinoActivityIndicator(
                                            color: Colors.white,
                                            radius: 10.0,
                                          ),
                                        ),
                                      );
                              }),
                            ),
                            const SizedBox(height: 15.0),
                            Text(
                              "current_loans".tr,
                              textAlign: TextAlign.center,
                              style: themes.light.textTheme.headlineSmall
                                  ?.copyWith(
                                color: AppColors.homeLabelFontColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 15.0),
                          ],
                        ),
                      ),
                      MyRunningLoanList(homeCtrl: homeCtrl),
                      const SizedBox(height: 90.0),
                    ],
                  );
          }),
        ),
      ),
    );
  }
}

class MyRunningLoanList extends StatelessWidget {
  const MyRunningLoanList({
    super.key,
    required this.homeCtrl,
  });

  final HomeCtrl homeCtrl;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return homeCtrl.myLoanList.isNotEmpty
          ? ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
              shrinkWrap: true,
              itemCount: homeCtrl.myLoanList.length,
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
                          arguments: homeCtrl.myLoanList[index].id,
                        );
                      },
                      borderRadius: BorderRadius.circular(14.0),
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "sampleflutterproject".tr,
                                textAlign: TextAlign.center,
                                style: themes.light.textTheme.headlineSmall
                                    ?.copyWith(
                                  color: const Color(0xFF8B8B8B),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "${homeCtrl.myLoanList[index].getBorrowAmount} TZS",
                                textAlign: TextAlign.center,
                                style: themes.light.textTheme.headlineSmall
                                    ?.copyWith(
                                  fontSize: 17.0,
                                  color: AppColors.lightTextColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                homeCtrl.myLoanList[index].tenure == 0
                                    ? "--"
                                    : "${homeCtrl.myLoanList[index].tenure} ${"months".tr}",
                                textAlign: TextAlign.center,
                                style: themes.light.textTheme.headlineSmall
                                    ?.copyWith(
                                  fontSize: 16.0,
                                  color: index == 0
                                      ? Colors.black
                                      : AppColors.getPrimary,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                homeCtrl.myLoanList[index].intrestRate == 0.0
                                    ? "--"
                                    : "${homeCtrl.myLoanList[index].intrestRate} %",
                                textAlign: TextAlign.center,
                                style: themes.light.textTheme.headlineSmall
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 69.0,
                                height: 26.0,
                                child: CustomButton(
                                  primaryColor:
                                      homeCtrl.myLoanList[index].getStatusColor,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 0.0, horizontal: 4.0),
                                  text: homeCtrl.myLoanList[index].getStatus,
                                  color: Colors.white,
                                  fontSize: 11.0,
                                  borderRadius: BorderRadius.circular(18.0),
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
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox();
              })
          : SizedBox(
              height: context.height * 0.05,
              child: Center(
                child: Text(
                  "no_loan_found".tr,
                  textAlign: TextAlign.center,
                  style: themes.light.textTheme.headlineSmall?.copyWith(
                    color: const Color(0xFF8B8B8B),
                    fontSize: 15.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            );
    });
  }
}
