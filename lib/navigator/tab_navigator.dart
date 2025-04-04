import 'package:flutter/material.dart';

import '../pages/home_page.dart';
import '../util/navigator_util.dart';

class TabNavigator extends StatefulWidget {
  const TabNavigator({super.key});

  @override
  State<TabNavigator> createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  var currentIndex = 0;
  final PageController _controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    // 更新导航器的context,供退出登录时使用
    NavigatorUtil.updateContext(context);
    return Scaffold(
      body: PageView(
        controller: _controller,
        physics: NeverScrollableScrollPhysics(),
        children: [HomePage(), HomePage(), HomePage(), HomePage()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.blue,
        currentIndex: currentIndex,
        onTap: (index) {
          _controller.jumpToPage(index);
          setState(() {
            currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          _bottomItem("首页", Icons.home, 0),
          _bottomItem("搜索", Icons.search, 1),
          _bottomItem("旅拍", Icons.camera_alt, 2),
          _bottomItem("我的", Icons.account_circle, 3),
        ],
      ),
    );
  }

  _bottomItem(String title, IconData icon, int index) {
    return BottomNavigationBarItem(
      icon: Icon(icon, color: Colors.grey),
      activeIcon: Icon(icon, color: Colors.blue),
      label: title,
    );
  }
}
