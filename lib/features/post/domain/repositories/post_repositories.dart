import 'package:dartz/dartz.dart';
import 'package:progress_soft_app/core/error/failures.dart';

import '../entities/post.dart';

abstract class PostRepository {
  Future<Either<Failure, List<Post>>> fetchPosts();
}