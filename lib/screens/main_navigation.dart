import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/navigation_provider.dart';
import '../providers/user_provider.dart';

class MainNavigation extends ConsumerWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);

    final List<Widget> screens = [
      const _HomePlaceholder(),
      const _SearchPlaceholder(),
      const _LibraryPlaceholder(),
      const _ProfilePlaceholder(),
    ];

    final List<String> titles = [
      'Feed',
      'Search',
      'My Library',
      'Profile',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[currentIndex]),
        centerTitle: true,
      ),
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => ref.read(navigationIndexProvider.notifier).state = index,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Library'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class _HomePlaceholder extends StatelessWidget {
  const _HomePlaceholder();
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.rss_feed, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('Live Activity Feed', style: TextStyle(fontSize: 20)),
          Text('See what your friends are reading!'),
        ],
      ),
    );
  }
}

class _SearchPlaceholder extends StatelessWidget {
  const _SearchPlaceholder();
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('Book Search', style: TextStyle(fontSize: 20)),
          Text('Search the Google Books API.'),
        ],
      ),
    );
  }
}

class _LibraryPlaceholder extends StatelessWidget {
  const _LibraryPlaceholder();
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.collections_bookmark, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('My Library', style: TextStyle(fontSize: 20)),
          Text('Your shelves and reading progress.'),
        ],
      ),
    );
  }
}

class _ProfilePlaceholder extends ConsumerWidget {
  const _ProfilePlaceholder();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(currentUserDataProvider);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.account_circle, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          userProfile.when(
            data: (user) => Text(
              user?.displayName ?? 'Reader',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            loading: () => const CircularProgressIndicator(),
            error: (_, __) => const Text('Error loading profile'),
          ),
          const SizedBox(height: 8),
          const Text('Member since 2026'),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => ref.read(authServiceProvider).signOut(),
            icon: const Icon(Icons.logout),
            label: const Text('Sign Out'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.red,
              backgroundColor: Colors.red.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
}
