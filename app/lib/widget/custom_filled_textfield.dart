import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:sampleflutterproject/styles/app_colors.dart';

class FilledTextField extends StatelessWidget {
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
  final Color? filledColor;
  final BorderRadius? borderRadius;
  final bool? autoFocus;

  const FilledTextField({
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
    this.filledColor,
    this.borderRadius,
    this.autoFocus,
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
            fontSize: 16.0,
            color: AppColors.lightTextColor,
          ),
      decoration: InputDecoration(
        hintStyle: hintStyle ??
            const TextStyle(
              color: AppColors.textFieldHintColor,
              fontSize: 16.0,
            ),
        fillColor: filledColor ?? AppColors.textFieldColor,
        hintText: hint,
        border: border(),
        disabledBorder: border(),
        errorBorder: errorBorder(),
        enabledBorder: border(),
        focusedBorder: border(),
        focusedErrorBorder: border(),
        counterText: "",
        //isDense: true,
        filled: true,
        errorMaxLines: 2,
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(
              horizontal: 20,vertical: 15.0,
            ),
        //const EdgeInsets.only(left: 20,right:20.0, top: 8.0, bottom: 0),
        errorStyle: style ??
            const TextStyle(
              fontSize: 14.0,
              color: Colors.red,
            ),
        suffixIcon: suffixIcon,
        prefixIcon: preFixIcon,
        prefix: preFix,
      ),
      keyboardType: textInputType,
      controller: controller,
      cursorColor: Colors.black,
      autofocus: autoFocus ?? false,
    );
  }

  OutlineInputBorder errorBorder() {
    return OutlineInputBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.red));
  }

  OutlineInputBorder border() {
    return OutlineInputBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.transparent));
  }
}
