// To parse this JSON data, do
//
//     final adminNotificationModel = adminNotificationModelFromJson(jsonString);

import 'dart:convert';

AdminNotificationModel adminNotificationModelFromJson(String str) =>
    AdminNotificationModel.fromJson(json.decode(str));

String adminNotificationModelToJson(AdminNotificationModel data) =>
    json.encode(data.toJson());

class AdminNotificationModel {
  int id;
  int userId;
  String title;
  String body;
  int type;
  int typeId;
  dynamic isCustomerCare;
  dynamic info;
  UserIds perm;
  int isRead;
  DateTime createdAt;

  AdminNotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    required this.typeId,
    this.isCustomerCare,
    this.info,
    required this.perm,
    required this.isRead,
    required this.createdAt,
  });

  factory AdminNotificationModel.fromJson(Map<String, dynamic> json) =>
      AdminNotificationModel(
        id: json["id"] ?? 0,
        userId: json["user_id"] ?? 0,
        title: json["title"] ?? '',
        body: json["body"] ?? '',
        type: json["type"] ?? 0,
        typeId: json["type_id"] ?? 0,
        isCustomerCare: json["is_customer_care"],
        info: json["info"],
        perm: json["perm"] == null || json["perm"].isEmpty
            ? UserIds()
            : userIdsFromJson(json["perm"] ?? {}),
        isRead: json["is_read"] ?? 0,
        createdAt: json['created_at'] == null
            ? DateTime(0)
            : DateTime.parse(json["created_at"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "title": title,
        "body": body,
        "type": type,
        "type_id": typeId,
        "is_customer_care": isCustomerCare,
        "info": info,
        "perm": perm,
        "is_read": isRead,
        "created_at": createdAt.toIso8601String(),
      };
}
// To parse this JSON data, do
//
//     final userIds = userIdsFromJson(jsonString);

UserIds userIdsFromJson(String str) => UserIds.fromJson(json.decode(str));

String userIdsToJson(UserIds data) => json.encode(data.toJson());

class UserIds {
  int uId;

  UserIds({
    this.uId = 0,
  });

  factory UserIds.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      return UserIds(
        uId: int.tryParse(json["u_id"].toString()) ?? 0,
      );
    } else {
      return UserIds();
    }
  }

  Map<String, dynamic> toJson() => {
        "u_id": uId,
      };
}
