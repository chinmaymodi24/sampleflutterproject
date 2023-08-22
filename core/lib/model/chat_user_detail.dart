import 'dart:convert';

ChatUserDetail chatUserDetailFromJson(String str) =>
    ChatUserDetail.fromJson(json.decode(str));

String chatUserDetailToJson(ChatUserDetail data) => json.encode(data.toJson());

class ChatUserDetail {
  ChatUserDetail({
    this.id = 0,
    this.name = "",
    this.nickname = "",
    this.profileImg = "",
  });

  int id;
  String name;
  String nickname;
  String profileImg;

  factory ChatUserDetail.fromJson(Map<String, dynamic> json) => ChatUserDetail(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        nickname: json["nickname"] ?? "",
        profileImg: json["profile_img"] ?? "",
      );

  factory ChatUserDetail.fromEmpty() => ChatUserDetail(
        id: 0,
        name: "",
        nickname: "",
        profileImg: "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "nickname": nickname,
        "profile_img": profileImg,
      };
}