import 'dart:developer';
import 'package:core/api_routes/api_routes.dart';
import 'package:core/styles/app_themes.dart';
import 'package:dio/dio.dart';

class ApiService {
  static final instance = ApiService._();
  static Dio dio = createDio();

  String apiKey = "", token = "";
  bool isWeb = false;

  factory ApiService() => instance;

  ApiService._();

  setApiKey(
      {required String apiKey, required String token, bool isWeb = false}) {
    this.apiKey = apiKey;
    this.token = token;
    if (!isWeb) {
      dio.options.headers.addAll({
        'apikey': this.apiKey,
        'token': this.token,
      });

      log("dio.options.headers = ${dio.options.headers}");

    } else {
      dio.options.headers.clear();
      dio.options.queryParameters.addAll({
        'apikey': this.apiKey,
        'token': this.token,
      });
    }

    this.isWeb = isWeb;
    logger.i(dio.options.headers);
  }

  static createDio() {
    Dio d = Dio(
      BaseOptions(
          baseUrl: ApiRoutes.baseUrl,
          // connectTimeout: 9000,
          // receiveTimeout: 9000,
          //sendTimeout: 9000
          connectTimeout: 900000,
          receiveTimeout: 900000,
          sendTimeout: 60 * 100000),
    );

    d.interceptors.addAll({DioInterceptor(dio: d)});
    return d;
  }

  static Future<Response> get({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    log("url = $url");
    log("body = $body");
    var res = await dio.get(
      url,
      queryParameters: body,
    );
    return res;
  }

  static Future<Response> post(
      {required String url, required Map<String, dynamic> body}) async {
    logger.wtf("body --> $body");
    var res = await dio.post(url, data: FormData.fromMap(body));
    return res;
  }
}

class DioInterceptor extends Interceptor {
  final dio;

  DioInterceptor({this.dio});

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.wtf("response = ${response.statusCode},  ${response.realUri}");
    handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioErrorType.connectTimeout:
        throw ConnectionTimeOutException(err.requestOptions);
      case DioErrorType.sendTimeout:
        // TODO: Handle this case.
        break;
      case DioErrorType.receiveTimeout:
        // TODO: Handle this case.
        break;
      case DioErrorType.response:
        switch (err.response!.statusCode) {
          case 400:
            //snackError("400");
            break;
          case 500:
            //snackError("500");
            break;
          case 404:
            //snackError("404");
            break;
        }
        break;
      case DioErrorType.cancel:
        // TODO: Handle this case.
        break;
      case DioErrorType.other:
        // TODO: Handle this case.
        break;
    }
    return handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    return handler.next(options);
  }
}

class ConnectionTimeOutException extends DioError {
  final option;

  ConnectionTimeOutException(this.option) : super(requestOptions: option);

  @override
  String toString() {
    // TODO: implement toString
    return "Please try again";
  }
}
