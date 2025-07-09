class PostModel {
  final String feedText;
  final String communityId;
  final String spaceId;
  final String uploadType;
  final Map<String, dynamic> metaData;
  final String activityType;
  final String isBackground;
  final String? bgColor;
  final List<String>? pollOptions;
  final Map<String, dynamic>? pollPrivacy;

  PostModel({
    required this.feedText,
    required this.communityId,
    required this.spaceId,
    required this.uploadType,
    required this.metaData,
    required this.activityType,
    required this.isBackground,
    this.bgColor,
    this.pollOptions,
    this.pollPrivacy,
  });

  Map<String, dynamic> toJson() {
    return {
      'feed_txt': feedText,
      'community_id': communityId,
      'space_id': spaceId,
      'uploadType': uploadType,
      'meta_data': metaData,
      'activity_type': activityType,
      'is_background': isBackground,
      if (bgColor != null) 'bg_color': bgColor,
      if (pollOptions != null) 'poll_options': pollOptions,
      if (pollPrivacy != null) 'poll_privacy': pollPrivacy,
    };
  }
}