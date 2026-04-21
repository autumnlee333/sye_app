import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/navigation_provider.dart';
import '../providers/library_provider.dart';
import '../models/library_book_model.dart';
import '../widgets/review_dialog.dart';
import 'profile_screen.dart';
import 'library_screen.dart';
import 'feed_screen.dart';
import 'community_screen.dart';
import 'explore_tab.dart';

class MainNavigation extends ConsumerWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);

    // Global listener for finished books to show the review prompt
    ref.listen<LibraryBookModel?>(finishedBookProvider, (previous, next) {
      if (next != null) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            _showReviewPrompt(context, ref, next);
            // Clear the provider so we don't show it again on rebuild
            ref.read(finishedBookProvider.notifier).state = null;
          }
        });
      }
    });

    final List<Widget> screens = [
      const FeedScreen(),
      const ExploreTab(),
      const CommunityScreen(),
      const LibraryScreen(),
      const ProfileScreen(),
    ];

    final List<String> titles = [
      'Feed',
      'Explore',
      'Community',
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
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Community'),
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
              Navigator.pop(context); // Close prompt
              // Use the context of the main navigation to show the review dialog
              ReviewDialog.show(context, book);
            },
            child: const Text('Leave Review'),
          ),
        ],
      ),
    );
  }
}
