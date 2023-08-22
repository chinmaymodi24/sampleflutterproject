import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

SupportChatModel supportChatModelFromJson(String str) => SupportChatModel.fromJson(json.decode(str));
String supportChatModelToJson(SupportChatModel data) => json.encode(data.toJson());

class SupportChatModel {
  SupportChatModel({
    required this.isRead,
    required this.msg,
    required this.msgType,
    required this.sendAt,
    required this.sendById,
  });

  int isRead;
  String msg;
  int msgType;
  Timestamp sendAt;
  int sendById;
  String docId = "";

  get time => DateFormat().add_jm().format(sendAt.toDate());
  //12th September, 2022 06:30 PM
  //get time => DateFormat('dd MMMM yyyy').add_jm().format(sendAt.toDate());

  factory SupportChatModel.fromJson(Map<String, dynamic> json) => SupportChatModel(
    isRead: json["isRead"] ?? 0,
    msg: json["msg"] ?? "",
    msgType: json["msgType"] ?? 0,
    sendAt: json["sendAt"] ?? Timestamp.fromDate(DateTime(0)),
    sendById: json["sendById"] ?? 0,
  );

  factory SupportChatModel.fromListJson(
      Map<String, dynamic> json) =>
      SupportChatModel(
        isRead: json["isRead"] ?? 0,
        msg: json["msg"] ?? "",
        msgType: json["msgType"] ?? 0,
        sendAt: json["sendAt"] ?? Timestamp.fromDate(DateTime(0)),
        sendById: json["sendById"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
    "isRead": isRead,
    "msg": msg,
    "msgType": msgType,
    "sendAt": sendAt,
    "sendById": sendById,
  };
}
