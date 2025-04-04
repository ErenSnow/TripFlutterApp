import 'package:flutter_hi_cache/flutter_hi_cache.dart';

class CacheUtil {
  static const tokenCache = "token";

  static saveToken(String value) {
    HiCache.getInstance().setString(tokenCache, value);
  }

  static String? getToken() {
    return HiCache.getInstance().get(tokenCache);
  }

  static removeToken() {
    HiCache.getInstance().remove(tokenCache);
  }
}
