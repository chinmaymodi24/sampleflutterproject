import 'package:admin/module/reports/reports_ctrl.dart';
import 'package:admin/utils/app_toast.dart';
import 'package:core/styles/app_colors.dart';
import 'package:core/widget/custom_button.dart';
import 'package:core/widget/custom_filled_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Reports extends StatelessWidget {
  final ctrl = Get.put(ReportsCtrl());

  Reports({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.adminBackgroundColor,
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top : 50.0),
          child: Container(
            width: 400.0,
            height: 300.0,
            padding: const EdgeInsets.symmetric(horizontal: 20.0,),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: FilledTextField(
                        onTap: () async {
                          DateTime? dateTime = await ctrl.selectStartDate(context);

                          if (dateTime != null) {
                            ctrl.ctrlStartDate.text = DateFormat('dd/MM/yyyy')
                                .format(dateTime)
                                .toString();
                          }
                        },
                        readOnly: true,
                        outlineInputBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.grey.withOpacity(0.50))),
                        filledColor: Colors.grey.withOpacity(0.10),
                        hint: "Start Date",
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w700,
                          color: AppColors.lightTextColor,
                        ),
                        hintStyle: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                          color: AppColors.lightTextColor.withOpacity(0.5),
                        ),
                        suffixIcon: const Icon(
                          Icons.date_range,
                          color: AppColors.getPrimary,
                          size: 20.0,
                        ),
                        contentPadding: const EdgeInsets.only(
                            top: 14.0, left: 20.0, right: 20.0, bottom: 0.0),
                        controller: ctrl.ctrlStartDate,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return "Please select start date";
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.done,
                        textInputType: TextInputType.text,
                        maxLength: 60,
                      ),
                    ),
                    const SizedBox(
                      width: 30.0,
                    ),
                    Expanded(
                      child: FilledTextField(
                        onTap: () async {
                          if (ctrl.ctrlStartDate.text.isEmpty) {
                            AppToast.msg("Please select start date first");
                          } else {
                            DateTime? dateTime = await ctrl.selectEndDate(context);

                            if (dateTime != null) {
                              ctrl.ctrlEndDate.text = DateFormat('dd/MM/yyyy')
                                  .format(dateTime)
                                  .toString();
                            }
                          }
                        },
                        readOnly: true,
                        outlineInputBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.grey.withOpacity(0.50))),
                        filledColor: Colors.grey.withOpacity(0.10),
                        hint: "End Date",
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w700,
                          color: AppColors.lightTextColor,
                        ),
                        hintStyle: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                          color: AppColors.lightTextColor.withOpacity(0.5),
                        ),
                        suffixIcon: const Icon(
                          Icons.date_range,
                          color: AppColors.getPrimary,
                          size: 20.0,
                        ),
                        contentPadding: const EdgeInsets.only(
                            top: 14.0, left: 20.0, right: 20.0, bottom: 0.0),
                        controller: ctrl.ctrlEndDate,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return "Please select end date";
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.done,
                        textInputType: TextInputType.text,
                        maxLength: 60,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Obx(() {
                  return CustomButton(
                    text: "Export New Users",
                    isLoading: ctrl.isUserButtonLoading.value,
                    onPressed: () async {
                      if (ctrl.ctrlStartDate.text.isEmpty) {
                        AppToast.msg("Please select start date");
                      } else if (ctrl.ctrlEndDate.text.isEmpty) {
                        AppToast.msg("Please select end date");
                      } else {
                        ctrl.isUserButtonLoading.value = true;
                        await ctrl.getNewUserList();
                        ctrl.ctrlStartDate.clear();
                        ctrl.ctrlEndDate.clear();
                        ctrl.isUserButtonLoading.value = false;
                      }
                    },
                  );
                }),
                const SizedBox(height: 20.0),
                Obx(() {
                  return CustomButton(
                    text: "Export Loans has taken",
                    isLoading: ctrl.isLoanButtonLoading.value,
                    onPressed: () async {
                      if (ctrl.ctrlStartDate.text.isEmpty) {
                        AppToast.msg("Please select start date");
                      } else if (ctrl.ctrlEndDate.text.isEmpty) {
                        AppToast.msg("Please select end date");
                      } else {
                        ctrl.isLoanButtonLoading.value = true;
                        await ctrl.getNewLoanList();
                        ctrl.ctrlStartDate.clear();
                        ctrl.ctrlEndDate.clear();
                        ctrl.isLoanButtonLoading.value = false;
                      }
                    },
                  );
                }),
                /*const SizedBox(width: 50.0),
                    SizedBox(
                      width: 160.0,
                      child: CustomButton(
                        text: "Export Interest Received",
                        onPressed: () {},
                      ),
                    ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
