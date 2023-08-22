import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sampleflutterproject/module/notification/notification_ctrl.dart';
import 'package:sampleflutterproject/styles/app_colors.dart';
import 'package:sampleflutterproject/styles/app_themes.dart';
import 'package:sampleflutterproject/widget/common_container.dart';
import 'package:sampleflutterproject/widget/custom_appbar.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatelessWidget {
  final ctrl = Get.put(NotificationCtrl());

  NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldGradientBackground(
      extendBody: true,
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white,
          Color(0xFFD1E2FF),
        ],
      ),
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 70.0),
        child: CustomAppBarWithBack(
          title: "notifications".tr,
          actions: [],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ctrl.getAllNotificationList();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 6.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Obx(() {
                return ctrl.isLoading.value
                    ? const Expanded(
                        child: Center(
                          child: CupertinoActivityIndicator(
                            color: AppColors.getPrimary,
                          ),
                        ),
                      )
                    : ctrl.list.isNotEmpty
                        ? Expanded(
                            child: ListView.separated(
                                physics: const BouncingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics(),
                                ),
                                itemCount: ctrl.list.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return CommonContainer(
                                    borderRadius: BorderRadius.circular(14.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${"loan_amount".tr}: ${ctrl.list[index].borrowAmount}",
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        Text(
                                          "${ctrl.list[index].title}${ctrl.list[index].body}",
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            color: Color(0xFF595959),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8.0,
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            DateFormat('yyyy-MM-dd')
                                                .format(
                                                    ctrl.list[index].createdAt)
                                                .toString(),
                                            style: const TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10.0));
                                }),
                          )
                        : Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics()),
                              child: SizedBox(
                                height: context.height * 0.7,
                                child: Center(
                                  child: Text(
                                    "no_notification_found".tr,
                                    textAlign: TextAlign.center,
                                    style: themes.light.textTheme.headlineSmall
                                        ?.copyWith(
                                      color: const Color(0xFF8B8B8B),
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
              }),
              const SizedBox(height: 10.0),

              // Obx(() {
              //   return Expanded(
              //     child:
              //     ctrl.isLoading.value
              //         ? const Center(
              //             child: CupertinoActivityIndicator(
              //               color: AppColors.getPrimary,
              //             ),
              //           ) :
              //     ctrl.list.isEmpty
              //         ? Expanded(
              //       child: SingleChildScrollView(
              //         physics: const BouncingScrollPhysics(
              //             parent: AlwaysScrollableScrollPhysics()),
              //         child: SizedBox(
              //           height: context.height * 0.7,
              //           child: Center(
              //             child: Text(
              //               "no_notification_found".tr,
              //               textAlign: TextAlign.center,
              //               style: themes.light.textTheme.headlineSmall
              //                   ?.copyWith(
              //                 color: const Color(0xFF8B8B8B),
              //                 fontSize: 15.0,
              //                 fontWeight: FontWeight.w700,
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //     )
              //         : Expanded(
              //           child: ListView.separated(
              //               physics: const BouncingScrollPhysics(
              //                 parent: AlwaysScrollableScrollPhysics(),
              //               ),
              //               itemCount: ctrl.list.length,
              //               itemBuilder: (BuildContext context, int index) {
              //                 return CommonContainer(
              //                   borderRadius: BorderRadius.circular(14.0),
              //                   child: Column(
              //                     mainAxisAlignment: MainAxisAlignment.start,
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     children: [
              //                       Text(
              //                         "${"loan_amount".tr}: ${ctrl.list[index].borrowAmount}",
              //                         style: const TextStyle(
              //                           fontSize: 16.0,
              //                           color: Colors.black,
              //                           fontWeight: FontWeight.w600,
              //                         ),
              //                       ),
              //                       const SizedBox(height: 4.0),
              //                       Text(
              //                         "${ctrl.list[index].title}${ctrl.list[index].body}",
              //                         style: const TextStyle(
              //                           fontSize: 16.0,
              //                           color: Color(0xFF595959),
              //                           fontWeight: FontWeight.w400,
              //                         ),
              //                       ),
              //                       const SizedBox(height: 8.0,),
              //                       Align(
              //                         alignment: Alignment.centerRight,
              //                         child: Text(
              //                         DateFormat('yyyy-MM-dd').format(ctrl.list[index].createdAt).toString(),
              //                           style: const TextStyle(
              //                             fontSize: 12.0,
              //                             color: Colors.grey,
              //                             fontWeight: FontWeight.w400,
              //                           ),
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                 );
              //               },
              //               separatorBuilder: (BuildContext context, int index) {
              //                 return const Padding(
              //                     padding: EdgeInsets.symmetric(vertical: 10.0));
              //               }),
              //         ),
              //   );
              // }),
            ],
          ),
        ),
      ),
    );
  }
}
