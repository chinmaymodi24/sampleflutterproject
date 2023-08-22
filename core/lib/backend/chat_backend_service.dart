import 'dart:developer';

import 'package:core/api_routes/api_routes.dart';
import 'package:core/model/api_generic_model.dart';
import 'package:core/network/dio_config.dart';
import 'package:core/styles/app_themes.dart';

class ChatBackEndService {
  static Future<ApiResponse> createChatId(
      Map<String, dynamic> body) async {
    try {
      var res = await ApiService.post(
          url: ApiRoutes.createChatId, body: body);
      log("createChatId res = ${res.data}");
      var apiRes = ApiResponse.fromJson(res.data);
      return apiRes;
    } catch (e) {
      logger.i("createChatId error = $e");
      return ApiResponse.fromError();
    }
  }
}
