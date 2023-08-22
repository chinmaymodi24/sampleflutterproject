import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

ConversationModel conversationModelFromJson(String str) =>
    ConversationModel.fromJson(json.decode(str));

String conversationModelToJson(ConversationModel data) =>
    json.encode(data.toJson());

enum Role {
  support,
  customer,
}

Role intToRole(int role) {
  var r = Role.values.where((element) => element.index == role);
  if (r.isNotEmpty) {
    return r.first;
  } else {
    return Role.support;
  }
}

class ConversationModel {
  ConversationModel(
      {required this.createdAt,
      required this.message,
      required this.chatId,
      required this.toId,
      required this.fromId,
      required this.type,
      required this.role,
      this.documentReference,
      this.replayDocRef,
      this.deleted = const {}});

  DateTime createdAt;
  String message;
  int chatId;
  int toId;
  int fromId;
  int type;
  Role role;
  Map<String, dynamic> deleted;

  bool isDeleteForMe(int id) {
    return deleted["$id"] == 1;
  }

  bool get isDeleteForEveryOne {
    return deleted.entries.where((element) => element.value == 1).length == 2;
  }

  DocumentReference? documentReference;
  DocumentReference? replayDocRef;

  factory ConversationModel.fromJson(Map<String, dynamic> json,
          {DocumentReference? reference}) =>
      ConversationModel(
        createdAt: json["created_at"] != null? (json["created_at"] as Timestamp).toDate()
            : DateTime(0),
        message: json["message"] ?? "",
        chatId: json["chat_id"] ?? 0,
        toId: json["to_id"] ?? 0,
        fromId: json["from_id"] ?? 0,
        role: intToRole(json["role"] ?? 0),
        type: json["type"] ?? 1,
        documentReference: reference,
        replayDocRef: json["replay_doc_ref"],
        deleted: json["deleted"] ?? <String, int>{},
      );

  Map<String, dynamic> toJson() => {
        "created_at":
            createdAt.year == 0 ? null : Timestamp.fromDate(createdAt),
        "message": message,
        "chat_id": chatId,
        "to_id": toId,
        "from_id": fromId,
        "type": type,
        "role": role.index,
    "replay_doc_ref": replayDocRef,
        "deleted": deleted
      };

  Map<String, dynamic> toJsonSupport() => {
        "created_at":
            createdAt.year == 0 ? null : Timestamp.fromDate(createdAt),
        "message": message,
        "chat_id": chatId,
        "to_id": toId,
        "from_id": fromId,
        "type": type,
      };
}
