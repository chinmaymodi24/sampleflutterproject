import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:core/service/local_storage_service.dart';
import 'package:core/styles/app_themes.dart';
import 'package:sampleflutterproject/app/app_repo.dart';
import 'package:core/model/api_generic_model.dart';
import 'package:core/model/user_model.dart';
import 'package:sampleflutterproject/module/auth/verification_pending/verification_pending.dart';
import 'package:core/backend/auth_service.dart';
import 'package:sampleflutterproject/utils/app_toast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile, Response;
import 'package:sampleflutterproject/styles/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpCtrl extends GetxController {
  AuthCredential? credential;

  RxBool isLoading = false.obs;

  String countryName = "";
  String optionalCountryName = "";

  DateTime? dateOfBirthDate;
  final passwordVisible = false.obs;
  RxString nationalIDFrontImagePath = "".obs;
  RxString nationalIDBackImagePath = "".obs;
  RxString governmentLaterImagePath = "".obs;

  RxString profileImagePath = "".obs;
  RxString profileFirebaseImagePath = "".obs;
  RxString profileUploadFirebaseImagePath = "".obs;

  RxString optionalPhoneNumber = "".obs;
  RxString optionalCountryCode = "255".obs;
  Rx<Uint8List> imageBytes = Uint8List(0).obs;

  final TextEditingController ctrlFullName = TextEditingController();
  final TextEditingController ctrlEmail = TextEditingController();
  final TextEditingController ctrlNationalIdNumber = TextEditingController();
  final TextEditingController ctrlPhoneNumber = TextEditingController();
  final TextEditingController ctrlOptionalPhoneNumber = TextEditingController();
  final TextEditingController ctrlAddress = TextEditingController();
  final TextEditingController ctrlSecondPhoneNumber = TextEditingController();
  final TextEditingController ctrlPassword = TextEditingController();
  final TextEditingController ctrlDateOfBirth = TextEditingController();

  selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.getPrimary, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF232c5a), // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
      initialDate: DateTime(2000),
      currentDate: DateTime(2000),
      firstDate: DateTime(1930),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      dateOfBirthDate = picked;
      ctrlDateOfBirth.text =
          DateFormat('dd-MM-yyyy').format(dateOfBirthDate!).toString();
    }
  }

  Future<ApiResponse> signUp({
    required String fId,
    required int loginType,
    required String fullName,
    String? profileImage,
    required String email,
    required DateTime dob,
    required String nationalIdNo,
    required String nationalIdFrontImage,
    required String nationalIdBackImage,
    required String countryCode,
    required String phoneNumber,
    required String address,
    String? governmentLetterImage,
    String? optionalCountyCode,
    String? optionalPhoneNumber,
  }) async {
    Map<String, dynamic> data = {
      "f_id": fId,
      "login_type": loginType,
      "full_name": fullName,
      "email": email,
      "dob": DateFormat('yyyy-MM-dd').format(dob),
      "nat_id_no": nationalIdNo,
      "nat_id_front": await MultipartFile.fromFile(nationalIdFrontImage,
          filename: nationalIdFrontImage.split("/").last),
      "nat_id_back": await MultipartFile.fromFile(nationalIdBackImage,
          filename: nationalIdBackImage.split("/").last),
      "cc": countryCode,
      "phno": phoneNumber,
      "address": address,
    };

    if (optionalPhoneNumber != null && optionalCountyCode != null) {
      data.addAll({
        "opt_cc": optionalCountyCode,
        "opt_phno": optionalPhoneNumber,
      });
    }

    if (imageBytes().isNotEmpty) {
      data.addAll({
        "profile_img":
            MultipartFile.fromBytes(imageBytes(), filename: 'temp.jpg'),
      });
    } else {
      if (profileImage != null) {
        data.addAll({
          "profile_img": await MultipartFile.fromFile(profileImage,
              filename: profileImage.split("/").last),
        });
      }
    }

    if (governmentLetterImage != null) {
      data.addAll({
        "gov_later": await MultipartFile.fromFile(governmentLetterImage,
            filename: governmentLetterImage.split("/").last),
      });
    }

    var res = await AuthService.signUp(data);

    if (res.isValid) {
      AppToast.msg("create_account_successfully".tr);
      app.userModel.value = UserModel.fromJson(res.r);

      // LocalStorageService.setLogin(app.userModel.value);
      // LocalStorageService.getLogin;
      return res;
    } else {
      AppToast.msg("something_went_wrong".tr);
      return res;
    }
  }

  Future<ApiResponse> emailIsExist(
      {required String email, required String phoneNumber}) async {
    var res = await AuthService.checkEmailIsExist({
      "email": email,
      "phno": phoneNumber,
    });
    return res;
  }

  String? get getFid {
    if (Platform.isIOS) {
      if (app.linkedInUid.isNotEmpty) {
        return app.linkedInUid;
      } else if (credential != null) {
        return null;
      } else {
        return null;
      }
    } else {
      if (app.linkedInUid.isNotEmpty) {
        return app.linkedInUid;
      } else {
        return null;
      }
    }
  }

  Future<ApiResponse?> createUserWithEmailAndPassAndSignUpWithBackend(
      {required User user, bool isLogin = true}) async {
    try {
      log("getFId = ${app.getCurrentUserUid.toString()}");

      if (app.getCurrentUserUid.toString().isNotEmpty) {
        var res1 = await AuthService.signIn({
          "f_id": user.uid,
        });
        if (res1.isValid) {
          app.userModel.value = UserModel.fromJson(res1.r!);

          /*if(app.userModel.value.accStatus == -1)
            {
              AppToast.msg("You are blocked by admin");
            }*/
          var res =await app.deleteAccountMethod();
          if(res){
            LocalStorageService.setLogin(app.userModel.value);
            app.navigate();
          }

        } else {
          //Get.back();
          //AppToast.msg("User not exist, Please create an account first");
        }
      }

        var res = await signUp(
          //fId: user.user!.uid,
          //fId: app.linkedInUid.isNotEmpty ? app.linkedInUid : user.uid,
          fId: getFid ?? user.uid,
          loginType: 1,
          fullName: ctrlFullName.text,
          email: ctrlEmail.text,
          dob: dateOfBirthDate!,
          nationalIdNo: ctrlNationalIdNumber.text,
          profileImage:
              profileImagePath.value.isEmpty ? null : profileImagePath.value,
          nationalIdFrontImage: nationalIDFrontImagePath.value,
          nationalIdBackImage: nationalIDBackImagePath.value,
          countryCode: app.countryCode.value,
          phoneNumber: app.phoneNumber.value,
          optionalCountyCode: optionalCountryName,
          optionalPhoneNumber: optionalPhoneNumber.value,
          governmentLetterImage: governmentLaterImagePath.value.isEmpty
              ? null
              : governmentLaterImagePath.value,
          address: ctrlAddress.text,
        );
        if (res.isValid) {
          LocalStorageService.setLogin(UserModel.fromJson(res.r));
          Get.offAll(() => VerificationPending());
        } else {
          AppToast.msg("something_went_wrong".tr);
        }
        return res;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          AppToast.msg("password_weak".tr);
          log('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          AppToast.msg("account_already_exist".tr);
          log('The account already exists for that email.');
        }
    } catch (e,t) {
         //logger.i("e = $e\n$t");
    }
    return null;
  }

  checkStoragePermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.photos,
      Permission.photosAddOnly,
      Permission.videos,
    ].request();
  }

  init() async {
    if (Get.arguments is AuthCredential) {
      credential = Get.arguments;

      logger.i("credential = ${credential!.accessToken}");

      if (app.userModel.value.fullName.isNotEmpty) {
        ctrlFullName.text = app.userModel.value.fullName;
      }
      if (app.userModel.value.email.isNotEmpty) {
        ctrlEmail.text = app.userModel.value.email;
      }
      if (app.userModel.value.profileImg.isNotEmpty) {
        profileFirebaseImagePath.value = app.userModel.value.profileImg;
        logger.i(
            "app.userModel.value.profileImg = ${app.userModel.value.profileImg}");
        logger.i(
            "profileFirebaseImagePath.value = ${profileFirebaseImagePath.value}");

        final rs = await Dio().get<List<int>>(
          profileFirebaseImagePath.value,
          options: Options(
              responseType:
                  ResponseType.bytes), // Set the response type to `bytes`.
        );
        if (rs.data != null) {
          imageBytes(Uint8List.fromList(rs.data!));
        }
        logger.i('IMAGE LENGTH :${rs.data?.length}');
      }
    } else {
      logger.i("AuthCredential is null");
    }
  }

  @override
  void onInit() {
    init();
    super.onInit();
  }
}
