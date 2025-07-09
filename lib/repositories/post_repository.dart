import 'dart:convert';
import 'package:dio/dio.dart';
import 'dart:io';
import '../models/post_model.dart';
import '../utils/token_storage.dart';

class PostRepository {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'https://ezyappteam.ezycourse.com/api/app/'),
  );

  PostRepository() {
    _dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }

  Future<void> createPost(PostModel post, List<String> imagePaths) async {
    try {
      // Validate token
      final token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }
      print('Token: $token');

      // Validate required fields
      if (post.feedText.isEmpty) {
        throw Exception('feed_txt cannot be empty');
      }
      if (post.communityId.isEmpty || post.spaceId.isEmpty) {
        throw Exception('community_id and space_id are required');
      }
      if (post.uploadType.isEmpty || !['text', 'photos', 'files'].contains(post.uploadType)) {
        throw Exception('Invalid uploadType: must be text, photos, or files');
      }
      if (post.activityType.isEmpty || !['group', 'poll'].contains(post.activityType)) {
        throw Exception('Invalid activity_type: must be group or poll');
      }
      if (post.isBackground.isEmpty || !['0', '1'].contains(post.isBackground)) {
        throw Exception('Invalid is_background: must be "0" or "1"');
      }

      // Prepare meta_data (required)
      final metaData = post.metaData ?? {
        'linkMeta': null,
        'contentsMetaData': null,
      };

      final formData = FormData();

      // Add text fields
      formData.fields.addAll([
        MapEntry('feed_txt', post.feedText.trim()),
        MapEntry('community_id', post.communityId),
        MapEntry('space_id', post.spaceId),
        MapEntry('uploadType', post.uploadType),
        MapEntry('meta_data', jsonEncode(metaData)),
        MapEntry('activity_type', post.activityType),
        MapEntry('is_background', post.isBackground), // String: "0" or "1"
      ]);

      // Add optional fields
      if (post.bgColor != null && post.bgColor!.isNotEmpty) {
        formData.fields.add(MapEntry('bg_color', post.bgColor!));
      }

      if (post.pollOptions != null && post.pollOptions!.isNotEmpty) {
        formData.fields.add(MapEntry('poll_options', jsonEncode(post.pollOptions)));
      }

      if (post.pollPrivacy != null) {
        formData.fields.add(MapEntry('poll_privacy', jsonEncode(post.pollPrivacy)));
      }

      // Add image files and validate
      print('--- FormData Request ---');
      print('Fields:');
      for (var field in formData.fields) {
        print('${field.key}: ${field.value}');
      }
      print('Files:');
      if (post.uploadType == 'text' && imagePaths.isNotEmpty) {
        print('Warning: uploadType is text but imagePaths provided');
      }
      if (['photos', 'files'].contains(post.uploadType) && imagePaths.isEmpty) {
        print('Warning: uploadType is ${post.uploadType} but no files provided');
        // Optionally allow request to proceed for testing
      }
      for (int i = 0; i < imagePaths.length; i++) {
        final file = File(imagePaths[i]);
        if (!await file.exists()) {
          throw Exception('Image file does not exist: ${imagePaths[i]}');
        }
        formData.files.add(MapEntry(
          'files',
          await MultipartFile.fromFile(file.path, filename: 'image_$i.jpg'),
        ));
        print('files: image_$i.jpg (path: ${imagePaths[i]})');
      }
      print('--- End FormData Request ---');

      // Send request
      final response = await _dio.post(
        'teacher/community/createFeedWithUpload',
        data: formData,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        }),
      );

      // Print response
      print('--- Server Response ---');
      print('Status Code: ${response.statusCode}');
      print('Data: ${response.data}');
      print('--- End Server Response ---');

      if (response.statusCode != 200) {
        print('--- Error Response ---');
        print('Status Code: ${response.statusCode}');
        print('Status Message: ${response.statusMessage}');
        print('Response Data: ${response.data}');
        throw Exception('Failed to create post: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error creating post: $e');
    }
  }
}