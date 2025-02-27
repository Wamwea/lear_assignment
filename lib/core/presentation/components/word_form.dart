// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lear_assignment/core/logic/data_provider.dart';
import 'package:lear_assignment/core/models/word.dart';

class AddWordForm extends ConsumerStatefulWidget {
  final String userId;

  const AddWordForm({super.key, required this.userId});

  @override
  ConsumerState<AddWordForm> createState() => _AddWordFormState();
}

class _AddWordFormState extends ConsumerState<AddWordForm> {
  final _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _submitWord() async {
    if (!_formKey.currentState!.validate()) return;

    final newWord = Word(
      word: _textController.text.trim(),
      userID: widget.userId,
    );

    try {
      await ref.read(dataProvider.notifier).createWord(newWord);
      _textController.clear();

      // Dismiss the keyboard
      FocusScope.of(context).unfocus();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding word: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(dataProvider).isLoading;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _textController,
                decoration: const InputDecoration(
                  hintText: 'Enter a new word',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a word';
                  }
                  return null;
                },
                textInputAction: TextInputAction.done,
                onEditingComplete: _submitWord,
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: isLoading ? null : _submitWord,
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Add Word'),
            ),
          ],
        ),
      ),
    );
  }
}
