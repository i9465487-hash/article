
class PostModel {
  final int id;
  final String title;
  final String body;
  final List<String> tags;
  final ReactionsModel reactions;
  final int views;
  final int userId;

  const PostModel({
    required this.id,
    required this.title,
    required this.body,
    required this.tags,
    required this.reactions,
    required this.views,
    required this.userId,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      tags: List<String>.from(json['tags']),
      reactions: ReactionsModel.fromJson(json['reactions']),
      views: json['views'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'tags': tags,
      'reactions': reactions.toJson(),
      'views': views,
      'userId': userId,
    };
  }
}

class ReactionsModel {
  final int likes;
  final int dislikes;

  const ReactionsModel({
    required this.likes,
    required this.dislikes,
  });

  factory ReactionsModel.fromJson(Map<String, dynamic> json) {
    return ReactionsModel(
      likes: json['likes'],
      dislikes: json['dislikes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'likes': likes,
      'dislikes': dislikes,
    };
  }
}
