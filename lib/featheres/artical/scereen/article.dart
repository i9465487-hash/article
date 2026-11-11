
import 'package:artical/featheres/artical/scereen/saved_articles_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../persentation/cubit/artical_cubit.dart';
import '../persentation/cubit/artical_state.dart';
import 'article_details_pag.dart';

class ArticlesPage extends StatelessWidget {
  const ArticlesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ArticlesCubit()..fetchArticles(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Articles'),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SavedArticlesPage(),
                ),
              );
            },
            icon: const Icon(Icons.save_alt),
          ),
        ),
        body: BlocBuilder<ArticlesCubit, ArticlesState>(
          builder: (context, state) {
            if (state is ArticlesLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is ArticlesFailure) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.error,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<ArticlesCubit>().fetchArticles();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is ArticlesSuccess) {
              final posts = state.articles;

              return LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;

                  // تحديد عدد الأعمدة حسب عرض الشاشة
                  final crossAxisCount = width >= 700 ? 2 : 1;

                  // تحديد عرض المحتوى حتى لا يتمدد كثيراً
                  final maxWidth = width >= 1000 ? 1000.0 : width;

                  return Center(
                    child: SizedBox(
                      width: maxWidth,
                      child: GridView.builder(
                        padding: EdgeInsets.all(
                          width < 360 ? 10 : 16,
                        ),
                        itemCount: posts.length,
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio:
                          crossAxisCount == 1 ? 3.0 : 1.5,
                        ),
                        itemBuilder: (context, index) {
                          final post = posts[index];

                          return Card(
                            clipBehavior: Clip.antiAlias,
                            margin: EdgeInsets.zero,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ArticleDetailsPage(
                                      post: Map<String, dynamic>.from(post),
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: width < 360 ? 17 : 22,
                                      child: FittedBox(
                                        child: Text('${post['id']}'),
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            post['title']?.toString() ?? '',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: width < 360 ? 13 : 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Expanded(
                                            child: Text(
                                              post['body']?.toString() ?? '',
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: width < 360 ? 11 : 13,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
