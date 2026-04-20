import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/custom_list_model.dart';
import '../providers/book_provider.dart';
import '../providers/list_provider.dart';
import '../providers/selection_provider.dart';
import '../widgets/book_card.dart';
import 'book_details_screen.dart';

class ListDetailsScreen extends ConsumerWidget {
  final CustomListModel list;

  const ListDetailsScreen({super.key, required this.list});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allLists = ref.watch(userListsProvider).value ?? [];
    final currentList = allLists.firstWhere((l) => l.id == list.id, orElse: () => list);
    final isBatchMode = ref.watch(isBatchModeProvider);
    final selectedIds = ref.watch(selectedBookIdsProvider);

    return Scaffold(
      appBar: AppBar(
        title: isBatchMode 
            ? Text('${selectedIds.length} Selected')
            : Text(currentList.name),
        leading: isBatchMode 
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  ref.read(isBatchModeProvider.notifier).state = false;
                  ref.read(selectedBookIdsProvider.notifier).state = {};
                },
              )
            : null,
        actions: [
          if (!isBatchMode) ...[
            IconButton(
              icon: const Icon(Icons.playlist_add),
              tooltip: 'Add Book',
              onPressed: () => _showSearchToAddDialog(context, ref, currentList),
            ),
            IconButton(
              icon: const Icon(Icons.checklist_rtl, color: Colors.blue),
              tooltip: 'Batch Edit',
              onPressed: () => ref.read(isBatchModeProvider.notifier).state = true,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Delete List',
              onPressed: () => _confirmDelete(context, ref, currentList),
            ),
          ],
        ],
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (currentList.description.isNotEmpty && !isBatchMode)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    currentList.description,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              Expanded(
                child: currentList.bookIds.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.bookmark_border, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text('No books in this list yet.', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      )
                    : ref.watch(bookDetailsProvider(currentList.bookIds)).when(
                          data: (books) => ListView.builder(
                            itemCount: books.length,
                            itemBuilder: (context, index) {
                              final book = books[index];
                              final isSelected = selectedIds.contains(book.id);

                              return BookCard(
                                title: book.title,
                                authors: book.authors,
                                thumbnailUrl: book.thumbnailUrl,
                                averageRating: book.averageRating,
                                categories: book.categories,
                                isSelected: isSelected,
                                onSelected: isBatchMode 
                                    ? (val) {
                                        final current = Set<String>.from(ref.read(selectedBookIdsProvider));
                                        if (val == true) {
                                          current.add(book.id);
                                        } else {
                                          current.remove(book.id);
                                        }
                                        ref.read(selectedBookIdsProvider.notifier).state = current;
                                      }
                                    : null,
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
                                trailing: !isBatchMode 
                                    ? IconButton(
                                        icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                        onPressed: () {
                                          ref.read(listActionProvider.notifier).removeBookFromList(currentList.id, book.id);
                                        },
                                      )
                                    : null,
                              );
                            },
                          ),
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (e, _) => Center(child: Text('Error: $e')),
                        ),
              ),
            ],
          ),
          if (isBatchMode && selectedIds.isNotEmpty)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Card(
                elevation: 8,
                color: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: () => _confirmBulkRemoveFromList(context, ref, currentList, selectedIds.toList()),
                        icon: const Icon(Icons.delete_outline, color: Colors.white),
                        label: Text('Remove from ${currentList.name}', style: const TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _confirmBulkRemoveFromList(BuildContext context, WidgetRef ref, CustomListModel list, List<String> bookIds) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Books?'),
        content: Text('Are you sure you want to remove ${bookIds.length} books from "${list.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              ref.read(listActionProvider.notifier).bulkRemoveBooksFromList(list.id, bookIds);
              ref.read(isBatchModeProvider.notifier).state = false;
              ref.read(selectedBookIdsProvider.notifier).state = {};
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Removed ${bookIds.length} books from ${list.name}')),
              );
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showSearchToAddDialog(BuildContext context, WidgetRef ref, CustomListModel list) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ListSearchSheet(list: list),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, CustomListModel list) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete List?'),
        content: Text('Are you sure you want to delete "${list.name}"? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              ref.read(listActionProvider.notifier).deleteList(list.id);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back from details screen
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _ListSearchSheet extends ConsumerStatefulWidget {
  final CustomListModel list;
  const _ListSearchSheet({required this.list});

  @override
  ConsumerState<_ListSearchSheet> createState() => _ListSearchSheetState();
}

class _ListSearchSheetState extends ConsumerState<_ListSearchSheet> {
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

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search books to add...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onChanged: _onSearchChanged,
                ),
              ),
              Expanded(
                child: searchResults.when(
                  data: (books) => ListView.builder(
                    controller: scrollController,
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final book = books[index];
                      // Use the updated list state from the provider to check containment
                      final allLists = ref.watch(userListsProvider).value ?? [];
                      final currentList = allLists.firstWhere((l) => l.id == widget.list.id, orElse: () => widget.list);
                      final isAlreadyInList = currentList.bookIds.contains(book.id);

                      return ListTile(
                        leading: book.thumbnailUrl != null
                            ? Image.network(book.thumbnailUrl!, width: 40, fit: BoxFit.cover)
                            : const Icon(Icons.book),
                        title: Text(book.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle: Text(book.authors.isNotEmpty ? book.authors.first : 'Unknown Author'),
                        trailing: isAlreadyInList
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : const Icon(Icons.add_circle_outline, color: Colors.blue),
                        onTap: isAlreadyInList
                            ? null
                            : () {
                                ref.read(listActionProvider.notifier).addBookToList(widget.list.id, book.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Added to ${widget.list.name}')),
                                );
                              },
                      );
                    },
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Error: $e')),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
