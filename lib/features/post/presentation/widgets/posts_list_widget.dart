import 'package:flutter/material.dart';
import 'package:progress_soft_app/features/post/presentation/widgets/post_widget.dart';

import '../../domain/entities/post.dart';

class PostsListWidget extends StatelessWidget {
  final List<Post> postsList;
  const PostsListWidget({super.key, required this.postsList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: postsList.length,
      itemBuilder: (context, index) {
        return PostWidget(post: postsList[index]);
      },
    );
  }
}
