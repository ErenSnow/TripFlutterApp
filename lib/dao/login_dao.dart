import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:trip_flutter_app/config/app_config.dart';
import 'package:trip_flutter_app/dao/header_util.dart';
import 'package:trip_flutter_app/util/cache_util.dart';
import 'package:trip_flutter_app/util/navigator_util.dart';

import '../util/toast_util.dart';

class LoginDao {
  /// 登录
  static lgoin({
    required String username,
    required String password,
    required VoidCallback changed,
  }) async {
    Map<String, String> paramsMap = {};
    paramsMap["username"] = username;
    paramsMap["password"] = password;
    Uri uri = Uri.https(AppConfig.baseUrl, "/user/login", paramsMap);
    final response = await http.post(uri, headers: hiHeaders());
    Utf8Decoder utf8decoder = Utf8Decoder(); // 中文乱码
    String bodyString = utf8decoder.convert(response.bodyBytes);
    print(bodyString);
    if (response.statusCode == 200) {
      var request = json.decode(bodyString);
      if (request["errorCode"] == 0 && request["data"] != null) {
        // 保存Token
        CacheUtil.saveToken(request["data"]["token"]);
        changed();
      } else {
        showToast(request["errorMsg"]);
        throw Exception(request["errorMsg"]);
      }
    } else {
      showToast(bodyString);
      throw Exception(bodyString);
    }
  }

  /// 退出登录
  static void logout() {
    // 清除Token
    CacheUtil.removeToken();
    // 跳转登录页
    NavigatorUtil.goLogin();
  }
}
