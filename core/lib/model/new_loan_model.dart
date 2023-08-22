// To parse this JSON data, do
//
//     final newLoanModel = newLoanModelFromJson(jsonString);

import 'dart:convert';

NewLoanModel newLoanModelFromJson(String str) =>
    NewLoanModel.fromJson(json.decode(str));

String newLoanModelToJson(NewLoanModel data) => json.encode(data.toJson());

class NewLoanModel {
  int id;
  int uId;
  int borrowAmount;
  double intrestRate;
  int tenure;
  int status;
  DateTime approveDate;
  int isHide;
  DateTime createdAt;
  DateTime updatedAt;
  String fullName;

  NewLoanModel({
    required this.id,
    required this.uId,
    required this.borrowAmount,
    required this.intrestRate,
    required this.tenure,
    required this.status,
    required this.approveDate,
    required this.isHide,
    required this.createdAt,
    required this.updatedAt,
    required this.fullName,
  });

  factory NewLoanModel.fromJson(Map<String, dynamic> json) => NewLoanModel(
        id: json["id"] ?? 0,
        uId: json["u_id"] ?? 0,
        borrowAmount: json["borrow_amount"] ?? 0,
        intrestRate:
            double.tryParse(json["intrest_rate"]?.toString() ?? "") ?? 0.0,
        tenure: json["tenure"] ?? 0,
        status: json["status"] ?? 0,
        approveDate:
            DateTime.tryParse(json["approve_date"] ?? "") ?? DateTime(0),
        isHide: json["is_hide"] ?? 0,
        createdAt: DateTime.tryParse(json["created_at"] ?? "") ?? DateTime(0),
        updatedAt: DateTime.tryParse(json["updatedAt"] ?? "") ?? DateTime(0),
        fullName: json["full_name"] ?? "",
      );

  factory NewLoanModel.froEmpty() => NewLoanModel(
        id: 0,
        uId: 0,
        borrowAmount: 0,
        intrestRate: 0.0,
        tenure: 0,
        status: 0,
        approveDate: DateTime(0),
        isHide: 0,
        createdAt: DateTime(0),
        updatedAt: DateTime(0),
        fullName: "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "u_id": uId,
        "borrow_amount": borrowAmount,
        "intrest_rate": intrestRate,
        "tenure": tenure,
        "status": status,
        "approve_date": approveDate.toIso8601String(),
        "is_hide": isHide,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "full_name": fullName,
      };
}
