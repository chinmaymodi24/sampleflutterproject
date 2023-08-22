import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:core/backend/auth_service.dart';
import 'package:core/model/api_generic_model.dart';
import 'package:core/model/user_model.dart';
import 'package:core/network/dio_config.dart';
import 'package:core/service/local_storage_service.dart';
import 'package:core/styles/app_themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile, Response;
import 'package:dio/dio.dart';
import 'package:sampleflutterproject/app/app_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sampleflutterproject/backend/firestore/firebase_keys.dart';
import 'package:sampleflutterproject/model/linkedin_user_model.dart';
import 'package:sampleflutterproject/module/auth/account_rejected.dart';
import 'package:sampleflutterproject/module/auth/login_with_phone_number/login_with_phone_number.dart';
import 'package:sampleflutterproject/module/auth/signup/signup.dart';
import 'package:sampleflutterproject/module/auth/verification_pending/verification_pending.dart';
import 'package:sampleflutterproject/module/home/home.dart';
import 'package:sampleflutterproject/module/navigation/navigation_page.dart';
import 'package:sampleflutterproject/styles/app_colors.dart';
import 'package:sampleflutterproject/utils/app_toast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:linkedin_login/linkedin_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linkedin_login/linkedin_login.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:crypto/crypto.dart';

class LoginWithPhoneNumberCtrl extends GetxController {
  RxBool isLoading = false.obs;

  //Linkedin Details
  final String redirectUrl =
      'https://www.linkedin.com/developers/apps/verification/3abb5e3c-952a-458e-8255-8fddd44a354b';
  final String clientId = '86boy0bq1xcgn6';
  final String clientSecret = '8meFbuSPoKtaoJXj';
  bool logoutUser = false;
  AuthCodeObject? authorizationCode;

  final formKey = GlobalKey<FormState>();

  String countryName = "";

  final TextEditingController ctrlPhoneNumber = TextEditingController();

  final passwordVisible = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<ApiResponse> getProfileByFId({required String fId}) async {
    var res = await AuthService.signIn({
      "f_id": fId,
    });

    // log("--------------------------------------------------------");
    // log("getProfileByFId res = ${res.r}");
    // log("--------------------------------------------------------");

    if (res.isValid) {
      logger.wtf("res.isValid");

      app.userModel.value = UserModel.fromJson(res.r);

      logger.i("apiKey: ${app.userModel.value.apiKey},");
      logger.i("token: ${app.userModel.value.token},");

      LocalStorageService.setLogin(UserModel.fromJson(res.r));
      LocalStorageService.getLogin;

      ApiService().setApiKey(
        apiKey: app.userModel.value.apiKey,
        token: app.userModel.value.token,
      );

      if (app.userModel.value.accStatus == 0) {
        AppToast.msg(
            "Your account has been deleted\n Please create new account");
        Get.offAll(() => LoginWithPhoneNumber());
        return res;
      }
      if (app.userModel.value.accStatus == -1) {
        AppToast.msg("You are blocked by admin");
        Get.offAll(() => LoginWithPhoneNumber());
      }
      if (app.userModel.value.verificationStatus == 0) {
        Get.offAll(() => VerificationPending());
      } else if (app.userModel.value.verificationStatus == -1) {
        Get.offAll(() => const AccountRejected());
      } else if (app.userModel.value.verificationStatus == 1) {
        Get.offAll(() => Home());
      }
    }
    return res;
  }

