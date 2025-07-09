import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocks/create_post_bloc.dart';
import '../repositories/post_repository.dart';
import 'Create_post_screen.dart';

class CreatePostView extends StatelessWidget {
  final String communityId;
  final String spaceId;

  const CreatePostView({
    Key? key,
    required this.communityId,
    required this.spaceId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              CreatePostBloc(postRepository: context.read<PostRepository>()),
      child: CreatePostScreen(communityId: communityId, spaceId: spaceId),
    );
  }
}
