import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sampleflutterproject/module/sponsored_loans/approved_loan/approved_loan.dart';
import 'package:sampleflutterproject/module/sponsored_loans/pending_loan/pending_loan.dart';
import 'package:sampleflutterproject/styles/app_colors.dart';
import 'package:sampleflutterproject/styles/app_themes.dart';
import 'package:get/get.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';

class SponsoredLoans extends StatefulWidget {
  const SponsoredLoans({Key? key}) : super(key: key);

  @override
  State<SponsoredLoans> createState() => _SponsoredLoansState();
}

class _SponsoredLoansState extends State<SponsoredLoans>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

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
          "sponsored_loans_".tr,
          textAlign: TextAlign.center,
          style: themes.light.textTheme.headlineMedium?.copyWith(
            fontSize: 19.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: Container(
              height: 55,
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(
                  12.0,
                ),
              ),
              child: TabBar(
                controller: tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    12.0,
                  ),
                  color: AppColors.darkBlue,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.signUpLabelFontColor,
                tabs: [
                  Tab(text: 'pending'.tr),
                  Tab(text: 'approved'.tr),
                ],
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: tabController,
                children: const [
                  PendingLoan(),
                  ApprovedLoan(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
