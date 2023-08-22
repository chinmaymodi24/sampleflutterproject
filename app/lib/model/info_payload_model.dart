// To parse this JSON data, do
//
//     final infoModel = infoModelFromJson(jsonString);

import 'dart:convert';

InfoModel infoModelFromJson(String str) => InfoModel.fromJson(json.decode(str));

String infoModelToJson(InfoModel data) => json.encode(data.toJson());

class InfoModel {
  InfoModel({
    required this.user0,
    required this.user1,
    required this.displayName,
    required this.userProfileUrl,
  });

  int user0;
  int user1;
  String displayName;
  String userProfileUrl;

  factory InfoModel.fromJson(Map<String, dynamic> json) => InfoModel(
    user0: json["user[0]"],
    user1: json["user[1]"],
    displayName: json["displayName"],
    userProfileUrl: json["userProfileUrl"],
  );

  Map<String, dynamic> toJson() => {
    "user[0]": user0,
    "user[1]": user1,
    "displayName": displayName,
    "userProfileUrl": userProfileUrl,
  };
}
