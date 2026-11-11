abstract class ArticlesState {}

class ArticlesInitial extends ArticlesState {}

class ArticlesLoading extends ArticlesState {}

class ArticlesSuccess extends ArticlesState {
  final List<dynamic> articles;

  ArticlesSuccess(this.articles);
}

class ArticlesFailure extends ArticlesState {
  final String error;

  ArticlesFailure(this.error);
}