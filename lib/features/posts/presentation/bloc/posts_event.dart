import 'package:equatable/equatable.dart';
import '../../data/models/post_model.dart';

abstract class PostsEvent extends Equatable {
  const PostsEvent();
  @override
  List<Object?> get props => [];
}

class LoadPosts extends PostsEvent {}

class LoadPostDetail extends PostsEvent {
  final int postId;
  const LoadPostDetail(this.postId);
  @override
  List<Object?> get props => [postId];
}

class CreatePost extends PostsEvent {
  final PostModel post;
  const CreatePost(this.post);
  @override
  List<Object?> get props => [post];
}

class RefreshPosts extends PostsEvent {}

class SearchPosts extends PostsEvent {
  final String query;
  const SearchPosts(this.query);
  @override
  List<Object?> get props => [query];
}