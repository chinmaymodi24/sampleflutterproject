import 'package:admin/utils/app_toast.dart';
import 'package:admin/utils/constants.dart';
import 'package:core/backend/auth_service.dart';
import 'package:core/backend/chat_backend_service.dart';
import 'package:core/backend/loan_service.dart';
import 'package:core/backend/notification_service.dart';
import 'package:core/model/api_generic_model.dart';
import 'package:core/model/sponsor_model.dart';
import 'package:core/model/user_model.dart';
import 'package:core/model/user_statement_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:core/model/user_statement_list_model.dart';
import 'package:core/backend/user_statement_service.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:html' as html;
import 'package:csv/csv.dart';

class CustomMonthInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    TextEditingValue v = TextEditingValue(
        text: '${newValue.text.replaceAll("Months", "")} Months',
        selection: TextSelection.fromPosition(TextPosition(
            offset: newValue.text.length, affinity: TextAffinity.upstream)));
    return v;
  }
}

class CustomInterestInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    TextEditingValue v = TextEditingValue(
        text: '${newValue.text.replaceAll("%", "")} %',
        selection: TextSelection.fromPosition(TextPosition(
            offset: newValue.text.length, affinity: TextAffinity.upstream)));
    return v;
  }
}

class UserStatementCtrl extends GetxController {
  TextEditingController interestRateCtrl = TextEditingController();
  TextEditingController tenureCtrl = TextEditingController();
  TextEditingController payAmountCTRL = TextEditingController();
  int userId = 0;

  RxBool isLoading = true.obs;
  RxBool isChatButtonLoading = false.obs;

  RxBool isDownloadLoading = false.obs;

  RxBool isGetList = true.obs;

  Rx<UserStatementDetailModel> userStatementDetailModel =
      UserStatementDetailModel.fromEmpty().obs;

  RxList<UserStatementListModel> userStatementList =
      <UserStatementListModel>[].obs;

  RxList<SponsorModel> sponsorList = <SponsorModel>[].obs;

  RxBool isSponsorLoading = false.obs;

  Future<UserModel?> getChatUserDetail({required int id}) async {
    var res = await AuthService.getProfile({
      "id": id,
    });
    if (res.isValid) {
      return res.r;
    } else {
      logger.i(res.m);
    }
    return res.r;
  }

  Future<ApiResponse> createChatId(
      {required int userOneId, required int userTwoId}) {
    var res = ChatBackEndService.createChatId({
      "from_user": userOneId,
      "to_user": userTwoId,
    });
    return res;
  }

  // Type 1 - Push Notification
  // Type 2 - Chat Notification
  //Type 3 - loan reminder
  //TypeId = LoanId here only
  Future<void> sendRemainderNotification(
      {required int type, required int typeIdLoanId, required int uId}) async {
    var res = await NotificationAPIService.sendNotificationToAllUser(
      {
        'type': type,
        'type_id': typeIdLoanId,
        'u_id': uId,
      },
    );
    AppToast.msg(res.m);
  }

  Future<void> hideOrUnHideLoan(
      {required int loanId, required int isHide}) async {
    var res = await LoanService.hideOrUnHideLoan(
      {
        'loan_id': loanId,
        'is_hide': isHide,
      },
    );
    AppToast.msg(res.m);
  }

  Future<void> getUserStatementList({required int userId}) async {
    isLoading.value = true;
    isGetList(true);
    var res = await UserStatementService.getAllUserStatement({
      "uid": userId,
    });

    if (res.isValid) {
      userStatementList.value = res.r!;
      // logger.d(userStatementList.map((element) => element.toJson()).toList(),
      //     'Loan Details dsgsd');
    } else {
      AppToast.msg(res.m);
      logger.e("e = ${res.r}");
    }
    isGetList(false);
  }

  Future<void> getUserStatementDetails({required int userId}) async {
    var res = await UserStatementService.getMyLoanDetails({"uid": userId});

    if (res.isValid) {
      userStatementDetailModel.value = res.r!;
    } else {
      logger.e("e = ${res.r}");
    }
  }

