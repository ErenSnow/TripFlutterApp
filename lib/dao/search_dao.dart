import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:trip_flutter_app/model/search_article_model.dart';

import '../config/app_config.dart';
import 'header_util.dart';

/// 文章搜索Dao
class SearchDao {
  /// 搜索文章列表
  /// [page] 页码，从0开始
  /// [keyword] 搜索关键词，支持多个关键词用空格隔开
  /// [pageSize] 每页数量，取值范围[1-40]，可选
  static Future<SearchArticleModel> searchArticles({
    required int page,
    required String keyword,
    int? pageSize,
  }) async {
    try {
      // 将page转换为字符串，确保路径构建正确
      final String pageStr = page.toString();
      
      // 构建URL路径
      final uri = Uri.https(
        AppConfig.baseUrl,
        "/article/query/$pageStr/json",
      );
      
      // 构建表单数据 - 确保所有值都是字符串类型
      final Map<String, String> formData = {
        'k': keyword,
      };
      
      // 如果提供了pageSize，添加到表单数据
      if (pageSize != null) {
        formData['page_size'] = pageSize.toString();
      }
      
      debugPrint('搜索请求URL: ${uri.toString()}');
      debugPrint('搜索请求表单数据: $formData');
      
      // 发送POST请求，将参数作为表单数据传递
      final response = await http.post(
        uri, 
        headers: hiHeaders(),
        body: formData,  // 作为表单数据传递
      );
      
      // 处理中文编码
      Utf8Decoder utf8decoder = Utf8Decoder();
      String bodyString = utf8decoder.convert(response.bodyBytes);
      
      // 检查响应状态
      if (response.statusCode == 200) {
        debugPrint('搜索响应: $bodyString');
        var result = json.decode(bodyString);
        return SearchArticleModel.fromJson(result);
      } else {
        // 处理错误情况
        debugPrint('搜索请求失败：状态码 ${response.statusCode}');
        throw Exception('搜索请求失败：状态码 ${response.statusCode}');
      }
    } catch (e) {
      // 处理异常
      debugPrint('搜索请求异常：$e');
      throw Exception('搜索请求异常：$e');
    }
  }
}
