import 'package:flutter/material.dart';
import 'package:trip_flutter_app/dao/login_dao.dart';
import 'package:trip_flutter_app/pages/search_page.dart';
import 'package:trip_flutter_app/util/navigator_util.dart';
import 'package:trip_flutter_app/widget/banner_widget.dart';
import 'package:trip_flutter_app/widget/search_bar_widget.dart';

import '../dao/home_dao.dart';
import '../model/banner_model.dart';
import '../util/view_util.dart';
import '../widget/loading_container.dart';

const searchBarDefaultText = '网红打开地 景点 酒店 美食';

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

  get _appBar {
    //获取刘海屏实际的Top 安全边距
    double top = MediaQuery.of(context).padding.top;
    return Column(
      children: [
        shadowWarp(
          child: Container(
            padding: EdgeInsets.only(top: top),
            height: 60 + top,
            decoration: BoxDecoration(
              color: Color.fromARGB((appBarAlpha * 255).toInt(), 255, 255, 255),
            ),
            child: SearchBarWidget(
              searchBarType:
                  appBarAlpha > 0.2
                      ? SearchBarType.homeLight
                      : SearchBarType.home,
              inputBoxClick: _jumpToSearch,
              defaultText: searchBarDefaultText,
              rightButtonClick: () {
                LoginDao.logout();
              },
            ),
          ),
        ),
        // bottom line
        Container(
          height: appBarAlpha > 0.2 ? 0.5 : 0,
          decoration: const BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 0.5)],
          ),
        ),
      ],
    );
  }

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

  void _jumpToSearch() {
    NavigatorUtil.push(context, const SearchPage());
  }
}
