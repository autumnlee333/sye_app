import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/library_book_model.dart';
import '../providers/review_provider.dart';

class ReviewDialog extends ConsumerStatefulWidget {
  final LibraryBookModel book;

  const ReviewDialog({super.key, required this.book});

  static void show(BuildContext context, LibraryBookModel book) {
    showDialog(
      context: context,
      useRootNavigator: true,
      builder: (context) => ReviewDialog(book: book),
    );
  }

  @override
  ConsumerState<ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends ConsumerState<ReviewDialog> {
  double _rating = 0;
  final _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Review: ${widget.book.title}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('What do you think?'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 32,
                  ),
                  onPressed: () => setState(() => _rating = index + 1.0),
                );
              }),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _reviewController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Write your thoughts here...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _rating == 0 
              ? null 
              : () {
                  ref.read(reviewActionProvider.notifier).postReview(
                    bookId: widget.book.bookId,
                    bookTitle: widget.book.title,
                    bookAuthors: widget.book.authors,
                    bookThumbnail: widget.book.thumbnailUrl,
                    rating: _rating,
                    text: _reviewController.text.trim(),
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Review posted!')),
                  );
                },
          child: const Text('Post Review'),
        ),
      ],
    );
  }
}
