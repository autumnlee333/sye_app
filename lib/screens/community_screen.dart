import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_provider.dart';
import '../providers/follow_provider.dart';
import '../providers/auth_provider.dart';
import 'profile_screen.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        ref.read(userSearchProvider.notifier).search(query.trim());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(userSearchProvider);
    final currentUserId = ref.watch(authProvider).value?.uid;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Find other readers...',
              prefixIcon: const Icon(Icons.people),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  ref.read(userSearchProvider.notifier).search('');
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            onChanged: _onSearchChanged,
          ),
        ),
        Expanded(
          child: searchResults.when(
            data: (users) {
              if (users.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _searchController.text.isEmpty
                            ? Icons.group_add
                            : Icons.person_off,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _searchController.text.isEmpty
                            ? 'Search for people to follow!'
                            : 'No users found.',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  if (user.uid == currentUserId) return const SizedBox.shrink();

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: user.profilePicUrl.isNotEmpty
                          ? NetworkImage(user.profilePicUrl)
                          : null,
                      child: user.profilePicUrl.isEmpty
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    title: Text(user.displayName),
                    subtitle: Text(
                      user.bio,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: ref.watch(isFollowingProvider(user.uid)).when(
                          data: (isFollowing) => TextButton(
                            onPressed: () {
                              if (isFollowing) {
                                ref.read(followActionProvider.notifier).unfollow(user.uid);
                              } else {
                                ref.read(followActionProvider.notifier).follow(user.uid);
                              }
                            },
                            child: Text(isFollowing ? 'Unfollow' : 'Follow'),
                          ),
                          loading: () => const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          error: (_, __) => const Icon(Icons.error),
                        ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(userId: user.uid),
                        ),
                      );
                    },
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        ),
      ],
    );
  }
}
