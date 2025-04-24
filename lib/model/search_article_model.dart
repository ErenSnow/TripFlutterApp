class SearchArticleModel {
  SearchArticleListBean data;
  int errorCode;
  String errorMsg;

  SearchArticleModel({
    required this.data,
    required this.errorCode,
    required this.errorMsg,
  });

  SearchArticleModel.fromJson(Map<String, dynamic> json)
    : data = json['data'] != null
        ? SearchArticleListBean.fromJson(json['data'])
        : SearchArticleListBean(
            curPage: 0,
            datas: [],
            offset: 0,
            over: false,
            pageCount: 0,
            size: 0,
            total: 0,
          ),
      errorCode = json['errorCode'] ?? 0,
      errorMsg = json['errorMsg'] ?? '';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['data'] = this.data.toJson();
    data['errorCode'] = this.errorCode;
    data['errorMsg'] = this.errorMsg;
    return data;
  }
}

class SearchArticleListBean {
  int curPage;
  List<SearchArticleBean> datas;
  int offset;
  bool over;
  int pageCount;
  int size;
  int total;

  SearchArticleListBean({
    required this.curPage,
    required this.datas,
    required this.offset,
    required this.over,
    required this.pageCount,
    required this.size,
    required this.total,
  });

  SearchArticleListBean.fromJson(Map<String, dynamic> json)
    : curPage = json['curPage'] ?? 0,
      datas = (json['datas'] as List<dynamic>?)
          ?.map((v) => SearchArticleBean.fromJson(v))
          .toList() ?? [],
      offset = json['offset'] ?? 0,
      over = json['over'] ?? false,
      pageCount = json['pageCount'] ?? 0,
      size = json['size'] ?? 0,
      total = json['total'] ?? 0;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['curPage'] = this.curPage;
    data['datas'] = this.datas.map((v) => v.toJson()).toList();
    data['offset'] = this.offset;
    data['over'] = this.over;
    data['pageCount'] = this.pageCount;
    data['size'] = this.size;
    data['total'] = this.total;
    return data;
  }
}

class SearchArticleBean {
  String apkLink;
  int audit;
  String author;
  int chapterId;
  String chapterName;
  bool collect;
  int courseId;
  String desc;
  String envelopePic;
  bool fresh;
  int id;
  String link;
  String niceDate;
  String niceShareDate;
  String origin;
  String prefix;
  String projectLink;
  int publishTime;
  dynamic shareDate;
  String shareUser;
  int superChapterId;
  String superChapterName;
  List<Tag> tags;
  String title;
  int type;
  int userId;
  int visible;
  int zan;
  int top;

  SearchArticleBean({
    required this.apkLink,
    required this.audit,
    required this.author,
    required this.chapterId,
    required this.chapterName,
    required this.collect,
    required this.courseId,
    required this.desc,
    required this.envelopePic,
    required this.fresh,
    required this.id,
    required this.link,
    required this.niceDate,
    required this.niceShareDate,
    required this.origin,
    required this.prefix,
    required this.projectLink,
    required this.publishTime,
    required this.shareDate,
    required this.shareUser,
    required this.superChapterId,
    required this.superChapterName,
    required this.tags,
    required this.title,
    required this.type,
    required this.userId,
    required this.visible,
    required this.zan,
    required this.top,
  });

  SearchArticleBean.fromJson(Map<String, dynamic> json)
    : apkLink = json['apkLink'] ?? '',
      audit = json['audit'] ?? 0,
      author = json['author'] ?? '',
      chapterId = json['chapterId'] ?? 0,
      chapterName = json['chapterName'] ?? '',
      collect = json['collect'] ?? false,
      courseId = json['courseId'] ?? 0,
      desc = json['desc'] ?? '',
      envelopePic = json['envelopePic'] ?? '',
      fresh = json['fresh'] ?? false,
      id = json['id'] ?? 0,
      link = json['link'] ?? '',
      niceDate = json['niceDate'] ?? '',
      niceShareDate = json['niceShareDate'] ?? '',
      origin = json['origin'] ?? '',
      prefix = json['prefix'] ?? '',
      projectLink = json['projectLink'] ?? '',
      publishTime = json['publishTime'] ?? 0,
      shareDate = json['shareDate'],  // 保持dynamic类型，因为可能是int或String
      shareUser = json['shareUser'] ?? '',
      superChapterId = json['superChapterId'] ?? 0,
      superChapterName = json['superChapterName'] ?? '',
      tags = (json['tags'] as List<dynamic>?)
          ?.map((v) => Tag.fromJson(v))
          .toList() ?? [],
      title = json['title'] ?? '',
      type = json['type'] ?? 0,
      userId = json['userId'] ?? 0,
      visible = json['visible'] ?? 0,
      zan = json['zan'] ?? 0,
      top = json['top'] ?? 0;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['apkLink'] = this.apkLink;
    data['audit'] = this.audit;
    data['author'] = this.author;
    data['chapterId'] = this.chapterId;
    data['chapterName'] = this.chapterName;
    data['collect'] = this.collect;
    data['courseId'] = this.courseId;
    data['desc'] = this.desc;
    data['envelopePic'] = this.envelopePic;
    data['fresh'] = this.fresh;
    data['id'] = this.id;
    data['link'] = this.link;
    data['niceDate'] = this.niceDate;
    data['niceShareDate'] = this.niceShareDate;
    data['origin'] = this.origin;
    data['prefix'] = this.prefix;
    data['projectLink'] = this.projectLink;
    data['publishTime'] = this.publishTime;
    data['shareDate'] = this.shareDate;
    data['shareUser'] = this.shareUser;
    data['superChapterId'] = this.superChapterId;
    data['superChapterName'] = this.superChapterName;
    data['tags'] = this.tags.map((v) => v.toJson()).toList();
    data['title'] = this.title;
    data['type'] = this.type;
    data['userId'] = this.userId;
    data['visible'] = this.visible;
    data['zan'] = this.zan;
    data['top'] = this.top;
    return data;
  }
}

class Tag {
  String name;
  String url;

  Tag({
    required this.name,
    required this.url,
  });

  Tag.fromJson(Map<String, dynamic> json)
    : name = json['name'] ?? '',
      url = json['url'] ?? '';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = this.name;
    data['url'] = this.url;
    return data;
  }
}
