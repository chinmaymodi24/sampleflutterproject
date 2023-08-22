import 'dart:convert';

import 'package:core/utils/extensions/num_extensions.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.id,
    required this.fId,
    required this.role,
    required this.loginType,
    required this.fullName,
    required this.apiKey,
    required this.rejectReason,
    required this.token,
    required this.profileImg,
    required this.email,
    required this.dob,
    required this.natIdNo,
    required this.natIdFront,
    required this.natIdBack,
    required this.phno,
    required this.optPhno,
    required this.address,
    required this.govLater,
    required this.accStatus,
    required this.verificationStatus,
    required this.accNumber,
    required this.cc,
    required this.optCc,
    required this.isSponsor,
    required this.borrowedAmt,
    required this.eligibleAmount,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String fId;
  int loginType;
  int role;
  String fullName;
  String profileImg;
  String email;
  DateTime dob;
  String natIdNo;
  String natIdFront;
  String natIdBack;
  String phno;
  String optPhno;
  String address;
  String govLater;
  int accStatus;
  int verificationStatus;
  int accNumber;
  int cc;
  int optCc;
  int isSponsor;
  int eligibleAmount;
  int borrowedAmt;
  DateTime createdAt;
  DateTime updatedAt;
  String apiKey;
  String token;
  String rejectReason;

  String get getBorrowedAmt => borrowedAmt.toCurrency;

  String get getEligibleAmount => eligibleAmount.toCurrency;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"] ?? 0,
        fId: json["f_id"] ?? "",
        loginType: json["login_type"] ?? 0,
        role: json["role"] ?? 0,
        fullName: json["full_name"] ?? "",
        profileImg: json["profile_img"] ?? "",
        email: json["email"] ?? "",
        dob: DateTime.tryParse(json["dob"] ?? "") ?? DateTime(0),
        natIdNo: json["nat_id_no"] ?? "",
        natIdFront: json["nat_id_front"] ?? "",
        natIdBack: json["nat_id_back"] ?? "",
        phno: json["phno"] ?? "",
        optPhno: json["opt_phno"] ?? "",
        address: json["address"] ?? "",
        govLater: json["gov_later"] ?? "",
        accStatus: json["acc_status"] ?? 0,
        verificationStatus: json["verification_status"] ?? 0,
        accNumber: int.tryParse(json["acc_number"]?.toString() ?? "") ?? 0,
        cc: int.tryParse(json["cc"]?.toString() ?? "") ?? 0,
        optCc: int.tryParse(json["opt_cc"]?.toString() ?? "") ?? 0,
        isSponsor: json["is_sponser"] ?? 0,
        borrowedAmt: int.tryParse(json["borrowed_amt"]?.toString() ?? "") ?? 0,
        eligibleAmount: json["eligible_amount"] ?? 0,
        createdAt: DateTime.tryParse(json["created_at"] ?? "") ?? DateTime(0),
        updatedAt: DateTime.tryParse(json["updatedAt"] ?? "") ?? DateTime(0),
        apiKey: json["apikey"] ?? "",
        rejectReason: json["reject_reason"] ?? "",
        token: json["token"] ?? "",
      );

  factory UserModel.fromEmpty() => UserModel(
        id: 0,
        fId: "",
        loginType: 0,
        role: 0,
        fullName: "",
        profileImg: "",
        email: "",
        dob: DateTime(0),
        natIdNo: "",
        natIdFront: "",
        natIdBack: "",
        phno: "",
        optPhno: "",
        address: "",
        govLater: "",
        accStatus: 0,
        verificationStatus: 0,
        accNumber: 0,
        cc: 0,
        optCc: 0,
        isSponsor: 0,
        borrowedAmt: 0,
        eligibleAmount: 0,
        createdAt: DateTime(0),
        updatedAt: DateTime(0),
        apiKey: "",
        token: "",
        rejectReason: "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "f_id": fId,
        "login_type": loginType,
        "role": role,
        "full_name": fullName,
        "profile_img": profileImg,
        "email": email,
        "dob": dob.toIso8601String(),
        "nat_id_no": natIdNo,
        "nat_id_front": natIdFront,
        "nat_id_back": natIdBack,
        "phno": phno,
        "opt_phno": optPhno,
        "address": address,
        "gov_later": govLater,
        "acc_status": accStatus,
        "verification_status": verificationStatus,
        "acc_number": accNumber,
        "cc": cc,
        "opt_cc": optCc,
        "is_sponser": isSponsor,
        "borrowed_amt ": borrowedAmt,
        "eligible_amount": eligibleAmount,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "apikey": apiKey,
        "token": token,
        "reject_reason": rejectReason,
      };
}
