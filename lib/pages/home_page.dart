import 'package:flutter/material.dart';
import 'package:trip_flutter_app/dao/login_dao.dart';
import 'package:trip_flutter_app/widget/banner_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final bannerList = [
    "https://o.devio.org/images/other/rn-cover2.png",
    "https://o.devio.org/images/other/rn-cover2.png",
    "https://o.devio.org/images/other/rn-cover2.png",
    "https://o.devio.org/images/other/rn-cover2.png",
    "https://o.devio.org/images/other/rn-cover2.png",
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(title: Text("首页"), actions: [_logoutBtn()]),
      body: Column(children: [BannerWidget(bannerList: bannerList)]),
    );
  }

  _logoutBtn() {
    return ElevatedButton(
      onPressed: () {
        LoginDao.logout();
      },
      child: Text("登出"),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
