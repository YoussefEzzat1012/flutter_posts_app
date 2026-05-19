import 'dart:convert';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../core/services/local_storage_service.dart';
import '../models/post_model.dart';

class PostRepository {
  final ApiService _apiService = ApiService();
  final ConnectivityService _connectivityService = ConnectivityService();

  Future<List<PostModel>> getPosts() async {
    final isOnline = await _connectivityService.isConnected();

    if (isOnline) {
      try {
        final response = await _apiService.get(AppConstants.postsEndpoint);
        final List<dynamic> data = response;
        final posts = data.map((json) => PostModel.fromJson(json)).toList();

        final postsJson = posts.map((p) => jsonEncode(p.toJson())).toList();
        await LocalStorageService.setStringList(AppConstants.cachedPostsKey, postsJson);

        return posts;
      } catch (e) {
        return _getCachedPosts();
      }
    } else {
      return _getCachedPosts();
    }
  }

  Future<PostModel> getPost(int id) async {
    final isOnline = await _connectivityService.isConnected();

    if (isOnline) {
      try {
        final response = await _apiService.get('${AppConstants.postsEndpoint}/$id');
        return PostModel.fromJson(response);
      } catch (e) {
        return _getCachedPostById(id);
      }
    } else {
      return _getCachedPostById(id);
    }
  }

  Future<PostModel> createPost(PostModel post) async {
    final isOnline = await _connectivityService.isConnected();

    if (isOnline) {
      try {
        final response = await _apiService.post(
          AppConstants.postsEndpoint,
          body: {
            'title': post.title,
            'body': post.body,
            'userId': post.userId,
          },
        );
        return PostModel.fromJson(response);
      } catch (e) {
        return _savePostLocally(post);
      }
    } else {
      return _savePostLocally(post);
    }
  }

  Future<List<PostModel>> _getCachedPosts() async {
    final cachedData = LocalStorageService.getStringList(AppConstants.cachedPostsKey);
    if (cachedData != null && cachedData.isNotEmpty) {
      return cachedData.map((json) => PostModel.fromJson(jsonDecode(json))).toList();
    }
    return [];
  }

  Future<PostModel> _getCachedPostById(int id) async {
    final posts = await _getCachedPosts();
    return posts.firstWhere(
          (post) => post.id == id,
      orElse: () => throw Exception('Post not found in cache'),
    );
  }

  Future<PostModel> _savePostLocally(PostModel post) async {
    final cachedPosts = await _getCachedPosts();
    final newPost = post.copyWith(
      id: DateTime.now().millisecondsSinceEpoch,
      createdAt: DateTime.now(),
    );
    cachedPosts.insert(0, newPost);

    final postsJson = cachedPosts.map((p) => jsonEncode(p.toJson())).toList();
    await LocalStorageService.setStringList(AppConstants.cachedPostsKey, postsJson);

    return newPost;
  }
}