  //googleSignIn
  Future<String> onGoogleSignIn() async {
    try {
      try {
        await GoogleSignIn().disconnect();
      } on Exception catch (e, t) {
        logger.i("GoogleSignIn().disconnect() = $e,\n$t");
      }
      final GoogleSignIn googleSignIn = GoogleSignIn();

      //await googleSignIn.signOut();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount == null) return '';
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User? user = authResult.user;

      if (user != null) {
        //loading.value = false;

        log("googleName = ${user.displayName}");
        log("googleEmail = ${user.email}");
        log("googleImageUrl = ${user.photoURL}");
        log("uid = ${user.uid}");

        app.userModel.value = UserModel.fromEmpty();

        app.userModel.value.fullName = user.displayName ?? "";
        app.userModel.value.email = user.email ?? "";
        app.userModel.value.profileImg = user.photoURL ?? "";

        var res = await getProfileByFId(
          fId: user.uid,
        );
        if (res.isValid) {
          var res = await app.deleteAccountMethod();
          if (res) {
            Get.offAll(NavigationPage());
          }
        } else {
          Get.to(() => SignUp(), arguments: credential);
        }
        return "success";
      } else {
        Get.to(() => SignUp(), arguments: credential);
      }
      return "";
    } on Exception catch (e) {
      return "";
    }
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  //signWithApple
  onAppleSignIn() async {
    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Create an `OAuthCredential` from the credential returned by Apple.
      final AuthCredential authCredential =
          OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
        accessToken: appleCredential.authorizationCode,
      );

      UserCredential credential =
          await FirebaseAuth.instance.signInWithCredential(authCredential);
      String? fName = appleCredential.givenName;
      String? lName = appleCredential.familyName;
      logger.e("name-->$fName\n$lName");

      final User? user = credential.user;

      if (user != null) {
        //loading.value = false;

        log("AppleName = ${user.displayName}");
        log("AppleEmail = ${user.email}");
        log("AppleImageUrl = ${user.photoURL}");
        log("uid = ${user.uid}");

        app.userModel.value = UserModel.fromEmpty();
        app.userModel.value.fullName = user.displayName ?? "";
        app.userModel.value.email = user.email ?? "";
        app.userModel.value.profileImg = user.photoURL ?? "";

        var res = await getProfileByFId(
          fId: user.uid,
        );
        if (res.isValid) {
          var res = await app.deleteAccountMethod();
          if (res) {
            Get.offAll(NavigationPage());
          }
        } else {
          Get.to(() => SignUp(), arguments: authCredential);
        }
        return "success";
      }
    } on Exception catch (e) {
      logger.e("");
    }
  }

  onLinkedinInSignIn({required BuildContext context}) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (final BuildContext context) => SafeArea(
          child: LinkedInAuthCodeWidget(
            destroySession: logoutUser,
            redirectUrl: redirectUrl,
            clientId: clientId,
            onError: (final AuthorizationFailedAction e) {
              print('Error: ${e.toString()}');
              print('Error: ${e.stackTrace.toString()}');
            },
            onGetAuthCode: (final AuthorizationSucceededAction response) {
              logger.i('Auth code ${response.codeResponse.code}');

              logger.i('State: ${response.codeResponse.state}');

              authorizationCode = AuthCodeObject(
                code: response.codeResponse.code!,
                state: response.codeResponse.state!,
              );

              Navigator.pop(context);

              signInWithLinkedIn(context: context);
            },
          ),
        ),
        fullscreenDialog: true,
      ),
    );
  }

  late UserObject? user;

  signInWithLinkedIn({required BuildContext context}) async {
    try {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (final BuildContext context) => SafeArea(
            child: LinkedInUserWidget(
              appBar: AppBar(
                title: const Text('OAuth User'),
              ),
              destroySession: logoutUser,
              redirectUrl: redirectUrl,
              clientId: clientId,
              clientSecret: clientSecret,
              projection: const [
                ProjectionParameters.id,
                ProjectionParameters.localizedFirstName,
                ProjectionParameters.localizedLastName,
                ProjectionParameters.firstName,
                ProjectionParameters.lastName,
                ProjectionParameters.profilePicture,
              ],
              onError: (final UserFailedAction e) {
                logger.e('Error: ${e.toString()}');
                logger.e('Error: ${e.stackTrace.toString()}');
              },
              onGetUserProfile: (final UserSucceededAction linkedInUser) async {
                await Get.showOverlay(
                  loadingWidget: Center(
                    child: Container(
                      height: 70.0,
                      width: 70.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: const Center(
                        child: CupertinoActivityIndicator(
                          color: AppColors.getPrimary,
                        ),
                      ),
                    ),
                  ),
                  asyncFunction: () async {
                    if (linkedInUser.user.token.accessToken != null) {
                      final dio = Dio();

                      Response response = await dio.get(
                          "https://api.linkedin.com/v2/me?projection=(profilePicture(displayImage~:playableStreams))",
                          options: Options(
                              responseType: ResponseType.json,
                              sendTimeout: 60000,
                              receiveTimeout: 60000,
                              headers: {
                                HttpHeaders.authorizationHeader:
                                    "Bearer ${linkedInUser.user.token.accessToken}"
                              }));

                      user = UserObject(
                        firstName:
                            linkedInUser.user.firstName?.localized?.label ?? "",
                        lastName:
                            linkedInUser.user.lastName?.localized?.label ?? "",
                        email: linkedInUser.user.email?.elements?[0].handleDeep
                                ?.emailAddress ??
                            "",
                        profileImageUrl: linkedInUser
                                .user
                                .profilePicture
                                ?.displayImageContent
                                ?.elements?[0]
                                .identifiers?[0]
                                .identifier ??
                            "",
                      );

                      var profilePic = response.data;

                      app.linkedInUid = linkedInUser.user.userId!;
                      logger.i(
                          "linkedInUser.user.userId = ${linkedInUser.user.userId!}");
                      logger.i("user profile = ${profilePic.toString()}");
                      logger.i("user lastName = ${user?.lastName}");
                      logger.i("user firstName = ${user?.firstName}");
                      logger.i("user email = ${user?.email}");
                      logger
                          .i("user profileImageUrl = ${user?.profileImageUrl}");

                      OAuthCredential credential =
                          OAuthProvider("linkedin.com").credential(
                        //idToken: ,
                        //signInMethod: Si,
                        idToken: clientId,
                        secret: clientSecret,
                        accessToken: linkedInUser.user.token.accessToken,
                      );

                      var res = await getProfileByFId(
                        fId: linkedInUser.user.userId!,
                      );
                      if (res.isValid) {
                        Get.back();
                        var res = await app.deleteAccountMethod();
                        if (res) {
                          Get.offAll(NavigationPage());
                        }
                      } else {
                        app.userModel.value = UserModel.fromEmpty();
                        app.userModel.value.fullName =
                            "${user?.firstName}${user?.lastName}";
                        app.userModel.value.email = "${user?.email}";
                        Get.back();
                        Get.to(() => SignUp(), arguments: credential);
                      }
                    }
                  },
                );
              },
            ),
          ),
          fullscreenDialog: true,
        ),
      );
    } catch (e) {
      logger.e("Catch exception = $e");
    }
  }

  final FacebookLogin facebookLogin = FacebookLogin();
  static final FacebookLogin facebookSignIn = FacebookLogin();

  //facebookSignIn
  void onFacebookSignIn() async {
    logger.i("message1234");

    try {
      final FacebookLoginResult result = await facebookSignIn.logIn(
          permissions: [
            FacebookPermission.email,
            FacebookPermission.publicProfile
          ]);

      final dio = Dio();

      switch (result.status) {
        case FacebookLoginStatus.success:
          await Get.showOverlay(
              loadingWidget: Center(
                child: Container(
                  height: 70.0,
                  width: 70.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: const Center(
                    child: CupertinoActivityIndicator(
                      color: AppColors.getPrimary,
                    ),
                  ),
                ),
              ),
              asyncFunction: () async {
                final FacebookAccessToken? accessToken = result.accessToken;
                final graphResponse = await dio.get(
                    "https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${accessToken?.token}");

                logger.i("graphResponse = ${graphResponse.realUri.path}");

                // dynamic profile = jsonDecode(graphResponse.realUri.path);
                // log("profile = $profile");
                //
                // var displayName = profile['first_name'];
                // log("displayName = $displayName");
                //
                // var userEmail = profile['email'];
                // log("userEmail = $userEmail");

                log('''
          Logged in!
      
          Token: ${accessToken?.token}
          User id: ${accessToken?.userId}
          Expires: ${accessToken?.expires}
          Permissions: ${accessToken?.permissions}
          Declined permissions: ${accessToken?.declinedPermissions}
          ''');

                final AuthCredential credential =
                    FacebookAuthProvider.credential(accessToken!.token);

                UserCredential userCredential = await FirebaseAuth.instance
                    .signInWithCredential(credential);

                logger.i("userCredential = ${userCredential.user}");

                if (accessToken != null) {
                  // app.userModel.value.fullName = userCredential.user?.displayName ?? "";
                  // app.userModel.value.email = userCredential.user?.email ?? "";
                  // app.userModel.value.profileImg = userCredential.user?.photoURL ?? "";

                  User? currentUser = FirebaseAuth.instance.currentUser;
                  var res = await getProfileByFId(
                    fId: currentUser!.uid,
                  );
                  if (res.isValid) {
                    Get.back();
                    var res = await app.deleteAccountMethod();
                    if (res) {
                      Get.offAll(NavigationPage());
                    }
                  } else {
                    app.userModel.value = UserModel.fromEmpty();
                    app.userModel.value.fullName =
                        "${userCredential.user!.displayName}";
                    app.userModel.value.email = "${userCredential.user!.email}";
                    Get.back();
                    Get.to(
                      () => SignUp(),
                      arguments: credential,
                    );
                  }
                }
                ;
              });
          break;
        case FacebookLoginStatus.cancel:
          log('Login cancelled by the user.');
          //loading.value = false;
          AppToast.msg(
            "Login cancelled by the user.",
          );
          break;
        case FacebookLoginStatus.error:
          log('Something went wrong with the login process.\n'
              'Here\'s the error Facebook gave us: ${result.error}');
          log('Login cancelled by the user.');
          //loading.value = false;
          AppToast.msg(
            "${result.error}",
          );
          break;
      }
    } on Exception catch (e, t) {
      logger.e("catch $e $t");
    }
  }

  Future<ApiResponse> numberIsExist({required String phoneNumber}) async {
    var res = await AuthService.checkEmailIsExist({
      "phno": phoneNumber,
    });
    return res;
  }

  @override
  void onInit() {
    super.onInit();
  }
}
