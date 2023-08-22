// import 'dart:developer';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:sampleflutterproject/module/auth/login/login_ctrl.dart';
// import 'package:sampleflutterproject/module/auth/signup/signup.dart';
// import 'package:sampleflutterproject/module/navigation/navigation_page.dart';
// import 'package:sampleflutterproject/styles/app_assets.dart';
// import 'package:sampleflutterproject/styles/app_colors.dart';
// import 'package:sampleflutterproject/styles/app_themes.dart';
// import 'package:get/get.dart';
// import 'package:sampleflutterproject/widget/custom_button.dart';
// import 'package:sampleflutterproject/widget/custom_filled_textfield.dart';
// import 'package:sampleflutterproject/widget/custom_scaffold.dart';
//
// class Login extends StatelessWidget {
//   Login({Key? key}) : super(key: key);
//   final ctrl = Get.put(LoginCtrl());
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomScaffold(
//       child: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Expanded(
//                 child: Form(
//                   key: ctrl.formKey,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text(
//                         "Welcome Back,",
//                         textAlign: TextAlign.center,
//                         style: themes.light.textTheme.headlineMedium,
//                       ),
//                       const SizedBox(height: 5.0),
//                       Text(
//                         "Enter your email & password to login",
//                         textAlign: TextAlign.center,
//                         style: themes.light.textTheme.headlineSmall,
//                       ),
//                       const SizedBox(height: 20.0),
//                       FilledTextField(
//                         hint: "Johndoe@gmail.com",
//                         controller: ctrl.ctrlEmail,
//                         validator: (value) {
//                           if (value!.trim().isEmpty) {
//                             return "Please enter email";
//                           } else if (!value.isEmail) {
//                             return "Please enter valid email";
//                           }
//                           return null;
//                         },
//                         textInputAction: TextInputAction.next,
//                         textInputType: TextInputType.emailAddress,
//                         maxLength: 60,
//                         borderRadius: BorderRadius.circular(13.0),
//                       ),
//                       const SizedBox(height: 15.0),
//                       Obx(() {
//                         return FilledTextField(
//                           hint: "*******",
//                           obscureText:
//                               !ctrl.passwordVisible.value ? true : false,
//                           borderRadius: BorderRadius.circular(13.0),
//                           controller: ctrl.ctrlPassword,
//                           validator: (value) {
//                             if (value!.trim().isEmpty) {
//                               return "Please enter password";
//                             }
//                             return null;
//                           },
//                           textInputAction: TextInputAction.done,
//                           textInputType: TextInputType.text,
//                           maxLength: 10,
//                           suffixIcon: InkWell(
//                             onTap: () {
//                               ctrl.passwordVisible.value =
//                                   !ctrl.passwordVisible.value;
//                             },
//                             child: Obx(() {
//                               return Image.asset(
//                                 !ctrl.passwordVisible.value
//                                     ? AppAssets.signupPassword
//                                     : AppAssets.signupShowPassword,
//                                 color: const Color(0xFF3C7CE8),
//                                 width:
//                                     !ctrl.passwordVisible.value ? 10.0 : 26.0,
//                                 height:
//                                     !ctrl.passwordVisible.value ? 10.0 : 26.0,
//                               );
//                             }).paddingAll(6.0).paddingOnly(right: 14.0),
//                           ),
//                         );
//                       }),
//                       const SizedBox(height: 15.0),
//                       Obx(() {
//                         return CustomButton(
//                           borderRadius: BorderRadius.circular(13.0),
//                           text: "Log in",
//                           isLoading: ctrl.isLoading.value,
//                           onPressed: () async {
//                             if (ctrl.formKey.currentState!.validate()) {
//                               ctrl.isLoading.value = true;
//                               await ctrl.createUserWithEmailAndPassword();
//                             } else {
//                               log("Invalid");
//                             }
//                           },
//                         );
//                       }),
//                       const SizedBox(height: 15.0),
//                       Text(
//                         "Or",
//                         textAlign: TextAlign.center,
//                         style: themes.light.textTheme.headlineSmall,
//                       ),
//                       const SizedBox(height: 20.0),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           CircleAvatar(
//                             radius: 22.0,
//                             backgroundColor: Colors.white,
//                             child: Image.asset(
//                               width: 20.0,
//                               height: 20.0,
//                               AppAssets.logoGoogle,
//                               fit: BoxFit.fitHeight,
//                             ),
//                           ),
//                           const SizedBox(width: 20.0),
//                           CircleAvatar(
//                             radius: 22.0,
//                             backgroundColor: Colors.white,
//                             child: Image.asset(
//                               width: 20.0,
//                               height: 20.0,
//                               AppAssets.logoIn,
//                               fit: BoxFit.fitHeight,
//                             ),
//                           ),
//                           const SizedBox(width: 20.0),
//                           CircleAvatar(
//                             radius: 22.0,
//                             backgroundColor: Colors.white,
//                             child: Image.asset(
//                               width: 20.0,
//                               height: 20.0,
//                               AppAssets.logoFb,
//                               fit: BoxFit.fitHeight,
//                             ),
//                           ),
//                           const SizedBox(width: 20.0),
//                           CircleAvatar(
//                             radius: 22.0,
//                             backgroundColor: Colors.white,
//                             child: Image.asset(
//                               width: 20.0,
//                               height: 20.0,
//                               AppAssets.logoApple,
//                               fit: BoxFit.fitHeight,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 24.0),
//                 child: RichText(
//                   textAlign: TextAlign.start,
//                   text: TextSpan(
//                     children: [
//                       TextSpan(
//                         text: "Don’t Have a Account ! ",
//                         style: themes.light.textTheme.headlineSmall!.copyWith(
//                           color: const Color(0xFF6D6D6D),
//                         ),
//                       ),
//                       TextSpan(
//                         recognizer: TapGestureRecognizer()
//                           ..onTap = () {
//                             Get.off(() => SignUp());
//                           },
//                         text: "Create Now ",
//                         style: themes.light.textTheme.headlineSmall?.copyWith(
//                           color: const Color(0xFF1F1F1F),
//                           fontSize: 14.0,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
