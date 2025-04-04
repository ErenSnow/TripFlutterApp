import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../dao/login_dao.dart';
import '../util/navigator_util.dart';
import '../util/string_util.dart';
import '../util/toast_util.dart';
import '../util/view_util.dart';
import '../widget/input_widget.dart';
import '../widget/login_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoginEnable = false;
  String? username, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 防止键盘弹起
      body: Stack(children: [..._background(), _content()]),
    );
  }

  _background() {
    return [
      Positioned.fill(
        child: Image.asset("images/login-bg1.jpg", fit: BoxFit.cover),
      ),
      Positioned.fill(
        child: Container(decoration: BoxDecoration(color: Colors.black54)),
      ),
    ];
  }

  _content() {
    return Positioned.fill(
      left: 25,
      right: 25,
      child: ListView(
        children: [
          hiSpace(height: 100),
          Text("账号密码登录", style: TextStyle(fontSize: 26, color: Colors.white)),
          hiSpace(height: 40),
          InputWidget(
            "请输入账号",
            onChanged: (text) {
              username = text;
              _checkInput();
            },
          ),
          hiSpace(height: 10),
          InputWidget(
            "请输入密码",
            obscureText: true,
            onChanged: (text) {
              password = text;
              _checkInput();
            },
          ),
          hiSpace(height: 50),
          LoginButton("登录", enable: isLoginEnable, onPressed: () => _login()),
          hiSpace(height: 15),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () => _jumpRegistration(),
              child: Text("注册账号", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  _checkInput() {
    setState(() {
      isLoginEnable = isNotEmpty(username) && isNotEmpty(password);
    });
  }

  _login() async {
    try {
      LoginDao.lgoin(
        username: username!,
        password: password!,
        changed: () {
          showToast("登录成功");
          // 跳转首页
          NavigatorUtil.goHome(context);
        },
      );
    } catch (e) {
      print(e);
    }
  }

  /// 跳转H5
  _jumpRegistration() async {
    Uri uri = Uri.parse("https://www.baidu.com");
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $uri';
    }
  }
}
