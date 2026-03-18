import 'package:flutter/material.dart';
import '../models/book_model.dart';

class BookCard extends StatelessWidget {
  final BookModel book;
  final VoidCallback? onTap;

  const BookCard({
    super.key,
    required this.book,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: book.thumbnailUrl != null
              ? Image.network(
                  book.thumbnailUrl!,
                  width: 50,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.book, size: 50),
                )
              : const Icon(Icons.book, size: 50),
        ),
        title: Text(
          book.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (book.authors.isNotEmpty)
              Text(
                book.authors.join(', '),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            if (book.averageRating != null)
              Row(
                children: [
                  const Icon(Icons.star, size: 16, color: Colors.amber),
                  Text(' ${book.averageRating}'),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
