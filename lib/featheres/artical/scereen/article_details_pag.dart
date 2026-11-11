
import 'package:flutter/material.dart';

import '../data/article_database.dart';

class ArticleDetailsPage extends StatelessWidget {
  final Map<String, dynamic> post;

  const ArticleDetailsPage({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    final reactions =
        post['reactions'] as Map<String, dynamic>? ?? {};

    final tags = (post['tags'] as List?)
        ?.map((tag) => tag.toString())
        .toList() ??
        [];

    final title = post['title']?.toString() ?? '';
    final body = post['body']?.toString() ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Article Details'),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final isSmall = width < 360;

          final horizontalPadding = width < 600 ? 16.0 : 28.0;
          final titleSize = width < 600 ? 24.0 : 30.0;
          final bodySize = width < 600 ? 16.0 : 18.0;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 20,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 850,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: isSmall ? 25 : 30,
                        child: Text(
                          '${post['id'] ?? ''}',
                          style: TextStyle(
                            fontSize: isSmall ? 17 : 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                        fontSize: titleSize,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 18),

                    Text(
                      body,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(
                        fontSize: bodySize,
                        height: 1.8,
                      ),
                    ),

                    const SizedBox(height: 28),

                    Text(
                      'Tags',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    if (tags.isEmpty)
                      const Text('No tags available')
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: tags.map((tag) {
                          return Chip(
                            avatar: const Icon(
                              Icons.tag,
                              size: 18,
                            ),
                            label: Text(tag),
                          );
                        }).toList(),
                      ),

                    const SizedBox(height: 28),
                    const Divider(),
                    const SizedBox(height: 8),

                    _InfoTile(
                      icon: Icons.thumb_up_outlined,
                      color: Colors.green,
                      title: 'Likes',
                      value: '${reactions['likes'] ?? 0}',
                    ),

                    _InfoTile(
                      icon: Icons.thumb_down_outlined,
                      color: Colors.red,
                      title: 'Dislikes',
                      value: '${reactions['dislikes'] ?? 0}',
                    ),

                    _InfoTile(
                      icon: Icons.visibility_outlined,
                      title: 'Views',
                      value: '${post['views'] ?? 0}',
                    ),

                    _InfoTile(
                      icon: Icons.person_outline,
                      title: 'User ID',
                      value: '${post['userId'] ?? ''}',
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          try {
                            await ArticleDatabase.instance
                                .saveArticle(post);

                            if (!context.mounted) return;

                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Article saved successfully',
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                          } catch (e) {
                            if (!context.mounted) return;

                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Failed to save article',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                          }
                        },
                        icon: const Icon(Icons.bookmark_add_outlined),
                        label: const Text('Save Article'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                          backgroundColor:
                          Theme.of(context).colorScheme.primary,
                          foregroundColor:
                          Theme.of(context).colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final String title;
  final String value;

  const _InfoTile({
    required this.icon,
    this.color,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(title),
      trailing: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 120),
        child: Text(
          value,
          textAlign: TextAlign.end,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
