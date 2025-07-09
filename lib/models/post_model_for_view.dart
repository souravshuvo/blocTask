class PostModelForView {
  final String id;
  final String userName;
  final String userImage;
  final String content;
  final String imageUrl;
  final String time;
  final int comments;
  final int likes;
  final String activityType;

  PostModelForView({
    required this.id,
    required this.userName,
    required this.userImage,
    required this.content,
    required this.imageUrl,
    required this.time,
    required this.comments,
    required this.likes,
    required this.activityType,
  });

  factory PostModelForView.fromJson(Map<String, dynamic> json) {
    String imageUrl = '';
    if (json['files'] is List &&
        json['files'].isNotEmpty &&
        json['files'][0] is Map &&
        json['files'][0]['url'] != null) {
      imageUrl = json['files'][0]['url'];
    }

    return PostModelForView(
      id: json['id'].toString(),
      userName: json['user']?['full_name'] ?? json['name'] ?? 'Unknown',
      userImage: json['user']?['profile_pic'] ?? json['pic'] ?? '',
      content: json['feed_txt'] ?? '',
      imageUrl: imageUrl,
      time: json['created_at'] ?? '',
      comments: int.tryParse(json['comment_count'].toString()) ?? 0,
      likes: int.tryParse(json['like_count'].toString()) ?? 0,
      activityType: json['activity_type'] ?? '',
    );
  }
}
