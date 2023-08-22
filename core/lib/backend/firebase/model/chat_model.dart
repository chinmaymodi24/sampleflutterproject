// To parse this JSON data, do
//
//     final chatModel = chatModelFromJson(jsonString);

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

ChatModel chatModelFromJson(String str) => ChatModel.fromJson(json.decode(str));

String chatModelToJson(ChatModel data) => json.encode(data.toJson());

class ChatModel {
  ChatModel({
    required this.chatId,
    required this.createdAt,
    required this.updatedAt,
    required this.updatedBy,
    required this.lastMessage,
    required this.unreadCount,
    required this.users,
    required this.allUsers,
    required this.type,
    this.lastMsgRef,
    this.deleteChatAt,
  });

  int chatId;
  DateTime createdAt;
  DateTime updatedAt;
  int updatedBy;
  String lastMessage;
  int unreadCount;
  List<int> users;
  List<int> allUsers;
  int type;
  DocumentReference? lastMsgRef;
  Map<String,dynamic>? deleteChatAt;

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        chatId: json["reference_id"] ?? 0,
        createdAt: json["created_at"] != null
            ? (json["created_at"] as Timestamp).toDate()
            : DateTime(0),
        updatedAt: json["updated_at"] != null
            ? (json["updated_at"] as Timestamp).toDate()
            : DateTime(0),
        updatedBy: json["updated_by"] ?? 0,
        lastMessage: json["lastMessage"] ?? "",
        unreadCount: json["unread_count"] ?? 0,
        users: json["users"] == null
            ? []
            : List<int>.from(json["users"].map((x) => x)),
    allUsers: json["all_users"] == null
            ? []
            : List<int>.from(json["all_users"].map((x) => x)),
        type: json["type"] ?? 0,
        lastMsgRef: json["last_msg_ref"],
        deleteChatAt: json["delete_chat_at"] is Map<String,dynamic> ?  json["delete_chat_at"]:<String,dynamic>{},
      );

  Map<String, dynamic> toJson() => {
        "reference_id": chatId,
        "created_at":
            createdAt.year == 0 ? null : Timestamp.fromDate(createdAt),
        "updated_at":
            updatedAt.year == 0 ? null : Timestamp.fromDate(updatedAt),
        "updated_by": updatedBy,
        "lastMessage": lastMessage,
        "unread_count": unreadCount,
        "users": List<dynamic>.from(users.map((x) => x)),
        "all_users": List<dynamic>.from(allUsers.map((x) => x)),
        "type": type,
        "last_msg_ref": lastMsgRef,
      };
}
