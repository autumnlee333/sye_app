import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/library_book_model.dart';
import '../providers/review_provider.dart';
import 'star_rating.dart';

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

  void _updateRating(Offset localPosition, double maxWidth) {
    final double relativePosition = localPosition.dx / maxWidth;
    double newRating = (relativePosition * 5 * 2).ceil() / 2;
    
    if (newRating < 0.5) newRating = 0.5;
    if (newRating > 5.0) newRating = 5.0;

    setState(() {
      _rating = newRating;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.id != null;

    return AlertDialog(
      title: Text(
        '${isEditing ? 'Edit' : 'Review'}: ${widget.book.title}',
        style: const TextStyle(fontSize: 18),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('What do you think?'),
              const SizedBox(height: 16),
              // Use a fixed width container for the gesture detector to ensure it has constraints
              SizedBox(
                width: 220, // 5 stars * 40 size + padding
                child: GestureDetector(
                  onTapDown: (details) => _updateRating(details.localPosition, 220),
                  onPanUpdate: (details) => _updateRating(details.localPosition, 220),
                  child: Center(
                    child: StarRating(
                      rating: _rating,
                      size: 40,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _rating == 0 ? 'Select a rating' : '$_rating stars',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _reviewController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Write your thoughts here...',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
            ],
          ),
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
