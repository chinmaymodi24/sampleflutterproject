import 'dart:developer';
import 'package:core/api_routes/api_routes.dart';
import 'package:core/model/api_generic_model.dart';
import 'package:core/model/new_loan_model.dart';
import 'package:core/model/user_model.dart';
import 'package:core/network/dio_config.dart';
import 'package:core/styles/app_themes.dart';

class ReportsService {

  //get new user report
  static Future<ApiResponse<List<UserModel>>> getNewUsers(
      Map<String, dynamic> body) async {
    try {
      var res = await ApiService.get(url: ApiRoutes.getNewUsers, body: body);
      log("getNewUsers res = ${res.data}");

      var apiRes = ApiResponse<List<UserModel>>.fromListJson(
          res.data, (data) => data.map((e) => UserModel.fromJson(e)).toList());

      return apiRes;
    } catch (e, t) {
      logger.i("getNewUsers error = $e,$t");
      return ApiResponse.fromError();
    }
  }

  //new loan model
  static Future<ApiResponse<List<NewLoanModel>>> getNewLoan(
      Map<String, dynamic> body) async {
    try {
      var res = await ApiService.get(url: ApiRoutes.getNewLoan, body: body);
      log("getNewLoan res = ${res.data}");

      var apiRes = ApiResponse<List<NewLoanModel>>.fromListJson(
          res.data, (data) => data.map((e) => NewLoanModel.fromJson(e)).toList());

      return apiRes;
    } catch (e, t) {
      logger.i("getNewLoan error = $e,$t");
      return ApiResponse.fromError();
    }
  }

}
