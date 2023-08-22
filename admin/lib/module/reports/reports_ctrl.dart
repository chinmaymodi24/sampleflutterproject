import 'package:core/model/new_loan_model.dart';
import 'package:core/model/user_model.dart';
import 'package:core/styles/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:core/backend/reports_service.dart';
import 'dart:convert';
import 'dart:html' as html;
import 'package:csv/csv.dart';

class ReportsCtrl extends GetxController {
  DateTime? startDate;
  DateTime? endDate;

  TextEditingController ctrlStartDate = TextEditingController();
  TextEditingController ctrlEndDate = TextEditingController();

  Future<DateTime?> selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: themes.light.colorScheme,
          ),
          child: child!,
        );
      },
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      startDate = picked;
      return picked;
    }
    return null;
  }

  Future<DateTime?> selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: themes.light.colorScheme,
          ),
          child: child!,
        );
      },
      initialDate: startDate!,
      firstDate: startDate!,
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      endDate = picked;
      return picked;
    }
    return null;
  }

  RxList<UserModel> newUserList = <UserModel>[].obs;
  RxList<NewLoanModel> newLoanList = <NewLoanModel>[].obs;

  RxBool isUserButtonLoading = false.obs;
  RxBool isLoanButtonLoading = false.obs;

  getNewUserList() async {
    try {
      var res = await ReportsService.getNewUsers({
        //2023-04-04
        "frm_date": DateFormat('yyyy-MM-dd').format(startDate!).toString(),
        "to_date": DateFormat('yyyy-MM-dd').format(endDate!).toString(),
        // "frm_date": "2023-01-01",
        // "to_date": "2023-05-10",
      });

      if (res.isValid) {
        if (res.r == null) return;
        newUserList.value = res.r!;
        exportNewUserListExcel();
      }
    } catch (e, t) {
      logger.e(e, 'Error');
      logger.e(t, 'Trace');
    }
  }

  getNewLoanList() async {
    try {
      var res = await ReportsService.getNewLoan({
        //2023-04-04
        "frm_date": DateFormat('yyyy-MM-dd').format(startDate!).toString(),
        "to_date": DateFormat('yyyy-MM-dd').format(endDate!).toString(),
        // "frm_date": "2023-01-01",
        // "to_date": "2023-05-10",
      });

      if (res.isValid) {
        if (res.r == null) return;
        newLoanList.value = res.r!;
        exportNewLoanListExcel();
      }
    } catch (e, t) {
      logger.e(e, 'Error');
      logger.e(t, 'Trace');
    }
  }

  Future<void> exportNewUserListExcel() async {
    // we will declare the list of headers
    try {
      List<String> rowHeader = [
        "No.",
        "Account Number.",
        "Name",
        "Type",
        "Eligible Amount",
        "Email",
        "Phone Number",
        "Date of birth",
        "Address",
      ];
      // here we will make a 2D array to handle a row
      List<List<dynamic>> rows = [];
      //First add entire row header into our first row
      rows.add(rowHeader);

      //Get User List
      for (int i = 0; i < newUserList.length; i++) {
        //everytime loop executes we need to add new row
        List<String> dataRow = [];
        dataRow.add("${i + 1}");
        dataRow.add(newUserList[i].accNumber.toString());
        dataRow.add(newUserList[i].fullName);
        dataRow.add(newUserList[i].isSponsor == 1 ? "Sponsor" : "Borrower");
        dataRow.add(newUserList[i].eligibleAmount.toString());
        dataRow.add(newUserList[i].email);
        dataRow.add("${newUserList[i].cc.toString()} ${newUserList[i].phno}");
        dataRow.add(
            DateFormat('yyyy-MM-dd').format(newUserList[i].dob).toString());
        dataRow.add(newUserList[i].address);
        //lastly add dataRow to our 2d list
        rows.add(dataRow);
      }

      //now convert our 2d array into the csvlist using the plugin of csv
      String csv = const ListToCsvConverter().convert(rows);
      //this csv variable holds entire csv data
      //Now Convert or encode this csv string into utf8
      final bytes = utf8.encode(csv);
      //NOTE THAT HERE WE USED HTML PACKAGE
      final blob = html.Blob([bytes]);
      //It will create downloadable object
      final url = html.Url.createObjectUrlFromBlob(blob);
      //It will create anchor to download the file
      final anchor = html.document.createElement('a') as html.AnchorElement
        ..href = url
        ..style.display = 'none'
        ..download = 'UserList.csv';
      //finally add the csv anchor to body
      html.document.body!.children.add(anchor);
      // Cause download by calling this function
      anchor.click();
      //revoke the object
      html.Url.revokeObjectUrl(url);
    } catch (e, t) {
      logger.e(e, 'Error');
      logger.e(t, 'Trace');
    }
  }

  Future<void> exportNewLoanListExcel() async {
    // we will declare the list of headers
    try {
      List<String> rowHeader = [
        "No.",
        "Name",
        "Borrow Amount",
        "Intrest Rate",
        "Tenure",
        "Approve Date",
      ];
      // here we will make a 2D array to handle a row
      List<List<dynamic>> rows = [];
      //First add entire row header into our first row
      rows.add(rowHeader);

      //Get User List
      for (int i = 0; i < newLoanList.length; i++) {
        //everytime loop executes we need to add new row
        List<String> dataRow = [];
        dataRow.add("${i + 1}");
        dataRow.add(newLoanList[i].fullName);
        dataRow.add(newLoanList[i].borrowAmount.toString());
        dataRow.add(newLoanList[i].intrestRate.toString());
        dataRow.add(newLoanList[i].tenure.toString());
        dataRow.add(DateFormat('yyyy-MM-dd')
            .format(newLoanList[i].approveDate)
            .toString());
        //lastly add dataRow to our 2d list
        rows.add(dataRow);
      }

      //now convert our 2d array into the csvlist using the plugin of csv
      String csv = const ListToCsvConverter().convert(rows);
      //this csv variable holds entire csv data
      //Now Convert or encode this csv string into utf8
      final bytes = utf8.encode(csv);
      //NOTE THAT HERE WE USED HTML PACKAGE
      final blob = html.Blob([bytes]);
      //It will create downloadable object
      final url = html.Url.createObjectUrlFromBlob(blob);
      //It will create anchor to download the file
      final anchor = html.document.createElement('a') as html.AnchorElement
        ..href = url
        ..style.display = 'none'
        ..download = 'LoanList.csv';
      //finally add the csv anchor to body
      html.document.body!.children.add(anchor);
      // Cause download by calling this function
      anchor.click();
      //revoke the object
      html.Url.revokeObjectUrl(url);
    } catch (e, t) {
      logger.e(e, 'Error');
      logger.e(t, 'Trace');
    }
  }
}
