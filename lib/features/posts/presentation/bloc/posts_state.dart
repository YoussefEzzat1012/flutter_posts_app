import 'package:equatable/equatable.dart';
import '../../data/models/post_model.dart';

abstract class PostsState extends Equatable {
  const PostsState();
  @override
  List<Object?> get props => [];
}

class PostsInitial extends PostsState {}
class PostsLoading extends PostsState {}

class PostsLoaded extends PostsState {
  final List<PostModel> posts;
  final bool isOffline;
  const PostsLoaded(this.posts, {this.isOffline = false});
  @override
  List<Object?> get props => [posts, isOffline];
}

class PostDetailLoaded extends PostsState {
  final PostModel post;
  const PostDetailLoaded(this.post);
  @override
  List<Object?> get props => [post];
}

class PostCreated extends PostsState {
  final PostModel post;
  const PostCreated(this.post);
  @override
  List<Object?> get props => [post];
}

class PostsError extends PostsState {
  final String message;
  const PostsError(this.message);
  @override
  List<Object?> get props => [message];
}