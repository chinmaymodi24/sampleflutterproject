import 'package:core/styles/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class BottomBorderTextField extends StatelessWidget {
  final String? hint;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final TextInputType? textInputType;
  final int maxLine;
  final int? minLine;
  final int? maxLength;
  final bool? secureText;
  final Widget? suffixIcon;
  final Widget? preFixIcon;
  final Widget? preFix;
  final VoidCallback? suffixIconCallback;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;
  final bool obscureText;
  final GestureTapCallback? onTap;
  final ValueChanged? onFieldSubmitted;
  final ValueChanged? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final bool? readOnly;
  final bool? enabled;
  final BorderRadius? borderRadius;

  const BottomBorderTextField({
    Key? key,
    this.hint,
    this.controller,
    this.validator,
    this.textInputType,
    this.maxLine = 1,
    this.onTap,
    this.obscureText = false,
    this.readOnly,
    this.enabled,
    this.style,
    this.hintStyle,
    this.contentPadding,
    this.minLine,
    this.maxLength,
    this.secureText,
    this.suffixIcon,
    this.preFixIcon,
    this.preFix,
    this.suffixIconCallback,
    this.textInputAction,
    this.focusNode,
    this.inputFormatters,
    this.onFieldSubmitted,
    this.onChanged,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled ?? true,
      readOnly: readOnly ?? false,
      onTap: onTap,
      maxLength: maxLength,
      maxLines: maxLine,
      textInputAction: textInputAction,
      validator: validator,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      obscureText: obscureText,
      inputFormatters: inputFormatters,
      style: style ??
          const TextStyle(
            fontSize: 14.0,
            color: AppColors.adminHintFontColor,
          ),
      decoration: InputDecoration(
        hintStyle: hintStyle ??
            const TextStyle(
              color: AppColors.adminHintFontColor,
              fontSize: 14.0,
            ),
        hintText: hint,
        border: border(),
        disabledBorder: border(),
        errorBorder: errorBorder(),
        enabledBorder: border(),
        focusedBorder: border(),
        focusedErrorBorder: border(),
        counterText: "",
        //isDense: true,
        //filled: true,
        errorMaxLines: 2,
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12.0,
            ),
        //const EdgeInsets.only(left: 20,right:20.0, top: 8.0, bottom: 0),
        errorStyle: style ??
            const TextStyle(
              fontSize: 14.0,
              color: Color(0xFFABABAB),
            ),
        suffixIcon: suffixIcon,
        prefixIcon: preFixIcon,
        prefix: preFix,
      ),
      keyboardType: textInputType,
      controller: controller,
      cursorColor: Colors.black,
    );
  }

  UnderlineInputBorder errorBorder() {
    return UnderlineInputBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.red));
  }

  UnderlineInputBorder border() {
    return UnderlineInputBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Color(0xFFC4C4C4)));
  }
}
