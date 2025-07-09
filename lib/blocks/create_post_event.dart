abstract class CreatePostEvent {}

class PostTextChanged extends CreatePostEvent {
  final String text;
  PostTextChanged(this.text);
}

class PostTypeChanged extends CreatePostEvent {
  final bool isPoll;
  PostTypeChanged(this.isPoll);
}

class BackgroundChanged extends CreatePostEvent {
  final bool isBackground;
  final int? colorIndex;
  BackgroundChanged(this.isBackground, {this.colorIndex});
}

class PollOptionAdded extends CreatePostEvent {
  final String option;
  PollOptionAdded(this.option);
}

class PollOptionRemoved extends CreatePostEvent {
  final int index;
  PollOptionRemoved(this.index);
}

class PollOptionChanged extends CreatePostEvent {
  final int index;
  final String option;
  PollOptionChanged(this.index, this.option);
}

class ImagesSelected extends CreatePostEvent {
  final List<String> imagePaths;
  ImagesSelected(this.imagePaths);
}

class SubmitPost extends CreatePostEvent {
  final String communityId;
  final String spaceId;
  SubmitPost(this.communityId, this.spaceId);
}

class ResetPost extends CreatePostEvent {}