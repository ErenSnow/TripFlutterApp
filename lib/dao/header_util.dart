import 'package:trip_flutter_app/util/cache_util.dart';

hiHeaders() {
  Map<String, String> headers = {
    "Content-Type": "application/x-www-form-urlencoded",
    "token": CacheUtil.getToken() ?? "",
  };
  return headers;
}
