import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sampleflutterproject/app/app_repo.dart';
import 'package:sampleflutterproject/module/auth/otp/otp_ctrl.dart';
import 'package:get/get.dart';
import 'package:sampleflutterproject/styles/app_themes.dart';
import 'package:sampleflutterproject/utils/app_toast.dart';
import 'package:sampleflutterproject/widget/custom_button.dart';
import 'package:sampleflutterproject/widget/custom_scaffold.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Otp extends StatefulWidget {
  bool isLinkAccount = false;

  Otp({
    Key? key,
    required this.isLinkAccount,
  }) : super(key: key);

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  final ctrl = Get.put(OtpCtrl());

  RxInt timerValue = 60.obs;
  Timer? timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      timerValue.value = timerValue.value - 1;

      if (timerValue.value == 0) {
        timer.cancel();
      }
    });
    ctrl.sendOtp();
    super.initState();
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 42.0),
              Text(
                "otp_verification".tr,
                textAlign: TextAlign.center,
                style: themes.light.textTheme.headlineMedium,
              ),
              const SizedBox(height: 5.0),
              Text(
                "${"enter_6_digit_code_sent_your_number".tr} +${app.countryCode}  ${app.phoneNumber} ${"change_number".tr}",
                textAlign: TextAlign.center,
                style: themes.light.textTheme.headlineSmall,
              ),
              const SizedBox(height: 48.0),
              PinCodeTextField(
                appContext: context,
                //enablePinAutofill: true,
                pastedTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                length: 6,
                animationType: AnimationType.fade,
                validator: (v) {
                  if (v!.length != 6) {
                    return "";
                  } else {
                    return null;
                  }
                },

                enablePinAutofill: true,
                pinTheme: PinTheme(
                  fieldHeight: 52,
                  fieldWidth: 48,
                  borderWidth: 2,
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(10.0),
                  selectedFillColor: const Color(0xFFFBFBFB),
                  inactiveColor: const Color(0xFFFBFBFB),
                  activeColor: const Color(0xFFFBFBFB),
                  inactiveFillColor: const Color(0xFFFBFBFB),
                  activeFillColor: const Color(0xFFFBFBFB),
                  selectedColor: const Color(0xFFFBFBFB),
                ),
                cursorColor: Colors.black,
                animationDuration: const Duration(milliseconds: 300),
                enableActiveFill: true,
                controller: ctrl.pinCodeCtrl,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                keyboardType: TextInputType.number,
                onCompleted: (v) {
                  debugPrint("Completed");
                  log("v = $v");
                },
                // onTap: () {
                //   print("Pressed");
                // },
                onChanged: (value) {
                  debugPrint(value);
                  //currentText = value;
                },
                onSubmitted: (pin) async {
                  log("in onSubmitted");
                  ctrl.verifyOtp(isLinkAccount: widget.isLinkAccount,);
                },
                //autovalidateMode: AutovalidateMode.onUserInteraction,
                beforeTextPaste: (text) {
                  debugPrint("Allowing to paste $text");
                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                  //but you can show anything you want here, like your pop up saying wrong paste format or etc
                  return true;
                },
              ),
              const SizedBox(height: 28.0),
              SizedBox(
                width: double.infinity,
                child: Obx(() {
                  return CustomButton(
                    isLoading: !ctrl.codeSent.value,
                    text: "verify".tr,
                    onPressed: () {
                      if (ctrl.codeSent.value) {
                        log("pinCodeCtrl = ${ctrl.pinCodeCtrl.text}");
                        log("verificationCode = ${ctrl.verificationCode}");
                        if (ctrl.pinCodeCtrl.text.trim().isEmpty) {
                          AppToast.msg("please_enter_the_otp".tr);
                        } else {

                          log("verify login value = ${widget.isLinkAccount}");

                          ctrl.isOtpLoadingButton.value = true;
                          ctrl.codeSent.value = true;
                          ctrl.verifyOtp(isLinkAccount: widget.isLinkAccount,);
                        }
                      }
                    },
                  );
                }),
              ),
              const SizedBox(height: 28.0),
              Center(
                child: Obx(() {
                  return GestureDetector(
                      onTap: () {
                        if (timerValue.value == 0) {
                          ctrl.pinCodeCtrl.clear();
                          ctrl.sendOtp();
                        }
                      },
                      child: Text(
                        timerValue.value == 0
                            ? "resend_otp".tr
                            : "${"resend_otp".tr} ( 00:${timerValue.value} )",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            height: 1,
                            fontWeight: FontWeight.w300,
                            fontSize: 16.0),
                      ));
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
