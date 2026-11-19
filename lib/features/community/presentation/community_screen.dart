import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/localization.dart';
import '../../../app/presentation/language_selector.dart';
import '../../../app/theme/app_theme.dart';
import '../../shared/presentation/auth_screen.dart';
import '../data/community_repository.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({required this.supabaseClient, super.key});

  final SupabaseClient? supabaseClient;

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final _contentController = TextEditingController();
  bool _isPublishing = false;
  String? _error;
  late Future<List<CommunityPost>> _posts = _loadPosts();

  Future<List<CommunityPost>> _loadPosts() {
    final client = widget.supabaseClient;
    if (client == null) return Future.value(<CommunityPost>[]);
    return CommunityRepository(client).loadPosts();
  }

  Future<void> _refresh() async {
    setState(() {
      _posts = _loadPosts();
      _error = null;
    });
  }

  Future<void> _publish() async {
    final content = _contentController.text.trim();
    final client = widget.supabaseClient;
    if (content.isEmpty) return;
    if (client == null) {
      setState(() => _error = context.tr('configuration_notice'));
      return;
    }

    if (client.auth.currentUser == null) {
      await Navigator.of(context).push<bool>(
        MaterialPageRoute<bool>(
          builder: (_) =>
              AuthScreen(supabaseClient: client, startInRegistration: true),
        ),
      );
      if (!mounted) return;
    }
    if (client.auth.currentUser == null) {
      setState(() => _error = context.tr('community_login_required'));
      return;
    }

    setState(() {
      _isPublishing = true;
      _error = null;
    });
    try {
      await CommunityRepository(client).createPost(content);
      _contentController.clear();
      await _refresh();
    } on Exception catch (error) {
      if (mounted) setState(() => _error = _formatCommunityError(error));
    } finally {
      if (mounted) setState(() => _isPublishing = false);
    }
  }

  Future<void> _delete(CommunityPost post) async {
    final client = widget.supabaseClient;
    if (client == null) return;
    try {
      await CommunityRepository(client).deletePost(post.id);
      await _refresh();
    } on Exception catch (error) {
      if (mounted) setState(() => _error = _formatCommunityError(error));
    }
  }

  String _formatCommunityError(Object error) {
    if (error is PostgrestException &&
        (error.code == '42P01' ||
            error.code == '42501' ||
            error.code == 'PGRST205' ||
            error.message.contains('community_posts') ||
            error.message.contains('schema cache'))) {
      return '${context.tr('community_setup_error')} (${error.message})';
    }
    return '${context.tr('failed_post')} ($error)';
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final client = widget.supabaseClient;
    final currentUserId = client?.auth.currentUser?.id;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.text('community_title')),
        actions: const [LanguageSelector()],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                if (client != null) ...[
                  if (client.auth.currentUser == null) ...[
                    OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).push<void>(
                        MaterialPageRoute<void>(
                          builder: (_) => AuthScreen(
                            supabaseClient: client,
                            startInRegistration: true,
                          ),
                        ),
                      ),
                      icon: const Icon(Icons.person_add_alt_1_outlined),
                      label: Text(l10n.text('sign_in_or_register')),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Text(
                    l10n.text('new_post'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _contentController,
                    minLines: 3,
                    maxLines: 6,
                    maxLength: 1000,
                    decoration: InputDecoration(
                      hintText: l10n.text('post_placeholder'),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton.icon(
                      onPressed: _isPublishing ? null : _publish,
                      icon: const Icon(Icons.send_rounded),
                      label: Text(l10n.text('publish')),
                    ),
                  ),
                ] else
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.goldTint,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(l10n.text('configuration_notice')),
                  ),
                if (_error != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    _error!,
                    style: const TextStyle(color: AppColors.terracotta),
                  ),
                ],
                const SizedBox(height: 24),
                Text(
                  l10n.text('community_feed'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                if (client == null)
                  Text(l10n.text('configuration_notice'))
                else
                  FutureBuilder<List<CommunityPost>>(
                    future: _posts,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text(
                          _formatCommunityError(snapshot.error!),
                          style: const TextStyle(color: AppColors.terracotta),
                        );
                      }
                      if (!snapshot.hasData) {
                        return const Padding(
                          padding: EdgeInsets.all(24),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final posts = snapshot.data!;
                      if (posts.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            l10n.text('empty_feed'),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                      return Column(
                        children: [
                          for (final post in posts) ...[
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const CircleAvatar(
                                          backgroundColor: AppColors.blueTint,
                                          child: Icon(Icons.person_outline),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                context.l10n.content(
                                                  post.authorName,
                                                ),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                              ),
                                              Text(
                                                '${post.createdAt.day}/${post.createdAt.month}/${post.createdAt.year}',
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodySmall,
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (post.userId == currentUserId)
                                          IconButton(
                                            tooltip: l10n.text('delete_post'),
                                            onPressed: () => _delete(post),
                                            icon: const Icon(
                                              Icons.delete_outline_rounded,
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(post.content),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ],
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
