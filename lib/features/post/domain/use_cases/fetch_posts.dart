import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/post.dart';
import '../repositories/post_repositories.dart';

class FetchPostsUseCase{
  final PostRepository repository;

  FetchPostsUseCase(this.repository);

  Future<Either<Failure, List<Post>>> call() async {
    return await repository.fetchPosts();
  }
}