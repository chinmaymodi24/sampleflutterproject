import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminChatListModel {
  AdminChatListModel({
     required this.lastMsg,
     required this.lastMsgBy,
     required this.msgType,
     required this.sendAt,
     required this.unreadCountAdmin,
     required this.unreadCountUser,
     required this.userId,
      this.docId = "",
  });
  String docId = "";

  String lastMsg;
  int lastMsgBy;
  int msgType;
  Timestamp sendAt;
  int unreadCountAdmin;
  int unreadCountUser;
  int userId;
  String name = "";

  get time => DateFormat.Hm().format(sendAt.toDate());

  factory AdminChatListModel.fromJson(Map<String, dynamic> json,String docId) => AdminChatListModel(
    lastMsg: json["last_msg"] ?? "",
    lastMsgBy: json["last_msg_by"] ?? 0,
    msgType: json["msg_type"] ?? 0,
    userId: json["user_id"] ?? 0,
    sendAt: json["sendAt"] ?? Timestamp.fromDate(DateTime(0)),
    unreadCountAdmin: json["unread_count_admin"] ?? 0,
    unreadCountUser: json["unread_count_user"] ?? 0,
    docId: docId??"",
  );

  factory AdminChatListModel.fromEmpty() => AdminChatListModel(
    lastMsg: "",
    lastMsgBy: 0,
    msgType: 0,
    userId: 0,
    sendAt:Timestamp.fromDate(DateTime.now()),
    unreadCountAdmin: 0,
    unreadCountUser: 0,
  );

  factory AdminChatListModel.fromError() => AdminChatListModel(
    lastMsg: "",
    lastMsgBy: 0,
    msgType: 0,
    userId: 0,
    sendAt:Timestamp.fromDate(DateTime.now()),
    unreadCountAdmin: 0,
    unreadCountUser: 0,
  );

  Map<String, dynamic> toJson() => {
    "last_msg": lastMsg,
    "last_msg_by": lastMsgBy,
    "msg_type": msgType,
    "user_id": userId,
    "sendAt": sendAt,
    "unread_count_admin": unreadCountAdmin,
    "unread_count_user": unreadCountUser,
  };
}
