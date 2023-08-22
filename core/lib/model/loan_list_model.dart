import 'package:core/utils/extensions/num_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyLoanListModel {
  MyLoanListModel({
    required this.id,
    required this.uId,
    required this.borrowAmount,
    required this.tenure,
    required this.intrestRate,
    required this.fullName,
    required this.profileImg,
    required this.adminApproved,
    required this.status,
    required this.approved,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int uId;
  int borrowAmount;
  int tenure;
  double intrestRate;
  String fullName;
  String profileImg;
  int adminApproved;
  int status;
  int approved;
  DateTime createdAt;
  DateTime updatedAt;

  String get getBorrowAmount => borrowAmount.toCurrency;

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
    }else if (status == -2) {
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
    }if (status == -2) {
      return const Color(0xFF668BC2);
    } else {
      return Colors.white;
    }
  }

  factory MyLoanListModel.fromJson(Map<String, dynamic> json) =>
      MyLoanListModel(
        id: json["id"] ?? 0,
        uId: json["u_id"] ?? 0,
        borrowAmount: json["borrow_amount"] ?? 0,
        tenure: json["tenure"] ?? 0,
        //intrestRate: json["intrest_rate"] ?? 0.0,
        intrestRate:
            double.tryParse(json["intrest_rate"]?.toString() ?? "") ?? 0.0,
        fullName: json["full_name"] ?? "",
        profileImg: json["profile_img"] ?? "",
        adminApproved: json["admin_approved"] ?? 0,
        status: json["status"] ?? 0,
        approved: json["approved"] ?? 0,
        createdAt: DateTime.tryParse(json["created_at"] ?? "") ?? DateTime(0),
        updatedAt: DateTime.tryParse(json["updatedAt"] ?? "") ?? DateTime(0),
      );

  factory MyLoanListModel.fromEmpty() => MyLoanListModel(
        id: 0,
        uId: 0,
        borrowAmount: 0,
        tenure: 0,
        intrestRate: 0.0,
        fullName: "",
        profileImg: "",
        adminApproved: 0,
        status: 0,
        approved: 0,
        createdAt: DateTime(0),
        updatedAt: DateTime(0),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "u_id": uId,
        "borrow_amount": borrowAmount,
        "tenure": tenure,
        "intrest_rate": intrestRate,
        "full_name": fullName,
        "profile_img": profileImg,
        "admin_approved": adminApproved,
        "status": status,
        "approved": approved,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
