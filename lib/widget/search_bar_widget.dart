import 'package:flutter/material.dart';

/// 定义SearchBar的三种样式：
/// home 首页默认状态下使用的样式
/// homeLight 首页发生上滑后使用的样式
/// normal 为默认情况下使用的样式
enum SearchBarType { home, normal, homeLight }

/// 搜索栏组件
class SearchBarWidget extends StatefulWidget {
  /// 搜索回调函数
  final Function(String)? onSearch;
  
  /// 初始搜索关键词
  final String? initialKeyword;
  
  /// 提示文本
  final String? hintText;
  
  ///是否隐藏左侧返回键
  final bool? hideLeft;

  ///搜索框类型
  final SearchBarType searchBarType;

  ///默认内容
  final String? defaultText;

  ///左侧按钮点击回调
  final void Function()? leftButtonClick;

  ///右侧按钮点击回调
  final void Function()? rightButtonClick;

  ///输入框点击回调
  final void Function()? inputBoxClick;

  ///内容变化的回调
  final ValueChanged<String>? onChanged;
  
  const SearchBarWidget({
    Key? key,
    this.onSearch,
    this.initialKeyword,
    this.hintText,
    this.hideLeft,
    this.searchBarType = SearchBarType.normal,
    this.defaultText,
    this.leftButtonClick,
    this.rightButtonClick,
    this.inputBoxClick,
    this.onChanged,
  }) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  /// 搜索控制器
  late TextEditingController _searchController;
  
  /// 是否显示清除按钮
  bool showClear = false;
  
  @override
  void initState() {
    super.initState();
    // 优先使用initialKeyword，其次使用defaultText初始化搜索控制器
    _searchController = TextEditingController(
      text: widget.initialKeyword ?? widget.defaultText ?? ''
    );
    
    // 如果有内容，显示清除按钮
    if (_searchController.text.isNotEmpty) {
      setState(() {
        showClear = true;
      });
    }
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  /// 执行搜索
  void _performSearch() {
    final keyword = _searchController.text.trim();
    if (keyword.isNotEmpty && widget.onSearch != null) {
      widget.onSearch!(keyword);
    }
  }
  
  /// 文本变化回调
  void _onChanged(String value) {
    if (value.isNotEmpty) {
      setState(() {
        showClear = true;
      });
    } else {
      setState(() {
        showClear = false;
      });
    }
    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }
  }
  
  /// 生成normal样式的搜索栏
  Widget get _normalSearchBar => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        // 返回按钮
        if (!(widget.hideLeft ?? false))
          GestureDetector(
            onTap: widget.leftButtonClick ?? () => Navigator.pop(context),
            child: const Padding(
              padding: EdgeInsets.fromLTRB(6, 5, 10, 5),
              child: Icon(Icons.arrow_back_ios, color: Colors.grey, size: 26),
            ),
          ),
        // 搜索输入框
        Expanded(
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: widget.hintText ?? '请输入关键词搜索',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
              prefixIcon: const Icon(Icons.search),
              contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
              suffixIcon: showClear
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          _searchController.clear();
                          showClear = false;
                        });
                        _onChanged('');
                      },
                      child: const Icon(Icons.clear, size: 22, color: Colors.grey),
                    )
                  : null,
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _performSearch(),
            onChanged: _onChanged,
          ),
        ),
        // 搜索按钮
        GestureDetector(
          onTap: widget.rightButtonClick ?? _performSearch,
          child: const Padding(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Text(
              '搜索',
              style: TextStyle(color: Colors.blue, fontSize: 17),
            ),
          ),
        ),
      ],
    ),
  );
  
  /// 生成home样式的搜索栏
  Widget get _homeSearchBar {
    // 定义字体颜色
    final textColor = widget.searchBarType == SearchBarType.homeLight 
        ? Colors.black54 
        : Colors.white;
    
    return Row(
      children: [
        // 左侧城市选择
        GestureDetector(
          onTap: widget.leftButtonClick,
          child: Container(
            padding: const EdgeInsets.fromLTRB(6, 5, 5, 5),
            child: Row(
              children: [
                Text(
                  '北京', 
                  style: TextStyle(color: textColor, fontSize: 16),
                ),
                Icon(
                  Icons.expand_more, 
                  color: textColor, 
                  size: 22,
                ),
              ],
            ),
          ),
        ),
        // 中间搜索框
        Expanded(
          child: GestureDetector(
            onTap: widget.inputBoxClick,
            child: Container(
              height: 30,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  widget.searchBarType == SearchBarType.normal ? 5 : 15,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    size: 20,
                    color: widget.searchBarType == SearchBarType.normal
                        ? const Color(0xffa9a9a9)
                        : Colors.blue,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    widget.defaultText ?? "",
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
        // 右侧登出按钮
        GestureDetector(
          onTap: widget.rightButtonClick,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Text(
              '登出',
              style: TextStyle(color: textColor, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return widget.searchBarType == SearchBarType.normal
        ? _normalSearchBar
        : _homeSearchBar;
  }
}
