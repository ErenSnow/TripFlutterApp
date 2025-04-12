// 单个 Banner 数据项
import 'base_model.dart';

class BannerItem {
  final String desc;
  final int id;
  final String imagePath;
  final int isVisible;
  final String title;
  final String url;

  BannerItem({
    required this.desc,
    required this.id,
    required this.imagePath,
    required this.isVisible,
    required this.title,
    required this.url,
  });

  factory BannerItem.fromJson(Map<String, dynamic> json) {
    return BannerItem(
      desc: json['desc'] ?? '',
      id: json['id'] ?? 0,
      imagePath: json['imagePath'] ?? '',
      isVisible: json['isVisible'] ?? 0,
      title: json['title'] ?? '',
      url: json['url'] ?? '',
    );
  }
}

// 整个 Banner 接口的响应模型
class BannerModel extends BaseModel<List<BannerItem>> {
  BannerModel.fromJson(Map<String, dynamic> json)
    : super.fromJson(
        json,
        // 处理 data 数组的解析
        (data) =>
            (data as List).map((item) => BannerItem.fromJson(item)).toList(),
      );
}
