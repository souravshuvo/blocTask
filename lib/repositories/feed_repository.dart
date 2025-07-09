import 'package:dio/dio.dart';
import '../models/post_model_for_view.dart';
import '../utils/token_storage.dart';

class FeedRepository {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'https://ezyappteam.ezycourse.com/api/app/'),
  );

  Future<List<PostModelForView>> fetchFeed(
    String communityId,
    String spaceId, {
    String? more,
  }) async {
    final token = await TokenStorage.getToken();
    final response = await _dio.post(
      '/teacher/community/getFeed?status=feed',
      data: {
        'community_id': communityId,
        'space_id': spaceId,
        if (more != null) 'more': more,
      },
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    final data = response.data;

    if (data is List) {
      return data.map((e) => PostModelForView.fromJson(e)).toList();
    } else {
      throw Exception("Expected List from API but got: ${data.runtimeType}");
    }
  }

}
