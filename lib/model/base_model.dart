// 修正后的 BaseModel
class BaseModel<T> {
  int errorCode;
  String errorMsg;
  T data;

  // 生成式构造函数（关键改动）
  BaseModel({
    required this.errorCode,
    required this.errorMsg,
    required this.data,
  });

  // 生成式 fromJson 构造函数
  BaseModel.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT, // 数据解析器
  ) : errorCode = json['errorCode'],
      errorMsg = json['errorMsg'],
      data = fromJsonT(json['data']); // 通过函数转换 data
}
