import 'package:flutter/material.dart';
import '../models/post_model_for_view.dart';
import '../repositories/auth_repository.dart';
import '../repositories/feed_repository.dart';
import '../utils/button.dart';
import '../view_models/auth_view_model.dart';
import '../view_models/feed_view_model.dart';

import 'create_post_view.dart';
import 'login_screen.dart';

class FeedScreen extends StatefulWidget {
  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final FeedViewModel viewModel = FeedViewModel(FeedRepository());
  List<PostModelForView> posts = [];
  bool isLoading = false;
  String? lastPostId;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchPosts();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !isLoading) {
        fetchPosts();
      }
    });
  }

  Future<void> fetchPosts({bool refresh = false}) async {
    setState(() => isLoading = true);
    if (refresh) {
      lastPostId = null;
      posts.clear();
    }
    final newPosts = await viewModel.getFeed('2914', '5883', more: lastPostId);
    setState(() {
      posts.addAll(newPosts);
      if (newPosts.isNotEmpty) lastPostId = newPosts.last.id;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF004D60),
        title: Text(
          "Python Developer Community",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          CreatePostView(communityId: '2914', spaceId: '5883'),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              height: 100,
              width: double.infinity,
              child: Row(
                children: [
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                      height: 60,
                      width: double.infinity,
                      color: Colors.white,
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.person,
                                size: 30,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 3,
                            child: TextField(
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                hintText: 'Write something here.....',
                                hintStyle: const TextStyle(
                                  color: Colors.black54,
                                ),
                                enabled: false,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 12,
                                ), // Responsive padding
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: PrimaryButton(
                              height: 34,
                              onPressed: () {},
                              tittleText: Text('Post'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => fetchPosts(refresh: true),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: posts.length + 1,
                itemBuilder: (context, index) {
                  if (index == posts.length) {
                    return isLoading
                        ? Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          ),
                        )
                        : SizedBox.shrink();
                  }
                  final post = posts[index];
                  return Card(
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(post.userImage),
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    post.userName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    post.time,
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(post.content),
                          if (post.imageUrl.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(post.imageUrl),
                              ),
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.thumb_up_alt_outlined, size: 20),
                                  SizedBox(width: 5),
                                  Text('${post.likes} Likes'),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.comment_outlined, size: 20),
                                  SizedBox(width: 5),
                                  Text('${post.comments} Comments'),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        color: Colors.grey.shade100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, // No border radius
                ),
              ),
              label: Text('Community'),
              icon: Icon(Icons.groups),
            ),
            SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: () {
                showDeleteWarningDialog(context);
              },
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, // No border radius
                ),
              ),
              label: Text('Logout'),
              icon: Icon(Icons.groups),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> showDeleteWarningDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false, // tap outside won't close
          builder:
              (context) => Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.warning_amber_rounded, size: 48),
                      SizedBox(height: 12),
                      Text(
                        'Logout',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Are you sure , you want to logout',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                final viewModel = AuthViewModel(
                                  AuthRepository(),
                                );
                                await viewModel.logout();

                                if (context.mounted) {
                                  Navigator.of(context).pop(); // Close dialog
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => LoginScreen(),
                                    ),
                                  ); // Replace with your login route
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.red),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text('Yes'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade600,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text('No'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
        ) ??
        false;
  }
}
