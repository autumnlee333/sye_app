import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/library_book_model.dart';
import '../models/custom_list_model.dart';
import '../providers/library_provider.dart';
import '../providers/list_provider.dart';
import '../providers/selection_provider.dart';
import '../widgets/book_card.dart';
import '../widgets/review_dialog.dart';
import 'book_details_screen.dart';
import 'list_details_screen.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listsAsync = ref.watch(userListsProvider);
    final isBatchMode = ref.watch(isBatchModeProvider);
    final selectedIds = ref.watch(selectedBookIdsProvider);

    return Scaffold(
      appBar: AppBar(
        title: isBatchMode 
            ? Text('${selectedIds.length} Selected')
            : const Text('My Library'),
        centerTitle: true,
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
          if (!isBatchMode)
            IconButton(
              icon: const Icon(Icons.checklist_rtl, color: Colors.blue),
              tooltip: 'Batch Edit',
              onPressed: () => ref.read(isBatchModeProvider.notifier).state = true,
            ),
        ],
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    'Status',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 400, // Fixed height for status tabs
                  child: DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        const TabBar(
                          tabs: [
                            Tab(text: 'Reading'),
                            Tab(text: 'Want to Read'),
                            Tab(text: 'Finished'),
                          ],
                          labelColor: Colors.blue,
                          unselectedLabelColor: Colors.grey,
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              _LibraryList(status: ReadingStatus.reading),
                              _LibraryList(status: ReadingStatus.wantToRead),
                              _LibraryList(status: ReadingStatus.finished),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'My Custom Lists',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      if (!isBatchMode)
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, color: Colors.blue),
                          onPressed: () => _showCreateListDialog(context, ref),
                        ),
                    ],
                  ),
                ),
              ),
              listsAsync.when(
                data: (lists) => lists.isEmpty
                    ? const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Center(
                            child: Text(
                              'No custom lists yet.\nCreate one to organize your books!',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverGrid(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 1.5,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final list = lists[index];
                              return _CustomListCard(list: list);
                            },
                            childCount: lists.length,
                          ),
                        ),
                      ),
                loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
                error: (e, _) => SliverToBoxAdapter(child: Center(child: Text('Error: $e'))),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)), // Space for bottom bar
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton.icon(
                        onPressed: () => _showBulkStatusDialog(context, ref, selectedIds.toList()),
                        icon: const Icon(Icons.move_to_inbox, color: Colors.white),
                        label: const Text('Move Status', style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(height: 24, child: VerticalDivider(color: Colors.white24)),
                      TextButton.icon(
                        onPressed: () => _confirmBulkDelete(context, ref, selectedIds.toList()),
                        icon: const Icon(Icons.delete_outline, color: Colors.white),
                        label: const Text('Remove', style: TextStyle(color: Colors.white)),
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

  void _showBulkStatusDialog(BuildContext context, WidgetRef ref, List<String> bookIds) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Move Selected Books'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ReadingStatus.values.map((status) {
            return ListTile(
              title: Text(status.label),
              onTap: () {
                ref.read(libraryActionProvider.notifier).bulkUpdateStatus(bookIds, status);
                ref.read(isBatchModeProvider.notifier).state = false;
                ref.read(selectedBookIdsProvider.notifier).state = {};
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Moved ${bookIds.length} books to ${status.label}')),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _confirmBulkDelete(BuildContext context, WidgetRef ref, List<String> bookIds) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Books?'),
        content: Text('Are you sure you want to remove ${bookIds.length} books from your library?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              ref.read(libraryActionProvider.notifier).bulkRemoveBooks(bookIds);
              ref.read(isBatchModeProvider.notifier).state = false;
              ref.read(selectedBookIdsProvider.notifier).state = {};
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Removed ${bookIds.length} books')),
              );
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showCreateListDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    bool isPrivate = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Create New List'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'List Name (e.g. Summer 2024)'),
                ),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: 'Description (optional)'),
                ),
                SwitchListTile(
                  title: const Text('Private List'),
                  value: isPrivate,
                  onChanged: (val) => setState(() => isPrivate = val),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  ref.read(listActionProvider.notifier).createList(
                    nameController.text.trim(),
                    descController.text.trim(),
                    isPrivate,
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LibraryList extends ConsumerWidget {
  final ReadingStatus status;
  const _LibraryList({required this.status});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsync = ref.watch(libraryProvider(status));
    final isBatchMode = ref.watch(isBatchModeProvider);
    final selectedIds = ref.watch(selectedBookIdsProvider);

    return booksAsync.when(
      data: (books) => books.isEmpty
          ? Center(child: Text('No books in ${status.label}'))
          : ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                final isSelected = selectedIds.contains(book.bookId);

                return BookCard(
                  title: book.title,
                  authors: book.authors,
                  thumbnailUrl: book.thumbnailUrl,
                  averageRating: book.averageRating,
                  categories: book.categories,
                  currentPage: book.currentPage,
                  totalPages: book.totalPages,
                  isSelected: isSelected,
                  onSelected: isBatchMode 
                      ? (val) {
                          final current = Set<String>.from(ref.read(selectedBookIdsProvider));
                          if (val == true) {
                            current.add(book.bookId);
                          } else {
                            current.remove(book.bookId);
                          }
                          ref.read(selectedBookIdsProvider.notifier).state = current;
                        }
                      : null,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BookDetailsScreen(bookId: book.bookId),
                      ),
                    );
                  },
                  trailing: !isBatchMode ? _getTrailingAction(context, ref, book) : null,
                );
              },
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  Widget? _getTrailingAction(BuildContext context, WidgetRef ref, LibraryBookModel book) {
    if (status == ReadingStatus.reading) {
      return IconButton(
        icon: const Icon(Icons.edit_note, color: Colors.blue),
        tooltip: 'Update Progress',
        onPressed: () => _showUpdateProgressDialog(context, ref, book),
      );
    } else if (status == ReadingStatus.finished) {
      return TextButton(
        onPressed: () => ReviewDialog.show(context, book),
        child: const Text('Rate & Review', style: TextStyle(fontSize: 12)),
      );
    }
    return null;
  }

  void _showUpdateProgressDialog(BuildContext context, WidgetRef ref, LibraryBookModel book) {
    final pageController = TextEditingController(text: book.currentPage.toString());
    final totalPageController = TextEditingController(text: book.totalPages > 0 ? book.totalPages.toString() : '');
    final commentController = TextEditingController();
    bool postToFeed = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Update Progress: ${book.title}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: pageController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Current Page',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('of', style: TextStyle(fontSize: 16)),
                    ),
                    Expanded(
                      child: TextField(
                        controller: totalPageController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Total Pages',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: commentController,
                  decoration: const InputDecoration(
                    labelText: 'Add a thought (optional)',
                    hintText: 'What\'s happening in the book?',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                CheckboxListTile(
                  title: const Text('Post update to feed', style: TextStyle(fontSize: 14)),
                  value: postToFeed,
                  onChanged: (val) => setState(() => postToFeed = val ?? true),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final newPage = int.tryParse(pageController.text) ?? book.currentPage;
                final newTotal = int.tryParse(totalPageController.text) ?? book.totalPages;
                
                if (newPage > newTotal && newTotal > 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Current page cannot exceed total pages.')),
                  );
                  return;
                }

                ref.read(libraryActionProvider.notifier).updateProgress(
                  book.bookId,
                  newPage,
                  newTotal,
                  comment: commentController.text.trim(),
                  postToFeed: postToFeed,
                );
                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomListCard extends StatelessWidget {
  final CustomListModel list;
  const _CustomListCard({required this.list});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ListDetailsScreen(list: list),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(list.isPrivate ? Icons.lock_outline : Icons.list, size: 20, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    list.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${list.bookIds.length} books',
              style: TextStyle(color: Colors.blue[800], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
