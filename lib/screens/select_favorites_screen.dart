import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/book_provider.dart';
import '../providers/user_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/book_card.dart';

class SelectFavoritesScreen extends ConsumerStatefulWidget {
  final List<String> initialFavoriteIds;

  const SelectFavoritesScreen({
    super.key,
    required this.initialFavoriteIds,
  });

  @override
  ConsumerState<SelectFavoritesScreen> createState() => _SelectFavoritesScreenState();
}

class _SelectFavoritesScreenState extends ConsumerState<SelectFavoritesScreen> {
  final _searchController = TextEditingController();
  final List<String> _selectedIds = [];
  Timer? _debounce;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedIds.addAll(widget.initialFavoriteIds);
  }

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

  void _toggleSelection(String bookId) {
    setState(() {
      if (_selectedIds.contains(bookId)) {
        _selectedIds.remove(bookId);
      } else {
        if (_selectedIds.length < 3) {
          _selectedIds.add(bookId);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You can only select up to 3 favorites.')),
          );
        }
      }
    });
  }

  Future<void> _saveFavorites() async {
    setState(() => _isSaving = true);
    try {
      final user = ref.read(authProvider).value;
      if (user != null) {
        await ref.read(userServiceProvider).updateFavoriteBooks(user.uid, _selectedIds);
        if (mounted) Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving favorites: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(bookSearchProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Favorites'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Selected: ${_selectedIds.length} / 3',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    if (_selectedIds.length == 3)
                      const Text(
                        'Limit reached',
                        style: TextStyle(color: Colors.orange, fontSize: 12),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for books...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onChanged: _onSearchChanged,
                ),
              ],
            ),
          ),
          Expanded(
            child: searchResults.when(
              data: (books) {
                if (books.isEmpty && _searchController.text.isEmpty) {
                  return const Center(child: Text('Search for your favorite books!'));
                }
                if (books.isEmpty) {
                  return const Center(child: Text('No books found.'));
                }
                return ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    final isSelected = _selectedIds.contains(book.id);
                    return BookCard(
                      title: book.title,
                      authors: book.authors,
                      thumbnailUrl: book.thumbnailUrl,
                      averageRating: book.averageRating,
                      categories: book.categories,
                      onTap: () => _toggleSelection(book.id),
                      trailing: Icon(
                        isSelected ? Icons.check_circle : Icons.add_circle_outline,
                        color: isSelected ? Colors.green : Colors.grey,
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveFavorites,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Save Favorites', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
