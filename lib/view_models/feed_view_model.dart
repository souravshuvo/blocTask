
import '../models/post_model_for_view.dart';
import '../repositories/feed_repository.dart';

class FeedViewModel {
  final FeedRepository _repo;

  FeedViewModel(this._repo);

  Future<List<PostModelForView>> getFeed(String communityId, String spaceId, {String? more}) {
    return _repo.fetchFeed(communityId, spaceId, more: more);
  }

}