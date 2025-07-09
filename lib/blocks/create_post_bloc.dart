import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../models/post_model.dart';
import '../repositories/post_repository.dart';
import '../utils/color.dart';
import 'create_post_event.dart';
import 'create_post_state.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  final PostRepository postRepository;
  final ImagePicker _imagePicker = ImagePicker();

  CreatePostBloc({required this.postRepository}) : super(CreatePostState()) {
    on<PostTextChanged>(_onPostTextChanged);
    on<PostTypeChanged>(_onPostTypeChanged);
    on<BackgroundChanged>(_onBackgroundChanged);
    on<PollOptionAdded>(_onPollOptionAdded);
    on<PollOptionRemoved>(_onPollOptionRemoved);
    on<PollOptionChanged>(_onPollOptionChanged);
    on<ImagesSelected>(_onImagesSelected);
    on<SubmitPost>(_onSubmitPost);
    on<ResetPost>(_onResetPost);
  }

  void _onPostTextChanged(
    PostTextChanged event,
    Emitter<CreatePostState> emit,
  ) {
    emit(state.copyWith(postText: event.text));
  }

  void _onPostTypeChanged(
    PostTypeChanged event,
    Emitter<CreatePostState> emit,
  ) {
    emit(
      state.copyWith(
        isPoll: event.isPoll,
        pollOptions: event.isPoll ? ['Option 1', 'Option 2'] : [],
      ),
    );
  }

  void _onBackgroundChanged(
    BackgroundChanged event,
    Emitter<CreatePostState> emit,
  ) {
    emit(
      state.copyWith(
        isBackground: event.isBackground,
        selectedColorIndex: event.colorIndex ?? state.selectedColorIndex,
      ),
    );
  }

  void _onPollOptionAdded(
    PollOptionAdded event,
    Emitter<CreatePostState> emit,
  ) {
    final newOptions = List<String>.from(state.pollOptions)..add(event.option);
    emit(state.copyWith(pollOptions: newOptions));
  }

  void _onPollOptionRemoved(
    PollOptionRemoved event,
    Emitter<CreatePostState> emit,
  ) {
    final newOptions = List<String>.from(state.pollOptions)
      ..removeAt(event.index);
    emit(state.copyWith(pollOptions: newOptions));
  }

  void _onPollOptionChanged(
    PollOptionChanged event,
    Emitter<CreatePostState> emit,
  ) {
    final newOptions = List<String>.from(state.pollOptions);
    newOptions[event.index] = event.option;
    emit(state.copyWith(pollOptions: newOptions));
  }

  void _onImagesSelected(ImagesSelected event, Emitter<CreatePostState> emit) {
    emit(state.copyWith(selectedImages: event.imagePaths));
  }

  void _onSubmitPost(SubmitPost event, Emitter<CreatePostState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final postModel = PostModel(
        feedText: state.postText,
        communityId: event.communityId,
        spaceId: event.spaceId,
        uploadType: _getUploadType(),
        metaData: {"linkMeta": null, "contentsMetaData": null},
        activityType: state.isPoll ? 'poll' : 'group',
        isBackground: state.isBackground ? "1" : "0",
        bgColor:
            state.isBackground
                ? ColorConstants.bgColorList[state.selectedColorIndex - 1]
                : null,
        pollOptions: state.isPoll ? state.pollOptions : null,
        pollPrivacy:
            state.isPoll
                ? {"is_multiple_selected": 1, "allow_user_add_option": 1}
                : null,
      );

      await postRepository.createPost(postModel, state.selectedImages);
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void _onResetPost(ResetPost event, Emitter<CreatePostState> emit) {
    emit(CreatePostState());
  }

  String _getUploadType() {
    if (state.selectedImages.isNotEmpty) {
      return 'photos';
    } else if (state.postText.isNotEmpty) {
      return 'text';
    }
    return 'text';
  }

  Future<void> pickImages() async {
    final List<XFile> images = await _imagePicker.pickMultiImage();
    if (images.isNotEmpty) {
      final imagePaths = images.map((image) => image.path).toList();
      add(ImagesSelected(imagePaths));
    }
  }

  Future<void> pickCamera() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.camera,
    );
    if (image != null) {
      add(ImagesSelected([image.path]));
    }
  }
}
