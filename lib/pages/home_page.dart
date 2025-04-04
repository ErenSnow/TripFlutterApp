import 'package:flutter/material.dart';
import 'package:trip_flutter_app/dao/login_dao.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(appBar: AppBar(title: Text("首页"), actions: [_logoutBtn()]));
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
