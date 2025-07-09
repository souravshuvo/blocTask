import 'package:community_feed/repositories/post_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'blocks/auth_bloc.dart';
import 'blocks/create_post_bloc.dart';
import 'views/login_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [Provider<PostRepository>(create: (_) => PostRepository())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
          BlocProvider<CreatePostBloc>(
            create:
                (context) => CreatePostBloc(
                  postRepository: context.read<PostRepository>(),
                ),
          ),
          BlocProvider<CreatePostBloc>(
            create:
                (context) => CreatePostBloc(
                  postRepository: context.read<PostRepository>(),
                ),
          ),
        ],
        child: LoginScreen(),
      ),
    );
  }
}
