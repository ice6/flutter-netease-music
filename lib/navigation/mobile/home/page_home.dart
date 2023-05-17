import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../extension.dart';
import '../../../providers/settings_provider.dart';
import '../../common/navigation_target.dart';
import 'main_page_audiobook.dart';
import 'main_page_discover.dart';
import 'main_page_musiclibrary.dart';
import 'main_page_my.dart';
import 'main_page_publish.dart';

class PageHome extends ConsumerWidget {
  PageHome({super.key, required this.selectedTab})
      : assert(selectedTab.isMobileHomeTab());

  final NavigationTarget selectedTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Widget body;
    switch (selectedTab.runtimeType) {
      case NavigationTargetDiscover:
        body = const MainPageDiscover();
        break;
      case NavigationTargetMusicLibrary:
        body = const MainPageMusicLibraryWidget();
        break;
      case NavigationTargetPublish:
        body = const MainPagePublishWidget();
        break;
      case NavigationTargetAudioBook:
        body = const MainPageAudioBookWidget();
        break;
      case NavigationTargetMine:
        body = const MainPageMy();
        break;
      default:
        assert(false, 'unsupported tab: $selectedTab');
        body = const MainPageMy();
        break;
    }
    final isLight = ref.watch(
      settingStateProvider.select((value) => value.themeMode),
    ).isLight(context);

    return Scaffold(
      backgroundColor: context.colorScheme.backgroundSecondary,
      body: isLight ? DecoratedBox(decoration: BoxDecoration(
            gradient: LinearGradient(
              // Where the linear gradient begins and ends
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              // Add one stop for each color. Stops should increase from 0 to 1
              stops: const [0.1, 0.26, 0.36, 0.5],
              colors: [
                // Colors are easy thanks to Flutter's Colors class.
                Colors.purple[100]!,
                Colors.pink[50]!,
                Colors.white,
                Colors.white,
              ],
            ),
          ),
          child: body,
      ) : body,
    );
  }
}
