import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BookCard extends StatelessWidget {
  final String title;
  final List<String> authors;
  final String? thumbnailUrl;
  final double? averageRating;
  final List<String> categories;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool isSelected;
  final ValueChanged<bool?>? onSelected;
  final int currentPage;
  final int totalPages;

  const BookCard({
    super.key,
    required this.title,
    required this.authors,
    this.thumbnailUrl,
    this.averageRating,
    this.categories = const [],
    this.onTap,
    this.trailing,
    this.isSelected = false,
    this.onSelected,
    this.currentPage = 0,
    this.totalPages = 0,
  });

  @override
  Widget build(BuildContext context) {
    final hasProgress = totalPages > 0;
    final progress = hasProgress ? (currentPage / totalPages).clamp(0.0, 1.0) : 0.0;
    final percentage = (progress * 100).toInt();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      color: isSelected ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected 
            ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onSelected != null ? () => onSelected!(!isSelected) : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (onSelected != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0, top: 40),
                      child: Checkbox(
                        value: isSelected,
                        onChanged: onSelected,
                      ),
                    ),
                  // Book Cover Thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 80,
                      height: 120,
                      color: Colors.grey[200],
                      child: thumbnailUrl != null && thumbnailUrl!.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: thumbnailUrl!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Icon(Icons.book, size: 40, color: Colors.grey),
                              errorWidget: (context, url, error) => const Icon(Icons.book, size: 40, color: Colors.grey),
                            )
                          : const Icon(Icons.book, size: 40, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Book Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          authors.isNotEmpty
                              ? authors.join(', ')
                              : 'Unknown Author',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        if (averageRating != null)
                          Row(
                            children: [
                              const Icon(Icons.star, size: 16, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text(
                                averageRating!.toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 8),
                        if (categories.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              categories.first,
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (trailing != null) trailing!,
                ],
              ),
              if (hasProgress) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '$percentage%',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Page $currentPage of $totalPages',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
