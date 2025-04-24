import 'package:flutter/material.dart';
import 'package:trip_flutter_app/dao/search_dao.dart';
import 'package:trip_flutter_app/model/search_article_model.dart';
import 'package:trip_flutter_app/widget/search_bar_widget.dart';
import 'package:trip_flutter_app/widget/search_item_widget.dart';
import 'package:url_launcher/url_launcher.dart';

/// 搜索页面
class SearchPage extends StatefulWidget {
  /// 初始搜索关键词
  final String? initialKeyword;

  const SearchPage({Key? key, this.initialKeyword}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  /// 搜索关键词
  String _keyword = '';
  
  /// 当前页码
  int _currentPage = 0;
  
  /// 每页数量
  final int _pageSize = 20;
  
  /// 是否正在加载
  bool _isLoading = false;
  
  /// 是否有更多数据
  bool _hasMore = true;
  
  /// 文章列表
  final List<SearchArticleBean> _articles = [];
  
  /// 列表控制器
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    
    // 设置初始关键词
    if (widget.initialKeyword != null && widget.initialKeyword!.isNotEmpty) {
      _keyword = widget.initialKeyword!;
      _searchArticles();
    }
    
    // 监听滚动事件，实现加载更多
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// 执行搜索
  void _onSearch(String keyword) {
    // 无论关键词是否变化，都执行搜索
    final bool isNewKeyword = _keyword != keyword;
    
    setState(() {
      _keyword = keyword;
      _currentPage = 0;
      _articles.clear();
      _hasMore = true;
    });
    
    if (isNewKeyword) {
      debugPrint('准备执行新搜索，关键词: $keyword');
    } else {
      debugPrint('重新搜索相同关键词: $keyword');
    }
    
    _searchArticles();
  }

  /// 搜索文章
  Future<void> _searchArticles() async {
    if (_isLoading || !_hasMore || _keyword.isEmpty) {
      debugPrint('跳过搜索: isLoading=$_isLoading, hasMore=$_hasMore, keyword=$_keyword');
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      debugPrint('开始搜索，关键词: "$_keyword", 页码: $_currentPage, 每页数量: $_pageSize');
      final result = await SearchDao.searchArticles(
        page: _currentPage,
        keyword: _keyword,
        pageSize: _pageSize,
      );
      
      // 检查搜索是否已被取消（例如用户快速输入多个搜索词）
      if (!mounted) {
        debugPrint('搜索完成，但组件已被销毁');
        return;
      }
      
      if (result.errorCode == 0) {
        final articles = result.data.datas;
        debugPrint('搜索成功，找到文章数量: ${articles.length}, 总页数: ${result.data.pageCount}, 是否已到最后: ${result.data.over}');
        
        setState(() {
          _isLoading = false;
          
          if (articles.isEmpty) {
            debugPrint('没有找到文章，标记无更多数据');
            _hasMore = false;
          } else {
            _articles.addAll(articles);
            _currentPage++;
            _hasMore = !result.data.over;
            debugPrint('更新文章列表，当前总数: ${_articles.length}, 下一页: $_currentPage, 是否有更多: $_hasMore');
          }
        });
      } else {
        debugPrint('搜索接口返回错误: ${result.errorMsg} (错误码: ${result.errorCode})');
        setState(() {
          _isLoading = false;
          _hasMore = false;
        });
        
        _showErrorMessage('搜索失败: ${result.errorMsg}');
      }
    } catch (e) {
      if (!mounted) return;
      
      debugPrint('搜索过程中出现异常: $e');
      setState(() {
        _isLoading = false;
      });
      
      _showErrorMessage('搜索失败：$e');
    }
  }

  /// 加载更多
  void _loadMore() {
    _searchArticles();
  }

  /// 显示错误信息
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// 处理文章点击
  void _onArticleTap(SearchArticleBean article) async {
    final url = Uri.parse(article.link);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      _showErrorMessage('无法打开链接：${article.link}');
    }
  }

  /// 处理收藏点击
  void _onCollectTap(SearchArticleBean article, bool isCollect) {
    // TODO: 实现收藏功能
    setState(() {
      article.collect = isCollect;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 搜索栏
            SearchBarWidget(
              searchBarType: SearchBarType.normal,
              initialKeyword: _keyword,
              onSearch: _onSearch,
              hintText: '请输入关键词搜索文章',
            ),
            
            // 搜索结果列表
            Expanded(
              child: _buildResultList(),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建搜索结果列表
  Widget _buildResultList() {
    if (_keyword.isEmpty) {
      // 未搜索时显示提示
      return const Center(
        child: Text(
          '请输入关键词搜索',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16.0,
          ),
        ),
      );
    } else if (_articles.isEmpty && !_isLoading) {
      // 无搜索结果
      return const Center(
        child: Text(
          '没有找到相关文章',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16.0,
          ),
        ),
      );
    } else {
      // 显示搜索结果
      return ListView.builder(
        controller: _scrollController,
        itemCount: _articles.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < _articles.length) {
            // 文章项
            return SearchItemWidget(
              article: _articles[index],
              onTap: _onArticleTap,
              onCollectTap: _onCollectTap,
            );
          } else {
            // 加载更多提示
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('没有更多内容了'),
              ),
            );
          }
        },
      );
    }
  }
}
