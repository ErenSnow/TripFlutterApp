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

  double appBarAlpha = 0.0;

  int appbarScrollOffset = 100;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Stack(
        children: [
          MediaQuery.removePadding(
            removeTop: true, // 移除顶部空白
            context: context,
            child: NotificationListener(
              onNotification: (scrollNotification) {
                if (scrollNotification is ScrollUpdateNotification &&
                    scrollNotification.depth == 0) {
                  // 通过depth来过滤指定widget发出的滚动事件，depth==0表示最外层的列表发出的滚动事件
                  _onScroll(scrollNotification.metrics.pixels);
                }
                return false;
              },
              child: _listView,
            ),
          ),
          _appBar,
        ],
      ),
    );
  }

  get _appBar => Opacity(
    opacity: appBarAlpha,
    child: Stack(
      children: [
        Container(
          height: 80,
          decoration: BoxDecoration(color: Colors.white),
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text("首页"),
            ),
          ),
        ),
      ],
    ),
  );

  get _listView => ListView(
    children: [
      BannerWidget(bannerList: bannerList),
      SizedBox(height: 1000, child: ListTile(title: Text("data"))),
    ],
  );

  _logoutBtn() {
    return ElevatedButton(
      onPressed: () {
        LoginDao.logout();
      },
      child: Text("登出"),
    );
  }

  void _onScroll(double offset) {
    var alpha = offset / appbarScrollOffset;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
  }

  @override
  bool get wantKeepAlive => true;
}
