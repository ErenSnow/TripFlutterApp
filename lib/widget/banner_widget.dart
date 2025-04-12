import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:trip_flutter_app/util/navigator_util.dart';
import 'package:trip_flutter_app/util/screen_adapter_helper.dart';

import '../model/banner_model.dart';

/// Banner轮播图组件
class BannerWidget extends StatefulWidget {
  final List<BannerItem?> bannerList;

  const BannerWidget({super.key, required this.bannerList});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CarouselSlider(
          items:
              widget.bannerList.map((item) => _tabImage(item, width)).toList(),
          carouselController: _controller,
          options: CarouselOptions(
            height: 200.px,
            autoPlay: true,
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        Positioned(bottom: 10, left: 0, right: 0, child: _indicator()),
      ],
    );
  }

  Widget _tabImage(BannerItem? bannerBean, width) {
    return GestureDetector(
      onTap: () {
        NavigatorUtil.goWeb(bannerBean?.url ?? "");
      },
      child: Image.network(
        bannerBean?.imagePath ?? "",
        width: width,
        fit: BoxFit.cover,
      ),
    );
  }

  _indicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          widget.bannerList.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 6,
                height: 6,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (Colors.white).withValues(
                    alpha: _current == entry.key ? 0.9 : 0.4,
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }
}
