import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lear_assignment/core/logic/data_provider.dart';
import 'package:lear_assignment/core/models/word.dart';
import 'package:lear_assignment/features/authentication/logic/auth_provider.dart';

class WordList extends ConsumerWidget {
  final List<Word> words;

  const WordList({super.key, required this.words});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the current user ID
    final authState = ref.watch(authProvider);
    final currentUserId = authState.user?.id;

    if (words.isEmpty) {
      return const Center(
        child: Text('No words yet. Add your first word!'),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        spacing: 8.0, // gap between adjacent chips
        runSpacing: 8.0, // gap between lines
        children: words.map((word) {
          // Generate a color based on the userID
          final color = _generateColorFromUserId(word.userID);

          // Check if this word belongs to the current user
          final isCurrentUserWord = word.userID == currentUserId;

          return Chip(
            backgroundColor: color,
            label: Text(
              word.word,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            // Only show delete icon for the current user's words
            deleteIcon: isCurrentUserWord
                ? const Icon(Icons.close, size: 16, color: Colors.white)
                : null,
            onDeleted: isCurrentUserWord
                ? () {
                    ref.read(dataProvider.notifier).deleteWord(word.id!);
                  }
                : null,
          );
        }).toList(),
      ),
    );
  }

  Color _generateColorFromUserId(String userId) {
    // Simple hash function to generate a consistent color for each user
    int hash = 0;
    for (var i = 0; i < userId.length; i++) {
      hash = userId.codeUnitAt(i) + ((hash << 5) - hash);
    }

    // Convert to a color with good saturation and brightness
    final hue = (hash % 360).abs();
    return HSLColor.fromAHSL(1.0, hue.toDouble(), 0.7, 0.5).toColor();
  }
}
