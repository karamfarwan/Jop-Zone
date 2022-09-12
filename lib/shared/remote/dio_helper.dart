import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class DioHelper {
  static Dio dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://student.valuxapps.com/api/',
        // headers: {
        //   'Content-Type':'application/json'
        // },
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> getData({
    @required String url,
    Map<String, dynamic> query,
    String lang = 'en',
    String token,
  }) async {
    dio.options.headers = {
      'lang': lang,
      'Content-Type': 'application/json',
      'Authorization': token ?? '',
    };

    return await dio.get(
      url,
      queryParameters: query,
    );
  }

  static Future<Response> postData({
    @required String url,
    Map<String, dynamic> query,
    @required Map<String, dynamic> data,
    String lang = 'ar',
    String token,
  }) async {
    dio.options.headers = {
      'lang': lang,
      'Content-Type': 'application/json',
      'Authorization': token,
    };
    return dio.post(
      url,
      queryParameters: query,
      data: data,
    );
  }

  static Future<Response> postSocialData({Map<String, dynamic> data}) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAAIQasDlw:APA91bGztG0B0_SjHChpqs7MW20S9vdOx_wiiKgraU74OuLMCfr0cWzz4xdU-_6qoMjcS0r1anxYsFT8wcOQfPQB8lRcXuu_Y6q4xvgBlFayjRsaESud4TuBAF2zylqLqwOmIXXoVxua',
    };
    return await dio.post('https://fcm.googleapis.com/fcm/send', data: data);
  }
}
