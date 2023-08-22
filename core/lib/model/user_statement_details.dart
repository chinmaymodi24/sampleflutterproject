import 'dart:convert';

import 'package:core/utils/extensions/num_extensions.dart';

UserStatementDetailModel userStatementDetailModelFromJson(String str) =>
    UserStatementDetailModel.fromJson(json.decode(str));

String userStatementDetailModelToJson(UserStatementDetailModel data) =>
    json.encode(data.toJson());

class UserStatementDetailModel {
  UserStatementDetailModel({
    required this.totalLoan,
    required this.closedLoan,
    required this.elgAmt,
    required this.totalLoanAmt,
    required this.totalPaidAmt,
    required this.userId,
    required this.userName,
  });

  int totalLoan;
  int closedLoan;
  int elgAmt;
  int totalLoanAmt;
  int totalPaidAmt;
  int userId;
  String userName;

  String get getElgAmt => elgAmt.toCurrency;

  String get getTotalLoanAmt => totalLoanAmt.toCurrency;

  String get getTotalPaidAmt => totalPaidAmt.toCurrency;

  factory UserStatementDetailModel.fromJson(Map<String, dynamic> json) =>
      UserStatementDetailModel(
        totalLoan: int.tryParse(json["total_loan"]?.toString() ?? "") ?? 0,
        closedLoan: int.tryParse(json["closed_loan"]?.toString() ?? "") ?? 0,
        elgAmt: int.tryParse(json["elg_amt"]?.toString() ?? "") ?? 0,
        totalLoanAmt:
            int.tryParse(json["total_loan_amt"]?.toString() ?? "") ?? 0,
        totalPaidAmt:
            int.tryParse(json["total_paid_amt"]?.toString() ?? "") ?? 0,
        userId: json["id"] ?? 0,
        userName: json["user_name"] ?? "",
      );

  factory UserStatementDetailModel.fromEmpty() => UserStatementDetailModel(
        totalLoan: 0,
        closedLoan: 0,
        elgAmt: 0,
        totalLoanAmt: 0,
        totalPaidAmt: 0,
        userId: 0,
        userName: "",
      );

  Map<String, dynamic> toJson() => {
        "total_loan": totalLoan,
        "closed_loan": closedLoan,
        "elg_amt": elgAmt,
        "total_loan_amt": totalLoanAmt,
        "total_paid_amt": totalPaidAmt,
        "id": userId,
        "user_name": userName,
      };
}
