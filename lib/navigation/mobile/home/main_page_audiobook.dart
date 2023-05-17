import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainPageAudioBookWidget extends ConsumerWidget
{
  const MainPageAudioBookWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('有声'),
      ),
      body: const Text('有声'),
    );
  }
}
