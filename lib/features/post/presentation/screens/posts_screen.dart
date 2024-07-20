import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/loading_widget.dart';
import '../bloc/posts_bloc.dart';
import '../widgets/posts_list_widget.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            BlocProvider.of<PostsBloc>(context).add(SearchPostEvent(query: value));
          },
        ),
      ),
      body: BlocBuilder<PostsBloc, PostsState>(builder: (context, state) {
        if (state is LoadingPostsState) {
          return const LoadingWidget();
        } else if (state is LoadedPostsState) {
          return RefreshIndicator(
              onRefresh: () async {
                BlocProvider.of<PostsBloc>(context).add(RefreshPostsEvent());
              },
              child: PostsListWidget(postsList: state.posts));
        } else if (state is ErrorPostsState) {
          return Text(state.message);
        }
        return const SizedBox.shrink();
      }),
    );
  }
}
