import 'package:flutter/material.dart';
import 'package:trip_flutter_app/model/search_article_model.dart';

/// 搜索结果项组件
class SearchItemWidget extends StatelessWidget {
  /// 文章数据
  final SearchArticleBean article;
  
  /// 点击回调
  final Function(SearchArticleBean)? onTap;
  
  /// 收藏按钮点击回调
  final Function(SearchArticleBean, bool)? onCollectTap;
  
  const SearchItemWidget({
    Key? key,
    required this.article,
    this.onTap,
    this.onCollectTap,
  }) : super(key: key);
  
  /// 处理HTML标签，返回RichText组件
  Widget _buildHighlightedTitle(String htmlTitle) {
    // 定义正则表达式查找<em>标签
    final RegExp emRegex = RegExp(r"<em class='highlight'>(.*?)<\/em>");
    
    // 存储所有文本片段
    List<TextSpan> spans = [];
    
    // 记录当前处理位置
    int currentPosition = 0;
    
    // 查找所有匹配项
    for (final match in emRegex.allMatches(htmlTitle)) {
      // 添加高亮前的普通文本
      if (match.start > currentPosition) {
        spans.add(
          TextSpan(
            text: htmlTitle.substring(currentPosition, match.start),
            style: const TextStyle(
              fontSize: 16.0, 
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        );
      }
      
      // 添加高亮文本
      final highlightedText = match.group(1) ?? '';
      spans.add(
        TextSpan(
          text: highlightedText,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,  // 深橙色文字
            backgroundColor: Color(0x33FFC107),  // 琥珀色背景
            decoration: TextDecoration.underline,  // 添加下划线
            decorationColor: Colors.deepOrange,
          ),
        ),
      );
      
      // 更新处理位置
      currentPosition = match.end;
    }
    
    // 添加剩余的普通文本
    if (currentPosition < htmlTitle.length) {
      spans.add(
        TextSpan(
          text: htmlTitle.substring(currentPosition),
          style: const TextStyle(
            fontSize: 16.0, 
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      );
    }
    
    // 如果没有高亮部分，直接返回纯文本
    if (spans.isEmpty) {
      spans.add(
        TextSpan(
          text: htmlTitle,
          style: const TextStyle(
            fontSize: 16.0, 
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      );
    }
    
    // 返回RichText组件
    return RichText(
      text: TextSpan(children: spans),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
  
  /// 移除HTML标签，返回纯文本
  String _removeHtmlTags(String htmlText) {
    return htmlText.replaceAll(RegExp(r'<[^>]*>'), '');
  }
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!(article);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[200]!,
              width: 1.0,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 文章标题 - 使用处理HTML标签的方法
            _buildHighlightedTitle(article.title),
            const SizedBox(height: 8.0),
            // 文章详情
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 作者信息
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person,
                        size: 16.0,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4.0),
                      Expanded(
                        child: Text(
                          _removeHtmlTags(article.author.isNotEmpty ? article.author : article.shareUser),
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                // 分类信息
                Expanded(
                  child: Text(
                    '${_removeHtmlTags(article.superChapterName)}/${_removeHtmlTags(article.chapterName)}',
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                // 收藏按钮
                IconButton(
                  icon: Icon(
                    article.collect ? Icons.favorite : Icons.favorite_border,
                    color: article.collect ? Colors.red : Colors.grey,
                    size: 20.0,
                  ),
                  onPressed: () {
                    if (onCollectTap != null) {
                      onCollectTap!(article, !article.collect);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 4.0),
            // 发布时间
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(
                  Icons.access_time,
                  size: 14.0,
                  color: Colors.grey,
                ),
                const SizedBox(width: 4.0),
                Text(
                  article.niceDate,
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
