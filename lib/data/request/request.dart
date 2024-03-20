import 'dart:async';
import 'package:dio/dio.dart';

import '../../constants/key_constant.dart';
import '../../utils/logger.dart';
import '../models/error_model.dart';
import 'api_url.dart';

Map<MethodType, String> methods = {
  MethodType.GET: "GET",
};

class Request {
  Dio _dio = Dio();

  Request({required String baseUrl}) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      receiveTimeout: environment.receiveTimeout as Duration,
      connectTimeout: environment.connectTimeout as Duration,
      contentType: "application/json",
    ));
  }

  Future<Object> requestApi(
      {required MethodType method,
      required String url,
      Map<String, dynamic>? data,
      Map<String, dynamic>? header}) async {
    Logger.info("URL: $url\nbody: $data");
    try {
      var response = await _dio.request(
        url,
        data: data,
        options: Options(method: methods[method], headers: header),
      );

      return response.data;
    } catch (e) {
      Logger.error(e.toString());
      return handleError(e);
    }
  }

  Future<ErrorModel> handleError(dynamic error) async {
    ErrorModel errorModel = ErrorModel();
    errorModel.message = error.toString();
    if (error is DioException) {
      switch (error.error) {
        case DioExceptionType.sendTimeout:
          errorModel.description = KEY_CONST.request_send_timeout;
          break;
        case DioExceptionType.cancel:
          errorModel.description = KEY_CONST.request_cancelled;
          break;
        case DioExceptionType.connectionTimeout:
          errorModel.description = KEY_CONST.request_connect_timeout;
          break;
        case DioExceptionType.unknown:
          errorModel.description = KEY_CONST.no_internet;
          break;
        case DioExceptionType.receiveTimeout:
          errorModel.description = KEY_CONST.request_receive_timeout;
          break;
        case DioExceptionType.badResponse:
          Logger.error(error.response!.toString());
          try {
            errorModel.code = error.response?.statusCode ?? errorModel.code;
            errorModel.description =
                error.response?.data ?? errorModel.description;
          } catch (e) {
            Logger.error(e.toString());
          }
          break;
      }
    }
    return errorModel;
  }
}
