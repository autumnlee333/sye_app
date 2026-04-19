import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/book_provider.dart';
import '../providers/library_provider.dart';
import '../models/library_book_model.dart';
import '../widgets/book_card.dart';
import 'book_details_screen.dart';

class ExploreTab extends ConsumerStatefulWidget {
  const ExploreTab({super.key});

  @override
  ConsumerState<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends ConsumerState<ExploreTab> {
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
    final isSearching = _searchController.text.isNotEmpty;

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(recommendationsProvider);
        ref.invalidate(smartRecommendationsProvider);
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search books, authors, or ISBN...',
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
              ),
            ),
          ),
          if (!isSearching) ...[
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Text(
                  'Explore by Genre',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 200,
                child: ref.watch(recommendationsProvider).when(
                  data: (books) => books.isEmpty
                      ? const Center(child: Text('Add favorite genres for better picks!'))
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: books.length,
                          itemBuilder: (context, index) => _CompactBookCard(book: books[index]),
                        ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Error: $e')),
                ),
              ),
            ),
            ref.watch(smartRecommendationsProvider).when(
              data: (books) => books.isEmpty
                  ? const SliverToBoxAdapter(child: SizedBox.shrink())
                  : SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                            child: Text(
                              'More Like Your Favorites',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              itemCount: books.length,
                              itemBuilder: (context, index) => _CompactBookCard(book: books[index]),
                            ),
                          ),
                        ],
                      ),
                    ),
              loading: () => const SliverToBoxAdapter(
                child: SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
              ),
              error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
            ),
          ] else
            searchResults.when(
              data: (books) => books.isEmpty
                  ? const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: Text('No books found.')),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
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
                              onSelected: (status) {
                                ref.read(libraryActionProvider.notifier).addBook(book, status);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Added to ${status.label}')),
                                );
                              },
                              itemBuilder: (context) => ReadingStatus.values.map((status) {
                                return PopupMenuItem(value: status, child: Text(status.label));
                              }).toList(),
                            ),
                          );
                        },
                        childCount: books.length,
                      ),
                    ),
              loading: () => const SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
              error: (e, _) => SliverToBoxAdapter(child: Center(child: Text('Error: $e'))),
            ),
        ],
      ),
    );
  }
}

class _CompactBookCard extends StatelessWidget {
  final dynamic book;
  const _CompactBookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: const EdgeInsets.all(4),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BookDetailsScreen(bookId: book.id, initialBook: book),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: book.thumbnailUrl != null
                    ? Image.network(book.thumbnailUrl!, fit: BoxFit.cover)
                    : Container(color: Colors.grey[200], child: const Icon(Icons.book)),
              ),
            ),
            const SizedBox(height: 4),
            Text(book.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            Text(
              book.authors.isNotEmpty ? book.authors.first : 'Unknown',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
