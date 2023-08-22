import 'dart:developer';
import 'package:core/api_routes/api_routes.dart';
import 'package:core/model/api_generic_model.dart';
import 'package:core/model/loan_list_model.dart';
import 'package:core/model/my_loan_details_model.dart';
import 'package:core/network/dio_config.dart';
import 'package:core/styles/app_themes.dart';

import '../model/sponsor_model.dart';

class LoanService {
  //withDraw/Close loan from user side
  static Future<ApiResponse> withDrawLoanFromUser(
      Map<String, dynamic> body) async {
    try {
      var res = await ApiService.post(
          url: ApiRoutes.withDrawLoanFromUser, body: body);
      log("withDrawLoanFromUser res = ${res.data}");
      var apiRes = ApiResponse.fromJson(res.data);
      return apiRes;
    } catch (e,t) {
      logger.i("withDrawLoanFromUser error = $e,\n$t");
      return ApiResponse.fromError();
    }
  }

  //give loan status from sponsor
  static Future<ApiResponse> giveLoanStatusFromSponsor(
      Map<String, dynamic> body) async {
    try {
      var res = await ApiService.post(
          url: ApiRoutes.giveLoanStatusFromSponsor, body: body);
      log("giveLoanStatusFromSponsor res = ${res.data}");
      var apiRes = ApiResponse.fromJson(res.data);
      return apiRes;
    } catch (e) {
      logger.i("giveLoanStatusFromSponsor error = $e");
      return ApiResponse.fromError();
    }
  }


  //hide or unhide loan from admin
  static Future<ApiResponse> hideOrUnHideLoan(
      Map<String, dynamic> body) async {
    try {
      var res = await ApiService.post(
          url: ApiRoutes.hideOrUnHideLoan, body: body);
      log("hideOrUnHideLoan res = ${res.data}");
      var apiRes = ApiResponse.fromJson(res.data);
      return apiRes;
    } catch (e) {
      logger.i("hideOrUnHideLoan error = $e");
      return ApiResponse.fromError();
    }
  }


  //get all sponsored Loan
  static Future<ApiResponse<List<MyLoanListModel>>> getAllSponsoredLoan(
      Map<String, dynamic> body) async {
    try {
      var res =
          await ApiService.get(url: ApiRoutes.getAllSponserLoan, body: body);
      log("getAllSponsoredLoan res = ${res.data}");

      var apiRes = ApiResponse<List<MyLoanListModel>>.fromListJson(res.data,
          (data) => data.map((e) => MyLoanListModel.fromJson(e)).toList());

      return apiRes;
    } catch (e, t) {
      logger.i("getAllSponsoredLoan error = $e,$t");
      return ApiResponse.fromError();
    }
  }

  //get all My Loan
  static Future<ApiResponse<List<MyLoanListModel>>> getAllMyLoan(
      Map<String, dynamic> body) async {
    try {
      var res = await ApiService.get(url: ApiRoutes.getAllMyLoan, body: body);
      log("getAllMyLoan res = ${res.data}");

      var apiRes = ApiResponse<List<MyLoanListModel>>.fromListJson(res.data,
          (data) => data.map((e) => MyLoanListModel.fromJson(e)).toList());

      return apiRes;
    } catch (e, t) {
      logger.i("getAllMyLoan error = $e,$t");
      return ApiResponse.fromError();
    }
  }

  //get My Loan detail
  static Future<ApiResponse<MyLoanDetailModel>> getMyLoanDetails(
      Map<String, dynamic> body) async {
    try {
      var res =
          await ApiService.get(url: ApiRoutes.getMyLoanDetail, body: body);
      logger.i("getMyLoanDetails res = ${res.data}");
      var apiRes = ApiResponse<MyLoanDetailModel>.fromMapJson(
          res.data, (data) => MyLoanDetailModel.fromJson(data));
      log("res = ${apiRes.r!.toJson()}");
      return apiRes;
    } catch (e, t) {
      logger.i("getMyLoanDetails error = $e,$t ${body}, $body");
      return ApiResponse.fromError();
    }
  }

  //get Sponsor pending/Approved Loan detail
  static Future<ApiResponse<MyLoanListModel>> getSponsorDetails(
      Map<String, dynamic> body) async {
    try {
      var res =
          await ApiService.get(url: ApiRoutes.getSponsorDetail, body: body);
      log("getSponsorDetails res = ${res.data}");
      var apiRes = ApiResponse<MyLoanListModel>.fromMapJson(
          res.data, (data) => MyLoanListModel.fromJson(data));
      log("res = ${apiRes.r!.toJson()}");
      return apiRes;
    } catch (e, t) {
      logger.i("getSponsorDetails error = $e,$t, $body");
      return ApiResponse.fromError();
    }
  }

  /// GET ALL MY PENDING LOANS
  static Future<ApiResponse<List<SponsorModel>>> getAllPendingLoans(
      Map<String, dynamic> body) async {
    try {
      var res =
          await ApiService.get(url: ApiRoutes.pendingLoanList, body: body);
      logger.i("getAllPendingLoans res = ${res.data}");

      var apiRes = ApiResponse<List<SponsorModel>>.fromListJson(res.data,
          (data) => data.map((e) => SponsorModel.fromJson(e)).toList());
      return apiRes;
    } catch (e, t) {
      logger.i("getAllPendingLoans error = $e,$t");
      return ApiResponse.fromError();
    }
  }

}
