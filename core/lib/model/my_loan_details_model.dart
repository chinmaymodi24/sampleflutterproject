import 'dart:convert';

import 'package:core/styles/app_themes.dart';
import 'package:core/utils/extensions/date_extensions.dart';
import 'package:core/utils/extensions/num_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

MyLoanDetailModel myLoanDetailModelFromJson(String str) =>
    MyLoanDetailModel.fromJson(json.decode(str));

String myLoanDetailModelToJson(MyLoanDetailModel data) =>
    json.encode(data.toJson());

class MyLoanDetailModel {
  MyLoanDetailModel({
    required this.id,
    required this.uId,
    required this.borrowAmount,
    required this.intrestRate,
    required this.tenure,
    required this.adminApproved,
    required this.status,
    required this.approveDate,
    required this.createdAt,
    required this.updatedAt,
    required this.sponserDetails,
    required this.details,
  });

  int id;
  int uId;
  int borrowAmount;
  double intrestRate;
  int tenure;
  int adminApproved;
  int status;
  DateTime approveDate;
  DateTime createdAt;
  DateTime updatedAt;
  List<SponserDetail> sponserDetails;
  List<Detail> details;

  String get getBorrowAmount => borrowAmount.toCurrency;

  List<Detail> get loanStatement {
    List<Detail> data = [];
    try {
      for (int i = 0; i < tenure; i++) {
        bool isExist = details.length > i;
        double principalAmt =
        (i == 0 ? borrowAmount : data[i - 1].outstandingAmt).ceilToDouble();
        double interest = ((principalAmt * intrestRate) / 100).ceilToDouble();
        int payment = isExist ? details[i].payment : 0;
        int outstandingAmt =
        ((principalAmt + interest) - payment).ceilToDouble().toInt();
        int date = approveDate.day > 28 ? 28 : approveDate.day;
        final Detail detail = Detail(
          id: isExist ? details[i].id : 0,
          loanId: id,
          date: DateTime(approveDate.year, approveDate.month + (i + 1), date),
          principleAmt: principalAmt,
          interest: interest,
          payment: payment,
          outstandingAmt: outstandingAmt,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          status: isExist ? details[i].status : 0,
          isDelete: 0,
        );
        data.add(detail);
      }
    } catch (e) {
      logger.e(e.toString());
    }
    return data;
  }

  String get getStatus {
    // pending = 0,
    // approved = 1,
    // closed = 2
    // rejected = -1
    // Withdrawn = -2
    // running = 3
    if (status == 0) {
      return "pending".tr;
    } else if (status == 1) {
      return "approved".tr;
    } else if (status == 2) {
      return "closed".tr;
    } else if (status == 3) {
      return "running".tr;
    } else if (status == -1) {
      return "rejected".tr;
    } else if (status == -2) {
      return "withDrawn".tr;
    } else {
      return "";
    }
  }

  Color get getStatusColor {
    if (status == 0) {
      return const Color(0xFFC29D66);
    } else if (status == 1) {
      return const Color(0xFF668BC2);
    } else if (status == 2) {
      return const Color(0xFF00A5D9);
    } else if (status == 3) {
      return const Color(0xFF90A84C);
    } else if (status == -1) {
      return Colors.red;
    }
    if (status == -2) {
      return const Color(0xFF668BC2);
    } else {
      return Colors.white;
    }
  }

  factory MyLoanDetailModel.fromJson(Map<String, dynamic> json) =>
      MyLoanDetailModel(
        id: json["id"] ?? 0,
        uId: json["u_id"] ?? 0,
        borrowAmount: json["borrow_amount"] ?? 0,
        intrestRate:
            double.tryParse(json["intrest_rate"]?.toString() ?? "") ?? 0.0,
        tenure: json["tenure"] ?? 0,
        adminApproved: json["admin_approved"] ?? 0,
        status: json["status"] ?? 0,
        approveDate:
            DateTime.tryParse(json["approve_date"].toString()) ?? DateTime(0),
        createdAt: DateTime.tryParse(json["created_at"] ?? "") ?? DateTime(0),
        updatedAt: DateTime.tryParse(json["updatedAt"] ?? "") ?? DateTime(0),
        sponserDetails: json["sponser_details"] == null
            ? []
            : List<SponserDetail>.from(json["sponser_details"].map(
                (x) => SponserDetail.fromJson(x),
              )),
        details: json["details"] == null
            ? []
            : List<Detail>.from(json["details"].map((x) => Detail.fromJson(x))),
      );

