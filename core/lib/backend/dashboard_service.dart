import 'dart:developer';
import 'package:core/api_routes/api_routes.dart';
import 'package:core/model/admin_dashboard_detail_model.dart';
import 'package:core/model/api_generic_model.dart';
import 'package:core/model/recent_user_model.dart';
import 'package:core/model/user_model.dart';
import 'package:core/network/dio_config.dart';
import 'package:core/styles/app_themes.dart';

class DashboardService {

  //get dashboard Detail
  static Future<ApiResponse<AdminDashboardDetailModel>> getDashboardDetail(
      Map<String, dynamic> body) async {
    try {
      var res = await ApiService.get(
          url: ApiRoutes.getAdminDashboardDetail, body: body);
      log("getDashboardDetail res = ${res.data}");
      var apiRes = ApiResponse<AdminDashboardDetailModel>.fromMapJson(
          res.data, (data) => AdminDashboardDetailModel.fromJson(data));
      log("res = ${apiRes.r!.toJson()}");
      return apiRes;
    } catch (e, t) {
      logger.i("getDashboardDetail error = $e,$t, $body");
      return ApiResponse.fromError();
    }
  }

  //get all recent user
  static Future<ApiResponse<List<UserModel>>> getRecentUser(
      Map<String, dynamic> body) async {
    try {
      var res =
      await ApiService.get(url: ApiRoutes.getRecentUser, body: body);
      log("getRecentUser res = ${res.data}");

      var apiRes = ApiResponse<List<UserModel>>.fromListJson(res.data,
              (data) => data.map((e) => UserModel.fromJson(e)).toList());

      return apiRes;
    } catch (e, t) {
      logger.i("getRecentUser error = $e,$t");
      return ApiResponse.fromError();
    }
  }

  //get get Top Borrower
  static Future<ApiResponse<List<RecentUserModel>>> getTopBorrower(
      Map<String, dynamic> body) async {
    try {
      var res =
      await ApiService.get(url: ApiRoutes.getTopBorrower, body: body);
      log("getTopBorrower res = ${res.data}");

      var apiRes = ApiResponse<List<RecentUserModel>>.fromListJson(res.data,
              (data) => data.map((e) => RecentUserModel.fromJson(e)).toList());

      return apiRes;
    } catch (e, t) {
      logger.i("getTopBorrower error = $e,$t");
      return ApiResponse.fromError();
    }
  }
}
