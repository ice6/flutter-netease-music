import 'package:flutter/material.dart';

import '../../../extension.dart';
import '../../common/navigation_target.dart';
import 'main_page_audiobook.dart';
import 'main_page_discover.dart';
import 'main_page_musiclibrary.dart';
import 'main_page_my.dart';
import 'main_page_publish.dart';

class PageHome extends StatelessWidget {
  PageHome({super.key, required this.selectedTab})
      : assert(selectedTab.isMobileHomeTab());

  final NavigationTarget selectedTab;

  @override
  Widget build(BuildContext context) {
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
      case NavigationTargetLibrary:
        body = const MainPageMy();
        break;
      default:
        assert(false, 'unsupported tab: $selectedTab');
        body = const MainPageMy();
        break;
    }
    return Scaffold(
      backgroundColor: context.colorScheme.backgroundSecondary,
      body: body,
    );
  }
}
