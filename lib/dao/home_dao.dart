import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../model/banner_model.dart';
import '../util/navigator_util.dart';
import 'header_util.dart';

///首页大接口
class HomeDao {
  static Future<BannerModel?>? fetch() async {
    Uri uri = Uri.https(AppConfig.baseUrl, "/banner/json");
    final response = await http.get(uri, headers: hiHeaders());
    Utf8Decoder utf8decoder = const Utf8Decoder(); //fix 中文乱码
    String bodyString = utf8decoder.convert(response.bodyBytes);
    // print(bodyString);
    debugPrint(bodyString);
    if (response.statusCode == 200) {
      var result = json.decode(bodyString);
      return BannerModel.fromJson(result);
    } else {
      if (response.statusCode == 401) {
        NavigatorUtil.goLogin();
        return null;
      }
      throw Exception(bodyString);
    }
  }
}
