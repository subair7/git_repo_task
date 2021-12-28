import 'dart:async';
import 'dart:convert';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:git_repo/network/Response/post_response.dart';

class ApiHandler {
  ///Production URL
  static final String BASE_URL = "https://api.github.com/users/JakeWharton/repos?page=1&per_page=15";

  static ApiHandler? _instance;
  static Dio? _api;

  static ApiHandler getInstance() {
    _instance ??= ApiHandler();
    return _instance!;
  }



  static Future<Dio?> getAPI(BuildContext context, String tok) async {

    _api = new Dio();
    _api!.options.baseUrl = BASE_URL;
    _api!.options.headers["Content-Type"] = "application/json";
    _api!.options.headers["Accept"] = "application/json";

    return _api;
  }


  static Future<List<PostResponse>?> fetchPost(
    BuildContext context,int pageKey
  ) async {
    try {
      List<PostResponse> myModels;
      var res = await http.get(Uri.parse("https://api.github.com/users/JakeWharton/repos?page=$pageKey&per_page=15"));
      myModels=(json.decode(res.body) as List).map((i) =>
          PostResponse.fromJson(i)).toList();
      return myModels;
    } catch (e) {
    }
    return null;
  }


}
