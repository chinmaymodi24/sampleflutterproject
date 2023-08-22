import 'dart:developer';
import 'package:core/model/admin_notification_model.dart';
import 'package:core/model/sponsor_model.dart';
import '../api_routes/api_routes.dart';
import '../model/api_generic_model.dart';
import '../network/dio_config.dart';
import '../styles/app_themes.dart';

class NotificationAPIService {
  /// UPDATE USER FCM
  static Future<void> updateFCMToken(Map<String, dynamic> body) async {
    try {
      logger.i("body => $body");
      var res = await ApiService.post(url: ApiRoutes.fcmUpdate, body: body);
      log("updateFCMToken res = ${res.data}");
    } catch (e, t) {
      logger.i("updateFCMToken error = $e,$t");
    }
  }

  /// SEND NOTIFICATION TO ALL USER
  static Future<ApiResponse> sendNotificationToAllUser(
      Map<String, dynamic> body) async {
    try {
      var res = await ApiService.post(
          url: ApiRoutes.sendAllUserNotification, body: body);
      log("updateFCMToken res = ${res.data}");
      var apiRes = ApiResponse.fromJson(res.data);
      return apiRes;
    } catch (e, t) {
      logger.i("updateFCMToken error = $e,$t");
      return ApiResponse.fromError();
    }
  }

  ///Get user all notifications
  static Future<ApiResponse<List<SponsorModel>>> userNotificationList(
      Map<String, dynamic> body) async {
    try {
      var res = await ApiService.get(
          url: ApiRoutes.getUserAllNotification, body: body);
      logger.i("userNotificationList res = ${res.data}");

      var apiRes = ApiResponse<List<SponsorModel>>.fromListJson(res.data,
          (data) => data.map((e) => SponsorModel.fromJson(e)).toList());
      return apiRes;
    } catch (e, t) {
      logger.i("userNotificationList error = $e,$t");
      return ApiResponse.fromError();
    }
  }

  ///Get Admin all notifications
  static Future<ApiResponse<List<AdminNotificationModel>>>
      adminNotificationList(int count) async {
    try {
      var res = await ApiService.get(
          url: ApiRoutes.getAllAdminNotification, body: {"count": count});
      logger.i("AdminNotification res = ${res.data}");

      var apiRes = ApiResponse<List<AdminNotificationModel>>.fromListJson(
          res.data,
          (data) =>
              data.map((e) => AdminNotificationModel.fromJson(e)).toList());
      return apiRes;
    } catch (e, t) {
      logger.i("AdminNotification error = $e,$t");
      return ApiResponse.fromError(errorMessage: e.toString());
    }
  }
}
