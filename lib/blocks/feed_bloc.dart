import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/post_model_for_view.dart';
import '../repositories/feed_repository.dart';
import '../view_models/feed_view_model.dart';

abstract class FeedEvent {}
class FetchFeed extends FeedEvent {
  final String communityId;
  final String spaceId;
  final String? more;
  final bool refresh;

  FetchFeed(this.communityId, this.spaceId, {this.more, this.refresh = false});
}

abstract class FeedState {}
class FeedInitial extends FeedState {}
class FeedLoading extends FeedState {}
class FeedLoaded extends FeedState {
  final List<PostModelForView> posts;
  final String? lastPostId;
  final bool isRefreshed;

  FeedLoaded({required this.posts, this.lastPostId, this.isRefreshed = false});
}
class FeedError extends FeedState {
  final String message;
  FeedError(this.message);
}

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final FeedViewModel viewModel = FeedViewModel(FeedRepository());
  List<PostModelForView> allPosts = [];

  FeedBloc() : super(FeedInitial()) {
    on<FetchFeed>((event, emit) async {
      if (event.refresh) {
        emit(FeedLoading());
        allPosts.clear();
      }

      try {
        final posts = await viewModel.getFeed(event.communityId, event.spaceId, more: event.more);
        allPosts.addAll(posts);
        final lastId = posts.isNotEmpty ? posts.last.id : null;
        emit(FeedLoaded(posts: allPosts, lastPostId: lastId, isRefreshed: event.refresh));
      } catch (e) {
        emit(FeedError(e.toString()));
      }
    });
  }
}
