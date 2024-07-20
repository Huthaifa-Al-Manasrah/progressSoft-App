import 'dart:convert';

import '../../../../core/error/exceptions.dart';
import '../models/post_model.dart';
import 'package:http/http.dart' as http;

abstract class PostRemoteDataSource {
  Future<List<PostModel>> getAllPosts();
}

const BASE_URL = 'https://jsonplaceholder.typicode.com';


class PostRemoteDataSourceImpl implements PostRemoteDataSource {

  final http.Client client;

  PostRemoteDataSourceImpl({required this.client});

  @override
  Future<List<PostModel>> getAllPosts() async {
    final response = await client.get(Uri.parse('$BASE_URL/posts/'),
        headers: {"Content-Type": "application/json"});
    if(response.statusCode == 200){
      final List decodedJson = json.decode(response.body) as List;
      final List<PostModel> postModels = decodedJson.map<PostModel>((jsonPostModel) => PostModel.fromJson(jsonPostModel)).toList();
      return postModels;
    }else{
      throw ServerException();
    }
  }
}
