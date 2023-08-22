import 'package:flutter/material.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';

class CustomScaffold extends StatelessWidget {
  final Widget child;
  final Widget? bottomNavigationBar;
  final PreferredSize? appBar;

  CustomScaffold({
    Key? key,
    required this.child,
    this.bottomNavigationBar,
    this.appBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldGradientBackground(
      bottomNavigationBar: bottomNavigationBar ?? SizedBox(),
      extendBody: true,
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white,
          Color(0xFFD1E2FF),
        ],
      ),
      appBar: appBar ?? const PreferredSize(
        preferredSize: Size(double.infinity, 70.0),
        child: SizedBox(),
      ),
      body: child,
    );
  }
}
