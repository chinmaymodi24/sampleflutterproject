import 'dart:developer';
import 'package:core/api_routes/api_routes.dart';
import 'package:core/model/api_generic_model.dart';
import 'package:core/model/home_detail_model.dart';
import 'package:core/model/sponsor_model.dart';
import 'package:core/model/user_model.dart';
import 'package:core/network/dio_config.dart';
import 'package:core/styles/app_themes.dart';

class AuthService {
  //get home detail
  static Future<ApiResponse<HomeDetailModel>> homeDetail(
      Map<String, dynamic> body) async {
    try {
      var res = await ApiService.get(url: ApiRoutes.homeDetails, body: body);
      log("homeDetail res = ${res.data}");
      var apiRes = ApiResponse<HomeDetailModel>.fromMapJson(
          res.data, (data) => HomeDetailModel.fromJson(data));
      log("res = ${apiRes.r!.toJson()}");
      return apiRes;
    } catch (e, t) {
      logger.i("homeDetail error = $e,$t, $body");
      return ApiResponse.fromError();
    }
  }

  //get all sponsor
  static Future<ApiResponse<List<SponsorModel>>> getAllSponsor(
      Map<String, dynamic> body) async {
    try {
      var res = await ApiService.get(url: ApiRoutes.getAllSponsor, body: body);
      log("getAllSponsor res = ${res.data}");

      var apiRes = ApiResponse<List<SponsorModel>>.fromListJson(res.data,
          (data) => data.map((e) => SponsorModel.fromJson(e)).toList());

      return apiRes;
    } catch (e, t) {
      logger.i("getAllSponsor error = $e,$t");
      return ApiResponse.fromError();
    }
  }

  //loan Request
  static Future<ApiResponse> userLoanRequest(Map<String, dynamic> body) async {
    try {
      var res =
          await ApiService.post(url: ApiRoutes.userLoanRequest, body: body);
      log("userLoanRequest res = ${res.data}");
      var apiRes = ApiResponse.fromJson(res.data);
      return apiRes;
    } catch (e) {
      logger.i("userLoanRequest error = $e");
      return ApiResponse.fromError();
    }
  }

  //Update profile
  static Future<ApiResponse> updateProfile(Map<String, dynamic> body) async {
    try {
      var res = await ApiService.post(url: ApiRoutes.userUpdate, body: body);
      log("updateProfile res = ${res.data}");
      var apiRes = ApiResponse.fromJson(res.data);
      return apiRes;
    } catch (e) {
      logger.i("updateProfile error = $e");
      return ApiResponse.fromError();
    }
  }

  //GetProfile
  static Future<ApiResponse<UserModel>> getProfile(
      Map<String, dynamic> body) async {
    try {
      var res = await ApiService.get(url: ApiRoutes.userGetById, body: body);
      // log("getProfile res = ${res.data}");
      var apiRes = ApiResponse<UserModel>.fromMapJson(
          res.data, (data) => UserModel.fromJson(data));
      // log("res = ${apiRes.r!.toJson()}");
      return apiRes;
    } catch (e, t) {
      logger.i("getProfile error = $e,\n\n$t,\n\n$body");
      return ApiResponse.fromError();
    }
  }

  //Sign in
  static Future<ApiResponse> signIn(Map<String, dynamic> body) async {
    try {
      var res = await ApiService.post(url: ApiRoutes.signIn, body: body);
      log("signIn res = ${res.data}");
      var apiRes = ApiResponse.fromJson(res.data);
      return apiRes;
    } catch (e) {
      logger.i("signIn error = $e");
      return ApiResponse.fromError();
    }
  }

  //Sign up
  static Future<ApiResponse> signUp(Map<String, dynamic> body) async {
    try {
      var res = await ApiService.post(url: ApiRoutes.signUp, body: body);
      log("signUp res = ${res.data}");
      var apiRes = ApiResponse.fromJson(res.data);
      return apiRes;
    } catch (e) {
      logger.i("signUp error = $e");
      return ApiResponse.fromError();
    }
  }

  //Check Email is exist
  static Future<ApiResponse> checkEmailIsExist(
      Map<String, dynamic> body) async {
    try {
      var res = await ApiService.post(url: ApiRoutes.emailIsExist, body: body);
      log("checkEmailIsExist res = ${res.data}");
      var apiRes = ApiResponse.fromJson(res.data);
      return apiRes;
    } catch (e) {
      logger.i("checkEmailIsExist error = $e");
      return ApiResponse.fromError();
    }
  }

  //Admin
  //Give kyc status
  static Future<ApiResponse> giveKycStatus(Map<String, dynamic> body) async {
    try {
      var res = await ApiService.post(url: ApiRoutes.giveKycStatus, body: body);
      log("giveKycStatus res = ${res.data}");
      var apiRes = ApiResponse.fromJson(res.data);
      return apiRes;
    } catch (e) {
      logger.i("giveKycStatus error = $e");
      return ApiResponse.fromError();
    }
  }

  //Make sponsor or block user
  static Future<ApiResponse> statusUpdate(Map<String, dynamic> body) async {
    try {
      logger.i("body =====> $body");
      var res = await ApiService.post(url: ApiRoutes.statusUpdate, body: body);
      log("statusUpdate res = ${res.data}");
      var apiRes = ApiResponse.fromJson(res.data);
      return apiRes;
    } catch (e) {
      logger.i("statusUpdate error = $e");
      return ApiResponse.fromError();
    }
  }

  //get all user
  static Future<ApiResponse<List<UserModel>>> getAllUser(
      Map<String, dynamic> body) async {
    try {
      var res = await ApiService.get(url: ApiRoutes.getAllUser, body: body);
      log("getAllUser res = ${res.data}");

      var apiRes = ApiResponse<List<UserModel>>.fromListJson(
          res.data, (data) => data.map((e) => UserModel.fromJson(e)).toList());

      return apiRes;
    } catch (e, t) {
      logger.i("getAllUser error = $e,$t");
      return ApiResponse.fromError();
    }
  }
}
