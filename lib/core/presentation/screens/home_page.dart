// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lear_assignment/core/logic/data_provider.dart';
import 'package:lear_assignment/core/presentation/components/word_form.dart';
import 'package:lear_assignment/core/presentation/components/word_list.dart';
import 'package:lear_assignment/core/routing/app_router.dart';
import 'package:lear_assignment/features/authentication/logic/auth_provider.dart';

@RoutePage()
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final wordsState = ref.watch(dataProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Lear Assignment'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authProvider.notifier).signOut();
              context.router.replaceAll([const AuthRoute()]);
            },
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Email: ${user?.email ?? 'User'}!',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Expanded(
            child: WordList(words: wordsState.words),
          ),
          AddWordForm(userId: user?.id ?? ''),
        ],
      ),
    );
  }
}
