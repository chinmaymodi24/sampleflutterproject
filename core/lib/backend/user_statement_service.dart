import 'dart:convert';
import 'dart:developer';
import 'package:core/api_routes/api_routes.dart';
import 'package:core/model/api_generic_model.dart';
import 'package:core/model/sponsor_model.dart';
import 'package:core/model/user_statement_details.dart';
import 'package:core/model/user_statement_list_model.dart';
import 'package:core/network/dio_config.dart';
import 'package:core/styles/app_themes.dart';

class UserStatementService {
  //give status of loan installment from admin
  static Future<ApiResponse> giveStatusOfLoanInstallment(
      Map<String, dynamic> body) async {
    try {
      var res = await ApiService.post(
          url: ApiRoutes.giveStatusOfLoanInstallment, body: body);
      log("giveStatusOfLoanInstallment res = ${res.data}");
      var apiRes = ApiResponse.fromJson(res.data);
      return apiRes;
    } catch (e) {
      logger.i("giveStatusOfLoanInstallment error = $e");
      return ApiResponse.fromError();
    }
  }

  //give approval from admin
  static Future<ApiResponse> giveLoanStatusFromAdmin(
      Map<String, dynamic> body) async {
    try {
      var res = await ApiService.post(
          url: ApiRoutes.giveLoanStatusFromAdmin, body: body);
      log("giveLoanStatusFromAdmin res = ${res.data}");
      var apiRes = ApiResponse.fromJson(res.data);
      return apiRes;
    } catch (e) {
      logger.i("giveLoanStatusFromAdmin error = $e");
      return ApiResponse.fromError();
    }
  }

  //give approval from admin
  static Future<ApiResponse> loanReOpenFromAdmin(
      Map<String, dynamic> body) async {
    try {
      var res = await ApiService.post(
          url: ApiRoutes.reOpenLoanFromAdmin, body: body);
      log("loanReOpenFromAdmin res = ${res.data}");
      var apiRes = ApiResponse.fromJson(res.data);
      return apiRes;
    } catch (e) {
      logger.i("loanReOpenFromAdmin error = $e");
      return ApiResponse.fromError();
    }
  }


  //edit loan
  static Future<ApiResponse> newEditLoan(
      Map<String, dynamic> body) async {
    try {
      var res = await ApiService.post(
          url: ApiRoutes.newEditLoan, body: body);
      log("newEditLoan res = ${res.data}");
      var apiRes = ApiResponse.fromJson(res.data);
      return apiRes;
    } catch (e) {
      logger.i("newEditLoan error = $e");
      return ApiResponse.fromError();
    }
  }




  //get user loan detail
  static Future<ApiResponse<UserStatementDetailModel>> getMyLoanDetails(
      Map<String, dynamic> body) async {
    try {
      var res = await ApiService.get(
          url: ApiRoutes.getUserStatementDetails, body: body);
      log("getMyLoanDetails res = ${res.data}");
      var apiRes = ApiResponse<UserStatementDetailModel>.fromMapJson(
          res.data, (data) => UserStatementDetailModel.fromJson(data));
      log("res = ${apiRes.r!.toJson()}");
      return apiRes;
    } catch (e, t) {
      logger.i("getMyLoanDetails error = $e,$t, $body");
      return ApiResponse.fromError();
    }
  }

  //get all User statement
  static Future<ApiResponse<List<UserStatementListModel>>> getAllUserStatement(
      Map<String, dynamic> body) async {
    try {
      var res =
          await ApiService.get(url: ApiRoutes.getUserStatementList, body: body);
      log("getAllSponsoredLoan res = ${res.data}");

      var apiRes = ApiResponse<List<UserStatementListModel>>.fromListJson(
          res.data,
          (data) =>
              data.map((e) => UserStatementListModel.fromJson(e)).toList());

      return apiRes;
    } catch (e, t) {
      logger.i("getAllSponsoredLoan error = $e,$t");
      return ApiResponse.fromError();
    }
  }

  //  get all sponsor by loan id
  static Future<ApiResponse<List<SponsorModel>>> getAllSponsorById(
      Map<String, dynamic> body) async {
    try {
      var res =
          await ApiService.get(url: ApiRoutes.getAllSponsorById, body: body);
      log("getAllSponsorById res = ${res.data}");

      var apiRes = ApiResponse<List<SponsorModel>>.fromListJson(res.data,
          (data) => data.map((e) => SponsorModel.fromJson(e)).toList());

      return apiRes;
    } catch (e, t) {
      logger.i("getAllSponsorById error = $e,$t");
      return ApiResponse.fromError();
    }
  }

  //give approval from admin
  static Future<ApiResponse> editLoanDetails(List<Detail> list) async {
    try {
      Map<String, dynamic> body = {
        "details":
            json.encode(List<dynamic>.from(list.map((x) => x.toAddUpdate()))),
      };
      var res =
          await ApiService.post(url: ApiRoutes.loanEditDetails, body: body);
      log("editLoanDetails res = ${res.data}");
      var apiRes = ApiResponse.fromJson(res.data);
      return apiRes;
    } catch (e) {
      logger.i("editLoanDetails error = $e");
      return ApiResponse.fromError();
    }
  }
}