  Future<void> exportUserStatementExcel({required int i}) async {

    isDownloadLoading.value = true;

    // we will declare the list of headers
    try {
      List<String> rowHeader1 = [
        "Loan Number",
        "Date",
        "Total Amount",
        "Tenure Months",
        "Interest",
      ];
      // here we will make a 2D array to handle a row
      List<List<dynamic>> rows1 = [];
      //First add entire row header into our first row
      rows1.add(rowHeader1);
      List<String> rowHeader2 = [
        "-",
        DateFormat('dd-MM-yyyy')
            .format(userStatementList[i].approveDate)
            .toString(),
        "${userStatementList[i].borrowAmount} TZS",
        "${userStatementList[i].tenure} Months",
        "${userStatementList[i].intrestRate} %",
      ];
      // here we will make a 2D array to handle a row
      List<List<dynamic>> rows2 = [];
      //First add entire row header into our first row
      rows2.add(rowHeader2);


      List<String> rowHeader3 = [
        "",
      ];
      // here we will make a 2D array to handle a row
      List<List<dynamic>> rows3 = [];
      //First add entire row header into our first row
      rows3.add(rowHeader3);

      List<String> rowHeader = [
        "No.",
        "Date",
        "Principal Amount",
        "Intrest Rate",
        "Payment",
        "Outstanding amount",
        "Status",
      ];
      // here we will make a 2D array to handle a row
      List<List<dynamic>> rows = [];
      //First add entire row header into our first row
      rows.add(rowHeader1);
      rows.add(rowHeader2);
      rows.add(rowHeader3);
      rows.add(rowHeader);

      logger.wtf(
          "userStatementList[i].loanStatement.length = ${userStatementList[i].loanStatement.length}");

      //Get User List
      for (int j = 0; j < userStatementList[i].loanStatement.length; j++) {
        //everytime loop executes we need to add new row
        List<String> dataRow = [];
        dataRow.add("${j + 1}");
        dataRow.add(DateFormat('dd-MM-yyyy')
            .format(userStatementList[i].loanStatement[j].date)
            .toString());
        dataRow.add(
            "${userStatementList[i].loanStatement[j].getPrincipleAmt} TZS");
        dataRow.add(
          "${userStatementList[i].loanStatement[j].getInterest} TZS",
        );
        dataRow.add(
          "${userStatementList[i].loanStatement[j].getPayment} TZS",
        );
        dataRow.add(
          "${userStatementList[i].loanStatement[j].getOutstandingAmt} TZS",
        );
        dataRow.add(
          userStatementList[i].loanStatement[j].statusString,
        );

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
        ..download = 'UserStatement.csv';
      //finally add the csv anchor to body
      html.document.body!.children.add(anchor);
      // Cause download by calling this function
      anchor.click();
      //revoke the object
      html.Url.revokeObjectUrl(url);
      isDownloadLoading.value = false;
    } catch (e, t) {

      isDownloadLoading.value = false;

      logger.e(e, 'Error');
      logger.e(t, 'Trace');
    }
  }

  Future<void> giveLoanStatusFromAdmin({
    required int loanId,
    required int status,
    required int? tenure,
    required double? intrestRate,
    required DateTime? approveDate,
    bool formEdit = false,
  }) async {
    isLoading.value = true;
    if (formEdit == true) {
      await newEditLoan(
          loanId: loanId, tenure: tenure ?? 0, intrestRate: intrestRate ?? 0);
    } else {
      Map<String, dynamic> data = {"loan_id": loanId, "status": status};
      // if (formEdit == false) {
      //   data.addAll({"status": status});
      // }

      if (tenure != null) {
        data.addAll({
          "tenure": tenure,
        });
      }

      if (intrestRate != null) {
        data.addAll({
          "intrest_rate": intrestRate,
        });
      }

      if (approveDate != null) {
        data.addAll({
          "approve_date": approveDate,
        });
      }

      var res = await UserStatementService.giveLoanStatusFromAdmin(data);

      if (res.isValid) {
        AppToast.msg("status_updated".tr);
      } else {
        logger.e("${res.r}");
      }
    }
    await init();

    isLoading.value = false;
  }

  Future<void> reOpenLoanFromAdmin({required int loanId}) async {
    var res = await UserStatementService.loanReOpenFromAdmin({
      "loan_id": loanId,
    });

    if (res.isValid) {
      AppToast.msg("Loan is reopen");
    } else {
      AppToast.msg("Something went wrong");
    }
  }

  Future<void> newEditLoan({
    required int loanId,
    required int tenure,
    required double intrestRate,
  }) async {
    isLoading.value = true;
    var res = await UserStatementService.newEditLoan({
      "loan_id": loanId,
      "intrest_rate  ": intrestRate,
      "tenure": tenure,
    });

    if (res.isValid) {
      await init();
      AppToast.msg("syncing_please_wait".tr);
    } else {
      logger.e("${res.r}");
    }
    isLoading.value = false;
  }

  Future<void> addLoanDetails({
    required double interest,
    required int duration,
    required UserStatementListModel statement,
  }) async {
    List<Detail> list = [];
    for (var i = 0; i < duration; i++) {
      var newAmount =
          (i == 0) ? statement.borrowAmount : list[i - 1].outstandingAmt;
      var newDate = (i == 0)
          ? DateTime(
              DateTime.now().year, DateTime.now().month + 1, DateTime.now().day)
          : DateTime(list[i - 1].date.year, list[i - 1].date.month + 1,
              list[i - 1].date.day);
      var newInterest = findInterest(newAmount, interest);

      var model = Detail(
        id: 0,
        loanId: statement.id,
        date: newDate,
        principleAmt: newAmount.toDouble(),
        interest: newInterest,
        payment: 0,
        outstandingAmt: (newAmount + newInterest).toInt(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        status: 0,
        isDelete: 0,
      );

      list.add(model);
    }
    await UserStatementService.editLoanDetails(list);
  }

  Future<void> updateLoanDetail({
    required int index,
    required int subIndex,
  }) async {
    UserStatementListModel statement = userStatementList[index];
    Detail detail = userStatementList[index].loanStatement[subIndex];
    int amount = int.parse(payAmountCTRL.text);
    detail.payment = amount;
    detail.status = 1;
    for (int i = statement.details.length; i < subIndex; i++) {
      Detail detail = userStatementList[index].loanStatement[i];
      detail.status = 2;
      userStatementList[index].details.add(detail);
    }
    userStatementList[index].details.add(detail);

    logger.i("amount = $amount");
    logger.i(
        "userStatementList[index].loanStatement[subIndex].outstandingAmt = ${userStatementList[index].loanStatement[subIndex].outstandingAmt}");

    if (0 == userStatementList[index].loanStatement[subIndex].outstandingAmt) {
      logger.i("CLOSE LOAN API WILL CALL");

      logger
          .e(" userStatementList[index].id, = ${userStatementList[index].id}");

      await giveLoanStatusFromAdmin(
        loanId: userStatementList[index].id,
        status: 2,
        tenure: null,
        intrestRate: null,
        approveDate: null,
      );
    }

    // var interest = statement.intrestRate;
    // List<Detail> list = [];
    // for (var i = 0; i < statement.details.length; i++) {
    //   try {
    //     var newAmount = (i == 0)
    //         ? userStatementList[index].borrowAmount
    //         : statement.details[i - 1].outstandingAmt;
    //     var newInterest = findInterest(newAmount, interest);
    //     // var pay = int.tryParse(model.payCTRL.text) ?? 0;
    //     if (id == statement.details[i].id) {
    //       var newBalance = (newAmount + newInterest) - amount;
    //
    //       /// update pay amount
    //       statement.details[i].principleAmt = newAmount.toDouble();
    //       statement.details[i].interest = newInterest;
    //       statement.details[i].payment = amount;
    //       statement.details[i].status = 1;
    //       statement.details[i].outstandingAmt = newBalance.toInt();
    //       statement.details[i].isDelete = newAmount.toDouble() == 0 ? 1 : 0;
    //     } else {
    //       var outstandingAmt =
    //           ((newAmount + newInterest) - statement.details[i].payment)
    //               .toInt();
    //       statement.details[i].principleAmt = newAmount.toDouble();
    //       statement.details[i].interest = newInterest;
    //       statement.details[i].outstandingAmt = outstandingAmt;
    //       statement.details[i].isDelete = newAmount.toDouble() == 0 ? 1 : 0;
    //     }
    //   } on Exception catch (e, t) {
    //     logger.e('ERROR :$e \nTRACE :$t', 'INDEX :$i');
    //   }
    // }
    await UserStatementService.editLoanDetails(statement.details);
    await init();
  }

  double findInterest(int amount, double interest) {
    var interestAmount = (amount * interest) / 100;
    return double.parse(interestAmount.toStringAsFixed(2));
  }

  Future<void> giveStatusOfLoanInstallment({
    required int id,
  }) async {
    isLoading.value = true;

    var res = await UserStatementService.giveStatusOfLoanInstallment({
      "id": id,
    });

    if (res.isValid) {
      await init();
      AppToast.msg("installment_status_updated".tr);
    } else {
      logger.e("${res.r}");
    }
    isLoading.value = false;
  }

  Future<void> getAllSponsorById({required int loanId}) async {
    isSponsorLoading.value = true;
    var res = await UserStatementService.getAllSponsorById({
      "loan_id": loanId,
    });

    if (res.isValid) {
      sponsorList.value = res.r!;
    } else {
      isSponsorLoading.value = false;
      AppToast.msg(res.m);
    }
    isSponsorLoading.value = false;
  }

  init() async {
    isLoading.value = true;
    if (Get.arguments is int) {
      userId = Get.arguments;
      await getUserStatementDetails(userId: userId);
      await getUserStatementList(userId: userId);

      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    init();
    super.onInit();
  }
}
