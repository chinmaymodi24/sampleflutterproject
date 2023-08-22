import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

ChatRoomModel chatRoomModelFromJson(String str) =>
    ChatRoomModel.fromJson(json.decode(str));

String chatRoomModelToJson(ChatRoomModel data) => json.encode(data.toJson());

class ChatRoomModel {
  ChatRoomModel({
    required this.isRead,
    required this.msg,
    required this.msgType,
    required this.receiveById,
    required this.sendAt,
    required this.sendById,
  });

  int isRead;
  String msg;
  int msgType;
  int receiveById;
  Timestamp sendAt;
  int sendById;
  String docId = "";

  get time => DateFormat.Hm().format(sendAt.toDate());

  //12th September, 2022 06:30 PM
  //get time => DateFormat('dd MMMM yyyy').add_jm().format(sendAt.toDate());

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) => ChatRoomModel(
        isRead: json["is_read"] ?? 0,
        msg: json["msg"] ?? "",
        msgType: json["msg_type"] ?? 0,
        receiveById: json["receive_by_id"] ?? 0,
        sendAt: json["send_at"] ?? Timestamp.fromDate(DateTime(0)),
        sendById: json["send_by_id"] ?? 0,
      );

  factory ChatRoomModel.fromListJson(Map<String, dynamic> json) =>
      ChatRoomModel(
        isRead: json["is_read"] ?? 0,
        msg: json["msg"] ?? "",
        msgType: json["msg_type"] ?? 0,
        receiveById: json["receive_by_id"] ?? 0,
        sendAt: json["send_at"] ?? Timestamp.fromDate(DateTime(0)),
        sendById: json["send_by_id"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "is_read": isRead,
        "msg": msg,
        "msg_type": msgType,
        "receive_by_id": receiveById,
        "send_at": sendAt,
        "send_by_id": sendById,
      };
}
