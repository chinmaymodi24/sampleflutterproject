import 'package:flutter/material.dart';

class CommonContainer extends StatelessWidget {
  final Widget child;
  final BorderRadius? borderRadius;
  final Color? color;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Function()? onTap;
  final List<BoxShadow>? boxShadow;

  CommonContainer({
    Key? key,
    required this.child,
    this.borderRadius,
    this.color,
    this.width,
    this.height,
    this.padding,
    this.onTap,
    this.boxShadow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        boxShadow: boxShadow,
        //color: color ?? const Color(0xFFFBFBFB),
        borderRadius: borderRadius ?? BorderRadius.circular(18.0),     ),
      child: Material(
        color: color,
        borderRadius: borderRadius ?? BorderRadius.circular(18.0),
        child: InkWell(
            borderRadius: borderRadius ?? BorderRadius.circular(18.0),
            onTap: onTap,
            child: Padding(
              padding: padding ??
                  const EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 17.0,
                  ),
              child: child,
            )),
      ),
    );
  }
}
