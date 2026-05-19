class AppConstants {
  static const String appName = 'Posts App';
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const String postsEndpoint = '/posts';
  static const String loginEndpoint = '/users';

  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String cachedPostsKey = 'cached_posts';

  static const int connectTimeout = 10;
  static const int receiveTimeout = 10;
}