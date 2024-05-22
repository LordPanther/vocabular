import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:vocab_app/constants/key_constant.dart';
import 'package:vocab_app/data/models/error_model.dart';
import 'package:vocab_app/utils/logger.dart';

import 'api_url.dart';

class Request {
  Dio _dio = Dio();

  Request({required String baseUrl, required String apiKey}) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      receiveTimeout: environment.receiveTimeout as Duration,
      connectTimeout: environment.connectTimeout as Duration,
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json",
      },
    ));
  }

  Future<Object> requestApi({
    required String url,
    required String prompt,
  }) async {
    Logger.info("URL: $url");
    try {
      var response = await _dio.post(
        url,
        data: json.encode({
          'model': 'text-davinci-003',
          'prompt': prompt,
          'max_tokens': 100,
        }),
      );

      if (response.statusCode == 200) {
        return response.data['choices'][0]['text'];
      } else {
        throw Exception('Failed to generate text');
      }
    } on DioException catch (e) {
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
        case DioExceptionType.badCertificate:
          errorModel.description = KEY_CONST.request_bad_certificate;
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
