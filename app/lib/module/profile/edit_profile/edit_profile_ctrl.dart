import 'package:core/styles/app_themes.dart';
import 'package:sampleflutterproject/app/app_repo.dart';
import 'package:core/model/api_generic_model.dart';
import 'package:core/backend/auth_service.dart';
import 'package:sampleflutterproject/utils/app_toast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:sampleflutterproject/styles/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';

class EditProfileCtrl extends GetxController {
  RxBool isLoading = false.obs;

  String countryName = "";
  String optionalCountryName = "";

  DateTime? dateOfBirthDate;
  final passwordVisible = false.obs;

  RxString pickedFrontImagePath = "".obs;
  RxString pickedBackImagePath = "".obs;

  RxString governmentLaterImagePath = "".obs;
  RxString pickedProfileImagePath = "".obs;

  RxString optionalPhoneNumber = "".obs;
  RxString optionalCountryCode = "255".obs;

  final TextEditingController ctrlFullName = TextEditingController();
  final TextEditingController ctrlEmail = TextEditingController();
  final TextEditingController ctrlNationalIdNumber = TextEditingController();
  final TextEditingController ctrlPhoneNumber = TextEditingController();
  final TextEditingController ctrlOptionalPhoneNumber = TextEditingController();
  final TextEditingController ctrlAddress = TextEditingController();
  final TextEditingController ctrlSecondPhoneNumber = TextEditingController();
  final TextEditingController ctrlPassword = TextEditingController();
  final TextEditingController ctrlDateOfBirth = TextEditingController();

  selectLastUsedDate(BuildContext context) async {
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
      initialDate: DateTime.now(),
      currentDate: DateTime.now(),
      firstDate: DateTime(1930),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      dateOfBirthDate = picked;
      ctrlDateOfBirth.text =
          DateFormat('dd-MM-yyyy').format(dateOfBirthDate!).toString();
    }
  }

  Future<ApiResponse> updateProfile() async {
    var res;

    try {
      Map<String, dynamic> data = {
        "id": app.userModel.value.id,
        "full_name": ctrlFullName.text,
        "email": ctrlEmail.text,
        "dob": DateFormat('yyyy-MM-dd').format(dateOfBirthDate!),
        "cc": app.countryCode.value,
        "phno": app.phoneNumber.value,
        "address": ctrlAddress.text,
      };

      if (optionalPhoneNumber.value.isNotEmpty &&
          optionalCountryCode.isNotEmpty) {
        data.addAll({
          "opt_cc": optionalCountryCode,
          "opt_phno": optionalPhoneNumber,
        });
      }

      if (ctrlNationalIdNumber.text != app.userModel.value.natIdNo) {
        data.addAll({
          "nat_id_no": ctrlNationalIdNumber.text,
        });
      }

      if (pickedFrontImagePath.value != app.userModel.value.natIdFront) {
        data.addAll({
          "nat_id_front": await MultipartFile.fromFile(
              pickedFrontImagePath.value,
              filename: pickedFrontImagePath.split("/").last),
        });
      }

      if (pickedBackImagePath.value != app.userModel.value.natIdBack) {
        data.addAll({
          "nat_id_back": await MultipartFile.fromFile(pickedBackImagePath.value,
              filename: pickedBackImagePath.split("/").last),
        });
      }

      if (pickedProfileImagePath.isNotEmpty) {
        data.addAll({
          "profile_img": await MultipartFile.fromFile(
              pickedProfileImagePath.value,
              filename: pickedProfileImagePath.split("/").last),
        });
      }

      if (governmentLaterImagePath.isNotEmpty) {
        data.addAll({
          "gov_later": await MultipartFile.fromFile(
              governmentLaterImagePath.value,
              filename: governmentLaterImagePath.split("/").last),
        });
      }

      res = await AuthService.updateProfile(data);

      if (res.isValid) {
        AppToast.msg("update_successfully".tr);
        await getProfile();
        Get.back();
        isLoading.value = false;
        return res;
      } else {
        AppToast.msg("something_went_wrong".tr);
        isLoading.value = false;
        return res;
      }
    } catch (e) {
      isLoading.value = false;
      logger.i("e = $e");
    }
    return res;
  }

  Future<ApiResponse> emailIsExist({required String email, required String phoneNo}) async {
    var res = await AuthService.checkEmailIsExist({
      "email": email,
      "phno": phoneNo,
    });
    return res;
  }

  setValues() {
    ctrlFullName.text = app.userModel.value.fullName;
    ctrlEmail.text = app.userModel.value.email;
    dateOfBirthDate = app.userModel.value.dob;
    ctrlDateOfBirth.text =
        DateFormat('dd-MM-yyyy').format(app.userModel.value.dob).toString();
    ctrlNationalIdNumber.text = app.userModel.value.natIdNo;
    app.countryCode.value = app.userModel.value.cc.toString();
    ctrlPhoneNumber.text = app.userModel.value.phno;
    ctrlAddress.text = app.userModel.value.address;

    if (app.userModel.value.optPhno.isNotEmpty) {
      ctrlOptionalPhoneNumber.text = app.userModel.value.optPhno;
      optionalCountryCode.value = app.userModel.value.optCc.toString();
    }
    pickedFrontImagePath.value = app.userModel().natIdFront;
    pickedBackImagePath.value = app.userModel().natIdBack;
    //pickedProfileImagePath.value = app.userModel.value.profileImg;
  }

  getProfile() async {
    var res = await AuthService.getProfile({
      "id": app.userModel.value.id,
    });
    if (res.isValid) {
      app.userModel.value = res.r!;
      setValues();
    }
  }

  init() async {
    getProfile();
  }

  @override
  void onInit() {
    init();
    super.onInit();
  }

  checkStoragePermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.photos,
      Permission.photosAddOnly,
      Permission.videos,
    ].request();
  }
}
