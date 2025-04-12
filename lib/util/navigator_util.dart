import 'package:flutter/material.dart';
import 'package:trip_flutter_app/pages/home_page.dart';
import 'package:trip_flutter_app/pages/login_page.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigatorUtil {
  /// 用于在获取不到context的地方，如dao中跳转页面时使用，需要在HomePage赋值
  static BuildContext? _context;

  static updateContext(BuildContext context) {
    _context = context;
  }

  /// 跳转指定页面
  static void push(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  /// 跳转首页
  static void goHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  /// 跳转登录页
  static void goLogin() {
    Navigator.pushReplacement(
      _context!,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  /// 跳转H5
  static void goWeb(String url) async {
    Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $uri';
    }
  }
}
