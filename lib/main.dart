import 'package:flutter/material.dart';
import 'package:flutter_hi_cache/flutter_hi_cache.dart';
import 'package:trip_flutter_app/pages/login_page.dart';
import 'package:trip_flutter_app/util/cache_util.dart';
import 'package:trip_flutter_app/util/screen_adapter_helper.dart';

import 'navigator/tab_navigator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter之旅',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: FutureBuilder<dynamic>(
        future: HiCache.preInit(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          ScreenHelper.init(context); // 初始化屏幕适配工具
          if (snapshot.connectionState == ConnectionState.done) {
            if (CacheUtil.getToken() == null) {
              return LoginPage();
            } else {
              return TabNavigator();
            }
          } else {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }
        },
      ),
    );
  }
}
