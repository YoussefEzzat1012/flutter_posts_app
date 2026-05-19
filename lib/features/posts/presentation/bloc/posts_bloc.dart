import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/post_model.dart';
import '../../data/repositories/post_repository.dart';
import 'posts_event.dart';
import 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostRepository _postRepository;
  List<PostModel> _allPosts = [];

  PostsBloc(this._postRepository) : super(PostsInitial()) {
    on<LoadPosts>(_onLoadPosts);
    on<LoadPostDetail>(_onLoadPostDetail);
    on<CreatePost>(_onCreatePost);
    on<RefreshPosts>(_onRefreshPosts);
    on<SearchPosts>(_onSearchPosts);
  }

  Future<void> _onLoadPosts(LoadPosts event, Emitter<PostsState> emit) async {
    emit(PostsLoading());
    try {
      final posts = await _postRepository.getPosts();
      _allPosts = posts;
      emit(PostsLoaded(posts));
    } catch (e) {
      emit(PostsError(e.toString()));
    }
  }

  Future<void> _onLoadPostDetail(LoadPostDetail event, Emitter<PostsState> emit) async {
    emit(PostsLoading());
    try {
      final post = await _postRepository.getPost(event.postId);
      emit(PostDetailLoaded(post));
    } catch (e) {
      emit(PostsError(e.toString()));
    }
  }

  Future<void> _onCreatePost(CreatePost event, Emitter<PostsState> emit) async {
    emit(PostsLoading());
    try {
      final post = await _postRepository.createPost(event.post);
      emit(PostCreated(post));
      add(LoadPosts());
    } catch (e) {
      emit(PostsError(e.toString()));
    }
  }

  Future<void> _onRefreshPosts(RefreshPosts event, Emitter<PostsState> emit) async {
    try {
      final posts = await _postRepository.getPosts();
      _allPosts = posts;
      emit(PostsLoaded(posts));
    } catch (e) {
      emit(PostsError(e.toString()));
    }
  }

  Future<void> _onSearchPosts(SearchPosts event, Emitter<PostsState> emit) async {
    if (event.query.isEmpty) {
      emit(PostsLoaded(_allPosts));
      return;
    }

    final filtered = _allPosts.where((post) {
      return post.title.toLowerCase().contains(event.query.toLowerCase()) ||
          post.body.toLowerCase().contains(event.query.toLowerCase());
    }).toList();

    emit(PostsLoaded(filtered));
  }
}