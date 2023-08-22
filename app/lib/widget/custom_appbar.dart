import 'package:flutter/material.dart';
import 'package:sampleflutterproject/styles/app_colors.dart';
import 'package:sampleflutterproject/styles/app_themes.dart';
import 'package:get/get.dart';

class CustomAppBarWithBack extends StatelessWidget {
  final String title;
  final Function()? onTap;
  final List<Widget> actions;

  const CustomAppBarWithBack({
    Key? key,
    required this.title,
    required this.actions,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      toolbarHeight: 60.0,
      leadingWidth: 60.0,
      centerTitle: true,
      title: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: themes.light.textTheme.headlineMedium?.copyWith(
            fontSize: 19.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(top: 22.0, left: 22.0),
        child: Material(
          borderRadius: BorderRadius.circular(40.0),
          color: AppColors.getPrimary,
          child: InkWell(
            borderRadius: BorderRadius.circular(40.0),
            onTap:
                onTap ??
                () {
              Get.back();
            },
            child: const Center(
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      actions: actions,
    );
  }
}
