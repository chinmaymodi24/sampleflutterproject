import 'package:admin/module/user/user_ctrl.dart';
import 'package:admin/module/user/user_statement/user_statement.dart';
import 'package:admin/styles/app_assets.dart';
import 'package:admin/utils/app_toast.dart';
import 'package:admin/widget/common_container.dart';
import 'package:core/api_routes/api_routes.dart';
import 'package:core/model/user_model.dart';
import 'package:core/widget/custom_button.dart';
import 'package:core/widget/custom_filled_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:core/styles/app_colors.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'dart:html' as html;

class User extends StatelessWidget {
  User({Key? key}) : super(key: key);

  final ctrl = Get.put(UserCtrl());

  final TextStyle style = GoogleFonts.poppins(
    color: AppColors.lightTextColor,
    fontWeight: FontWeight.w500,
    fontSize: 12.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.adminBackgroundColor,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: SizedBox(
                    width: 400.0,
                    child: FilledTextField(
                      filledColor: Colors.white,
                      hint: "search".tr,
                      style: GoogleFonts.poppins(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: AppColors.lightTextColor.withOpacity(0.5),
                      ),
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: AppColors.lightTextColor.withOpacity(0.5),
                      ),
                      preFixIcon: Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, left: 14.0, right: 10.0, bottom: 10.0),
                        child: Image.asset(
                          AppAssets.userUserSearch,
                          width: 20.0,
                          height: 20.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      contentPadding: const EdgeInsets.only(
                          top: 14.0, left: 20.0, right: 20.0, bottom: 0.0),
                      //controller: ctrlEmail,
                      validator: (value) {
                        // if (value!.trim().isEmpty) {
                        //   return "Please enter a value";
                        // }
                        // return null;
                      },
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.text,
                      maxLength: 60,
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 12.0,
                    ),
                    child: Text(
                      "filter_by".tr,
                      style: GoogleFonts.poppins(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: AppColors.lightTextColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Obx(() {
              ctrl.userList();
              ctrl.userList.refresh();
              return Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: DataTable2(
                      columnSpacing: 12,
                      horizontalMargin: 12,
                      dividerThickness: 1,
                      // this one will be ignored if [border] is set above
                      bottomMargin: 10,
                      minWidth: 900,
                      border: TableBorder(
                        bottom: BorderSide(color: Colors.grey[300]!),
                      ),
                      sortArrowIcon: Icons.keyboard_arrow_up,
                      // custom arrow
                      sortArrowAnimationDuration:
                          const Duration(milliseconds: 500),
                      // custom animation duration
                      columns: [
                        DataColumn2(
                          label: Text(
                            '#',
                            style: style,
                          ),
                          size: ColumnSize.S,
                          fixedWidth: 30,
                        ),
                        DataColumn2(
                          label: Text(
                            'borrower_name'.tr,
                            style: style,
                          ),
                          fixedWidth: 136,
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: SizedBox(
                            width: 120.0,
                            child: Wrap(children: [
                              Text(
                                'account_number'.tr,
                                style: style,
                              ),
                            ]),
                          ),
                          fixedWidth: 90,
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text(
                            textAlign: TextAlign.start,
                            'email'.tr,
                            style: style,
                          ),
                          fixedWidth: 190,
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text(
                            'phone_number'.tr,
                            style: style,
                          ),
                          fixedWidth: 140,
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text(
                            'borrowed_nmoney'.tr,
                            textAlign: TextAlign.center,
                            style: style,
                          ),
                          fixedWidth: 130,
                          size: ColumnSize.S,
                        ),
                        /*DataColumn2(
                        label: Text(
                          'Sponsored \nMoney',
                          textAlign: TextAlign.center,
                          style: style,
                        ),
                        //fixedWidth: 130,
                        size: ColumnSize.S,
                      ),*/
                        DataColumn2(
                          label: Text(
                            'eligible_namount'.tr,
                            textAlign: TextAlign.center,
                            style: style,
                          ),
                          fixedWidth: 130,
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text(
                            'type'.tr,
                            style: style,
                          ),
                          fixedWidth: 100,
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text(
                            'profile_status'.tr,
                            style: style,
                          ),
                          fixedWidth: 120,
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text(
                            'action'.tr,
                            style: style,
                          ),
                          fixedWidth: 100,
                          size: ColumnSize.S,
                        ),
                      ],
                      empty: Center(
                          child: Container(
                              padding: const EdgeInsets.all(20),
                              color: Colors.grey[200],
                              child: Text('no_data'.tr))),
                      rows: ctrl.userList
                          .asMap()
                          .entries
                          .map(
                            (e) => DataRow(
                              cells: [
                                /// FOR DATE AND TIME
                                DataCell(
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Text(
                                      '${e.key + 1}',
                                      textAlign: TextAlign.end,
                                      style: style,
                                    ),
                                  ),
                                ),
                                DataCell(Text(
                                  e.value.fullName,
                                  style: style,
                                  textAlign: TextAlign.start,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )),
                                DataCell(Text(
                                  e.value.accNumber.toString(),
                                  style: style,
                                  textAlign: TextAlign.start,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )),
                                DataCell(Text(
                                  e.value.email,
                                  style: style,
                                  textAlign: TextAlign.start,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )),
                                DataCell(Text(
                                  e.value.phno.toString(),
                                  style: style,
                                  textAlign: TextAlign.start,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )),
                                DataCell(
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      e.value.getBorrowedAmt,
                                      //"",
                                      style: style,
                                      textAlign: TextAlign.start,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                /*DataCell(Text(
                                e.sponsoredMoney,
                                style: style,
                                textAlign: TextAlign.start,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              )),*/
                                DataCell(Text(
                                  "${e.value.getEligibleAmount} TZS",
                                  // "3,200 TZS",
                                  style: style,
                                  textAlign: TextAlign.start,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )),
                                DataCell(Text(
                                  e.value.isSponsor == 0
                                      ? "borrower".tr
                                      : "sponsor".tr,
                                  style: style,
                                  textAlign: TextAlign.start,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )),
                                DataCell(
                                  SizedBox(
                                    width: 80.0,
                                    child: Obx(() {
                                      ctrl.userList();
                                      return CustomButton(
                                        text: e.value.verificationStatus == 1
                                            ? "approved".tr
                                            : e.value.verificationStatus == 0
                                                ? "pending".tr
                                                : "rejected".tr,
                                        //color: AppColors.adminProfileStatusFontColor,
                                        color: AppColors.darkTextColor,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0, vertical: 4.0),
                                        fontSize: 9.0,
                                        borderRadius:
                                            BorderRadius.circular(40.0),
                                        primaryColor:
                                            e.value.verificationStatus == 0
                                                ? AppColors
                                                    .adminUserPendingBgColor
                                                : AppColors
                                                    .adminUserApprovedBgColor,
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
                                                    userModel: e.value,
                                                  ),
                                                );
                                              });
                                        },
                                      );
                                    }),
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Dialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            24.0),
                                                  ),
                                                  child: UserDetailsDialog(
                                                    userModel: e.value,
                                                  ),
                                                );
                                              });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFEEEEEE),
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                          ),
                                          child: Image.asset(
                                            AppAssets.userUserAction,
                                            width: 24.0,
                                            height: 24.0,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10.0),
                                      InkWell(
                                        onTap: () async {
                                          await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Dialog(
                                                  child: _confirmDeleteAccount(
                                                      context, e.value.id),
                                                );
                                              });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFEEEEEE),
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                          ),
                                          child: Image.asset(
                                            AppAssets.userUserDelete,
                                            width: 24.0,
                                            height: 24.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  /*Text(
                                  e.type,
                                  style: style,
                                  textAlign: TextAlign.start,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),*/
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _confirmDeleteAccount(BuildContext context, int userId) {
    return Container(
      width: context.width * 0.15,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
      padding: const EdgeInsets.only(
          top: 15.0, bottom: 5.0, left: 20.0, right: 10.0),
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
                "delete_account!".tr,
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
          /*const SizedBox(height: 18.0),
        Center(
          child: const Icon(
            Icons.delete_forever_rounded,
            color: Color(0xFFDF5B5B),
            size: 40.0,
          ),
        ),*/
          const SizedBox(height: 18.0),
          Text(
            "confirm_delete_account".tr,
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
                  var res = await ctrl.statusUpdate(
                    userId: userId,
                    accStatus: 0,
                    isSponsor: null,
                    amount: null,
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
    );
  }
}

class UserGiveApprovalDialog extends StatelessWidget {
  final UserModel userModel;
  final userCtrl = Get.put(UserCtrl());

  UserGiveApprovalDialog({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  RxBool isLoading = false.obs;

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
                  "user_detail".tr,
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
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 30.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "photo".tr,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13.0,
                              color: Color(0xFFB3B3B3),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 23.0),
                          InkWell(
                            onTap: () {
                              html.window.open(
                                  "${ApiRoutes.baseProfileUrl}${userModel.profileImg}",
                                  "_blank");
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(19.0),
                              child: SizedBox(
                                height: 193,
                                width: 193,
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "${ApiRoutes.baseProfileUrl}${userModel.profileImg}",
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
                          ),
                          const SizedBox(height: 12.0),
                          Text(
                            userModel.fullName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                              fontFamily: "SegoeUI-Bold",
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          Text(
                            userModel.natIdNo,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13.0,
                              color: Color(0xFFA7A7A7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          const Divider(
                            height: 1,
                            color: Color(0xFFC4C4C4),
                            thickness: 1.0,
                          ),
                          const SizedBox(height: 12.0),
                          Text(
                            "phone_number".tr,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13.0,
                              color: Color(0xFFB3B3B3),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            "+${userModel.cc} ${userModel.phno}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontFamily: "SegoeUI-Bold",
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: Divider(
                              height: 1,
                              color: Color(0xFFC4C4C4),
                              thickness: 1.0,
                            ),
                          ),
                          Text(
                            "email:".tr,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13.0,
                              color: Color(0xFFB3B3B3),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            userModel.email,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontFamily: "SegoeUI-Bold",
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: Divider(
                              height: 1,
                              color: Color(0xFFC4C4C4),
                              thickness: 1.0,
                            ),
                          ),
                          Text(
                            "date_of_birth".tr,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13.0,
                              color: Color(0xFFB3B3B3),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            DateFormat('dd MMM yyyy').format(userModel.dob),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontFamily: "SegoeUI-Bold",
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: Divider(
                              height: 1,
                              color: Color(0xFFC4C4C4),
                              thickness: 1.0,
                            ),
                          ),
                          Text(
                            "address:".tr,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13.0,
                              color: Color(0xFFB3B3B3),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            userModel.address,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontFamily: "SegoeUI-Bold",
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: Divider(
                              height: 1,
                              color: Color(0xFFC4C4C4),
                              thickness: 1.0,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                        ],
                      ),
                    ),
                  ),
                  const VerticalDivider(
                    width: 1,
                    thickness: 1.0,
                    color: AppColors.adminDividerColor,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "id_proof:".tr,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13.0,
                              color: Color(0xFFB3B3B3),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: SizedBox(
                              width: 171.0,
                              height: 106.0,
                              child: CachedNetworkImage(
                                imageUrl:
                                    "${ApiRoutes.baseNationalIdUrl}${userModel.natIdFront}",
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
                          const SizedBox(height: 10.0),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: SizedBox(
                              width: 171.0,
                              height: 106.0,
                              child: CachedNetworkImage(
                                imageUrl:
                                    "${ApiRoutes.baseNationalIdUrl}${userModel.natIdBack}",
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
                          const SizedBox(height: 10.0),
                          const Divider(
                            height: 1.0,
                            thickness: 1.0,
                            color: AppColors.adminDividerColor,
                          ),
                          const SizedBox(height: 12.0),
                          Text(
                            "governor_letter:".tr,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13.0,
                              color: Color(0xFFB3B3B3),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          userModel.govLater.isNotEmpty
                              ? InkWell(
                            onTap: () {
                              html.window.open(
                                  "${ApiRoutes.baseGovLaterUrl}${userModel.govLater}",
                                  "_blank");
                            },
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: SizedBox(
                                      width: 171.0,
                                      height: 238.0,
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "${ApiRoutes.baseGovLaterUrl}${userModel.govLater}",
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
                              )
                              : Padding(
                                  padding: const EdgeInsets.only(top: 18.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                      "letter_is_not_added".tr,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                        color: Color(0xFFB3B3B3),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                          const SizedBox(height: 10.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Divider(
                height: 1,
                thickness: 1.0,
                color: AppColors.adminDividerColor,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Obx(() {
                    return CustomButton(
                      text: "approve".tr,
                      isLoading: isLoading.value,
                      primaryColor: const Color(0xFF57A51B),
                      onPressed: () async {
                        isLoading.value = true;
                        await userCtrl.giveKycStatus(
                          userId: userModel.id,
                          rejectReason: "",
                          verificationStatus: 1,
                        );
                        isLoading.value = false;
                        Get.back();
                      },
                    );
                  }),
                ),
                const SizedBox(width: 15.0),
                Expanded(
                  child: CustomButton(
                    text: "reject".tr,
                    primaryColor: const Color(0xFF9B6363),
                    onPressed: () async {
                      Get.back();
                      await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              child: RejectReason(
                                userModel: userModel,
                              ),
                            );
                          });
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

class UserDetailsDialog extends StatelessWidget {
  final UserModel userModel;
  final userCtrl = Get.put(UserCtrl());
  RxBool isLoading = false.obs;
  RxBool blockIsLoading = false.obs;
  RxBool makeSponsorIsLoading = false.obs;

  TextEditingController ctrlEligibleAmount = TextEditingController();

  UserDetailsDialog({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  init() {
    if (userModel.eligibleAmount != 0) {
      ctrlEligibleAmount.text = "${userModel.eligibleAmount}";
    } else {
      ctrlEligibleAmount.text = "2000";
    }
  }

  @override
  Widget build(BuildContext context) {
    init();

    return CommonContainer(
      width: 563.0,
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
                  "user_detail".tr,
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
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 30.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "photo".tr,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13.0,
                              color: Color(0xFFB3B3B3),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 23.0),
                          InkWell(
                            onTap: () {
                              html.window.open(
                                  "${ApiRoutes.baseProfileUrl}${userModel.profileImg}",
                                  "_blank");
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(19.0),
                              child: SizedBox(
                                height: 193,
                                width: 193,
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "${ApiRoutes.baseProfileUrl}${userModel.profileImg}",
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
                          ),
                          const SizedBox(height: 12.0),
                          Text(
                            userModel.fullName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                              fontFamily: "SegoeUI-Bold",
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          Text(
                            userModel.natIdNo,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13.0,
                              color: Color(0xFFA7A7A7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          const Divider(
                            height: 1,
                            color: Color(0xFFC4C4C4),
                            thickness: 1.0,
                          ),
                          const SizedBox(height: 12.0),
                          Text(
                            "phone_number:".tr,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13.0,
                              color: Color(0xFFB3B3B3),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            "+${userModel.cc} ${userModel.phno}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontFamily: "SegoeUI-Bold",
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: Divider(
                              height: 1,
                              color: Color(0xFFC4C4C4),
                              thickness: 1.0,
                            ),
                          ),
                          Text(
                            "email:".tr,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13.0,
                              color: Color(0xFFB3B3B3),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            userModel.email,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontFamily: "SegoeUI-Bold",
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: Divider(
                              height: 1,
                              color: Color(0xFFC4C4C4),
                              thickness: 1.0,
                            ),
                          ),
                          Text(
                            "date_of_birth:".tr,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13.0,
                              color: Color(0xFFB3B3B3),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            DateFormat('dd MMM yyyy').format(userModel.dob),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontFamily: "SegoeUI-Bold",
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: Divider(
                              height: 1,
                              color: Color(0xFFC4C4C4),
                              thickness: 1.0,
                            ),
                          ),
                          Text(
                            "address:".tr,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13.0,
                              color: Color(0xFFB3B3B3),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            userModel.address,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontFamily: "SegoeUI-Bold",
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: Divider(
                              height: 1,
                              color: Color(0xFFC4C4C4),
                              thickness: 1.0,
                            ),
                          ),
                          Text(
                            "eligible_amount_".tr,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13.0,
                              color: Color(0xFFB3B3B3),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Container(
                            width: 150.0,
                            height: 44.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: AppColors
                                  .adminUserStatementEligibleAmountBgColor,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 90.0,
                                  height: 40.0,
                                  child: FilledTextField(
                                    autoFocus: true,
                                    //maxLength: 4,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    contentPadding: const EdgeInsets.only(
                                      top: 5.0,
                                      left: 8.0,
                                      bottom: 0.0,
                                    ),
                                    filledColor: Colors.transparent,
                                    style: GoogleFonts.inter(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.lightTextColor,
                                    ),
                                    controller: ctrlEligibleAmount,
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 10,
                                      ),
                                      child: Text(
                                        "TZS",
                                        style: GoogleFonts.inter(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.lightTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                /*Text(
                                  "2,000 TZS",
                                  style: GoogleFonts.inter(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.lightTextColor,
                                  ),
                                ),*/
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
                          const SizedBox(height: 10.0),
                          SizedBox(
                            width: 90,
                            height: 40,
                            child: Obx(() {
                              return CustomButton(
                                isLoading: isLoading.value,
                                textAlign: TextAlign.center,
                                text: "submit".tr,
                                fontSize: 14.0,
                                onPressed: () async {
                                  if (ctrlEligibleAmount.text.trim().isEmpty) {
                                    AppToast.msg(
                                        "please_enter_eligible_amount".tr);
                                  } else {
                                    isLoading.value = true;

                                    await userCtrl.statusUpdate(
                                      userId: userModel.id,
                                      accStatus: userModel.accStatus,
                                      isSponsor: null,
                                      amount: int.parse(ctrlEligibleAmount.text
                                          .trim()
                                          .toString()),
                                    );

                                    isLoading.value = false;
                                    Get.back();
                                  }
                                },
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const VerticalDivider(
                    width: 1,
                    thickness: 1.0,
                    color: AppColors.adminDividerColor,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "id_proof:".tr,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13.0,
                              color: Color(0xFFB3B3B3),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          InkWell(
                            onTap: () {
                              html.window.open(
                                  "${ApiRoutes.baseNationalIdUrl}${userModel.natIdFront}",
                                  "_blank");
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: SizedBox(
                                width: 171.0,
                                height: 106.0,
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "${ApiRoutes.baseNationalIdUrl}${userModel.natIdFront}",
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
                          ),
                          const SizedBox(height: 10.0),
                          InkWell(
                            onTap: () {
                              html.window.open(
                                  "${ApiRoutes.baseNationalIdUrl}${userModel.natIdFront}",
                                  "_blank");
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: SizedBox(
                                width: 171.0,
                                height: 106.0,
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "${ApiRoutes.baseNationalIdUrl}${userModel.natIdBack}",
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
                          ),
                          const SizedBox(height: 10.0),
                          const Divider(
                            height: 1.0,
                            thickness: 1.0,
                            color: AppColors.adminDividerColor,
                          ),
                          const SizedBox(height: 12.0),
                          Text(
                            "governor_letter:".tr,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13.0,
                              color: Color(0xFFB3B3B3),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          userModel.govLater.isNotEmpty
                              ? InkWell(
                            onTap: () {
                              html.window.open(
                                  "${ApiRoutes.baseGovLaterUrl}${userModel.govLater}",
                                  "_blank");
                            },
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: SizedBox(
                                      width: 171.0,
                                      height: 238.0,
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "${ApiRoutes.baseGovLaterUrl}${userModel.govLater}",
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
                              )
                              : Padding(
                                  padding: const EdgeInsets.only(top: 18.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                      "letter_is_not_added".tr,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                        color: Color(0xFFB3B3B3),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                          const SizedBox(height: 10.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Divider(
                height: 1,
                thickness: 1.0,
                color: AppColors.adminDividerColor,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Obx(() {
                    return CustomButton(
                      text: userModel.accStatus == 1
                          ? "block_user".tr
                          : "unblock_user".tr,
                      isLoading: blockIsLoading.value,
                      primaryColor: const Color(0xFFD64949),
                      onPressed: () async {
                        blockIsLoading.value = true;

                        if (userModel.accStatus == 1) {
                          await userCtrl.statusUpdate(
                            userId: userModel.id,
                            accStatus: -1,
                            isSponsor: null,
                            amount: null,
                          );
                        } else {
                          await userCtrl.statusUpdate(
                            userId: userModel.id,
                            accStatus: 1,
                            isSponsor: null,
                            amount: null,
                          );
                        }

                        blockIsLoading.value = false;
                        Get.back();
                      },
                    );
                  }),
                ),
                const SizedBox(width: 15.0),
                Expanded(
                  child: CustomButton(
                    text: "view_statements".tr,
                    fontSize: 15.0,
                    primaryColor: AppColors.getPrimary,
                    onPressed: () {
                      Get.back();
                      Get.to(
                        () => UserStatement(),
                        arguments: userModel.id,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 15.0),
                Expanded(
                  child: Obx(() {
                    return CustomButton(
                      text: userModel.isSponsor == 0
                          ? "make_sponsor".tr
                          : "make_unsponsor".tr,
                      isLoading: makeSponsorIsLoading.value,
                      primaryColor: AppColors.getPrimary,
                      onPressed: () async {
                        makeSponsorIsLoading.value = true;

                        if (userModel.isSponsor == 0) {
                          await userCtrl.statusUpdate(
                            userId: userModel.id,
                            accStatus: null,
                            isSponsor: 1,
                            amount: null,
                          );
                        } else {
                          await userCtrl.statusUpdate(
                            userId: userModel.id,
                            accStatus: null,
                            isSponsor: 0,
                            amount: null,
                          );
                        }

                        makeSponsorIsLoading.value = false;
                        Get.back();
                      },
                    );
                  }),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class RejectReason extends StatelessWidget {
  final userCtrl = Get.put(UserCtrl());

  UserModel userModel;

  RxBool isLoading = false.obs;

  RejectReason({
    Key? key,
    required this.userModel,
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
                  "reject_reason".tr,
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
              hint: "enter_rejection_reason".tr,
              borderRadius: BorderRadius.circular(10.0),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              minLine: 6,
              maxLine: 6,
              controller: userCtrl.ctrlReason,
              hintStyle: const TextStyle(
                  fontSize: 16.0,
                  color: Color(0xFF8A8A8A),
                  fontWeight: FontWeight.w600),
              style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
              textInputType: TextInputType.text,
              filledColor: const Color(0xFFF6F6F6),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: Obx(() {
                    return CustomButton(
                      text: "reject".tr,
                      isLoading: isLoading.value,
                      primaryColor: const Color(0xFFEE6E6E),
                      onPressed: () async {
                        if (userCtrl.ctrlReason.text.trim().isNotEmpty) {
                          isLoading.value = true;
                          await userCtrl.giveKycStatus(
                            userId: userModel.id,
                            rejectReason: userCtrl.ctrlReason.text.trim(),
                            verificationStatus: -1,
                          );
                          isLoading.value = false;
                          Get.back();
                        } else {
                          AppToast.msg("please_enter_rejection_reason".tr);
                        }
                      },
                    );
                  }),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
