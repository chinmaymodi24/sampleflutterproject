import 'package:core/backend/auth_service.dart';
import 'package:core/model/admin_chat_list_model.dart';
import 'package:core/model/user_model.dart';
import 'package:get/get.dart';

class ChatListCtrl extends GetxController {
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
  ];*/

  Map<int, UserModel> cashesU = {};
  Rx<AdminChatListModel> adminChatModel = AdminChatListModel.fromEmpty().obs;

  // RxString supportChatLastMsg = "".obs;
  // RxInt supportUnreadCount = 0.obs;
  // RxInt supportLastMsgBy = 0.obs;

  Future<UserModel> getUserDetail({required int id}) async {
    var r = cashesU[id];
    if (r is UserModel) {
      return r;
    }
    var res = await AuthService.getProfile({
      "id": id,
    });

    if (res.isValid) {
      cashesU.addAll({id: res.r!});
      return res.r!;
    } else {
      return UserModel.fromEmpty();
    }
  }

  // @override
  // void onInit() {
  //   SupportChatQuery()
  //       .supportChat
  //       .doc("${app.userModel.value.id}")
  //       .snapshots()
  //       .listen((event) {
  //     if (event.data() != null) {
  //       adminChatModel.value = AdminChatListModel.fromJson(event.data()!, '');
  //       logger.i(adminChatModel.toJson(), 'Admin_model');
  //
  //       // supportChatLastMsg.value = event.data()!["last_msg"];
  //       // supportUnreadCount.value = event.data()!["unread_count"];
  //       // supportLastMsgBy.value = event.data()!["last_msg_by"];
  //     }
  //   });
  //   super.onInit();
  // }
}
