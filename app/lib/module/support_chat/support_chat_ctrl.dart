
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupportChatCtrl extends GetxController {
  /*List<String> userNameList = [
    "Josh Smith",
    "Nancy Anderson",
    "Neeraj Gupta",
    "Bella Milevski",
    "Junior Keita",
  ];

  List<String> msgList = [
    "Curabitur laoreet dignissim nibh nec vehicula",
    "dignissim nibh nec vehicula",
    "molestie interdum bibendum",
    "vitae quam",
    "finibus felis non orci",
  ];

  List<String> chatList = [
    "Lorem ipsum",
    "consectetur adipiscing elit.",
    "Lorem ipsum dolor sit",
    "hey Victoria ",
    "hello, Josh",
  ];

  List<String> timeList = [
    "08:15",
    "08:16",
    "08:19",
    "08:20",
    "08:25",
  ];*/

  // RxList<SupportChatModel> chatList = <SupportChatModel>[].obs;
  // Stream<QuerySnapshot<Map<String, dynamic>>>? supportSteram;
  RxBool isLoading = true.obs;

  final TextEditingController chatCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // init() async {
  //   supportSteram = SupportChatQuery()
  //       .getSupportStream(createdChatId: app.userModel.value.id.toString());
  //   supportSteram?.listen((event) async {
  //     chatList.value =
  //         event.docs.map((e) => SupportChatModel.fromJson(e.data())).toList();
  //     await SupportChatQuery()
  //         .supportChat
  //         .doc(app.userModel.value.id.toString())
  //         .update({
  //       "unread_count": 0,
  //     });
  //     isLoading.value = false;
  //     logger.i('VALUE UPDATED SUCCESSFULLY');
  //   });
  // }

  @override
  void onInit() {
    // init();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
