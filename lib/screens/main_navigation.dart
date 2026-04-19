import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/navigation_provider.dart';
import '../providers/book_provider.dart';
import '../providers/library_provider.dart';
import '../models/library_book_model.dart';
import '../widgets/book_card.dart';
import '../widgets/review_dialog.dart';
import 'profile_screen.dart';
import 'library_screen.dart';
import 'feed_screen.dart';
import 'community_screen.dart';
import 'book_details_screen.dart';

class MainNavigation extends ConsumerWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);

    // Global listener for finished books to show the review prompt
    ref.listen<LibraryBookModel?>(finishedBookProvider, (previous, next) {
      if (next != null) {
        // Use SchedulerBinding to ensure we show the dialog after the current frame
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            _showReviewPrompt(context, ref, next);
            // Clear the state so it doesn't trigger again
            ref.read(finishedBookProvider.notifier).state = null;
          }
        });
      }
    });

    final List<Widget> screens = [
      const FeedScreen(),
      const CommunityScreen(),
      const BookSearchTab(),
      const LibraryScreen(),
      const ProfileScreen(),
    ];

    final List<String> titles = [
      'Feed',
      'Community',
      'Search Books',
      'My Library',
      'Profile',
    ];

    return Scaffold(
      appBar: currentIndex != 3 // LibraryScreen has its own AppBar with tabs
          ? AppBar(
              title: Text(titles[currentIndex]),
              centerTitle: true,
            )
          : null,
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
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Community'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Library'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  void _showReviewPrompt(BuildContext context, WidgetRef ref, LibraryBookModel book) {
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (context) => AlertDialog(
        title: const Text('Congratulations!'),
        content: Text('You\'ve finished "${book.title}". Would you like to leave a review?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Maybe Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ReviewDialog.show(context, book);
            },
            child: const Text('Leave Review'),
          ),
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
        ref.read(bookSearchProvider.notifier).search(query.trim());
      }
    });
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
            onChanged: _onSearchChanged,
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
                  final book = books[index];
                  return BookCard(
                    title: book.title,
                    authors: book.authors,
                    thumbnailUrl: book.thumbnailUrl,
                    averageRating: book.averageRating,
                    categories: book.categories,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => BookDetailsScreen(
                            bookId: book.id,
                            initialBook: book,
                          ),
                        ),
                      );
                    },
                    trailing: PopupMenuButton<ReadingStatus>(
                      icon: const Icon(Icons.library_add, color: Colors.blue),
                      tooltip: 'Add to Library',
                      onSelected: (status) {
                        ref.read(libraryActionProvider.notifier).addBook(book, status);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Added to ${status.label}')),
                        );
                      },
                      itemBuilder: (context) => ReadingStatus.values.map((status) {
                        return PopupMenuItem(
                          value: status,
                          child: Text(status.label),
                        );
                      }).toList(),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      e.toString().replaceFirst('Exception: ', '').replaceFirst('Error searching books: ', ''),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.read(bookSearchProvider.notifier).search(_searchController.text.trim()),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
