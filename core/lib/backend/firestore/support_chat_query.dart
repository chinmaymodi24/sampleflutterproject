// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:core/backend/firestore/keys/collection_keys.dart';
// import 'package:core/model/support_chat_model.dart';
// import 'package:core/styles/app_themes.dart';
// import 'package:get/get.dart';
//
// class  SupportChatQuery {
//   CollectionReference<Map<String, dynamic>> supportChat =
//       FirebaseFirestore.instance.collection(FirebaseCollectionKeys.support);
//
//   /*Stream<QuerySnapshot> getChatList() {
//     return supportChat
//         .where("user_id", arrayContains: appModels.userModel.value.userDetails.id)
//         .snapshots();
//   }*/
//
//   Stream<QuerySnapshot> getUserList() {
//     return supportChat.orderBy("sendAt", descending: true).snapshots();
//     //   .listen((event) {
//     // tempList.value =
//     //     event.docs.map((e) => SupportChatModel.fromJson(e.data())).toList();
//     // log("tempList.value ==> ${tempList.length}");
//   }
//   Stream<QuerySnapshot<Map<String, dynamic>>> getSupportStream({required String createdChatId}) {
//     return supportChat
//         .doc(createdChatId)
//         .collection(FirebaseCollectionKeys.supportChat)
//         .orderBy("sendAt", descending: true)
//         .snapshots();
//   }
//
//   Future<RxList<SupportChatModel>> getChatDetail(
//       {required String createdChatId}) async {
//     RxList<SupportChatModel> tempList = <SupportChatModel>[].obs;
//
//     try {
//       supportChat
//           .doc(createdChatId)
//           .collection(FirebaseCollectionKeys.supportChat)
//           .orderBy("sendAt", descending: true)
//           .snapshots()
//           .listen((event) {
//         tempList.value =
//             event.docs.map((e) => SupportChatModel.fromJson(e.data())).toList();
//
//         if(tempList.isNotEmpty)
//           {
//             for (var data in tempList) {
//               data.msg;
//
//               // logger.v(
//               //     'Message :${data.msg} \nDate: ${data.sendAt.toDate().toIso8601String()}');
//             }
//           }else
//             {
//               tempList.value = [];
//             }
//
//
//         //log("tempList.value ==> ${tempList.length}");
//       });
//       return tempList;
//     } catch (e) {
//       logger.i(e);
//       return tempList;
//     }
//   }
//
//   Future adminSendMsg({
//     required String uid,
//     required String lastMsg,
//     required int msgType,
//     required int userId,
//     required bool isExist,
//   }) async {
//     try {
//       if (!isExist) {
//         await supportChat.doc(uid).set({
//           "last_msg": lastMsg,
//           "msg": lastMsg,
//           "last_msg_by": userId,
//           "msg_type": msgType,
//           "sendAt": Timestamp.now(),
//           "unread_count_user": FieldValue.increment(1),
//         });
//       } else {
//         await supportChat.doc(uid).update({
//           "last_msg": lastMsg,
//           "msg": lastMsg,
//           "last_msg_by": userId,
//           "msg_type": msgType,
//           "sendAt": Timestamp.now(),
//           "unread_count_user": FieldValue.increment(1),
//           //"user_id": userId,
//         });
//       }
//      await supportChat.doc(uid).collection(FirebaseCollectionKeys.supportChat).add({
//         "isRead": 1,
//         "msg": lastMsg,
//         "msgType": 1,
//         "sendById": userId,
//         "sendAt": Timestamp.now(),
//         "last_msg_by": userId,
//       });
//     } catch (e) {
//       logger.e('SOMETHING WENT WRONG \n $e');
//     }
//   }
//
//   Future sendMsg({
//     required String uid,
//     required String lastMsg,
//     required int msgType,
//     required int userId,
//   }) async {
//     try {
//       try {
//         await supportChat.doc(uid).update({
//           "last_msg": lastMsg,
//           "last_msg_by": userId,
//           "msg_type": msgType,
//           "sendAt": Timestamp.now(),
//           "unread_count_admin": FieldValue.increment(1),
//           "user_id": userId,
//         });
//       } catch (e) {
//         await supportChat.doc(uid).set({
//           "last_msg": lastMsg,
//           "last_msg_by": userId,
//           "msg_type": msgType,
//           "sendAt": Timestamp.now(),
//           "unread_count_admin": FieldValue.increment(1),
//           "user_id": userId,
//         });
//       }
//
//       supportChat.doc(uid).collection(FirebaseCollectionKeys.supportChat).add({
//         "isRead": 1,
//         "msg": lastMsg,
//         "msgType": 1,
//         "sendById": userId,
//         "sendAt": Timestamp.now(),
//         "last_msg_by": userId,
//       });
//     } catch (e) {
//       logger.i("sendMsg $e");
//     }
//   }
// }
