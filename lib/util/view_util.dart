// 间距
import 'package:flutter/material.dart';

SizedBox hiSpace({double width = 1, double height = 1}) {
  return SizedBox(width: width, height: height);
}

///添加阴影
Widget shadowWarp({required Widget child, EdgeInsetsGeometry? padding}) {
  return Container(
    padding: padding,
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        //AppBar渐变遮罩背景
        colors: [Color(0x66000000), Colors.transparent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
    child: child,
  );
}
