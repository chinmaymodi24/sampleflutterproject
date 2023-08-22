import 'package:admin/app/app_repo.dart';
import 'package:admin/module/chat/admin_chat.dart';
import 'package:admin/module/dashboard/dashboard.dart';
import 'package:admin/module/notification/notification.dart';
import 'package:admin/module/reports/reports.dart';
import 'package:admin/module/user/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/constants.dart';
import 'home_ctrl.dart';
import 'home_drawer.dart';

class Home extends StatelessWidget {
  final ctrl = Get.put(HomeCtrl());
  final List pages = [
    Dashboard(),
    User(),
    Chat(),
    NotificationPage(),
    Reports(),
    //const AppSettings(),
  ];

  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.d('User id :${app.userModel().toJson()}');
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Home Drawer
          Expanded(
            flex: 2,
            child: HomeDrawer(),
          ),
          Expanded(
            flex: 10,
            child: Container(
              color: const Color(0xFFF1F4FA),
              //padding: const EdgeInsets.fromLTRB(22.0, 30.0, 22.0, 20.0),
              child: Obx(
                () => pages[ctrl.isSelected.value],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
