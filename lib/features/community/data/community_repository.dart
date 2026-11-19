import 'package:supabase_flutter/supabase_flutter.dart';

class CommunityPost {
  const CommunityPost({
    required this.id,
    required this.userId,
    required this.authorName,
    required this.content,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String authorName;
  final String content;
  final DateTime createdAt;

  factory CommunityPost.fromMap(Map<String, dynamic> map) {
    return CommunityPost(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      authorName: (map['author_name'] as String?)?.trim().isNotEmpty == true
          ? map['author_name'] as String
          : 'Usuario',
      content: map['content'] as String,
      createdAt: DateTime.parse(map['created_at'] as String).toLocal(),
    );
  }
}

class CommunityRepository {
  const CommunityRepository(this.client);

  final SupabaseClient client;

  Future<List<CommunityPost>> loadPosts() async {
    final data = await client
        .from('community_posts')
        .select('id, user_id, author_name, content, created_at')
        .order('created_at', ascending: false)
        .limit(100);
    return [
      for (final row in data)
        CommunityPost.fromMap(Map<String, dynamic>.from(row as Map)),
    ];
  }

  Future<void> createPost(String content) async {
    final user = client.auth.currentUser;
    if (user == null) throw const AuthException('Inicia sesión para publicar.');

    final authorName =
        user.userMetadata?['full_name'] as String? ??
        user.userMetadata?['name'] as String? ??
        user.email ??
        'Usuario';
    await client.from('community_posts').insert({
      'content': content,
      'author_name': authorName,
    });
  }

  Future<void> deletePost(String postId) async {
    await client.from('community_posts').delete().eq('id', postId);
  }
}
