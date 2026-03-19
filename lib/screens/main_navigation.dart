import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/navigation_provider.dart';
import '../providers/user_provider.dart';
import '../providers/book_provider.dart';
import '../widgets/book_card.dart';

class MainNavigation extends ConsumerWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);

    final List<Widget> screens = [
      const _HomePlaceholder(),
      const BookSearchTab(),
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

class BookSearchTab extends ConsumerStatefulWidget {
  const BookSearchTab({super.key});

  @override
  ConsumerState<BookSearchTab> createState() => _BookSearchTabState();
}

class _BookSearchTabState extends ConsumerState<BookSearchTab> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    final query = _searchController.text.trim();
    ref.read(bookSearchProvider.notifier).search(query);
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(bookSearchProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search for books, authors, or ISBN...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  ref.read(bookSearchProvider.notifier).search('');
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            onSubmitted: (_) => _onSearch(),
            textInputAction: TextInputAction.search,
          ),
        ),
        Expanded(
          child: searchResults.when(
            data: (books) {
              if (books.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _searchController.text.isEmpty
                            ? Icons.search
                            : Icons.search_off,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _searchController.text.isEmpty
                            ? 'Search for your next great read!'
                            : 'No books found.',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemCount: books.length,
                itemBuilder: (context, index) {
                  return BookCard(
                    book: books[index],
                    onTap: () {
                      // TODO: Navigate to Book Details
                    },
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, __) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text('Error: $e', textAlign: TextAlign.center),
              ),
            ),
          ),
        ),
      ],
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
              backgroundColor: Colors.red.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }
}
