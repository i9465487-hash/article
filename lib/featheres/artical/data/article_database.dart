
import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ArticleDatabase {
  ArticleDatabase._();

  static final ArticleDatabase instance =
  ArticleDatabase._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'articles.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE saved_articles (
            id INTEGER PRIMARY KEY,
            title TEXT NOT NULL,
            body TEXT NOT NULL,
            tags TEXT NOT NULL,
            reactions TEXT NOT NULL,
            views INTEGER NOT NULL,
            userId INTEGER NOT NULL
          )
        ''');
      },
    );

    return _database!;
  }

  // حفظ المقال أو تحديثه إذا كان محفوظًا بالفعل
  Future<void> saveArticle(
      Map<String, dynamic> post,
      ) async {
    final db = await database;

    await db.insert(
      'saved_articles',
      {
        'id': post['id'],
        'title': post['title'],
        'body': post['body'],
        'tags': jsonEncode(post['tags'] ?? []),
        'reactions': jsonEncode(post['reactions'] ?? {}),
        'views': post['views'] ?? 0,
        'userId': post['userId'] ?? 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // جلب جميع المقالات المحفوظة
  Future<List<Map<String, dynamic>>> getSavedArticles() async {
    final db = await database;

    final result = await db.query(
      'saved_articles',
      orderBy: 'id DESC',
    );

    return result.map((article) {
      return {
        ...article,
        'tags': jsonDecode(article['tags'] as String),
        'reactions': jsonDecode(
          article['reactions'] as String,
        ),
      };
    }).toList();
  }

  // التحقق من حفظ مقال معين
  Future<bool> isArticleSaved(int id) async {
    final db = await database;

    final result = await db.query(
      'saved_articles',
      columns: ['id'],
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  // حذف مقال من المحفوظات
  Future<void> deleteArticle(int id) async {
    final db = await database;

    await db.delete(
      'saved_articles',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
