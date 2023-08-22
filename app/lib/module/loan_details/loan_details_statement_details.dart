import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sampleflutterproject/module/loan_details/loan_details_ctrl.dart';
import 'package:sampleflutterproject/styles/app_colors.dart';
import 'package:sampleflutterproject/widget/custom_appbar.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class StatementDetails extends StatefulWidget {
  const StatementDetails({Key? key}) : super(key: key);

  @override
  State<StatementDetails> createState() => _StatementDetailsState();
}

class _StatementDetailsState extends State<StatementDetails> {
  final ctrl = Get.find<LoanDetailsCtrl>();

  @override
  void initState() {
    //WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
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
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 70.0),
          child: CustomAppBarWithBack(
            title: "loan_statements".tr,
            actions: [],
            onTap: () async {
              Get.back();
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitDown,
                DeviceOrientation.portraitUp
              ]);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 0.0,left: 18.0, right: 18.0, bottom: 25.0),
          child: Container(
            width: double.infinity,
            //color: Colors.white,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics()
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 84.0,
                    decoration: BoxDecoration(
                      color: AppColors.getPrimary.withOpacity(0.1),
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
                                  .format(ctrl.myLoanDetailModel.value.createdAt)
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
                              "${ctrl.myLoanDetailModel.value.borrowAmount} TZS",
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
                              //"${ctrl.myLoanDetailModel.value.details[index].} months",
                              "${ctrl.myLoanDetailModel.value.tenure} ${"months"
                                  .tr}",
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
                              ctrl.myLoanDetailModel.value.intrestRate ==
                                  0.0
                                  ? "-"
                                  : "${ctrl.myLoanDetailModel.value
                                  .intrestRate} %",
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
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
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.black,
                    ),
                  ),
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    shrinkWrap: true,
                    itemCount: ctrl.myLoanDetailModel.value.loanStatement
                        .length,
                    itemBuilder: (BuildContext context, int subIndex) {
                      return SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                // DateFormat('dd-MM-yyyy')
                                //     .format(ctrl.myLoanDetailModel.value
                                //     .loanStatement[subIndex].date)
                                //     .toString(),
                                DateFormat('dd-MM-yyyy')
                                    .format(ctrl.myLoanDetailModel.value
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
                                "${(ctrl.myLoanDetailModel.value
                                    .loanStatement[subIndex]
                                    .getPrincipleAmt)} TZS",
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
                                      "${(ctrl.myLoanDetailModel.value
                                          .loanStatement[subIndex]
                                          .getInterest)} TZS",
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
                                      "${(ctrl.myLoanDetailModel.value
                                          .loanStatement[subIndex]
                                          .getPayment)} TZS",
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
                                alignment: WrapAlignment.end,
                                children: [
                                  Text(
                                    "${(ctrl.myLoanDetailModel.value
                                        .loanStatement[subIndex]
                                        .getOutstandingAmt)} TZS",
                                    style: GoogleFonts.inter(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.lightTextColor,
                                    ),
                                  ),
                                ],
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
                          color: AppColors.dividerColor,
                          thickness: 0.6,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                          ctrl.myLoanDetailModel.value
                              .getStatus,
                          textAlign: TextAlign.end,
                          style: GoogleFonts.inter(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              //color: ctrl.myLoanDetailModel.value.details[index].getStatusColor,
                              color: ctrl.myLoanDetailModel.value.getStatusColor
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