  factory MyLoanDetailModel.fromEmpty() => MyLoanDetailModel(
        id: 0,
        uId: 0,
        borrowAmount: 0,
        intrestRate: 0.0,
        tenure: 0,
        adminApproved: 0,
        status: 0,
        approveDate: DateTime(0),
        createdAt: DateTime(0),
        updatedAt: DateTime(0),
        sponserDetails: [],
        details: [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "u_id": uId,
        "borrow_amount": borrowAmount,
        "intrest_rate": intrestRate,
        "tenure": tenure,
        "admin_approved": adminApproved,
        "status": status,
        "approve_date": approveDate.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "sponser_details":
            List<dynamic>.from(sponserDetails.map((x) => x.toJson())),
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
      };
}

class SponserDetail {
  SponserDetail({
    required this.id,
    required this.fullName,
    required this.profileImg,
    required this.approved,
  });

  int id;
  String fullName;
  String profileImg;
  int approved;

  factory SponserDetail.fromJson(Map<String, dynamic> json) => SponserDetail(
        id: json["id"] ?? 0,
        fullName: json["full_name"] ?? "",
        profileImg: json["profile_img"] ?? "",
        approved: json["approved"] ?? 0,
      );

  factory SponserDetail.fromEmpty() => SponserDetail(
        id: 0,
        fullName: "",
        profileImg: "",
        approved: 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "profile_img": profileImg,
        "approved": approved,
      };
}

class Detail {
  Detail({
    required this.id,
    required this.loanId,
    required this.date,
    required this.principleAmt,
    required this.interest,
    required this.payment,
    required this.outstandingAmt,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.isDelete,
  });

  int id;
  int loanId;
  DateTime date;
  double principleAmt;
  double interest;
  int payment;
  int outstandingAmt;
  DateTime createdAt;
  DateTime updatedAt;
  int status;
  int isDelete;

  String get getPrincipleAmt => principleAmt.toCurrency;

  String get getInterest => interest.toCurrency;

  String get getPayment => payment.toCurrency;

  String get getOutstandingAmt => outstandingAmt.toCurrency;

  String get statusString {
    switch (status) {
      case 1:
        return "Paid";
      case 2:
        return "Skipped";
      default:
        return "Not Paid";
    }
  }

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        id: json["id"] ?? 0,
        loanId: json["loan_id"] ?? 0,
        date: DateTime.tryParse(json["date"].toString()) ?? DateTime(0),
        principleAmt: double.tryParse(json["principle_amt"].toString()) ?? 0,
        interest: double.tryParse(json["interest"].toString()) ?? 0.0,
        payment: int.tryParse(json["payment"].toString()) ?? 0,
        outstandingAmt: int.tryParse(json["outstanding_amt"].toString()) ?? 0,
        createdAt: DateTime.tryParse(json["created_at"] ?? "") ?? DateTime(0),
        updatedAt: DateTime.tryParse(json["updatedAt"] ?? "") ?? DateTime(0),
        status: json["status"] ?? 0,
        isDelete: json["is_delete"] ?? 0,
      );

  factory Detail.fromEmpty() => Detail(
        id: 0,
        loanId: 0,
        date: DateTime(0),
        principleAmt: 0,
        interest: 0,
        payment: 0,
        status: 0,
        outstandingAmt: 0,
        createdAt: DateTime(0),
        updatedAt: DateTime(0),
        isDelete: 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "loan_id": loanId,
        "date": date.serverDate,
        "principle_amt": principleAmt,
        "interest": interest,
        "payment": payment,
        "outstanding_amt": outstandingAmt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "status": status,
        "is_delete": isDelete,
      };

  Map<String, dynamic> toAddUpdate() => {
        "id": id,
        "loan_id": loanId,
        "date": date.serverDate,
        "principle_amt": principleAmt,
        "interest": interest,
        "payment": payment,
        "outstanding_amt": outstandingAmt,
        "status": status,
        "is_delete": isDelete,
      };
}
