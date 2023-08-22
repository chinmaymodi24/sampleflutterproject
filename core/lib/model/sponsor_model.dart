import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SponsorModel {
  SponsorModel({
    required this.id,
    required this.userId,
    required this.borrowAmount,
    required this.fullName,
    required this.profileImg,
    required this.accStatus,
    required this.isSponsor,
    required this.isApproved,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  int id;
  int userId;
  int borrowAmount;
  String fullName;
  String profileImg;
  int accStatus;
  int isSponsor;
  int isApproved;
  String title;
  String body;
  DateTime createdAt;

  String get getStatus {
    log("isApproved = $isApproved");

    // pending = 0,
    // approved = 1,
    // closed = 2
    // rejected = -1
    // withdrawn = -2
    // running = 3
    if (isApproved == 0) {
      return "pending".tr;
    } else if (isApproved == 1) {
      return "approved".tr;
    } else if (isApproved == 2) {
      return "closed".tr;
    } else if (isApproved == 3) {
      return "running".tr;
    } else if (isApproved == -1) {
      return "rejected".tr;
    } else if (isApproved == -2) {
      return "withDrawn".tr;
    } else {
      return "";
    }
  }

  Color get getIsApprovedColor {
    if (isApproved == 0) {
      return const Color(0xFFC29D66);
    } else if (isApproved == 1) {
      return const Color(0xFF668BC2);
    } else if (isApproved == 2) {
      return const Color(0xFF00A5D9);
    } else if (isApproved == 3) {
      return const Color(0xFF90A84C);
    } else if (isApproved == -1) {
      return Colors.red;
    } else if (isApproved == 2) {
      return const Color(0xFF668BC2);
    } else {
      return Colors.white;
    }
  }

  factory SponsorModel.fromJson(Map<String, dynamic> json) => SponsorModel(
        id: json["id"] ?? 0,
        userId: json["u_id"] ?? 0,
        borrowAmount: json["borrow_amount"] ?? 0,
        fullName: json["full_name"] ?? "",
        profileImg: json["profile_img"] ?? "",
        accStatus: json["acc_status"] ?? 0,
        isSponsor: json["is_sponser"] ?? 0,
        isApproved: json["approved"] ?? 0,
        title: json["title"] ?? "",
        body: json["body"] ?? "",
    createdAt: DateTime.tryParse(json["created_at"] ?? "") ?? DateTime(0),
      );

  factory SponsorModel.fromEmpty() => SponsorModel(
        id: 0,
        userId: 0,
        borrowAmount: 0,
        fullName: "",
        profileImg: "",
        accStatus: 0,
        isSponsor: 0,
        isApproved: 0,
        title: "",
        body: "",
    createdAt: DateTime(0),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "u_id": userId,
        "borrow_amount": borrowAmount,
        "full_name": fullName,
        "profile_img": profileImg,
        "acc_status": accStatus,
        "is_sponser": isSponsor,
        "approved": isApproved,
        "title": title,
        "body": body,
        "created_at": createdAt,
      };
}
