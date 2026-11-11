
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'artical_state.dart';

class ArticlesCubit extends Cubit<ArticlesState> {
  ArticlesCubit() : super(ArticlesInitial());

  Future<void> fetchArticles() async {
    emit(ArticlesLoading());

    try {
      final response = await http.get(
        Uri.parse('https://dummyjson.com/posts'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        emit(
          ArticlesSuccess(
            List<dynamic>.from(data['posts']),
          ),
        );
      } else {
        emit(ArticlesFailure('Failed to load articles'));
      }
    } catch (e) {
      emit(ArticlesFailure('Something went wrong'));
    }
  }
}
