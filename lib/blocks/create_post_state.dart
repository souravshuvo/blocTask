class CreatePostState {
  final String postText;
  final bool isPoll;
  final bool isBackground;
  final int selectedColorIndex;
  final List<String> pollOptions;
  final List<String> selectedImages;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  CreatePostState({
    this.postText = '',
    this.isPoll = false,
    this.isBackground = false,
    this.selectedColorIndex = 1,
    this.pollOptions = const [],
    this.selectedImages = const [],
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  CreatePostState copyWith({
    String? postText,
    bool? isPoll,
    bool? isBackground,
    int? selectedColorIndex,
    List<String>? pollOptions,
    List<String>? selectedImages,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return CreatePostState(
      postText: postText ?? this.postText,
      isPoll: isPoll ?? this.isPoll,
      isBackground: isBackground ?? this.isBackground,
      selectedColorIndex: selectedColorIndex ?? this.selectedColorIndex,
      pollOptions: pollOptions ?? this.pollOptions,
      selectedImages: selectedImages ?? this.selectedImages,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
