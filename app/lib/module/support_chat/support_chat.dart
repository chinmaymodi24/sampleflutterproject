// import 'package:core/backend/firestore/support_chat_query.dart';
// import 'package:core/model/support_chat_model.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:sampleflutterproject/app/app_repo.dart';
// import 'package:sampleflutterproject/module/support_chat/support_chat_ctrl.dart';
// import 'package:sampleflutterproject/styles/app_assets.dart';
// import 'package:sampleflutterproject/styles/app_colors.dart';
// import 'package:get/get.dart';
// import 'package:sampleflutterproject/widget/custom_filled_textfield.dart';
// import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class SupportChat extends StatelessWidget {
//   final ctrl = Get.put(SupportChatCtrl());
//   SupportChat({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ScaffoldGradientBackground(
//       extendBody: true,
//       gradient: const LinearGradient(
//         begin: Alignment.topCenter,
//         end: Alignment.bottomCenter,
//         colors: [
//           Colors.white,
//           Color(0xFFD1E2FF),
//         ],
//       ),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         toolbarHeight: 60.0,
//         leadingWidth: 60.0,
//         leading: IconButton(
//           onPressed: () {
//             Get.back();
//           },
//           icon: const Icon(
//             Icons.arrow_back_ios,
//             color: Color(0xFF1C274C),
//             size: 24.0,
//           ),
//         ),
//         actions: const [
//           /*Padding(
//             padding: EdgeInsets.only(right: 18.0),
//             child: Icon(
//               color: Color(0xFFD9D9D9),
//               size: 20.0,
//               Icons.more_vert,
//             ),
//           ),*/
//         ],
//         centerTitle: true,
//         title: const Text(
//           "Customer Care",
//           style: TextStyle(
//             fontWeight: FontWeight.w500,
//             fontSize: 20.0,
//             color: Colors.black,
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: SupportChatQuery().getSupportStream(
//                   createdChatId: app.userModel.value.id.toString()),
//               builder: (BuildContext context,
//                   AsyncSnapshot<QuerySnapshot> snapshot) {
//                 List<SupportChatModel> chatList;
//                 if (snapshot.data != null) {
//                   chatList = snapshot.data!.docs
//                       .map((e) => SupportChatModel.fromJson(
//                           e.data() as Map<String, dynamic>))
//                       .toList();
//
//                   // /// remove count
//                   // SupportChatQuery()
//                   //     .supportChat
//                   //     .doc(app.userModel.value.id.toString())
//                   //     .update({"unread_count_user": 0});
//
//                   return ListView.builder(
//                       reverse: true,
//                       itemCount: chatList.length,
//                       physics: const BouncingScrollPhysics(),
//                       itemBuilder: (BuildContext context, int index) {
//                         return chatList[index].sendById ==
//                                 app.userModel.value.id
//                             ? ChatRightLayout(
//                                 msg: chatList[index].msg,
//                                 time: chatList[index].time,
//                               )
//                             : ChatLeftLayout(
//                                 msg: chatList[index].msg,
//                                 time: chatList[index].time,
//                               );
//                       });
//                 } else {
//                   return const Center(
//                     child: CupertinoActivityIndicator(
//                       color: AppColors.getPrimary,
//                     ),
//                   );
//                 }
//               },
//             ),
//           ),
//           const SizedBox(height: 10.0),
//           const Divider(
//             height: 1,
//             color: AppColors.dividerColor,
//             thickness: 1.5,
//           ),
//           FilledTextField(
//             hint: "Type Your Message here",
//             borderRadius: BorderRadius.circular(0.0),
//             contentPadding: const EdgeInsets.only(
//                 right: 50.0, left: 20.0, top: 8.0, bottom: 8.0),
//             controller: ctrl.chatCtrl,
//             hintStyle: const TextStyle(
//               fontSize: 14.0,
//               color: AppColors.chatFontColor,
//               fontWeight: FontWeight.w500,
//             ),
//             style: const TextStyle(
//               fontSize: 14.0,
//               color: AppColors.chatFontColor,
//               fontWeight: FontWeight.w500,
//             ),
//             suffixIcon: InkWell(
//               onTap: () {
//                 if (ctrl.chatCtrl.text.isNotEmpty) {
//                   String msg = ctrl.chatCtrl.text;
//                   ctrl.chatCtrl.clear();
//                   SupportChatQuery().sendMsg(
//                     uid: app.userModel.value.id.toString(),
//                     lastMsg: msg,
//                     msgType: 1,
//                     userId: app.userModel.value.id,
//                   );
//                 }
//               },
//               child: Image.asset(
//                 AppAssets.chatSend,
//                 width: 10.0,
//                 height: 10.0,
//                 fit: BoxFit.cover,
//               ).paddingAll(6.0).paddingOnly(right: 4.0),
//             ),
//           ),
//           const Divider(
//             height: 1,
//             color: AppColors.dividerColor,
//             thickness: 1.5,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class ChatLeftLayout extends StatelessWidget {
//   final String time;
//   final String msg;
//
//   const ChatLeftLayout({
//     Key? key,
//     required this.time,
//     required this.msg,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 4.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             padding:
//                 //const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//                 const EdgeInsets.only(
//                     left: 14.0, right: 14.0, top: 10.0, bottom: 8.0),
//             decoration: const BoxDecoration(
//               color: AppColors.darkBlue,
//               borderRadius: BorderRadius.only(
//                 topRight: Radius.circular(12.0),
//                 bottomRight: Radius.circular(12.0),
//                 topLeft: Radius.circular(12.0),
//                 bottomLeft: Radius.circular(0.0),
//               ),
//             ),
//             child: ConstrainedBox(
//               constraints: const BoxConstraints(
//                 minWidth: 10,
//                 maxWidth: 180,
//               ),
//               child: SelectableText(
//                 msg,
//                 style: const TextStyle(
//                   height: 1.2,
//                   fontSize: 15.0,
//                   color: AppColors.darkTextColor,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 8.0),
//           Text(
//             time,
//             style: const TextStyle(
//               fontSize: 11.0,
//               color: AppColors.lightTextColor,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class ChatRightLayout extends StatelessWidget {
//   final String time;
//   final String msg;
//
//   const ChatRightLayout({
//     Key? key,
//     required this.time,
//     required this.msg,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 4.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.end,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             padding:
//                 //const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//                 const EdgeInsets.only(
//                     left: 14.0, right: 14.0, top: 10.0, bottom: 8.0),
//             decoration: const BoxDecoration(
//               color: AppColors.getPrimary,
//               borderRadius: BorderRadius.only(
//                 topRight: Radius.circular(12.0),
//                 bottomRight: Radius.circular(0.0),
//                 topLeft: Radius.circular(12.0),
//                 bottomLeft: Radius.circular(12.0),
//               ),
//             ),
//             child: ConstrainedBox(
//               constraints: const BoxConstraints(
//                 minWidth: 10,
//                 maxWidth: 200,
//               ),
//               child: SelectableText(
//                 msg,
//                 style: const TextStyle(
//                   height: 1.2,
//                   fontSize: 15.0,
//                   color: AppColors.darkTextColor,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 8.0),
//           Text(
//             time,
//             style: const TextStyle(
//               fontSize: 11.0,
//               color: AppColors.lightTextColor,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
