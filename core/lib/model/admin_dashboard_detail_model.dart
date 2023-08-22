import 'dart:convert';
import 'package:core/utils/extensions/num_extensions.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

AdminDashboardDetailModel qtyCurrencyModelFromJson(String str) =>
    AdminDashboardDetailModel.fromJson(json.decode(str));

String qtyCurrencyModelToJson(AdminDashboardDetailModel data) =>
    json.encode(data.toJson());

class AdminDashboardDetailModel {
  AdminDashboardDetailModel({
    required this.totalUsers,
    required this.totalAmtBorrowed,
  });

  int totalUsers;
  String totalAmtBorrowed;

  String get getTotalAmtBorrowed =>
      (int.tryParse(totalAmtBorrowed.toString()) ?? 0).toCurrency;

  factory AdminDashboardDetailModel.fromJson(Map<String, dynamic> json) =>
      AdminDashboardDetailModel(
        totalUsers: json["total_users"] ?? 0,
        totalAmtBorrowed: json["total_amt_borrowed"] ?? "",
      );

  factory AdminDashboardDetailModel.froEmpty() => AdminDashboardDetailModel(
        totalUsers: 0,
        totalAmtBorrowed: "",
      );

  Map<String, dynamic> toJson() => {
        "total_users": totalUsers,
        "total_amt_borrowed": totalAmtBorrowed,
      };
}
