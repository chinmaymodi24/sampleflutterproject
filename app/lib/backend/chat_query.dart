// import 'dart:async';
// import 'dart:developer';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:core/styles/app_themes.dart';
// import 'package:sampleflutterproject/app/app_repo.dart';
// import 'package:sampleflutterproject/model/chatroom_model.dart';
// import 'firestore/collection_keys.dart';
// import 'package:get/get.dart';
//
// class ChatQuery  {
//   int localNotificationChatId = 0;
//   CollectionReference<Map<String, dynamic>> usersChatroom =
//       FirebaseFirestore.instance.collection(FirebaseCollectionKeys.chat);
//
//   Stream<QuerySnapshot> getChatList() {
//     return usersChatroom
//         .where("users", arrayContains: app.userModel.value.id)
//         .orderBy("send_at", descending: true)
//         .snapshots();
//   }
//
//   Stream<QuerySnapshot<Map<String, dynamic>>> getChatStream(
//       {required String createdChatId}) {
//     return usersChatroom
//         .doc(createdChatId)
//         .collection(FirebaseCollectionKeys.conversation)
//         .orderBy("send_at", descending: true)
//         .snapshots();
//   }
//
//   Future<Stream<DocumentSnapshot<Map<String, dynamic>>>> getChat(
//       {required String id}) async {
//     return usersChatroom.doc(id).snapshots();
//   }
//
//   // Future<RxList<ChatRoomModel>> getChatDetail(
//   //     {required String createdChatId}) async {
//   //   RxList<ChatRoomModel> t = <ChatRoomModel>[].obs;
//   //   try {
//   //     usersChatroom
//   //         .doc(createdChatId)
//   //         .collection(FirebaseCollectionKeys.conversation)
//   //         .orderBy("send_at", descending: true)
//   //         .snapshots()
//   //         .listen((event) async {
//   //       if (event.docs.isNotEmpty) {
//   //         log("p0.isNotEmpty");
//   //         log("p0.last.sendById = ${event.docs.first.data()}");
//   //         log("appModels.userModel.value.userDetails.id = ${app.userModel.value.id}");
//   //
//   //         if (event.docs.first.data()["send_by_id"] == app.userModel.value.id) {
//   //           try {
//   //             logger
//   //                 .e("send_by_id => ${event.docs.first.data()["send_by_id"]} &"
//   //                     "\n userId => ${app.userModel.value.id} in if");
//   //
//   //             await ChatQuery().usersChatroom.doc(createdChatId).update({
//   //               "unread_count_user1": 0,
//   //             });
//   //           } catch (e) {
//   //             logger.e("e =>>> $e");
//   //           }
//   //         }
//   //         if (event.docs.first.data()["send_by_id"] != app.userModel.value.id) {
//   //           try {
//   //             logger
//   //                 .e("send_by_id => ${event.docs.first.data()["send_by_id"]} &"
//   //                     "\n userId => ${app.userModel.value.id} in if =!");
//   //
//   //             await ChatQuery().usersChatroom.doc(createdChatId).update({
//   //               "unread_count_user2": 0,
//   //             });
//   //           } catch (e) {
//   //             logger.e("e =>>> $e");
//   //           }
//   //         }
//   //         t.value = event.docs
//   //             .map((e) => ChatRoomModel.fromJson(
//   //                   e.data(),
//   //                 ))
//   //             .toList()
//   //             .obs;
//   //         //log("tempList.value ==> ${tempList.length}");
//   //       } else {
//   //         t.value = [];
//   //       }
//   //     });
//   //     return t;
//   //   } catch (e) {
//   //     logger.i(e);
//   //     return t;
//   //   }
//   // }
//
//   Future sendMsg(
//       {required String uid,
//       required String lastMsg,
//       required int msgType,
//       required List<int> users,
//       required bool isExist}) async {
//     try {
//       Map<String, dynamic> unreadCount = {};
//       for (var user in users) {
//         if (user == app.userModel().id) {
//           unreadCount.addAll({"$user": 0});
//         } else {
//           unreadCount.addAll({"$user": FieldValue.increment(1)});
//         }
//       }
//
//       var res = await usersChatroom.doc(uid).get();
//       if (res.exists) {
//         usersChatroom.doc(uid).update({
//           "last_msg": lastMsg,
//           "last_msg_by": app.userModel.value.id,
//           "msg_type": msgType,
//           "unread_count": unreadCount,
//           "send_at": Timestamp.now(),
//           // "unread_count_user1": FieldValue.increment(1),
//         });
//       } else {
//         usersChatroom.doc(uid).set({
//           "last_msg": lastMsg,
//           "last_msg_by": app.userModel.value.id,
//           "msg_type": msgType,
//           "unread_count": unreadCount,
//           "send_at": Timestamp.now(),
//           // "unread_count_user1": FieldValue.increment(1),
//           "users": users,
//         });
//       }
//
//       usersChatroom
//           .doc(uid)
//           .collection(FirebaseCollectionKeys.conversation)
//           .add({
//         "is_read": 1,
//         "msg": lastMsg,
//         "msg_type": 1,
//         "send_by_id": app.userModel.value.id,
//         "send_at": Timestamp.now(),
//         "last_msg_by": app.userModel.value.id,
//       });
//     } catch (e, t) {
//       logger.i("sendMsg $e \n Trace :${t}");
//     }
//   }
// }
