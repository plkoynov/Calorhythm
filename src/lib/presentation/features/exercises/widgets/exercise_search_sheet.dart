import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:calorhythm/domain/entities/exercise.dart';
import 'package:calorhythm/presentation/features/exercises/providers/exercises_provider.dart';
import 'exercise_tile.dart';

/// Bottom sheet that lets the user search all exercises by name and pick one.
/// Returns the selected [Exercise] via [Navigator.pop].
class ExerciseSearchSheet extends ConsumerStatefulWidget {
  const ExerciseSearchSheet({super.key});

  static Future<Exercise?> show(BuildContext context) =>
      showModalBottomSheet<Exercise>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (_) => const ExerciseSearchSheet(),
      );

  @override
  ConsumerState<ExerciseSearchSheet> createState() =>
      _ExerciseSearchSheetState();
}

class _ExerciseSearchSheetState extends ConsumerState<ExerciseSearchSheet> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resultsAsync = ref.watch(exerciseSearchProvider(_query));

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Column(
        children: [
          // Handle
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),

          // Search field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search exercises…',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          const SizedBox(height: 8),

          // Results
          Expanded(
            child: resultsAsync.when(
              data: (exercises) => exercises.isEmpty
                  ? const Center(child: Text('No exercises found.'))
                  : GridView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.1,
                      ),
                      itemCount: exercises.length,
                      itemBuilder: (context, index) => ExerciseTile(
                        exercise: exercises[index],
                        onTap: () =>
                            Navigator.of(context).pop(exercises[index]),
                      ),
                    ),
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
