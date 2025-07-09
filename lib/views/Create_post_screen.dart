import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocks/create_post_bloc.dart';
import '../blocks/create_post_event.dart';
import '../blocks/create_post_state.dart';
import '../utils/color.dart';

class CreatePostScreen extends StatefulWidget {
  final String communityId;
  final String spaceId;

  const CreatePostScreen({
    Key? key,
    required this.communityId,
    required this.spaceId,
  }) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<TextEditingController> _pollControllers = [];

  @override
  void initState() {
    super.initState();
    _pollControllers.addAll([
      TextEditingController(text: 'Option 1'),
      TextEditingController(text: 'Option 2'),
    ]);
  }

  @override
  void dispose() {
    _textController.dispose();
    for (var controller in _pollControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close', style: TextStyle(color: Colors.black)),
        ),
        title: const Text('Create Post'),
        centerTitle: true,
        actions: [
          BlocBuilder<CreatePostBloc, CreatePostState>(
            builder: (context, state) {
              return TextButton(
                onPressed:
                    state.isLoading || state.postText.isEmpty
                        ? null
                        : () {
                          context.read<CreatePostBloc>().add(
                            SubmitPost(widget.communityId, widget.spaceId),
                          );
                        },
                child:
                    state.isLoading
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Text(
                          'CREATE',
                          style: TextStyle(color: Colors.blue),
                        ),
              );
            },
          ),
        ],
      ),
      body: BlocListener<CreatePostBloc, CreatePostState>(
        listener: (context, state) {
          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Post created successfully!')),
            );
            Navigator.pop(context);
          }
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildUserInfo(),
              _buildPostContent(),
              _buildColorPicker(),
              _buildActionButtons(),
              _buildPostOptions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[300],
            child: const Icon(Icons.person, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          const Text(
            'Ezy Student',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildPostContent() {
    return BlocBuilder<CreatePostBloc, CreatePostState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            gradient:
                state.isBackground
                    ? ColorConstants.gradientsColor[state.selectedColorIndex]
                    : null,
            color: state.isBackground ? null : Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              if (state.isPoll)
                _buildPollContent(state)
              else
                _buildTextContent(state),
              if (state.selectedImages.isNotEmpty) _buildImagePreview(state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextContent(CreatePostState state) {
    return TextField(
      controller: _textController,
      onChanged: (text) {
        context.read<CreatePostBloc>().add(PostTextChanged(text));
      },
      maxLines: null,
      minLines: 3,
      decoration: InputDecoration(
        hintText: state.isPoll ? 'This is a poll post' : "What's on your mind?",
        border: InputBorder.none,
        contentPadding: const EdgeInsets.all(16),
        hintStyle: TextStyle(color: Colors.grey[600]),
      ),
      style: TextStyle(
        color: state.isBackground ? Colors.white : Colors.black,
        fontSize: 16,
      ),
    );
  }

  Widget _buildPollContent(CreatePostState state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _textController,
            onChanged: (text) {
              context.read<CreatePostBloc>().add(PostTextChanged(text));
            },
            decoration: const InputDecoration(
              hintText: 'This is a poll post',
              border: InputBorder.none,
            ),
            style: TextStyle(
              color: state.isBackground ? Colors.white : Colors.black,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(state.pollOptions.length, (index) {
            return _buildPollOption(state, index);
          }),
          const SizedBox(height: 8),
          _buildAddPollOption(),
        ],
      ),
    );
  }

  Widget _buildPollOption(CreatePostState state, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller:
                  _pollControllers.length > index
                      ? _pollControllers[index]
                      : TextEditingController(text: state.pollOptions[index]),
              onChanged: (text) {
                context.read<CreatePostBloc>().add(
                  PollOptionChanged(index, text),
                );
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Add option...',
              ),
            ),
          ),
          if (state.pollOptions.length > 2)
            IconButton(
              onPressed: () {
                context.read<CreatePostBloc>().add(PollOptionRemoved(index));
                if (_pollControllers.length > index) {
                  _pollControllers[index].dispose();
                  _pollControllers.removeAt(index);
                }
              },
              icon: const Icon(Icons.close, size: 20),
            ),
        ],
      ),
    );
  }

  Widget _buildAddPollOption() {
    return GestureDetector(
      onTap: () {
        context.read<CreatePostBloc>().add(PollOptionAdded(''));
        _pollControllers.add(TextEditingController());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Icon(Icons.add, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text('Add option...', style: TextStyle(color: Colors.grey[600])),
            const Spacer(),
            Icon(Icons.settings, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(CreatePostState state) {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: state.selectedImages.length,
        itemBuilder: (context, index) {
          return Container(
            width: 150,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: FileImage(File(state.selectedImages[index])),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildColorPicker() {
    return BlocBuilder<CreatePostBloc, CreatePostState>(
      builder: (context, state) {
        if (state.isPoll) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  context.read<CreatePostBloc>().add(BackgroundChanged(false));
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color:
                          !state.isBackground ? Colors.blue : Colors.grey[300]!,
                      width: 2,
                    ),
                  ),
                  child: const Icon(Icons.text_fields, size: 16),
                ),
              ),
              const SizedBox(width: 8),
              ...List.generate(ColorConstants.gradientsColor.length - 1, (
                index,
              ) {
                final colorIndex = index + 1;
                return GestureDetector(
                  onTap: () {
                    context.read<CreatePostBloc>().add(
                      BackgroundChanged(true, colorIndex: colorIndex),
                    );
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      gradient: ColorConstants.gradientsColor[colorIndex],
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color:
                            state.isBackground &&
                                    state.selectedColorIndex == colorIndex
                                ? Colors.blue
                                : Colors.grey[300]!,
                        width: 2,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                _buildActionButton(Icons.photo_library, 'Photo Gallery', () {
                  context.read<CreatePostBloc>().pickImages();
                }),
                const SizedBox(width: 16),
                _buildActionButton(Icons.videocam, 'Video Gallery', () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildPostOptions() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    _buildActionButton(Icons.camera_alt, 'Capture Photo', () {
                      context.read<CreatePostBloc>().pickCamera();
                    }),
                    const SizedBox(width: 16),
                    _buildActionButton(Icons.videocam, 'Capture Video', () {}),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    _buildActionButton(Icons.attach_file, 'File', () {}),
                    const SizedBox(width: 16),
                    BlocBuilder<CreatePostBloc, CreatePostState>(
                      builder: (context, state) {
                        return GestureDetector(
                          onTap: () {
                            context.read<CreatePostBloc>().add(
                              PostTypeChanged(!state.isPoll),
                            );
                          },
                          child: Row(
                            children: [
                              Icon(Icons.poll, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                'Poll',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.public, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                'Post anonymously',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
