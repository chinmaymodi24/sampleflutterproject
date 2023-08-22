import 'dart:convert';
import 'package:core/utils/extensions/num_extensions.dart';

RecentUserModel recentUserModelFromJson(String str) => RecentUserModel.fromJson(json.decode(str));

String recentUserModelToJson(RecentUserModel data) => json.encode(data.toJson());

class RecentUserModel {
  RecentUserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.cc,
    required this.phno,
    required this.amt,
    required this.isSponser,
    required this.accStatus,
  });

  int id;
  String fullName;
  String email;
  int cc;
  String phno;
  String amt;
  int isSponser;
  int accStatus;

  String get getAmt => int.parse(amt).toCurrency;

  factory RecentUserModel.fromJson(Map<String, dynamic> json) => RecentUserModel(
    id: json["id"] ?? 0,
    fullName: json["full_name"] ?? "",
    email: json["email"] ?? "",
    cc: json["cc"] ?? 0,
    phno: json["phno"] ?? "",
    amt: json["amt"] ?? "",
    isSponser: json["is_sponser"] ?? 0,
    accStatus: json["acc_status"] ?? 0,
  );

  factory RecentUserModel.fromEmpty() => RecentUserModel(
    id: 0,
    fullName: "",
    email: "",
    cc: 0,
    phno: "",
    amt: "",
    isSponser: 0,
    accStatus: 0,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullName,
    "email": email,
    "cc": cc,
    "phno": phno,
    "amt": amt,
    "is_sponser": isSponser,
    "acc_status": accStatus,
  };
}
