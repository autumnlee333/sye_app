import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/library_book_model.dart';
import '../providers/review_provider.dart';

class ReviewDialog extends ConsumerStatefulWidget {
  final LibraryBookModel book;
  final String? id;
  final double? initialRating;
  final String? initialText;
  final String? activityId;

  const ReviewDialog({
    super.key, 
    required this.book,
    this.id,
    this.initialRating,
    this.initialText,
    this.activityId,
  });

  static void show(
    BuildContext context, 
    LibraryBookModel book, {
    String? id,
    double? initialRating,
    String? initialText,
    String? activityId,
  }) {
    showDialog(
      context: context,
      useRootNavigator: true,
      builder: (context) => ReviewDialog(
        book: book,
        id: id,
        initialRating: initialRating,
        initialText: initialText,
        activityId: activityId,
      ),
    );
  }

  @override
  ConsumerState<ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends ConsumerState<ReviewDialog> {
  late double _rating;
  late final TextEditingController _reviewController;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating ?? 0;
    _reviewController = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.id != null;

    return AlertDialog(
      title: Text('${isEditing ? 'Edit' : 'Review'}: ${widget.book.title}'),
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
                    id: widget.id,
                    activityId: widget.activityId,
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(isEditing ? 'Review updated!' : 'Review posted!')),
                  );
                },
          child: Text(isEditing ? 'Save Changes' : 'Post Review'),
        ),
      ],
    );
  }
}
