import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../styles/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final double? fontSize;
  final bool isLoading;
  final TextBaseline? textBaseline;
  final Color? color;
  final TextAlign? textAlign;
  final VoidCallback onPressed;
  final Color? primaryColor;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsets? padding;

  const CustomButton({
    Key? key,
    this.isLoading = false,
    required this.text,
    this.fontSize,
    this.textBaseline,
    this.color = Colors.white,
    this.textAlign = TextAlign.center,
    required this.onPressed,
    this.primaryColor,
    this.padding,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      //height: 110.0,
      decoration: BoxDecoration(
        color: primaryColor ?? AppColors.getPrimary,
        //color: Colors.deepPurple.shade300,
        borderRadius: borderRadius ?? BorderRadius.circular(10.0),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          padding: padding ??
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius?? BorderRadius.circular(10.0),
          ),
        ),
        onPressed: onPressed,
        child: isLoading
            ? const CupertinoActivityIndicator(
                color: Colors.white,
                //size: 20.0,
              )
            //CupertinoActivityIndicator()
            : Text(
                text,
                style: TextStyle(
                  color: color,
                  //fontFamily: GoogleFonts.anekDevanagari().fontFamily,
                  fontSize: fontSize ?? 15.0,
                  //height: 1.0,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.7,
                ),
                textAlign: TextAlign.center,
                //fontFamily: "NeueMontreal-Regular",
                //fontWeight: FontWeight.w600,
              ),
      ),
    );


  }
}
