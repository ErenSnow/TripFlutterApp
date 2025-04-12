import 'package:flutter/material.dart';
import 'package:trip_flutter_app/dao/login_dao.dart';
import 'package:trip_flutter_app/widget/banner_widget.dart';

import '../dao/home_dao.dart';
import '../model/banner_model.dart';
import '../widget/loading_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  List<BannerItem?> bannerList = [];

  double appBarAlpha = 0.0;

  int appbarScrollOffset = 100;

  bool _loading = true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      body: LoadingContainer(
        isLoading: _loading,
        child: Stack(children: [_contentView, _appBar]),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _handleRefresh();
  }

  get _contentView => MediaQuery.removePadding(
    removeTop: true, // 移除顶部空白
    context: context,
    child: RefreshIndicator(
      onRefresh: _handleRefresh,
      color: Colors.blue,
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
  );

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

  Future<void> _handleRefresh() async {
    try {
      BannerModel? model = await HomeDao.fetch();
      if (model == null) {
        setState(() {
          _loading = false;
        });
        return;
      }
      setState(() {
        bannerList = model?.data ?? [];
        _loading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        _loading = false;
      });
    }
  }
}
