import 'package:flutter/material.dart';
import 'package:sampleflutterproject/widget/custom_appbar.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import "package:get/get.dart";
import 'package:webview_flutter/webview_flutter.dart';

class CustomWebView extends StatelessWidget {
  final String titleName;
  final String url;

  const CustomWebView({
    Key? key,
    required this.titleName,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldGradientBackground(
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
          title: titleName,
          actions: [],
        ),
      ),
      body: WebView(
        backgroundColor: Colors.white,
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
