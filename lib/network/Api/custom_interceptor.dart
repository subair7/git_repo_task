import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CustomInterceptor extends Interceptor {
  final BuildContext context;

  CustomInterceptor(this.context);

  // CustomInterceptor({ Key key, @required this.ctx });

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print("onRequest");
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(response.statusCode);
    print("onResponse");
    return super.onResponse(response, handler);
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    print("onError: ${err.response!.statusMessage}");
    ScaffoldMessenger.of(context).showSnackBar((SnackBar(
        content: Text(
      '${err.response!.statusMessage}',
      style: const TextStyle(color: Colors.yellow),
    ))));
    return handler.next(err); // <--- THE TIP IS HERE
  }
}
